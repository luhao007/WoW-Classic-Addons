# [2.17.0](https://github.com/WeakAuras/WeakAuras2/tree/2.17.0) (2020-04-13)

[Full Changelog](https://github.com/WeakAuras/WeakAuras2/compare/2.16.6...2.17.0)

## Highlights

 - Supercharge Glow Actions / Conditions, lots of new options available
- New options and filters for buff tracking
- Animation easing
- Allow WA Updates from chat links
- UI Improvements to Author Mode
- Repair Tool Improvements
- Tons of bug fixes as always
- Happy Easter! 

## Commits

ForsakenNGS (1):

- Added option to supply pure text tooltips (#2076)

Grim (1):

- Allow WA Updates from chat links. (#2085)

InfusOnWoW (51):

- Workaround China's overeager profanity filter
- Fix Models on Icons
- Classic: Fix SAY/YELL not being prevented outside of instances
- Glow External Element Conditions: Fix multi selection
- Fix pencil descriptions not layouting correctly
- Fix Profession Cooldowns if they are on cooldown before login
- BuffTrigger: Fix bug in filtering scan functions
- Fix a few more instances of missing nil checks,
- Wrap calls to customTestFunctions defined in conditionTest into xpcall
- Add missing file
- Tweak Pencil Options to make the whole line clickable
- BuffTrigger2: Fix small issues
- Fix Model on AuraBars
- Model: Fix bug where a released model was not properly released
- Fix typo
- Fix totalStacks calculation for multi bufftriggers
- BuffTrigger2: Remove unused strings
- Prevent auras from being hidden while the options are open
- Fix ScheduleCastCheck for Cast Trigger in a unlikely event
- Fix remaing time check of Weapon Enchant trigger
- Fix custom text from unrelated aura showing up in some cases
- Implement blacklisting for BuffTrigger2
- Remove a bit of code duplication
- Bufftrigger2: Limit the amount of options created
- Fix wrongly named options
- Fix localized strings
- Don't check for state.show in ReplacePlaceHolders
- Make OnHide/OnSHow work around opening/closing options
- BT2: Add a totalStacks text replacement
- BT2: Add support for filtering by class
- SubText: Fix anchor collapsed description
- Fix dynamic group limit option slightly diffrently
- AuthorOptions: Fix Move out of group
- CLEU: Add the isOffHand check for _MISSED
- Fix dynamic group limit option
- BuffTrigger2: Add "party", "raid" to the existing group support
- Fix deleting sub texts with conditions that don't have a property set
- Rework Unit Type Triggers
- BT2: Hide Filter by Group Role on classic
- Add a shaking entry animation
- Fix times showing up on reused icons
- Blacklist two M+ affixes that were never used
- Icon: Hide the cooldown widget in modify
- Icon Cooldown: Disable the bling
- Fix bling showing on updating timers
- Templates: Add Chaos Strike
- Simplify force_events a bit
- BarModel: Fix interaction between parent alpha and model alpha
- DynamicGroups: Fix text placement not adjusting to text dimensions
- Fix Character Stats trigger MoveSpeed
- Fix Zone load option

Sanluli36li (1):

- Add Text's Automatic Width and Word Warp for Subtext

Stanzilla (2):

- Update ForAllIndentsAndPurposes
- Fix classic pkgmeta

asaka-wa (2):

- Universal animation easing (#2087)
- Eased translate animations (#2080)

emptyrivers (7):

- more fixes to repair
- guard against errors in migration
- ensure that id is correct when installing migration
- Add GetData method
- Allow separators to force a "page break" in custom options
- clear authormode on any child imports too
- compare value to value, not table containing value

mrbuds (29):

- classic: remove boss & arena unit from multi, bufftrigger2 and cast trigers
- Pet trigger: fix defensive mode on retail pet's action button was renamed to PET_MODE_DEFENSIVEASSIST
- stance trigger: fix multi and simplify the code GetShapeshiftForm() seems to be working for classic now
- update classic toc interface version to 11304 where it was missing
- remove previous glow before applying a new one
- improve flow of glow external element conditions & actions
- [WIP] Auto re-anchor unitframes & slightly different anchors for nameplates addons (#2070)
- fix migration
- data migration to set actions's glows to "FRAMESELECTOR"
- Supercharge glow actions / conditions (#2032)
- localize strings
- Re-Add Encounter Id(s) load condition and full list in tooltip
- fix typo in ConstructTest
- Combat Log trigger: fix srcUnit and dstUnit conditions
- remove LibTotemInfo (totem api restored with 1.13.4)
- bump toc version for classic to 11304
- Classic: Combat Log trigger: re-add spellId compare the name for the spell id
- Health & Power triggers: fix division per 0
- Fix Unit status triggers:
- fix auras anchored to an other aura
- fix anchorPoint name with new anchors option
- re-anchor on expand if aura was already shown
- disable unitframe & nameplate anchor options from group & dynamicgroup
- call AnchorFrame only on Expand for anchors that require data from clone
- add nameplate and unitframe anchors for auras
- Restore print profile binding text
- stop swing timer when a cast is started fixes #2005 (#2006)
- Show realtime visual graph of profiling (#1949)
- add lastest mythic_plus_affixes (should be almost future proof)

nullKomplex (1):

- Make Cooldown Progress (Equipment slot) able to use Mainhand and Offhand on retail.

