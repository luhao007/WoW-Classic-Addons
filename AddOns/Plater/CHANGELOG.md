@cont1nuity:
- Fixing load on TBC.
- New profiling in development with extended data. Use '/plater profstartadvance' to use it.
- Casts which result in a channeled spell should now re-trigger scripts 'On Hide' code for cast and 'On Show' for the channel when the cast is finished and channel starts.
- Adding new option for namepalte 'Larger Scale' CVar.
- Questie support restored for WotLK beta.
- Rune 'ready animation' could cause additonal cooldown texts to not scale correctly and become larger over time.
- Cast Icon customization will now properly show the icon when moving the cast bar above the health bar through offsets.
- Added 'Forced Blizzard Nameplate Units' which will always show blizzard nameplates. Use 'Plater.AddForceBlizzardNameplateUnits(npcID)' / 'Plater.RemoveForceBlizzardNameplateUnits(npcID)' in a mod to add/remove them to the list.
- Fixing profile import from wago stash.
- Cache players threat raw percent and absolute threat values on unitFrame 'namePlateThreatRawPercent' and 'namePlateThreatValue' respectively.
- Bug fix for broken DBM or BW installations for Boss-Mod support registration.
- Support for WotLK DK runes (Combo Point settings).

@Terciob:
- Added 'Performance Units' which won't have auras, threat and other high usage things enabled. Use 'Plater.AddPerformanceUnits(npcID)' / 'Plater.RemovePerformanceUnits(npcID)' in a mod to add/remove them to the list.
- Added Spells and New Scripts to support Season 4 for M+ Dungeons.

