# AllTheThings

## [4.5.8](https://github.com/ATTWoWAddon/AllTheThings/tree/4.5.8) (2025-07-07)
[Full Changelog](https://github.com/ATTWoWAddon/AllTheThings/compare/4.5.7...4.5.8) [Previous Releases](https://github.com/ATTWoWAddon/AllTheThings/releases)

- Fix parser error, indent preprocessors a bit  
- [Logic] Retail: Fixed dynamic Pet Battles group to include nested content  
- [Logic] Retail: Added a 'Pet Battles' dynamic category now that the original Pet Battles category got partially obliterated  
- [Logic] Retail: Removed some blanket event handlers from all ATT windows. This logic is already covered by other events and has been added where needed to other ATT events  
- [DB] 'Ultra Prime Deluxe Turbo-Boost' was reset and seems it cannot be actually completed  
- [DB] Coord for 'You Owe Me a Spirit'  
- [Parser] Technically Undermine FP map is 11.1  
- [Parser] Flight Path map is post 11.2  
- [DB] Removed some redundant account wide descriptions  
- Fix a few reported errors, fixes #2067, #2081  
- Finished moving Pet Battle quests to their respective zones and added objectives.  
- [DB] Mists: add more NYI items :)  
- [DB] Add a few NYI items  
- [DB] Mists: add WG heirlooms to SW/Org vendors  
- [DB] Mists: add WG heirloom armor upgrades  
- [DB] Mists: add WG heirloom weapon upgrades  
- [DB] Mists: add new WG heirloom trinkets  
- [DB] Mists: add SW/Org Justice heirloom vendors and set their inv via sym link  
- [Logic] Retail: Removed double-nesting of 'container' results  
- [DB] Mists: remove cost from Dalaran JP heirloom vendor  
- [DB] Mists: add armor + heirloom trinket upgrades to Dalaran JP vendor  
- [DB] Mists: fix Champion's Seal cost for old heirloom in Argent Tournament  
- Fix Sara Finkleswitch/Gentle San coordinates  
    they were swapped  
