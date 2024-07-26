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
.. TitanUtils_GetGoldText("8.0.16 : 2024/07/22\n")
.. TitanUtils_GetGreenText("Gold, Repair, XP : \n")
.. TitanUtils_GetHighlightText(""
.. "- Gold : Fix gold display when user selects . (period) as thousands separator.\n"
.. "- Added TitanUtils_NumToString for use in all 3.\n"
.. "- Added TitanUtils_CashToString for use in Gold and Repair for common look of gold/silver/copper.\n"
)
.. TitanUtils_GetGreenText("Regen : \n")
.. TitanUtils_GetHighlightText(""
.. "- Cleanup documentation (comments); made some routines local.\n"
)
.. "\n\n"
Titan_Global.recent_changes = ""
.. TitanUtils_GetGoldText("8.0.15 : 2024/07/14\n")
.. TitanUtils_GetGreenText("Location : \n")
.. TitanUtils_GetHighlightText(""
.. "- Fix error shown when in instances.\n"
.. "- Options same in all versions: Show Zone Text shows text or not; Show ONLY subzone removes zone text.\n"
)
.. TitanUtils_GetGreenText("Auto Hide (full bars) : \n")
.. TitanUtils_GetHighlightText(""
.. "- Fix error on clicking 'pin' to toggle auto hide.\n"
)
.. "\n\n"
.. TitanUtils_GetGoldText("8.0.14 : 2024/07/12\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "- Updated Classic Era version to 1.15.3."
.. "- AutoHide : Fix tooltip error; shows Enabled / Disabled.\n"
.. "- Deprecated Titan Child template plugin code removed.\n"
.. "- Cleanup Titan tool tip code.\n"
.. "- Refactor Titan code to move color codes to Titan globals.\n"
.. "- Add debug to Titan startup code.\n"
)
.. TitanUtils_GetGreenText("Clock, Location, Performance, Repair, Volume, XP : \n")
.. TitanUtils_GetHighlightText(""
.. "- Refactor code for IDE, mostly comments; some code.\n"
.. "- Refactor code for Titan color code changes.\n"
)
.. "\n\n"
.. TitanUtils_GetGoldText("8.0.13 : 2024/06/18\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "- Update Retail version to 10.2.7.\n"
.. "- Unknown LDB will not print error to Chat. Remains in Config > Attempted.\n")
.. TitanUtils_GetGreenText("Repair : \n")
.. TitanUtils_GetHighlightText(""
.. "- Change to not error in Beta (The War Within).\n")
.. TitanUtils_GetGreenText("Bag : \n")
.. TitanUtils_GetHighlightText(""
.. "- Bag taint appears to be fixed (10.2.7). Removed nag message and reverted code.\n"
.. "- Change to not error in Beta (The War Within).\n")
.. TitanUtils_GetGreenText("XP : \n")
.. TitanUtils_GetHighlightText(""
.. "- Improve performance. Now on a 30 sec timer rather than OnUpdate. Still event driven.\n")
.. TitanUtils_GetGreenText("Location : \n")
.. TitanUtils_GetHighlightText(""
.. "- Classic versions Only : Add option to put coords on Top or Bottom to prevent Cata overlap.\n")
.. TitanUtils_GetGreenText("AutoHide : \n")
.. TitanUtils_GetHighlightText(""
.. "- Fix error in tooltip.\n")
.. TitanUtils_GetGreenText("Loot : \n")
.. TitanUtils_GetHighlightText(""
.. "- Small cleanup.\n")
.. TitanUtils_GetGreenText("Volume : \n")
.. TitanUtils_GetHighlightText(""
.. "- Small cleanup.\n")
.. "\n\n"
.. TitanUtils_GetGoldText("8.0.12 : 2024/05/01\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "- TOC update for Cataclysm.\n")
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
