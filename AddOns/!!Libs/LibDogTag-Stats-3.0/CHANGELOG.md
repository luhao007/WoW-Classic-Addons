# Lib: DogTag-Stats-3.0

## [v90100.1](https://github.com/ascott18/LibDogTag-Stats-3.0/tree/v90100.1) (2021-08-21)
[Full Changelog](https://github.com/ascott18/LibDogTag-Stats-3.0/commits/v90100.1) [Previous Releases](https://github.com/ascott18/LibDogTag-Stats-3.0/releases)

- Oops, wrong folder for the workflow.  
- Updates for git, add bigwigs packager  
- Fix spell crit for non-retail  
- Update for WoW Classic compatibility  
- TOC bump, added SpellCrit tag back  
- Toc bump  
- Don't create Multistrike tag if GetMultistrike doesnt exist (for Legion)  
- Removed pre-6.0 compatibility, and added an event to the CriticalStrike tag.  
- Added some events to help with tags not updating when they should  
- Update toc version, remove TODO comment that is TODONE.  
- Fixed the fix for the versatility tag  
- Fixed versatility tag  
- Updated for Warlords  
- toc bump to 50400  
- Added CurrentSpeed and GroundSpeed tags  
- Fixed version tag in LibDogTag-Stats-3.0.toc  
- Changed SpellCrit events to "PLAYER\_DAMAGE\_DONE\_MODS;COMBAT\_RATING\_UPDATE"  
- Added UNIT\_STATS#player tp SpellCrit's events so that it will update when the player's intellect changes.  
- Improved description and default behavior of [SpellCrit] and [SpellDamage]  
- Added PLAYER\_DAMAGE\_DONE\_MODS as an event for [BlockChance]  
- * Fixed GetBlockChance copy/paste error  
    * Added another event to the BlockChance tag that should make it update when it should  
    * Fixed copy/paste errors in Melee.lua  
    * Mastery now uses GetMasteryEffect()  
    * The event for [PvPPowerRating] has been added in (was missing by accident)  
- Fixed lib.xml so that it will now load the new zhCN and zhTW localizations.  
- Added zhCN and zhTW localization files  
- Added phrases to localization file  
- Added tags for checking hit rating.  
    Improved the examples for many tags.  
- [SpellCrit] was returning the same as [SpellDamage] by mistake.  
- Oh. I figured out how to to the $Repository$ keyword substitution!  
- Trying again to figure out how the $Revision$ substitution works.  
- Fixed the svn $Revision$ substitutions  
- Initial Commit  
- libdogtag-stats-3-0/mainline: Initial Import  
