import functools
import logging
import os
import shutil
from collections.abc import Callable, Iterable
from pathlib import Path
from typing import Literal, Optional

from chardet.enums import LanguageFilter
from chardet.universaldetector import UniversalDetector

TOCS = [".toc"] + [
    f"{s}{p}.toc"
    for s in ("-", "_")
    for p in (
        "Classic",
        "BCC",
        "WOTLKC",
        "Mainline",
        "TBC",
        "Vanilla",
        "Wrath",
        "Cata",
        "Mists",
    )
]


class Color:
    """ANSI color codes for terminal output."""

    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    BLUE = "\033[94m"
    MAGENTA = "\033[95m"
    CYAN = "\033[96m"
    WHITE = "\033[97m"
    RESET = "\033[0m"


@functools.lru_cache
def get_logger(name: str) -> logging.Logger:
    logger = logging.getLogger(name)
    if not logger.hasHandlers():
        handler = logging.StreamHandler()
        formatter = logging.Formatter(
            f"{Color.WHITE}%(asctime)s {Color.YELLOW}%(name)s"
            f" {Color.GREEN}%(levelname)s {Color.WHITE}- %(message)s"
        )
        handler.setFormatter(formatter)
        logger.addHandler(handler)
    return logger


def process_file(
    path: str | Path, func: Callable[[Iterable[str]], Iterable[str]]
) -> None:
    """Helper function to process the files.

    :param str path: Path of the file.
    :param function func: A function with the input of lines of the file
                          and returns the output lines after processing.
    """
    logger = get_logger("FileHandler")
    logger.debug(
        f"{Color.YELLOW}Processing {Color.GREEN}%s{Color.YELLOW}...{Color.RESET}", path
    )

    with open(path, "rb") as file:
        file_bytes = file.read()

    detector = UniversalDetector(LanguageFilter.CHINESE)
    detector.feed(file_bytes)
    encoding = detector.close()["encoding"]
    if encoding is None:
        logger.warning("Could not detect encoding for %s, using utf-8.", path)
        encoding = "utf-8"

    lines = file_bytes.decode(encoding).splitlines()
    lines = [line.rstrip() + "\n" for line in lines]
    while lines[-1].strip() == "":
        lines = lines[:-1]
    new_lines = func(lines.copy())

    if new_lines != lines:
        with open(path, "w", encoding="utf-8") as file:
            file.writelines(new_lines)

    logger.debug(f"{Color.YELLOW}Done.{Color.RESET}")


def remove(path: str | Path):
    logger = get_logger("FileHandler")
    if os.path.exists(path):
        logger.info(
            f"{Color.YELLOW}Removing {Color.GREEN}%s{Color.YELLOW}...{Color.RESET}",
            path,
        )
        if str(path).endswith(".lua"):
            os.remove(path)
        else:
            shutil.rmtree(path)


PLATFORM = Literal["retail", "classic", "classic_era"]


@functools.lru_cache
def get_platform() -> PLATFORM:
    path: str = os.getcwd()
    while path:
        path: str
        last: str
        path, last = os.path.split(path)
        if last.startswith("_") and last.endswith("_"):
            platform = last[1:-1]
            if platform in ("retail", "classic", "classic_era"):
                return platform
            else:
                raise RuntimeError(f"Unknown platform: {platform}")

    return "retail"


def remove_libs_in_file(path: str | Path, libs: Iterable[str]):
    def process(lines: Iterable[str]) -> Iterable[str]:
        return [
            line
            for line in lines
            if not any(
                f"{lib}".lower() in line.lower()
                or f'{lib.replace('\\', '/')}'.lower() in line.lower()
                for lib in libs
            )
        ]

    process_file(path, process)


