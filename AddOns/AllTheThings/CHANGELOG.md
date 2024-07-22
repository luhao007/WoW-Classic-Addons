# AllTheThings

## [DF-3.12.12](https://github.com/DFortun81/AllTheThings/tree/DF-3.12.12) (2024-07-21)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/DF-3.12.11...DF-3.12.12) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- Reparsed all flavors  
- Fel Iron Ore & Adamantite Ore no longer linked to Jewelcrafting  
- Missing |r and missing }, closing  
- CATA: Add more objective data for Ashenvale  
- CATA: Add more objective data for Southern Barrens  
- Varzok BoP  
- Pet Battles/Quests descriptions  
- Profession Knowledge  
- Alex?? O.o  
- Activate TWW Skinning  
- Some clean up  
- Sojourner of The Ringing Deeps adjustments now Blizzard fixed the criteria  
- Harvested achievement DB + new Wago files  
- Sorted missing TWW achievements  
- Classic HAT  
- TWW: a little bit more  
- TWW: touched a bit pvp stuff  
    added honor cost to gear  
    removed conquest gear from unsorted  
    added wm gear (also created header for this and throw it under seasonal stuff to see if it will be better to maintain it like that)  
- CATA: Add objective for quest "Pick-a-Part" (25075)  
- CATA: Add objective for quest "The Taurajo Briefs" (25059)  
- TWW: Dornogal sorting  
- TWW: Added Cooking and Fishing  
    TWW: Mereldar Fishing Derby fully fledged  
- Reparse beta  
- ....Lol  
- Beta Config update  
- After harvesting lets see how much of MissingTransmog is done :D  
- Tweak July Trading Post removal patch  
- Some unsorted  
- Catalyst fixes and source harvesting  
- Some fixes to pvp and also from Jen  
- Minor fixes  
- Generating Missing  
- Sort Recipes  
- Harvest: 11.0.2.55763  
- Harvest: 11.0.2.55665  
- Harvest: 11.0.0.55666  
- Harvest: 11.0.0.55636  
- Harvest: 10.2.7.55664  
- Harvest: 4.4.0.55639  
- Harvest: 1.15.3.55646  
- Fixes to catalyst  
- Reorg and reparsed for PvP File  
- TWW Gladiator (finally, right?)  
- Known By/Completed By for known Account-Wide quests will now show "Account-Wide" instead of listing every Character on the Account  
- Retail: Fixed drop chance calculation issue when items are removed from the encounter loot table  
- Parser: Supports new fields 'classes\_display' and 'races\_display' for when we want to attach class/race data to a Thing but not actually perform Filtering in-game based on that data  
    Burden of Eternity items properly switched to 'classes\_display' since they require certain classes to 'obtain' but are otherwise not class-restricted for 'use' (which is how we attempt to Filter Things)  
    Information Types for 'c' and 'r' now support the new display-only data variants as well  
- Fixed 'Argent Squire' and 'Argent Gruntling' not considered for their proper Factions  
- Retail: Adjusted visibility logic for Costs/Upgrades to not be excluded when the group is 'saved' (this prevented needed Costs/Upgrades from showing within a saved instance difficulty, and it should not cause Costs to show under one-time completed Quests since the Cost logic itself will not assign Costs under content of that nature)  
- 'Stop the Spread' cannot be completed at max level  
- Aurelid Lure is a one-time quest-flag (even though it can be obtained weekly thereafter)  
- Parser: Fixed an issue where a bad sym field would cause a crash  
    Parser: Cleaned up sym merge logic to be more in-line with current standards without secretly waiting for key input  
- Retail: Parsed... (why so many header IDs change...??)  
- Retail: Using new sym commands so that old symlinks aren't tainted by new logic  
- Reparsed to fix chat print for git folks  
- CATA: Add objective data for Wetlands  
- CATA: Add objective data for Vashj'ir  
- Cleaned up DF S4 Tier content into a (hopefully) reusable structure for future weird Season stuff (or other content which is shared across multiple Instances from specific Encounters)  
    * All S4 Tier listed under single header 'Awakening the Dragonflight Raids'  
    * All DF Raids properly show the possible Tier/Token content in minilist & tooltips (including potential Upgrades)  
    * All S4 Token Item variants now show accurate tooltips  
    Fixed some InstanceHelper logic for appending into ALL\_BOSSES  
    InstanceHelper has a new function 'RawAllBosses' to copy groups linked to all bosses within the instance (basically CBD but using raw provided data)  
    ResolveSymlink supports some adjusted functionality:  
    * Commands 'modID' and 'myModID' now affect the next following 'select' command  
    * Command 'groupfill' now accepts a bool parameter to perform the 'fill' logic immediately against the current set of search results (instead of performing at the end of the entire symlink)  
    Couple debug comments/todo  
- Some more TWW Cooking  
- Add Kharnalex to ABB vendor  
- Sort NYI junk from Forbidden Reach  
- CATA: Fix automated mistake in Tol Barad  
- CATA: Add objective data for Tol Barad  
- CATA: Add objective data for Tirisfal Glades  
- CATA: Add objective data for The Hinterlands  
- CATA: Adjust objective data for Cape of Stranglethorn  
- CATA: Add objective data for Silverpine Forest  
- CATA: Add 3 more npc to objective for quest 27982  
- CATA: Add 3 more npc to objective for quest 26570  
- CATA: Fix automated mistake in Loch Modan  
- CATA: Correct some objectives for Northern Stranglethorn  
- CATA: Add objective data for Loch Modan  
- Fixed Uldum tabs.  
- CATA: Correct some objectives in EK  
- CATA: Add objective data for Winterspring  
- CATA: Add objective data for Un'goro Crater  
- Fix Uldum.lua parsing  
- CATA: Add objective for "Hacking the Wibson"  
- A bit more than half of TWW Cooking done  
- Some Toy Sorting  
- Some more timeline stuff  
- Timeline Placeholders until blizzard knows whats going on  
- CATA: Add objective data for Uldum  
- -- Continued with Sorting TWW Mounts and Pets  
    -- Sorted most of DF.  
    -- Added the new BoEs to the Raid  
    -- Added Constant for Battle Pet Achievements  
    -- Added Charming Courier  
- Generating Missing Files  
- New Items-...... Hmmm New Profession knowledge  
- Harvest: 11.0.2.55522  
- Harvest: 4.4.0.55613  
- Harvest: 3.4.3.55586  
- Harvest: 3.4.3.55541  
- Harvest: 1.15.3.55563  
- Some Unsorted Cleaning  
- Removes outdated time restriction note on classic fish (Fixes #1681)  
- CATA: Add objective data for Timbermaw Hold  
- Hallowfall Rares  
- Hallowfall Quest Sorting  
- Retail: Fixed a slight nuance with Item/Currency Source lines to not include the Cost-sources of those Things (e.g. where you spend something isn't the Source for that Thing)  
- CATA: Add objective data for Thousand Needles  
