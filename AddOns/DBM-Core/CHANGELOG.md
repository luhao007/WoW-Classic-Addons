# Deadly Boss Mods Core

## [1.13.26](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.26) (2019-12-30)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.25...1.13.26)

- Prep new version  
- Merge pull request #37 from woopydalan/patch-7  
    Update localization.es.lua  
- Update localization.es.lua  
- Merge pull request #36 from woopydalan/patch-6  
    Update localization.mx.lua  
- Update localization.mx.lua  
- Merge pull request #34 from woopydalan/patch-5  
    Update localization.mx.lua  
- Update localization.mx.lua  
- Fix error  
- Redid how add counting works so if adds are left over from previous stage, they don't mess up counting logic.  
    Added minsync revisions to block syncing from outdated mod versions to avoid counting logic breaking from older versions in raid.  
- Fix spell event for last  
- Added combat log event for ragnaros summon, so it'll work in raids that don't have anyone playing a localized language.  
    Added timer correction to combat start timer for ragnaros if timer is too short at time domo dies (only time DBM can actually get a definitive timer for it.)  
- Remove Extra Space  
- Merge pull request #32 from woopydalan/patch-4  
    Update DBM-Party-Classic.toc  
- Merge pull request #31 from woopydalan/patch-3  
    Update localization.es.lua  
- Update DBM-Party-Classic.toc  
- Update localization.es.lua  
- Merge pull request #30 from woopydalan/patch-1  
    Create localization.mx.lua  
- Create localization.mx.lua  
- Fixed personal fake syncs, restoring break/pull/etc functions when doing outside of groups, or soloing raids that use syncing to pass boss messages  
- Fix LibStub name for LibThreatClassic2  
- Embed LibThreatClassic2  
    Updated core to use LibThreatClassic2 by default, but to continue using old lib IF it exists from another mod, while waiting for greater adoption of LibThreatClassic2  
- Forgot this  
- Remove Threatlib and ace embeds. at least while threatlib author is MIA and bugs exist in it that are affecting DBM  
    However, if threatlib exists from another addon, DBM will still use it. But DBM can no longer be blamed for the bugs it introduces for being present.  
- Adjust arrow protection against nil errors from slow/nil UnitPosition returns to prevent errors in in situations where the remote target is another player  
- Execute dispel filter on ignite  
- Switched ignite mana warning from regular warning for all to just a dispel warning for dispellers  
