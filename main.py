import logging
import os
import click

from instawow_manager import InstawowManager
from manage import Manager
from toc import process_toc


class Context(object):

    def __init__(self):
        if '_classic_' in os.getcwd():
            self.game_flavour = 'classic'
        else:
            self.game_flavour = 'retail'
        self.manager = InstawowManager(self.game_flavour, False)
        self.manager_lib = InstawowManager(self.game_flavour, True)

    def manage(self):
        print('Modifying addons to fit each other...', end='')
        Manager().process()
        print('Done!')

        process_toc('11304' if self.game_flavour == 'classic' else '80300')
        logging.info('Finished.')


@click.group(context_settings={'help_option_names': ('-h', '--help')})
@click.option('--verbose', '-v', help='Show more logs',
              is_flag=True, default=False)
@click.pass_context
def main(ctx, verbose):
    """luhao007's Addon Manager."""
    if verbose:
        logging.basicConfig(level=logging.INFO)
    ctx.obj = Context()


@main.command()
@click.pass_obj
def manage(obj):
    """Manage addons"""
    obj.manage()


@main.command()
@click.argument('addons', required=True, nargs=-1)
@click.pass_obj
def install(obj, addons):
    """Install addons"""
    obj.manager.install(addons)
    obj.manager.export()
    obj.manage()


@main.command()
@click.argument('libs', required=True, nargs=-1)
@click.pass_obj
def install_lib(obj, libs):
    """Install libraries"""
    obj.manager_lib.install(libs)
    obj.manager_lib.export()
    Manager().handle_libs()


@main.command()
@click.pass_obj
def update(obj):
    """Update all addons"""
    obj.manager.update()
    obj.manager_lib.update()
    obj.manage()


@main.command()
@click.argument('addons', required=True, nargs=-1)
@click.pass_obj
def remove(obj, addons):
    """Remove addons"""
    obj.manager.remove(addons)
    obj.manager.export()


@main.command()
@click.pass_obj
def show(obj):
    """Show all addons"""
    obj.manager.show()


@main.command()
@click.pass_obj
def show_libs(obj):
    """Show all libraries"""
    obj.manager_lib.show()


if __name__ == "__main__":
    main()  # pylint: disable=no-value-for-parameter
