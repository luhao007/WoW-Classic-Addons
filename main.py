import logging
import os
import click

from instawow_manager import InstawowManager
from manage import Manager


class Context:

    def __init__(self, ctx, verbose: bool):
        """Basic content for CLI."""
        ctx.params['log_level'] = verbose
        self.game_flavour = 'classic' if self.is_classic else 'retail'
        self.manager = InstawowManager(ctx, self.game_flavour, False)
        self.manager_lib = InstawowManager(ctx, self.game_flavour, True)
        self.manager_lib_classic = InstawowManager(ctx, 'classic', True, True)

    @property
    def is_classic(self):
        return '_classic_' in os.getcwd()


def _manage():
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
    ctx.obj = Context(ctx, verbose=verbose)


@main.command()
def manage():
    """Manage addons."""
    _manage()


@main.command()
@click.argument('addons', required=True, nargs=-1)
@click.pass_obj
def install(obj, addons):
    """Install addons."""
    obj.manager.install(addons)
    obj.manager.export()
    _manage()


@main.command()
@click.argument('libs', required=True, nargs=-1)
@click.pass_obj
def install_lib(obj, libs):
    """Install libraries."""
    obj.manager_lib.install(libs)
    obj.manager_lib.export()
    Manager().process_libs()


@main.command()
@click.argument('libs', required=True, nargs=-1)
@click.pass_obj
def install_lib_classic(obj, libs):
    """Install libraries."""
    if not obj.is_classic:
        raise RuntimeError('Cannot manage classic libs in retail game folder')
    obj.manager_lib_classic.install(libs)
    obj.manager_lib_classic.export()
    Manager().process_libs()


@main.command()
@click.pass_obj
def reinstall(obj):
    obj.manager.reinstall()
    obj.manager_lib.reinstall()
    if obj.is_classic:
        obj.manager_lib_classic.reinstall()
    _manage()


@main.command()
@click.pass_obj
def update(obj):
    """Update all addons."""
    obj.manager.update()
    obj.manager_lib.update()
    if obj.is_classic:
        obj.manager_lib_classic.update()
    _manage()


@main.command()
@click.argument('addons', required=True, nargs=-1)
@click.pass_obj
def remove(obj, addons):
    """Remove addons."""
    obj.manager.remove(addons)
    obj.manager.export()


@main.command()
@click.argument('libs', required=True, nargs=-1)
@click.pass_obj
def remove_lib(obj, libs):
    """Remove addons."""
    obj.manager_lib.remove(libs)
    obj.manager_lib.export()


@main.command()
@click.argument('libs', required=True, nargs=-1)
@click.pass_obj
def remove_lib_classic(obj, libs):
    """Install libraries."""
    if not obj.is_classic:
        raise RuntimeError('Cannot manage classic libs in retail game folder')
    obj.manager_lib_classic.remove(libs)
    obj.manager_lib_classic.export()


@main.command()
@click.pass_obj
def show(obj):
    """Show all addons."""
    obj.manager.show()
    obj.manager.export()


@main.command()
@click.pass_obj
def show_libs(obj):
    """Show all libraries."""
    obj.manager_lib.show()
    obj.manager_lib.export()


@main.command()
@click.pass_obj
def show_libs_classic(obj):
    """Install libraries."""
    if not obj.is_classic:
        raise RuntimeError('Cannot manage classic libs in retail game folder')
    obj.manager_lib_classic.show()
    obj.manager_lib_classic.export()


if __name__ == "__main__":
    main()  # pylint: disable=no-value-for-parameter
