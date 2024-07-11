# [5.15.0](https://github.com/WeakAuras/WeakAuras2/tree/5.15.0) (2024-07-09)

[Full Changelog](https://github.com/WeakAuras/WeakAuras2/compare/5.14.1...5.15.0)

## Highlights

 - Add support for CustomNames addon
- Add auto complete and text replacement widgets for code editors
- UI Improvements
- TWW updates 

## Commits

Dsune0 (2):

- Hide Resize button when minimized
- Change Profiling frame resize/toggle behaviour

InfusOnWoW (10):

- Add missing Instances Types: Delves, Story Raid, Quest Party(?)
- TWW+Model SubElement: Replace "Clips by Progress" by "Anchor to FG"
- Progress Source: Only use additinalProgress (aka overlays) in auto mode
- Add Dynamic Text Codes window
- TWW: Workaround ColorMixin not being found in custom code
- Fix Item Cooldown trigger if GetItemCooldown returns a nil duration
- TWW: Fix  WeakAuras.CheckTalentForUnit
- Snippets: Prevent stack overflows on TWW on e.g. renaming
- Fix regression in icon determination for the options
- TWW: Fix WeakAuras.CheckTalentForUnit to be compatible with TWW

Stanzilla (3):

- Update TOC for Vanilla Patch 1.15.3
- Update WeakAurasModelPaths from wago.tools
- Update WeakAurasModelPaths from wago.tools

dependabot[bot] (2):

- Bump cbrgm/mastodon-github-action from 2.1.4 to 2.1.5
- Bump cbrgm/mastodon-github-action from 2.1.3 to 2.1.4

mrbuds (14):

- Fix spellcache for cataclysm
- Fix Update frame error
- Re-add CallbackHandler-1.0 required by AceCom
- Fix error when opening doing an aura update
- Dont't construct unnecessary frames when opening /wa
- Remove non-unified BigWigs & DBM triggers for TWW
- Item Slot triggers: add Relic slot for Cataclysm
- Lib cleanup & move to WeakAurasOptions/Libs
- Enable LibAPIAutoComplete for TextEditor and Events
- Add support for LibCustomNames
- Remove AceEvent-3.0
- watchUnitChange optimisation
- watchUnitChange check for new arena units
- fix frame_monitor_callback error

