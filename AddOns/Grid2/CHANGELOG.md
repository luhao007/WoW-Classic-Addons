# Grid2

## r955 (2020-03-11)

- Classic: TOC Update  
- -Changed "Deepwind Gorge" mapId in GridRoster(ticket #806)  
    -Fixed possible crash in status directions.  
- - Added some optimizations to icons indicator and buffs/debuffs statuses.  
    - Fixed minor bug in icons indicator.  
- -Added some missing raid debuffs for Ny'alotha raid.  
    -Removed some debug code.  
- Fixing ticket #795 (Dispellable Debuff blacklisting not working well)  
- -Debuffs: Added optional blacklist to dispelleable debuffs status (ticket #788)  
    -RaidDebuffs: Removed unnecessary Ny'alotha maps in bugged\_maps table.  
-   
- Fixing ticket #786 (Ny'alotha RaidDebuffs not working)  
- Fixing a bug in debuffs groups blacklists: using spellIDs did not work, now spellIDs are correctly converted to spellNames.  
- TOC Update for 8.3  
    Added "Ny'alotha, the Waking City" raid debuffs.  
- Fixing ticket #780  
- TOC Update for retail  
- TOC Update  
- Classic: Repackaged with a new libhealcomm-4 stable version.  
    Healths: Added unit\_connection event to health tracking code.  
- -Added time band and selectable heal types to heals-incoming &amp; my-heals-incoming statuses configuration.  
- Repackage with newest libhealcomm-4 library.  
- Using LibHealComm-4.0 instead of LibClassicHealComm  
- -Fixing overheals issue (ticket #756)  
- -Fixed: Dispellable debuffs not working in classic (ticket #754)  
    -Fixed: Debuffs tracked text values not displayed (ticket #755)  
- -Fixed a bug with "Include Player Heals" option (ticket #749)  
- Recoded roles management in layouts&amp;layout editor for Classic (ticket #748)  
- Added database fix code that deletes nonexistant modules to avoid possible raiddebuffsoptions crash (ticket #746).  
- Added my-incoming-heals status for classic.  
- -Reimplemented class filters for buffs in classic.  
- Refactored some code in my-incoming-heals status, now the status is classic compatible (but only if a reported bug in libhealcomm library is fixed).  
- -Fixing ticket #739, workaround to game bug, the game reports that nonmana classes have mana just after a new unit is added to the roster.  
- -Fixed a typo in the error messsage when the wrong Grid2 package was installed.  
    -Added overhealing status (ticket #735)  
- -Posible fix to ticket #734 (not all raid visible in dungeons)  
    -More changes in offline status.  
    -Fixing posible crash in masterlooter status.  
- More changes in offline status (reimplemented a timer).  
- Added a classic/retail check + error message if the wrong version was installed.  
- Icons indicator: Lowered the max possible number of icons to 6 in options (down from 20)  
- Added an option to lock/unlock Grid2 window movement in Minimap button popup menu.  
- Fixing crash on profile import (ticket #710)  
- -Fixing issue with incorrect frame sizes when changing theme (ticket #708)  
- Classic: Removed banzai status.  
- -Banzai status: Bug Fix, status was not detecting interrupted casts (ticket #703)  
- Now the offsetX and offsetY of the icons Stack text can be configured.  
- Refactored Offline status (ticket #702)  
- -Classic: Fixed crash in charmed status (ticket #697)  
    -Banzai statuses, added nameplate units tracking (this allows to detect more banzais)  
    -Auras: Added a new Text section in buffs and debuffs, this allows to configure which text must be displayed in text indicators (aura name, a custom text, or a value).  
    -Minimap icon popup menu: Added a new section to fast switch Grid2 visibility: Always/grouped/Raid.  
- Fixed a crash in multibar indicator (ticket #696)  
- Added some classic/retail checks, changed toc file.  
- -Changed glow textures.  
    -Fixed bug with multibar indicators when changing themes.  
    -Classic: Fixed bug in health &amp; heals-incoming statuses  
    -Classic: Fixed setup defaults for mage.  
- Updated Russian locale (thanks to Gizmii).  
- Updated english and spanish translations.  
- Classic: Now Aura durations/remaining time display/tracking can be disabled.  
- Classic: Now RaidDebuffs cooldowns are displayed.  
- Classic: Added LibClassicDurations Library.  
    Classic: Now cooldowns of buffs&amp;debuffs can be displayed.   
- Classic: Added LibClassicHealComm-1.0 library  
    Classic: Added heals-incoming status  
- Updated pkgmetas, added missing ignore files  
- Updated pkgmeta files  
    Added setup defaults for classic.  
- toc changes  
- Removed modules.xml  
    Updated TOC file.  
- Changes to use BigWigs packager.  
- Multibar indicator: Fixed a subtle graphical glitch. StatusBar main texture was updated one frame later, so the main bar draw process was not in sync with the additional bars, this causes that when the main bar value changes (and additional bars or the multibar background are visible), for a few milliseconds the frame background was displayed instead the main bar.  
- Repackage Grid2 with AceConfig library alpha version (stable version crash in Wow Classic)  
- -Reactivated RaidDebuffs module in Classic.  
    -Added raid debuffs for Classic Raids.  
- -Classic: Fixed range status crash for priests.  
    -Classic: Fixed some non-existent textures.  
- -Added shields-overflow status (tracks when part of the shield is above player max hp)  
    -Added Grid2 Glow Vertical and Grid2 Glow Horizontal textures, can be used with shields-overflow + rectangle indicator.  
    -Added compatibility with Wow Classic: Several statuses and the RaidDebuffs module are disabled for classic.   
- -RaidDebuffs: Added up/down buttons to change debuffs position in the priority list (ticket #690)  
    -Added suggested patch to fix Down click misbehavior when using Clique, thanks to Humfras (ticket #692)  
- -Fixing ticket #691, Eternal Palace RaidDebuffs not loaded after a d/c.  
    -Using AceGUI library stable version.  
- -Alpha indicator: Now the default alpha can be configured (alpha when the indicator is not active), previously it was always full opaque(1).  
    -Added an "Hide in Pet Battle" option in General&gt;Appearance  
    -Fixed a bug in "Show Frame" option, It was not working when "Display all groups" (in layout editor section) option was enabled.  
- -Directions status: removed guess direction option, cannot be used due to new nameplates restrictions  
    -health-low status: now this status can be assigned to alpha indicator.  
- Fixing a crash when opening configuration (Ticket #684)  
- -Grid2 repackage with an AceGUI library alpha version (see ticket #683)  
- -Added Eternal Palace raid debuffs.  
    -Added Operation: Mechagon instance debuffs  
    -Workaround for ticket #682  
- Fixing: wrong auras displayed just when new unit frames are added (ticket #681)  
- TOC Update  
- -Alpha indicator: Minor speed optimization.  
    -Alpha indicator: Now a global opacity can be specified (will be used instead of the opacity provided by the statuses) (see last comments on ticket #671).  
    -Icons indicator: now a negative value can be set for the icons spacing option (must by typed manually) (ticket #678)  
    -Buffs/Debuffs statuses: Now the buff/debuff Name or spellID can be changed for single buffs/debuffs.  
- -Fixing ticket (#677) Frames move with every UI reload when ElvUI is enabled  
- -Fixing minor issue in raiddebuffs config.  
    -Now unit frames are visible if UI is reloaded in combat.  
- -Square indicator: Now indicator border color can be swapped with the main square/rectangle color.  
    This allows to create extra border indicators, in this way:  
    1. Create a new square indicator, and adjust position/size/framelevel, enabling rectangle option if necessary.   
    2. Link the statuses we want to track to the indicator.  
    3. Set a border size higher than 0  
    4. Set a transparent color for the border (move down the opacity slider).  
    5. Enable "Swap Colors" option, so the square will be filled with the transparent color (instead of the border).  
    6. Ready, now the linked statuses colors will be used to draw the square border, and the square will remain transparent.  
- -Phased status, little optimization now timer is paused inside instances.  
    -RaidDebuffs statuses now can be mapped to text indicators.  
- Fixing ticket #671 (now auras can be used with the alpha indicator)  
- -Fixing first part of ticket #669 (indicator sizes specified in themes were not used on theme changes).  
- -Added "Phased" status (in miscellaneos category)  
    -Fixed a bug in auras management (auras were not disabled correctly)  
    -Now values higher than 75 can be used for bars width and height (ticket #668)  
    -Fixed a minor bug in debuffs creation window.  
    -Now Buffs and Debuffs can be class specific (ticket #659):  
      All buffs and debuffs have a new "Enabled for" option where one can select a toon class, if  
      an aura is enabled for a class, the aura will be disabled for the rest of classes,  
      this allows to use the same profile for several classes and to link a lot of auras to the   
      same indicators without cpu performance cost.  
- Icon Indicator: Added and option to activate animations only when the indicator is activated (not on updates) (see ticket #665)  
- -Add some Crucible of Storm Raid Debuffs.  
    -Fixing ticket #658 (Profile import crash if imported profile has custom layouts)  
- A new special buffs group status can be created (buffs:Blizzard), this status displays the same buffs  
    than the blizzard default raid frames, can be linked only to an "icons" (plural) indicator.  
- - Using softMin&amp;softMax for indicator coordinates in config (allowing to bypass the 50 pixels limit).  
    - Now a disabled Tooltip indicator is not reenabled when a config option is changed (see last comment on ticket #655).  
- -Fixing Arathi Basin and Warsong Gulch BGs mapIds (ids changed in patch 8.1.5) (ticket #654)  
- Fixing ticket #652 (Random BGs always return raidsize 40)  
- - Using a different workaround (a timer instead of UPDATE\_RAID\_INFO event) to fix ticket #641  
    - Fixed Range&amp;Role statuses possible crash when changing profiles (to update indicators inside OnEnable event is not allowed).  
- -Fixing ticket #649 (IsAddonMessagePrefixRegistered() does not exists)  
    -Trying to fix ticket #641 for a second time (Wrong raid size in pvp)  
    -Added mythic+ debuffs to the debuff creation dropdown list (typing "mythic" all debuffs are displayed in the dropdown)  
- Fixing Ticket #644 (Icons indicator showing buffs group not hiding buff that expires).  
- Fixing ticket #642 (Mana Bar appears empty for healers who respec)  
- - Added 15 man raid size to Themes Conditions and Layout Sizes.  
    - Fixing raid size issue in BGs, see ticket #641.  
    - Added Grid2:SetDefaultTheme(theme) function, to allow to change the current theme   
    from external sources like macros or other addons, "theme" parameter can be an index   
    (starting in 0) or a theme name.  
- - Fixed a crash when a profile with disabled indicators is loaded.  
- Added some missing "Battle of Dazar'alor" Raid Debuffs.  
- -Added "portrait" indicator, it can display unit 2d, 3d model or class icon.  
    -No portrait indicator is created by default, user must created the indicator manually.  
- -Fixing wrong profile export when multiple themes were defined (only one theme was exported).  
    -Enhanced workaround for ticket #640: now all used backdrops are assigned only if the config has really changed to avoid delays (because SetBackdrop() method is awful slow). Now all backdrops are created using the same function, avoiding creating multiple tables for the same backdrop configuration, saving a bit of memory.  
- - Icons indicator issue fixed: Switching themes freezes the game for a second when a lot of icons indicators are defined (ticket #640)  
- Direction Status: Fixed a crash introduced in version r839 (Ticket #639)  
- -Fixing ticket #638 (buffs groups not showing up)  
- - Added Raid Debuffs for Battle of Dazar'alor and Crucible of Storms (Remember to go to "Statuses"-&gt;"Debuffs"&gt;"Raid Debuffs" to enable the raid debuffs for the new raids).  
- *Options inside "Debug" tab moved to "About" tab.  
    *Reverted visual changes in option window to avoid confusion with new Themes configuration. Now the options to manage multiple themes are disabled by default and the grid2 window will display old style configuration, Themes Section is now hidden, only some minimal changes in General Section:  
    - "General" Tab renamed to "Appearance".  
    - "Misc" Tab renamed to "General".  
    - Added new "Indicators" tab to configure default indicators values, and which indicators must be enabled/disabled.  
    Now to enable Multiple Themes a checkbox placed in *General Section/General Tab/Enable Themes* must be checked, once enabled the "Themes" section becomes visible, and "Appearance", "Indicators" and "Layouts" tab in general options are moved to Default theme inside "Themes" Section. The Layout Editor is not moved to Themes section and it stays in General/Layouts Tab.  
- Fixing (for the second time) ticket #633 (Indicator configuration doesn't update correctly)  
- -Fixing ticket #633 (Indicator configuration doesn't update correctly)  
- Changed a bit the tooltip indicator code and configuration, now must be more intuitive.(see ticket #631)  
- Fixing #632 ticket ("Color Charmed Unit" option cannot be disabled)  
- -Range Status:  
    Now "Heal Range" can be used in non healer specs (range status will use 38 yards range if no heal spell is available).  
    Now "Heal Range" option is not class specific (the same profile will work for different heal classes).  
    -Raid Debuffs:  
    Added some code for develop &amp; debug purposes (a hidden option to extract instances&amp;bosses info from the Game Encounter Journal)  
- Added an stacks count activation threshold option to buffs and debuffs statuses (ticket #629)  
- -Workaround to blizzard securegroupheaders bug introduced in patch 8.1 (see ticket #628)  
- TOC Update  
- - Icon Indicator: Now stack count text will be displayed over the cooldown animation, not applicable to icons(plural) indicator. (Ticket #623)  
    - Health Updates: Removed normal update frequency, now only "Fast" and "Instant" updates are applicable. This must fix ticket #625.  
    - Health Updates: "Fast" update frequency renamed to "Normal", so only "Normal" and "Instant" are available in configuration.   
    - Themes: Now specialization theme rules/conditions are class specific. (Ticket #626).  
- Debuffs: Now mine &amp; not-mine debuffs can be created, useful to track the new priest "Weakened Soul" debuff.  
- *Added a new "summon" status to track summoned players (summon accepted, declined,etc)(setup is under Miscellaneous category).  
    *Using background textures instead of border textures for mouseover highlight texture option.  
- -Fixing readycheck status bug (when linked to icons indicator) (second issue in ticket #616)  
- -Minor changes in ReadyCheck status.  
    -Fixed a minor issue in roster module.  
- -Now StatusAOE configuration allows to add more spells (spells with spellID&gt;150000)  
    -Using a standalone frame as parent for animation timers instead of the Grid2 main frame (because   
    using Grid2 main frame, timers "Play" method is up to half million x times slower :O).  
- -Minor refactoring in roster management, role and ready check statuses.  
    -Removed some debug code.  
- -Replace all AceTimers with built-in timers.  
    -Removed AceTimer library.  
    -Fixed a bug, auras tracking by spellID was not working.  
- - Fixed a crash due to a bug in conversion code from old custom layout format.  
- Fixed a crash with ancient user defined layouts.  
- *Removed a lot of layouts, now the only available built-in layouts are:  
     By Group, By Class, By Role, By Group &amp; Role.  
     Deleted layouts can be recreated using the layout editor.  
    *Added some defaults settings for layouts in General -&gt; Layouts.  
    *Improved the layout editor (in General -&gt; Layouts): Now players NameLists filters can be defined.  
    *Fixed a bug: not all players were visible in some Brawl instances when using some built-in layouts.  
- -Little optimization in Leader status.  
    -Added "Combat" and "Combat:mine" statuses.  
- -Fixed a bug in StatusAuras/Multibars. "Val" values were not set to nil when a buff ends (ticket #609)  
    -Workaround for a strange AceDialog/AceGUI/EditBox bug, occasionally, the first time Theme-&gt;General   
    options are displayed, all slider editboxes display nothing: the sliders display the correct values but   
    the editboxes are blank.  
    -Fixed Minor bug in GridTestLayout.lua.  
    -Fixed a lua error when moving grid2 main window in combat.  
- WARNING this version has massive changes, some crashes&amp;bugs may be expected.  
    -Fixed an issue with tooltips and clique (ticket #602)  
    -Changed the way unit frames are registered on clique addon.  
    -Removed some duplicated raid debuffs.  
    -Refactored StatusAuras/Buffs/Debuffs code to avoid a lot of function calls.  
    -Refactored the code of most timers.  
    -Removed the main window background gradient and added an option to setup the background texture.  
    -Removed the posibility to change profiles based on group type and raid size.  
    -Options to remove or rename indicators have been moved to: Indicators -&gt; Right Panel.  
    -Added the posibility to have multiple "Themes", a different theme can be enabled for each especialization, group type or raid size.  
    A theme defines:  
    * Main window and unit frames appearance &amp; position.  
    * Some default values for indicators: bars orientation&amp;texture, font, font size, icon size, etc.  
    * A list of indicators enabled for the theme.  
    * The layouts to be used.  
    Indicators &amp; Statuses are the same for all themes, but the displayed information &amp; appearance can   
    be customized enabling/disabling different indicators for each theme or using different default values  
    per theme.  
    People who do not want to use themes can locate the old appearance configuration (general&amp;layouts) in the default theme:  
    Left Panel -&gt; Themes -&gt; Default.  
- - Fixing ticket #594, (whitelisted debuffs not displayed).  
    - Fixing minor pets bug in GridLayout.  
    - Debugging options now are global (instead of per profile).  
- Fixed a crash when changing profiles.  
- - Fixing ticket #593 (Grid2 layouts not working in Brawl)  
    - Cleaning a bit layouts definitions and layouts managemente code.  
    - Refactored de Tooltip management code:   
     * Now tooltip is a new indicator, configurable from Options -&gt; Indicators -&gt; tooltip  
     * Statuses that can be assigned to the new tooltip indicator: Name, Banzai, RaidDebuffs, Debuffs (groups of debuffs)  
- RaidDebuffs: One more workaround for the never-ending ticket #588 (Uldir RaidDebuffs not loading).  
- -Fixed Status Range bug when changing profile.  
    -RaidDebuffs: Workaround to try to fix ticket #588 (sometimes raiddebuffs not loaded).  
- -Fixed target status not updated when raid members were added or removed (ticket #581)  
    -Fixed Buffs groups colors time tracking bug (ticket #590)  
    -Fixed timetracker initialization bug in StatusAuras.lua (initialization code was executed multiple times instead of only once)  
    -Some minor speed optimization tweaks in several statuses.  
    -Added number of raid debuffs loaded in Grid2 LDB and Minimap tooltip.  
- Profiles management:   
    - Now profile configurations by Raid Type (pvp/lfr/mythic/etc) are optional.  
    - Removed "Raid(world)" &amp; "Raid(other)" configurations, replaced by a simple "Raid" profile option.  
- -Fixing non self debuffs bug (ticket #582).  
    -Layouts Editor: Added Role Order option (visible when Group By: "Role" is selected).  
    -Refactored Profiles Management Code:  
     *Removed libdualspec library (now grid2 own code handles spec profile changes).  
     *"Advanced" tab renamed to "Import&amp;Export"  
     *New "Advanced" tab to configure advanced profiles:  
     *Added "Enable profiles by Specialization" option to Advanced tab.  
     *Added "Enable Profiles by Type of Group"  option to Advanced tab. Enabling this option a different   
      profile can be selected for each type of group: solo, party, arena, raid, etc.  
     *Profiles "by spec" and "by type of group" can be enabled at the same time.  
- Added configuration options to Texture&amp;Color mouseover Highlight.(ticket #580)  
- Raid Debuffs: Added a lot of 5man instances debuffs.  
- Fixed Grid2Options crash when game client is in windowed mode.  
- - Removed duplicated raid debuffs.  
    - Added some missing Uldir Raid Debuffs (thanks to Sixthumbs)  
- add a few more Uldir debuffs, thanks to JD  
- -Fixed banzai status.  
    -Added a "Display Square" option to Icons indicator, enabling this option, the indicator will display a flat square instead the icon provided by the active status, useful to display a colorized square with an animation cooldown (see ticket #574).  
- Fixing Buffs status bug (ticket #573).  
- - Speed optimization for Debuffs Groups statuses.  
    - Minor code tweaks.  
- -Fixing bug in Dispellable debuffs filter status (ticket #572)  
- -Some tweaks to Debuffs status , trying to fix ticket #572.  
    -Added Horizontal&amp;Vertical position sliders to general options (ticket #454)  
- Fixed layouts by raid size functionality (ticket #570)  
- -Enabled right click menu functionality without clique addon.  
    -Removed clickthrough option.  
    *RaidDebuffs:  
    -Removed old expansions raid debuffs  
    -Simplified raid debuffs autodetection code.  
    -Added Battle for Azeroth raid debuffs for 5man instances and Uldir raid.  
    *** WARNING: This version will reset raid debuffs configuration on first run,   
    all raid debuffs will by removed (even custom debuffs).  
- - Fixed Grid2RaidDebuffs crash (ticket #566)  
- Fixed Direction status crash.  
- -Fixed AOE Heals status (ticket #560)  
    -Fixed Voice status (maybe, not tested).  
- -Fixed dispeleable debuffs crash (ticket #557)  
    -Fixed Voice status crash, status was disabled, it does not work anymore(ticket #558)  
    -Grid2RaidDebuffs: Due to Battle for Azeroth api changes WorldMapAreaIDs cannot be used anymore.  
    So all WorldMapAreaIDs were converted to instanceMapIDs (8th parameter of GetInstanceInfo())  
- -Fixes for 8.0.1  
- clean out a few old class spells and fix a typo  
- huge whitespace cleanup and add .editorconfig file so this does not happen again. also fix some typos.  
- fix a typo and a nil check  
- Updated Antorus raid debuffs.  
- Fixed a bug in status debuffs code.  
- - Fixing ticket #525 (refactored hide blizzard raid frames code)  
    - Added a filter in "Debuffs" statuses to display only debuffs the player can dispell/cure (#520).   
      Debuffs statuses can be created going to Statuses -&gt; Debuffs -&gt; Right Panel -&gt;   
      Select "Debuffs" -&gt; Type a name for the status -&gt; Create Debuff  
- RaidDebuffs, added debuffs for:   
    Karazhan, Cathedral of eternal night, The Seat of the Triumvirate (5man)  
    Antorus, the Burning Throne (raid)  
- TOC Update  
    Fixed ticket #519  
    Fixed ticket #514  
- Added Tomb of Sargeras raiddebuffs (thanks to Benea &amp; Skyburn), ticket #511  
- -Fixed ticket #504  
    -Workaround to try to fix ticket #506  
- -TOC Update.  
    -Fixed ticket #503 (raiddebuff id fix).  
    -Minor changes.  
- - Added an "Indicators" tab for each status to direct link/unlink indicators to the status (multibar indicators cannot be assigned from this new tab).  
    - Now status delete button displays a message when the status cannot be deleted (ticket #481)  
- Added Nighthold raiddebuffs #499 (thanks to Xerxes)  
    Added missing power types #500 (thanks to Xeveran)  
- TOC uPDATE  
- Ticket #494: Added Trial of Valor raid debuffs (thanks to Xerxes13)  
- Fixed ticket #492  
- Fixed ticket #391  
- Added direction arrows status.  
- Added an option to disable Right-Click Menu. Ticket #464  
- Fixing ticket #477. Changed range heal spell for priests to "Leap of Faith", thanks to Xerxes13.  
- Fixed ticket #461 (health instant updates doesn't update on pet resummons)  
- RaidDebuffs: Added Legion raiddebuffs for raids, world bosses and 5man instances.   
    The Legion module must be enabled in raiddebuffs configuration options.  
- -Moved Healing spells tracking status from AOE-Heals module to Grid2 Core.  
    -Removed AOE-Heals module (motive: Blizzard disabled unit position tracking in Legion)  
    -Removed Direction Status (motive: Blizzard disabled unit position tracking in Legion)  
    -Range Status:  Added a new option in configuration to track units checking a healing spell range, this must fix range issues for some healing clases (goto Statuses&gt;Target&amp;Distances&gt;Range to select the new option)  
- - Fixed AoeHeals crash  
    - Added a new by role x10 layout.  
    - Minor changes in configuration options.  
