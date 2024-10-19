# AllTheThings

## [4.0.18](https://github.com/DFortun81/AllTheThings/tree/4.0.18) (2024-10-13)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/4.0.17...4.0.18) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- ppppppparsa  
- Runner errors should now include stacktrace without Debugging  
- revert id check.  
- Migrate GetSpellCooldown.  
- Uniform the return values of GetItemID.  
- try to fix Runner error  
- Couple mobile NPCs  
- Add garrison inn daily quests to MobileNPCDB  
- Cata: Fixed level requirement for Guardians of Hyjal: Firelands Invasion!  
- Fixed the quest giver for The Old Barracks.  
- CATA: Add multiple Howling Fjord objectives  
- CATA: Add multiple Grizzly Hills objectives  
- CATA: Add multiple Dragonblight objectives  
- CATA: Add multiple Borean Tundra objectives  
- Converted all Argent Tournament manual On* functions into proper ReferenceDB functions  
- CATA: Add multiple Terokkar Forest objectives  
- CATA: Add multiple Shadowmoon Valley objectives  
- Parser: Handles reference checking for ReferenceDB.OnClickDB keys as well  
- Removed auto expanding from AWP window.  
- Parser: Now includes ReferenceDB reference checking for OnUpdateDB and OnInitDB for when those begin to receive exported functions  
- CATA: Add some Deepholm objectives  
- Added more objectives for Deepholm.  
- Moved 'The Long Hunt' under the Quests header  
- Parser: No longer affects verbatim strings within Lua functions when performing Lua compression  
- Neither the Boots of the Bay nor the Dread Pirate Ring were a reward from the STV fishing event until 5.1.0.  
- Rebuilt RefenceDB for all classic flavors.  
- Grant Anima Appeal's Appeal  
- [Localization] Update zhTW.  
- A little change to DF herbalism discovery recipes.  
- note for some crests so I dont have to think with all their wierd names and shit  
- updated october trading post to not dissapear once 11.0.5 releases  
- added maps header for discovery  
- Parser: Lua compaction cleans up a bit more whitespace  
    Parser: ReferenceDB now uses Lua compaction on the OnTooltipDB values  
    Partially updated some ReagentsDB  
- Retail: Added some colors to the hidden windows so that Things there are more obvious in tooltip source lines  
- Rebuilt Classic DBs with all the recipe data.  
- Some Zekvir HQTs that popped today  
- Revert "Deleted the old item recipe cache we had before ProfessionDB."  
- Throw vaporware SL callings into NYI, add some HQTs  
- AccountWideQuestsDB and ReagentsDB are now baked into ReferenceDB instead of being manually-updated separate DBs  
    AccountWideQuestsDB now has some preprocessors and template logic in case Quests need to be split by Version  
    AccountWideQuestsDB no longer includes any Quests prior to MOP Version  
- Parser: Now strips out un-referenced OnTooltip keys from the ReferenceDB  
    Fixed a Lua syntax error highlight in the Phases file  
- Explicitly marked a couple of phases for some enchanting and tailoring recipes that can be bought all over the place.  
- Converted remaining random OnTooltip functions into ReferenceDB functions (makes it very clear to see what OnTooltip functionality is custom-added everywhere, even if only used in one place)  
- Use `maps`; don't put raw map headers in places (This would make these recipes show up in the root of the minilist in that Zone which makes no sense)  
- overgrown herbs can only be discovered in emerald dream, using map header?  
- Added IsSpellOnCooldown OnTooltip which supports whatever SpellID is on the current group  
    Added a function template GenerateOnTooltipSpellOnCooldown which can generate a custom OnTooltip for a specified SpellID  
