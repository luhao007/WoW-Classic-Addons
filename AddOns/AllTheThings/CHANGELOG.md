# AllTheThings

## [4.0.15](https://github.com/DFortun81/AllTheThings/tree/4.0.15) (2024-09-22)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/4.0.14...4.0.15) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- prase to parse  
- Moved Cobalt Eye back to the objective where it belongs.  
- Added Shaffar's Stasis Chamber. Fixed GlyphDB error in Parser.  
- Un-Thanosed Tol Barad  
- Added the Mana-Tombs Stasis Chamber object data.  
- Fixed a Lua bug when attempting to use ignore-quest-print or allow-quest-print  
- Added a Hunter-specific Earthen quest  
- Cata: Added a 'Molten Front' phase between Rise of the Zandalari and Rage of the Firelands.  
- Fix various reported errors  
- Whoops, missed a few.  
- Cata: Moved all Molten Front quests to Molten Front.  
- updated some promo stuff for release  
- Tol Barad - minor correction in comment  
- Removed duplicated map + parsed Tol Barad changes.  
- Tol Barad and Tol Barad Peninsula  
- Quest fixes.  
- Use raw access SourceID cached checks instead of calling .collected  
- Added crs to Conjurer Luminrath  
    Fixed extra parenthesis in Source line  
    AddArtifactRelicInformation can get rawlink from group  
    Partially stubbed an ArtifactRelicCompletion information type  
- Missing providers  
- ...  
- Fixed the faction tag for a few Orgrimmar PVP Vendors.  
- Fix some quest detils and reparse  
- Added the Blackened Urn to Karazhan. Copied over (and commented out) unused (for now) source files to the Cata TOC.  
- Added the rare hunter pet rares to the Molten Front.  
- Cata: Added objectives to the Molten Front.  
- Added the Elemental Bonds quest line as an Expansion Feature for Cataclysm. (rather than it being split up into the different zones)  
- Retail: Fixed an issue where getting search results via SearchLink would not properly combine multiple matching results  
    Retail: Fixed an issue where modified item data (modID/bonusID) would merge into a base Item group which shouldn't have those values (fixes #1793)  
- Fixed some tabs + TWW quests.  
- TWW/Azj-Kahet: Added vendor Bobbin  
    Updated tooltip :)  
