class TOC(object):

    def __init__(self, lines):
        self.tags = dict(l[3:].split(':', 1) for l in lines if l.startswith('## ') and ':' in l)
        self.contents = [l for l in lines if not l.startswith('## ')]
        for i, e in enumerate(self.contents):
            if e != '\n':
                self.contents = self.contents[i:]
                break
        else:
            self.contents = []

    def tags_to_line(self, tags):
        return ['## {}: {}\n'.format(tag, self.tags[tag].strip())
                for tag in tags if tag in self.tags]

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

        ret += self.contents

        return ret