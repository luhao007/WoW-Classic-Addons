# AllTheThings

## [4.0.11](https://github.com/DFortun81/AllTheThings/tree/4.0.11) (2024-09-04)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/4.0.10...4.0.11) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- retail errors / parsed for release  
- Revised a lot of logic for DisplayID into a Model.lua file (potentially temporary until Classic uses NPC.lua). This allows the same DisplayID blocking to be done in one place for both Model preview and row icons  
    DisplayID calculation is now cached for the respective data  
    Game Tooltip now uses a priority function chain to assign a Model from a reference since Retail & Classic support different tooltip functions  
    Followers can once again show their model  
    Retail: Scrollbar changes now only cause the respective ATT window to refresh once per game frame (there were some situations where dragging a scrollbar would refresh the window multiple times with different scroll amounts in one game frame)  
- Retail: dm fixes  
- TWW/Hallowfall: Stay awhile gossip in Veneration Grounds appears when you accept the quest The Flame Still Burns  
- More Fixes  
- Sweep some retail errors, add Lurker of the Deep coords  
- Source two new Trading Post quests  
- Reparse  
- Some hidden achievement triggers sorted so I can yeet the missing file  
- Updat WSG note that's been wrong for 9 years, fixes #1767  
- Some achievement updates related to TWW main campaign being fully available  
- Parser: Removed some old obsolete Mount handling logic  
    Parser: Removed some arbitrary Mount type assignment being done after we've already calculated what is what  
    Fixed a couple NYI Items from being attached to in-game Mount spells  
- Add final TWW campaign chapter (on plate at least) and Earthen allied race mount  
- Use achievement headers for family battler types of past expansions (current expansion doesn't get one, unfortunately)  
- Moved many "Stay awhile and Listen" quests to the correct positions.  
- Moved entire 'The War Within' questline to one place.  
- TWW/Hallowfall: Simplify the notes/answers for Loremaster's Reward  
- Testing out sourceQuest-only structure for Loremaster's Reward  
- Small note for Arathi Treasure Hoard  
- Retail: Removed the extra nesting of top-level categories in the minilist  
- TWW: Spreading The Light hqt clarification  
- Fix some Widow Arak'Nai coords  
- TWW/Hallowfall: Correct a coordinate for an NPC  
    and remove a piece of the treasure code already present in Spreading the Light.  
- Many small DF HQTs sorting + timelines.  
    Sorted few manuscripts.  
- Converted Zul'Gurub Ensembles to iensemble and moved their HQTs to the backup file.  
- Moved skinning HQT to other professions.  
- theaer troupe is weekly reward from the quest with the same name & the recipes are a reward from the box  
- some duplicates for severed thread recipes  
    found 3 items that are sorted but dont load ingame (digits only)  
- since we are using monthly dates for trading post for a couple months now, we can rename the monthly reward.  
    old: trading post>monthly reward  
    new: trading post>june 2024>filled travelers log  
- delves is now 02 instead of 16 to follow ingame list of  
    d&r  
    delves  
    outdoor  
    due outdoor beginning with O, delves can use 02 and stay above that  
    same with secrets  
- stunning sapphire re-sourced  
- storm vessel is no longer a zone drop & crackling shard can drop from any mob  
- Sorted 'Vow-Taker's Boots'  
- 2 more sorted!  
- Update Skinning.lua  
    Refine Hides+++  
- Bit of sorting perhaps  
- Add breadcrumb sourcequests, fix map coord for LW treasure  
- Fix two sourcequests  
- Retail Errors  
- Fixed: The Wealth of a Kingdom  
- No more parser warnings  
- Sort some rare drops and a bugged quest starter  
- TWW/Isle of Dorn: Treasures do not appear with some delay anymore  
- The titles require renown 25.  
    Added back NYI item.  
- Add TWW Renown 25 titles, sort some unsorted  
- Quest fixes.  
- TWW Profession clean up  
- Blizzard forgot that shaman exists and made 2 less special items :(  
- Added all season 1 tier sets.  
- Minor fixes to BlacksmithingDB  
- Fixes TWW Blacksmithing  
- Missing L  
- Fixed tabs.  
- Fixes to TWW Alchemy  
- Some updating to QuestNames Handling for new expansion  
- Generating Missing Files  
- Harvest: 11.0.2.56421  
- Harvest: 11.0.2.56382  
- Harvest: 11.0.2.56380  
- Harvest: 11.0.2.56313  
- Harvest: 4.4.0.56420  
- Harvest: 1.15.4.56419  
- Harvest: 1.15.4.56400  
- Add TWW paragon boxes, missing inscription weekly treasures, and resort profession weeklies to match other files  
- Retail-Errors  
- Comma Comma  
- Weavercloth Spellthread  
- uncommented catalyst under primal storms. technically primal storm mobs can also drop primal gear which can be upgraded to s1 tier set, but can farm them on forbidden reach. Way more rares & not time based.  
- added catalyst fully into vault of the incarnates as well as into primal storm&forbidden reach  
- more QIs, mostly 8.0.1 but some SL items  
- If the 'if tww' if statement is used, then if I have to decide, should I write it if 'if before tww,' or if after 'df'?  
- sussy if statements  
- more wording for revival cata  
- DF S2 & DF S3 revival catalyst also now show in their respective zones, but only LFR as only event rewards can be converted.  
    wording for raid catalysators  
- Merge branch 'master' of https://github.com/DFortun81/AllTheThings  
    * 'master' of https://github.com/DFortun81/AllTheThings:  
      Update NYI Quests.lua  
- Update NYI Quests.lua  
- moved zaralek wq rewards to zone rewards as they can also drop as zone drop  
    catalyst for s2 & s3 now show inside of the raid instead of under expansion feature similar to s3/s4 from shadowlands. vault still need updating  
- I Fix!  
- blacklisted an item  
- added weekly wording to weekly treasure knowledge in tww  
