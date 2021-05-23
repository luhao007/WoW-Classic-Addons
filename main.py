import logging
import click

from instawow_manager import InstawowManager
from manage import Manager
import utils


class Context:

    def __init__(self, ctx, verbose: bool):
        """Basic content for CLI."""
        ctx.params['log_level'] = verbose
        platform = utils.get_platform()
        self.game_flavour = 'vanilla_classic' if platform == 'classic_era' else platform
        self.manager = InstawowManager(self.game_flavour, False)
        self.manager_lib = InstawowManager(self.game_flavour, True)


def _manage():
    print('Modifying addons to fit each other...')
    Manager().process()
    Manager().process_libs()
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
@click.option('--strategy', '-s', help='Specify a strategy')
@click.pass_obj
def install(obj, addons, strategy=None):
    """Install addons."""
    if strategy:
        strategy = strategy.replace('=', '').strip()
    obj.manager.install(addons, strategy)
    obj.manager.export()
    _manage()


@main.command()
@click.argument('file', required=True)
@click.pass_obj
def reinstall(obj, file):
    """Reinstall addons."""
    obj.manager.reinstall(file)
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
@click.argument('file', required=True)
@click.pass_obj
def reinstall_libs(obj, file):
    """Reinstall libs."""
    obj.manager_lib.reinstall(file)
    _manage()


@main.command()
@click.pass_obj
def update(obj):
    """Update all addons."""
    obj.manager.update()
    obj.manager_lib.update()
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


if __name__ == "__main__":
    main()  # pylint:disable=no-value-for-parameter