- Fix broken racing icon  
- Further adjustment for T0.5 ensembles  
- Classic: Fixed some cost logic for containers. (that use headerID, but aren't headers)  
- Moved Sparklematic-Wrapped Box out of the object and into the Rewards header where it belongs.  
- Gahz'rooki's Summoning Stone shouldn't drop in the Barrens yet.  
- Whoops, ADDED\_6\_0\_2 is the constant to use.  
- Disabled Dire Maul's zone-text-areaID implementation for MOP.  
- Moved a lot of the Pet Battle quests to their specific zones.  
- Fixed 11.2.0 timelines.  
- Whoops, wrong key!  
- Moved the initial Pet Battle quest chain to their respective zones. (to the point that I have completed in MOP Classic so far...)  
- Classic: Battle Pets no longer merge into Zone Drops in the Mini List when referenced in another zone.  
- MOP: Karazhan no longer utilizes zone-text-areaID logic to force the area around Karazhan to be considered part of the raid.  
- Converted all of the DMF achievements into automated achievements using Wago data.  
- Fix some reported errors  
- The Map class now sorts all elements below it prioritizing submaps > raids > breadcrumbs > text.  
- [Parser] Now cleaning up empty non-standalone headers in map data.  
- [Parser] Now copying the e, u, classes, and races fields for criteria from the parent achievement.  
- Moved the Fishing section in Mount Hyjal under Professions  
- [DB] Added the 'standalone' property to headers. This declares that a custom header can exist without any relative children or symlinks and will prevent it from being removed by parser in a future commit.  
- [DB] Another coord  
- Replica theory was disproven :( Still looking for a better solution to list these only for those who meet the requirements!  
- [DB] Glyph of the Sun was added in WoD, not MoP  
- [DB] Mists: set common timeline for Dalaran Heirloom NPC and add Heirloom weapon upgrades to the JP vendor  
- K'aresh: Content revision and update  
    - Move "Stay awhile" HQTs in order when they become accessible  
    - Added about a dozen World Quests  
    - Added Mining and Herbalism "FirstCraft" quests and looted quest items  
    -Cleaned up duplicate entries in Unsorted -> Quest Items  
- [Parser] Now moving map related achievement criteria to the Achievements or Pet Battles sections.  
- explorationAch has been deprecated and removed in favor of the default "ach".  
- Tamer, Loremaster, Exploration, and Safari achievements pre-WOD are now automated by Parser.  
- [Parser] Now publishing achievement criteria with map associations to their respective zones. (requires rebuild)  
- [DB] Zuldazar treasure chest & scroll  
- Remove 11.2 delves from tooltips  
- [Logic] Added a chat command (/att calendar-cache) to allow the user to easily reset their calendar cache when needed  
- Merge branch 'master' of https://github.com/ATTWoWAddon/AllTheThings  
- [Misc] Unnecessary local  
- Robes of the Shadowcaster was removed between Cata and Legion.  
- Classic: Battle Pet achievement criteria without an achievement header will now display within the Pet Battles section when viewed within the Mini List.  
- [DB] Vanilla: Crafted Items spell headers  
- Sort some BfA trash  
- [DB] Error gonna error  
- [DB] Vanilla skinning reagents  
- [Wago] Now exporting petBattleLvl and min lvl (beta) for all maps.  
- MOP: Mini List now sorts Pet Battle Quests under Pet Battles rather than in the Quests section.  
- MOP: Scarlet Monastery Entrance is now visible in Tirisfal Glades.  
- Classic: CachedMapData in the Mini and Local Lists now ignore nil mapIDs.  
- [DB] Condensed a bit of BoD with all difficulties  
- [DB] HFC skip quests are not syncable  
- Fix a few reported errors  
- Classic: Local List is no longer defaulted on.  
- MOP: Added exploration data from a monk that explored The Wandering Isle!  
- Added a temporary ExplorationDB for MOP. (A more granular harvest will be done when the expansion is fully explored later)  
- Classic: Removed references to the old ExplorationDB data. (we don't need this anymore!)  
- Added exploration nodes for The Wandering Isle.  
- [DB] Some uncollectible BFA trash  
- [Logic] Fixed Lua error with 'qgParent'  
- [MOP] Finished The Wandering Isle quests and their objectives.  
- [Parser] NPC providers of Quests which follow an Item provider are no longer converted into 'qgs' (this situation seems to be when an Item provides a quest and the NPC provider is actually where the quest is turned in)  
- The training weapons looted from the Weapons Rack are not tradeable, they're quest items. Fixed some more objectives.  
- Updated The Wandering Isle (Starting Zone for Pandas) to utilize objectives, coordinates, and relational structures.  
- Shang Xi's Academy can be collected, to a point. Once you reach the maximum reputation it will count as collected!  
- [Logic] Retail: Add a quest refresh mechanism so that quests which load their name after being viewed can properly refresh themselves automatically  
- [DB] Added proper timelines in case Classic ever uses this Heirlooms file  
- [Logic] Fixed a Lua error when viewing a cached character with no name saved  
- [DB] Adjusted Heirloom root listing of Upgrades to prevent some crazu duplication that started happening and to utilize Cost for upgrade tokens instead of 'sym'  
- Add Bobadormu to common timewalking vendors  
- [DB] Mist: Update Teldrassil.  
    Update coord of q 26940, 26945, 26946, 26947, 26948, 26949.  
    Add objective of q 26940, 26945, 26946, 26947, 26948, 26949.  
- [DB] Mist: Update Dun Morogh.  
    Update coord of q 24526, 24527, 24528, 24530, 24531, 26904.  
    Add objective of q 24526, 24527, 24530, 24531, 26904.  
    Update objective of q 24532, 24533.  
    Update annotated.  
- [DB] Misplaced group.  
- [DB] Vanilla: City vendors  
- [DB] Fix typo in Wharf Rat pet description  
- vision hqt  
- Coilfang Armaments doesnt display as currency once the quest got removed anymore (english)  
- removed note  
- [Logic] Retail: Expand current difficulty groups should now work properly when quickly re-entering the same instance on a different difficulty  
