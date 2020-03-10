import logging
import os
import re
import shutil
import sys
from pathlib import Path

from instawow_manager import InstawowManager
from toc import process_toc
from utils import process_file, rm_tree


class Handler(object):

    def remove_libraries(self, addon, lib_path):
        """Remove the embedded libraries"""
        path = Path('Addons') / addon / lib_path
        if os.path.exists(path):
            shutil.rmtree(path)

        # Extra library that need to be removed
        libs = ['embeds.xml', 'libs.xml', 'LibDataBroker-1.1.lua']
        for lib in libs:
            path = Path('Addons') / addon / lib
            if os.path.exists(path):
                os.remove(path)

        def f(lines):
            return [l for l in lines if not any(l.startswith(lib) for lib in
                                                libs + [lib_path])]
        toc_path = Path('Addons') / addon / '{}.toc'.format(addon)
        process_file(toc_path, f)

    def handle_libraries(self):
        libs = [
            ('Atlas', 'Libs'),
            ('AtlasLootClassic', 'Libs'),
            ('AtlasLootClassic_Options', 'Libs'),
            ('ATT-Classic', 'lib'),
            ('ClassicCastbars_Options', 'Libs'),
            ('DBM-Core', 'Libs'),
            ('Fizzle', 'Libs'),
            ('GatherMate2', 'Libs'),
            ('HandyNotes_NPCs (Classic)', 'libs'),
            ('HandyNotes', 'Libs'),
            ('MapSter', 'Libs'),
            ('oRA3', 'libs'),
            ('Quartz', 'libs'),
            ('Recount', 'libs'),
            ('TellMeWhen', 'Lib'),
            ('TitanClassic', 'libs'),
            ('TomTom', 'libs'),
            ('WIM', 'Libs'),
        ]
        for addon, lib_path in libs:
            self.remove_libraries(addon, lib_path)

    def handle_dejaclassicstats(self):
        def f(lines):
            # Change thest defaults value to false
            defaults = ['ShowDuraSetChecked', 'ShowItemRepairSetChecked',
                        'ShowItemLevelSetChecked', 'ShowEnchantSetChecked']
            ret = []
            for line in lines:
                if line.split(' = ')[0].strip() in defaults:
                    ret.append(line.replace('true', 'false'))
                else:
                    ret.append(line)
            return ret
        path = 'AddOns/DejaClassicStats/DCSDuraRepair.lua'
        process_file(path, f)

    def handle_decursive(self):
        for lib in os.listdir('Addons/Decursive/Libs'):
            if lib == 'BugGrabber':
                continue

            path = Path('Addons/Decursive/Libs') / lib
            if os.path.exists(path):
                shutil.rmtree(path)

        def f(lines):
            return [l for l in lines if 'Libs' not in l or 'BugGrabber' in l]
        path = 'Addons/Decursive/embeds.xml'
        process_file(path, f)

    def handle_fizzle(self):
        def f(lines):
            ret = []
            for line in lines:
                if line == '       DisplayWhenFull = true,':
                    # Change default settings to not dixplay the '100%'.
                    ret.append('       DisplayWhenFull = false,')
                else:
                    # Only show 'Fizzle' in the options, not the meta name.
                    ret.append(line.replace(
                                'GetAddOnMetadata("Fizzle", "Title")',
                                'Fizzle'
                               ))
            return ret
        path = 'Addons/Fizzle/Core.lua'
        process_file(path, f)

    def handle_grail(self):
        game_flavour = 'classic' if '_classic_' in os.getcwd() else 'retail'
        for folder in os.listdir('Addons'):
            if 'Grail' not in folder:
                continue

            if (('NPCs' in folder or 'Quests' in folder) and
               not folder.endswith('_') and
               ('enUS' not in folder and 'zhCN' not in folder)):
                rm_tree(Path('Addons') / folder)

            if ((game_flavour == 'retail' and 'classic' in folder) or
               (game_flavour == 'classic') and ('retail' in folder or
                                                'Achievements' in folder)):
                rm_tree(Path('Addons') / folder)

    def handle_honorspy(self):
        self.remove_libraries('honorspy', 'Libs')

        def f(lines):
            return ['local addonName = "Honorspy";\n'
                    if l.startswith('local addonName') else l for l in lines]
        path = 'Addons/honorspy/honorspy.lua'
        process_file(path, f)

    def handle_omnicc(self):
        path = 'Addons/OmniCC/libs'
        if os.path.exists(path):
            shutil.rmtree(path)

        def f(lines):
            return [l for l in lines if 'main.xml' not in l]
        path = 'Addons/OmniCC/main/main.xml'
        process_file(path, f)

    def handle_prat(self):
        rm_tree('Addons/Prat-3.0_Libraries')

    def handle_scrap(self):
        libs = ['AceEvent-3.0', 'AceLocale-3.0',
                'CallbackHandler-1.0', 'LibStub']
        for lib in libs:
            path = Path('Addons/Scrap/libs') / lib
            if os.path.exists(path):
                shutil.rmtree(path)

        def f(lines):
            return [l for l in lines if not any(l.startswith(lib)
                                                for lib in libs)]
        path = 'Addons/Scrap/libs/main.xml'
        process_file(path, f)

    def handle_threat_classic2(self):
        path = 'Addons/ThreatClassic2/Libs'
        if os.path.exists(path):
            shutil.rmtree(path)

        def f(lines):
            return [l for l in lines if 'Libs' not in l]
        path = 'Addons/ThreatClassic2/ThreatClassic2.xml'
        process_file(path, f)

    def handle_tsm(self):
        rm_tree('Addons/TradeSkillMaster/External/EmbeddedLibs/')

        def f1(lines):
            orig = r'".+ttf"'
            targ = r'"Fonts\\\\ARKai_C.ttf"'
            return [re.sub(orig, targ, l) for l in lines]
        path = 'Addons/TradeSkillMaster/Core/UI/Support/Fonts.lua'
        process_file(path, f1)

        def f2(lines):
            return [l for l in lines if 'EmbeddedLibs' not in l]
        path = 'Addons/TradeSkillMaster/TradeSkillMaster.toc'
        process_file(path, f2)

    def handle_ufp(self):
        rm_tree('Addons/UnitFramesPlus_MobHealth')

    def process(self):
        for f in dir(self):
            if f.startswith('handle'):
                getattr(self, f)()


def manage():
    game_flavour = 'classic' if '_classic_' in os.getcwd() else 'retail'
    for lib in [False, True]:
        InstawowManager(game_flavour, lib).update()

    Handler().process()

    process_toc('11303' if game_flavour == 'classic' else '80300')
    logging.info('Finished.')


def main():
    verbose = bool(set(['--verbose', '-v']) & set(sys.argv))
    if verbose:
        logging.basicConfig(level=logging.INFO)

    manage()
    print('All done.')


if __name__ == '__main__':
    main()