@functools.lru_cache
def get_libraries_list() -> list[str]:
    root = Path("AddOns/!!Libs")
    paths = [root, root / "Ace3", root / "Ace3" / "AceConfig-3.0", root / "LibBabble"]
    libs: list[str] = []
    libs = sum(
        [
            [lib for lib in os.listdir(path) if os.path.isdir(path / lib)]
            for path in paths
        ],
        libs,
    )
    libs += [
        "HereBeDragons-2.0",  # Alternative name, with the version number
        "LibUIDropDownMenu",  # We got an "!" mark in the lib name
        "LibTranslit",  # Alternative name, witout version number
        "Krowi_WorldMapButtons",  # Alternative name, without version number
    ]

    # individual files
    libs += [
        "LibStub.lua",
        "CallbackHandler-1.0.lua",
        "LibDataBroker-1.1.lua",
        "LibSharedMedia-3.0.lua",
    ]
    return libs


def remove_libraries_all(addon: str, lib_path: Optional[str] = None):
    """Remove all duplicate embedded libraries."""
    if not lib_path:
        for lib in ["Libs", "Lib", "ExternalLibs"]:
            path = Path("Addons") / addon / lib
            if os.path.exists(path):
                lib_path = lib
                break
        else:
            return

    libs = set(get_libraries_list()).intersection(
        os.listdir(Path("AddOns") / addon / lib_path)
    )

    if not libs:
        return

    print(
        f"{Color.YELLOW}Removing {Color.CYAN}{libs} {Color.YELLOW}in"
        f" {Color.GREEN}{addon}"
    )

    for lib in libs:
        remove(Path("AddOns") / addon / lib_path / lib)

    # Remove lib entry in root folder
    lib_files = [
        Path("AddOns") / addon / f"{addon.split('/')[-1]}{postfix}"
        for postfix in ([".xml"] + TOCS)
    ]
    lib_files += [
        Path("Addons") / addon / file for file in ["embeds.xml", "include.xml"]
    ]
    lib_files = [path for path in lib_files if os.path.exists(str(path))]
    for path in lib_files:
        remove_libs_in_file(path, [f"{lib_path}\\{lib}" for lib in libs])

    # Remove lib entry in lib folder
    xmls = [
        "Includes.xml",
        "Libs.xml",
        "ExternalLibs.xml",
        "load_libs.xml",
        "lib.xml",
        "lib_wrath.xml",
        "main.xml",
        "Manifest.xml",
        "Files.xml",
        "embeds.xml",
    ]
    lib_files = [Path("Addons") / addon / lib_path / lib_file for lib_file in xmls]
    lib_files = [path for path in lib_files if os.path.exists(str(path))]
    for path in lib_files:
        remove_libs_in_file(path, libs)


def remove_libraries(libs: Iterable[str], root: str, xml_path: str):
    """Remove selected embedded libraries from root and xml."""
    for lib in libs:
        remove(Path(root) / lib)

    remove_libs_in_file(xml_path, libs)


def change_defaults(path: str, defaults: str | Iterable[str]):
    defaults = [defaults] if isinstance(defaults, str) else defaults

    def handle(lines: Iterable[str]) -> Iterable[str]:
        ret: list[str] = []
        for line in lines:
            for default in defaults:
                if line.startswith(default.split("= ")[0] + "= "):
                    ret.append(default + "\n")
                    break
            else:
                ret.append(line)
        return ret

    process_file(path, handle)


def lib_to_toc(lib: str) -> str:
    if lib == "Krowi_WorldMapButtons":
        return "Krowi_WorldMapButtons\\Krowi_WorldMapButtons-1.4.xml\n"
    root = Path("Addons/!!Libs")
    subdir = os.listdir(root / lib)
    for script in ["lib.xml", "load.xml", f"{lib}.xml", f"{lib}.lua", "Core.lua"]:
        if script in subdir:
            return f"{lib}\\{script}\n"

    if lib in subdir:
        subdir = os.listdir(root / lib / lib)
        for script in [f"{lib}.xml", f"{lib}.lua"]:
            if script in subdir:
                return f"{lib}\\{lib}\\{script}\n"

    raise RuntimeError(f"{lib} not handled!")
