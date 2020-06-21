# Deadly Boss Mods Core

## [1.13.50](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.50) (2020-06-19)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.49...1.13.50)

- Added failsaves to IsPlayer and IsPlayerSource objects so they don't rely on GUIDs alone. You never know  
    Added an additional trigger to first wave on Rajaxx(if it's face pulled instead of npc pulled)  
    Prep new tag. Tiny release, with no update notification trigger, just fixing a few bugs.  
- Fixes to last  
- Improved Kurinnaxx trap detection  
- Update README.md  
- Merge pull request #234 from woopydalan/patch-127  
    Update localization.mx.lua  
- Also fix soundkit id that's wrong in two places  
- Fixed another regression where drop down values for special announce sound options had all the incorrect values for classic. This was broken for 23 days and sadly slipped into not only last release but last 2 or 3 releases. This is now fixed  
- Fixed regression with simpleHTML that caused GUI toget screwed up with 1.13.49 release with checkbox spacing  
- Fixed a bug where IsTanking Object was incorrectly checking unit against boss target unit, causing it to never return true for the bosses current target when called. it'd just always return false  
    Also fixed a bug where IsTanking never actually checked threat for non "boss" unit Ids (which is pretty much ALL units in classic)  
-  - Added protection from FastestClear being purged by the 2nd option pruner (why there are two of them is beyond me)  
     - While at it, normalized all of the temp options various features store in dbms options table so that if DBM core ever adds garbage collection to it's options tables, it's easy to exempt all the ones that use options for temporary storage.  
     - Also found an unused temp storage variable so pruned that  
- Update localization.mx.lua  
- Update localization.cn.lua (#232)  
- use real threat API on 1.13.5 PTR  
