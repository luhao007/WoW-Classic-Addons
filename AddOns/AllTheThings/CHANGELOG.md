# AllTheThings

## [4.0.5](https://github.com/DFortun81/AllTheThings/tree/4.0.5) (2024-08-16)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/4.0.4...4.0.5) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- parseing  
- Parser: Added 'isEnableTypeRecipe' (bool) field for special Recipes which can only be marked as collected by interaction with a specific NPC or location  
    Applied 'isEnableTypeRecipe' to Tanaan Jungle Jewelcrafting Recipes  
    Retail: Recipe collection no longer removes 'isEnableTypeRecipe' Recipes from being collected when they are not 'disabled', unless interacting with the proper profession UI  
- added nl & cos m+ drops  
- Retail: Revised use of Colors since in some cases it could result in an infinite metatable recursive reference to itself (fixes #1720) (fixes #1668)  
- Assign factions for RaceDB directly since Classic parses have differing values in faction lists  
- Added a symlink to Collapsing Riftstone  
- Fixed Proving Grounds HQTs timelines for Darkal  
    SourceIgnored groups are now also ignored for GetSearchResults logic for selection of the resulting root group (fixes situations where Achievements wouldn't show their inherited awp/rwp values in tooltips; other duplicate-source Things would still have this issue)  
- Earthen duplication yeeted  
- RaceID is now cached for lookups  
    RaceID can be used in CreateObject  
- Added support for 'Race' automatic header type  
- Couple of TODO notes for stuff I can't fix immediately :(  
- Allied Races: Earthen is not cooperating as a chievement so I slapped a fix on it for now  
- Faction achievements given minimum reputation, moved under faction headers, fixed wrong factionID for Assembly  
- Parser: Pure Lua exported tables are now exported in sorted order by their keys  
- War Within Delves: Endgame achievement was changed  
- Retail can has parse too  
- Beta parsed with beta source harvest  
- Fresh batch of Wago files  
- Unbound Bounty achievement is finally working correctly  
- Updated achievementDB  
- TWW: Clean up backlog  
- Moved Proving Grounds HQTs to Proving Grounds file for better organization  
- Fixed FactionData generation from RaceDB  
- RaceDB now contains 'faction' as matches HORDE\_ONLY and ALLIANCE\_ONLY lists  
    FactionData is now driven from RaceDB  
- Added a Database Exports file to setup the Exports container  
    Added RaceDB to Exports container so that it is now automatically exported by the Parser from raw data (existing stucture and values are available)  
    Updated the Races Class to properly support new data in RaceDB  
- Parser: Extended Export with 'Pure' Lua (doesn't do all the ATT conversions and data changes when exporting)  
    Parser: Can now read the 'Exports' table to directly export pure DB files for the addon  
- Retail: Added handling for a group to provide a 'OnSetVisibility' function for itself for when we expect the group to process all typical Update handling, but provide an additional visible allowance  
    Retail: Fixed Quest chain display sorting/visibility by utilizing OnSetVisibility  
- name for object 180682 Oily Blackmouth School  
- Retail: Removed RunnerStats (it's already in Analyzers module)  
    Retail: CheckSymlinks Analyzer go brrrr  
- Retail: Re-harvested ReagentsDB (including unsourced recipes)  
- Retail: Updated Recipe harvesting (now stored in typical harvest saved variable)  
    Retail: HarvestRecipes now properly checks for required Reagents  
- Retail: Re-designed Filling for Craftable Items  
    * Now changes as expected with Settings changes after being filled  
    * Filled Items are linked to their crafting Recipe Skill such that they filter appropriately with user settings (instead of filling differently based on BoP Reagent + known Profession)  
    * Crafting outputs for Unsourced Recipes are now included (previously for BoP Reagents they would be omitted since it was unknown whether the player could craft the output)  
- Since all objects that we need for achievements are now sourced, unsourced object has been upgraded to a parser warning.  
- Wrapped C\_TradeSkillUI.GetTradeSkillTexture in WOWAPI  
    Retail: Profession requirement in tooltips now includes an icon if possible  
- Restored and split out some things for Classic  
- Fixed RecipeID caching to work as required  
    Cleaned up row Summary generation to more-easily support additional information  
    Added Profession/Required Skill icon to Summary information  
- Fishing objects yay  
- added brh, dht&hov m+  
- The Scavenger achievement objects  
- Northrend angler objects + some missing automated notes  
- Parser support for automating fishing achievements via Wago data, sourced objects for non-classic version of Outland Angler achievement  
- Objects for dungeon and expansion feature achievements  
- The sourcing of achievement objects continues  
- Cleaned up commented out achievements and either moved them to HAT or NYI + added some new achievements too  
- Various Zskera Vaults quest fixes  
- Unsorted item and some incorrect headers  
- Parser: Greatly improved parsing time by fixing duplicate parsing of various global DBs generated during parsing (e.g. ItemDBConditional was being re-parsed by every file which added to the DB, re-accumulating all the data every time, leading to a final set of nearly ~250K data elements being conditionally applied. In total there are actually about 11K unique data elements in the DB)  
- Parser: Now accepts and consolidates the 'sharedDescription' field. This should be used in situations where lots of individual content within a single group is all sharing an identical description (i.e. TWW Pre-Launch Recruit Items)  
- Fixed a Lua error when inventory scan fails to retrieve an item's info after 5 attempts  
- Minor cleaning  
- Generate Missing FIles  
- Harvest: 11.0.2.56110  
- Harvest: 11.0.2.56071  
- Harvest: 11.0.0.56008  
- Some Parsing of Beta/PTR  
- Retail: Fixed a Lua error where some Professions failed to render an icon (fixes #1728)  
- Follower Dungeon difficulty now maps as Normal Dungeon for minilist use (fixes #1716)  
- Adjusted 'es' translation for 'Disturbed Dirt' to match actual in-game text (differs from Wowhead) (fixes #1718)  
- Git should now be on 11.0.2  
- Parser update  
- Some remaining cleaning of timelines  
- Remaining Timeline Changes  
- Structures > Prof Timeline Changes  
- Professions Timeline change  
- PvP Cleanup and Timeline Change  
- EF Timeline Change  
- Timeline + Lore Changes for Zones  
- Ringing Deeps Max Level Chapter  
- Merge branch 'master' of https://github.com/DFortun81/AllTheThings  
- Parser: Fixed an issue where Ensemble cleanup could randomly cause a concurrency exception when debugging  
    Parser: Fixed an issue where Ensemble-Sourced items were receiving a 'races' field instead of the 'r' field for the whole Faction (this is likely the cause of why many TWW pre-patch 'Recruit' items were not being properly flagged as collected in Unique mode from their matching Faction-restricted BFA Ensemble shared appearances) (fixes #1717)  
- Azj Max Level Chapter  
- D&R Timeline Change  
- Placeholder Timeline for Prepatch End, Further Timeline cleaning  
- Some DBs (Still need further cleaning soon) with timelines  
- Mythic+ Season Tempered!  
- Updated InGameShop Information.. Loads of missing pieces  
- Parser: Now accepts OnSourceInit to provide an OnInit for the specific source (since OnInit assignments are copied to all Sources of the Thing)  
    Parser: Improved the Lua function compression a bit  
    regionExclusive/regionUnavailable now use OnSourceInit  
    Mount properly cache themselves by 'mountID' (fixes Mount type being considered 'missing' in ATT using general logic)  
    Retail: Minor adjustment to common Unobtainable logic for NYI/Removed Items having multiple Sources (due to per-Region availability differences, thanks Blizzard :weary:)  
- waifu whitemane loot is back  
- Reharvested SourceIDs  
- Some unsorted for rares in Azj  
- chinaOnly() Darkal/Runaway NYI?!?!  
- Added in some old Tailoring Information while reworking undergoing  
- Commented out some achievements that aren't loading anymore or have otherwise been (soft) removed. Will sort them better later!  
- Retail: Various rendering improvements (should not have very noticeable visible differences)  
- Retail: Update TOC  
- Parser: Fixed some potential gaps in DataValidator & validation Reason will now be provided in log message  
    Parser: Added validation on 'collectible' field to only accept 'false' when provided  
- Source WoD ring  
- Move Watcher petDB entry from NYI to launch timeline  
- Retail: Future Warband Collected no longer excludes due to Class restriction (account for 11.0.5 confirmed change)  
- Twitch gifts cost real money  
- You WILL collect NPCIDs and you will LIKE it  
- updated note for something that nobody ever reads  
- Fixed BRF Essence tokens to be the proper item/quest association  
- Add Smouldering Phoenix Ash creature source  
- Parser: Now removes the 'c' field from data when equivalent to ALL\_CLASSES  
- Fix broken FAQ link  
- Source quest item, fixes #1724  
- Parser: Consolidated some DB file merging logic  
    Parser: Consolidated some conditional file export logic  
- Add TWW launch Twitch promos  
- Classic: Reclassified the phase identifier for enchants that were originally added with BWL to use "PHASE\_THREE\_ENCHANTS" instead so that the value can be changed in SOD. (not sure if the enchants are in yet, but we'll see)  
- Classic: Reclassified the phase identifier for crafting recipes that were originally added with BWL to use "PHASE\_THREE\_RECIPES" instead so that the value can be changed in SOD.  
- Classic: Reclassified the phase identifier for DMF cards to use a new constant "PHASE\_THREE\_DMF\_CARDS", but use the same phase ID. This will help categorization later in future SOD releases.  
- Added a warning message if trying to merge non-table data into a DB container  
- Added object data for Symbol of Lost Honor.  
- Parser: ItemDBConditional now works properly with modItemID keys  
- Charred Locket details  
- Sourced pandaria outdoor zone objects that belong to achievement criteria  
- SOD: You can buy the Dawnbringer Shoulders recipe from the Argent Quartermasters.  
- TWW: fixed dungeon crs for some bosses, added follower dungeon difficultyID (commented out)  
