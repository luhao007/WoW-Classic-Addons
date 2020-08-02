# Deadly Boss Mods Core

## [1.13.54](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.54) (2020-07-30)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.53...1.13.54) [Previous Releases](https://github.com/DeadlyBossMods/DBM-Classic/releases)

- prep new release, it's been 119 commits since last one  
- Update version out-of-date whisper (#418)  
    Co-authored-by: QartemisT <63267788+QartemisT@users.noreply.github.com>  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- Update localization.br.lua (#420)  
- Update localization.br.lua (#419)  
- Update koKR (Classic) (#417)  
    * Update koKR (Classic)  
    * Update koKR  
    * Update koKR (Classic)  
    * Update koKR (Classic)  
    * Update koKR (Classic)  
- One less nest  
- Update questie hiding code again to account for fact globals were changed back to non globals, but still have to be compatible with version that uses globals  
- Fixed some bugs in questie code  
- Redid way questy tracker hides, to also remove the header which now also obstructs timers. They also globalized tracker so don't need to import anymore.  
- Update localization.cn.lua (#414)  
- Update localization.de.lua (#413)  
- Update localization.ru.lua (#412)  
- Update localization.br.lua (#410)  
- Update localization.de.lua (#411)  
- Update localization.fr.lua (#409)  
- Update localization.fr.lua (#408)  
- Merge pull request #407 from anon1231823/patch-112  
    Update localization.fr.lua  
- Merge pull request #406 from anon1231823/patch-113  
    Update localization.fr.lua  
- Update localization.fr.lua  
- Update localization.fr.lua  
- Update localization.fr.lua (#404)  
- Remove comment and update warning text for Glare  
- Fixed eye icon to also work in later game versions on eye tentacles  
    Fixed option check to actually check option and not timer storage on cthun message  
- Merge pull request #403 from anon1231823/patch-109  
    Update localization.es.lua  
- Update localization.es.lua  
- Update localization.es.lua  
- Accidentally pasted over a local variable  
- Fix minor inefficient I found while working on something on retail. If timerText arg is nil, we don't need to take a nil value, then set it to nil again after comparing it to two nil values.  
    Addeds support for onlyHighest health option to Classic core, even though no mods use it now, they will by classic wrath  
- Update localization.es.lua (#400)  
- Update localization.tw.lua (#402)  
- Update localization.cn.lua (#401)  
- Updated AQ40 to support killing the bosses in any order for speed clear credit, matching WCL behavior  
    Added icons to warnings/timers that did not have icons assigned for C'Thun encounter  
    Added voice pack support to cthun, which was apparently still missing it.  
- Update DBM-Azeroth.toc (#399)  
- Create localization.mx.lua (#398)  
- Update DBM-Azeroth.toc  
- Update localization.es.lua (#397)  
- Update localization.fr.lua (#396)  
- Update localization.fr.lua (#394)  
- Update localization.fr.lua (#393)  
- Update localization.fr.lua (#392)  
- Update localization.br.lua (#391)  
- Update localization.br.lua (#390)  
- Update localization.br.lua (#389)  
- Update localization.br.lua (#388)  
- Update localization.es.lua (#386)  
- Update localization.mx.lua (#387)  
- Update localization.de.lua (#384)  
- aq/visc: add toxin gtfo warning (#385)  
- Prevent a variable sync from old version of that mod, now that bug fixed  
- Fixed a bug with Venoxis where it checked any ole targets health instead of filtering it by CID  
- Update localization.de.lua (#383)  
- aq/threebugs: add toxin to gtfo warnings (#376)  
- aq/cthun: remove dark glare cd for phase 2 (#374)  
- aq/fankriss: add entangle warning and yell (#375)  
- Force disable can now be triggered by guild version checks, greatly increasing chance it runs before you're in middle of raid  
    Force disable should be more robust against failure do to batched version check syncs  
- Update localization.de.lua (#382)  
- Update localization.cn.lua (#379)  
- Update localization.tw.lua (#380)  
- Update localization.es.lua (#381)  
- Update localization.es.lua (#378)  
- Update localization.tw.lua (#367)  
- Update localization.cn.lua (#368)  
- Update localization.cn.lua (#369)  
- Update localization.tw.lua (#370)  
- Update localization.cn.lua (#371)  
- Update localization.fr.lua (#372)  
- Update localization.tw.lua (#373)  
- Update localization.de.lua (#377)  
- Fix  
- Update localization.de.lua (#365) (force merged, GH editor doesn't show whitespace so have to fix after)  
- AQ: add reflect/plague warnings for anubisath trash (#361)  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- If i could make this button combo z+q+p+alt at same time, I would.  
- Update localization.de.lua (#364)  
- Update localization.fr.lua (#363)  
- Sync some other objects from retail to classic  
- Eliminate unneeded ENUM global variable usage  
- Audio pack fixes (Synced from dev) (#362)  
- Update localization.tw.lua (#360)  
- Update localization.tw.lua (#359)  
- Update localization.de.lua (#358)  
- Update localization.de.lua (#357)  
- Fix more dumb  
- Fixes  
- Combine stuff  
- Inverse logic of last, and fixed a spot checking target without check being defined  
- Fixed a bug in target scanner code where it was actually treating non tank target, as a tank target and filtering them too. Might effect things like fireball scanner on onyxia. target scanner should ONLY treat threat as the tank for purpose of filtering  
    Also improved target scanning to actually GUID match in the boss unit ID method, if bossGUID is defined.  
- Fix lua error that went invisible. (#356)  
- testing a meme theory just to annoy Artemis at this point  
- Update localization.br.lua (#355)  
- Fix UTF encoding  
- Update localization.ru.lua (#354)  
- Take at least 5 seconds off whirlwind timer  
- ru locale updates (#353)  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- Use a keep timer for teleport  
- Update localization.fr.lua (#351)  
- Update zhTW (#352)  
- Update localization.es.lua (#350)  
- Now that ragnaros has two way timer correction, use the average for combat start instead of min time  
- Update localization.ru.lua (#349)  
- Fussy  
- Sync infoframe changes  
- Portuguese: Localize Nef and Rend world buffs (#348)  
- Update localization.ru.lua (#347)  
- Update localization.ru.lua (#346)  
- Update localization.ru.lua (#345)  
- Update localization.de.lua (#343)  
    Co-authored-by: Adam <MysticalOS@users.noreply.github.com>  
- Update localization.ru.lua (#344)  
- Update localization.mx.lua (#342)  
- Update localization.es.lua (#341)  
- Update localization.de.lua (#340)  
- Update localization.es.lua (#338)  
- Fix optional bosses values checks. (#339)  
- Revert "Sync retail change for strFromTime (#336)"  
- Small timer text tweak  
- Prevent nil error if user disabled combat timer on ragnaros  
    Also added code to ensure that if for some reason the timer is > 10 to also correct it down to 10  
- Sync retail change for strFromTime (#336)  
- Update luacheck  
- Re-add Death king to nefarian, this should never have been removed, other ones I get, but Classic is likely going to be original trillogy so DK should remain  
- Forgot to bump alpha version  
- Fixed a bug that caused ZG settings to stop saving after old variable support was removed from Core. This module should now use new variable  
    Fixed bug wehre Cthun was not using global range check option, so it would not honor global disable  
    Added an 18 yard range check option to Huhuran for non lelee  
    Fixed a bug where Razorgore mod would accept syncs from versions of mod using old egg tracker and get screwed up by it, now it'll only accept syncs from this version of mod and later.  
