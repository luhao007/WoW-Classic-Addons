import logging
import os
import sys

from instawow_manager import InstawowManager
from manage import Manager
from toc import process_toc


def help():
    print('Usage:')
    print('\tmanage\t\t\t\tUpdate addons')
    print('\tshow\t\t\t\tShow addons')


def update():
    game_flavour = 'classic' if '_classic_' in os.getcwd() else 'retail'
    for lib in [False, True]:
        InstawowManager(game_flavour, lib).update()

    print('Hanlding Tocs...', end='')
    Manager().process()
    print('Done!')

    process_toc('11304' if game_flavour == 'classic' else '80300')
    logging.info('Finished.')


def main():
    verbose = bool(set(['--verbose', '-v']) & set(sys.argv))
    if verbose:
        logging.basicConfig(level=logging.INFO)

    if len(sys.argv) == 1:
        help()
        return

    action = sys.argv[1]
    if action == 'update':
        update()
    elif action == 'show':
        game_flavour = 'classic' if '_classic_' in os.getcwd() else 'retail'
        InstawowManager(game_flavour).show()


if __name__ == '__main__':
    main()
