# Deadly Boss Mods Core

## [1.13.58](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.58) (2020-08-29)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.57...1.13.58) [Previous Releases](https://github.com/DeadlyBossMods/DBM-Classic/releases)

- Prepare new classic release, some stuff needs testing, but to be honest it can't be more broken than the stuff that needed testing in last release.  
- Localize functions that don't need to be global  
    Optimized cpu usage by unregistering combat log events infofframe uses, when infoframe is hidden  
    Fixed a bug where mod was calling hide on infoframe only to IMMEDIATELY reshow it during glob phase.  
    removed unneeded local varaibles  
- aq/visc: hit counter (#540)  
    Co-authored-by: venuatu <venuatu@gmail.com>  
- Update localization.tw.lua (#539)  
- Update localization.tw.lua (#538)  
    * Update localization.tw.lua  
    * Resolve exclamation mark  
    These are indeed used in this locale.  
    Co-authored-by: QartemisT <63267788+QartemisT@users.noreply.github.com>  
- Update localization.cn.lua (#537)  
- Update localization.es.lua (#533)  
- Update localization.fr.lua (#534)  
- Update localization.br.lua (#535)  
- Update localization.de.lua (#536)  
- Further re-arrange AQ40 trash to get Shadow Storm in there  
- Update localization.es.lua (#531)  
- Update localization.fr.lua (#532)  
- Forgot the AQ20 trash cleanup  
- Some cleanup of unused variables as well as just organizing some things better  
    Completely redid infoframe on Cthun to not use syncing and instead target scanning on stomach debuffed players. In addition, it'll actually show who's in stomach and their debuff count (assuming classic allows UnitDebuff)  
    Fixed a bug on Viscious where it had two minsync revisions  
- Update localization.fr.lua (#530)  
- Make this actually a count warning  
- Some reworking on Viscidus.  
     - Now has a volley timer and announce with count  
     - Now has better way to cancel the frozen timer/announce that she hs fully shattered (needs some verification, a single log is not ideal verification)  
- aq/twin: fixup blizzard check (#529)  
- Disable claw tentacle warning by default. they spawn continously, don't want to derail focus from the more important tentacle spawns. timer can stay though.  
- re-enable explode warning for melee by default  
- Update localization.cn.lua (#527)  
- Update localization.fr.lua (#528)  
- Update localization.fr.lua (#526)  
- end  
- Kill off silent mode from minimap button.  
- Update koKR (Classic) (#524)  
- Update localization.cn.lua (#525)  
- Shorten stomach string  
- Update localization.fr.lua (#523)  
- Update localization.br.lua (#522)  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- Update localization.es.lua (#521)  
- Update localization.cn.lua (#520)  
- Update localization.tw.lua (#519)  
- Update hotfix revision, but not sync one. sync one should be fine since the sync msg is different.  
    Added nil checks to sync though and eliminate redundant string conversion  
- cthun: a new version of a stomach tentacle infoframe (#518)  
- Actually sync InfoFrame changes PROPERLY (Fixes #516) (#517)  
- Give movable bars timer icons  
- Update localization.cn.lua (#515)  
- Update localization.tw.lua (#514)  
- Update localization.tw.lua (#513)  
- Update localization.de.lua (#509)  
- Update localization.tw.lua (#508)  
- Update localization.tw.lua (#510)  
- Increased throttle for Sartura's whirlwind from a 2.5 second CD to 4 second cd  
- Spawn time Update, and we all forgot timerWeakened (#507)  
    as title  
- Update localization.mx.lua (#506)  
- Update localization.es.lua (#504)  
- Support partial string find on Pyroguard Emberseer pull (#505)  
- Sync infoframe changes to classic  
- Optimize the math with GUI (sync from retail)  
- Update localization.br.lua (#503)  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- Update localization.kr.lua (#502)  
- Shouldn't change syncing any, but makes them more like other mods  
- Update localization.tw.lua (#500)  
- Update localization.es.lua (#492)  
- Update localization.de.lua (#493)  
- Update localization.br.lua (#494)  
- Update localization.mx.lua (#495)  
- Update localization.es.lua (#496)  
- Update localization.fr.lua (#497)  
- Update localization.tw.lua (#498)  
- Update Tentacles Respawn Timer (#499)  
    Update Giant Eye Tentacles Respawn Timer  
- Update localization.br.lua (#491)  
- Update localization.fr.lua (#489)  
- Update localization.de.lua (#490)  
- Update localization.br.lua (#488)  
- Update localization.br.lua (#487)  
- Update localization.es.lua (#486)  
    * Update localization.es.lua  
    * Update localization.es.lua  
- Update localization.ru.lua (#485)  
- just a note fix  
- Update localization.mx.lua (#484)  
- Update localization.br.lua (#483)  
    * Update localization.br.lua  
    * Update localization.br.lua  
- Update localization.tw.lua (#481)  
- Update localization.tw.lua (#480)  
    * Update localization.tw.lua  
    * Update localization.tw.lua  
- Update localization.es.lua (#479)  
- Change forced update from 1 month to 21 days.  
