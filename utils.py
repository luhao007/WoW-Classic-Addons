import logging
import os
import shutil

import chardet

logger = logging.getLogger('process')


def process_file(path, func):
    """Helper function to process the files.

    :param str path: Path of the file.
    :param function func: A function with the input of lines of the file
                          and returns the output lines after processing.
    """
    logger.info('Processing %s...', path)

    with open(path, 'rb') as f:
        detect = chardet.detect(f.read())

    with open(path, 'r', encoding=detect['encoding']) as f:
        lines = f.readlines()

    new_lines = func(lines)

    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)

    logger.info('Done.')


def rm_tree(path):
    if os.path.exists(path):
        logger.info('Removing %s...', path)
        shutil.rmtree(path)
