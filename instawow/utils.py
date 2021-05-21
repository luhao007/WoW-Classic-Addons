from __future__ import annotations

import asyncio
from collections import defaultdict
from collections.abc import Awaitable, Callable, Iterable, Iterator, Mapping, Sequence
from contextlib import contextmanager
from datetime import datetime, timedelta
from functools import partial, wraps
from itertools import chain, repeat, takewhile
import os
from pathlib import Path, PurePath
import posixpath
from shutil import move as _move
from tempfile import mkdtemp
from typing import Generic, TypeVar, overload

from typing_extensions import TypeAlias

from . import _deferred_types

_T = TypeVar('_T')
_U = TypeVar('_U')
_StrPath: TypeAlias = 'os.PathLike[str] | str'


class TocReader:
    """Extracts key–value pairs from TOC files."""

    def __init__(self, contents: str) -> None:
        self.entries = {
            k: v
            for e in contents.splitlines()
            if e.startswith('##')
            for k, v in (map(str.strip, e.lstrip('#').partition(':')[::2]),)
            if k
        }

    def __getitem__(self, key: str | tuple[str, ...]) -> str | None:
        if isinstance(key, tuple):
            return next(filter(None, map(self.entries.get, key)), None)
        else:
            return self.entries.get(key)

    @classmethod
    def from_addon_path(cls, path: Path, suffix: str = '.toc') -> TocReader:
        return cls((path / (path.name + suffix)).read_text(encoding='utf-8-sig', errors='replace'))


class cached_property(Generic[_T, _U]):
    def __init__(self, f: Callable[[_T], _U]) -> None:
        self.f = f

    @overload
    def __get__(self, o: None, t: type[_T] | None = ...) -> cached_property[_T, _U]:
        ...

    @overload
    def __get__(self, o: _T, t: type[_T] | None = ...) -> _U:
        ...

    def __get__(self, o: _T | None, t: type[_T] | None = None) -> cached_property[_T, _U] | _U:
        if o is None:
            return self
        else:
            o.__dict__[self.f.__name__] = v = self.f(o)
            return v


def bucketise(iterable: Iterable[_U], key: Callable[[_U], _T]) -> defaultdict[_T, list[_U]]:
    "Place the elements of an iterable in a bucket according to ``key``."
    bucket: defaultdict[_T, list[_U]] = defaultdict(list)
    for value in iterable:
        bucket[key(value)].append(value)
    return bucket


def chain_dict(
    keys: Iterable[_T], default: _U, *overrides: Iterable[tuple[_T, _U]]
) -> dict[_T, _U]:
    "Construct a dictionary from a series of two-tuple iterables with overlapping keys."
    return dict(chain(zip(keys, repeat(default)), *overrides))


def uniq(it: Iterable[_T]) -> list[_T]:
    "Deduplicate hashable items in an iterable maintaining insertion order."
    return list(dict.fromkeys(it))


def merge_intersecting_sets(it: Iterable[frozenset[_T]]) -> Iterator[frozenset[_T]]:
    "Recursively merge intersecting sets in a collection."
    many_sets = list(it)
    while many_sets:
        this_set = many_sets.pop(0)
        while True:
            for idx, other_set in enumerate(many_sets):
                if not this_set.isdisjoint(other_set):
                    this_set |= many_sets.pop(idx)
                    break
            else:
                break
        yield this_set


@overload
async def gather(it: Iterable[Awaitable[_U]], wrapper: None = ...) -> list[_U]:
    ...


@overload
async def gather(
    it: Iterable[Awaitable[_U]],
    wrapper: Callable[[Awaitable[_U]], Awaitable[_T]] = ...,
) -> list[_T]:
    ...


async def gather(
    it: Iterable[Awaitable[object]], wrapper: Callable[..., Awaitable[object]] | None = None
) -> Sequence[object]:
    if wrapper is not None:
        it = map(wrapper, it)
    return await asyncio.gather(*it)


@overload
def run_in_thread(
    fn: type[list[object]],
) -> Callable[[Iterable[_U]], Awaitable[list[_U]]]:
    ...


@overload
def run_in_thread(fn: Callable[..., _U]) -> Callable[..., Awaitable[_U]]:
    ...


def run_in_thread(fn: Callable[..., object]) -> Callable[..., Awaitable[object]]:
    @wraps(fn)
    def wrapper(*args: object, **kwargs: object):
        loop = asyncio.get_running_loop()
        return loop.run_in_executor(None, partial(fn, *args, **kwargs))

    return wrapper


@contextmanager
def copy_resources(*packages: str) -> Iterator[Path]:
    """Copy package resources to a temporary directory on disk.

    Alembic cannot construct a migration environment from memory.
    This is a genericised bodge to make migrations work in a frozen instawow.
    """
    from importlib.resources import contents, is_resource, read_binary
    from tempfile import TemporaryDirectory

    with TemporaryDirectory() as tmp_dir:
        tmp_path = Path(tmp_dir)

        for package in packages:
            for resource in filter(partial(is_resource, package), contents(package)):
                parent_dir = tmp_path.joinpath(*package.split('.'))
                if not parent_dir.is_dir():
                    parent_dir.mkdir(parents=True)

                filename = parent_dir / resource
                # PyOxidizer does not expose Python source files to `importlib`
                # (see https://github.com/indygreg/PyOxidizer/issues/237).
                # The filenames of Python files have a secondary ".0" extension
                # so that PyOx will regard them as binary resources.
                # The extension is then removed when they're copied into
                # the temporary folder
                if filename.suffix == '.0':
                    filename = filename.with_suffix('')
                filename.write_bytes(read_binary(package, resource))
        yield tmp_path


