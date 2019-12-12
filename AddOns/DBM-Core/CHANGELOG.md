# Deadly Boss Mods Core

## [1.13.24](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.24) (2019-12-10)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.23...1.13.24)

- Bump Classic TOC/Version  
- Fix lua error with Adds type warnings in classic  
- BWL Update  
     - Added syncing to Broodlord, Chromaggus, Nefarian, Razorgore, and Vaelastrasz to improve mod functionality for a well spread out raid that's limitted by crappy combat log range.  
     - Fixed a bug on Nefarian where Veil Shadow curse was using wrong spellId/name, ensuring this warning will function properly going forward.  
     - Pruned some target timers from BWL that weren't really that important to begin that would require syncing to maintain their functionality (not worth it for unimportant timers, thus the prune)  
