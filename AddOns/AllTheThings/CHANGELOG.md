# AllTheThings

## [DF-3.12.8](https://github.com/DFortun81/AllTheThings/tree/DF-3.12.8) (2024-06-23)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/DF-3.12.7...DF-3.12.8) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- Parsed for releases  
- TWW zone quest achievements, and some fishing too  
- Cleaned up 'Shan'ze Ritual Stone' daily tracking quest (maybe improve this type of HQT + Item drop tracking in future)  
- Retail: Future Warband Collected additions now clear cached tooltips  
- Added mapID 843 to Kun-Lai Summit (fixes #1657)  
- TWW dungeon difficulty achievements  
- Retail: Fixed icon used in Source Lines for unavailable on current character indication (was previously using a texture which was roughly identical to the 'requires pre-requisites' texture)  
- Added Sturdy Expedition Shovel as cost for Disturbed Dirt  
- Retail: Compressed tooltips when Contains data is linked to multiple maps  
- TWW achievements  
- Added 1546 mapID for Mogu'shan Palace (fixes #1662)  
- Added Ice Chest for Ahune  
- Sojourner of The Ringing Deeps + some adjustments to sourced data for other Sojourner achievements  
- Sojourner of Azj-Kahet  
- Timelined Brann achievements as we're supposed to get a new companion for delves season 2  
- tagged some recipes with uncollectiable and added if features for wod (lol)  
- Re-organized Bloody Coins and respective Achievements to proper standards with 'cost'  
- More Torch Tossing  
- Classic: Transmog now collects properly when loading into the game as expected  
    Class: OnSettingsRefreshed event is way less spammy  
- Retail: Plotting waypoints will now take into account the source quests of that Thing if it is not itself a Quest (i.e. some Achievements etc. may have their requirement linked by source quest instead of other data)  
    Retail: Plotting waypoints now uses the same nested logic for search results when no coordinates are plotted from the initial group  
- Some more Isle of Dorn adjustments. Added Quests and Vendor for Council of Dornogal  
- Delve achievements  
- Azj-Kahet skyriding and expansion metas  
- Hallowfall skyriding plus some coordinated already found for the rest of the zones  
- Fixed TWW World Drops.  
- pvp note  
- Updated Heritage and Lore questlines + timelined all of them.  
    Updated few Heritage HQTs.  
- Classic: Simplified QUEST\_LOG\_UPDATE event  
- TWW: Enchanting first craft questIDs  
- Classic: Removed early QUEST\_LOG\_UPDATE registration  
- TWW: added Alchemy missing first craft questIDs and Agonizing Potion now Grotesque Vial  
- Some Sorting and new things in Isle of Dorn/Dornogal  
- --- Lyrendal Profession Books added  
- Changed to Heritage. Seems like all other language are correct?  
- Removed some enchanting rewards from teaching quest in Dornogal  
- Added some profession trainer information  
- Fixes to Mining  
- Weekly Profession Knowledge from Inscription added  
- Fixing Broken Midsummer and Void Scale DM! They are not dynamic yet thus must be added manually to work.  
- A Fix of CI:s and Noblegarden.... xD Many questIDs...  
- BT/SB/DB battlepet coords and descriptions.  
- Charred Fishing Pole is actually collectible so change the flag to reflect this.  Should now display collected instead of Incomplete  
- Add Aid the Anglers turn-in  
- - Removed scenario completion header because auto unfolding the difficulty is more important (and it should be clear you get scenario weapons either at the end, or from a bonus box, without really needing a header for it)  
    - Extra location for Mushan Hewer  
- Added Midsummer HQT.  
    Sorted items by alphabet.  
- Unsorted clean for midsummer  
- Midsummer update (someone fix my locale pls I am dumdum)  
- Appearances once again show their VisualID when enabled  
- Retail: Refreshing data for Future Warband Collected now clears cached tooltips beforehand  
- Added lockCriteria between 'My Wings Are Yours' - 'Forged by Trial' / 'No Ordinary Steward' - 'An Earned Bond'  
- Classic: Fixed a Lua error when opening a Taxi map and ATT has no current mapID assigned  
- Removed WIP indicator from Timerunning filter option  
- Added a function to allow toggling ATT's Registered Event debugging (/run AllTheThings.DebugEvents()) [Warning it will spam you out of sanity!]  
- Merge branch 'master' of https://github.com/DFortun81/AllTheThings  
- Sholazar Basin: Battle Pet descriptions  
- Cleaned up Quest event registrations  
- Cleaned up a lot of Event Registration to not manually assign to the underlying event table  
- Parser captures final Ensemble data for DebugDB after cleaning  
- Retail: Cleaned up a bit of Settings loading/refresh sequence  
- Additional location for icon of hope  
- Refreshing Settings now includes a refresh of the active information types (certain settings have been converted into information types without also becoming an information type setting, but changing the setting didn't actually trigger any refresh of the information type it controlled)  
- Minor improvement to GetDisplayID flow  
- WotLK Dalaran: Helper for JC dailies  
- Retail: Various headers given constants and ignored in minilist hierarchies (should help reduce nesting for remix minilist in instances, more adjustments likely)  
    Retail: Adjusted the mapping assignments of Remix Scenario content to make it a bit more concise when inside any given scenario  
- DMF and Trial of Style headers defined earlier since they are used external to their own file  
    Fixed various empty value headers due to bad Globals which caused merging data into the wrong places  
    Added a warning back for headers which are defined with no value  
- to do removed  
- TWW: new build, quick lookaround  
- Fixed an issue & Lua error with Mounts that don't have a name  
- This Is Not A Title  
- Added TWW Tailoring  
- Fixed the Eternal Aspirant's Cape itemID  
    Note: Copying/Pasting at 4:30am is bad  
- - Fixed the Unburied Aspirant's Cloak Ensemble (Blue SL S3/S4 PvP Ensemble)  
    - Added a description to it and the epic version.  Thinking what breaks it is if you own 1 of the cloaks, but need more data.  
- Fix for disappearing scenario weapons + a TODO  
- updated parser configs  
- Generating Missing Files  
- Harvest: 11.0.0.55185  
- HQTs for ensemble  
- Parser no longer attempts to incorporate Criteria data when it is listed under a Difficulty (this should fix some MoP raid achieves being copied into every version of a boss)  
    Parser no longer includes random 'f' values with Types that have no use for a FilterID (only Items utilize FilterIDs for filtering purposes)  
- Fixed the ONE random achievement listed in the wrong difficulty in every MoP raid except SoO  
- Retail: Future Warband Collected should get cleared now for learned Items for any inventory scan (previously was only when opening the Bank on the character who has the Item)  
- Missing quest  
- Generate missing files  
- Sort Recipes  
- Harvest: 11.0.0.55120  
- Harvest: 10.2.7.55165  
- Harvest: 10.2.7.55142  
- Harvest: 4.4.0.55141  
- Harvest: 4.4.0.55056  
- Harvest: 3.4.3.55221  
- Harvest: 3.4.3.55161  
- Harvest: 3.4.3.55136  
- Harvest: 3.4.3.55115  
- Harvest: 3.4.3.55095  
- Harvest: 3.4.3.55085  
- Harvest: 1.15.3.55112  
- Harvest: 1.15.2.55140  
- Added TWW Leatherworking  
- Reinstate some HQTs for Darkal  
- TWW: clear up from backlog before new build  
- TWW: login realms decide to die or new build incoming  
- Moved GLYPH\_OF\_LAY\_ON\_HANDS\_AND\_FLASH\_OF\_LIGHT from minor to northrend research.  
- fixed spelling from a tome note and put it on the item itself for easier visiblity.  
- updated scenario theramore items so its more clear that you can just buy the toys.  
- Update Scenario.lua  
    I was mistaken  
- Fixed the spelling of "raiting" to "rating"  
- TWW: another beta session  
- Blizzard with it's SL cloak trolling.  You get Eternal Gladiator's Elite cloaks, but not Sinful Elite cloaks.  Every commit is something new.  Thanks Blizzard  
- Fixed the Elite cloaks.  
- Blizzard trolling with the SL Cloak Ensembles at this point.  Giving Elite mogs out and most can't use?  
- TWW: Skinning  
- Added Glyph of the Long Word / Glyph of Protector of the Innocent.  
- Fixed the SL Cloak Ensemble again.  
    Re-added removed items.  
- More Upgrade logic consolidation  
    Fixed an issue with Upgrades where repeated lookups of the same item would cause it to think it upgrades into itself  
- Fixed `iupgrade` shortcut to use the expected bonusID shift  
-  Upgrade logic revisions for performance and stability  
    * Consolidated some upgrade logic  
    * Localized some heavily-used functions  
    * Now caching upgrade results based on requested modItemID  
    * Optimized some bits of logic  
    * Added a lookup for BonusID upgrades which are allowed to further nest within an upgrade hierarchy (i.e. Awakened upgrade tracks can now show 3 unlocks since they traverse N/H/M appearances)  
- GetSourceID now has a 'quick' option which ignores doing slot-based checking for available appearances  
    Adjusted some InstanceHelper prints  
    S3 Amirdrassil items are no longer considered upgradable in the Main list  
- - Fixed the SL Cloak Ensemble to show the correct cloaks it awards (These were awarded to Lucetia on 06/17/24.  SS in discord)  
- manuscripts are.. manuscripts  
- TWW: typo and itemID fix  
