import logging
import os

from xml.etree import ElementTree as ET
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


def get_title(config_tree, name):
    parts = []

    ns = {'x': 'https://www.github.com/luhao007'}
    path = './/*[@name="{}"]'.format(name)
    config = config_tree.find(path)
    if config.tag.endswith('SubAddon'):
        cat = config_tree.find('{}../../x:Category'.format(path), ns).text
        title = config_tree.find('{}../../x:Title'.format(path), ns).text
        sub = config.find('x:Title', ns).text
    else:
        cat = config.find('x:Category', ns).text
        title = config.find('x:Title', ns).text
        if config.find('x:Title-en', ns) is not None:
            en = config.find('x:Title-en', ns).text
        else:
            en = name

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
    parts.append('|cFFFFE00A<|r|cFF{}{}|r|cFFFFE00A>|r'.format(color, cat))

    parts.append('|cFFFFFFFF{}|r'.format(title))

    if config.tag.endswith('SubAddon'):
        if sub == '设置':
            color = 'FF0055FF'
        elif '文' in sub:
            color = 'FF22B14C'
        else:
            color = 'FF69CCF0'
        parts.append('|c{}{}|r'.format(color, sub))
    elif not (('DBM' in name and name != 'DBM-Core') or
              'Grail-' in name or
              name == '!!Libs'):
        parts.append('|cFFFFE00A{}|r'.format(en))

    ext = config.find('x:TitleExtra', ns)
    if ext is not None:
        parts.append('|cFF22B14C{}|r'.format(ext.text))

    return ' '.join(parts)


def process_toc(version, verbose=False):
    config_tree = ET.parse('config.xml')
    for addon in os.listdir('AddOns'):
        config = config_tree.find('.//*[@name="{}"]'.format(addon))
        if not config:
            logger.warn('%s not found!', addon)
            continue

        path = os.path.join('AddOns', addon, '{}.toc'.format(addon))

        def process(lines):
            toc = TOC(lines)

            toc.tags['Interface'] = version
            toc.tags['Title-zhCN'] = get_title(config_tree, addon)

            note = config.find('Notes')
            if note:
                toc.tags['Notes-zhCN'] = note.text

            return toc.to_lines()

        process_file(path, process)
