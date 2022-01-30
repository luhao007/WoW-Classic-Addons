# <DBM> Outlands

## [2.5.25](https://github.com/DeadlyBossMods/DBM-TBC-Classic/tree/2.5.25) (2022-01-27)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-TBC-Classic/compare/2.5.24...2.5.25) [Previous Releases](https://github.com/DeadlyBossMods/DBM-TBC-Classic/releases)

- - Make default voice pack options VEM instead of none. - Removed the reminder messages for having a voice pack installed but disabled (since it'll be expected that not everyone wants to use them and it's no longer something users install themselves) - Disabled the reminder message for having a voice pack selected in options that's disabled, if the selected pack is VEM. We want users who disable the module instead of the menu to also be viable path to disabling VEM. Likewise, if users re-enable vem, for the most part it'll just start working again since we didn't tell them to go into GUI and change it to none.  
- Add DBM-VPVEM package  
- Update localization.ru.lua (#49) Added and translated missing phrases.  
- Typo fix  
- missed that  
- Update koKR (#48)  
- Fix netherspite gtfo spellId. Closes #91  
- forgot to set defaults table.  
- create a controller wrapper vibrate function and throttle it to once per 2 seconds to prevent multiple calls to api happening within a fixed period of time, hopefully avoid api breaking and blizzard vibrating forever.  
- Maybe this will work  
- bump classic alpha cycle  
- prep new classic release  
- luacheck for last  
- add search tags  
- Update localization.ru.lua (#44)  
- Fix Luacheck  
- Update zhTW (#47)  
- Update localization.cn.lua (#90)  
- Update localization.cn.lua (#89)  
- Update koKR (#46)  
- Update koKR (BCC) (#87)  
- Council Update  
     - Consolidate the 3 gtfo warnings into one  
     - fixed interrupt object to also use newer cooldown checking tech and not just the old focus/target filter stuff.  
- .  
- our lua check blows  
- fix last  
- Shahraz update  
     - Added Fatal Attraction infoframe and arrow helper with dropdown to control it  
     - Tweaked how icons work for FA to work better with helper  
     - Applied mod syncing to Prismatic auras to ensure they aren't missed if not targetting boss (provided that someone else in raid, still is)  
- Fix Lua Errors  
- fix rearrangement errors  
- Black Temple Update 2:  
     - Fixed bad logic bugs on bloodboil, which will fix timer accuracy for rage  
     - Changed infoframe to use unit aura (higher cpu) scan since stacks don't appear in combat log for bloodboil  
     - Added breath announce to bloodboil  
     - Disabled shock interrupt bar on RoS, since it has no CD in TBC. Also made interrupt warning off by default for same reason (and if you do turn it on it'll now honor interrupt antispam tech from core)  
     - Improved cpu usage of RoS mod  by no longer using SPELL\_DAMAGE/SPELL\_MISSED events to start a timer (apparently the success event was unhidden years ago)  
     - Added a very approx timer for death debuff on gorefiend. It has to be noted here that there is still a variation to consider here.  
- clarify help message  
- Bar desaturating was turning bars white  
- First Black temple update:  
     - Blizzard elected not to have supremus' fixate debuff in combat log, so have to revert back to the old ways of scaning bosses target and localized triggers.  
     - Fixed najentus infoframe to display correct health status since it's much larger in classic vs retail.  
- Hyjal Update:  
    Fixed a bug where mark of Kazrogal timer never decreased by 5 seconds per cast and count was displayed wrong (args were messed up)  
    Also added optional (off by default) stomp tomer to kazrogal that isn't super helpful (thus the default)  
    Added auto range check to archimonde for burst target  
    Slightly adjusted silence timer on azgalor (still a crappy timer)  
    Adjusted DnD timer on rage to fit in line with data from PTR  
- Account for fact that M+ can now be in form of under leveled timewalking content...that isn't flagged as timewalking content (because it's index 8). Should no longer treat legion timewalking M+ as trivial content.  
- prep next cycle  
