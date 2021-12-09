# <DBM> PvP

## [r129](https://github.com/DeadlyBossMods/DBM-PvP/tree/r129) (2021-11-20)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-PvP/compare/r128...r129) [Previous Releases](https://github.com/DeadlyBossMods/DBM-PvP/releases)

- Add health tracking for Ashran's bosses;  
    - Added for Tremblade and Volrath (the main bosses)  
    - Added for fangraal/kronus (summonable bosses)  
- Add Narduke's cid for Ashran  
    This was changed in 9.1.5, yey Blizzard!  
- Update PvPGeneral.lua  
- Update localization.ru.lua (#107)  
    Slightly wrong translation. Sorry ..  
- Update localization.ru.lua (#106)  
    Oops .. Minor edits.  
- Fix Luacheck  
- Cleanup options handling a bit;  
    - TimerStart option now is responsible for handling the start timer only  
    - TimerRemaining option is now responsible for handling the remaining timer only  
    - Fixed TimerRemaining, as it was doing the oposite of what it should  
    - Added TimerFlag checking for flag stuff, as it was never checking if they had it enabled BEFORE starting the timer.  
- Update localization.ru.lua (#105)  
    Translated some of the phrases.  
- Remove unused variable (Silly Luacheck)  
- Cleanup and remove old debug code;  
    - Killed ShowBasesToWin code, as it's being redone  
    - Killed estimated points frame, as it was unused  
    - Removed old missing score reminder, as we have all the scores  
- Update localization.en.lua  
- bump classic toc while testing my new unified cloud based source code folder across multiple computers  
