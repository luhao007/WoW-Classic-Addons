import functools
import logging
import os
import shutil
from pathlib import Path

from defusedxml import ElementTree

import utils
from toc import TOC

logger = logging.getLogger('manager')

CLASSIC_ERA_VER = '11401'
CLASSIC_VER = '30400'
RETAIL_VER = '110000'


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
            if func.startswith('handle') and not func.startswith('handle_lib'):
                getattr(self, func)()

        self.process_toc()

    def process_libs(self):
        for func in dir(self):
            if func.startswith('handle_lib'):
                getattr(self, func)()

        self.process_lib_tocs()

    @functools.lru_cache
    def get_addon_config(self, addon):
        return self.config.find(f'.//*[@name="{addon}"]')

    @functools.lru_cache
    def get_addon_parent_config(self, addon):
        return self.config.find(f'.//*[@name="{addon}"]../..')

    def get_title(self, addon):
        parts = []

        config = self.get_addon_config(addon)
        if config.tag.endswith('SubAddon'):
            parent_config = self.get_addon_parent_config(addon)
            cat = parent_config.find('Category').text
            title = parent_config.find('Title').text
        else:
            cat = config.find('Category').text
            title = config.find('Title').text

        colors = {
            '基础库': 'C41F3B',     # Red - DK
            '任务': '00FF96',       # Spring green - Monk
            '专业': '0070DE',       # Doget blue - Shaman
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
        parts.append(f'|cFFFFE00A<|r|cFF{color}{cat}|r|cFFFFE00A>|r')

        parts.append(f'|cFFFFFFFF{title}|r')

        if config.tag.endswith('SubAddon'):
            sub = config.find('Title').text
            if sub == '设置':
                color = 'FF0055FF'
            else:
                color = 'FF69CCF0'
            parts.append(f'|c{color}{sub}|r')
        elif not (('DBM' in addon and addon != 'DBM-Core') or
                  'Grail-' in addon or
                  addon == '!!Libs'):
            if config.find('Title-en') is not None:
                title_en = config.find('Title-en').text
            else:
                title_en = addon
            parts.append(f'|cFFFFE00A{title_en}|r')

        ext = config.find('TitleExtra')
        if ext is not None:
            parts.append(f'|cFF22B14C{ext.text}|r')

        return ' '.join(parts)

    def process_toc(self):
        for addon in os.listdir('AddOns'):
            config = self.get_addon_config(addon)
            if not config:
                for file in os.listdir(os.path.join('AddOns', addon)):
                    if '.toc' in file:
                        logger.warning('%s not found!', addon)
                        break
                continue

            def process(config, addon, lines):
                toc = TOC(lines)

                toc.tags['Interface'] = self.interface
                toc.tags['Title-zhCN'] = self.get_title(addon)

                note = config.find('Notes')
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

            for postfix in utils.TOCS:
                path = os.path.join('AddOns', addon, f'{addon}{postfix}')
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
                        'LibDeflate\\lib.xml\n',
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
                        '\n']

        root = Path('Addons/!!Libs')
        libs = set(os.listdir(root))
        libs -= {'!!Libs.toc', 'Ace3', 'AceGUI-3.0-SharedMediaWidgets', 'HereBeDragons', 'UTF8', 'FrameXML',
                 '!LibUIDropDownMenu', '!LibUIDropDownMenu-2.0', 'LibCompress', 'LibDeflate',
                 'LibDataBroker-1.1', 'LibSharedMedia-3.0'}

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
            if lib == 'textures':
                continue
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
                ret.append(f'--{line}')
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
        ignores = ['!!Libs', 'Questie', 'RareScanner']
        addons = [addon for addon in os.listdir('AddOns') if addon not in ignores]
        for addon in addons:
            utils.remove_libraries_all(addon)

    # @staticmethod
    # def handle_att():
    #     addon = 'AllTheThings'
    #     utils.change_defaults(
    #         f'Addons/{addon}/Settings.lua',
    #         ['		["MinimapButton"] = false,',
    #             '		["Auto:MiniList"] = false,']
    #     )

    @staticmethod
    def handle_atlas():
        utils.change_defaults(
            'Addons/Atlas/Data/Constants.lua',
            '			hide = true,'
        )

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_atlasloot():
        utils.change_defaults(
            'Addons/AtlasLootClassic/db.lua',
            '			shown = false,'
        )

    @staticmethod
    @available_on(['classic', 'retail'])
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
    def handle_details():
        utils.change_defaults(
            'Addons/Details/functions/profiles.lua',
            ('		minimap = {hide = true, radius = 160, minimapPos = 220, '
                'onclick_what_todo = 1, text_type = 1, text_format = 3},'),
        )

        if os.path.exists('Addons/Details_Streamer'):
            utils.change_defaults(
                'Addons/Details_Streamer/Details_Streamer.lua',
                '					minimap = {hide = true, radius = 160, minimapPos = 160},',
            )

    @staticmethod
    def handle_fb():
        if not os.path.exists('Addons/FishingBuddy/'):
            return
        utils.change_defaults(
            'Addons/FishingBuddy/FishingBuddyMinimap.lua',
            '		FishingBuddy_Player["MinimapData"] = { hide=true };'
        )

    @staticmethod
    @available_on(['classic_era'])
    def handle_goodleader():
        utils.rm_tree('Addons/GoodLeader/Libs/tdGUI/Libs')
        utils.remove_libs_in_file('Addons/GoodLeader/Libs/tdGUI/Load.xml',
                                    ['Libs'])

    @staticmethod
    def handle_grail():
        for folder in os.listdir('AddOns'):
            if 'Grail' not in folder:
                continue

            local = folder[-4:]
            if local in ['deDE', 'esES', 'esMX', 'frFR', 'itIT', 'koKR', 'ptBR', 'ruRU', 'zhTW']:
                utils.rm_tree(Path('Addons') / folder)

    @staticmethod
    @available_on(['retail'])
    def handle_meetingstone():
        if not os.path.exists('Addons/MeetingStone'):
            return
        utils.change_defaults(
            'Addons/MeetingStone/Profile.lua',
            '            minimap = { hide = true,'
        )

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_meetinghorn():
        if not os.path.exists('Addons/MeetingHorn'):
            return
        utils.rm_tree('Addons/MeetingHorn/Libs/tdGUI/Libs')
        utils.remove_libs_in_file('Addons/MeetingHorn/Libs/tdGUI/Load.xml',
                                    ['Libs'])

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_merinspect():
        if not os.path.exists('Addons/MerInspect'):
            return
        utils.change_defaults(
            'Addons/MerInspect/Options.lua',
            ['    ShowCharacterItemSheet = false,          --玩家自己裝備列表',
                '    ShowCharacterItemStats = false,          --玩家自己屬性統計']
        )

    @staticmethod
    def handle_monkeyspeed():
        if not os.path.exists('Addons/MonkeySpeed'):
            return

        utils.process_file(
            'AddOns/MonkeySpeed/MonkeySpeedInit.lua',
            lambda lines: [line.replace(
                                'GetAddOnMetadata("MonkeySpeed", "Title")',
                                '"MonkeySpeed"'
                            ) if '"Title"' in line else line
                            for line in lines]
        )

    @staticmethod
    @available_on(['classic'])
    def handle_omnicc():
        utils.process_file(
            'AddOns/OmniCC/core/core.xml',
            lambda lines: [line for line in lines if 'libs' not in line]
        )

    @staticmethod
    @available_on(['retail', 'classic'])
    def handle_oa():
        if not os.path.exists('Addons/Overachiever'):
            return
        utils.process_file(
            'Addons/Overachiever/Overachiever.lua',
            lambda lines: [line.replace(
                'GetAddOnMetadata("Overachiever", "Title")',
                '"Overarchiever"'
            ) for line in lines]
        )

    @staticmethod
    def handle_prat():
        utils.rm_tree('AddOns/Prat-3.0_Libraries')
        utils.remove_libs_in_file('Addons/Prat-3.0/Libs.xml',
                                    ['Libs'])

    @staticmethod
    @available_on(['classic', 'classic_era'])
    def handle_questie():
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceBucket-3.0', 'AceComm-3.0', 'AceConfig-3.0',
                'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0', 'AceEvent-3.0',
                'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets', 'AceHook-3.0',
                'AceLocale-3.0', 'AceSerializer-3.0', 'AceTab-3.0',
                'AceTimer-3.0', 'CallbackHandler-1.0', 'Krowi_WorldMapButtons',
                'LibCompress',
                'LibDataBroker-1.1', 'LibDBIcon-1.0', 'LibSharedMedia', 'LibSharedMedia-3.0', 'LibStub'],
            'AddOns/Questie/Libs',
            'AddOns/Questie/embeds.xml'
        )

        if utils.get_platform() == 'classic_era':
            for postfix in ['', '-BCC']:
                utils.remove_libraries([ 'LibUIDropDownMenu'], 'AddOns/Questie/Libs', f'AddOns/Questie/Questie{postfix}.toc')

        root = Path('AddOns/Questie')
        with open(root / 'Questie-WOTLKC.toc', 'r', encoding='utf-8') as file:
            lines = file.readlines()

        toc = TOC(lines)

        version = toc.tags['Version']
        major, minor, patch = version.split(' ')[0].split('.')
        major = major.replace('v', '')

        def handle(lines):
            func = 'function QuestieLib:GetAddonVersionInfo()'
            start = 0
            for i, line in enumerate(lines):
                if line.startswith(func):
                    start = i
                    break

            ret = lines[:start+1]
            ret.append(f'    return {major}, {minor}, {patch}\n')
            ret.append('end\n')
            end = lines[start:].index('end\n')

            if not lines[start+1].strip().startswith('return'):
                for line in lines[start+1:start+end+1]:
                    ret.append(f'--{line}')

            ret += lines[start+end+1:]
            return ret

        utils.process_file(root / 'Modules/Libs/QuestieLib.lua', handle)

        utils.change_defaults(
            'AddOns/Questie/Modules/Network/QuestieComms.lua',
            f'    pkt.data.ver = "{major}.{minor}.{patch}";'
        )

    @staticmethod
    @available_on(['retail'])
    def handle_rarity():
        utils.remove_libraries(['HereBeDragons-2.0'], 'AddOns/Rarity/Libs', 'AddOns/Rarity/Rarity.toc')

    @staticmethod
    @available_on(['classic'])
    def handle_rl():
        utils.change_defaults(
            'AddOns/RaidLedger/options.lua',
            ['        b:SetChecked(Database:GetConfigOrDefault("minimapicon", false))']
        )

    @staticmethod
    @available_on(['classic'])
    def handle_rs():
        utils.change_defaults(
            'AddOns/RareScanner/Core/Libs/RSConstants.lua',
            ['				hide = true']
        )
        utils.remove_libraries(
            ['AceAddon-3.0', 'AceConfig-3.0',
                'AceConsole-3.0', 'AceDB-3.0', 'AceDBOptions-3.0',
                'AceGUI-3.0', 'AceGUI-3.0-SharedMediaWidgets',
                'AceLocale-3.0', 'AceSerializer-3.0', 'CallbackHandler-1.0', 'HereBeDragons',
                'LibDBIcon-1.0', 'LibDialog-1.0-9.0.1.1', 'LibSharedMedia-3.0', 'LibStub', 'LibTime-1.0'],
            'AddOns/RareScanner/ExternalLibs',
            'AddOns/RareScanner/ExternalLibs/Libs.xml'
        )

    @staticmethod
    @available_on(['retail'])
    def handle_sc():
        utils.change_defaults(
            'Addons/Simulationcraft/core.lua',
            '        hide = true,'
        )

    @staticmethod
    @available_on(['classic'])
    def handle_talentemu():
        utils.change_defaults(
            'AddOns/TalentEmu/setting.lua',
            ['		minimap = false,']
        )

    @staticmethod
    def handle_titan():
        addon = 'TitanLocation'
        utils.change_defaults(
            f'Addons/{addon}/{addon}.lua',
            ['			ShowCoordsOnMap = false,',
                '			ShowCursorOnMap = false,']
        )
        utils.rm_tree('Addons/Titan/Libs')
        utils.remove_libs_in_file('Addons/Titan/Titan_Mainline.toc',
                                    ['Libs'])
        utils.remove_libs_in_file('Addons/TitanClassic/TitanClassic_Cata.toc',
                                    ['Libs'])
        utils.remove_libs_in_file('Addons/TitanClassic/TitanClassic_Vanilla.toc',
                                    ['Libs'])
        utils.remove_libs_in_file('Addons/TitanClassic/TitanClassic_Wrath.toc',
                                    ['Libs'])

    @staticmethod
    def handle_tomtom():
        utils.change_defaults(
            'Addons/TomTom/TomTom.lua',
            ['                playerenable = false,',
                '                cursorenable = false,']
        )

    @staticmethod
    def handle_tsm():
        if not os.path.exists('Addons/TradeSkillMaster'):
            return
        utils.rm_tree('AddOns/TradeSkillMaster/External/EmbeddedLibs/')

        utils.process_file(
            'AddOns/TradeSkillMaster/TradeSkillMaster.toc',
            lambda lines: [line for line in lines
                            if 'EmbeddedLibs' not in line]
        )

        # utils.change_defaults(
        #     'AddOns/TradeSkillMaster/LibTSM/Service/Settings.lua',
        #     ['			minimapIcon = { type = "table", default = { hide = true, minimapPos = 220, radius = 80 }, lastModifiedVersion = 10 },']
        # )

    @staticmethod
    def handle_ufp():
        if not os.path.exists('Addons/UnitFramesPlus'):
            return
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
    @available_on(['classic'])
    def handle_vuhdo():
        utils.rm_tree('Addons/Vuhdo/Libs/LibBase64-1.0/LibStub')

        utils.change_defaults(
            'Addons/VuhDo/VuhDoDefaults.lua',
            '	["SHOW_MINIMAP"] = false,'
        )

    @staticmethod
    def handle_wa():
        utils.remove_libraries_all('WeakAuras/Libs/Archivist')
        utils.remove_libraries(['LibClassicSpellActionCount-1.0', 'LibClassicCasterino'],
                                'AddOns/WeakAuras/Libs/',
                                'AddOns/WeakAuras/WeakAuras_Vanilla.toc')

        utils.change_defaults(
            'Addons/WeakAuras/WeakAuras.lua',
            '      db.minimap = db.minimap or { hide = true };'
        )


    @staticmethod
    def handle_whlooter():
        utils.change_defaults(
            'Addons/+Wowhead_Looter/Wowhead_Looter.lua',
            'wlSetting = {minimap=false};'
        )
