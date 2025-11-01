import functools
import os
import shutil
from collections.abc import Callable, Iterable
from pathlib import Path
from xml.etree import ElementTree

import utils
from toc import TOC
from utils import PLATFORM, Color, get_logger

logger = get_logger("AddonManager")

CLASSIC_ERA_VER = "11401"
CLASSIC_VER = "50502"
RETAIL_VER = "110205"


def available_on(
    platforms: list[PLATFORM],
) -> Callable[..., Callable[..., None]]:
    def decorator(func: Callable[..., None]) -> Callable[..., None]:
        def wrapper() -> None:
            platform = utils.get_platform()
            if platform in platforms:
                func()

        return wrapper

    return decorator


def lib_babble_to_toc() -> list[str]:
    ret: list[str] = []
    root = Path("Addons/!!Libs")
    if os.path.exists(root / "LibBabble"):
        ret.append("# LibBabbles\n")
        for lib in os.listdir(root / "LibBabble"):
            if lib.endswith(".lua"):
                ret.append(f"LibBabble\\{lib}\n")
            else:
                subdir = os.listdir(root / "LibBabble" / lib)
                if "lib.xml" in subdir:
                    ret.append(f"LibBabble\\{lib}\\lib.xml\n")
                elif f"{lib}.lua" in subdir:
                    ret.append(f"LibBabble\\{lib}\\{lib}.lua\n")
        ret.append("\n")

    return ret


