import logging
import os
import re
import sys
from pathlib import Path

from instawow_manager import InstawowManager
from toc import process_toc
from utils import process_file, rm_tree


class Handler(object):

    def remove_libraries_all(self, addon, lib_path):
        """Remove all embedded libraries"""
        rm_tree(Path('Addons') / addon / lib_path)

        # Extra library that need to be removed
        libs = ['embeds.xml', 'libs.xml', 'LibDataBroker-1.1.lua']
        for lib in libs:
            rm_tree(Path('Addons') / addon / lib)

        process_file(
            Path('Addons') / addon / '{}.toc'.format(addon),
            lambda lines: [l for l in lines
                           if not any(l.startswith(lib)
                                      for lib in libs + [lib_path])]
        )

    def remove_libraries(self, libs, root, xml_path):
        """Remove selected embedded libraries from root and xml."""
        for lib in libs:
            rm_tree(Path(root) / lib)

        process_file(
            xml_path,
            lambda lines: [l for l in lines
                           if not any(lib in l for lib in libs)]
        )

    def handle_libs(self):
        def handle_graph(lines):
            orig = 'local TextureDirectory\n'
            tar = 'local TextureDirectory = "Interface\\\\Addons\\\\!!Libs' + \
                  '\\\\LibGraph-2.0\\\\LibGraph-2.0\\\\"\n'

            if orig not in lines:
                return lines

            # Comment out the block discovering TextureDirectory
            # The dictory discovery system is not working here
            start = lines.index(orig)
            ret = lines[:start]
            ret.append(tar)
            end = lines[start:].index('end\n')

            for l in lines[start+1:start+end+1]:
                ret.append('--{}'.format(l))
            ret += lines[start+end+1:]

            return ret

        process_file(
            'Addons/!!Libs/LibGraph-2.0/LibGraph-2.0/LibGraph-2.0.lua',
            handle_graph
        )

        game_flavour = 'classic' if '_classic_' in os.getcwd() else 'retail'
        if game_flavour == 'classic':
            def handle_dogtag_stats(lines):
                orig = 'DogTag:AddTag("Stats", "PvPPowerDamage", {\n'

                if orig not in lines:
                    return lines

                # Comment the block, we don't have PVP Power in classic
                start = lines.index(orig)
                ret = lines[:start]
                end = lines[start:].index('})\n')

                for l in lines[start:start+end+1]:
                    ret.append('--{}'.format(l))
                ret += lines[start+end+1:]

                return ret

            process_file(
                'Addons/!!Libs/LibDogTag-Stats-3.0/Categories/PvP.lua',
                handle_dogtag_stats
            )

    def handle_dup_libraries(self):
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
            self.remove_libraries_all(addon, lib_path)

    def handle_auctioneer(self):
        addons = ['Auc-Advanced', 'BeanCounter', 'Enchantrix', 'Informant']

        for addon in addons:
            rm_tree(Path('Addons') / addon / 'Libs' / 'LibDataBroker')
            process_file(
                Path('Addons') / addon / 'Libs' / 'Load.xml',
                lambda lines: [l for l in lines if 'LibDataBroker' not in l]
            )

        rm_tree('Addons/SlideBar/Libs')
        process_file(
            'Addons/SlideBar/Load.xml',
            lambda lines: [l for l in lines if 'Libs' not in l]
        )

    def handle_atlas(self):
        process_file(
            'Addons/Atlas/Core/Atlas.lua',
            lambda lines: ['addon.LocName = "Atlas"\n'
                           if l.startswith('addon.LocName') else l
                           for l in lines]
        )

    def handle_bagnon(self):
        rm_tree('AddOns/Bagnon/common/LibDataBroker-1.1')
        process_file(
            'Addons/Bagnon/addons/main/main.xml',
            lambda lines: [l for l in lines if 'LibDataBroker' not in l]
        )

        self.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0',
             'CallbackHandler-1.0', 'LibStub'],
            'AddOns/Bagnon/common/Wildpants/libs',
            'AddOns/Bagnon/common/Wildpants/libs/libs.xml'
        )

    def handle_dcs(self):
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

            rm_tree(Path('Addons/Decursive/Libs') / lib)

        process_file(
            'Addons/Decursive/embeds.xml',
            lambda lines: [l for l in lines
                           if 'Libs' not in l or 'BugGrabber' in l]
        )

    def handle_fb(self):
        self.remove_libraries(
            ['CallbackHandler-1.0', 'HereBeDragons',
             'LibBabble-SubZone-3.0', 'LibDataBroker-1.1',
             'LibDBIcon-1.0', 'LibStub', 'LibWindow-1.1'],
            'Addons/FishingBuddy/Libs',
            'Addons/FishingBuddy/Libs/Libs.xml'
        )

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
                                '"Fizzle"'
                               ))
            return ret
        process_file('Addons/Fizzle/Core.lua', f)

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
        self.remove_libraries_all('honorspy', 'Libs')

        process_file(
            'Addons/honorspy/honorspy.lua',
            lambda lines: ['local addonName = "Honorspy";\n'
                           if l.startswith('local addonName') else l
                           for l in lines]
        )

    def handle_monkeyspeed(self):
        process_file(
            'Addons/MonkeySpeed/MonkeySpeedInit.lua',
            lambda lines: [l.replace(
                              'GetAddOnMetadata("MonkeySpeed", "Title")',
                              '"MonkeySpeed"'
                           ) if '"Title"' in l else l
                           for l in lines]
        )

    def handle_omnicc(self):
        rm_tree('Addons/OmniCC/libs')

        for xml_path in ['main/main.xml', 'config/config.xml']:
            process_file(
                Path('Addons/OmniCC/') / xml_path,
                lambda lines: [l for l in lines if 'libs' not in l]
            )

    def handle_prat(self):
        rm_tree('Addons/Prat-3.0_Libraries')

    def handle_scrap(self):
        self.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0',
             'CallbackHandler-1.0', 'LibStub'],
            'Addons/Scrap/libs',
            'Addons/Scrap/libs/main.xml'
        )

    def handle_tc2(self):
        rm_tree('Addons/ThreatClassic2/Libs')

        def f(lines):
            return [l for l in lines if 'Libs' not in l]
        path = 'Addons/ThreatClassic2/ThreatClassic2.xml'
        process_file(path, f)

    def handle_tsm(self):
        rm_tree('Addons/TradeSkillMaster/External/EmbeddedLibs/')

        process_file(
            'Addons/TradeSkillMaster/Core/UI/Support/Fonts.lua',
            lambda lines: [re.sub(r'".+ttf"',
                                  r'"Fonts\\\\ARKai_C.ttf"',
                                  l)
                           for l in lines]
        )

        process_file(
            'Addons/TradeSkillMaster/TradeSkillMaster.toc',
            lambda lines: [l for l in lines if 'EmbeddedLibs' not in l]
        )

    def handle_ufp(self):
        rm_tree('Addons/UnitFramesPlus_MobHealth')

        self.remove_libraries_all('UnitFramesPlus_Cooldown', 'Libs')
        self.remove_libraries_all('UnitFramesPlus_Threat', 'LibThreatClassic2')

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
