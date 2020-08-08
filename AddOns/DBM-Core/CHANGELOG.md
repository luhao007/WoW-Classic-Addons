# Deadly Boss Mods Core

## [1.13.55](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.55) (2020-08-05)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.54...1.13.55) [Previous Releases](https://github.com/DeadlyBossMods/DBM-Classic/releases)

- prepare new classic release with first batch of AQ fixes  
- Improved submerge event on Ouro  
    Added missing timers for initial sweep and blast to Ouro on engage and initial timer for sweep and blast after a submerge.  
    NOTE: Ouro's Submerge does not have a timer. Check for yourselves on Warcraftlogs. I looked through 30 pulls. not a single one of them had submerge at same time. In fact the variance was so massive I can only conclude it truly is random. Some pulls with submerge as early as 70sec from engage and some with it as late as 3 minutes into fight. It's also worth noting that in most kills he didn't even submerge at all (likely because if the submerge window is 1-3 minutes, and kill is 1minute 30 seconds, there is a good change he died before submerge)  
- Update localization.es.lua (#444)  
- Update localization.br.lua (#443)  
- Fix case  
- Changed speed clear to require Huhuron do to fact that it's skipable and need to make sure it's included in full clear check. as a result of this change, this update will wipe previously recorded speed clears.  
    Fixed a bug on Cthun where eye tentacle timer didn't cancel on phase 2 push  
    Deleted whirlwind active timer on sartura. It was actually quite useless and inaccurate.  
    Fixed Summon images firing two warnings on Skeram  
    Fixed freeze warning icon on Viscidus to not be a green square  
- Update localization.cn.lua (#442)  
- Update koKR (Classic) (#441)  
- Over deleted  
- Standard game font will now be applied far more inteligently so that it's always set to correct one even if user swaps languages. Basically, the font itself is no longer saved in the option (when using one of standard game fonts) just a variable that says to apply standardFont font, to whatever it SHOULD be based on clients locales setting this session. So no more ????? warnings/timers when you change your language after DBMs initial setup (well, unless you are using a non standard font that doesn't support new language, can't do too much about that besides telling you to try other non default fonts til one works in your language)  
- Changed discord urls to non vanity invite link  
- Send boss name with the BWL enrage warnings (#440)  
- aq/trash: add warning for cause insanity / mind control (#439)  
- ported retail Fix for a bug that could cause yell scheduling to schedule invalid yells during a misusage  
- Update localization.es.lua (#437)  
- Update localization.fr.lua (#435)  
    * Update localization.fr.lua  
    * Update localization.fr.lua  
    * Update localization.fr.lua  
    Co-authored-by: QartemisT <63267788+QartemisT@users.noreply.github.com>  
- Update localization.fr.lua (#436)  
    * Update localization.fr.lua  
    * Update localization.fr.lua  
- aq/anubisath: add explode warning (#434)  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- Update localization.cn.lua (#433)  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- Fixed a bug where legacy mods calling StartCombat without an event type could throw errors  
    Fixed a bug with profile drop downs throwing a lua error  
- Update localization.cn.lua (#432)  
- Update localization.es.lua (#431)  
- Update localization.cn.lua (#429)  
- Let weakened be localized any way localizers want, so long as it works.  
- Set alpha revision for next cycle  
- Create localization.br.lua (#421)  
- Create localization.fr.lua (#422)  
- Create localization.br.lua (#423)  
- Update DBM-AQ20.toc (#424)  
- Update localization.de.lua (#425)  
    * Update localization.de.lua  
    * Update localization.de.lua  
- Create localization.fr.lua (#426)  
- Update DBM-AQ40.toc (#427)  
- Update zhTW (#428)  
