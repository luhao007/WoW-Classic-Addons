import functools
import logging
import os
import shutil
from pathlib import Path

from defusedxml import ElementTree

import utils
from toc import TOC

logger = logging.getLogger('manager')

CLASSIC_ERA_VER = '11307'
CLASSIC_VER = '20501'
RETAIL_VER = '90005'


NOT_WORKING = ['!Swatter', 'Auc-Advanced', 'Auc-Filter-Basic', 'Auc-ScanData', 'Auc-Stat-Histogram', 'Auc-Stat-iLevel',
                'Auc-Stat-Purchased', 'Auc-Stat-Simple', 'Auc-Stat-StdDev', 'Auc-Util-FixAH',
                'BeanCounter', 'ClassicCastbars', 'ClassicCastbars_Options', 'Enchantrix', 'Enchantrix-Barker',
                'Informant', 'MerInspect', 'SlideBar', 'Stubby']


def available_on(platforms):
    def decorator(func):
        def wrapper(*args):
            platform = utils.get_platform()
            if platform in platforms:
                func(*args)
        return wrapper
    return decorator


def lib_babble_to_toc():
    ret = []
    root = Path('Addons/!!Libs')
    if os.path.exists(root / 'LibBabble'):
        ret.append('# LibBabbles\n')
        for lib in os.listdir(root / 'LibBabble'):
            if lib.endswith('.lua'):
                ret.append(f'LibBabble\\{lib}\n')
            else:
                subdir = os.listdir(root / 'LibBabble' / lib)
                if 'lib.xml' in subdir:
                    ret.append(f'LibBabble\\{lib}\\lib.xml\n')
                elif f'{lib}.lua' in subdir:
                    ret.append(f'LibBabble\\{lib}\\{lib}.lua\n')
        ret.append('\n')

    return ret