class Manager:

    def __init__(self):
        """Addon manager."""
        self.config = ElementTree.parse("config.xml")

        if utils.get_platform() == "classic_era":
            self.interface = CLASSIC_ERA_VER
        elif utils.get_platform() == "classic":
            self.interface = CLASSIC_VER
        else:
            self.interface = RETAIL_VER

    def process(self):
        for func in dir(self):
            if func.startswith("handle") and not func.startswith("handle_lib"):
                getattr(self, func)()

        self.process_toc()

    def process_libs(self):
        for func in dir(self):
            if func.startswith("handle_lib"):
                getattr(self, func)()

        self.process_custom_luas()
        self.process_lib_tocs()

    @functools.lru_cache
    def get_addon_config(self, addon: str) -> ElementTree.Element:
        config = self.config.find(f'.//*[@name="{addon}"]')
        if config is None:
            raise ValueError(f"Addon config for {addon} not found!")
        return config

    @functools.lru_cache
    def get_addon_parent_config(self, addon: str) -> ElementTree.Element:
        config = self.config.find(f'.//*[@name="{addon}"]../..')
        if config is None:
            raise ValueError(f"Parent config for {addon} not found!")
        return config

    def _get_text_from_xml(
        self, xml: ElementTree.Element, tag: str, default: str = ""
    ) -> str:
        element = xml.find(tag)
        if element is None:
            return default
        return element.text if element.text else default

    def get_category(self, addon: str) -> str:
        config = self.get_addon_config(addon)
        if config.tag.endswith("SubAddon"):
            parent_config = self.get_addon_parent_config(addon)
            cat = self._get_text_from_xml(parent_config, "Category")
        else:
            cat = self._get_text_from_xml(config, "Category")

        colors = {
            "基础库": "C41F3B",  # Red - DK
            "任务": "00FF96",  # Spring green - Monk
            "专业": "0070DE",  # Doget blue - Shaman
            "界面": "A330C9",  # Dark Magenta - DH
            "副本": "FF7D0A",  # Orange - Druid
            "战斗": "C79C6E",  # Tan - Warrior
            "PVP": "8787ED",  # Purple - Warlock
            "探索": "40C7EB",  # Light Blue - Mage
            "收藏": "A9D271",  # Green - Hunter
            "社交": "F48CBA",  # Pink - Paladin
            "功能": "FFF468",  # Yellow - Rogue
            "辅助": "FFFFFF",  # White - Priest
        }
        color = colors.get(cat, "FFF569")  # Unknown defaults to Rogue Yellow
        return f"|cFFFFE00A<|r|cFF{color}{cat}|r|cFFFFE00A>|r"

    def get_title(self, addon: str) -> str:
        parts: list[str] = []

        config = self.get_addon_config(addon)
        if config.tag.endswith("SubAddon"):
            parent_config = self.get_addon_parent_config(addon)
            title = self._get_text_from_xml(parent_config, "Title")
        else:
            title = self._get_text_from_xml(config, "Title")

        parts.append(f"|cFFFFFFFF{title}|r")

        if config.tag.endswith("SubAddon"):
            sub = self._get_text_from_xml(config, "Title")
            if sub == "设置":
                color = "FF0055FF"
            else:
                color = "FF69CCF0"
            parts.append(f"|c{color}{sub}|r")
        elif not (
            ("DBM" in addon and addon != "DBM-Core")
            or "Grail-" in addon
            or addon == "!!Libs"
        ):
            title_en = self._get_text_from_xml(config, "Title-en", addon)
            parts.append(f"|cFFFFE00A{title_en}|r")

        ext = config.find("TitleExtra")
        if ext is not None:
            parts.append(f"|cFF22B14C{ext.text}|r")

        return " ".join(parts)

    def process_toc(self):
        for addon in os.listdir("AddOns"):
            try:
                config = self.get_addon_config(addon)
            except ValueError:
                for file in os.listdir(os.path.join("AddOns", addon)):
                    if ".toc" in file:
                        logger.warning(
                            f"{Color.GREEN}%s {Color.RED}not found!{Color.RESET}", addon
                        )
                        break
                continue

            def process(
                config: ElementTree.Element, addon: str, lines: Iterable[str]
            ) -> Iterable[str]:
                toc = TOC(lines)

                toc.tags["Interface"] = self.interface
                toc.tags["Title-zhCN"] = self.get_category(addon) + self.get_title(
                    addon
                )

                note = self._get_text_from_xml(config, "Notes")
                if note != "":
                    toc.tags["Notes-zhCN"] = note

                toc.tags["Category-zhCN"] = self.get_category(addon)

                if config.tag.endswith("SubAddon"):
                    parent_config = self.get_addon_parent_config(addon)
                    parent_name = parent_config.get("name")
                    if parent_name is None:
                        raise ValueError(f"Parent name for {addon} not found!")
                    toc.tags["X-Part-Of"] = parent_name
                    if (
                        # DBM actually depends on DBM-StatusBarTimers, not the opposite
                        addon != "DBM-StatusBarTimers"
                        # MasterPlanA is just a separate part of MasterPlan
                        and addon != "MasterPlanA"
                        and toc.tags.get("Dependencies", "") == ""
                        and toc.tags.get("RequiredDeps", "") == ""
                    ):
                        toc.tags["RequiredDeps"] = parent_name
                elif addon in ["DBM-Core", "Auc-Advanced", "TomCats"]:
                    toc.tags["X-Part-Of"] = addon
                elif addon in ["+Wowhead_Looter"]:
                    toc.tags.pop("X-Part-Of", None)

                return toc.to_lines()

            for postfix in utils.TOCS:
                path = os.path.join("AddOns", addon, f"{addon}{postfix}")
                if os.path.exists(path):
                    utils.process_file(path, functools.partial(process, config, addon))

    def process_custom_luas(self):
        lines = ['local media = LibStub("LibSharedMedia-3.0")\n', "\n"]

        root = Path("AddOns/!!Libs/SharedMedia/")
        p = "Interface\\\\AddOns\\\\!!Libs\\\\SharedMedia"

        lines += ["-- Add textures\n", "\n"]
        for texture in os.listdir(root / "textures"):
            t = texture.split(".")[0]
            lines.append(
                f'media:Register(media.MediaType.STATUSBAR, "{t}",'
                f' "{p}\\\\textures\\\\{t}.tga")\n'
            )

        lines += ["\n", "-- Add fonts\n", "\n"]

        for texture in os.listdir(root / "fonts"):
            t = texture.split(".")[0]
            lines.append(
                f'media:Register(media.MediaType.FONT, "{t}",'
                f' "{p}\\\\fonts\\\\{t}.ttf", media.LOCALE_BIT_zhCN)\n'
            )

        with open("AddOns/!!Libs/sharedmedia.lua", "w", encoding="utf-8") as file:
            file.writelines(lines)

    def process_lib_tocs(self):
        toc = TOC([])

        toc.tags["Interface"] = self.interface
        toc.tags["Author"] = "luhao007"

        toc.tags["Title"] = "Libraries"
        toc.tags["Notes"] = "Libraries"
        toc.tags["Title-zhCN"] = (
            "|cFFFFE00A<|r|cFFC41F3B基础库|r|cFFFFE00A>|r"
            " |cFFFFFFFF|cFF7FFF7FACE核心库|r |cFFFF0000必须加载|r|r"
        )
        toc.tags["Notes-zhCN"] = "插件基础函数库|N|CFFFF0000必须加载|R"

        toc.tags["Category"] = (
            f"|cFFFFE00A*<|r|cFFC41F3B基础库|r|cFFFFE00A>|r |cFFFF0000必须加载|r"
        )
        toc.tags["IconTexture"] = "Interface\\Icons\\INV_Misc_Bag_10_Black"

        toc.contents = [
            "# Common Handler Libs\n",
            "Ace3\\LibStub\\LibStub.lua\n",
            "Ace3\\CallbackHandler-1.0\\CallbackHandler-1.0.xml\n",
            "LibDataBroker-1.1\\LibDataBroker-1.1.lua\n",
            "\n",
            "# Ace3 Libs\n",
            "Ace3\\AceAddon-3.0\\AceAddon-3.0.xml\n",
            "Ace3\\AceEvent-3.0\\AceEvent-3.0.xml\n",
            "Ace3\\AceTimer-3.0\\AceTimer-3.0.xml\n",
            "Ace3\\AceBucket-3.0\\AceBucket-3.0.xml\n",
            "Ace3\\AceHook-3.0\\AceHook-3.0.xml\n",
            "Ace3\\AceDB-3.0\\AceDB-3.0.xml\n",
            "Ace3\\AceDBOptions-3.0\\AceDBOptions-3.0.xml\n",
            "Ace3\\AceLocale-3.0\\AceLocale-3.0.xml\n",
            "Ace3\\AceGUI-3.0\\AceGUI-3.0.xml\n",
            "Ace3\\AceConsole-3.0\\AceConsole-3.0.xml\n",
            "Ace3\\AceConfig-3.0\\AceConfig-3.0.xml\n",
            "Ace3\\AceComm-3.0\\AceComm-3.0.xml\n",
            "Ace3\\AceTab-3.0\\AceTab-3.0.xml\n",
            "Ace3\\AceSerializer-3.0\\AceSerializer-3.0.xml\n",
            "\n",
            "# Ace3 Additional Libs\n",
            "LibSharedMedia-3.0\\lib.xml\n",
            "AceGUI-3.0-SharedMediaWidgets\\AceGUI-3.0-SharedMediaWidgets\\widget.xml\n",
            "\n",
            "# Libs Needs to be Imported before Other Libs\n",
            "LibCompress\\lib.xml\n",
            "LibDeflate\\lib.xml\n",
            "UTF8\\utf8data.lua\n",
            "UTF8\\utf8.lua\n",
            "\n",
            "# HereBeDragons\n",
            "HereBeDragons\\HereBeDragons-2.0.lua\n",
            "HereBeDragons\\HereBeDragons-Pins-2.0.lua\n",
            "HereBeDragons\\HereBeDragons-Migrate.lua\n",
            "\n# Dropdown menus\n",
            "!LibUIDropDownMenu\\LibUIDropDownMenu\\LibUIDropDownMenu.xml\n",
            "\n",
        ]

        root = Path("Addons/!!Libs")
        libs = set(os.listdir(root))
        libs -= {
            "!!Libs.toc",
            "Ace3",
            "AceGUI-3.0-SharedMediaWidgets",
            "HereBeDragons",
            "UTF8",
            "FrameXML",
            "!LibUIDropDownMenu",
            "!LibUIDropDownMenu-2.0",
            "LibCompress",
            "LibDeflate",
            "LibDataBroker-1.1",
            "LibSharedMedia-3.0",
        }

        if "LibBabble" in libs:
            toc.contents += lib_babble_to_toc()
            libs.discard("LibBabble")

        drs = {lib for lib in libs if lib.startswith("DR")}
        libs -= drs
        if drs:
            toc.contents.append("# DR Libs\n")
            for dr_lib in drs:
                toc.contents.append(utils.lib_to_toc(dr_lib))
            toc.contents.append("\n")

        luas = {lib for lib in libs if lib.endswith("lua")}
        libs -= luas
        toc.contents.append("# Other Libs\n")
        for lib in sorted(libs):
            if lib == "SharedMedia":
                continue
            toc.contents.append(utils.lib_to_toc(lib))

        if luas:
            toc.contents.append("\n")
            toc.contents.append("# Custom Luas\n")
            for lua in sorted(luas):
                toc.contents.append(f"{lua}\n")

        with open("Addons/!!Libs/!!Libs.toc", "w", encoding="utf-8") as file:
            file.writelines(toc.to_lines())

    ###########################
    # Handle embedded libraries
    ###########################

    @staticmethod
    def handle_lib_graph():
        def handle_graph(lines: Iterable[str]) -> Iterable[str]:
            orig = "local TextureDirectory\n"
            tar = (
                'local TextureDirectory = "Interface\\\\AddOns\\\\!!Libs'
                + '\\\\LibGraph-2.0\\\\LibGraph-2.0\\\\"\n'
            )

            if orig not in lines:
                return lines

            lines = list(lines)
            # Comment out the block discovering TextureDirectory
            # The dictory discovery system is not working here
            start = lines.index(orig)
            ret = lines[:start]
            ret.append(tar)
            end = lines[start:].index("end\n")

            for line in lines[start + 1 : start + end + 1]:
                ret.append(f"--{line}")
            ret += lines[start + end + 1 :]

            return ret

        utils.process_file(
            "AddOns/!!Libs/LibGraph-2.0/LibGraph-2.0/LibGraph-2.0.lua",
            handle_graph,
        )

    @staticmethod
    def handle_lib_babbles():
        root = Path("Addons/!!Libs/")
        for lib in os.listdir(root):
            if lib.startswith("LibBabble-"):
                shutil.copytree(
                    root / lib, root / "LibBabble" / lib, dirs_exist_ok=True
                )
                shutil.rmtree(root / lib)

    @staticmethod
    def handle_separated_installed_libs():
        """Move the separated installed addon to !!Libs folder"""
        libs = ["Ace3", "HereBeDragons", "Krowi_WorldMapButtons"]
        root = Path("Addons")
        for addon in os.listdir(root):
            if addon in libs or addon.startswith("Lib") or addon.startswith("!Lib"):
                print(
                    f"{Color.YELLOW}Moving {Color.GREEN}{addon}{Color.YELLOW} to"
                    f" !!Libs...{Color.RESET}"
                )
                shutil.copytree(
                    root / addon, root / "!!Libs" / addon, dirs_exist_ok=True
                )
                shutil.rmtree(root / addon)

    @staticmethod
    def _handle_lib_in_libs(root: Path):
        for lib in os.listdir(root):
            if not os.path.isdir(root / lib) or lib == "Ace3":
                continue

            embeds = [
                "CallbackHandler-1.0",
                "LibStub",
                "LibStub-1.0",
                "HereBeDragons",
            ]
            for path in ["libs", "lib"]:
                if os.path.exists(root / lib / path):
                    embeds.append(path)
                    embeds.append(path.capitalize())
                    break

            for embed in embeds:
                utils.remove(root / lib / embed)

            if os.path.exists(root / lib / "embeds.xml"):
                os.remove(root / lib / "embeds.xml")
                embeds.append("embeds.xml")

            files = ["lib.xml", f"{lib}.xml", f"{lib}.toc"]
            for file in files:
                for path in [root / file, root / lib / file]:
                    if os.path.exists(path):
                        utils.remove_libs_in_file(path, embeds)

    @staticmethod
    def handle_lib_in_libs():
        Manager._handle_lib_in_libs(Path("AddOns/!!Libs"))
        Manager._handle_lib_in_libs(Path("AddOns/!!Libs/LibBabble"))

    ##########################
    # Handle individual addons
    ##########################

    @staticmethod
    def handle_dup_libraries():
        ignores = ["!!Libs", "Questie", "RareScanner"]
        addons = [addon for addon in os.listdir("AddOns") if addon not in ignores]
        for addon in addons:
            utils.remove_libraries_all(addon)

    @staticmethod
    def handle_atlas():
        utils.change_defaults("Addons/Atlas/Data/Constants.lua", "			hide = true,")

    @staticmethod
    @available_on(["retail", "classic"])
    def handle_atlasloot():
        utils.change_defaults("Addons/AtlasLoot/db.lua", "			shown = false,")

    @staticmethod
    @available_on(["classic_era"])
    def handle_atlaslootclassic():
        utils.change_defaults("Addons/AtlasLootClassic/db.lua", "			shown = false,")

    @staticmethod
    @available_on(["classic", "retail"])
    def handle_btwquest():
        def process(lines: Iterable[str]) -> Iterable[str]:
            ret: list[str] = []
            minimap = False
            for line in lines:
                if "minimapShown" in line:
                    minimap = True

                if minimap and "default" in line:
                    ret.append("            default = false,\n")
                    minimap = False
                else:
                    ret.append(line)
            return ret

        utils.process_file("Addons/BtWQuests/BtWQuests.lua", process)

    @staticmethod
    def handle_details():
        utils.change_defaults(
            "Addons/Details/functions/profiles.lua",
            "		minimap = {hide = true, radius = 160, minimapPos = 220, "
            "onclick_what_todo = 1, text_type = 1, text_format = 3},",
        )

        if os.path.exists("Addons/Details_Streamer"):
            utils.change_defaults(
                "Addons/Details_Streamer/Details_Streamer.lua",
                "					minimap = {hide = true, radius = 160, minimapPos = 160},",
            )

    @staticmethod
    @available_on(["retail"])
    def handle_fb():
        if not os.path.exists("Addons/FishingBuddy/"):
            return
        utils.change_defaults(
            "Addons/FishingBuddy/FishingBuddyMinimap.lua",
            '		FishingBuddy_Player["MinimapData"] = { hide=true };',
        )

    @staticmethod
    @available_on(["classic_era"])
    def handle_goodleader():
        utils.remove("Addons/GoodLeader/Libs/tdGUI/Libs")
        utils.remove_libs_in_file("Addons/GoodLeader/Libs/tdGUI/Load.xml", ["Libs"])

    @staticmethod
    def handle_grail():
        for folder in os.listdir("AddOns"):
            if "Grail" not in folder:
                continue

            local = folder[-4:]
            if local in [
                "deDE",
                "esES",
                "esMX",
                "frFR",
                "itIT",
                "koKR",
                "ptBR",
                "ruRU",
                "zhTW",
            ]:
                utils.remove(Path("Addons") / folder)

    @staticmethod
    @available_on(["retail"])
    def handle_hekili():
        if not os.path.exists("Addons/Hekili"):
            return

        utils.remove_libraries(
            ["LibStub"],
            "AddOns/Hekili/Libs/AceGUI-3.0_SFX-Widgets",
            "AddOns/Hekili/embeds.xml",
        )
        utils.remove_libraries(
            ["LibStub"],
            "AddOns/Hekili/Libs/SpellFlashCore/libs/BigLibTimer",
            "AddOns/Hekili/embeds.xml",
        )

    @staticmethod
    @available_on(["retail"])
    def handle_iat():
        if not os.path.exists("Addons/InstanceAchievementTracker"):
            return

        utils.remove("Addons/InstanceAchievementTracker/Libs/LibDBCompartment/Libs")

    @staticmethod
    @available_on(["retail"])
    def handle_meetingstone():
        if not os.path.exists("Addons/MeetingStone"):
            return
        utils.change_defaults(
            "Addons/MeetingStone/Profile.lua",
            "            minimap            = { hide = true,",
        )
        utils.change_defaults(
            "Addons/MeetingStone/Profile.lua",
            "                panel             = false,",
        )

    @staticmethod
    @available_on(["classic", "classic_era"])
    def handle_meetinghorn():
        if not os.path.exists("Addons/MeetingHorn"):
            return
        utils.remove("Addons/MeetingHorn/Libs/tdGUI/Libs")
        utils.remove_libs_in_file("Addons/MeetingHorn/Libs/tdGUI/Load.xml", ["Libs"])

    @staticmethod
    @available_on(["classic", "classic_era"])
    def handle_merinspect():
        if not os.path.exists("Addons/MerInspect"):
            return
        utils.change_defaults(
            "Addons/MerInspect/Options.lua",
            [
                "    ShowCharacterItemSheet = false,          --玩家自己裝備列表",
                "    ShowCharacterItemStats = false,          --玩家自己屬性統計",
            ],
        )

    @staticmethod
    def handle_monkeyspeed():
        if not os.path.exists("Addons/MonkeySpeed"):
            return

        utils.process_file(
            "AddOns/MonkeySpeed/MonkeySpeedInit.lua",
            lambda lines: [
                (
                    line.replace(
                        'GetAddOnMetadata("MonkeySpeed", "Title")',
                        '"MonkeySpeed"',
                    )
                    if '"Title"' in line
                    else line
                )
                for line in lines
            ],
        )

    @staticmethod
    @available_on(["classic"])
    def handle_omnicc():
        utils.process_file(
            "AddOns/OmniCC/core/core.xml",
            lambda lines: [line for line in lines if "libs" not in line],
        )

    @staticmethod
    @available_on(["retail"])
    def handle_omnicd():
        utils.process_file(
            "AddOns/OmniCD/Libs/LibOmniCDC/AceGUI-3.0/AceGUI-3.0.xml",
            lambda lines: [line for line in lines if "Ace3" not in line],
        )

        utils.process_file(
            "AddOns/OmniCD/Libs/LibOmniCDC/AceConfig-3.0/AceConfig-3.0.xml",
            lambda lines: [line for line in lines if "Ace3" not in line],
        )

    @staticmethod
    @available_on(["retail", "classic"])
    def handle_oa():
        if not os.path.exists("Addons/Overachiever"):
            return
        utils.process_file(
            "Addons/Overachiever/Overachiever.lua",
            lambda lines: [
                line.replace(
                    'GetAddOnMetadata("Overachiever", "Title")',
                    '"Overarchiever"',
                )
                for line in lines
            ],
        )

    @staticmethod
    def handle_prat():
        utils.remove("AddOns/Prat-3.0_Libraries")
        utils.remove_libs_in_file("Addons/Prat-3.0/Libs.xml", ["Libs"])

    @staticmethod
    @available_on(["classic", "classic_era"])
    def handle_questie():
        utils.remove_libraries(
            [
                "AceAddon-3.0",
                "AceBucket-3.0",
                "AceComm-3.0",
                "AceConfig-3.0",
                "AceConsole-3.0",
                "AceDB-3.0",
                "AceDBOptions-3.0",
                "AceEvent-3.0",
                "AceGUI-3.0",
                "AceGUI-3.0-SharedMediaWidgets",
                "AceHook-3.0",
                "AceLocale-3.0",
                "AceSerializer-3.0",
                "AceTab-3.0",
                "AceTimer-3.0",
                "CallbackHandler-1.0",
                "Krowi_WorldMapButtons",
                "LibCompress",
                "LibDataBroker-1.1",
                "LibDBIcon-1.0",
                "LibSharedMedia",
                "LibSharedMedia-3.0",
                "LibStub",
            ],
            "AddOns/Questie/Libs",
            "AddOns/Questie/embeds.xml",
        )

        if utils.get_platform() == "classic_era":
            for postfix in ["", "-BCC"]:
                utils.remove_libraries(
                    ["LibUIDropDownMenu"],
                    "AddOns/Questie/Libs",
                    f"AddOns/Questie/Questie{postfix}.toc",
                )

        root = Path("AddOns/Questie")
        with open(root / "Questie-WOTLKC.toc", "r", encoding="utf-8") as file:
            lines = file.readlines()

        toc = TOC(lines)

        version = toc.tags["Version"]
        major, minor, patch = version.split(" ")[0].split(".")
        major = major.replace("v", "")

        def handle(lines: Iterable[str]) -> Iterable[str]:
            func = "function QuestieLib:GetAddonVersionInfo()"
            start = 0
            for i, line in enumerate(lines):
                if line.startswith(func):
                    start = i
                    break

            lines = list(lines)
            ret = lines[: start + 1]
            ret.append(f"    return {major}, {minor}, {patch}\n")
            ret.append("end\n")
            end = lines[start:].index("end\n")

            if not lines[start + 1].strip().startswith("return"):
                for line in lines[start + 1 : start + end + 1]:
                    ret.append(f"--{line}")

            ret += lines[start + end + 1 :]
            return ret

        utils.process_file(root / "Modules/Libs/QuestieLib.lua", handle)

        utils.change_defaults(
            "AddOns/Questie/Modules/Network/QuestieComms.lua",
            f'    pkt.data.ver = "{major}.{minor}.{patch}";',
        )

    @staticmethod
    @available_on(["retail"])
    def handle_rarity():
        utils.remove_libraries(
            ["HereBeDragons-2.0"],
            "AddOns/Rarity/Libs",
            "AddOns/Rarity/Rarity.toc",
        )

    @staticmethod
    @available_on(["retail", "classic"])
    def handle_rio():
        # Remove the embedded databases
        for realm in ["US", "TW", "KR", "EU"]:
            for contents in ["F", "M", "R"]:
                path = f"AddOns/RaiderIO_DB_{realm}_{contents}"
                if os.path.exists(path):
                    shutil.rmtree(path)
            for contents in ["recruitment", "mythicplus", "raiding"]:
                for lua in ["lookup", "characters"]:
                    for suffix in ["db", "db_classic"]:
                        path = (
                            f"AddOns/RaiderIO/db/{suffix}_{contents}_{realm}_{lua}.lua"
                        )
                        if os.path.exists(path):
                            os.remove(path)

    @staticmethod
    @available_on(["classic", "retail"])
    def handle_rs():
        utils.change_defaults(
            "AddOns/RareScanner/Core/Libs/RSConstants.lua", ["				hide = true"]
        )
        utils.remove_libraries(
            [
                "AceAddon-3.0",
                "AceConfig-3.0",
                "AceConsole-3.0",
                "AceDB-3.0",
                "AceDBOptions-3.0",
                "AceGUI-3.0",
                "AceGUI-3.0-SharedMediaWidgets",
                "AceLocale-3.0",
                "AceSerializer-3.0",
                "CallbackHandler-1.0",
                "HereBeDragons",
                "Krowi_WorldMapButtons-1.4",
                "LibDBIcon-1.0",
                "LibSharedMedia-3.0",
                "LibStub",
                "LibTime-1.0",
            ],
            "AddOns/RareScanner/ExternalLibs",
            "AddOns/RareScanner/ExternalLibs/Libs.xml",
        )

    @staticmethod
    @available_on(["retail"])
    def handle_sc():
        utils.change_defaults("Addons/Simulationcraft/core.lua", "        hide = true,")

    @staticmethod
    @available_on(["retail"])
    def handle_tdBattlePetScript():
        utils.remove("Addons/tdBattlePetScript/Libs/tdGUI/Libs")
        utils.remove_libs_in_file(
            "Addons/tdBattlePetScript/Libs/tdGUI/Load.xml", ["Libs"]
        )

    @staticmethod
    def handle_titan():
        addon = "TitanLocation"
        utils.change_defaults(
            f"Addons/{addon}/{addon}.lua",
            ["			ShowCoordsOnMap = false,", "			ShowCursorOnMap = false,"],
        )
        utils.remove("Addons/Titan/Libs")
        utils.remove_libs_in_file(
            "Addons/Titan/Titan.toc",
            ["Libs"],
        )

        for f in ["Cata", "Vanilla", "Wrath", "Classic"]:
            p = f"Addons/TitanClassic/TitanClassic_{f}.toc"
            if os.path.exists(p):
                utils.remove_libs_in_file(p, ["Libs"])

    @staticmethod
    def handle_tomtom():
        utils.change_defaults(
            "Addons/TomTom/TomTom.lua",
            [
                "                playerenable = false,",
                "                cursorenable = false,",
            ],
        )

    @staticmethod
    def handle_tsm():
        if not os.path.exists("Addons/TradeSkillMaster"):
            return
        utils.remove("AddOns/TradeSkillMaster/External/EmbeddedLibs/")

        utils.process_file(
            "AddOns/TradeSkillMaster/TradeSkillMaster.toc",
            lambda lines: [line for line in lines if "EmbeddedLibs" not in line],
        )

        # utils.change_defaults(
        #     'AddOns/TradeSkillMaster/LibTSM/Service/Settings.lua',
        #     ['			minimapIcon = { type = "table", default = { hide = true, minimapPos = 220, radius = 80 }, lastModifiedVersion = 10 },']
        # )

    @staticmethod
    def handle_ufp():
        if not os.path.exists("Addons/UnitFramesPlus"):
            return
        if utils.get_platform() == "classic_era":
            utils.remove("AddOns/UnitFramesPlus_MobHealth")

            utils.remove_libraries_all("UnitFramesPlus_Cooldown")

        def process(lines: Iterable[str]) -> Iterable[str]:
            ret: list[str] = []
            minimap = False
            for line in lines:
                if "minimap = {" in line:
                    minimap = True

                if minimap and "button" in line:
                    ret.append("        button = 0,\n")
                    minimap = False
                else:
                    ret.append(line)
            return ret

        utils.process_file("Addons/UnitFramesPlus/UnitFramesPlus.lua", process)

    @staticmethod
    @available_on(["classic"])
    def handle_vuhdo():
        utils.remove("Addons/Vuhdo/Libs/LibBase64-1.0/LibStub")

        utils.change_defaults(
            "Addons/VuhDo/VuhDoDefaults.lua", '	["SHOW_MINIMAP"] = false,'
        )

    @staticmethod
    def handle_wa():
        utils.remove_libraries_all("WeakAuras/Libs/Archivist")
        utils.remove_libraries(
            ["LibClassicSpellActionCount-1.0", "LibClassicCasterino"],
            "AddOns/WeakAuras/Libs/",
            "AddOns/WeakAuras/WeakAuras_Vanilla.toc",
        )

        utils.change_defaults(
            "Addons/WeakAuras/WeakAuras.lua",
            "      db.minimap = db.minimap or { hide = true };",
        )

    @staticmethod
    def handle_whlooter():
        if not os.path.exists("Addons/+Wowhead_Looter/"):
            return

        utils.change_defaults(
            "Addons/+Wowhead_Looter/Wowhead_Looter.lua",
            "wlSetting = {minimap=false};",
        )
