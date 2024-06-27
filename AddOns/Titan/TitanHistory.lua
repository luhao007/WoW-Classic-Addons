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
.. TitanUtils_GetGoldText("8.0.13 : 2024/05/xx\n")
.. TitanUtils_GetGreenText("Titan : \n")
.. TitanUtils_GetHighlightText(""
.. "- Update Retail version to 10.2.7.\n")
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
.. TitanUtils_GetGoldText("8.0.11 : 2024/04/10\n")
.. TitanUtils_GetGreenText("Ammo : \n")
.. TitanUtils_GetHighlightText(""
.. "- Fix to remove plugin error text when wand (non-ammo) weapon is equipped in Classic (Wrath or Era) .\n")
.. TitanUtils_GetGreenText("Volume : \n")
.. TitanUtils_GetHighlightText(""
.. "- Double click (left) will mute / unmute. Note: tooltip will flash, not sure how to prevent that.\n"
.. "- Icon should reflect volume % : = 0 | <= 33% | <= 66% | <= 100% .\n"
)
.. TitanUtils_GetGreenText("XP : \n")
    .. TitanUtils_GetHighlightText(""
        .. "- Do not output time played - can spam Chat.\n"
        .. "- /played   Use this command instead to see same output.\n"
    )
    .. TitanUtils_GetGreenText("Config : \n")
    .. TitanUtils_GetHighlightText(""
        .. "- Plugins : Add to Notes <version> <category - Titan menu> <if LDB>.\n"
        .. "- Skins : Add text to use Bars / Bars - All to change skins.\n"
    )
    .. TitanUtils_GetGreenText("Titan : \n")
    .. TitanUtils_GetHighlightText(""
        .. "- Changed annotations and comments for better documentation.\n"
        .. "- Better handling of routines different between retail and Classic API.\n"
        ..
        "- Deprecated the Titan 'child' template, it has not been used in years. Template and param will be deleted in a future release.\n"
    )
    .. "\n\n"
    .. TitanUtils_GetGoldText("8.0.10 : 2024/03/14\n")
    .. TitanUtils_GetGreenText("Titan : \n")
    .. TitanUtils_GetHighlightText(""
        .. "- TOC update only : Classic Era to 1.15.2.\n"
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
