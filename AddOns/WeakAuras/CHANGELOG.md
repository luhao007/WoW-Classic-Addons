# [5.1.0](https://github.com/WeakAuras/WeakAuras2/tree/5.1.0) (2022-11-07)

[Full Changelog](https://github.com/WeakAuras/WeakAuras2/compare/5.0.5...5.1.0)

## Highlights

 - Added border settings for custom grow
- Added horizontal and vertical secondary grow options for dynamic groups
- Added ranks to talent checks
- Bug fixes 

## Commits

InfusOnWoW (18):

- Fix STATUS events for custom triggers without events
- Make debugLog option work on the selected group
- Fix nil error on calling  WeakAuras.SpecRolePositionForUnit()
- Fix borders for dynamic groups for advanced positioning code
- Fix wrong anchoring check blaming auras for anchoring that works
- Fix Group deletion not hiding the groups
- Remove data.controlledChildren from auras that aren't groups
- Optimize watched triggers if nothing has changed
- Fix deleting watched triggers could result in an error
- Use a more sophisticated check for whether a aura is a group type
- Fix corner case in anchoring auras
- Add more type annoations
- SubText: Remove legacy members in SubText
- Add Flipbook Profession images to StopMotion
- Tweak decompression error message
- Improve error message on unknown difficulty id
- Fix division by 0
- Shaman Templates: Add Molten Weapon

Jesse Manelius (2):

- BigWigs: Handle big wigs telling us multiple times to pause/resume
- Big Wigs: Add a isCooldown option

Stanzilla (3):

- Fix two more typos
- Fix typo in Talent widget
- Delete FUNDING.yml

httpsx (1):

- Enable border settings for custom grow

mrbuds (9):

- use IsSpellKnownOrOverridesKnown instead of IsSpellKnown + IsUsableSpell
- Spell Known load condition: also test with IsUsableSpell
- add horizontal/vertical secondary grows
- Dynamic Groups: add vertically & horizontally centered grows
- Add a few more stopmotion from professions
- Item Equipped trigger: return name & icon with inverse option enable Fixes #3975
- Talent Known: add rank check
- Character Stat trigger: add meleehastepercent on wotlk, fixes #3962
- Zone Id tooltip: show dungeon/raid tiers from current to last one At the time this is written, on retail it show both shadowlands & dragonflight data, and on DF's beta it show dragonflight dungeons and season 1 dungeons

