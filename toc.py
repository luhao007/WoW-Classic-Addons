class TOC:

    def __init__(self, lines: list[str]):
        """TOC Handler.

        :param lines [str]: lines of the TOC file.
        """
        self.tags: dict[str, str] = {}
        for line in lines:
            if line.startswith('## ') and ':' in line:
                k, value = line[3:].split(':', 1)
                self.tags[k.strip()] = value.strip()

        self.contents = [line for line in lines if not line.startswith('## ')]
        for i, line in enumerate(self.contents):
            if line != '\n':
                self.contents = self.contents[i:]
                break
        else:
            self.contents = []

    def tags_to_line(self, tags: list[str]) -> list[str]:
        return [f'## {tag}: {self.tags[tag]}\n'
                for tag in tags if tag in self.tags]

    def trim_contents(self):
        prev = ''
        removes = set([])
        for i, line in enumerate(self.contents):
            # Remove emtpy line following empty lines or comments
            if line == '\n':
                if prev == '\n' or (prev.startswith('#') and
                                    not prev.startswith('#@end')):
                    removes.add(i)

            # if it is end-of-block, then add an empty line
            if prev.startswith('#@end') and line != '\n':
                self.contents.insert(i, '\n')

            # Remove empty comment line
            if line.startswith('#') and set(line).issubset(['#', ' ', '\n']):
                removes.add(i)

            prev = line

        for i in sorted(removes, reverse=True):
            self.contents.pop(i)

    def to_lines(self) -> list[str]:
        keys = [['Interface', 'Author', 'Version'],

                # Addon info in list
                ['Title', 'Notes', 'Title-zhCN', 'Notes-zhCN'],

                # Addon icon in list
                ['IconTexture', 'IconAtlas'],

                # New tags added in 10.0 for the dropdown menu next to minimap
                ['AddonCompartmentFunc',
                 'AddonCompartmentFuncOnEnter', 'AddonCompartmentFuncOnLeave'],

                # Loading conditions
                ['RequiredDeps', 'Dependencies', 'OptionalDeps',
                 'LoadOnDemand', 'LoadWith', 'LoadManagers', 'DefaultState'],

                # Saved variables
                ['SavedVariables', 'SavedVariablesPerCharacter']]

        ret = []
        for key in keys:
            tag = [k for k in key if k in self.tags.keys()]
            if not tag:
                continue
            ret += self.tags_to_line(tag)
            ret += ['\n']

        # Extra meta tags
        ret += self.tags_to_line(k for k in self.tags if k.startswith('X-'))
        ret += ['\n']

        self.trim_contents()
        ret += self.contents

        return ret
