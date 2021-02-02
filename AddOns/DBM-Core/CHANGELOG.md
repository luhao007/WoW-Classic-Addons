# Deadly Boss Mods Core

## [1.13.68](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.68) (2021-01-27)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.67...1.13.68) [Previous Releases](https://github.com/DeadlyBossMods/DBM-Classic/releases)

- Prep tag  
- Add bone Barrier request  
    Cd timer not really possible, timer is all over place, probably based on health triggers IMO.  
- naxx/loatheb: healer corrupted mind tracker (#670)  
    * naxx/loatheb: healer corrupted mind tracker  
    * naxx/loatheb: change raid iterators  
    * Few optimizations  
    - Localize some of the update stuff, to save CPU cycles  
    - Last variable is unused in pairs, as its set to nil and therefor removed.  
    - Set infoframe to just show 40, rather than using a count, as its just more efficient and will only show healers anyway (as they're the only entries)  
    - Optimized some cases where local can just be put directly (saves memory)  
    * naxx/loatheb/healer: add in zone and alive checks  
    Co-authored-by: QartemisT <63267788+QartemisT@users.noreply.github.com>  
- fix last  
- sync more retail bar fixes to classic  
- Port timer fixes to classic  
- naxx/maexxna: add web wrap timer (#672)  
    * naxx/maexxna: add web wrap timer  
    * naxx/maexxna: fixup webwrap warning args  
    * Update Maexxna.lua  
    Fixed timer args as well  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- fix timer icon  
- Fixed regression where custom spellname removed from callbacks that only exist in classic  
- Several countdown fixes related to live bar updates  
     - Fixed a bug where default countdowns would start even when users had countdown completely disabled for that timer option,  after a bar fade or time remaining was live updated.  
     - Fixed a bug where bar updates would swap to default voice even when a custom voice was used.  
     - Fixed a bug where a countdown would not be canceled during a bar update for a bar a user set a countown on manually but had no default countdown option defined.  
     - Fixed a bug where a new countdown would needlessly be scheduled after a bar update, when remaining time on the new bar is less than 3.  
- InfoFrame optimization (Retail sync) (#669)  
- Update localization.tw.lua (#667)  
- Fixed a bug that caused KT range frame to never auto popup  
- Mark prewarn will now include mark count  
    Mark timer will now just say "mark" (in all langauges. It has no translations nor will there be any translations done by me. Sorry anonymous)  
    Closes #665  
- retail to classic synced fixes  
- All KT icon options now off by default, with a force reset  
- Possibly fix #664 in off chance it's hacky icon injection not being compatible with custom tables inputted as arg.  
- Some code sync from retail. I realize some of it doesn't apply to classic now, but you never know down the line. Eventually community will get bored and clammer for classic+ or some shit and i'll go "good thing dbm-classic already supports M+ logging for mythic 15 deadmine"  
- Bump alpha  
