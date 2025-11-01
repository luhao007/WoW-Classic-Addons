from collections.abc import Iterable

from utils import Color, get_logger


class TOC:

    def __init__(self, lines: Iterable[str]):
        """TOC Handler.

        :param lines [str]: lines of the TOC file.
        """
        self.tags: dict[str, str] = {}
        for line in lines:
            if line.startswith("## ") and ":" in line:
                k, value = line[3:].split(":", 1)
                self.tags[k.strip()] = value.strip()

        self.contents = [line for line in lines if not line.startswith("## ")]
        for i, line in enumerate(self.contents):
            if line != "\n":
                self.contents = self.contents[i:]
                break
        else:
            self.contents = []

    def tags_to_line(self, tags: Iterable[str]) -> Iterable[str]:
        return [
            f"## {tag}: {self.tags[tag]}\n"
            for tag in tags
            if self.tags.get(tag, "") != ""
        ]

    def trim_contents(self):
        prev = ""
        removes: set[int] = set([])
        for i, line in enumerate(self.contents):
            # Remove emtpy line following empty lines or comments
            if line == "\n":
                if prev == "\n" or (
                    prev.startswith("#") and not prev.startswith("#@end")
                ):
                    removes.add(i)

            # if it is end-of-block, then add an empty line
            if prev.startswith("#@end") and line != "\n":
                self.contents.insert(i, "\n")

            # Remove empty comment line
            if line.startswith("#") and set(line).issubset(["#", " ", "\n"]):
                removes.add(i)

            prev = line

        for i in sorted(removes, reverse=True):
            self.contents.pop(i)

    def to_lines(self) -> Iterable[str]:
        # https://warcraft.wiki.gg/wiki/TOC_format
        keys = [
            ["Interface", "Author", "Version", "License"],
            # Addon info in list
            ["Title", "Notes", "Title-zhCN", "Notes-zhCN"],
            # Addon icon in list
            ["IconTexture", "IconAtlas"],
            # Addon category in list
            ["Category", "Category-zhCN", "Group"],
            # New tags added in 10.0 for the dropdown menu next to minimap
            [
                "AddonCompartmentFunc",
                "AddonCompartmentFuncOnEnter",
                "AddonCompartmentFuncOnLeave",
            ],
            # Loading conditions
            [
                "RequiredDeps",
                "RequiredDep",
                "Dependencies",
                "OptionalDeps",
                "OptionalDependencies",
                "LoadOnDemand",
                "LoadWith",
                "LoadManagers",
                "AllowLoadGameType",
                "OnlyBetaAndPTR",
                "DefaultState",
            ],
            # Saved variables
            ["LoadSavedVariablesFirst", "SavedVariables", "SavedVariablesPerCharacter"],
            # Extra meta tags
            ["AllowAddOnTableAccess"],
            [k for k in self.tags.keys() if k.startswith("X-")],
            # Addition tags for specific use cases
            [
                "VersionDate",  # MeetingStoneEX - Used for grabbing the version date
            ],
        ]

        ret: list[str] = []
        for key in keys:
            tag = [k for k in key if k in self.tags.keys()]
            if not tag:
                continue
            tag_lines = self.tags_to_line(tag)
            if tag_lines:
                ret += tag_lines
                ret += ["\n"]

        all_keys = [key for sublist in keys for key in sublist]
        missing_keys = set(self.tags.keys()) - set(all_keys)

        # Ignore extra languages
        extra_languages = [
            "deDE",
            "enUS",
            "esES",
            "esMX",
            "frFR",
            "itIT",
            "koKR",
            "ptBR",
            "ruRU",
            "zhTW",
        ]
        missing_keys = [k for k in missing_keys if k[-4:] not in extra_languages]

        if missing_keys:
            logger = get_logger("TOCHandler")
            logger.warning(
                f"{Color.RED}Unknown tags found:"
                f" {Color.BLUE}{missing_keys} {Color.RED}in"
                f" {Color.GREEN}{self.tags['Title']}{Color.RESET}"
            )

        self.trim_contents()
        ret += self.contents

        return ret