- Fixed MDI and AWC toys to show before 11.0.5. Maybe it can help someone for the last few days lol.  
- First crafts and first skins changed to HQTs.  
- Goblin Rocket Boots was originally from a recipe.  
- Converted a lot of duplicated OnTooltip functions in Categories into single-referenced functions from OnTooltipDB [WIP]  
- HQTs should support WithAutoName variant  
- Don't forget about TBC!  
- Deleted the old item recipe cache we had before ProfessionDB.  
- Reparsed all Versions  
- Refactor/music rolls selfies (#1814)  
    * Retail: Music Rolls & Selfie Filters are no longer their own separate collectible Type and have been refactored into Character Unlocks since their underlying collection mechanics are identical.  
    Custom OnTooltips are now inherently supported by ExportDB and can be referenced by the object directly instead of duplicating custom OnTooltip logic throughout Categories.lua (this makes any errors far easier to track down)  
    Parser: No longer attempts to create Music Rolls and Selfie Filters [WIP]  
    * Parser: Cleaned up after Music Roll / Selfie removals  
- Enchanted Elementium Bar was phase 3.  
- Updated Engineering quests to not use a description, but instead include the required level to start it.  
    When in debug mode, the phase data will now be displayed in tooltips regardless of state.  
- Added all Mount Mods questIDs into AccountWideQuestsDB.  
- Add missing phase data for Blacksmithing recipes.  
- Parser: ReferenceDB is now always exported alphabetically to reduce change sets  
    Parser: Pure Lua string exports now supports verbatim strings (i.e. using ~ to not wrap in quotes)  
- ExportDBs are now exported into a single, non-dependent ReferenceDB.lua file (instead of LocalizationDB, since that needs to load later in TOC sequence currently)  
    Fixed TOCs to reference the single ReferenceDB per Version  
- ExportDB DBs are now directly included in the LocalizationDB for each game Version instead of being their own separate DB files (TOC updates inc)  
- FlightPathDB can once again just use ExportDB for simplicity instead of being smushed into the LocalizationDB  
- Coord fix for Right Between the Gyro-Optics (needs parse)  
- Merge branch 'master' of https://github.com/DFortun81/AllTheThings  
- ExportDBs are now split by Parser into their respective Version folders since they are able to be built differently during Parsing. This way each Version can specifically exclude or include data as intended  
- Added the Magnetized Scrap Collector.  
- Updated Leyara's Locket's quest chain.  
- Luxurious Silk Gem Bag came out with the Molten Front.  
- Fixed a couple issues with variants for Retail/Classic  
- Wording adjustments for name()  
- Simplified CreateClass a bit more and added the ability to support variants on Classes (rather than only on sub-classes) (we still can't support multi-variant classes yet...)  
    Quest & CharacterUnlockQuest classes can now directly use the WithAutoName variant  
- Retail: Fixed Item Harvester load issue when in Debugging  
- Adjust description and added KA maps for Ethereum Void Reaper since it very much seems to not spawn in any Instanced content  
- Added some missing Hyjal coords.  
- Added some more objectives to Deepholm.  
- Retail: Added chat note if trying to use 'itemharvester' without having loaded with Debugging flag  
- Retail: ItemHarvester functionality migrated to Item.Retail Module & locked behind 'Debugging' flag  
- Added some missing objectives to Deepholm.  
- Retail: CostItem and CostCurrency groups now use CreateClass to create the wrapped object instead of doing so manually  
- Migrated Currency Lib to Module  
    Moved GetPopulatedQuestObject closer to usage  
- Adjusted AttachTooltipSearchResults to pull from a tooltip cache based on the group being rendered into the tooltip instead of caching the tooltipInfo into the group itself. However this is not fully-effective yet since some tooltipInfo currently relies on the group receiving an Update pass, and we clear Search groups so often that we rarely actually re-use existing Search groups to obtain cached tooltips...  
- Fix some reported errors and add some mobile npcids  
- Removed some duplicated WipeSearchCache calls which are handled by preceeding events  
- Retail: Fixed priority on Source(s) group in popouts  
- Retail: Fixed priority of Cost and Total Cost groups within a popout  
- TWW/Azj-Kahet: More Rumors  
    TWW/Azj-Kahet: Move some vendors to the Severed Threads where they belong  
- Fixed AddEventRegistration when 'doNotPreRegister is true to actually store the function for later registration to access  
- Wrong NPC ID for Blazebound Elemental.  
- Added the Flameseer's Staff.  
- Classic: Now using the OnNewPopoutGroup event.  
- Added an ignoreChildren parameter to CloneObject.  
- Switched to CloneObject for Gear Set and Shared Appearance lists  
    Removed unused 'hideText' field  
- SearchForMergedObject replaced by key-based SearchForObject (since this inherently prioritizes results based on Accessibility, which accounts for some Filtering values)  
- Retail: Source Quest logic moved to 'OnNewPopoutGroup' handler and cleaned a bit  
- Adjusted SortPriority such that the default is 0  
- Fixed GlobalStrings being replaced and re-copied from Townlong Yak  
- parser for retail and classic  
- bnet balance into real money update (part2)(finished)  
- Added a 'SortPriority' to the Global sort  
    Retail: Now using a new Event 'OnNewPopoutGroup' to handle Module-based integration of data into Popouts (Classic wasn't using any of these data injections anyway so I haven't changed that version)  
- changing BLIZZARD\_BALANCE to real\_money (update1)  
- updated blizzard balance tooltip  
- AddEventRegistration can now skip pre-registering the Event during OnReady if desired  
    RefreshSaves is no longer triggered due to UPDATE\_INSTANCE\_INFO being fired when loading the game, and its manual handling from OnStartup is moved to OnRefreshCollectionsDone  
- updated ka'muko coordinates and removed resonance crystals (its double dipping on kej tooltip, since you can buy kej for reso and vice versa)  
- Retail: Some random cleanup in ATT.lua  
    Retail: Moved BuildCost and BuildTotalCost to Cost Module (WIP)  
- Retail: UpdateGroup evaluation for a valid group now includes any 'forceShow' groups (eg. popouts of a Thing which doesn't meet your current filters will still evalute visibility on the sub-groups instead of just showing nothing due to the root group not matching filters)  
- Retail: Settings UpdateMode now does a Callback event for OnRecalculate since some keybind toggles end up triggering UpdateMode multiple times in a single frame (probably need further clean up of this logic to better-utilize Events instead of manual update calls)  
- Shared Appearances and Gear Sets headers within popouts can no longer be popped into their own popouts  
- add comment.  
    add some explanations to make reading this code a bit easier.  
- Added more mobile NPCs (Bligntron, Nomi, etc.)  
- Migrate Faction APIs.  
- GetPlayerPosition now returns a 4th parameter to indicate if the returned coords are fake (due to being inside an instance or otherwise unavailable)  
    Contribute: coord ignore checks are now functions  
    Contribute: Added an ignore check for Creature coords which checks a MobileNPCDB (used to assign NPCs whose coords are greatly varied or based on Player position)  
- Migrate GetSpellLink and GetSpellIcon.  
- add C\_QuestLog cache.  
- Mirgate GetTradeSkillTexture.  
- Change the parameter names.  
- Removed the Event sequence for OnStartupDone to call OnRefreshSettings  
- Retail: The 'no entries found' row in popouts can no longer itself be popped out  
- GetRelativeDifficulty consolidated between Classic/Retail  
- Moved DLO functionality to the base Class file  
    CloneArray is now roughly ~2.5x faster and supports cloning into an existing table if desired  
    Retail: Replaced RawCloneData with CloneArray since the only existing use cases required that functionality  
    Retail: Removed a couple unused locals  
- Fix Alliance Vanguard symlink  
- Retail: ATT tooltips for ATT windows now refresh themselves if the row content for the tooltip changes within the row while the tooltip is visible (i.e. scrolling a list while cursor is over the rows)  
- Retail: Moved the first settings refresh to explicitly be called during OnStartupDone instead of coincidentally during other actions  
- Retail: Remove a temporary app flag to allow OnInit to occur rather than set a flag permanently  
- Added Mount Mods dynamic group.  
- Brann level quests are HQTs.  
- Generate Missing Files  
- Retail: Refresh Collections now uses an AfterCombat callback instead of coroutine to handle delaying Refresh until after combat  
- [Localization] Update zhTW of Phases.  
- Harvest: 11.0.5.56865  
- Harvest: 11.0.5.56749  
- Harvest: 11.0.2.56819  
- Harvest: 4.4.1.56859  
- Harvest: 4.4.0.56713  
- Harvest: 1.15.4.56857  
- Harvest: 1.15.4.56817  
- Harvest: 1.15.4.56760  
- Harvest: 1.15.4.56738  
- Harvest: 1.15.4.56718  
- Harvest: 1.15.4.56708  
- Fixed missing local reference in Waypoints (i.e. when plotting and no coordinates are found)  
- Ensemble questID fix.  
- [Tools] Replace absolute paths with relative paths  
- Moved and symlinked Kir'xal from Nerub'ar Palace to help show where to spend the Curio when in Azj-Kahet  
- Strip unnecessary ensemble data  
- Fixed Web-Wrapped Curios symlinks that got copypasta  
- Fix various reported errors  
- Fix the installation failure when no Interface/Addons  
- Update some class filters to use constants  
- [VS Code] Update setting  
- Kaja'Cola Machine -- Perhaps better instructions?  
- Added the only currently-missing Enchanting recipe  
- DmF: Darkmoon Treasure Chest  
- Fixed NPCID for the Fallowspark Glowfly  
- Fix various reported errors  
- Sources are now always refreshed when in Debug mode or tracking Appearances  
    Unique appearance collection is now triggered after Source refresh  
    Removed unnecessary external handling of DoRefreshAppearanceSources (this could prevent Sources from properly refreshing during force refreshes)  
    Event Handling revised such that Sequence Events will always follow any set of chained Events handled by the called event, in the order in which they are requested to be performed. This allows us to be a lot more confident in our Event usage as to the alignment of Events being handled, even when using a Runner internally to reduce stuttering.  
    Refactored many Events such that the expected order of operations is maintained with much less manual Event sequencing required  
    Retail: app:RefreshData removed -- this logic sequence is now entirely Event-driven, and some logic branches were never used  
- HQT quest chat reports will now remain as 'Unknown' if they have no name instead of reverting to the default quest name (Quest #...)  
- Added Silken Court normal npcIDs  
- Re-added the 25 limit for provider listings in tooltips (some achievements are crazy)  
    Retail: One That Didn't Get Away no longer lists all fish as providing the whole achievement since it's automated into the individual hidden Criteria per fish  
- [localization] update zhTW of Phases.  
- my bad  
- Fixed Thimble's Cache to be daily.  
    Added support for FILTERFUNC\_objectID.  
- Retail: delves keys after cost reduction have different questIDs  
- Changed icon of AWP window.  
