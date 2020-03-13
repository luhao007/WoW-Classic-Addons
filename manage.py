import os
import re
from pathlib import Path

from toc import TOC
from utils import process_file, rm_tree


class Manager(object):

    def remove_libraries_all(self, addon, lib_path):
        """Remove all embedded libraries"""
        rm_tree(Path('AddOns') / addon / lib_path)

        # Extra library that need to be removed
        libs = ['embeds.xml', 'libs.xml', 'LibDataBroker-1.1.lua']
        for lib in libs:
            path = Path('AddOns') / addon / lib
            if os.path.exists(path):
                os.remove(path)

        process_file(
            Path('AddOns') / addon / '{}.toc'.format(addon),
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
            tar = 'local TextureDirectory = "Interface\\\\AddOns\\\\!!Libs' + \
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
            'AddOns/!!Libs/LibGraph-2.0/LibGraph-2.0/LibGraph-2.0.lua',
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
                'AddOns/!!Libs/LibDogTag-Stats-3.0/Categories/PvP.lua',
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
        Addons = ['Auc-Advanced', 'BeanCounter', 'Enchantrix', 'Informant']

        for addon in Addons:
            rm_tree(Path('AddOns') / addon / 'Libs' / 'LibDataBroker')
            process_file(
                Path('AddOns') / addon / 'Libs' / 'Load.xml',
                lambda lines: [l for l in lines if 'LibDataBroker' not in l]
            )

        rm_tree('AddOns/SlideBar/Libs')
        process_file(
            'AddOns/SlideBar/Load.xml',
            lambda lines: [l for l in lines if 'Libs' not in l]
        )

    def handle_atlas(self):
        process_file(
            'AddOns/Atlas/Core/Atlas.lua',
            lambda lines: ['addon.LocName = "Atlas"\n'
                           if l.startswith('addon.LocName') else l
                           for l in lines]
        )

    def handle_bagnon(self):
        rm_tree('AddOns/Bagnon/common/LibDataBroker-1.1')
        process_file(
            'AddOns/Bagnon/AddOns/main/main.xml',
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
        for lib in os.listdir('AddOns/Decursive/Libs'):
            if lib == 'BugGrabber':
                continue

            rm_tree(Path('AddOns/Decursive/Libs') / lib)

        process_file(
            'AddOns/Decursive/embeds.xml',
            lambda lines: [l for l in lines
                           if 'Libs' not in l or 'BugGrabber' in l]
        )

    def handle_fb(self):
        self.remove_libraries(
            ['CallbackHandler-1.0', 'HereBeDragons',
             'LibBabble-SubZone-3.0', 'LibDataBroker-1.1',
             'LibDBIcon-1.0', 'LibStub', 'LibWindow-1.1'],
            'AddOns/FishingBuddy/Libs',
            'AddOns/FishingBuddy/Libs/Libs.xml'
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
        process_file('AddOns/Fizzle/Core.lua', f)

    def handle_grail(self):
        game_flavour = 'classic' if '_classic_' in os.getcwd() else 'retail'
        for folder in os.listdir('AddOns'):
            if 'Grail' not in folder:
                continue

            if (('NPCs' in folder or 'Quests' in folder) and
               not folder.endswith('_') and
               ('enUS' not in folder and 'zhCN' not in folder)):
                rm_tree(Path('AddOns') / folder)

            if ((game_flavour == 'retail' and 'classic' in folder) or
               (game_flavour == 'classic') and ('retail' in folder or
                                                'Achievements' in folder)):
                rm_tree(Path('AddOns') / folder)

    def handle_honorspy(self):
        self.remove_libraries_all('honorspy', 'Libs')

        process_file(
            'AddOns/honorspy/honorspy.lua',
            lambda lines: ['local addonName = "Honorspy";\n'
                           if l.startswith('local addonName') else l
                           for l in lines]
        )

    def handle_monkeyspeed(self):
        process_file(
            'AddOns/MonkeySpeed/MonkeySpeedInit.lua',
            lambda lines: [l.replace(
                              'GetAddOnMetadata("MonkeySpeed", "Title")',
                              '"MonkeySpeed"'
                           ) if '"Title"' in l else l
                           for l in lines]
        )

    def handle_omnicc(self):
        rm_tree('AddOns/OmniCC/libs')

        for xml_path in ['main/main.xml', 'config/config.xml']:
            process_file(
                Path('AddOns/OmniCC/') / xml_path,
                lambda lines: [l for l in lines if 'libs' not in l]
            )

    def handle_prat(self):
        rm_tree('AddOns/Prat-3.0_Libraries')

    def handle_questie(self):
        root = Path('AddOns/Questie')
        with open(root / 'Questie.toc', 'r', encoding='utf-8') as f:
            lines = f.readlines()

        toc = TOC(lines)

        version = toc.tags['Version']
        major, minor, patch = version.split(' ')[0].split('.')

        def handle(lines):
            func = 'function QuestieLib:GetAddonVersionInfo()'
            for i, l in enumerate(lines):
                if l.startswith(func):
                    break

            ret = lines[:i+1]
            ret.append('    return {}, {}, {}\n'.format(major, minor, patch))
            ret.append('end\n')
            end = lines[i:].index('end\n')

            if not lines[i+1].strip().startswith('return'):
                for l in lines[i+1:i+end+1]:
                    ret.append('--{}'.format(l))

            ret += lines[i+end+1:]
            return ret

        process_file(root / 'Modules/Libs/QuestieLib.lua', handle)

    def handle_scrap(self):
        self.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0',
             'CallbackHandler-1.0', 'LibStub'],
            'AddOns/Scrap/libs',
            'AddOns/Scrap/libs/main.xml'
        )

    def handle_tc2(self):
        rm_tree('AddOns/ThreatClassic2/Libs')

        def f(lines):
            return [l for l in lines if 'Libs' not in l]
        path = 'AddOns/ThreatClassic2/ThreatClassic2.xml'
        process_file(path, f)

    def handle_tsm(self):
        rm_tree('AddOns/TradeSkillMaster/External/EmbeddedLibs/')

        process_file(
            'AddOns/TradeSkillMaster/Core/UI/Support/Fonts.lua',
            lambda lines: [re.sub(r'".+ttf"',
                                  r'"Fonts\\\\ARKai_C.ttf"',
                                  l)
                           for l in lines]
        )

        process_file(
            'AddOns/TradeSkillMaster/TradeSkillMaster.toc',
            lambda lines: [l for l in lines if 'EmbeddedLibs' not in l]
        )

    def handle_ufp(self):
        rm_tree('AddOns/UnitFramesPlus_MobHealth')

        self.remove_libraries_all('UnitFramesPlus_Cooldown', 'Libs')
        self.remove_libraries_all('UnitFramesPlus_Threat', 'LibThreatClassic2')

    def process(self):
        for f in dir(self):
            if f.startswith('handle'):
                getattr(self, f)()
