# <DBM> World Bosses (Shadowlands)

## [9.2.32](https://github.com/DeadlyBossMods/DBM-Retail/tree/9.2.32) (2022-08-30)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Retail/compare/9.2.31...9.2.32) [Previous Releases](https://github.com/DeadlyBossMods/DBM-Retail/releases)

- prep new retail tag  
- Update fated affixes with weak 5 data  
- bump alpha  
- prep new wrath tag  
- Update ci.yml Don't forward to BCC  
- Add a check only for M+ for both DF and S4  
- tweak/fix  
- Redo scanning again to always scan multiple times instead of aborting on first scan, this will make it more robust in detecting affixes that don't appear right away. Did reduce scan times from 10 over 10 seconds to 5 over 10 seconds.  
- Fix a bug causing out of control scheduling loop. Closes#802  
- Fix stupid  
- attempt to fix situation where intial timers may fail, and as a result, timers could also fail to cancel on wipe/kill as well within the affixes mod. This was done through a more aggressive repeat scan that will persist for 10 seconds into fight  
- don't pass \"force\" arg on CALLENGE\_MODE\_RESET for autologging  
- bump alpha  
