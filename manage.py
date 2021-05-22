import functools
import logging
import os
import re
import shutil
from pathlib import Path
from typing import Optional

from defusedxml import ElementTree

from toc import TOC
from utils import process_file, rm_tree

logger = logging.getLogger('manager')

CLASSIC_ERA_VER = '11307'
CLASSIC_VER = '20501'
RETAIL_VER = '90002'


NOT_WORKING = ['!Swatter', 'Auc-Advanced', 'Auc-Filter-Basic', 'Auc-ScanData', 'Auc-Stat-Histogram', 'Auc-Stat-iLevel',
                'Auc-Stat-Purchased', 'Auc-Stat-Simple', 'Auc-Stat-StdDev', 'Auc-Util-FixAH', 'Atlas_Transportation', 'BeanCounter', 'BlizzMove_Debug', 'ClassicCastbars',
                'ClassicCastbars_Options', 'Enchantrix', 'Enchantrix-Barker', 'GatherMate2', 'GatherMate2_Data', 'Grail',
                'Grail-NPCs-_classic_', 'Grail-NPCs-_classic_-enUS', 'Grail-NPCs-_classic_-zhCN', 'Grail-Quests-_classic_', 'Grail-Quests-_classic_-enUS',
                'Grail-Quests-_classic_-zhCN', 'Grail-Reputations-_classic_', 'Grail-Rewards', 'Grail-When', 'GTFO',
                'Informant', 'MerInspect', 'RaidLedger', 'PallyPower', 'SlideBar', 'Stubby']


def available_on(platforms):
    def decorator(func):
        def wrapper(*args):
            for p in platforms:
                if f'\\_{p}_\\' in os.getcwd():
                    func(*args)
        return wrapper
    return decorator