- Brewfest now appears in the mini list for Dun Morogh and Durotar.  
- Removed duplicate 'isLimited' tooltip info for Classic.  
- Updated the original Brewfest Steins to show their Filled variants (and tooltips on their respective kegs) for folks that have them.  
- Migrated the 'SpecializationRequirements' tooltip info to information type  
- Migrated a couple more tooltip infos to the extra info information type  
- Migrated a bunch of various specific-Item/Currency tooltip info text into a proper information type (It can still be refined with Parser data at some point but at least it's not doing an extra chunk of conditionals during every search now)  
- Consolidated and improved the logic that adds Shared Appearances to a tooltip  
- Updated The Gnomish Bait-o-Matic in Ironforge.  
- Fix Mereldar Derby Marks and add a tailoring FC  
- Made HOLIDAY\_DROP description usable as a global.  
- Made the old Brew of the Month Club (A) quest repeatable on retail also, as is the case / was intended  
- Added holiday description to Noblegarden too.  
- Attempt to use a standardised description for the revamped Holiday drops  
- Using 'Unknown' for both HQT and regular quests which don't return a valid name for simplicity  
- Add and adjust some renown quests  
- Hallowfall Fishing Derby no longer account wide  
- An argument for 2-digit coords for Hallowfall treasure objects ONLY - the light sources are super picky and standing on our coordinates won't always reveal the chest. Has to be dead-on accurate.  
- Parsed with bar tab barrel's  
- Quest chat prints can now distinguish Unsorted from NYI  
    Quest chat prints for HQT should include their known name  
- Added First Craft for Coreforged Skeleton Key  
- Update Bar Tab Barrel objectids  
- Cata: Added a missing objective for "Aggressive Growth" in the Molten Front.  
- Fixed "Flamegard's Hope" achievement description.  
- Corrected all the objectIDs of the Bar Tab Barrels in Dragonflight.  
- Added new SoD sources into NYI for retail.  
- Cata: Brewfest - Pink Elekks removed for EU this year.  
- Cata: Build numbers are hard for Blizzard Devs.  
- Cata: Added Blizzard's dumbass duplicated items from Coren Direbrew.  
- Brewfest: These are only available after TWW was available.  
- Brewfest: Add a questgiver in Dornogal  
- I like to hit enter.  
- Added all new Bar Tab Barrel quests for TWW.  
    Fixed timelines.  
- Grim Batol update number 548.  
- Removed normal difficulty from heroic+ in SoB.  
    Put m+ difficulty behind mythic.  
- DF was nice, but time to get to TWW.  
- Fixed wrong npc id for Kargand  
- Generating missing files  
- Harvest: 11.0.5.56646  
- Harvest: 11.0.5.56572  
- Harvest: 11.0.2.56647  
- Harvest: 11.0.2.56625  
- Harvest: 11.0.2.56513  
- Harvest: 4.4.1.56574  
- Harvest: 4.4.0.56489  
- Harvest: 3.4.3.56514  
- Harvest: 3.4.3.56262  
- New brewfest cosmetic item for 2024  
- Harvest: 1.15.4.56573  
- Manual maps added to delve achievements to specify exactly where you can or cannot get them  
- Add details to some Hallowfall quests  
- Retail: Fixed link wording for one time fixes  
- Add renown quest and fix some quest details  
- Ignore the Severed Threads quartermaster Vignette alert  
- Fixed Grim Batol.  
- Cata: Added the Stormwind Lobster Trap object for Rock Lobster in SW.  
- Consolidated a lot of Base Class logic to make CreateClass easier to read/understand  
    Improved performance of object creation from a Class with defined Subclasses which are entirely excluded in the ATT version  
    Improved performance of object creation from a Class with Subclasses when no variants are defined for the Subclass  
    Moved around some variant logic to make the code simpler/encapsulated  
- Retail: Revised 'name' function to assign the 'autoname' field (instead of 'type') which is now used internally as 'an' for automatic naming of objects  
- Retail: Added a couple one-time fixes for incorrectly cached ATT data. Users affected will see a one-time message on login stating the specific data fixed  
- Add and fix some Severed Threads quest details  
- Fixed Lua error when trying to view Achievements which have no flags (i.e. old or non-existent)  
- Sort some quest data  
- Now exporting the contents of en\_auto into the LocalizationDB with the rest of the localization related content if its present in the build target.  
- Parser: No longer assign white space values for non-en locales if they are accidentally provided as such (this would prevent the locale from seeing the fall-through en value and instead see no text)  
- Cleaned up bubbleDown for old removed Classic instances  
- Classic: Sync'd toc files between classic versions.  
- New SoB items should be sourced also after the season end.  
- Added new Siege of Boralus items.  
    Re-structured Siege of Boralus.  
- Using nomerge and FILTERFUNC\_itemID tech too. Soon I am out of all ATT tech we have.  
- Changed Grim Batol structure to reflect TWW Season 1 changes.  
- Fixed a logic bug for zhCN / zhTW localizations.  
- Second pass at making the delves mini list a bit more useful  
- First pass at making the delves mini list a bit more useful  
- Merge pull request #1791 from NORPG/master  
    [Localization]zhCN: fix syntax error  
- Clarified a stay awhile quest as someone asked about the criteria of it and I was also momentarily confused  
- Revert "Breadcrumbs don't need lock when they can be put as a sourcequest."  
- Breadcrumbs don't need lock when they can be put as a sourcequest.  
- Retail: coords fixes, skinning elusive beasts, vizier level up hqt  
- Add a breadcrumb and renown quest  
- [localization]zhCN fix syntax error  
- Added "The Kalimdor Cup Begins" quests.  
- Fixed recent changes.  
- Cata: Added GlyphID <-> SpellID collection detection. (Still need to find a way to associate the spellIDs with glyph items though...)  
- Moved the raw ItemDB files to a subfolder so that more raw DB files can be used in other ways.  
- Merge pull request #1790 from NORPG/master  
    [Localization]zhTW: fix syntax error  
- [Localization]zhTW: fix syntax error  
- Fixed NYI LW recipe / Skinning Items  
- PVP Quest/item  
- Fixed coords for Webster  
- Retail: Added Quest chat commands to ignore/allow printing of Quest flagging in chat (i.e. users who get certain quests flagged back and forth on their account constantly for no reason THANKS BLIZZARD can now just use these commands to ignore those quests from being printed in chat instead of needing to run scripts or modify saved variables directly)  
    * /att ignore-quest-print [help] | [questID1 questID2 ...]  
    * /att allow-quest-print [help] | [questID1 questID2 ...]  
- Added some base handling for adding/removing chat commands for /att [command] (WIP) (potentially move to a separate Module if it gets more)  
- Added some info for Skittershaw Spin 40727  
- Add new raid intro quest, sort some rare drops  
- Revised some debug prints in Event handling (commented out, but easier to understand what to comment in when needing to Debug timing or sequences of Events)  
- Removed some extraneous logic in SeachForObject which was inadvertently doing extra filtering on top of what was requested by the calling code  
- Retail: Ignoring a few more pointless Achievement 'statistics' values (i.e. all progress values should show [X / Y])  
- Retail: Achievements marked as Account-Wide from Blizzard will now show the typical Account color in ATT for clarity  
- TryColorizeName can now color Account by 'accountWide' flag for objects  
- You can once again toggle the Death Tracker on/off.  
- Removed treasures which are now not collectable due to removal of the Khaz Algar Lore Hunter achievement.  
- Wrong npcID for Child of Tortolla.  
- Added some notes for And the Meek Shall Inherit Kalimdor.  
- Added coordinates and creature tooltips to Molten Front achievements.  
- Added a mapID constant for THE\_MOLTEN\_FRONT.  
- Rebuilt all DBs and fixed all missing globals.  
- Fixed some stuff.  
- Marked some dragonriding cup quests as repeatable and moved some sourceless quests that were located to NYI  
- Fix and sort some quests  
- Fixed all the current inaccurate Globals used  
- Parser: Made a few tweaks to handling of Globals such that we can now find out what Global values are actually non-existent  
- Update Quests.lua  
- Added the Portal to the Firelands.  
- Update some BFA quartermasters with bubbleDown rep  
- Cata: Fixed a number of achievements for the Molten Front.  
- Hopefully no more flightpath warnings!  
- Weekly TW Quest  
- Update Searing Gorge.lua  
- Expand use of Polished Pet Charm constant to earlier expansions  
- Retail: Moved Contributor setup logic into Contributor module  
- Underground Economics indeed requires all 3 sourceQuests (parse needed)  
- Add some quests and a rare drop  
- Fixed currency cost.  
- Fix a Hillhelm quest and add a Moira stay awhile you probably all missed  
- Azj Kahet coords  
- Update some Shadowlands quartermasters with bubbleDown rep  
- Cata: Updated fishing and cooking achievements.  
- Cata: Updated phase requirements on Cataclysm Crafted Items.  
- Fix and sort some retail errors  
- Retail: Achievements with a progress-based 'statistic' value now show in ATT rows (this can make it easier to see current progress in tooltips which contain an Achievement, i.e. "free this NPC 50 times")  
- missed a comma  
- Merge branch 'master' of https://github.com/DFortun81/AllTheThings  
    * 'master' of https://github.com/DFortun81/AllTheThings:  
      Fix and sort some retail errors  
- updated some update messages  
- Fix and sort some retail errors  
- Merge pull request #1787 from NORPG/master  
    [localization] Migrate classic locales file to default locale file  
- Fixed an oopsie.  
- Tol Barad: Abandoned Siege Engine  
- [localization] Migrate classic locales file to default locale file: Phase 1  
- 'Known By' information now shows for Exploration Areas to help narrow down which characters have discovered which areas for those aiming to actually collect Exploration areas  
- Removed some REMOVED\_GAME\_GAME.  
- Added Dragon Soul Relics  
- Added a bunch of Relics added with Cataclysm and then removed with MOP.  
- Spirit Shards aren't PVP.  
- Cata: Fixed transmog jingles.  
- Fix missed factionID conversion  
- Attached each tabard that can give you reputation with a particular faction as a provider for that faction.  
- Carved Crests not actually account-wide, this was hotfixed  
- Added 11.0 Upgrade Track bonusIDs  
