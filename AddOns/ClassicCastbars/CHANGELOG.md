# ClassicCastbars

## [v1.4.4](https://github.com/wardz/ClassicCastbars/tree/v1.4.4) (2022-01-26)
[Full Changelog](https://github.com/wardz/ClassicCastbars/compare/v1.4.3...v1.4.4) [Previous Releases](https://github.com/wardz/ClassicCastbars/releases)

- return early for performance reasons  
- show interrupt msg in castbar on successful interrupts  
- restart casts on GROUP\_ROSTER\_UPDATE aswell since it can trigger randomly in combat etc  
- check 'showCastBar' property aswell for player castbar incompatibility check  
- shouldnt be needed  
- simplify color initialization of player castbar  
- code cleanup  
- ensure animationgroups are inactive when frame is released  
- remove duplicate code  
- minor code cleanup  
- bump toc & license year  
- bump libs  
- remove AMS for tbc castImmunityBuffs  
- seems to work better (#61)  
- add still casting checks for 'player' here since the stop events are triggered many times incorrectly for this specific unit (#61)  
- bump settings version  
