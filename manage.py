import os
import re
from pathlib import Path
import shutil

from toc import TOC
from utils import process_file, rm_tree


def classic_only(func):
    def wrapper(*args):
        if '_classic_' in os.getcwd():
            func(*args)
    return wrapper


def retail_only(func):
    def wrapper(*args):
        if '_retail_' in os.getcwd():
            func(*args)
    return wrapper


class Manager(object):

    def is_classic(self):
        return '_classic_' in os.getcwd()

    def remove_libraries_all(self, addon, lib_path=None):
        """Remove all embedded libraries"""
        if not lib_path:
            for p in ['libs', 'lib']:
                path = Path('Addons') / addon / p
                if os.path.exists(path):
                    lib_path = p
                    break
            else:
                return

        rm_tree(Path('AddOns') / addon / lib_path)

        # Extra library that need to be removed
        libs = ['embeds.xml', 'Embeds.xml', 'libs.xml',
                'Libs.xml', 'LibDataBroker-1.1.lua']
        for lib in libs:
            path = Path('AddOns') / addon / lib
            if os.path.exists(path):
                os.remove(path)

        process_file(
            Path('AddOns') / addon / '{}.toc'.format(addon),
            lambda lines: [l for l in lines
                           if not any(l.lower().startswith(lib.lower())
                                      for lib in libs + [lib_path])]
        )

    def remove_libraries(self, libs, root, xml_path):
        """Remove selected embedded libraries from root and xml."""
        for lib in libs:
            rm_tree(Path(root) / lib)

        process_file(
            xml_path,
            lambda lines: [l for l in lines
                           if not any(lib+'\\' in l for lib in libs)]
        )

    def change_defaults(self, path, defaults):
        def handle(lines):
            ret = []
            for l in lines:
                for d in [defaults] if isinstance(defaults, str) else defaults:
                    if l.startswith(d.split('= ')[0] + '= '):
                        ret.append(d+'\n')
                        break
                else:
                    ret.append(l)
            return ret
        process_file(path, handle)

    def process(self):
        for f in dir(self):
            if f.startswith('handle'):
                getattr(self, f)()

    def handle_lib_graph(self):
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

    def handle_lib_babbles(self):
        root = Path('Addons/!!Libs/')
        for lib in os.listdir(root):
            if lib.startswith('LibBabble-'):
                shutil.copytree(root/lib,
                                root/'LibBabble'/lib,
                                dirs_exist_ok=True)
                shutil.rmtree(root/lib)

    def handle_libs(self):
        pass

    def handle_dup_libraries(self):
        addons = ['Atlas', 'DBM-Core', 'GatherMate2', 'HandyNotes',
                  'MapSter', 'oRA3', 'Quartz', 'TellMeWhen', 'TomTom']
        if self.is_classic():
            addons += ['AtlasLootClassic', 'AtlasLootClassic_Options',
                       'ATT-Classic', 'ClassicCastbars_Options',
                       'Fizzle', 'GroupCalendar', 'HandyNotes_NPCs (Classic)',
                       'Recount', 'TitanClassic']
        else:
            addons += ['AllTheThings', 'FasterCamera',
                       'GladiatorlosSA2', 'Gladius', 'Grid2', 'Grid2Options',
                       'HandyNotes_Argus', 'HandyNotes_BrokenShore',
                       'HandyNotes_DraenorTreasures',
                       'HandyNotes_LegionRaresTreasures',
                       'HandyNotes_SuramarShalAranTelemancy',
                       'HandyNotes_TimelessIsleChests',
                       'HandyNotes_WarfrontRares', 'NPCScan', 'Omen',
                       'RangeDisplay', 'RangeDisplay_Options',
                       'RelicInspector', 'Titan']
        for addon in addons:
            self.remove_libraries_all(addon)

    def handle_att(self):
        self.change_defaults(
            'Addons/{}/Settings.lua'.format(
                'ATT-Classic' if self.is_classic() else 'AllTheThings'),
            ['		["MinimapButton"] = false,',
             '		["Auto:MiniList"] = false,']
        )

    def handle_atlasloot(self):
        if not self.is_classic():
            self.remove_libraries(
                ['CallbackHandler-1.0', 'LibBabble-Boss-3.0',
                 'LibBabble-Faction-3.0', 'LibBabble-ItemSet-3.0',
                 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDialog-1.0',
                 'LibSharedMedia-3.0', 'LibStub'],
                'AddOns/AtlasLoot/Libs',
                'AddOns/AtlasLoot/embeds.xml'
            )
        self.change_defaults(
            'Addons/AtlasLoot{}/db.lua'.format(
                'Classic' if self.is_classic() else ''),
            '			shown = false,'
        )

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
        self.change_defaults(
            'AddOns/Atlas/Core/Atlas.lua',
            'addon.LocName = "Atlas"',
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
        path = 'AddOns/Deja{}Stats/DCSDuraRepair.lua'.format(
            'Classic' if self.is_classic() else 'Character')
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
             'LibDBIcon-1.0', 'LibPetJournal-2.0',
             'LibStub', 'LibTourist-3.0', 'LibWindow-1.1'],
            'AddOns/FishingBuddy/Libs',
            'AddOns/FishingBuddy/Libs/Libs.xml'
        )

        self.change_defaults(
            'Addons/FishingBuddy/FishingBuddyMinimap.lua',
            '		FishingBuddy_Player["MinimapData"] = { hide=true };'
        )

    @classic_only
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
        for folder in os.listdir('AddOns'):
            if 'Grail' not in folder:
                continue

            if (('NPCs' in folder or 'Quests' in folder) and
               not folder.endswith('_') and
               ('enUS' not in folder and 'zhCN' not in folder)):
                rm_tree(Path('AddOns') / folder)

            if ((not self.is_classic() and 'classic' in folder) or
                (self.is_classic() and
                 ('retail' in folder or 'Achievements' in folder))):
                rm_tree(Path('AddOns') / folder)

    @retail_only
    def handle_grid(self):
        rm_tree('Addons/Grid2LDB')

    @classic_only
    def handle_honorspy(self):
        self.remove_libraries_all('honorspy')

        self.change_defaults(
            'AddOns/honorspy/honorspy.lua',
            ['local addonName = "Honorspy";',
                '			minimapButton = {hide = true},']
        )

    @retail_only
    def handle_meetingstone(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
             'AceDB-3.0', 'AceEvent-3.0', 'AceGUI-3.0', 'AceHook-3.0',
             'AceLocale-3.0', 'AceSerializer-3.0', 'AceTimer-3.0',
             'CallbackHandler-1.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
             'LibStub', 'LibWindow-1.1'],
            'Addons/MeetingStone/Libs',
            'Addons/MeetingStone/Libs/Embeds.xml'
        )

    @retail_only
    def handle_mogit(self):
        self.remove_libraries(
            ['AceConfig-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceGUI-3.0',
             'CallbackHandler-1.0', 'LibBabble-Boss-3.0',
             'LibBabble-Inventory-3.0', 'LibBabble-Race-3.0', 'LibDBIcon-1.0',
             'LibDataBroker-1.1', 'LibStub'],
            'Addons/MogIt/Libs',
            'Addons/MogIt/Libs/Embeds.xml'
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

    @retail_only
    def handle_oa(self):
        self.remove_libraries(
            ['CallbackHandler-1.0', 'LibBabble-Inventory-3.0',
             'LibBabble-SubZone-3.0', 'LibSharedMedia-3.0', 'LibStub'],
            'Addons/Overachiever/libs',
            'Addons/Overachiever/Overachiever.toc'
        )

    @retail_only
    def handle_pt(self):
        self.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0', 'CallbackHandler-1.0',
             'LibPetJournal-2.0', 'LibStub'],
            'Addons/PetTracker/libs',
            'Addons/PetTracker/libs/main.xml'
        )

    def handle_prat(self):
        rm_tree('AddOns/Prat-3.0_Libraries')

    @classic_only
    def handle_questie(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
             'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
             'AceGUI-3.0', 'AceHook-3.0', 'AceLocale-3.0', 'AceSerializer-3.0',
             'AceTab-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
             'LibCompress', 'LibDataBroker-1.1', 'LibDBIcon-1.0', 'LibStub'],
            'AddOns/Questie/Libs',
            'AddOns/Questie/embeds.xml'
        )

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

    @retail_only
    def handle_rarity(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceConfig-3.0',
             'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
             'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets', 'AceLocale-3.0',
             'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
             'HereBeDragons-2.0', 'LibBabble-Boss-3.0',
             'LibBabble-CreatureType-3.0', 'LibBabble-SubZone-3.0',
             'LibBars-1.0', 'LibCompress', 'LibDBIcon-1.0',
             'LibDataBroker-1.1', 'LibQTip-1.0', 'LibSharedMedia-3.0',
             'LibSink-2.0', 'LibStub'],
            'AddOns/Rarity/Libs',
            'AddOns/Rarity/Rarity.toc'
        )

    @classic_only
    def handle_recount(self):
        self.change_defaults(
            'Addons/Recount/Recount.lua',
            ['				x = 500,',
             '				w = 250,'],
        )

    def handle_scrap(self):
        self.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0',
             'CallbackHandler-1.0', 'LibStub'],
            'AddOns/Scrap/libs',
            'AddOns/Scrap/libs/main.xml'
        )

    @retail_only
    def handle_sc(self):
        # We need the embeds.xml
        rm_tree('Addons/Simulationcraft/libs')
        process_file(
            'Addons/Simulationcraft/Simulationcraft.toc',
            lambda lines: [l for l in lines
                           if not l.lower().startswith('libs\\')]
        )

    @retail_only
    def handle_skada(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceConfigDialog-3.0', 'AceConfigRegistry-3.0',
             'AceDB-3.0', 'AceDBOptions-3.0', 'AceGUI-3.0',
             'AceGUI-3.0-SharedMediaWidgets', 'AceLocale-3.0', 'AceTimer-3.0',
             'CallbackHandler-1.0', 'LibBossIDs-1.0', 'LibDBIcon-1.0',
             'LibDataBroker-1.1', 'LibNotify-1.0', 'LibSharedMedia-3.0',
             'LibStub', 'LibWindow-1.1'],
            'AddOns/Skada/lib',
            'AddOns/Skada/embeds.xml'
        )

    @classic_only
    def handle_tc2(self):
        rm_tree('AddOns/ThreatClassic2/Libs')

        def f(lines):
            return [l for l in lines if 'Libs' not in l]
        path = 'AddOns/ThreatClassic2/ThreatClassic2.xml'
        process_file(path, f)

    def handle_titan(self):
        path = 'Addons/Titan{0}Location/Titan{0}Location.lua'.format(
            'Classic' if self.is_classic() else '')
        self.change_defaults(
            path,
            ['			ShowCoordsOnMap = false,',
             '			ShowCursorOnMap = false,']
        )

    def handle_tomtom(self):
        self.change_defaults(
            'Addons/TomTom/TomTom.lua',
            ['                playerenable = false,',
             '                cursorenable = false,']
        )

    def handle_tsm(self):
        rm_tree('AddOns/TradeSkillMaster/External/EmbeddedLibs/')

        process_file(
            'AddOns/TradeSkillMaster/Core/UI/Support/Fonts.lua',
            lambda lines: [re.sub(r'".+ttf"',
                                  r'"Fonts\\\\ARKai_T.ttf"',
                                  l)
                           for l in lines]
        )

        process_file(
            'AddOns/TradeSkillMaster/TradeSkillMaster.toc',
            lambda lines: [l for l in lines if 'EmbeddedLibs' not in l]
        )

    @classic_only
    def handle_ufp(self):
        rm_tree('AddOns/UnitFramesPlus_MobHealth')

        self.remove_libraries_all('UnitFramesPlus_Cooldown')
        self.remove_libraries_all('UnitFramesPlus_Threat', 'LibThreatClassic2')

    def handle_wa(self):
        self.remove_libraries(
            ['AceComm-3.0', 'AceConfig-3.0', 'AceConsole-3.0', 'AceEvent-3.0',
             'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets',
             'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
             'LibClassicCasterino', 'LibClassicDurations', 'LibCustomGlow-1.0',
             'LibCompress', 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDeflate',
             'LibRangeCheck-2.0', 'LibSharedMedia-3.0', 'LibSpellRange-1.0',
             'LibStub'],
            'Addons/WeakAuras/Libs',
            'Addons/WeakAuras/embeds.xml'
        )

    def handle_wim(self):
        self.remove_libraries(
            ['CallbackHandler-1.0', 'ChatThrottleLib', 'LibChatAnims',
             'LibSharedMedia-3.0', 'LibStub'],
            'Addons/WIM/Libs',
            'Addons/WIM/Libs/includes.xml'
        )

    def handle_whlooter(self):
        self.change_defaults(
            'Addons/+Wowhead_Looter/Wowhead_Looter.lua',
            'wlSetting = {minimap=false};'
        )

    @retail_only
    def handle_wqt(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceComm-3.0', 'AceConfig-3.0', 'AceConsole-3.0',
             'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0', 'AceGUI-3.0',
             'AceLocale-3.0', 'AceSerializer-3.0', 'AceTimer-3.0',
             'CallbackHandler-1.0', 'HereBeDragons', 'LibDBIcon-1.0',
             'LibDataBroker-1.1', 'LibDeflate', 'LG', 'LibSharedMedia-3.0',
             'LibStub', 'LibWindow-1.1'],
            'Addons/WorldQuestTracker/libs',
            'Addons/WorldQuestTracker/libs/libs.xml'
        )
