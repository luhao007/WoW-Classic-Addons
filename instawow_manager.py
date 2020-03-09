import os
from pathlib import Path

import click
import instawow.cli
from instawow.config import Config


class InstawowManager(object):

    def __init__(self, game_flavour, lib=False):
        self.config = game_flavour + ('_lib' if lib else '')
        config_root = Path(click.get_app_dir('instawow')) / self.config
        os.environ['INSTAWOW_CONFIG_DIR'] = str(config_root)

        addon_dir = Path(os.getcwd()) / 'Addons/'
        if lib:
            addon_dir /= '!!Libs'
            game_flavour = 'retail'
        config = Config(addon_dir=addon_dir, game_flavour=game_flavour)
        config.write()

        self.manager = instawow.cli.ManagerWrapper(debug=False).m

    def reinstall(self):
        addons = instawow.cli.import_from_csv(self.manager,
                                              '{}.csv'.format(self.config))

        results = self.manager.run(self.manager.install(addons, replace=False))
        print(instawow.cli.Report(results))

    def update(self):
        results = self.manager.run(self.manager.update([]))
        if results:
            print(instawow.cli.Report(results))
        else:
            print('All {} addons are up-to-date!'.format(self.config))

    def show(self):
        os.system('instawow list')

    def reconcile(self):
        os.system('instawow reconcile')

    def export(self):
        os.system('instawow list -e {}.csv'.format(self.config))
