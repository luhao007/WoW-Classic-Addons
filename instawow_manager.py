import os
from pathlib import Path

import instawow.cli
from instawow.config import Config
from instawow.models import Pkg
from instawow.exceptions import PkgUpToDate
from instawow.resolvers import Defn, MultiPkgModel


class InstawowManager:

    def __init__(self, ctx, game_flavour, lib=False, classic_only_lib=False):
        """Interface between instawow and main program.

        :param game_flavor str: 'classic' or 'retail'
        :param lib bool: Whether hanlding libraries.
        :param lib classic_only_lib: Whether hanlding classic-only libs
        """
        self.profile = game_flavour + ('_lib' if lib else '')
        if classic_only_lib:
            self.profile += '_classic_only'
        ctx.params['profile'] = self.profile

        addon_dir = Path(os.getcwd()) / 'Addons/'
        if lib:
            addon_dir /= '!!Libs'
            if classic_only_lib:
                game_flavour = 'classic'
            else:
                game_flavour = 'retail'
        config = Config(addon_dir=addon_dir, game_flavour=game_flavour)
        config.write()

        self.manager = instawow.cli.ManagerWrapper(ctx).m

    def get_addons(self):
        query = self.manager.database.query(Pkg)
        return query.order_by(Pkg.source, Pkg.name).all()

    def reinstall(self):
        addons = instawow.cli.parse_into_defn_from_json_file(
            self.manager,
            f'{self.profile}.json'
        )

        results = self.manager.run(self.manager.install(addons, replace=False))
        print(instawow.cli.Report(results))

    def update(self):
        addons = [Defn.from_pkg(p) for p in self.get_addons()]
        results = self.manager.run(self.manager.update(addons, False))
        report = instawow.cli.Report(results.items(),
                                     lambda r: not isinstance(r, PkgUpToDate))
        if str(report):
            print(report)
        else:
            print('All {} addons are up-to-date!'.format(self.profile))

    def install(self, addons):
        addons = instawow.cli.parse_into_defn(self.manager, addons)
        results = self.manager.run(self.manager.install(addons, replace=False))
        print(instawow.cli.Report(results.items()))

    def remove(self, addons):
        addons = instawow.cli.parse_into_defn(self.manager, addons)
        results = self.manager.run(self.manager.remove(addons))
        print(instawow.cli.Report(results.items()))

    def show(self):
        for addon in self.get_addons():
            print('{}: {}'.format(addon.name, addon.version))

    def export(self):
        with open(f'{self.profile}.json', 'w') as f:
            f.write(MultiPkgModel.parse_obj(self.get_addons()).json(indent=2))