class Manager:

    def __init__(self):
        """Addon manager."""
        self.config = ElementTree.parse('config.xml')

        if utils.get_platform() == 'classic_era':
            self.interface = CLASSIC_ERA_VER
        elif utils.get_platform() == 'classic':
            self.interface = CLASSIC_VER
        else:
            self.interface = RETAIL_VER

    def process(self):
        for func in dir(self):
            if func.startswith('handle'):
                getattr(self, func)()

        self.process_toc()

    def process_libs(self):
        for func in dir(self):
            if func.startswith('handle_lib'):
                getattr(self, func)()

        self.process_lib_tocs()

    @functools.lru_cache
    def get_addon_config(self, addon):
        return self.config.find('.//*[@name="{}"]'.format(addon))

    @functools.lru_cache
    def get_addon_parent_config(self, addon):
        return self.config.find('.//*[@name="{}"]../..'.format(addon))

    def get_title(self, addon):
        parts = []
        namespace = {'x': 'https://www.github.com/luhao007'}

        config = self.get_addon_config(addon)
        if config.tag.endswith('SubAddon'):
            parent_config = self.get_addon_parent_config(addon)
            cat = parent_config.find('x:Category', namespace).text
            title = parent_config.find('x:Title', namespace).text
        else:
            cat = config.find('x:Category', namespace).text
            title = config.find('x:Title', namespace).text

        colors = {
            '基础库': 'C41F3B',     # Red - DK
            '任务': '00FF96',       # Spring green - Monk
            '物品': '0070DE',       # Doget blue - Shaman
            '界面': 'A330C9',       # Dark Magenta - DH
            '副本': 'FF7D0A',       # Orange - Druid
            '战斗': 'C79C6E',       # Tan - Warrior
            'PVP': '8787ED',        # Purple - Warlock
            '探索': '40C7EB',       # Light Blue - Mage
            '收藏': 'A9D271',       # Green - Hunter
            '社交': 'F48CBA',       # Pink - Paladin
            '功能': 'FFF468',       # Yellow - Rogue
            '辅助': 'FFFFFF',       # White - Priest
        }
        color = colors.get(cat, 'FFF569')   # Unknown defaults to Rogue Yellow
        parts.append('|cFFFFE00A<|r|cFF{}{}|r|cFFFFE00A>|r'.format(color, cat))

        parts.append('|cFFFFFFFF{}|r'.format(title))

        if config.tag.endswith('SubAddon'):
            sub = config.find('x:Title', namespace).text
            if sub == '设置':
                color = 'FF0055FF'
            else:
                color = 'FF69CCF0'
            parts.append('|c{}{}|r'.format(color, sub))
        elif not (('DBM' in addon and addon != 'DBM-Core') or
                  'Grail-' in addon or
                  addon == '!!Libs'):
            if config.find('x:Title-en', namespace) is not None:
                title_en = config.find('x:Title-en', namespace).text
            else:
                title_en = addon
            parts.append('|cFFFFE00A{}|r'.format(title_en))

        ext = config.find('x:TitleExtra', namespace)
        if ext is not None:
            parts.append('|cFF22B14C{}|r'.format(ext.text))

        return ' '.join(parts)

    def process_toc(self):
        for addon in os.listdir('AddOns'):
            config = self.get_addon_config(addon)
            if not config:
                logger.warning('%s not found!', addon)
                continue

            def process(config, addon, lines):
                toc = TOC(lines)

                toc.tags['Interface'] = self.interface

                if utils.get_platform() == 'classic' and addon in NOT_WORKING:
                    toc.tags['Interface'] = '10000'
                toc.tags['Title-zhCN'] = self.get_title(addon)

                namespace = {'x': 'https://www.github.com/luhao007'}
                note = config.find('x:Notes', namespace)
                if note is not None:
                    toc.tags['Notes-zhCN'] = note.text

                if config.tag.endswith('SubAddon'):
                    parent_config = self.get_addon_parent_config(addon)
                    toc.tags['X-Part-Of'] = parent_config.get('name')
                elif addon in ['DBM-Core', 'Auc-Advanced', 'TomCats']:
                    toc.tags['X-Part-Of'] = addon
                elif addon in ['+Wowhead_Looter']:
                    toc.tags.pop('X-Part-Of', None)

                return toc.to_lines()

            for postfix in ['', '-Classic', '-BCC', '-Mainline']:
                path = os.path.join('AddOns', addon, f'{addon}{postfix}.toc')
                if os.path.exists(path):
                    utils.process_file(path, functools.partial(process, config, addon))

    def process_lib_tocs(self):
        toc = TOC([])

        toc.tags['Interface'] = self.interface
        toc.tags['Author'] = 'luhao007'

        toc.tags['Title'] = 'Libraries'
        toc.tags['Notes'] = 'Libraries'
        toc.tags['Title-zhCN'] = '|cFFFFE00A<|r|cFFC41F3B基础库|r|cFFFFE00A>|r |cFFFFFFFF|cFF7FFF7FAce核心库|r |cFFFF0000必须加载|r|r'
        toc.tags['Notes-zhCN'] = '插件基础函数库|N|CFFFF0000必须加载|R'

        toc.contents = ['# Common Handler Libs\n',
                        'Ace3\\LibStub\\LibStub.lua\n',
                        'Ace3\\CallbackHandler-1.0\\CallbackHandler-1.0.xml\n',
                        'LibDataBroker-1.1\\LibDataBroker-1.1.lua\n',
                        '\n',
                        '# Ace3 Libs\n',
                        'Ace3\\AceAddon-3.0\\AceAddon-3.0.xml\n',
                        'Ace3\\AceEvent-3.0\\AceEvent-3.0.xml\n',
                        'Ace3\\AceTimer-3.0\\AceTimer-3.0.xml\n',
                        'Ace3\\AceBucket-3.0\\AceBucket-3.0.xml\n',
                        'Ace3\\AceHook-3.0\\AceHook-3.0.xml\n',
                        'Ace3\\AceDB-3.0\\AceDB-3.0.xml\n',
                        'Ace3\\AceDBOptions-3.0\\AceDBOptions-3.0.xml\n',
                        'Ace3\\AceLocale-3.0\\AceLocale-3.0.xml\n',
                        'Ace3\\AceGUI-3.0\\AceGUI-3.0.xml\n',
                        'Ace3\\AceConsole-3.0\\AceConsole-3.0.xml\n',
                        'Ace3\\AceConfig-3.0\\AceConfig-3.0.xml\n',
                        'Ace3\\AceComm-3.0\\AceComm-3.0.xml\n',
                        'Ace3\\AceTab-3.0\\AceTab-3.0.xml\n',
                        'Ace3\\AceSerializer-3.0\\AceSerializer-3.0.xml\n',
                        '\n',
                        '# Ace3 Additional Libs\n',
                        'LibSharedMedia-3.0\\lib.xml\n',
                        'AceGUI-3.0-SharedMediaWidgets\\AceGUI-3.0-SharedMediaWidgets\\widget.xml\n',
                        '\n',
                        '# Libs Needs to be Imported before Other Libs\n',
                        'LibCompress\\lib.xml\n',
                        'UTF8\\utf8data.lua\n',
                        'UTF8\\utf8.lua\n',
                        '\n',
                        '# HereBeDragons\n',
                        'HereBeDragons\\HereBeDragons-2.0.lua\n',
                        'HereBeDragons\\HereBeDragons-Pins-2.0.lua\n',
                        'HereBeDragons\\HereBeDragons-Migrate.lua\n',
                        '\n'
                        '# Dropdown menus\n',
                        '!LibUIDropDownMenu\\LibUIDropDownMenu\\LibUIDropDownMenu.xml\n',
                        '!LibUIDropDownMenu-2.0\\LibUIDropDownMenu.xml\n',
                        '\n']

        root = Path('Addons/!!Libs')
        libs = set(os.listdir(root))
        libs -= {'!!Libs.toc', 'Ace3', 'AceGUI-3.0-SharedMediaWidgets', 'HereBeDragons', 'UTF8', 'FrameXML',
                    '!LibUIDropDownMenu', '!LibUIDropDownMenu-2.0', 'LibCompress', 'LibDataBroker-1.1', 'LibSharedMedia-3.0'}

        if 'LibBabble' in libs:
            toc.contents += lib_babble_to_toc()
            libs.discard('LibBabble')

        drs = {lib for lib in libs if lib.startswith('DR')}
        libs -= drs
        if drs:
            toc.contents.append('# DR Libs\n')
            for dr_lib in drs:
                toc.contents.append(utils.lib_to_toc(dr_lib))
            toc.contents.append('\n')

        luas = {lib for lib in libs if lib.endswith('lua')}
        libs -= luas
        toc.contents.append('# Other Libs\n')
        for lib in sorted(libs):
            toc.contents.append(utils.lib_to_toc(lib))

        if luas:
            toc.contents.append('\n')
            toc.contents.append('# Custom Luas\n')
            for lua in sorted(luas):
                toc.contents.append(f'{lua}\n')

        with open('Addons/!!Libs/!!Libs.toc', 'w', encoding='utf-8') as file:
            file.writelines(toc.to_lines())


    ###########################
    # Handle embedded libraries
    ###########################

    @staticmethod
    def handle_lib_graph():
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

            for line in lines[start+1:start+end+1]:
                ret.append('--{}'.format(line))
            ret += lines[start+end+1:]

            return ret

        utils.process_file(
            'AddOns/!!Libs/LibGraph-2.0/LibGraph-2.0/LibGraph-2.0.lua',
            handle_graph
        )

    @staticmethod
    def handle_lib_babbles():
        root = Path('Addons/!!Libs/')
        for lib in os.listdir(root):
            if lib.startswith('LibBabble-'):
                shutil.copytree(root/lib,
                                root/'LibBabble'/lib,
                                dirs_exist_ok=True)
                shutil.rmtree(root/lib)

    @staticmethod
    def _handle_lib_in_libs(root):
        for lib in os.listdir(root):
            if not os.path.isdir(root/lib) or lib == 'Ace3':
                continue

            embeds = ['CallbackHandler-1.0', 'LibStub', 'LibStub-1.0', 'HereBeDragons']
            for path in ['libs', 'lib']:
                if os.path.exists(root / lib / path):
                    embeds.append(path)
                    embeds.append(path.capitalize())
                    break

            for embed in embeds:
                utils.rm_tree(root / lib / embed)

            if os.path.exists(root / lib / 'embeds.xml'):
                os.remove(root / lib / 'embeds.xml')
                embeds.append('embeds.xml')

            files = ['lib.xml', f'{lib}.xml', f'{lib}.toc']
            for file in files:
                for path in [root / file, root / lib / file]:
                    if os.path.exists(path):
                        utils.remove_libs_in_file(path, embeds)

    @staticmethod
    def handle_lib_in_libs():
        Manager._handle_lib_in_libs(Path('AddOns/!!Libs'))
        Manager._handle_lib_in_libs(Path('AddOns/!!Libs/LibBabble'))


    ##########################
    # Handle individual addons
    ##########################

    @staticmethod
    def handle_dup_libraries():
        addons = ['Atlas', 'BlizzMove', 'DBM-Core', 'Details_Streamer',
                    'Details_TinyThreat', 'ExRT', 'GatherMate2', 'GTFO',
                    'HandyNotes', 'ItemRack', 'ItemRackOptions', 'MapSter',
                    'MikScrollingBattleText', 'OmniCC', 'OmniCC_Config',
                    'Quartz', 'RangeDisplay', 'RangeDisplay_Options', 'TellMeWhen', 'TomTom']

        if utils.get_platform() == 'retail':
            addons += ['AllTheThings', 'Details_ChartViewer',
                        'Details_DeathGraphs', 'Details_EncounterDetails',
                        'Details_RaidCheck', 'Details_TimeLine',
                        'Details_Vanguard', 'FasterCamera',
                        'GladiatorlosSA2', 'Gladius',
                        'HandyNotes_Argus', 'HandyNotes_BrokenShore',
                        'HandyNotes_BattleForAzeroth',
                        'HandyNotes_Draenor',
                        'HandyNotes_DraenorTreasures',
                        'HandyNotes_LegionClassOrderHalls',
                        'HandyNotes_LegionRaresTreasures',
                        'HandyNotes_Shadowlands',
                        'HandyNotes_SuramarShalAranTelemancy',
                        'HandyNotes_TimelessIsleChests',
                        'HandyNotes_VisionsOfNZoth',
                        'NPCScan', 'Omen',
                        'RelicInspector', 'Simulationcraft', 'Titan']
        else:
            addons += ['alaTalentEmu', 'alaCalendar', 'AtlasLootClassic', 'AtlasLootClassic_Options',
                        'ATT-Classic', 'ClassicCastbars_Options',
                        'Fizzle', 'GroupCalendar', 'HandyNotes_NPCs (Classic)',
                        'PallyPower', 'SimpleChatClassic', 'TradeLog', 'TitanClassic', 'WclPlayerScore']


        for addon in addons:
            utils.remove_libraries_all(addon)

    @staticmethod
    def handle_acp():
        def handle(lines):
            ret = []
            start1 = start2 = 0
            for i, line in enumerate(lines):
                if 'FontString name="$parentTitle"' in line:
                    start1 = i
                elif 'FontString name="$parentStatus"' in line:
                    start2 = i

            ret = lines[:start1+2]
            ret.append(' '*24 + '<AbsDimension x="270" y="12"/>\n')
            ret += lines[start1+3:start2+2]
            ret.append(' '*24 + '<AbsDimension x="90" y="12"/>\n')
            ret += lines[start2+3:]
            return ret

        utils.process_file('Addons/ACP/ACP.xml', handle)

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_ate():
        utils.remove_libraries(
                ['CallbackHandler-1.0', 'LibDataBroker-1.1',
                    'LibDbIcon-1.0', 'LibStub'],
                'AddOns/alaTalentEmu/Lib',
                'AddOns/alaTalentEmu/alaTalentEmu.xml'
            )

    @staticmethod
    def handle_att():
        utils.change_defaults(
            'Addons/{}/Settings.lua'.format(
                'AllTheThings' if utils.get_platform() == 'retail' else 'ATT-Classic'),
            ['		["MinimapButton"] = false,',
                '		["Auto:MiniList"] = false,']
        )

    @staticmethod
    def handle_atlas():
        utils.change_defaults(
            'AddOns/Atlas/Core/Atlas.lua',
            'addon.LocName = "Atlas"',
        )

        utils.change_defaults(
            'Addons/Atlas/Data/Constants.lua',
            '			hide = true,'
        )

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_atlasloot():
        if utils.get_platform() == 'retail':
            utils.remove_libraries(
                ['CallbackHandler-1.0', 'LibBabble-Boss-3.0',
                    'LibBabble-Faction-3.0', 'LibBabble-ItemSet-3.0',
                    'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDialog-1.0',
                    'LibSharedMedia-3.0', 'LibStub'],
                'AddOns/AtlasLoot/Libs',
                'AddOns/AtlasLoot/embeds.xml'
            )
        utils.change_defaults(
            'Addons/AtlasLootClassic/db.lua',
            '		shown = true,'
        )

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_auctioneer():
        addons = ['Auc-Advanced', 'BeanCounter', 'Enchantrix', 'Informant']

        for addon in addons:
            utils.rm_tree(Path('AddOns') / addon / 'Libs' / 'LibDataBroker')
            utils.process_file(
                Path('AddOns') / addon / 'Libs' / 'Load.xml',
                lambda lines: [line for line in lines
                                if 'LibDataBroker' not in line]
            )

        utils.rm_tree('AddOns/SlideBar/Libs')
        utils.process_file(
            'AddOns/SlideBar/Load.xml',
            lambda lines: [line for line in lines if 'Libs' not in line]
        )

    @staticmethod
    def handle_bagnon():
        utils.rm_tree('AddOns/Bagnon/common/LibDataBroker-1.1')
        utils.process_file(
            'AddOns/Bagnon/AddOns/main/main.xml',
            lambda lines: [line for line in lines
                            if 'LibDataBroker' not in line]
        )

        utils.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0',
                'CallbackHandler-1.0', 'LibStub'],
            'AddOns/Bagnon/common/Wildpants/libs',
            'AddOns/Bagnon/common/Wildpants/libs/libs.xml'
        )

    @staticmethod
    @available_on(['retail'])
    def handle_btwquest():
        def process(lines):
            ret = []
            minimap = False
            for line in lines:
                if 'minimapShown' in line:
                    minimap = True

                if minimap and 'default' in line:
                    ret.append('            default = false,\n')
                    minimap = False
                else:
                    ret.append(line)
            return ret

        utils.process_file('Addons/BtWQuests/BtWQuests.lua', process)

    @staticmethod
    def handle_dcs():
        utils.change_defaults(
            'AddOns/Deja{}Stats/DCSDuraRepair.lua'.format(
                'Character' if utils.get_platform() == 'retail' else 'Classic'),
            ['	ShowDuraSetChecked = false,',
                '	ShowItemRepairSetChecked = false,',
                '	ShowItemLevelSetChecked = false,',
                '	ShowEnchantSetChecked = false,']
        )

    @staticmethod
    def handle_decursive():
        for lib in os.listdir('AddOns/Decursive/Libs'):
            if lib == 'BugGrabber':
                continue

            utils.rm_tree(Path('AddOns/Decursive/Libs') / lib)

        utils.process_file(
            'AddOns/Decursive/embeds.xml',
            lambda lines: [line for line in lines
                            if 'Libs' not in line or 'BugGrabber' in line]
        )

    @staticmethod
    def handle_details():
        libs = ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
                'AceGUI-3.0', 'AceHook-3.0', 'AceLocale-3.0', 'AceSerializer-3.0',
                'AceTab-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',  'LibBossIDs-1.0',
                'LibCompress', 'LibClassicCasterino', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
                'LibDeflate', 'LibGraph-2.0', 'LibGroupInSpecT-1.1', 'LibItemUpgradeInfo-1.0',
                'LibSharedMedia-3.0', 'LibStub', 'LibTranslit', 'LibWindow-1.1', 'NickTag-1.0']

        utils.remove_libraries(libs, 'Addons/Details/Libs', 'Addons/Details/Libs/libs.xml')

        utils.change_defaults(
            'Addons/Details/functions/profiles.lua',
            ('		minimap = {hide = true, radius = 160, minimapPos = 220, '
                'onclick_what_todo = 1, text_type = 1, text_format = 3},'),
        )

        utils.change_defaults(
            'Addons/Details_Streamer/Details_Streamer.lua',
            '					minimap = {hide = true, radius = 160, minimapPos = 160},',
        )

    @staticmethod
    def handle_fb():
        utils.remove_libraries(
            ['CallbackHandler-1.0', 'HereBeDragons',
                'LibBabble-SubZone-3.0', 'LibDataBroker-1.1',
                'LibDBIcon-1.0', 'LibPetJournal-2.0',
                'LibStub', 'LibTourist-3.0', 'LibWindow-1.1'],
            'AddOns/FishingBuddy/Libs',
            'AddOns/FishingBuddy/Libs/Libs.xml'
        )

        utils.change_defaults(
            'Addons/FishingBuddy/FishingBuddyMinimap.lua',
            '		FishingBuddy_Player["MinimapData"] = { hide=true };'
        )

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_fizzle():
        def process(lines):
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
        utils.process_file('AddOns/Fizzle/Core.lua', process)

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_goodleader():
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceDB-3.0',
                'AceEvent-3.0', 'AceHook-3.0', 'AceLocale-3.0',
                'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
                'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibStub'],
            'AddOns/GoodLeader/Libs',
            'AddOns/GoodLeader/Libs/Libs.xml'
        )

        utils.rm_tree('Addons/GoodLeader/Libs/tdGUI/Libs')
        utils.remove_libs_in_file('Addons/GoodLeader/Libs/tdGUI/Load.xml',
                                    ['Libs'])

    @staticmethod
    def handle_grail():
        for folder in os.listdir('AddOns'):
            if 'Grail' not in folder:
                continue

            if (('NPCs' in folder or 'Quests' in folder) and
               not folder.endswith('_') and
               ('enUS' not in folder and 'zhCN' not in folder)):
                utils.rm_tree(Path('AddOns') / folder)

            if ((utils.get_platform() == 'retail' and 'classic' in folder) or
                (not utils.get_platform() == 'retail' and
                 ('retail' in folder or 'Achievements' in folder))):
                utils.rm_tree(Path('AddOns') / folder)

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_nwb():
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceComm-3.0', 'AceConfig-3.0', 'AceConsole-3.0',
                'AceDB-3.0', 'AceDBOptions-3.0', 'AceGUI-3.0',
                'AceGUI-3.0-SharedMediaWidgets', 'AceLocale-3.0',
                'AceSerializer-3.0', 'CallbackHandler-1.0', 'HereBeDragons',
                'LibCandyBar-3.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDeflate',
                'LibSharedMedia-3.0', 'LibStub'],
            'Addons/NovaWorldBuffs/Lib',
            'Addons/NovaWorldBuffs/embeds.xml',
        )

    @staticmethod
    @available_on(['retail'])
    def handle_meetingstone():
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceDB-3.0', 'AceEvent-3.0', 'AceGUI-3.0', 'AceHook-3.0',
                'AceLocale-3.0', 'AceSerializer-3.0', 'AceTimer-3.0',
                'CallbackHandler-1.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
                'LibStub', 'LibWindow-1.1'],
            'Addons/MeetingStone/Libs',
            'Addons/MeetingStone/Libs/Embeds.xml'
        )

        utils.change_defaults(
            'Addons/MeetingStone/Profile.lua',
            '            minimap = { hide = true,'
        )

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_meetinghorn():
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceDB-3.0', 'AceEvent-3.0', 'AceGUI-3.0', 'AceHook-3.0',
                'AceLocale-3.0', 'AceSerializer-3.0', 'AceTimer-3.0',
                'CallbackHandler-1.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
                'LibStub'],
            'Addons/MeetingHorn/Libs',
            'Addons/MeetingHorn/Libs/Libs.xml'
        )

        utils.rm_tree('Addons/MeetingHorn/Libs/tdGUI/Libs')
        utils.remove_libs_in_file('Addons/MeetingHorn/Libs/tdGUI/Load.xml',
                                    ['Libs'])

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_merinspect():
        utils.change_defaults(
            'Addons/MerInspect/Options.lua',
            ['    ShowCharacterItemSheet = false,          --玩家自己裝備列表',
                '    ShowCharacterItemStats = false,          --玩家自己屬性統計']
        )

    @staticmethod
    @available_on(['retail'])
    def handle_mogit():
        utils.remove_libraries(
            ['AceConfig-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceGUI-3.0',
                'CallbackHandler-1.0', 'LibBabble-Boss-3.0',
                'LibBabble-Inventory-3.0', 'LibBabble-Race-3.0', 'LibDBIcon-1.0',
                'LibDataBroker-1.1', 'LibStub'],
            'Addons/MogIt/Libs',
            'Addons/MogIt/Libs/Embeds.xml'
        )

        utils.change_defaults(
            'Addons/Mogit/Core/Core.lua',
            '		minimap = { hide = true },'
        )

    @staticmethod
    def handle_monkeyspeed():
        utils.process_file(
            'AddOns/MonkeySpeed/MonkeySpeedInit.lua',
            lambda lines: [line.replace(
                                'GetAddOnMetadata("MonkeySpeed", "Title")',
                                '"MonkeySpeed"'
                            ) if '"Title"' in line else line
                            for line in lines]
        )

    @staticmethod
    def handle_myslot():
        utils.remove_libraries(
            ['CallbackHandler-1.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibStub'],
            'Addons/Myslot/libs',
            'Addons/Myslot/Myslot.toc'
        )

    @staticmethod
    def handle_omnicc():
        utils.process_file(
            'AddOns/OmniCC/core/core.xml',
            lambda lines: [line for line in lines if 'libs' not in line]
        )

    @staticmethod
    @available_on(['retail'])
    def handle_omen():
        utils.change_defaults(
            'Addons/Omen/Omen.lua',
            '			hide = true,'
        )

    @staticmethod
    @available_on(['retail'])
    def handle_oa():
        utils.remove_libraries(
            ['CallbackHandler-1.0', 'LibBabble-Inventory-3.0',
                'LibBabble-SubZone-3.0', 'LibSharedMedia-3.0', 'LibStub'],
            'Addons/Overachiever/libs',
            'Addons/Overachiever/Overachiever.toc'
        )

        utils.process_file(
            'Addons/Overachiever/Overachiever.lua',
            lambda lines: [line.replace(
                'GetAddOnMetadata("Overachiever", "Title")',
                '"Overarchiever"'
            ) for line in lines]
        )

    @staticmethod
    def handle_plater():
        libs = ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
                'AceGUI-3.0', 'AceLocale-3.0', 'AceSerializer-3.0',
                'AceTimer-3.0', 'CallbackHandler-1.0', 'LibCompress',
                'LibClassicCasterino', 'LibClassicDurations', 'LibCustomGlow-1.0',
                'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDeflate',
                'LibRangeCheck-2.0', 'LibSharedMedia-3.0', 'LibTranslit-1.0', 'LibStub']

        utils.remove_libraries(libs, 'Addons/Plater/libs', 'Addons/Plater/libs/libs.xml')

    @staticmethod
    @available_on(['retail'])
    def handle_pt():
        utils.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0', 'CallbackHandler-1.0',
                'LibPetJournal-2.0', 'LibStub'],
            'Addons/PetTracker/libs',
            'Addons/PetTracker/libs/main.xml'
        )

    @staticmethod
    def handle_prat():
        utils.rm_tree('AddOns/Prat-3.0_Libraries')

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_questie():
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
                'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets', 'AceHook-3.0',
                'AceLocale-3.0', 'AceSerializer-3.0', 'AceTab-3.0',
                'AceTimer-3.0', 'CallbackHandler-1.0', 'LibCompress',
                'LibDataBroker-1.1', 'LibDBIcon-1.0', 'LibSharedMedia', 'LibSharedMedia-3.0', 'LibStub'],
            'AddOns/Questie/Libs',
            'AddOns/Questie/embeds.xml'
        )

        utils.remove_libraries([ 'LibUIDropDownMenu'], 'AddOns/Questie/Libs', 'AddOns/Questie/Questie.toc')

        root = Path('AddOns/Questie')
        with open(root / 'Questie.toc', 'r', encoding='utf-8') as file:
            lines = file.readlines()

        toc = TOC(lines)

        version = toc.tags['Version']
        major, minor, patch = version.split(' ')[0].split('.')

        def handle(lines):
            func = 'function QuestieLib:GetAddonVersionInfo()'
            start = 0
            for i, line in enumerate(lines):
                if line.startswith(func):
                    start = i
                    break

            ret = lines[:start+1]
            ret.append('    return {}, {}, {}\n'.format(major, minor, patch))
            ret.append('end\n')
            end = lines[start:].index('end\n')

            if not lines[start+1].strip().startswith('return'):
                for line in lines[start+1:start+end+1]:
                    ret.append('--{}'.format(line))

            ret += lines[start+end+1:]
            return ret

        utils.process_file(root / 'Modules/Libs/QuestieLib.lua', handle)

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_rl():
        utils.remove_libraries(
            ['CallbackHandler-1.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
                'LibStub'],
            'Addons/RaidLedger/lib',
            'Addons/RaidLedger/RaidLedger.toc'
        )

    @staticmethod
    @available_on(['retail'])
    def handle_rarity():
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceConfig-3.0',
                'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
                'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets', 'AceLocale-3.0',
                'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
                'HereBeDragons-2.0', 'LibBabble-Boss-3.0',
                'LibBabble-CreatureType-3.0', 'LibBabble-SubZone-3.0',
                'LibCompress', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
                'LibQTip-1.0', 'LibSharedMedia-3.0', 'LibSink-2.0', 'LibStub'],
            'AddOns/Rarity/Libs',
            'AddOns/Rarity/Rarity.toc'
        )

    @staticmethod
    def handle_scrap():
        utils.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0',
                'CallbackHandler-1.0', 'LibStub'],
            'AddOns/Scrap/libs',
            'AddOns/Scrap/libs/main.xml'
        )

    @staticmethod
    @available_on(['retail'])
    def handle_sc():
        utils.change_defaults(
            'Addons/Simulationcraft/core.lua',
            '        hide = true,'
        )

    @staticmethod
    @available_on(['retail'])
    def handle_talentsm():
        utils.remove_libraries(
            ['CallBackHandler', 'LibDataBroker', 'LibStub'],
            'AddOns/TalentSetManager/libs',
            'AddOns/TalentSetManager/libs/libs.xml'
        )

    @staticmethod
    def handle_titan():
        path = 'Addons/Titan{0}Location/Titan{0}Location.lua'.format(
            '' if utils.get_platform() == 'retail' else 'Classic')
        utils.change_defaults(
            path,
            ['			ShowCoordsOnMap = false,',
                '			ShowCursorOnMap = false,']
        )

    @staticmethod
    def handle_tomtom():
        utils.change_defaults(
            'Addons/TomTom/TomTom.lua',
            ['                playerenable = false,',
                '                cursorenable = false,']
        )

    @staticmethod
    def handle_tsm():
        utils.rm_tree('AddOns/TradeSkillMaster/External/EmbeddedLibs/')

        utils.process_file(
            'AddOns/TradeSkillMaster/TradeSkillMaster.toc',
            lambda lines: [line for line in lines
                            if 'EmbeddedLibs' not in line]
        )

    @staticmethod
    def handle_ufp():
        if utils.get_platform() == 'classic_era':
            utils.rm_tree('AddOns/UnitFramesPlus_MobHealth')

            utils.remove_libraries_all('UnitFramesPlus_Cooldown')

        def process(lines):
            ret = []
            minimap = False
            for line in lines:
                if 'minimap = {' in line:
                    minimap = True

                if minimap and 'button' in line:
                    ret.append('        button = 0,\n')
                    minimap = False
                else:
                    ret.append(line)
            return ret

        utils.process_file('Addons/UnitFramesPlus/UnitFramesPlus.lua', process)

    @staticmethod
    def handle_vuhdo():
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceEvent-3.0', 'AceGUI-3.0', 'AceLocale-3.0',
                'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
                'LibClassicDurations', 'LibCompress', 'LibCustomGlow-1.0',
                'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibSharedMedia-3.0',
                'LibStub', 'LibThreatClassic2', 'NickTag-1.0', 'UTF8'],
            'Addons/VuhDo/Libs',
            'Addons/VuhDo/Libs/Libs.xml'
        )

        if not utils.get_platform() == 'retail':
            utils.rm_tree('Addons/Vuhdo/Libs/!LibTotemInfo/LibStub')
            utils.remove_libs_in_file(
                'Addons/Vuhdo/Libs/!LibTotemInfo/embeds.xml',
                ['LibStub']
            )
        utils.rm_tree('Addons/Vuhdo/Libs/LibBase64-1.0/LibStub')

        utils.change_defaults(
            'Addons/VuhDo/VuhDoDefaults.lua',
            '	["SHOW_MINIMAP"] = false,'
        )

    @staticmethod
    def handle_wa():
        utils.remove_libraries(
            ['AceComm-3.0', 'AceConfig-3.0', 'AceConsole-3.0', 'AceEvent-3.0',
                'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets',
                'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
                'LibCustomGlow-1.0', 'LibCompress', 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDeflate',
                'LibGetFrame-1.0', 'LibRangeCheck-2.0', 'LibSharedMedia-3.0',
                'LibSerialize', 'LibSpellRange-1.0', 'LibStub'],
            'Addons/WeakAuras/Libs',
            'Addons/WeakAuras/embeds.xml'
        )

        utils.remove_libraries(
            ['LibClassicCasterino', 'LibClassicDurations', 'LibClassicSpellActionCount-1.0', ],
            'Addons/WeakAuras/Libs',
            'Addons/WeakAuras/WeakAuras.toc'
        )

        utils.remove_libraries_all('WeakAuras/Libs/Archivist')

        utils.change_defaults(
            'Addons/WeakAuras/WeakAuras.lua',
            '      db.minimap = db.minimap or { hide = true };'
        )

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_wim():
        utils.remove_libraries(
            ['CallbackHandler-1.0', 'ChatThrottleLib', 'LibChatAnims',
                'LibSharedMedia-3.0', 'LibStub'],
            'Addons/WIM/Libs',
            'Addons/WIM/Libs/includes.xml'
        )

    @staticmethod
    def handle_whlooter():
        utils.change_defaults(
            'Addons/+Wowhead_Looter/Wowhead_Looter.lua',
            'wlSetting = {minimap=false};'
        )
