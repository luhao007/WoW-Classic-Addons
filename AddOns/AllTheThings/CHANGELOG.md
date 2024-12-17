# AllTheThings

## [4.1.8](https://github.com/ATTWoWAddon/AllTheThings/tree/4.1.8) (2024-11-15)
[Full Changelog](https://github.com/ATTWoWAddon/AllTheThings/compare/4.1.7...4.1.8) [Previous Releases](https://github.com/ATTWoWAddon/AllTheThings/releases)

- Add note on BRD key caps  
- Sort some hqts  
- Add new guest relations secrets  
- [GitHub Action] Extend the artifact retention days from 1 to 7.  
- [GitHub Action] Alpha release changes from weekly builds to daily builds.  
- Removed Hidden Categories Window due to a major bug.  
    I'll add this in the future when I'll have working solution that won't be re-writing current categories.  
- [GitHub Action] Run All flavors in single job.  
- [GitHub Action] Build with multi flavors.  
- Deepen history in a different way  
- Fetch the last 2 tags  
- Fetch tags manually  
    Can't do that through actions/checkout due to https://github.com/actions/checkout/issues/1467  
- Try fetching through actions/checkout  
- [GitHub Action] Add job depends.  
- [GitHub Action] Fetch without all tags.  
- [GitHub Action] Remove dummy fetch.  
- [GitHub Action] Limit Fetch to only the latest 200 commits.  
- [Github Action] clone without LFS.  
- [GitHub Action] Remove delete db files.  
- [Github Action] Update artifact flow from v3 to v4.  
- [GitHub Action] hybrid build flow test phase 1.  
- PTR: 11.0.7 build 57528  
- Retail: More localisation, added questID for previous TW week  
    wow anniversary fix for text field replace itself with static text  
- ShouldExcludeFromTooltip should also apply to object tooltips. (noticed in Hellfire Ramparts)  
- But like actually this time  
- Update guest relations quest and hqts  
- Add new guest relations secrets  
- ZG: removes descriptions from faulty artifacts.  
- Retail: localisation (a bit) and sneaky ptr update  
- Added a few tags to faction/class restricted Mounts  
- Fixed flags in Hidden Categories window.  
- Added Hidden Categories Window: /att hidden  
    Individual sub-categories can still be called with commands: nyi, hat, hct, hqt, sourceless, unsorted  
- Non-consequential Parser code changes from trying to debug stuff  
- Guest Relations Temp Object Data  
- Removed some pointless filter assignments on Achievements  
- Add 11.0.7 MoP timewalking rewards  
- Update guest relations secrets  
- Classic: Fixed a Lua error when trying to plot waypoints  
- Migrated all ExplorationDBs into version-specific files  
    Reparsed all versions  
- Parser: Now includes the constant 'debugging' metatable at the end of the localizationDB instead of in a non-related file  
    Migrated Presets.lua into Retail/Classic ClassPresetsDB.lua  
    Reparse all flavors to remove reliance on Presets.lua  
- Bag of Timewarped Badges contains Timewarped Badges  
- Moved Retail ExplorationDB to ExportDB for consistency and removal from /db/ folder  
- ExportDB can now store '\_Compressed' keys to indicate which DB outputs should be compressed instead of including newlines for each key  
    AccountWideQuestsDB and ReagentsDB will now be compressed in ReferenceDB  
- Added some of the TWW Hidden Currencies.  
- Added some HAT timelines and changed them all into ADDED instead of CREATED.  
- Added Hidden Currency Triggers / Trackers.  
- Update zhCN locales (#1848)  
- More BFA metas  
- Removed warnings for 'Player'-shared Quests in Contributor mode  
- Parser: Can use '\_forcetimeline' to ensure that the applied timeline of a group does not get ignored due to a parent group with an earlier removal (only needed in rare circumstances)  
    Adjusted a couple 13th anniversary quests to be accurate  
- Updates  
- Update Guest Relations.lua  
    Lets fix this provider  
- Removed notes from BC Vendor Ensembles since they're learned 100% after relog  
- Parser: Removed Ensemble Cleanup logic as it has become apparent that Blizz now properly grants all Appearances even when Class/Armor differentiated from the general requirements of the Ensemble (Please report any weird Ensemble issues if encountered of course)  
- Update The Theater Troupe.lua  
    Coord fix  
- With parse we sometimes can fix incorrect id's  
- FIxed ranks and ordering of some JC SL recipes (fixes #1729)  
- Add some new 11.0.7 meta achievements and new Cata/Legion timewalking rewards  
- Adjusted areaID value checking slightly when checking player location exploration (fixes #1847)  
- Add new guest relations quest  
- Retail: Don't think we want to arbitrarily mark all quest objectives as uncollectible...  
- Update Contributor.lua  
    Added Direbeak Hatchling  
- DF Season 4 Normal Tier Sets are still obtainable in Catalyst from Mythic Dungeon Items.  
- PTR: 11.0.7 build 57409 data (once more)  
- Added object data for Drakkari History Tablet.  
- Cata: Adjusted the Defense Protocol Common Boss Drops header to not show the source outside the mini list so that it obeys the filtering rules established by the presence of the buffs.  
- Cata/Wrath: Updated the BuffIDs for the rest of the wrath dungeons.  
- Cata: Updated the BuffIDs in Trial of the Champion's Defense Protocols.  
- Classic: Fixed a bug with achievements that don't have rewards not showing their meta achievement data.  
- Added some of the upcoming meta achievements  
- Reworked Zul'Gurub description again. This time with nomerge so it works as expected.  
- Fixed MissingItems.txt from stashed changes merge.  
- Reverting Darkal's changes to Zul'Gurub (it broke descriptions)  
- Removed some unused commented out code. (now that DPA uses a different format)  
- Cata: Fixed some incorrect criteriaIDs for Gamma achievements.  
- Cata: Fixed a bug with Champion of the Frozen Wastes showing under every version of Cyanigosa.  
- Cata/Wrath: Updated the format of all the Defense Protocol Dungeons.  
- Whoops, missed one.  
- Cata: Added maps to the Protocol Inferno Common Boss Drops header.  
- Cata: Added Protocol Inferno for Heroic+ Cata Dungeons.  
- Drake of the North Wind also drops from normal mode.  
- Removed some duplicated listings of Techniques in M+ versions of dungeons  
- Cata: Added Protocol Inferno dungeon achievements.  
- Classic: Updated Halls of Lightning and Halls of Stone to utilize the new Defense Protocol Headers.  
- Parser: Fixed a bug involving negative headerID values generating a non-unique hash for encounterHashes.  
- fixing hallows end fudge  
- Elegant Rune already properly linked in the providers list.  
- Updated Parser to allow nesting encounter data underneath specific headers. (this is prep work for Defense Protocol Alpha, Beta, Gamma, etc)  
- more old QIs & fixing candy bucket error text for parsing (hi darkal!)  
- Added a helper for "ShouldExcludeFromTooltip" to replace the relative difficulty logic filtering. This is to allow for non-difficulty headers to also override their source visibility conditionally. (such as for titan rune dungeons, etc)  
- Moved the creatureID default field to the shared default field section.  
