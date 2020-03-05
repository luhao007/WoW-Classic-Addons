import chardet


def process_file(path, func, verbose):
    """Helper function to process the files.

    :param str path: Path of the file.
    :param function func: A function with the input of lines of the file and returns the output lines after processing.
    """
    if verbose:
        print('Processing {}...'.format(path), end='')

    with open(path, 'rb') as f:
        detect = chardet.detect(f.read())

    with open(path, 'r', encoding=detect['encoding']) as f:
        lines = f.readlines()

    new_lines = func(lines)

    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)

    if verbose:
        print('Done.')