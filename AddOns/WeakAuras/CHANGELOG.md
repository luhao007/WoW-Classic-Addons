# [3.0.5](https://github.com/WeakAuras/WeakAuras2/tree/3.0.5) (2020-10-25)

[Full Changelog](https://github.com/WeakAuras/WeakAuras2/compare/3.0.4...3.0.5)

## Highlights

 - A few small new features and bug fixes 

## Commits

Anssi Mäkinen (1):

- Fix leaked global in Character Stats trigger

InfusOnWoW (15):

- Create less PlayerModels
- Fix ModelPicker for BarModels and multi selection
- Fix TexturePicker for Ticks + multi select
- Conditions: Fix recheck time scheduling with Else if
- Fixes remaining time check for Weapon Enchant trigger
- Remove the capping of alpha while Options are open
- Cooldown Progress: Rename Stacks to Charges
- Weapon Enchant trigger: Default to Question Mark icon
- Fix conditions listing too many variables
- Fix error in Spell Known trigger
- Add One handed Axes to weapon types
- Fix bar model's alpha bein overwritten by PreShowModel
- Fix Spell Activation Overlay trigger
- Rename a few anchor options
- Bufftrigger 2: Fix total stack count

Stanzilla (6):

- Don't try to load covenant stuff on classic
- Add new feature indicator to item type equipped load condition
- Add new feature indicator for charged combo points
- Add new feature indicator to covenant load option
- Add Covenant Load Option (#2615)
- Update bug_report.md

mrbuds (6):

- remove debug print
- set default animation to "loop" instead of "progress
- parse StopMotion texture settings from filename implement #2356 format of filename has to be "name.x[1-9]+y[1-9]+f[1-9]+.(tga|blp)" where x is number of rows, y number of columns, and f number of frames
- add spell activation overlays added with wow 8.1.5
- fix nil error when using "Class Colors" addon CUSTOM_CLASS_COLORS table does not have the method WrapTextInColorCode
- better fix for omnicc error

