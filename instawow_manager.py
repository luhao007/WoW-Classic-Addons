import os
from pathlib import Path

import click
import instawow.cli
from instawow.config import Config
from instawow.models import Pkg
from instawow.exceptions import PkgUpToDate


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

    def get_addons(self):
        query = self.manager.db_session.query(Pkg)
        return query.order_by(Pkg.source, Pkg.name).all()

    def reinstall(self):
        addons = instawow.cli.import_from_csv(self.manager,
                                              '{}.csv'.format(self.config))

        results = self.manager.run(self.manager.install(addons, replace=False))
        print(instawow.cli.Report(results))

    def update(self):
        addons = [p.to_defn() for p in self.get_addons()]
        results = self.manager.run(self.manager.update(addons))
        report = instawow.cli.Report(results,
                                     lambda r: not isinstance(r, PkgUpToDate))
        if str(report):
            print(report)
        else:
            print('All {} addons are up-to-date!'.format(self.config))

    def install(self, addons):
        addons = instawow.cli.parse_into_defn(self.manager, addons)
        results = self.manager.run(self.manager.install(addons, replace=False))
        print(instawow.cli.Report(results))

    def remove(self, addons):
        addons = instawow.cli.parse_into_defn(self.manager, addons)
        results = self.manager.run(self.manager.remove(addons))
        print(instawow.cli.Report(results))

    def show(self):
        for addon in self.get_addons():
            print('{}: {}'.format(addon.name, addon.version))

    def export(self):
        instawow.cli.export_to_csv(self.get_addons(),
                                   '{}.csv'.format(self.config))
