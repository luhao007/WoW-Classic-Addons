from collections.abc import Callable, Iterable
import functools
import logging
import os
import shutil
from pathlib import Path
from typing import Optional, Literal

from chardet.enums import LanguageFilter
from chardet.universaldetector import UniversalDetector

logger = logging.getLogger('process')

TOCS = ['.toc'] + [f'{s}{p}.toc' for s in ('-', '_') for p in ('Classic', 'BCC', 'WOTLKC', 'Mainline', 'TBC', 'Vanilla', 'Wrath', 'Cata')]

def process_file(path: str | Path,
                 func: Callable[[Iterable[str]], Iterable[str]]) -> None:
    """Helper function to process the files.

    :param str path: Path of the file.
    :param function func: A function with the input of lines of the file
                          and returns the output lines after processing.
    """
    logger.info('Processing %s...', path)

    with open(path, 'rb') as file:
        file_bytes = file.read()

    detector = UniversalDetector(LanguageFilter.CHINESE)
    detector.feed(file_bytes)
    encoding = detector.close()['encoding']
    if encoding is None:
        logger.warning('Could not detect encoding for %s, using utf-8.', path)
        encoding = 'utf-8'

    lines = file_bytes.decode(encoding).splitlines()
    lines = [line.rstrip()+'\n' for line in lines]
    while lines[-1].strip() == '':
        lines = lines[:-1]
    new_lines = func(lines.copy())

    if new_lines != lines:
        with open(path, 'w', encoding='utf-8') as file:
            file.writelines(new_lines)

    logger.info('Done.')


def rm_tree(path: str | Path):
    if os.path.exists(path):
        logger.info('Removing %s...', path)
        shutil.rmtree(path)


PLATFORM = Literal['retail', 'classic', 'classic_era']

@functools.lru_cache
def get_platform() -> PLATFORM:
    path = os.getcwd()
    while path:
        path, last = os.path.split(path)
        if last.startswith('_') and last.endswith('_'):
            return last[1:-1]

    return 'retail'


def remove_libs_in_file(path: str | Path, libs: Iterable[str]):
    def process(lines):
        return [line for line in lines
                if not any(f'{lib}\\'.lower() in line.lower() for lib in libs)]

    process_file(path, process)


@functools.lru_cache
def get_libraries_list() -> list[str]:
    root = Path('AddOns/!!Libs')
    paths = [root, root / 'Ace3', root / 'Ace3' / 'AceConfig-3.0', root / 'LibBabble']
    libs = sum([[lib for lib in os.listdir(path) if os.path.isdir(path / lib)] for path in paths], [])
    libs += ['HereBeDragons-2.0']       # Alternative name
    libs += ['LibUIDropDownMenu']       # We got an "!" mark in the lib name
    libs += ['LibTranslit']             # Alternative name
    return libs


def remove_libraries_all(addon: str, lib_path: Optional[str] = None):
    """Remove all duplicate embedded libraries."""
    if not lib_path:
        for lib in ['Libs', 'Lib', 'ExternalLibs']:
            path = Path('Addons') / addon / lib
            if os.path.exists(path):
                lib_path = lib
                break
        else:
            return

    libs = set(get_libraries_list()).intersection(os.listdir(Path('AddOns') / addon / lib_path))

    if not libs:
        return

    print(f'Removing {libs} in {addon}')

    for lib in libs:
        rm_tree(Path('AddOns') / addon / lib_path / lib)

    # Remove lib entry in root folder
    lib_files = [Path('AddOns') / addon / f"{addon.split('/')[-1]}{postfix}" for postfix in (['.xml'] + TOCS)]
    lib_files += [Path('Addons') / addon / file for file in ['embeds.xml', 'include.xml']]
    lib_files = [path for path in lib_files if os.path.exists(str(path))]
    for path in lib_files:
        remove_libs_in_file(path, [f'{lib_path}\\{lib}' for lib in libs])

    # Remove lib entry in lib folder
    xmls = ['Includes.xml', 'Libs.xml', 'load_libs.xml', 'main.xml', 'Manifest.xml', 'Files.xml', 'embeds.xml']
    lib_files = [Path('Addons') / addon / lib_path / lib_file for lib_file in xmls]
    lib_files = [path for path in lib_files if os.path.exists(str(path))]
    for path in lib_files:
        remove_libs_in_file(path, libs)


def remove_libraries(libs: Iterable[str], root: str, xml_path: str):
    """Remove selected embedded libraries from root and xml."""
    for lib in libs:
        rm_tree(Path(root) / lib)

    remove_libs_in_file(xml_path, libs)


def change_defaults(path: str, defaults: str | list[str]):
    defaults = [defaults] if isinstance(defaults, str) else defaults

    def handle(lines):
        ret = []
        for line in lines:
            for default in defaults:
                if line.startswith(default.split('= ')[0] + '= '):
                    ret.append(default+'\n')
                    break
            else:
                ret.append(line)
        return ret

    process_file(path, handle)


def lib_to_toc(lib: str) -> str:
    if lib == 'Krowi_WorldMapButtons':
        return 'Krowi_WorldMapButtons\\Krowi_WorldMapButtons-1.4.xml\n'
    root = Path('Addons/!!Libs')
    subdir = os.listdir(root / lib)
    for script in ['lib.xml', 'load.xml', f'{lib}.xml', f'{lib}.lua', 'Core.lua']:
        if script in subdir:
            return f'{lib}\\{script}\n'

    if lib in subdir:
        subdir = os.listdir(root / lib / lib)
        for script in [f'{lib}.xml', f'{lib}.lua']:
            if script in subdir:
                return f'{lib}\\{lib}\\{script}\n'

    raise RuntimeError(f'{lib} not handled!')
