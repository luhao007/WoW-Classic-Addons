# AllTheThings

## [4.7.7](https://github.com/ATTWoWAddon/AllTheThings/tree/4.7.7) (2025-11-02)
[Full Changelog](https://github.com/ATTWoWAddon/AllTheThings/compare/4.7.6...4.7.7) [Previous Releases](https://github.com/ATTWoWAddon/AllTheThings/releases)

- [Locale] Update zhTW: strings.  
- [Locale] Update zhCN/zhTW: Collector.  
- [Misc.] Add empty langs.  
- [Locale] Update All: Brawler's Guild.  
- Fix some reported quest and object errors  
- Some SL NYI appearances.  
- Sorting some NYI appearances.  
- [Logic] Retail: Fixed an issue where TransmogAppearance links did not properly map to SourceID  
- [DB] Mists - The Black Prince: make Grand Commendation an heirloom  
- [DB] Mists: item harvest + db consolidation  
- [Locale] Update zhCN: Brawler's Guild (#2195)  
- [Logic] Improved a lot of cache logic by removing most uses of ipairs in favor of raw for loops (effectively 10x loop speed)  
- [Logic] Retail: Removed the use of CleanInheritingGroups since we are now specifically caching only expected data in the default cache  
- [Logic] The top-level Achievements category is now cached against its own cache and will properly update automatically when earning Achievements  
- [Logic] CacheFields can now cache specifically to a given cache  
- [Logic] Retail: QuestsWithReputation now simply use the base Cost logic by means of providing a custom costCollectibles lookup of their respective reputation-linked Faction(s)  
    [Logic] Retail: Fixed various tooltip logic issues exposed by Quests being treated as Costs properly  
    [Logic] Ensure that cached search data does not persist a 'working' value  
    [DB] Removed preprocessor to hide a Cost since the logic now works as expected for Costs on Quests  
- [Logic] Moved 'isCost' fall-through handling for cloned objects to base Class  
- [Logic] Retail: Removed other temporary conditions for displaying the 'Currency' icon in tooltips/row since the Cost logic now properly handles Filler-based situations for marking a Thing as a Cost directly  
- [Logic] Added 'isContainer' to the base Class to have an easier reference on whether a group contains other collectibles  
    [Logic] Retail: Use 'isContainer' in row/tooltip logic  
- [TOC] Cata and Wrath are legacy versions now.  
- [Logic] Retail: Fixed an issue where multi-difficulty groups mapping into an Instance minilist would have the text 'Unknown'  
