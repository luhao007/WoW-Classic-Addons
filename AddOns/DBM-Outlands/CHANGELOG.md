# <DBM> Outlands

## [2.5.21](https://github.com/DeadlyBossMods/DBM-TBC-Classic/tree/2.5.21) (2021-12-08)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-TBC-Classic/compare/2.5.20...2.5.21) [Previous Releases](https://github.com/DeadlyBossMods/DBM-TBC-Classic/releases)

- Prep new tags across board  
- Infoframe update  
     - Updated all infoframes to support total absorb being unknown and be an optional arg (when not given it returns numeric value instead of percent  
     - Removed unused variable  
     - Also updated the player absorb check to work without spell input optionally to be a generic total absorb checker  
- Update localization.tw.lua (#26)  
- Update commonlocal.tw.lua (#25)  
- Fixed a bug that caused mage tower challenges to incorrectly report as scenario mods instead of solo challenges, This caused incorrect combat reporting and stats tracking.  
- Update localization.ru.lua (#24)  
    Minor typos.  
- Update localization.ru.lua (#23)  
    Minor typos.  
- Add support for classic era difficulty IDs 184-186  
- tweak to last  
- Optimize CheckDispelFilter to return cached value when checking multiple debuffs similtaniously to avoid calling GetSpellCooldown over 100x in a single frame in rare cases.  
- Fix frame Hide cases for hyperlinks nad updatereminder  
- Fix incorrect difficulty ID (#22)  
- Missed some renames  
- Move journal icons to common locals too, that way nearly 100% of smaller mods can avoid using the cores much larger locals table for any reason.  
- Split common locals out of core so mods and gui elements that only need to access these only have to read or localize a much smaller table.  
- Fix case in Hyperlinks too.  
- Fixed regressions in notes and update popups  
- Fix dway usage. (Cleaner)  
- Fix dway usage.  
- Make Mitalie happy  
- More modules;  
    - Migrated Commands  
    - Migrated Hyperlinks  
    - Migrated Notes Editor  
    - Cleaned up a bit of Core Lua  
- Redunant IsLatestCodebase function  
- Migrate commands into modules  
- Luacheck unused variables.  
- Fixed previous commit  
- Fixed a positioning error within the GUI  
- Remove redundant nil returns  
- Revert one bad change  
- Safer usage for removing values from tables;  
    - In cases where we iterate and remove, just use twipe (table.wipe)  
    - In cases where its ipairs, use tremove (table.remove), as it's a SAFE CAST, otherwise iterating it can corrupt  
- Fixed commit signing, and bumped alphas  
