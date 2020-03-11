import logging
import os

from config import MAPPING
from utils import process_file

logger = logging.getLogger('toc')


class TOC(object):

    def __init__(self, lines):
        self.tags = {}
        for l in lines:
            if l.startswith('## ') and ':' in l:
                k, v = l[3:].split(':', 1)
                self.tags[k.strip()] = v.strip()

        self.contents = [l for l in lines if not l.startswith('## ')]
        for i, e in enumerate(self.contents):
            if e != '\n':
                self.contents = self.contents[i:]
                break
        else:
            self.contents = []

    def tags_to_line(self, tags):
        return ['## {}: {}\n'.format(tag, self.tags[tag])
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


def get_title(addon):
    m = MAPPING[addon]
    title = ''

    if 'Category' in m:
        cat = m['Category']
        if cat == '任务':
            color = '00FF7F'  # Spring green
        elif cat == '基础库':
            color = 'FF0000'  # Red
        elif cat == '物品':
            color = '1E90FF'  # Doget blue
        elif cat == '界面':
            color = 'BA55D3'  # Medium orchid
        elif cat == '副本':
            color = 'FF7D0A'  # Orange - DBM
        elif cat == '战斗':
            color = 'FF1493'  # Deep pink
        else:
            color = 'FFFFFF'  # White
        title += '|cFFFFE00A<|r|cFF{}{}|r|cFFFFE00A>|r '.format(color, cat)
    if 'Title-cn' in m:
        title += '|cFFFFFFFF{}|r '.format(m['Title-cn'])
    if 'Title-sub' in m:
        sub = m['Title-sub']
        if sub == '设置':
            color = 'FF0055FF'
        elif '文' in sub:
            color = 'FF22B14C'
        else:
            color = 'FF69CCF0'
        title += '|c{}{}|r'.format(color, sub)
    elif not (('DBM' in addon and addon != 'DBM-Core') or
              'Grail-' in addon or
              addon == '!!Libs'):
        title += '|cFFFFE00A{}|r'.format(m.get('Title-en', addon))

    return title.strip()


def get_notes(addon):
    m = MAPPING[addon]
    return m.get('Notes')


def process_toc(version, verbose=False):
    for addon in os.listdir('AddOns'):
        if addon not in MAPPING:
            logger.warn('%s not found!', addon)
            continue

        path = os.path.join('AddOns', addon, '{0}.toc'.format(addon))

        def process(lines):
            toc = TOC(lines)

            toc.tags['Interface'] = version

            title = get_title(addon)
            if title:
                toc.tags['Title-zhCN'] = title

            note = get_notes(addon)
            if note:
                toc.tags['Notes-zhCN'] = note

            return toc.to_lines()

        process_file(path, process)
