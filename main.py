import logging
import os
import click

from instawow_manager import InstawowManager
from manage import Manager


class Context(object):

    def __init__(self):
        self.game_flavour = 'classic' if self.is_classic() else 'retail'
        self.manager = InstawowManager(self.game_flavour, False)
        self.manager_lib = InstawowManager(self.game_flavour, True)
        self.manager_lib_classic = InstawowManager('classic', True, True)

    def is_classic(self):
        return '_classic_' in os.getcwd()

    def manage(self):
        print('Modifying addons to fit each other...', end='')
        Manager().process()
        print('Done!')


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
    Manager().process_libs()


@main.command()
@click.argument('libs', required=True, nargs=-1)
@click.pass_obj
def install_lib_classic(obj, libs):
    """Install libraries"""
    if not obj.is_classic():
        raise RuntimeError('Cannot manage classic libs in retail game folder')
    obj.manager_lib_classic.install(libs)
    obj.manager_lib_classic.export()
    Manager().process_libs()


@main.command()
@click.pass_obj
def update(obj):
    """Update all addons"""
    obj.manager.update()
    obj.manager_lib.update()
    if obj.is_classic():
        obj.manager_lib_classic.update()
    obj.manage()


@main.command()
@click.argument('addons', required=True, nargs=-1)
@click.pass_obj
def remove(obj, addons):
    """Remove addons"""
    obj.manager.remove(addons)
    obj.manager.export()


@main.command()
@click.argument('libs', required=True, nargs=-1)
@click.pass_obj
def remove_lib(obj, libs):
    """Remove addons"""
    obj.manager_lib.remove(libs)
    obj.manager_lib.export()


@main.command()
@click.argument('libs', required=True, nargs=-1)
@click.pass_obj
def remove_lib_classic(obj, libs):
    """Install libraries"""
    if not obj.is_classic():
        raise RuntimeError('Cannot manage classic libs in retail game folder')
    obj.manager_lib_classic.remove(libs)
    obj.manager_lib_classic.export()


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


@main.command()
@click.pass_obj
def show_libs_classic(obj):
    """Install libraries"""
    if not obj.is_classic():
        raise RuntimeError('Cannot manage classic libs in retail game folder')
    obj.manager_lib_classic.show()


if __name__ == "__main__":
    main()  # pylint: disable=no-value-for-parameter
