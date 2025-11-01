--[===[ File
This file contains Config 'recent changes' and notes.
It should be updated for each Titan release!

These are in a seperate file to
1) Increase the chance these strings get updated
2) Decrease the chance of breaking the code :).
--]===]

--[[ Var Release Notes
Detail changes for last 4 - 5 releases.
Format :
Gold - version & date
Green - 'header' - Titan or plugin
Highlight - notes. tips. and details
--]]
Titan_Global.recent_changes = ""
.. TitanUtils_GetGoldText("8.4.0 : 2025/09/07\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "-  Titan : \n"
.. "-  - : /titan reset working again; no reload needed!\n"
.. "-  - : Hopefully fix bar transparency values resetting on logout or reload.\n"
.. "-  - : Moved most bar settings from 'Bars - All' to each bar - use profiles instead.\n"
.. "-  --- Bar skin / color settings\n"
.. "-  --- Hide Bar during combat\n"
.. "-  --- Hide Bar in PvP and BG zones\n"
.. "-  - : Fix drag & drop of Titan plugins, per an API change in 11.2.0."
.. "-  Internal : \n"
.. "-  - : Global profiles should be working again.\n"
.. "-  - : More debug statements on login, reload, profile reset.\n"
.. "-  - : Removed code for old DewDrop and Tablet from tooltip code.\n"
)
.. TitanUtils_GetGoldText("8.3.5 : 2025/08/27\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "-  Repair : \n"
.. "-  - : Restore accidently removed 'use guild funds' option.\n"
.. "-  Loot : \n"
.. "-  - : Classic : Restore ability to resize Loot window frame.\n"
.. "-  - : Retail : Get ahead of deprecated APIs GetSpecialization and GetSpecializationInfo into C_SpecializationInfo.\n"
.. "-  Internal : \n"
.. "-  - : Config updates to Vars and Bars All when choosing global versus single bar values.\n"
)
.. TitanUtils_GetGoldText("8.3.4 : 2025/08/24\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "-  LootType : \n"
.. "-  - : Fix error per Curse comments (line 179).\n"
.. "-  ClassicLootType : \n"
.. "-  - : Prep for API change to GetLootMethod.\n"
.. "-  Internal : \n"
.. "-  - : Config updates to Vars and Bars All when choosing skins versus color.\n"
.. "-  - : New locale strings for the above Config change.\n"
)
.. TitanUtils_GetGoldText("8.3.3 : 2025/08/12\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "-  LootType : \n"
.. "-  - : Fix API change to GetLootMethod, retail only.\n"
.. "-  Location : \n"
.. "-  - : Fix map coords being off map in retail; Top and Bottom should now work in retail.\n"
.. "-  - : Fix rare error that shows error on button text.\n"
.. "-  Internally : \n"
.. "-  - : Fix profile not saving (#1439).\n"
.. "-  - : Expand Battle Ground widget adjust (allow 'up').\n"
.. "-  - : Make Classic TOC show as Classic to help avoid confusion.\n"
)
.. TitanUtils_GetGoldText("8.3.2 : 2025/08/01\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "-  Ammo : \n"
.. "-  - : Fix missing icon.\n"
.. "-  Internally : \n"
.. "-  - : Several tweaks for MoP.\n"
)
.. "\n\n"

--[[ Var Notes
Use for important notes in the Titan Config About
--]]
Titan_Global.config_notes = ""
    .. TitanUtils_GetGoldText("Notes:\n")
    .. TitanUtils_GetHighlightText(""
        ..
        "- Changing Titan Scaling : Short bars will move on screen. They should not go off screen. If Short bars move then drag to desired location. You may have to Reset the Short bar or temporarily disable top or bottom bars to drag the Short bar.\n"
    )
    .. "\n"
    .. TitanUtils_GetGoldText("Known Issues:\n")
    .. TitanUtils_GetHighlightText(""
    .. "- Cata : Titan right-click menu may stay visible even if click elsewhere. Hit Esc twice. Investigating...\n"
)
