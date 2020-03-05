import os
import unittest
from pprint import pprint


class CheckManagedAddons(unittest.TestCase):

    def test_checkToc(self):
        for addon in os.listdir('AddOns'):
            self.assertTrue(os.path.exists(os.path.join('Addons', addon, '{0}.toc'.format(addon))), '{0}.toc not existed!'.format(addon))

    def test_checkLibrary(self):
        path = os.path.join('Addons', '!!Libs')
        with open(os.path.join(path, '!!Libs.toc'), 'r', encoding='utf-8') as f:
            lines = f.readlines()

        for lib in os.listdir(path):
            if '.toc' not in lib:
                self.assertTrue(any(lib in l for l in lines), '{0} in !!Libs, but not used in !!Libs.toc'.format(lib))


    def test_checkDuplicateLibraries(self):
        path = os.path.join('Addons', '!!Libs')
        
        libs = {lib for lib in os.listdir(path) if os.path.isdir(os.path.join(path, lib))}
        duplicates = {}      
        for root, dirs, _ in os.walk('Addons'):
            if '!!Libs' in root:
                continue

            dup = libs & set(dirs)
            if dup:
                duplicates[root] = dirs
            
        if duplicates:
            print('Found below duplicate libraries:')
            pprint(duplicates)
            self.fail('Found duplicated libraries!')
