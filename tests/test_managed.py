import os
import unittest
from pathlib import Path
from pprint import pprint

from toc import TOC


class CheckManagedAddOns(unittest.TestCase):

    def test_check_addon_toc(self):
        for addon in os.listdir('AddOns'):
            path = Path('AddOns') / addon / '{0}.toc'.format(addon)
            if 'sekiro' not in addon:
                self.assertTrue(os.path.exists(path),
                                '{0}.toc not existed!'.format(addon))

    def test_check_libs(self):
        """Test for !!Libs.toc"""
        root = Path('AddOns/!!Libs')
        with open(root / '!!Libs.toc', 'r', encoding='utf-8') as f:
            lines = f.readlines()

        toc = TOC(lines)

        # Check every lib folder exists in the toc
        for lib in os.listdir(root):
            if '.toc' not in lib and lib != 'FrameXML':
                self.assertTrue(
                    any(lib in line for line in toc.contents),
                    '{0} in !!Libs, but not used in !!Libs.toc'.format(lib)
                )

        # Check every file in the toc exists
        for line in toc.contents:
            if line.startswith('#') or line == '\n':
                continue
            path = root / line.strip()
            self.assertTrue(
                os.path.exists(str(path).replace('\\', '/', -1)),
                '{0} in !!Libs.toc, but not exists!'.format(path)
            )

    def test_check_duplicate_libraries(self):
        root = Path('AddOns/!!Libs')
        paths = [root, root / 'Ace3', root / 'Ace3/AceConfig-3.0',
                 root / 'LibBabble']
        libs = []
        for path in paths:
            libs += [lib for lib in os.listdir(path)
                     if os.path.isdir(path / lib)]

        libs += ['HereBeDragons-2.0']

        duplicates = {}
        for root, dirs, _ in os.walk('AddOns'):
            if '!!Libs' in root:
                continue

            dup = set(dirs).intersection(libs)
            if dup:
                duplicates[root] = dup

        if duplicates:
            print('Found below duplicate libraries:')
            pprint(duplicates)

            # Ignore these embedded liraries, as they have customized versions
            whitelist = ['Questie']

            for k in duplicates:
                paths = []
                head = k
                tail = ''
                while head:
                    head, tail = os.path.split(head)
                    paths.append(tail)

                print(paths)

                addon = paths[-2]
                if addon not in whitelist:
                    self.fail('Found duplicated libraries in {}'.format(addon))
