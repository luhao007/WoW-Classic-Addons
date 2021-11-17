class TOC:

    def __init__(self, lines):
        """TOC Handler.

        :param lines [str]: lines of the TOC file.
        """
        self.tags = {}
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

    def tags_to_line(self, tags):
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

    def to_lines(self):
        keys = ['Interface', 'Author', 'Version',
                'RequiredDeps', 'Dependencies', 'OptionalDeps',
                'LoadOnDemand', 'LoadWith', 'LoadManagers',
                'SavedVariables', 'SavedVariablesPerCharacter',
                'DefaultState', 'Secure']
        ret = self.tags_to_line(keys)
        ret += ['\n']

        keys = ['Title', 'Notes', 'Title-zhCN', 'Notes-zhCN']
        ret += self.tags_to_line(keys)
        ret += ['\n']

        ret += self.tags_to_line(k for k in self.tags if k.startswith('X-'))
        ret += ['\n']

        self.trim_contents()
        ret += self.contents

        return ret
