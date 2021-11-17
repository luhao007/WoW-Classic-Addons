import json
import os
from pathlib import Path

import instawow.cli
import instawow.db
from instawow.config import Config, setup_logging
from instawow.models import Pkg, PkgList
from instawow.resolvers import Defn
from instawow.results import PkgUpToDate
from instawow.manager import Manager

import sqlalchemy


class InstawowManager:

    def __init__(self, game_flavour: str, lib: bool = False):
        """Interface between instawow and main program.

        :param game_flavor str: 'classic' or 'retail' or 'vanilla_classic'
        :param lib bool: Whether hanlding libraries.
        :param lib classic_only_lib: Whether hanlding classic-only libs
        """
        self.profile = game_flavour + ('_lib' if lib else '')

        addon_dir = Path(os.getcwd()) / 'Addons/'
        if lib:
            addon_dir /= '!!Libs'
        config = Config(addon_dir=addon_dir, game_flavour=game_flavour, profile=self.profile)
        config.write()

        setup_logging(config)
        instawow.cli._apply_patches()

        self.manager = Manager.from_config(config)

    def get_addons(self):
        query = self.manager.database.execute(
            sqlalchemy.select(instawow.db.pkg)
            .order_by(instawow.db.pkg.c.source, instawow.db.pkg.c.name)
        )
        if not query:
            return []

        return [Pkg.from_row_mapping(self.manager.database, p) for p in query.mappings().all()]

    def to_defn(self, addon: str, strategy: str = None) -> Defn:
        pair = self.manager.pair_uri(addon) or ('*', addon)
        ret = Defn(*pair)
        if strategy:
            ret = ret.with_(strategy=strategy)
        return ret

    def to_defns(self, addons: str | list[str] | list[tuple]) -> list[Defn]:
        if isinstance(addons, str):
            return [self.to_defn(addons)]

        return [self.to_defn(addon) if isinstance(addon, str) else self.to_defn(*addon) for addon in addons]

    def update(self):
        addons = [Defn.from_pkg(p) for p in self.get_addons()]
        results = instawow.cli.run_with_progress(self.manager.update(addons, False))
        report = instawow.cli.Report(results.items(),
                                     lambda r: not isinstance(r, PkgUpToDate))
        if str(report):
            print(report)
        else:
            print(f'All {self.profile} addons are up-to-date!')

    def install(self, addons: str | list[str], reinstall=False, strategy=None):
        defns = self.to_defns(addons)

        if '_lib' in self.profile:
            defns = [d.with_(strategy='any_flavour' if d.source == 'curse' else 'default') for d in defns]
        elif strategy:
            defns = [d.with_(strategy=strategy) for d in defns]

        if reinstall:
            results = instawow.cli.run_with_progress(self.manager.remove(defns, False))
            print(instawow.cli.Report(results.items()))
        results = instawow.cli.run_with_progress(self.manager.install(defns, replace=False))
        print(instawow.cli.Report(results.items()))

    def remove(self, addons: str | list[str]):
        defns = self.to_defns(addons)

        results = instawow.cli.run_with_progress(self.manager.remove(defns, False))
        print(instawow.cli.Report(results.items()))

    def show(self):
        for addon in self.get_addons():
            print(f'{addon.name}: {addon.version}')

    def export(self):
        with open(f'{self.profile}.json', 'w', encoding='utf-8') as file:
            file.write(PkgList.parse_obj(self.get_addons()).json(indent=2))

    def reinstall(self, filename: str):
        with open(filename, 'rb') as file:
            addons = json.loads(file.read())
        addons = [(f"{a['source']}:{a['slug']}", a['options']['strategy']) for a in addons]
        addons = [self.to_defn(addon, strategy) for addon, strategy in addons]
        results = instawow.cli.run_with_progress(self.manager.install(addons, replace=True))
        print(instawow.cli.Report(results.items()))