class Manager:

    def __init__(self):
        """Addon manager."""
        self.is_classic_era = '_classic_era_' in os.getcwd()
        self.is_classic = '_classic_' in os.getcwd()
        self.is_retail = '_retail_' in os.getcwd()
        self.config = ElementTree.parse('config.xml')

    def process(self):
        for f in dir(self):
            if f.startswith('handle'):
                getattr(self, f)()

        self.process_toc()

    def process_libs(self):
        for f in dir(self):
            if f.startswith('handle_lib'):
                getattr(self, f)()

    def remove_libs_in_file(self, path, libs):
        def f(lines):
            if str(path).endswith('.toc'):
                pattern = r'\s*(?i){}.*'
            else:
                pattern = r'\s*<((Script)|(Include))+ file\s*=\s*"(?i){}[\\\"\.].*'

            return [line for line in lines
                    if not any(re.match(pattern.format(lib), line)
                               for lib in libs)]

        process_file(path, f)

    def remove_libraries_all(self, addon, lib_path: Optional[str] = None):
        """Remove all embedded libraries."""
        if not lib_path:
            for p in ['libs', 'lib']:
                path = Path('Addons') / addon / p
                if os.path.exists(path):
                    lib_path = str(p)
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

        for p in ['.xml', '.toc', '-Classic.toc', '-BCC.toc', '-Mainline.toc']:
            path = Path('AddOns') / addon
            path /= '{}{}'.format(addon.split('/')[-1], p)
            if os.path.exists(str(path)):
                self.remove_libs_in_file(path, libs + [lib_path])

    def remove_libraries(self, libs, root, xml_path):
        """Remove selected embedded libraries from root and xml."""
        for lib in libs:
            rm_tree(Path(root) / lib)

        process_file(
            xml_path,
            lambda lines: [line for line in lines
                           if not any(lib.lower()+'\\' in line.lower() for lib in libs)]
        )

    def change_defaults(self, path, defaults):
        def handle(lines):
            ret = []
            for line in lines:
                for d in [defaults] if isinstance(defaults, str) else defaults:
                    if line.startswith(d.split('= ')[0] + '= '):
                        ret.append(d+'\n')
                        break
                else:
                    ret.append(line)
            return ret
        process_file(path, handle)

    ###################
    # Handle Addon Tocs
    ###################

    @functools.lru_cache
    def get_addon_config(self, addon):
        return self.config.find('.//*[@name="{}"]'.format(addon))

    @functools.lru_cache
    def get_addon_parent_config(self, addon):
        return self.config.find('.//*[@name="{}"]../..'.format(addon))

    def get_title(self, addon):
        parts = []
        ns = {'x': 'https://www.github.com/luhao007'}

        config = self.get_addon_config(addon)
        if config.tag.endswith('SubAddon'):
            parent_config = self.get_addon_parent_config(addon)
            cat = parent_config.find('x:Category', ns).text
            title = parent_config.find('x:Title', ns).text
        else:
            cat = config.find('x:Category', ns).text
            title = config.find('x:Title', ns).text

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
            sub = config.find('x:Title', ns).text
            if sub == '设置':
                color = 'FF0055FF'
            else:
                color = 'FF69CCF0'
            parts.append('|c{}{}|r'.format(color, sub))
        elif not (('DBM' in addon and addon != 'DBM-Core') or
                  'Grail-' in addon or
                  addon == '!!Libs'):
            if config.find('x:Title-en', ns) is not None:
                en = config.find('x:Title-en', ns).text
            else:
                en = addon
            parts.append('|cFFFFE00A{}|r'.format(en))

        ext = config.find('x:TitleExtra', ns)
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

                if self.is_classic_era:
                    toc.tags['Interface'] = CLASSIC_ERA_VER
                elif self.is_classic:
                    if not addon in NOT_WORKING:
                        toc.tags['Interface'] = CLASSIC_VER
                    else:
                        toc.tags['Interface'] = 11307
                else:
                    toc.tags['Interface'] = RETAIL_VER
                toc.tags['Title-zhCN'] = self.get_title(addon)

                ns = {'x': 'https://www.github.com/luhao007'}
                note = config.find('x:Notes', ns)
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
                    process_file(path, functools.partial(process, config, addon))

    ###########################
    # Handle embedded libraries
    ###########################

    def handle_lib_tocs(self):
        toc = TOC([])

        if self.is_classic_era:
            toc.tags['Interface'] = CLASSIC_ERA_VER
        elif self.is_classic:
            toc.tags['Interface'] = CLASSIC_VER
        else:
            toc.tags['Interface'] = RETAIL_VER
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
            toc.contents.append('# LibBabbles\n')
            for l in os.listdir(root / 'LibBabble'):
                if l.endswith('.lua'):
                    toc.contents.append(f'LibBabble\\{l}\n')
                else:
                    d = os.listdir(root / 'LibBabble' / l)
                    if 'lib.xml' in d:
                        toc.contents.append(f'LibBabble\\{l}\\lib.xml\n')
                    elif f'{l}.lua' in d:
                        toc.contents.append(f'LibBabble\\{l}\\{l}.lua\n')
            toc.contents.append('\n')
            libs.discard('LibBabble')

        drs = {lib for lib in libs if lib.startswith('DR')}
        libs -= drs
        if drs:
            toc.contents.append('# DR Libs\n')
            for dr in drs:
                toc.contents.append(f'{dr}\\{dr}.xml\n')
            toc.contents.append('\n')

        luas = {lib for lib in libs if lib.endswith('lua')}
        libs -= luas
        toc.contents.append('# Other Libs\n')
        for lib in sorted(libs):
            d = os.listdir(root / lib)
            if 'lib.xml' in d:
                toc.contents.append(f'{lib}\\lib.xml\n')
            elif f'{lib}.xml' in d:
                toc.contents.append(f'{lib}\\{lib}.xml\n')
            elif f'{lib}.lua' in d:
                toc.contents.append(f'{lib}\\{lib}.lua\n')
            elif lib in d:
                sd = os.listdir(root / lib / lib)
                if f'{lib}.xml' in sd:
                    toc.contents.append(f'{lib}\\{lib}\\{lib}.xml\n')
                elif f'{lib}.lua' in sd:
                    toc.contents.append(f'{lib}\\{lib}\\{lib}.lua\n')
            else:
                raise RuntimeError(f'{lib} not handled!')

        if luas:
            toc.contents.append('\n')
            toc.contents.append('# Custom Luas\n')
            for lua in sorted(luas):
                toc.contents.append(f'{lua}\n')

        with open('Addons/!!Libs/!!Libs.toc', 'w', encoding='utf-8') as f:
            f.writelines(toc.to_lines())

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

            for line in lines[start+1:start+end+1]:
                ret.append('--{}'.format(line))
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

    def _handle_lib_in_libs(self, root):
        for lib in os.listdir(root):
            if not os.path.isdir(root/lib) or lib == 'Ace3':
                continue

            embeds = ['CallbackHandler-1.0', 'LibStub', 'LibStub-1.0', 'HereBeDragons']
            for p in ['libs', 'lib']:
                if os.path.exists(root / lib / p):
                    embeds.append(p)
                    embeds.append(p.capitalize())
                    break

            for embed in embeds:
                rm_tree(root / lib / embed)

            if os.path.exists(root / lib / 'embeds.xml'):
                os.remove(root / lib / 'embeds.xml')
                embeds.append('embeds.xml')

            files = ['lib.xml', f'{lib}.xml', f'{lib}.toc']
            for f in files:
                for p in [root / f, root / lib / f]:
                    if os.path.exists(p):
                        self.remove_libs_in_file(p, embeds)

    def handle_lib_in_libs(self):
        self._handle_lib_in_libs(Path('AddOns/!!Libs'))
        self._handle_lib_in_libs(Path('AddOns/!!Libs/LibBabble'))

    ##########################
    # Handle individual addons
    ##########################

    def handle_dup_libraries(self):
        addons = ['Atlas', 'BlizzMove', 'DBM-Core', 'Details_Streamer',
                  'Details_TinyThreat', 'ExRT', 'GatherMate2', 'GTFO',
                  'HandyNotes', 'ItemRack', 'ItemRackOptions', 'MapSter',
                  'MikScrollingBattleText', 'OmniCC', 'OmniCC_Config',
                  'Quartz', 'RangeDisplay', 'RangeDisplay_Options', 'TellMeWhen', 'TomTom']

        if self.is_retail:
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
            self.remove_libraries_all(addon)

    def handle_acp(self):
        def handle(lines):
            ret = []
            start1 = start2 = 0
            for i, l in enumerate(lines):
                if 'FontString name="$parentTitle"' in l:
                    start1 = i
                elif 'FontString name="$parentStatus"' in l:
                    start2 = i

            ret = lines[:start1+2]
            ret.append(' '*24 + '<AbsDimension x="270" y="12"/>\n')
            ret += lines[start1+3:start2+2]
            ret.append(' '*24 + '<AbsDimension x="90" y="12"/>\n')
            ret += lines[start2+3:]
            return ret

        process_file('Addons/ACP/ACP.xml', handle)

    @available_on(['classic', 'classic_era'])
    def handle_ate(self):
        self.remove_libraries(
                ['CallbackHandler-1.0', 'LibDataBroker-1.1',
                 'LibDbIcon-1.0', 'LibStub'],
                'AddOns/alaTalentEmu/Lib',
                'AddOns/alaTalentEmu/alaTalentEmu.xml'
            )

    def handle_att(self):
        self.change_defaults(
            'Addons/{}/Settings.lua'.format(
                'AllTheThings' if self.is_retail else 'ATT-Classic'),
            ['		["MinimapButton"] = false,',
             '		["Auto:MiniList"] = false,']
        )

    def handle_atlas(self):
        self.change_defaults(
            'AddOns/Atlas/Core/Atlas.lua',
            'addon.LocName = "Atlas"',
        )

        self.change_defaults(
            'Addons/Atlas/Data/Constants.lua',
            '			hide = true,'
        )

    @available_on(['classic', 'classic_era'])
    def handle_atlasloot(self):
        if self.is_retail:
            self.remove_libraries(
                ['CallbackHandler-1.0', 'LibBabble-Boss-3.0',
                 'LibBabble-Faction-3.0', 'LibBabble-ItemSet-3.0',
                 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDialog-1.0',
                 'LibSharedMedia-3.0', 'LibStub'],
                'AddOns/AtlasLoot/Libs',
                'AddOns/AtlasLoot/embeds.xml'
            )
        self.change_defaults(
            'Addons/AtlasLootClassic/db.lua',
            '		shown = true,'
        )

    @available_on(['classic', 'classic_era'])
    def handle_auctioneer(self):
        addons = ['Auc-Advanced', 'BeanCounter', 'Enchantrix', 'Informant']

        for addon in addons:
            rm_tree(Path('AddOns') / addon / 'Libs' / 'LibDataBroker')
            process_file(
                Path('AddOns') / addon / 'Libs' / 'Load.xml',
                lambda lines: [line for line in lines
                               if 'LibDataBroker' not in line]
            )

        rm_tree('AddOns/SlideBar/Libs')
        process_file(
            'AddOns/SlideBar/Load.xml',
            lambda lines: [line for line in lines if 'Libs' not in line]
        )

    def handle_bagnon(self):
        rm_tree('AddOns/Bagnon/common/LibDataBroker-1.1')
        process_file(
            'AddOns/Bagnon/AddOns/main/main.xml',
            lambda lines: [line for line in lines
                           if 'LibDataBroker' not in line]
        )

        self.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0',
             'CallbackHandler-1.0', 'LibStub'],
            'AddOns/Bagnon/common/Wildpants/libs',
            'AddOns/Bagnon/common/Wildpants/libs/libs.xml'
        )

    @available_on(['retail'])
    def handle_btwquest(self):
        def f(lines):
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

        process_file('Addons/BtWQuests/BtWQuests.lua', f)

    def handle_dcs(self):
        self.change_defaults(
            'AddOns/Deja{}Stats/DCSDuraRepair.lua'.format(
                'Character' if self.is_retail else 'Classic'),
            ['	ShowDuraSetChecked = false,',
             '	ShowItemRepairSetChecked = false,',
             '	ShowItemLevelSetChecked = false,',
             '	ShowEnchantSetChecked = false,']
        )

    def handle_decursive(self):
        for lib in os.listdir('AddOns/Decursive/Libs'):
            if lib == 'BugGrabber':
                continue

            rm_tree(Path('AddOns/Decursive/Libs') / lib)

        process_file(
            'AddOns/Decursive/embeds.xml',
            lambda lines: [line for line in lines
                           if 'Libs' not in line or 'BugGrabber' in line]
        )

    def handle_details(self):
        libs = ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
                'AceGUI-3.0', 'AceHook-3.0', 'AceLocale-3.0', 'AceSerializer-3.0',
                'AceTab-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',  'LibBossIDs-1.0',
                'LibCompress', 'LibClassicCasterino', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
                'LibDeflate', 'LibGraph-2.0', 'LibGroupInSpecT-1.1', 'LibItemUpgradeInfo-1.0',
                'LibSharedMedia-3.0', 'LibStub', 'LibWindow-1.1', 'NickTag-1.0']
        if self.is_retail:
            libs += ['DF', 'LibTranslit-1.0']

        self.remove_libraries(libs, 'Addons/Details/Libs', 'Addons/Details/Libs/libs.xml')

        self.change_defaults(
            'Addons/Details/functions/profiles.lua',
            ('		minimap = {hide = true, radius = 160, minimapPos = 220, '
             'onclick_what_todo = 1, text_type = 1, text_format = 3},'),
        )

        self.change_defaults(
            'Addons/Details_Streamer/Details_Streamer.lua',
            '					minimap = {hide = true, radius = 160, minimapPos = 160},',
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

    @available_on(['classic', 'classic_era'])
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

    @available_on(['classic', 'classic_era'])
    def handle_goodleader(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceDB-3.0',
             'AceEvent-3.0', 'AceHook-3.0', 'AceLocale-3.0',
             'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
             'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibStub'],
            'AddOns/GoodLeader/Libs',
            'AddOns/GoodLeader/Libs/Libs.xml'
        )

        rm_tree('Addons/GoodLeader/Libs/tdGUI/Libs')
        self.remove_libs_in_file('Addons/GoodLeader/Libs/tdGUI/Load.xml',
                                 ['Libs'])

    @available_on(['retail'])
    def handle_grail(self):
        for folder in os.listdir('AddOns'):
            if 'Grail' not in folder:
                continue

            if (('NPCs' in folder or 'Quests' in folder) and
               not folder.endswith('_') and
               ('enUS' not in folder and 'zhCN' not in folder)):
                rm_tree(Path('AddOns') / folder)

            if ((self.is_retail and 'classic' in folder) or
                (not self.is_retail and
                 ('retail' in folder or 'Achievements' in folder))):
                rm_tree(Path('AddOns') / folder)

    @available_on(['classic', 'classic_era'])
    def handle_nwb(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceComm-3.0', 'AceConfig-3.0', 'AceConsole-3.0',
             'AceDB-3.0', 'AceDBOptions-3.0', 'AceGUI-3.0',
             'AceGUI-3.0-SharedMediaWidgets', 'AceLocale-3.0',
             'AceSerializer-3.0', 'CallbackHandler-1.0', 'HereBeDragons',
             'LibCandyBar-3.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDeflate',
             'LibSharedMedia-3.0', 'LibStub'],
            'Addons/NovaWorldBuffs/Lib',
            'Addons/NovaWorldBuffs/embeds.xml',
        )

    @available_on(['retail'])
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

        self.change_defaults(
            'Addons/MeetingStone/Profile.lua',
            '            minimap = { hide = true,'
        )

    @available_on(['classic', 'classic_era'])
    def handle_meetinghorn(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceComm-3.0', 'AceConfig-3.0',
             'AceDB-3.0', 'AceEvent-3.0', 'AceGUI-3.0', 'AceHook-3.0',
             'AceLocale-3.0', 'AceSerializer-3.0', 'AceTimer-3.0',
             'CallbackHandler-1.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
             'LibStub'],
            'Addons/MeetingHorn/Libs',
            'Addons/MeetingHorn/Libs/Libs.xml'
        )

        rm_tree('Addons/MeetingHorn/Libs/tdGUI/Libs')
        self.remove_libs_in_file('Addons/MeetingHorn/Libs/tdGUI/Load.xml',
                                 ['Libs'])

    @available_on(['classic', 'classic_era'])
    def handle_merinspect(self):
        self.change_defaults(
            'Addons/MerInspect/Options.lua',
            ['    ShowCharacterItemSheet = false,          --玩家自己裝備列表',
             '    ShowCharacterItemStats = false,          --玩家自己屬性統計']
        )

    @available_on(['retail'])
    def handle_mogit(self):
        self.remove_libraries(
            ['AceConfig-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceGUI-3.0',
             'CallbackHandler-1.0', 'LibBabble-Boss-3.0',
             'LibBabble-Inventory-3.0', 'LibBabble-Race-3.0', 'LibDBIcon-1.0',
             'LibDataBroker-1.1', 'LibStub'],
            'Addons/MogIt/Libs',
            'Addons/MogIt/Libs/Embeds.xml'
        )

        self.change_defaults(
            'Addons/Mogit/Core/Core.lua',
            '		minimap = { hide = true },'
        )

    def handle_monkeyspeed(self):
        process_file(
            'AddOns/MonkeySpeed/MonkeySpeedInit.lua',
            lambda lines: [line.replace(
                              'GetAddOnMetadata("MonkeySpeed", "Title")',
                              '"MonkeySpeed"'
                           ) if '"Title"' in line else line
                           for line in lines]
        )

    def handle_myslot(self):
        self.remove_libraries(
            ['CallbackHandler-1.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibStub'],
            'Addons/Myslot/libs',
            'Addons/Myslot/Myslot.toc'
        )

    def handle_omnicc(self):
        process_file(
            'AddOns/OmniCC/core/core.xml',
            lambda lines: [line for line in lines if 'libs' not in line]
        )

    @available_on(['retail'])
    def handle_omen(self):
        self.change_defaults(
            'Addons/Omen/Omen.lua',
            '			hide = true,'
        )

    @available_on(['retail'])
    def handle_oa(self):
        self.remove_libraries(
            ['CallbackHandler-1.0', 'LibBabble-Inventory-3.0',
             'LibBabble-SubZone-3.0', 'LibSharedMedia-3.0', 'LibStub'],
            'Addons/Overachiever/libs',
            'Addons/Overachiever/Overachiever.toc'
        )

        process_file(
            'Addons/Overachiever/Overachiever.lua',
            lambda lines: [line.replace(
                'GetAddOnMetadata("Overachiever", "Title")',
                '"Overarchiever"'
            ) for line in lines]
        )

    def handle_plater(self):
        libs = ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
                'AceGUI-3.0', 'AceLocale-3.0', 'AceSerializer-3.0',
                'AceTimer-3.0', 'CallbackHandler-1.0', 'LibCompress',
                'LibClassicCasterino', 'LibClassicDurations', 'LibCustomGlow-1.0',
                'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDeflate',
                'LibRangeCheck-2.0', 'LibSharedMedia-3.0', 'LibStub']
        if self.is_retail:
            libs += ['DF', 'LibTranslit-1.0']

        self.remove_libraries(libs, 'Addons/Plater/libs', 'Addons/Plater/libs/libs.xml')

    @available_on(['retail'])
    def handle_pt(self):
        self.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0', 'CallbackHandler-1.0',
             'LibPetJournal-2.0', 'LibStub'],
            'Addons/PetTracker/libs',
            'Addons/PetTracker/libs/main.xml'
        )

    def handle_prat(self):
        rm_tree('AddOns/Prat-3.0_Libraries')

    @available_on(['classic', 'classic_era'])
    def handle_questie(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
             'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
             'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets', 'AceHook-3.0',
             'AceLocale-3.0', 'AceSerializer-3.0', 'AceTab-3.0',
             'AceTimer-3.0', 'CallbackHandler-1.0', 'LibCompress',
             'LibDataBroker-1.1', 'LibDBIcon-1.0', 'LibSharedMedia',
             'LibStub'],
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

        process_file(root / 'Modules/Libs/QuestieLib.lua', handle)

    @available_on(['classic', 'classic_era'])
    def handle_rl(self):
        self.remove_libraries(
            ['CallbackHandler-1.0', 'LibDBIcon-1.0', 'LibDataBroker-1.1',
             'LibStub'],
            'Addons/RaidLedger/lib',
            'Addons/RaidLedger/RaidLedger.toc'
        )

    @available_on(['retail'])
    def handle_rarity(self):
        self.remove_libraries(
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

    def handle_scrap(self):
        self.remove_libraries(
            ['AceEvent-3.0', 'AceLocale-3.0',
             'CallbackHandler-1.0', 'LibStub'],
            'AddOns/Scrap/libs',
            'AddOns/Scrap/libs/main.xml'
        )

    @available_on(['retail'])
    def handle_sc(self):
        self.change_defaults(
            'Addons/Simulationcraft/core.lua',
            '        hide = true,'
        )

    @available_on(['retail'])
    def handle_talentsm(self):
        self.remove_libraries(
            ['CallBackHandler', 'LibDataBroker', 'LibStub'],
            'AddOns/TalentSetManager/libs',
            'AddOns/TalentSetManager/libs/libs.xml'
        )

    def handle_titan(self):
        path = 'Addons/Titan{0}Location/Titan{0}Location.lua'.format(
            '' if self.is_retail else 'Classic')
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
            'AddOns/TradeSkillMaster/TradeSkillMaster.toc',
            lambda lines: [line for line in lines
                           if 'EmbeddedLibs' not in line]
        )

    def handle_ufp(self):
        if self.is_classic_era:
            rm_tree('AddOns/UnitFramesPlus_MobHealth')

            self.remove_libraries_all('UnitFramesPlus_Cooldown')

        def f(lines):
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

        process_file('Addons/UnitFramesPlus/UnitFramesPlus.lua', f)


    def handle_vuhdo(self):
        self.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
             'AceEvent-3.0', 'AceGUI-3.0', 'AceLocale-3.0',
             'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
             'LibClassicDurations', 'LibCompress', 'LibCustomGlow-1.0',
             'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibSharedMedia-3.0',
             'LibStub', 'LibThreatClassic2', 'NickTag-1.0', 'UTF8'],
            'Addons/VuhDo/Libs',
            'Addons/VuhDo/Libs/Libs.xml'
        )

        if not self.is_retail:
            rm_tree('Addons/Vuhdo/Libs/!LibTotemInfo/LibStub')
            self.remove_libs_in_file(
                'Addons/Vuhdo/Libs/!LibTotemInfo/embeds.xml',
                ['LibStub']
            )
        rm_tree('Addons/Vuhdo/Libs/LibBase64-1.0/LibStub')

        self.change_defaults(
            'Addons/VuhDo/VuhDoDefaults.lua',
            '	["SHOW_MINIMAP"] = false,'
        )

    def handle_wa(self):
        self.remove_libraries(
            ['AceComm-3.0', 'AceConfig-3.0', 'AceConsole-3.0', 'AceEvent-3.0',
             'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets',
             'AceSerializer-3.0', 'AceTimer-3.0', 'CallbackHandler-1.0',
             'LibCustomGlow-1.0', 'LibCompress', 'LibDBIcon-1.0', 'LibDataBroker-1.1', 'LibDeflate',
             'LibGetFrame-1.0', 'LibRangeCheck-2.0', 'LibSharedMedia-3.0',
             'LibSerialize', 'LibSpellRange-1.0', 'LibStub'],
            'Addons/WeakAuras/Libs',
            'Addons/WeakAuras/embeds.xml'
        )

        self.remove_libraries(
            ['LibClassicCasterino', 'LibClassicDurations', 'LibClassicSpellActionCount-1.0', ],
            'Addons/WeakAuras/Libs',
            'Addons/WeakAuras/WeakAuras.toc'
        )

        self.remove_libraries_all('WeakAuras/Libs/Archivist')

        self.change_defaults(
            'Addons/WeakAuras/WeakAuras.lua',
            '      db.minimap = db.minimap or { hide = true };'
        )

    @available_on(['classic', 'classic_era'])
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
