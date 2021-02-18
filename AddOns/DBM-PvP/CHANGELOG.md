# <DBM> PvP

## [r115](https://github.com/DeadlyBossMods/DBM-PvP/tree/r115) (2021-02-04)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-PvP/compare/r114...r115) [Previous Releases](https://github.com/DeadlyBossMods/DBM-PvP/releases)

- Add Arathi final value (#79)  
    Also fixed a major longstanding bug... We calculate in "resources per second", but blizzard awards them per tick (every 2 seconds). All the values had to be halved.  
    This may also make classic scores a little "more in line", and could possibly be removed in the future?  
- Update localization.en.lua (#78)  
