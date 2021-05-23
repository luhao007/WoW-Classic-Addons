import functools
import logging
import os
import re
import shutil
from pathlib import Path
from typing import Optional

from chardet.enums import LanguageFilter
from chardet.universaldetector import UniversalDetector

logger = logging.getLogger('process')


def process_file(path, func):
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

    lines = file_bytes.decode(encoding).splitlines()
    lines = [line.rstrip()+'\n' for line in lines]
    while lines[-1].strip() == '':
        lines = lines[:-1]
    new_lines = func(lines.copy())

    if new_lines != lines:
        with open(path, 'w', encoding='utf-8') as file:
            file.writelines(new_lines)

    logger.info('Done.')


def rm_tree(path):
    if os.path.exists(path):
        logger.info('Removing %s...', path)
        shutil.rmtree(path)


@functools.lru_cache
def get_platform():
    path = os.getcwd()
    while path:
        path, last = os.path.split(path)
        if last.startswith('_') and last.endswith('_'):
            return last[1:-1]


def remove_libs_in_file(path, libs):
    def process(lines):
        if str(path).endswith('.toc'):
            pattern = r'\s*(?i){}.*'
        else:
            pattern = r'\s*<((Script)|(Include))+ file\s*=\s*"(?i){}[\\\"\.].*'

        return [line for line in lines
                if not any(re.match(pattern.format(lib), line)
                            for lib in libs)]

    process_file(path, process)


def remove_libraries_all(addon, lib_path: Optional[str] = None):
    """Remove all embedded libraries."""
    if not lib_path:
        for lib in ['libs', 'lib']:
            path = Path('Addons') / addon / lib
            if os.path.exists(path):
                lib_path = lib
                break
        else:
            return

    rm_tree(Path('AddOns') / addon / lib_path)

    # Extra library that need to be removed
    libs = ['embeds.xml', 'Embeds.xml', 'libs.xml',
            'Libs.xml', 'LibDataBroker-1.1.lua']
    for lib in libs:
        path = Path('AddOns') / addon / lib
        if os.path.exists(path):
            os.remove(path)

    for lib in ['.xml', '.toc', '-Classic.toc', '-BCC.toc', '-Mainline.toc']:
        path = Path('AddOns') / addon
        path /= '{}{}'.format(addon.split('/')[-1], lib)
        if os.path.exists(str(path)):
            remove_libs_in_file(path, libs + [lib_path])


def remove_libraries(libs, root, xml_path):
    """Remove selected embedded libraries from root and xml."""
    for lib in libs:
        rm_tree(Path(root) / lib)

    process_file(
        xml_path,
        lambda lines: [line for line in lines
                        if not any(lib.lower()+'\\' in line.lower() for lib in libs)]
    )


def change_defaults(path, defaults):
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


def lib_to_toc(lib):
    root = Path('Addons/!!Libs')
    subdir = os.listdir(root / lib)
    if 'lib.xml' in subdir:
        return f'{lib}\\lib.xml\n'
    if f'{lib}.xml' in subdir:
        return f'{lib}\\{lib}.xml\n'
    if f'{lib}.lua' in subdir:
        return f'{lib}\\{lib}.lua\n'
    if lib in subdir:
        subsubdir = os.listdir(root / lib / lib)
        if f'{lib}.xml' in subsubdir:
            return f'{lib}\\{lib}\\{lib}.xml\n'
        if f'{lib}.lua' in subsubdir:
            return f'{lib}\\{lib}\\{lib}.lua\n'
    raise RuntimeError(f'{lib} not handled!')
