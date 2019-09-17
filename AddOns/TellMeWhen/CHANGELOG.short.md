
## v8.7.0
* Classic: Updated the Cast condition and icon type to use LibClassicCasterino for approximations of others' spell casts.
* Classic: Aura durations might now be correct for abilities whose durations are variable by combopoints.
* The Missing Buffs/Debuffs icon type now sorts by lowest duration first.
* Switched to DRList-1.0 (from DRData-1.0) for DR category data.
* Added events to the Combat Event icon type for swing & spell dodges/blocks/parries.
* Classic: Added support for Real Mob Health and LibClassicMobHealth. Real Mob Health is the better approach, and must be installed standalone.
* Classic: Added instructions to the Swing Timer icon type on how to get Wand "swing" timers.
* Added an option to Spell Cooldown icons and Cooldown conditions to prevent the GCD from being ignored.
* Classic: Added a Spell Autocasting condition.

### Bug Fixes
* Fixed an uncommon issue that could cause some event-driven icons to not update correctly after one of the units being tracked by an icon stops existing.
* Classic: Fixed the Unit Class condition's options.
* Classic: Fixed the Weapon Imbue icon type & Condition for offhands.
* Classic: Fixed talented aura duration tracking.
* Classic: Fixed combopoint tracking.

