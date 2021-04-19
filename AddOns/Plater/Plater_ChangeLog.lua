


local Plater = Plater
local _

function Plater.GetChangelogTable()
	if (not Plater.ChangeLogTable) then
		Plater.ChangeLogTable = {
		
			{1616962855,  "Bug Fix", "March 28th, 2021", "Fixing Questie support."},
		
			{1605864094,  "Backend Changes", "November 20th, 2020", "Switching mod/script code shadowing to DF."},
			{1605864094,  "Bug Fix", "November 4th, 2020", "Fixing script priority slider position."},
			
			{1605864094,  "Options Changes", "November 10th, 2020", "Adding 'auras per row' overwrite option. (not UI)"},
			{1605864094,  "Backend Changes", "November 10th, 2020", "Make aura rows grow in the proper directions according to the selected anchor position."},
			{1605864094,  "Backend Changes", "November 10th, 2020", "Enable tooltips on buff special."},
			{1605864094,  "Backend Changes", "November 10th, 2020", "Supress blizzard timers on buff special."},
			{1605864094,  "Backend Changes", "November 10th, 2020", "Adding font options for buff special timer, stack and caster texts. (not UI)"},
			
			{1605864094,  "Options Changes", "November 5th, 2020", "Nameplate color dropdown now works on any map."},
			{1605864094,  "Options Changes", "November 5th, 2020", "Added class color option to Enemy Player."},
			{1605864094,  "Bug Fix", "November 5th, 2020", "Fixed aura show animation not playing at the right times + scale reset."},
			{1605864094,  "Options Changes", "November 5th, 2020", "Global health bar resizer now also resize the cast bar width."},
			{1605864094,  "Options Changes", "November 5th, 2020", "Adding an option to not show the cast target if the player is a tank."},
			
			{1605864094,  "Bug Fix", "November 2nd, 2020", "Execute range indicator overlay is back to its lower alpha value."},
			{1605864094,  "Bachend Changes", "November 2nd, 2020", "Sorting consolidated auras properly."},
			{1605864094,  "Options Changes", "November 1st, 2020", "Adding option to use target alpha settings for focus target as well."},
			{1605864094,  "Options Changes", "November 1st, 2020", "Adding option to disable Aggro-Glow."},
			{1605864094,  "Bachend Changes", "October 31st, 2020", "Shortening names should now work properly on all non-latin charsets."},
			
			{1605864094,  "New Feature", "October 30th, 2020", "New function to duplicate or copy mod/script options to other mods/scripts."},
			{1605864094,  "Options Changes", "October 27th, 2020", "Adding an option to disable the '-AGGRO-' flash (off by default)."},
			{1605864094,  "Bug Fix", "October 26th, 2020", "Ensure mods/scripts are saved properly before exporting a profile."},
			{1605864094,  "Bachend Changes", "October 25th, 2020", "'IsSelf' is now more consistent across the members."},
			{1605864094,  "Bachend Changes", "October 25th, 2020", "Proper alpha checks for the personal bar."},
			{1605864094,  "Bachend Changes", "October 25th, 2020", "Refresh settings tab when selecting it."},
			{1605864094,  "Bug Fix", "October 25th, 2020", "Stopping nameplate flash animations on nameplate removal."},
			{1605864094,  "Bug Fix", "October 24th, 2020", "Fixing an issue with internal aura sorting making auras too 'jumpy'."},
			{1605864094,  "Bug Fix", "October 24th, 2020", "Fixing an issue with LibCustomGlow implementation not recognizing the key properly in certain cases."},
			
			{1603571275,  "Backend Changes", "October 22nd, 2020", "Adding 'upper range' execute ranges. (e.g. 100% to 80%). Useably via 'Plater.SetExecuteRange (isExecuteEnabled, healthAmountLower, healthAmountUpper)'"},
			
			{1603571275,  "Bug Fix", "October 20th, 2020", "Fixing issue with no-combat alpha and coloring."},
			{1603571275,  "Bug Fix", "October 19th, 2020", "Fixing an issue with scripts/mods not being re-compiled properly."},

			{1603571275,  "Bug Fix", "October 18th, 2020", "Execute Glow effect now scales properly with healthbar size."},
			{1603571275,  "Bug Fix", "October 17th, 2020", "Fixing an issue with overwritten modTable/scriptTable for mods/scripts with the same name."},
			{1603571275,  "Bug Fix", "October 17th, 2020", "Destructor Hooks now are called again."},
			{1603571275,  "Bug Fix", "October 15th, 2020", "Selecting Profile Import text box is now easier."},
			{1603571275,  "Bug Fix", "October 15th, 2020", "Fixing an issue with importing profiles."},
			
			{1603571275,  "Bug Fix", "October 14th, 2020", "Fixing issue with plate sizes not updating properly when entering combat."},
			{1603571275,  "Bug Fix", "October 14th, 2020", "Fixing npc title recognition."},
			
			{1603571275,  "Options Changes", "October 13th, 2020", "New global nameplate width and height options for easier setup."},
			{1603571275,  "Backend Changes", "October 13th, 2020", "New option for 'In Combat' config to apply according to combat state of the unit."},
			
			{1603571275,  "Bug Fix", "October 7th, 2020", "Fixing Health % 'Out of Combat' option."},
		
			{1603571275,  "Bug Fix", "September 22nd, 2020", "Fixing a re-scaling issue with the target highlight glows."},
			{1603571275,  "Bug Fix", "September 15th, 2020", "Cast bar alpha will not be changed for range/target when already fading."},
			{1603571275,  "Backend Changes", "September 14th, 2020", "'Stacking' and 'Friendly' nameplates auto toggle (Auto tab) now apply in PVP zones as well."},
		
			{1603571275,  "Bug Fix", "August 21st, 2020", "Units should now be added to NPC list more consistently."},
		
			{1603571275,  "Backend Changes", "August 16th, 2020", "Configuration for minor and pet nameplates should now prefer minor over pet."},
			{1603571275,  "Bug Fix", "August 11th, 2020", "Bugfix to 'Cast Bar Icon Config' mod."},
		
			
			{1596791967,  "Bug Fix", "August 7th, 2020", "Buff Frame Anchors behave consistent with grow direction and anchor position now."},
			
			{1596672621,  "New Feature", "August 6th, 2020", "New Mod added: 'Cast Bar Icon Settings [P]', this is a new mod to deal with the cast bar icon at ease. It can be enabled at the Modding tab."},
			
			{1594844798,  "Backend Changes", "August 4th, 2020", "Adding cache value 'unitFrame.IsFocus' for usage in mods/scripts."},
			{1594844798,  "Backend Changes", "July 30th, 2020", "Range/Target Alpha options should behave more consistent now."},
			{1596627316,  "Options Changes", "July 29th, 2020", "Adding icon size options for Buff Frame 2."},
			{1596627316,  "Options Changes", "July 29th, 2020", "Adding anchor options for Buff Frames. Important: this requires offset migration, which is attempted automatically, but you might need to setup Buff Frame anchors and offsets again."},
			{1596627316,  "Options Changes", "July 29th, 2020", "Adding option to ignore duration filtering on personal bar buffs."},
			{1596627316,  "Options Changes", "July 29th, 2020", "Adding options for 'Big Actor Title' on enemy npcs to better support 'name only' mode in mods."},
			
			{1594844798,  "Bug Fix", "July 15th, 2020", "The event code buttons now show the correct code."},
			{1594844798,  "Backend Changes", "July 15th, 2020", "'Hide OmniCC' now surpresses tullaCC as well. Option available for Boss-Mod-Auras as well."},
			
			{1594193442,  "Backend Changes", "July 8th, 2020", "Switching to WoW Threat API."},
			
			{1593011350,  "Bug Fix", "June 26th, 2020", "Fixing an issue with the 'Use Tank Threat Colors' setting not applying properly."},
			{1593011350,  "Bug Fix", "June 24th, 2020", "Fixing an issue with reputation standing showing on friendly NPCs instead of the unit title when color blind mode is enabled."},
			{1593011350,  "New Feature", "June 24th, 2020", "Introducing 'Custom Options' for Mods and Scripts as per profile settings for the mod/script."},
			{1593011350,  "New Feature", "June 24th, 2020", "Profile updates from wago.io through the companion app will now keep additionally imported mods/scripts which were not part of the profile."},
			{1593011350,  "Bug Fix", "June 24th, 2020", "Fixing buff special tracking being case sensitive and auto-suggest being all lower-case."},
			
			{1593011350,  "New Feature", "June 24th, 2020", "Adding options to skip or ignore profile updates."},
			{1593011350,  "New Feature", "June 24th, 2020", "Adding options to skip or ignore a mod/script updates."},
			{1593011350,  "New Feature", "June 24th, 2020", "Wago-Icons on Mods/Scripts are now clickable to update."},
			{1593011350,  "Bug Fix", "Jne 24nd, 2020", "Range/Target alpha should now update properly."},
		
			{1588949935,  "New Feature", "May 7th, 2020", "Adding 'Plater.GetVersionInfo(<printOut - bool>)' function to get current version information."},
			{1588949935,  "Bug Fix", "May 7th, 2020", "Spell names are now truncated properly accordingly to the nameplate size."},
			{1588949935,  "Bug Fix", "Apr 29th, 2020", "Shield Absorb indicators are now updated properly when showing the plate for the first time."},
			{1588949935,  "New Feature", "Apr 28th, 2020", "Supporting whole Plater profiles to be updated from wago.io via WA-Companion app."},
			{1588949935,  "New Feature", "Apr 28th, 2020", "Available Wago.io updates will now be indicated by small wago icons on the tabs."},
			
			{1587858181,  "Bug Fix", "Apr 25th, 2020", "Fixing 'copy wago url' action not updating the URL properly."},
			{1587858181,  "Bug Fix", "Apr 16th, 2020", "Pet recognition is working for russian clients as intended now."},
			
			{1586982107,  "Bug Fix", "Apr 7th, 2020", "Do not clean up NPC titles."},
			{1586982107,  "Backend Changes", "Mar 29th, 2020", "'Consolidate Auras' now uses the icon instead of the name for uniqueness."},
			{1586982107,  "Backend Changes", "Mar 29th, 2020", "Pets and Minions should now be recognized better."},
			{1586982107,  "Bug Fix", "Mar 27th, 2020", "Alternate Power should now show properly on the personal bar if using UIParent."},
			{1586982107,  "Backend Changes", "Mar 27th, 2020", "Failsafe for NPC-Colors imports: warning messages are shown if used on the wrong tab."},
			{1586982107,  "Bug Fix", "Mar 16th, 2020", "Ensure Boss Mod Icons are unique and not duplicated."},
			{1586982107,  "Bug Fix", "Mar 16th, 2020", "Ensure cast bars stay hidden according to settings for friendly / enemy units with both enabled."},
			{1586982107,  "New Feature", "Mar 16th, 2020", "New scripts/mods imported from wago.io now show the URL, Version and Revision. Plus you can copy the url through the right mouse button menu."},
			{1586982107,  "Backend Changes", "Mar 16th, 2020", "Imports for Mods/Scripts now prompt to overwrite if one with the same name already exist."},
			{1586982107,  "Backend Changes", "Mar 14th, 2020", "Imports on wrong tabs are now handled better and show propper error messages."},
			
			{1583878613,  "New Feature", "Mar 10th, 2020", "Adding unit aura caching which covers all auras on the unit, even if they are not visible. -> Plater.UnitHasAura(unitFrame)"},
			{1583878613,  "Bug Fix", "Mar 6th, 2020", "Consolidate auras by spellId instead of name."},
			{1583878613,  "New Feature", "Mar 6th, 2020", "Adding a search tab to the options menu to lookup settings."},
			{1583878613,  "Bug Fix", "Mar 1st, 2020", "Ensure nameplates are updated properly when a unit becomes hostile."},
			{1583878613,  "Bug Fix", "Feb 27th, 2020", "Fixing an issue with cast bars not updating properly with different versions of DF library."},
			{1583878613,  "New Feature", "Feb 27th, 2020", "Adding support for DBM and BigWigs Nameplate Icon feature. Settings are on the Buff Special tab."},
			{1583878613,  "New Feature", "Feb 24th, 2020", "Adding line numbering to scripting frames."},
			{1583878613,  "Bug Fix", "Feb 21st, 2020", "Ensure nameplates are updated fully when being added to screen."},
			{1583878613,  "Options Changes", "Feb 18th, 2020", "Adding Cast-Bar offset setting to friendly units."},
			{1583878613,  "New Feature", "Feb 3rd, 2020", "Mods now have 'modTable' as a mod-global table shared about all nameplates the mod runs on. Same for scripts with 'scriptTable'. The new 'Initialization' function for mods and scripts can be used to initialize the global env table."},
			{1583878613,  "", "Jan 20th, 2020", "Added cooldown text size setting for Buff Especial."},
			{1583878613,  "Bug Fix", "Jan 20th, 2020", "Fixing rare nil-error with UNITIDs."},
			{1583878613,  "Options Changes", "Jan 17th, 2020", "Added options to set alpha for each frame individually on transparency settings."},
			{1583878613,  "New Feature", "Jan 19th, 2020", "Added some GoTo buttons in the options frame to help new users find the basic tabs to setup."},
			{1583878613,  "Options Changes", "Jan 18th, 2020", "Many default textures has changed plus health and shield prediction are enabled by default."},
			
			{1579261831,  "New Feature", "Jan 21st, 2020", "Alpha for range check can now be set individualy to health, cast, power, buff bars."},
			{1579261831,  "Backend Changes", "Jan 21st, 2020", "Entry for scripts 'namePlateAlpha' has been removed."},

			{1579261831,  "Bug Fix", "Jan 17th, 2020", "Updating OmniCC integration for 8.3 changes in OmniCC."},
			{1579261831,  "Options Changes", "Jan 17th, 2020", "Adding native support to 'Non Target Alpha' called now 'Units Which Isn't Your Target' in the General Settings Page."},
			{1579261831,  "Bug Fix", "Jan 7th, 2020", "Ensuring BuffFrame2 is shown/hidden properly."},
			{1579261831,  "Backend Changes", "Jan 4th, 2020", "Buff-Special enhancement: Adding Stack info and more public information for modding / scripting."},
			{1579261831,  "New Feature", "Dec 31st, 2019", "Introducing run priority for mods and scripts."},
			
			{1577547573,  "Backend Changes", "Dec 28th, 2019", "Switching to LibThreatClassic2."},
			{1577547573,  "Bug Fix", "Dec 28th, 2019", "Fixing error with Raid Marks."},
			{1577547573,  "Backend Changes", "Dec 28th, 2019", "Updating Masque integration."},
			{1577547573,  "Bug Fix", "Dec 28th, 2019", "Ensure raid target frames to be above healthbar."},
			{1577547573,  "Bug Fix", "Dec 23rd, 2019", "Fixing color and castBar updates on 'no healthbar' mode."},
			{1577547573,  "Options Changes", "Dec 23rd, 2019", "Bringing back 'Hide Enemy Cast Bar' option."},

			{1576496347,  "Bug Fix", "Dec 16th, 2019", "Fixing tank recognition for player shapeshifts."},
			
			{1575627153,  "Bug Fix", "Nov 27th, 2019", "Tank recognition for player and raid tanks is now be more reliable and include raid role assignment 'MAINTANK'"},
			{1575627153,  "Bug Fix", "Nov 25th, 2019", "Fixing 'Cast by Player' debuff recognition if the caster is a player totem."},
			{1575627153,  "Options Changes", "Nov 19th, 2019", "Adding text options for the npc title."},
			{1575627153,  "New Feature", "Nov 19th, 2019", "Adding support for enemy buff tracking."},
			{1575627153,  "Bug Fix", "Oct 30th, 2019", "Fixing spell cast push-back hiding the castbar in some cases."},
			{1575627153,  "Bug Fix", "Oct 28rd, 2019", "Removing Demoralizing Roar from CC list, as it is no CC in classic."},
			{1575627153,  "Bug Fix", "Oct 23rd, 2019", "Fixing global nameplate offset for Custom Strata Channels."},
			{1575627153,  "Bug Fix", "Sep 26th, 2019", "'Import Profile' should no longer cause broken mods."},
			{1575627153,  "New Feature", "Sep 26th, 2019", "'Import Profile' is now asking to overwrite an existing profile."},
			{1575627153,  "Bug Fix", "Sep 20th, 2019", "Mod conditions are updated to reflect classic options."},
			{1575627153,  "New Feature", "Sep 8th, 2019", "Adding option to switch between DPS and Tank Threat colors, including macro support via '/run Plater.ToggleThreatColorMode()'."},
			{1575627153,  "Bug Fix", "Sep 7th, 2019", "Fixing friends colors."},
			{1575627153,  "Bug Fix", "Sep 7th, 2019", "Fixing spell range check."},
			{1575627153,  "New Feature", "Sep 7th, 2019", "Adding support for the addon 'Questie' to enable plater quest recognition."},
			{1575627153,  "Bug Fix", "Aug 30th, 2019", "Fixing spell name on castbar."},
			{1575627153,  "New Feature", "Aug 30th, 2019", "Adding support for 'Real Mob Health' (addon to show ral health values)."},
			{1575627153,  "New Feature", "Aug 30th, 2019", "Adding support for LibClassicDurations for aura timers on nameplates."},
			{1575627153,  "Bug Fix", "Aug 29th, 2019", "Fixing Power Bar."},
			{1575627153,  "Options Changes", "Aug 29th, 2019", "General settings cleanup for health, absorb, view distance and Personal Bar according to support in classic."},
			{1575627153,  "Options Changes", "Aug 29th, 2019", "Removing settings for personal display and resources on target."},
			
			{1562097297,  "Bug Fix", "July 2nd, 2019", "Fixed spell animations."},
			{1562097297,  "Bug Fix", "July 2nd, 2019", "Fixed script errors which was spamming in the chat."},
			{1562097297,  "Bug Fix", "July 2nd, 2019", "Fixed buffs sometimes not showing in the aura frame 2."},
			{1562097297,  "Bug Fix", "July 2nd, 2019", "Fixed more bugs with quest mobs detection."},
			{1562097297,  "Bug Fix", "July 2nd, 2019", "Unit Highlight is now placed below the unit name and unit health."},
			
			{1557674970,  "New Feature", "May 12, 2019", "Added an option to stack auras with the same name."},
			{1557674970,  "New Feature", "May 12, 2019", "Added an option to change the space between each aura icon."},
			{1557674970,  "New Feature", "May 12, 2019", "Added an option to hide the nameplate when the unit dies."},
			{1557674970,  "New Feature", "May 12, 2019", "Added an option to automatically track enrage effects."},
			{1557674970,  "New Feature", "May 12, 2019", "Experimental tab got renamed to 'Level and Statra'."},
			
			{1554737982,  "Buf Fix", "April 8, 2019", "Fixed 'Only Show Player Name' not overriding the 'Only Damaged Players' setting."},
			{1554737982,  "Buf Fix", "April 8, 2019", "Fixed Paladin's Hammer of Wrath execute range."},
			{1554222484,  "Buf Fix", "April 4, 2019", "Fixed an issue with NameplateHasAura() API not checking Special Auras."},
			{1554222484,  "New Feature", "April 2, 2019", "Language localization has been started: https://wow.curseforge.com/projects/plater-nameplates/localization."},
			{1554222484,  "New Feature", "April 2, 2019", "Added Pet Indicator."},
			
			{1553180406,  "New Feature", "March 21, 2019", "Added Indicator Scale."},
			
			{1553016092,  "New Feature", "March 19, 2019", "Added Number System selector (western/east asia) at the Advanced tab."},
			{1552762100,  "New Feature", "March 16, 2019", "Added Show Interrupt Author option (enabled by default)."},
		
			{1551553169,  "New Feature", "March 02, 2019", "Npc Colors tab now offers an easy way to set colors to different npcs, works on dungeons and raids."},
			{1551553169,  "New Feature", "March 02, 2019", "Added an alpha slider for resources in the Personal Bar tab."},
			{1551553169,  "New Feature", "March 02, 2019", "Added 'No Spell Name Length Limitation' option."},
			
			{1550774255,  "New Feature", "February 21, 2019", "Added checkbox to disable the health bar in the Personal Bar. Now it is possible to use the Personal Bar as just a regular Cast Bar that follows your character."},
			{1550774255,  "Bug Fix", "February 21, 2019", "Fixed RefreshNameplateColor not applying the correct color when the unit is a quest mob."},
			{1550410653,  "Scripting", "February 17, 2019", "Added 'M+ Bwonsamdi Reaping' (enabled by default) hook script for the mobs from the affix without aggro tables."},
			{1550410653,  "Scripting", "February 17, 2019", "Added 'Dont Have Aura' hook script."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed cast bar border sometimes showing as white color above the spell name cast."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed border color by aggro reported to not be working correctly as it should."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed health animation and color transition animations."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed health percent text calling :Show() every time the health gets an update."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed resource anchor not correctly adjusting its offset when the personal health bar isn't shown."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed the neutral nameplate color."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed the channeling color sometimes using the finished cast color."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed hook script load conditions not showing reaping affix."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed some issue with the npc name glitching its size when anchoring the name inside the nameplate."},
			{1550410653,  "Bug Fix", "February 17, 2019", "Fixed an issue with quest state not being exposed to scripts."},
			{1550410653,  "Options Changes", "February 17, 2019", "Added a check box to enable Masque support, default disabled."},
			{1550410653,  "Options Changes", "February 17, 2019", "Added options to change the spell name anchor."},
			{1550410653,  "Options Changes", "February 17, 2019", "Added option 'Offset if Buff is Shown' for resource at the Personal Bar tab."},
			{1550410653,  "Scripting", "February 17, 2019", "Added 'Health Changed' hook event."},
			{1550410653,  "Scripting", "February 17, 2019", "Added unitFrame.InCombat, this member is true when the unit is in combat with any other unit."},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater.GetConfig (unitFrame) for scripts to have access to the nameplate settings."},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater:GetPlayerRole() which returns the name of the current role the player is in (TANK DAMAGER, HEALER, NONE)."},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater.SetExecuteRange (isEnabled, range)"},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater.IsInOpenWorld()"},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater.IsUnitInFriendsList (unitFrame)"},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater.IsUnitTapped (unitFrame)"},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater.GetUnitGuildName (unitFrame)"},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater.IsUnitTank (unitFrame)"},
			{1550410653,  "Scripting", "February 17, 2019", "Added Plater.GetTanks()"},
		
			{1548612692,  "New Feature", "January 27, 2019", "Added an option to test cast bars."},
			{1548612692,  "New Feature", "January 27, 2019", "Added options to customize the cast bar Spark."},
			{1548612692,  "New Feature", "January 27, 2019", "Added options to show the unit heal prediction and shield absorbs."},
			{1548612692,  "New Feature", "January 27, 2019", "Added options for cast bar fade animations."},
			{1548612692,  "New Feature", "January 27, 2019", "Added options to adjust the cast bar color when the cast is interrupted or successful."},
			{1548612692,  "Scripting", "January 27, 2019", "Update for Player Targeting Amount and Combo Points hook scripts."},
			{1548612692,  "Bug Fix", "January 27, 2019", "Fixed target indicator 'Ornament' which was a dew pixels inside the nameplate."},
			{1548612692,  "Bug Fix", "January 27, 2019", "Fixed the unit name which sometimes was 10 pixels below where it should be."},
			{1548612692,  "Bug Fix", "January 27, 2019", "Fixed the unit name showing ... instead when the option to show guild names enabled."},
			{1548612692,  "Bug Fix", "January 27, 2019", "Fixed the personal bar sometimes showing the player name."},
			{1548612692,  "Bug Fix", "January 27, 2019", "Fixed special auras still being tracked after deleting an aura from the track list."},
			{1548612692,  "Bug Fix", "January 27, 2019", "Fixed special auras not being tracked if the aura is in the regular debuff blacklist."},
		
			{1548117317, "Scripting", "January 21, 2019", "Added new hooking scripts for Jaina and Blockade encounters on Battle of Dazar'alor."},
			{1548006299, "Scripting", "January 20, 2019", "Added new hooking script: Aura Reorder. Added a new script for Blink by Time Left."},
			{1548006299, "Settings", "January 20, 2019", "Cast bar now have an offset settings for most of the nameplate types."},
			{1548006299, "Settings", "January 20, 2019", "Added 'No Tank Aggro' color for DPS, which color the namepalte when an unit isn't attacking you or the tank."},
			
			{1547411718, "Scripting", "January 13, 2019", "Added 3 new hooking scripts: Color Automation, Attacking Specific Unit and Execute Range."},
			{1547411718, "Scripting", "January 13, 2019", "Plater.SetBorderColor (unitFrame, 'color') now accept any format of color."},
			
			{1547239726, "Back End Changes", "January 11, 2019", "Plater now uses its own unit frame instead of recycling the Blizzard nameplate frame. This fixes a xit ton of problems and unlock more customizations."},
			{1547239726, "Options Changes", "January 11, 2019", "Removed shadow toggles, added outline mode selection and shadow color selection."},
			{1547239726, "Options Changes", "January 11, 2019", "Personal nameplate now have a cast bar for the player."},
			{1547239726, "Options Changes", "January 11, 2019", "Override colors are now enabled by default and it won't override player class colors."},
			{1547239726, "Options Changes", "January 11, 2019", "Added the following options for target highlight: texture, alpha, size and color."},
			{1547239726, "Options Changes", "January 11, 2019", "Added global offset to slightly adjust the nameplate up and down."},
			
			{1543680969, "Script Changes", "December 1, 2018", "'Added 'Aura Border Color' script (disabled by default)."},
			{1543248430, "Script Changes", "November 26, 2018", "'Fixate on You' Spawn of G'huun triggers only for the mythic raid version of this mob."},
			{1543248430, "Script Changes", "November 26, 2018", "Added script 'Color Change' with the mythic dungeon version of Spawn of G'huun, settings for it on its constructor script."},
			{1543248430, "Script Changes", "November 26, 2018", "Added hook script 'Combo Points' (disabled by default), show combo points for rogue and feral druid."},
			{1543248430, "Script Changes", "November 26, 2018", "Added hook script 'Extra Border' (disabled by default), adds an extra border in the health bar."},
			{1543248430, "Script Changes", "November 26, 2018", "Added hook script 'Reorder Nameplate' (disabled by default), simple reorder for the health and cast bars."},
			
			{1542811859, "Script Changes", "November 21, 2018", "Added hook script 'Players Targeting a Target' (disabled by default), show the amount of players currently targeting a unit."},
			{1542811859, "Level Text", "November 21, 2018", "Fixed level text always showing the level of the unit as 120."},
			
			{1542475895, "Target Shading", "November 17, 2018", "Target Shading won't apply it's effect in the Personal Bar."},
			{1542475895, "Console Variables", "November 17, 2018", "Renamed some options and added several options for CVars in the advanced tab."},
			{1542475895, "Auras", "November 17, 2018", "When using aura grow direction to left or right, auras will grow in a second line if the total size of the icons passes the size of the nameplate."},
			{1542475895, "Scripting", "November 17, 2018", "unitFrame.InExecuteRange is true if the unit is within your character execute range."},
			{1542475895, "Scripting", "November 17, 2018", "unitFrame.IsSelf is true if the nameplate is the Personal Bar."},
			
			{1542475895, "Cast Bar", "November 08, 2018", "Added cast Bar Offset for enemy player and enemy npc."},
			{1541001993, "New Feature: Masque Support", "October 31, 2018", "Buff icons now uses masque skins. A Plater group has been added into /masque options where you can setup or disable them."},
			{1541001993, "New Feature: Hook Scripts", "October 16, 2018", "Added new tab for creating hook scripts. These scripts can run on all nameplates after certain events and should be use to a more deep costumization of nameplates."},
			{1541001993, "New Feature: Import and Export Profile", "October 16, 2018", "Profile tab now has options to export and import profiles."},
			{1541001993, "New Feature: Animations", "October 16, 2018", "Animations for spell can now be edited, added or disabled at the animations tab."},
			{1541001993, "Target Tab", "October 16, 2018", "Targetting optons has been moved to its own tab."},
			{1541001993, "Personal Bar", "October 16, 2018", "Added options to Show health, health amount and health percent."},
			{1541001993, "Health Percent", "October 16, 2018", "All nameplate types got the option to disable percent decimals."},
			{1541001993, "Buff Settings", "October 16, 2018", "Added font option for buff timer and buff stack amount."},
			{1541001993, "Buff Tracking", "October 16, 2018", "Now shows all spells it's tracking when hovering over a spell line."},
			{1541001993, "Buff Special", "October 16, 2018", "Added the option to only track the aura if it has been casted by the player."},
			--{1541001993, "", "October 16, 2018", ""},
		}
	end
	
	return Plater.ChangeLogTable
end
