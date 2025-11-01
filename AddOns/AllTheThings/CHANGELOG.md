# AllTheThings

## [4.7.5](https://github.com/ATTWoWAddon/AllTheThings/tree/4.7.5) (2025-10-26)
[Full Changelog](https://github.com/ATTWoWAddon/AllTheThings/compare/4.7.4...4.7.5) [Previous Releases](https://github.com/ATTWoWAddon/AllTheThings/releases)

- prasrers parsrer  
- [DB] Fixed 'Rise of the Red Dawn' Titles  
    [DB] Fixed 'Bulwark of Mannoroth being an ensemble (it currently doesn't exist/load. Maybe Argus phase of Lemix will fix it?)  
- [DB] Mists: add token items as cost for normal tier 11 set  
- PTR 11.2.7 Parse  
- Housing Decor: Vindicator Nuurem, Stormshield  
- Housing Decor: Most (if not all) pre-Midnight Decor is available as of 11.2.7.  
    - Neighbourhood (and related quests and activities) will be released in 12.0.0  
- swapped arathi story title filters  
- wow bday now shows only 7 days before start  
    bday ends after 11.2.7 release  
- Alpha: side quests Harandar (build 63854)  
- [Misc.] Fix syntax error.  
- [Issue Report] Add language.  
- [Issue Report] Add event.  
- [Issue Report] Update description.  
- [PAT] Updated source file format based on current standards.  
- Add coordinates for "Dealing with Satyrs" pet battle (#2180)  
- [DB] Clean up Balance of Power intro quests  
    [DB] Added a treasure in Isle of Dorn  
    [Parser] Added a bit more concurrent protection for ItemDB caching  
- Decor: Midnight 'Epic Edition' Decor Vendor  
    - 'Epic Edition' Decor will be available to players in 11.2.7  
- [Logic] Removed a piece of symlink select code which doesn't seem to be necessary any longer... probably  
- [DB] Unsourced object in Ringing Deeps  
- [DB] Fixed remaining bad symlinks currently in ATT  
- [Debug] Added simple chat commands for existing Analyzers  
- [DB] Fixed symlinks for TW CoS (assuming heroic appearance drops in TW)  
- Timeline all rated pvp achievements (#2184)  
- Fix some reported errors  
- Winter Veil icon updated  
- I found more NYI artifacts again.  
- Finished sorting Remix Artifacts.  
- Housing Decor: Add one more Decor Vendor  
- Midnight/Zul'Aman: Twilight Bled  
    - Hopefully this will make PAT focus on something else.  
- [PAT] Updated source file format based on current standards.  
- Housing Decor: Add a couple of Decor Vendors  
- TWW s3 the Triple Threat Meta achievements (#2181)  
    TWW s3 the Triple Threat Meta achievents  
- Add temp availability for Kara M+ portal  
- [Parser] Adjusted some timeline handling to fix cases where defaulted timeline values for certain shortcuts would prevent proper inheritance and awp/rwp handling during parse  
    * Defaulted timelines no longer generate awp/rwp fields  
    * Defaulted timelines which inherit to child objects will also be inherited as defaulted timelines  
    [Parser] Patch-based Expansion headers will now use a 'real' timeline for that specific Patch (this mainly affects NYI/Unsorted stuff)  
- [Parser] Fixed an issue where the maps\_disp field would not properly be an array  
- Added all NYI artifact weapon versions from Remix.  
- Reverted MissingTransmog.txt to older version for Remix corrections currently.  
- Reparse  
- Generate Missing Files Again  
- [Logic] Retail: Fixed an issue where the Total Cost row could continue to append 'Processing...' if the process was reset at specific times  
- Some fixes  
- Decor: Alchemy  
- Quest Names Harvest  
- Future Timeslines  
- Added new decor header  
- Merge branch 'master' of https://github.com/ATTWoWAddon/AllTheThings  
- Parser complained  
- [DB] Properly-nested various Expansion Pre-Launch Events instead of being standalone  
    [DB] Removed bad bubbledown timelines from Expansion Pre-Launch  
- [DB] Reduced some duplication in Legion Pre-Launch  
- [DB] Fixed a bunch of weird nesting, redundant custom headers, and inconsistent organization for Dragonflight > Expansion Features  
- [DB] Cleaned some redundant custom headers/nesting for Delve mount mods  
- [Logic] Sort by progress will now fallback to sort by name for identical sort values (this will reduce repeated sorting from shifting things around)  
- [Logic] Data with SortPriority now is accounted for when sorting by name or progress  
- (Icons) Housing,Campsite update, Decor added  
- [DB] Mists - Blacksmithing: move Socket Bracer/Gloves (Rank 2) recipes away from NYI comment  
- Parse for Mists  
- [DB] Mists - First Aid: set ranks for Heavy Windool Bandage  
- [DB] Mists - Blacksmithing: set ranks for Socket Bracer/Gloves  
- [Logic] Classic: don't mark mounts as BoP by default after Wrath  
    - Fixes Character mode issue where tradable profession mounts are only visible for characters with the corresponding profession learned  
- Generate Missing Files  
- Sort Recipes  
- Harvest: 12.0.0.63967  
- Harvest: 12.0.0.63854  
- Harvest: 12.0.0.63728  
- Harvest: 12.0.0.63724  
- Retroactive Harvest: 12.0.0.63534 for Campsite/Decors  
- Harvest: 11.2.7.64011  
- Harvest: 11.2.7.63853  
- Harvest: 11.2.7.63642  
- Retroactive Harvesting for campsites  
- Added Campsites and Decors to harvester  
- Harvest: 11.2.5.63906  
- Harvest: 11.2.5.63834  
- Harvest: 11.2.5.63825  
- Harvest: 11.2.5.63796  
- Harvest: 11.2.5.63704  
- Harvest: 11.2.5.63660  
- Harvest: 5.5.1.63698  
- Harvest: 3.4.5.63697  
- Harvest: 3.4.5.63623  
- Harvest: 1.15.8.63829  
- Harvest: 1.15.7.63696  
- [PAT] Updated source file format based on current standards.  
- Fix some reported quest and object errors  
- Update Mount/Pet/ToyDB for 12.0.0.63967  
- Housing Decor: Update many placeholders with newly datamined items  
- [Logic] Retail: Fixed an Item cache issue where weird sequences of tooltips for non-existent Items could corrupt the data for real Items  
    [Logic] Retail: Removed clearing of Item cache when setting a raw link since the modItemID is now properly accurate to the data within the Item String  
    [Logic] SourceID -> Link determination now includes extraID and modID checks and only requires Debugging for bonusID checks (since it's far more computation to determine)  
- Update Mardum The Shattered Abyss (Demon Hunter).lua  
- Not a good bubbleDown, it overwrote other COMMONLOOT too.  
- [DB] Mists: fix description for Satchel of Helpful Goods 35-39  
- [DB] Fixed a few starting Legion Remix Artifacts that Blizzard made slightly-differently from all other Artifacts  
    [DB] Fixed a Highmountain Treasure Criteria  
- This is surely the last fix for Remix Trial of Valor.  
