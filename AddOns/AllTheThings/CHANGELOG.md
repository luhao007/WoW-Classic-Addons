# AllTheThings

## [TWW-4.0.1](https://github.com/DFortun81/AllTheThings/tree/TWW-4.0.1) (2024-07-28)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/TWW-4.0.0a...TWW-4.0.1) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- Retail: Now showing 'Class' icons in place of 'Specialization' icons when no specializations show for the current ATT row (WIP - plan to add Races as well when no Classes shown)  
- Venomhide Baby Tooth HQT  
- Retail: Only add Party sync logic to quest popouts when they are popped out whle in active Party Sync  
- Sourcing some objects so criteria can nest under them  
- If we're going to switch to TWW parsing while still DFS4 in game then we want Catalyst to still show S4 as expected  
- SOD: Added Engrave Boots - Guarded by the Light for Paladins.  
- SOD: Added the Sturdy Lunchbox.  
- SOD: Missing timeline for ony quest.  
- Fixed a bug with GetPatchString where it was truncating patches greater than 10 for the major patch number.  
- SOD: Wrong questID for The Arcanist's Cookbook.  
- SOD: Added updated SOD versions of Codex of Defense, Garona: A Study on Stealth and Treachery, The Arcanist's Cookbook, The Light and How To Swing It, and The Forging of Quel'Serrar to Dire Maul.  
    SOD: Added the updated Stave of the Ancients quest for Hunters.  
- SOD: Adjusted the phase requirements for Dire Maul and the Tier 0.5 Sets. (TODO: Add in the SOD specific stuff for these sections)  
- SOD: Added Moonsteel Broadsword and all of its associated updated SOD specific quests/recipes.  
- SOD: Added the SOD specific version of Jarl Needs a Blade in Dustwallow Marsh.  
- Classic: Added some missing objectIDs for Swamp of Sorrows.  
- SOD: Marked the Recover Incursion Field Report quests as repeatable.  
- Explore zone style achievements are now also automated  
- missing SL QI  
- Fixed tabs.  
- Retail: Fixed a little logic for following a quest chain popout of completed quests while in Party Sync  
- No longer possible to show negative progress on rows when using 'Show Remaining' option  
- Parser: Minor adjustment to prioritize _objects over providers for Criteria  
- Retail: Moved fallback row icon to fix situations where it was shown for 'wrapped' groups (i.e. cost counts display in popouts)  
- Automated another type (using game objects)  
- Set up achievement automation for flight path achievments (currently only one exists in TWW, more soon maybe?)  
- Update Isle Of Giants.lua  
    Comparing weapon drops with wowhead drop list  
- Update Isle of Thunder.lua  
    Comparing weapon drops with wowhead drop list  
- Update Timeless Isle.lua  
    Comparing weapon drops with wowhead drop list  
- Update Kun-Lai Summit.lua  
    Comparing weapon drops with wowhead drop list  
- Update Townlong Steppes.lua - just confirming  
- Update The Jade Forest.lua - just confirming  
- Update Krasarang Wilds.lua - Wowhead confirmation  
- Vale of Eternal Blossoms weapon confirmation  
    Just added Wowhead confirmations  
- Valley Of The Four Winds weapon update  
    Mostly just confirmation of drops from wowhead  
- Dread Wastes weapons updated  
    Adjustment based on wowhead drop tables  
- Ancient Hornswog bonus objective no longer exists  
- Update The Jade Forest removing Hozen Effigy  
    Hozen Effigy on Wowhead only have recorded drops from Vale of Eternal Blossom. https://www.wowhead.com/item=215658/hozen-effigy  
- Retail: Added a dynamic group for Heirlooms  
- Adjusted Locked logic such that anything locked via 'sourceID' (Kaldorei treasures, etc.) will not continue to be considered collectible when in Account/Debug modes  
- CATA: Add objective data for Netherstorm  
- TWW exploration set up manually again  
- Fix link script due to DragonFlight to Retail file move  
- Update Townlong Steppes.lua (#1699)  
    Ironwood Shield does not drop in Townlong Steppes. I have done a lot of farming, it didn't drop and Wowhead dropped by list and comments suggests the same thing: https://www.wowhead.com/item=216533/ironwood-shield#dropped-by  
- Fixed timeline of the new Exile's Reach items.  
- - Blizzard adds Expeditionary Boots to Exile's Reach, but removes the old white gloves >_>  
- 'Inconvenience Fee' is AccountWide instead of OneTimeQuest  
- Used 'C\_QuestLog.IsAccountQuest' to find a few more quests that Blizz flags account-wide  
