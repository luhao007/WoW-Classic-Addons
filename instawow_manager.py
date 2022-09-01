import asyncio
import json
import os
import typing
from pathlib import Path

import instawow.cli
import instawow.db
import sqlalchemy
from attrs import asdict, evolve
from instawow.common import Flavour
from instawow.db import prepare_database
from instawow.config import (Config, GlobalConfig, config_converter,
                             setup_logging)
from instawow.manager import Manager, contextualise, DB_REVISION
from instawow.models import Pkg, pkg_converter
from instawow.resolvers import Defn
from instawow.results import PkgUpToDate


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
        values = asdict(GlobalConfig.read())
        if not values['access_tokens']['cfcore']:
            token = input('CfCore Access Token:')
            if token:
                values['access_tokens']['cfcore'] = token
        global_config = config_converter.structure(values, GlobalConfig)
        global_config.write()
        config = Config(global_config = global_config, addon_dir=addon_dir, game_flavour=Flavour(game_flavour), profile=self.profile)
        config.write()

        setup_logging(config.logging_dir, debug=False)
        instawow.cli._apply_patches()

        self.conn = prepare_database(config.db_uri, DB_REVISION).connect()
        self.manager = Manager(config, self.conn)

    def run(self, awaitable):
        from instawow.prompts import make_progress_bar

        async def run():
            with make_progress_bar() as progress_bar, instawow.cli._cancel_tickers(progress_bar) as tickers:
                async with instawow.cli._init_cli_web_client(progress_bar, tickers) as web_client:
                    contextualise(web_client=web_client)
                    return await awaitable

        return asyncio.run(run())

    def get_addons(self):
        query = self.manager.database.execute(
            sqlalchemy.select(instawow.db.pkg)
            .order_by(instawow.db.pkg.c.source, instawow.db.pkg.c.name)
        )
        if not query:
            return []

        return [Pkg.from_row_mapping(self.manager.database, p) for p in query.mappings().all()]

    def to_defn(self, addon: str, strategy: typing.Optional[str] = None) -> Defn:
        pair = self.manager.pair_uri(addon) or ('*', addon)
        defn = Defn(*pair)
        if strategy:
            return evolve(defn, strategy=strategy)
        return defn

    def to_defns(self, addons: str | list[str] | list[tuple]) -> list[Defn]:
        if isinstance(addons, str):
            return [self.to_defn(addons)]

        return [self.to_defn(addon) if isinstance(addon, str) else self.to_defn(*addon) for addon in addons]

    def update(self):
        addons = [Defn.from_pkg(p) for p in self.get_addons()]
        results = self.run(self.manager.update(addons, False))
        report = instawow.cli.Report(results.items(),
                                     lambda r: not isinstance(r, PkgUpToDate))
        if str(report):
            print(report)
        else:
            print(f'All {self.profile} addons are up-to-date!')

    def install(self, addons: str | list[str], reinstall=False, strategy=None):
        defns = self.to_defns(addons)

        if '_lib' in self.profile:
            defns = [evolve(d, strategy='any_flavour' if d.source == 'curse' else 'default') for d in defns]
        elif strategy:
            defns = [evolve(d, strategy=strategy) for d in defns]

        if reinstall:
            results = self.run(self.manager.remove(defns, False))
            print(instawow.cli.Report(results.items()))
        results = self.run(self.manager.install(defns, replace=False))
        print(instawow.cli.Report(results.items()))

    def remove(self, addons: str | list[str]):
        defns = self.to_defns(addons)

        results = self.run(self.manager.remove(defns, False))
        print(instawow.cli.Report(results.items()))

    def show(self):
        for addon in self.get_addons():
            print(f'{addon.name}: {addon.version}')

    def export(self):
        with open(f'{self.profile}.json', 'w', encoding='utf-8') as file:
            file.write(
                json.dumps(
                    pkg_converter.unstructure(  # pyright: ignore[reportUnknownMemberType]
                        self.get_addons(), typing.List[Pkg]
                    ),
                    indent=2
                )
            )

    def reinstall(self, filename: str):
        with open(filename, 'rb') as file:
            addons = json.loads(file.read())
        addons = [(f"{a['source']}:{a['slug']}", a['options']['strategy']) for a in addons]
        addons = [self.to_defn(addon, strategy) for addon, strategy in addons]
        results = self.run(self.manager.install(addons, replace=True))
        print(instawow.cli.Report(results.items()))
