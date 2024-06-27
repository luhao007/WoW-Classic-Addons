# AllTheThings

## [DF-3.12.6](https://github.com/DFortun81/AllTheThings/tree/DF-3.12.6) (2024-06-09)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/DF-3.12.5...DF-3.12.6) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- every sunday is att ririsudesu  
- Weapons and achievement correction  
- Cobalt Guardian's Cloak does not require a mail class to learn  
- Alchemy and Herbalism are now Added and Loaded into Beta  
- Reported as normal drop also  
- Added MoP HQT.  
- Some Unsorted upkeep  
- Generate Missing (Diff against Beta)  
- Sort new recipes!  
- Some Data Entry Fixes  
- Harvest: 11.0.0.55000  
- Harvest: 10.2.7.54988  
- Harvest: 4.4.0.55006  
- Harvest: 4.4.0.54986  
- Harvest: 3.4.3.54987  
- Harvest: 1.15.2.55002  
- World Bosses are now in Beta  
- Load Priory, Dawnbreaker, Rookery, Stonevault onto beta  
- Loading in Ara-Kara, Cinderbrew, City of Threads and Darkflame Cleft onto the Beta  
- Merge branch 'master' of https://github.com/DFortun81/AllTheThings  
- Norushen's Tower Shield (mythic SoO)  
- Loading in Azj-Kahet onto beta  
- This Should load Hallowfall into Beta  
- Merge branch 'master' of https://github.com/DFortun81/AllTheThings  
- The Ringing Deeps should now load on the Beta  
- Death Lotus Repeater for Mythic SoO confirmed via Discord  
- Fixed some non-existent timeline constants  
- New achievementDB & Wago files for TWW Beta  
- Dornogal and Isle of Dorn should now load on the Beta  
- 3 NYI items sourced  
- updated the bronze caches a bit  
- Some additional weapon sources  
- Fixed another Lua error on load  
- Fixed some in-line global calls for custom headers (needs re-parse)  
- Transformed old custom headers into the new style: Most Dragonflight headers but also remaining PvP BFA and some misc ones  
- GetSpellName's wrapper now prevents bad data from bricking everything.  
- Added GetSpellLink to the WOW API Wrapper file.  
- Fixed a retail API bug.  
- Moved GetItemCount to the WoW API Wrapper file.  
- Added Item APIs to the WoW API Wrapper.  
- Moved GetSpellName/GetSpellIcon to the WOW API Wrapper file.  
- Moved all GetFactionInfoByID to the new WoW API Wrappers file.  
- Added temporary helper functions for GetFactionName and GetFactionBonusReputation.  
- locales now loads without issue on Beta.  
- Added temporary functions for GetSpellName and GetSpellIcon.  
- Rebuilt all DBs for all game flavors to show the new WOWAPI helper functions doing the lord's work.  
- Added a function for GetCategoryName being used within the contrib folder. (It returns a versioned string that switches GetCategoryInfo with the namespaced version)  
    In the future, this function might return something else, but for now this is good enough.  
- Added a function for GetAchievementName being used within the contrib folder. (It returns a versioned string that switches GetAchievementInfo with the namespaced version)  
    In the future, this function might return something else, but for now this is good enough.  
- Fixed a scuffed sharedData function in the draenor garrison mission file.  
- Added a function for GetItemSubClassInfo being used within the contrib folder. (It returns a versioned string that switches GetItemSubClassInfo with the namespaced version)  
    In the future, this function might return something else, but for now this is good enough.  
- Added a function for GetItemClassInfo being used within the contrib folder. (It returns a versioned string that switches GetItemClassInfo with the namespaced version)  
    In the future, this function might return something else, but for now this is good enough.  
- Added a function for GetSpellName being used within the contrib folder. (It returns a versioned string that switches GetSpellInfo/GetSpellName with the namespaced version)  
    In the future, this function might return something else, but for now this is good enough.  
- Added a function for GetSpellCooldown being used within the contrib folder. (It returns a versioned string that switches GetSpellCooldown with the namespaced version)  
    In the future, this function might return something else, but for now this is good enough.  
- Added a function for GetItemCount being used within the contrib folder. (It returns a versioned string that switches GetItemCount with the namespaced version)  
    In the future, this function might return something else, but for now this is good enough.  
- Moved the Brazier OnInit function to the function templates file.  
- Added back some valid commits that were lost in the great purge.  
- Revert "Don't need this preprocessor since parser is a bit smarter now"  
- Extra weapon sources  
- Some headers in pvp converted  
- BFA S1/2 Ensemble clean up  
- TWW Achcats  
- Great Vault Cleaning  
- Fixed 'Polyformic Acid Science' criterias  
    Fixed Bronze prices on some Mounts  
- Pandamix DH starter kit  
- 8.1 QIs  
- Darkhide Shield additional drop location  
- Remix: Another Round of Noodles  
- Don't need this preprocessor since parser is a bit smarter now  
- Parser no longer exports empty top level Categories  
    Parser no longer attempts to automate Achievements listed under a Difficulty (typically these are specific to a boss or encounter, and automating them can cause mutliple criteria to spread to other difficulties)  
- Retail: Fixed an issue (probably) where mapIDs with no data were being reported as mapID 0  
- Unsorted weapon located :)  
- TWW: more data before beta  
- TWW: a little bit of cleanup in zone HQTs  
- Fixed the 'real' difficulties of T14/ToT raids in Remix (someone pls parse and test thanks :smirk:)  
- Retail: Factions are 'Things'  
- Couple additional weapon sources  
- Mini Mana Bomb (Horde) and Theramore Tabard (Alliance)  
    No longer level 35 requirements  
- Added a new function to allow a Filter to be added externally  
    Added some other unused Filter code that is potentially usable for some situations in the future  
- Dinomancer's Spire fix  
- Added the Delves custom header.  
- Added Delves main category.  
- Weapons. Maybe possibly finally cleaned up the mess that was T14 LFR/N due to things dropping on wrong difficulty for a while.  
- Sorted all NYI Unknown Sources from SL and DF.  
- TWW: Azj-Kahet re-run on warrior  
- Weapons  
- TWW: new character again, more quests! (Isle of Dorn main story)  
- Removed temp itemDB  
    Fixed some weird Difficulty issues due to multi-difficulty logic causing unexpected shifts in data values when parsing  
    SImplified some Item merging logic which was being duplicated  
    Recipes now automatically have their ModID/BonusID cleaned (in case they are listed inside Instances)  
- Reported as HC drop  
- Added Green Snugglefin Murloc Romper set to Shop.  
    More unknown sources sorting.  
- wpn is hc only  
