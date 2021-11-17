# <DBM> Outlands

## [2.5.19](https://github.com/DeadlyBossMods/DBM-TBC-Classic/tree/2.5.19) (2021-11-02)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-TBC-Classic/compare/2.5.18...2.5.19) [Previous Releases](https://github.com/DeadlyBossMods/DBM-TBC-Classic/releases)

- prepare new core releases  
- fix last  
- Add user requested CD timer for Quagmirran's volley  
- Fixed a bug where the scheduler woud not have correct zone Id do to flawed logic that only updated it if a mod registered a function BEFORE changing zones (which realistically almost never happens, since mods register custom schedulers mid fight) Should fix https://github.com/DeadlyBossMods/DBM-TBC-Classic/issues/78  
- Fix a very obvious bug in golemagg  
- Finally fix a bug where stats and wipe/kill message would be wrong difficulty on classic bosses that have poor wipe detection (no valid encounter\_end event or releasing before it fires)  
- Fix numpty  
- Added support for classic seasons to Unified Core  
- This makes me a little less nervous  
- Bump alphas  
