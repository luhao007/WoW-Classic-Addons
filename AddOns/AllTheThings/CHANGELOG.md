# AllTheThings

## [4.2.7a](https://github.com/ATTWoWAddon/AllTheThings/tree/4.2.7a) (2025-01-16)
[Full Changelog](https://github.com/ATTWoWAddon/AllTheThings/compare/4.2.7...4.2.7a) [Previous Releases](https://github.com/ATTWoWAddon/AllTheThings/releases)

- BFA things  
- Zul Farrak: Desertwalker Cone specification  
- Another Oribos HQT moved  
- Couple HQT updates in Oribos  
- [DB] Added "old" quest: Attunement to the Core.  
- titleID is NOT the maskID, who knew?  
- Contribute: Slight adjustment for object interaction reports since the objectID can differ from the ID of the found Thing (i.e. provider object on a header, etc. we want to see both IDs)  
- Added a 'Hidden Quests' Dynamic category  
- Plunderstorm shows in Main List now  
    TODO - Add proper end date  
- Organized remaining top-level HQTs  
- Add Plunderstorm Titles  
- More HQT organization based on source file  
- todo for plunder  
- plunderwin and plunder 1mil plunder fos are both back  
- Fixed some Korthia data & adjusted Korthia HQT categorization  
- Fix some reported errors, fixes #1763  
- Fixed a duped questID in Timeless Isle and related achievement automation  
- [VSCode] Disable diagnostics on ignored & library files.  
- [DB] Added "old" Stranglethorn Vale quests to the db.  
    Fixed Missing Quest 614 #1861.  
- Revert "[DB] Add crit for ach: A Simple Re-Quest."  
- Revert "[Classic Logic] Replace GetAchievementCriteriaInfo by GetAchievementCriteriaInfoByID."  
- [Classic Logic] Replace GetAchievementCriteriaInfo by GetAchievementCriteriaInfoByID.  
    This is a walkaround to fix the issue with crit not working in classic.  
    It is not final and will need to be reverted when the crit header classification bug is fixed.  
- PTR: daily stuff update + weekly reset (but no new build)  
    -  
- [DB] Try to fix parser error in classic: q: 31145.  
- [DB] Try to fix parser error in classic: q: 31137.  
- [DB] Try to fix parser error in classic: q: 41218.  
- [DB] Try to fix parser error in classic: q: 75189.  
- Fix symlink for Pool Cleaner  
- [DB] Delete wrong questid.  
- Add 6 month sub items, timeline out Diablo IV promo  
- [DB] Update crit of ach: Exile's Reach.  
    Since Shadowlands was launched in retail, the conditions for obtaining the achievement have been changed to be based on HQT.  
    The situation where you need to complete subsequent tasks in the capital should only exist in the beta.  
- [DB] Try to fix parser error in classic: q: 27022.  
- Fixed last class (warrior) elite gear in TWW season 1.  
- [Misc.] Add annotation: inst.  
- [Misc.] Add annotation: map.  
- [Misc.] Add annotation: npc.  
- Added 'RowOnClick' to the ignored debug events (it's still too spammy for me)  
- Contribute: Check for non-sourced openable objects can now include provider-referenced objects  
- Various Hallowfall achievement updates  
- Contribute: Object check now includes when objects are listed as providers for other Things as well  
- [DB] Add another mapid: Tak-Rethan Abyss.  
- [DB] Update InstanceDB.  
- PTR: daily stuff update  
- Revert "[DB] Remove custom header: Nightmare Grove."  
- Revert "[logic] add RealzoneTextRunner."  
    mini list broken again, revert commit :( .  
- Source more GameObjects to the quests, add some coordinates  
- WoD: Source some GameObject with their Quest Items  
- Swamp of Sorrows updates  
- Some quest sorting  
- Adjusted TWW achievements because "kill boss on mythic" has remained a valid criteria for past achievements so we can reasonably assume the pattern will continue (unless it is ruled a bug and gets fixed....)  
- Last bunch of 11.1.0 achievements (for now, probably...)  
- [DB] Remove custom header: Nightmare Grove.  
- [DB] Update instanceDB: SoD.  
- [DB] Update InstanceDB.  
- [DB] Update InstanceDB.  
- [logic] add RealzoneTextRunner.  
- [DB] Try to fix syntax.  
- [DB] Add crit for ach: A Simple Re-Quest.  
- [DB] Update crit of ach:Thirty Six and Two.  
    source: https://wago.tools/db2/CriteriaTree?build=10.0.5.47118&filter[Parent]=68043&page=1&sort[OrderIndex]=asc  
- Using otherwise hidden criteria to add nuance and automatic nesting to these faction achievements  
- CHETT and SCRAP stuff  
- 11.1.0 factions  
- Added 2 missing timelines for new 11.1.0 achievements.  
- Undermine adventurer and treasures  
- 11.1.0 worldsoul stuff + some data fixes for current worldsoul achievements  
- Undermine Safari  
- Family battler of Undermine  
- BFA updatez  
- PTR: Profession recipes that exist for player  
- Update Silithus (The Wound).lua  
- Update 11 - The War Within.lua  
    Skinning King Splash  
- Update Sourceless.lua  
    Bad at saving things oops  
- Hallowfall: Consolidate quests related to Lost and Found achievement under a separate header  
    Closes #1883  
- Searing Gorge updates  
- PTR: more open world stuff and some delves  
- Loch Modan: Cleaned up Mo'grosh Masher  
- Burning Steppes updates  
- [VSCode] Disable auto-diagnostics.  
- [Localization] Update zhTW: Battered Chest.  
- Reparse retail for delve changes since we know what is staying and leaving based on PTR  
- Loooooots of new delves stuff and also delves changes now we can see what is in season 2  
- Fix some reported errors  
- Fixed timeline for 11.1.0 achievement.  
- Fixed wrong lockCriteria for Iron Mining Pick.  
