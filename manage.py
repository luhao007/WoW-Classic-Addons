import os
import sys
import shutil
import re
import instawow

from toc import process_toc
from utils import process_file


class Handler(object):

    def __init__(self, verbose):
        self.verbose = verbose

    def remove_libraries(self, addon, lib_path):
        """Remove the embedded libraries"""
        path = os.path.join('Addons', addon, lib_path)
        if os.path.exists(path):
            shutil.rmtree(path)
        
        toc_path = os.path.join('Addons', addon, '{}.toc'.format(addon))
        p = lambda lines: [l for l in lines if not l.startswith(lib_path)]
        process_file(toc_path, p, self.verbose)

    def handle_classic_castbar(self):
        self.remove_libraries('ClassicCastbars_Options', 'Libs')

    def handle_tsm(self):
        if os.path.exists('Addons/TradeSkillMaster/External/EmbeddedLibs/'):
            shutil.rmtree('Addons/TradeSkillMaster/External/EmbeddedLibs/')

        p = lambda lines: [re.sub(r'".+ttf"', r'"Fonts\\\\ARKai_C.ttf"', l) for l in lines]
        process_file('Addons/TradeSkillMaster/Core/UI/Support/Fonts.lua', p, self.verbose)
        
        p = lambda lines: [l for l in lines if 'EmbeddedLibs' not in l]
        process_file('Addons/TradeSkillMaster/TradeSkillMaster.toc', p, self.verbose)

    def process(self):
        for f in dir(self):
            if f.startswith('handle'):
                getattr(self, f)()
    

def manage(verbose=False):
    h = Handler(verbose)
    h.process()

    process_toc(verbose)
    
    if verbose:
        print('Finished.')

def main():
    verbose = bool(set(['--verbose', '-v']) & set(sys.argv))
    manage(verbose)
    print('All done.')

if __name__ == '__main__':
    main()