def tabulate(rows: Sequence[Sequence[object]], *, max_col_width: int = 60) -> str:
    "Produce an ASCII table from equal-length elements in a sequence."
    from textwrap import fill

    def apply_max_col_width(value: object):
        return fill(str(value), width=max_col_width, max_lines=1)

    def calc_resultant_col_widths(rows: Sequence[Sequence[str]]):
        cols = zip(*rows)
        return [max(map(len, c)) for c in cols]

    rows = [tuple(map(apply_max_col_width, r)) for r in rows]
    head, *tail = rows

    base_template = '  '.join(f'{{{{{{0}}{w}}}}}' for w in calc_resultant_col_widths(rows))
    row_template = base_template.format(':<')
    table = '\n'.join(
        (
            base_template.format(':^').format(*head),
            base_template.format(f'0:-<').format(''),
            *(row_template.format(*r) for r in tail),
        )
    )
    return table


def make_progress_bar(**kwargs: object) -> _deferred_types.prompt_toolkit.shortcuts.ProgressBar:
    "A ``ProgressBar`` with download progress expressed in megabytes."
    from prompt_toolkit.formatted_text import HTML
    from prompt_toolkit.shortcuts.progress_bar import formatters
    from prompt_toolkit.shortcuts.progress_bar.base import ProgressBar, ProgressBarCounter

    class DownloadProgress(formatters.Progress):
        template = '<current>{current:>3}</current>/<total>{total:>3}</total>MB'

        def format(
            self, progress_bar: ProgressBar, progress: ProgressBarCounter[object], width: int
        ):
            def format_pct(value: int):
                return f'{value / 2 ** 20:.1f}'

            return HTML(self.template).format(
                current=format_pct(progress.items_completed),
                total=format_pct(progress.total) if progress.total else '?',
            )

    progress_bar = ProgressBar(
        formatters=[
            formatters.Label(),
            formatters.Text(' '),
            formatters.Percentage(),
            formatters.Text(' '),
            formatters.Bar(),
            formatters.Text(' '),
            DownloadProgress(),
            formatters.Text(' '),
            formatters.Text('eta [', style='class:time-left'),
            formatters.TimeLeft(),
            formatters.Text(']', style='class:time-left'),
            formatters.Text(' '),
        ],
        **kwargs,
    )
    return progress_bar


def move(src: _StrPath, dest: _StrPath) -> _StrPath:
    return _move(
        str(src),  # See https://bugs.python.org/issue32689
        dest,
    )


def trash(paths: Sequence[PurePath], *, dest: PurePath, missing_ok: bool = False) -> None:
    if not paths:
        return

    parent_folder = mkdtemp(dir=dest, prefix=f'deleted-{paths[0].name}-')
    for path in paths:
        try:
            move(path, dest=parent_folder)
        except (FileNotFoundError if missing_ok else ()):
            pass


def shasum(*values: object) -> str:
    "Base-16-encode a string using SHA-256 truncated to 32 characters."
    from hashlib import sha256

    return sha256(''.join(map(str, values)).encode()).hexdigest()[:32]


def is_not_stale(path: Path, ttl: Mapping[str, float]) -> bool:
    "Check if a file is older than ``ttl``."
    return path.exists() and (
        (datetime.now() - datetime.fromtimestamp(path.stat().st_mtime)) < timedelta(**ttl)
    )


async def is_outdated() -> tuple[bool, str]:
    """Check on PyPI to see if the installed copy of instawow is outdated.

    The response is cached for 24 hours.
    """
    from aiohttp.client import ClientError

    from . import __version__
    from .config import Config
    from .manager import init_web_client

    def parse_version(version: str) -> tuple[int, ...]:
        version_numbers = version.split('.')[:3]
        int_only_version_numbers = (
            int(''.join(takewhile('0123456789'.__contains__, e))) for e in version_numbers
        )
        return tuple(int_only_version_numbers)

    if 'dev' in __version__:
        return (False, '')

    dummy_config = Config.get_dummy_config()
    if not dummy_config.auto_update_check:
        return (False, '')

    cache_file = dummy_config.temp_dir / '.pypi_version'
    if await run_in_thread(is_not_stale)(cache_file, {'days': 1}):
        version = cache_file.read_text(encoding='utf-8')
    else:
        try:
            async with init_web_client(raise_for_status=True) as web_client, web_client.get(
                'https://pypi.org/pypi/instawow/json'
            ) as response:
                version = (await response.json())['info']['version']
        except ClientError:
            version = __version__
        else:
            cache_file.write_text(version, encoding='utf-8')

    return (parse_version(version) > parse_version(__version__), version)


def find_zip_base_dirs(names: Sequence[str]) -> set[str]:
    "Find top-level folders in a list of ZIP member paths."
    return {n for n in (posixpath.dirname(n) for n in names) if n and posixpath.sep not in n}


def make_zip_member_filter(base_dirs: set[str]) -> Callable[[str], bool]:
    """Filter out items which are not sub-paths of top-level folders for the
    purpose of extracting ZIP files.
    """

    def is_subpath(name: str):
        head, sep, _ = name.partition(posixpath.sep)
        return head in base_dirs if sep else False

    return is_subpath


def file_uri_to_path(file_uri: str) -> str:
    "Convert a file URI to a path that works both on Windows and *nix."
    from urllib.parse import unquote

    unprefixed_path = unquote(file_uri[7:])  # len('file://')
    # A slash is prepended to the path even when there isn't one there
    # on Windows.  The ``PurePath`` instance will inherit from either
    # ``PurePosixPath`` or ``PureWindowsPath``; this will be a no-op on POSIX.
    if PurePath(unprefixed_path[1:]).drive:
        unprefixed_path = unprefixed_path[1:]
    return unprefixed_path
