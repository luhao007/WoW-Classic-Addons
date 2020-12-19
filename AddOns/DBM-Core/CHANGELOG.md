# Deadly Boss Mods Core

## [1.13.63](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.63) (2020-12-07)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.62...1.13.63) [Previous Releases](https://github.com/DeadlyBossMods/DBM-Classic/releases)

- Tag last classic release for a while. There will likely be no further updates until the new year, do to launch of castle nathria tomorrow.  
- Added additional warnings/timers to Horseman, Closes #642  
    Fixed Meteor warning while at it, was using wrong event for classic. Cast start event didn't come til wrath  
- If a mod has no stats, don't reply to whispers or status  
- Tweak the shift soon warning and timing  
- Anub timer wasn't working either, based on WCL it should be working but just in case it's an aura type mis flag, switch to checking unit type instead of aura type  
- Add experimental target scanning to impale on anub and removed wrath spellids from spellID registration so it doesn't fire debug warnings  
- I was right about dicimate not being a timer, blizz confirmed it in a post, it's a mechanic trigger based on a diff criteria  
    removed timer and soon warnings for it  
- Changing shout to use median timer. Lets be clear though, I saw a 22 second cast on PTR testing, I also saw one as late as 25.9. The most common timer was about 25, however using a timer of 25 when it can rarely be 22 is not accurate. Non the less, with the variation being 22-25.9, I decided to change it to 24, the median of the variation. I saw even a December 3rd log from today already as low as 24 and that's with only 3 sample. There will probably be some 22s and 23s after a day or two, but lets see how people feel about 24.  
- Update localization.ru.lua (#641)  
- Update localization.de.lua (#640)  
- Update localization.fr.lua (#639)  
- Update koKR (Classic) (#638)  
- Deleted twitch references  
