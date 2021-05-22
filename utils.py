import logging
import os
import shutil

from chardet.universaldetector import UniversalDetector
from chardet.enums import LanguageFilter

logger = logging.getLogger('process')


def process_file(path, func):
    """Helper function to process the files.

    :param str path: Path of the file.
    :param function func: A function with the input of lines of the file
                          and returns the output lines after processing.
    """
    logger.info('Processing %s...', path)

    with open(path, 'rb') as f:
        b = f.read()

    detector = UniversalDetector(LanguageFilter.CHINESE)
    detector.feed(b)
    encoding = detector.close()['encoding']

    lines = b.decode(encoding).splitlines()
    lines = [line.rstrip()+'\n' for line in lines]
    while lines[-1].strip() == '':
        lines = lines[:-1]
    new_lines = func(lines.copy())

    if new_lines != lines:
        with open(path, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)

    logger.info('Done.')


def rm_tree(path):
    if os.path.exists(path):
        logger.info('Removing %s...', path)
        shutil.rmtree(path)


def get_platform():
    path = os.getcwd()
    while path:
        path, last = os.path.split(path)
        if last.startswith('_'):
            return last[1:-1]