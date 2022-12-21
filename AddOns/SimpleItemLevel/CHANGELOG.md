# Simple Item Level

## [v28](https://github.com/kemayo/wow-simpleitemlevel/tree/v28) (2022-12-17)
[Full Changelog](https://github.com/kemayo/wow-simpleitemlevel/compare/v27...v28) [Previous Releases](https://github.com/kemayo/wow-simpleitemlevel/releases)

- Don't 100% fall back on item links for bagnon  
    Fixes #24  
- Split out the "equipment only" option into subtypes  
    Also, add an option to only show the missing-things on the character  
    frame.  
    Fixes #21  
- Fix errors coming from Bagnon void storage  
    Fixes #22  
- For caged battle pets show their level/quality rather than the cage's  
    Caged pets are all item 82800, "Pet Cage", which is item level 20.  
    This also fixes an error that was happening when it tried to check the  
    caged pet for gem slots.  
    Fixes #20  
