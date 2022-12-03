# Simple Item Level

## [v23](https://github.com/kemayo/wow-simpleitemlevel/tree/v23) (2022-11-30)
[Full Changelog](https://github.com/kemayo/wow-simpleitemlevel/compare/v22...v23) [Previous Releases](https://github.com/kemayo/wow-simpleitemlevel/releases)

- Fix for the missing icons sticking around when moving items in bags  
- Minor fixes for classic  
- Fix some luacheck complaints in the config  
- Fix Inventorian integration so item levels work in cached frames  
- Change the font used for the E in the missing enchants  
- Actually, missing indicators on the left  
    Looks better with the default font size  
- Move the slash command code into the config file  
- Show missing enchantments and gems (with config, etc)  
- If your mainhand is 2-handed don't show all 1-handed weapons as upgrades  
    It was comparing them to the empty offhand slot. The check only happens  
    if the offhand slot is empty, so Titan's Grip warriors shouldn't be too  
    affected.  
- Consolidate some of the show-on-button code  
    Side effect: you'll get upgrade arrows when inspecting now  
- Fix tooltips on config checkboxes  
