This is an addon to compare the memory and CPU usage of your addons.

=== How to Use

To summon or dismiss the window:
* /addonusage
* or set up a key binding in the default key binding interface

A window will list each loaded addon alongside its memory usage, and CPU usage if enabled.
* Column headers across the top can be clicked to sort by that column.
* The total memory and CPU usage will be displayed at the bottom of their respective columns.
* The window can be resized by the grip in the lower right corner.

In the lower left is a "CPU Usage" checkbox. Enabling this will turn on CPU profiling and display CPU times for each addon alongside their memory usage.

Beside the checkbox are three buttons, from left to right:
* Reset: This will clean up memory and reset CPU usage tracking.
* Update: This will update usage information.
* Continuous Update: This acts as a Pause/Play button to automatically update usage every second.

=== Why to Use

If you're thinking of downloading this addon, you're probably trying to optimize your UI so it can run as efficiently as possible or you're experiencing fps loss and suspect an addon may be the cause.

I recommend, for the most part, ignoring the memory usage of addons unless you're on a low-end system. Even garbage memory creation (the memory creep active addons appear to be doing) is not really an issue if it happens slowly. If you watch closely you'll see the addons' memory usage reset back after a while. WoW's Lua implementation does this over time in a low-impact cleanup.

Instead you'll want to focus on the CPU usage of your addons. Everything your addons do, everything, happens between the frames rendered on your screen. The more work your addons are doing, the longer the game waits to render your next frame and your fps drops.

The best way to troubleshoot fps issues is to turn on CPU monitoring and go out and play. You can forget about it until later in the session. Bring up the window and see how they all behaved.

If you're experiencing a noticable fps drop in certain situations, like in one encounter in a raid (which is almost always graphic related and not addon related), or flying around looking at the map, or doing tradeskills, etc, you can hit Reset before you know the fps drop is about to hit. Then look for any abnormally high CPU usage among your addons.

The reason CPU monitoring isn't on by default is because the act of monitoring how much work your addons are doing causes a bit more work that will slow you down even more unless you're on a high end system or have few addons. You should only have CPU monitoring enabled when you're testing.

That said, some things to consider when looking at the numbers:
* The percentages are all relative to each other. If you're spending 80% of your time making bandages, 10% of your time chatting and 10% of your time raiding, expect your tradeskill/inventory addons to share a bulk of the usage. If you notice in this situation a map addon taking up an abnormally huge share of CPU time, then that's something to investigate.
* CPU usage is measured in milliseconds per second. The milliseconds of CPU time that the addon has accumulated divided by how long since CPU usage was last reset, or just after login if there has been no reset.
* CPU usage per addon is taken from the in-game API and does not represent the whole story. It's possible for an addon to get some of its work blamed on another if libraries are involved, or it may get a lot of work to go unnoticed. Use these numbers as a guide only.
* Remember to turn off CPU monitoring when you're done testing!

11/02/2021 version 3.0.10
- toc update for 9.1.5 patch

06/29/2021 version 3.0.9
- Fix for backdrop of control button tooltips
- toc update for 9.1.0 patch

05/18/2021 version 3.0.8
- Update for The Burning Crusade Classic

03/13/2021 version 3.0.7
- toc update for 9.0.5

10/13/2020 version 3.0.6
- toc update for 9.0

08/13/2018 version 3.0.5
- removed debug key binding

07/17/2018 version 3.0.4
- toc update for 8.0

08/29/2017 version 3.0.3
- toc update for 7.3

04/20/2017 version 3.0.2
- Fix for potential divide by zero errors (integer overflow)

03/27/2017 version 3.0.1
- Fixed key binding entry
- toc update for 7.2

01/12/2017 version 3.0.0
- New resizable UI.
- Sort choices persists across sessions.
- CPU time is now displayed (as milliseconds per second).
- The "Realtime updates" checkbox is now a Play/Pause toggle button at the bottom of the window.
- Support for addons that are named a number.
- The login usage is no longer recorded; tracking begins very soon after the game starts to render.
- The sorted list has its name as a secondary sort to produce more "stable" lists.

10/24/2016 version 2.0.10
- toc update for 7.1

07/16/2016 version 2.0.9
- toc update for 7.0

06/22/2015 version 2.0.8
- toc update for 6.2

02/24/2015 version 2.0.7
- toc update for 6.1

11/05/2014 version 2.0.6
- Fix for load-on-demand addons not showing up.
- Fix for lua error when turning off real-time updates.

10/11/2014 version 2.0.5
- Total memory/CPU usage summary added.

10/02/2014 version 2.0.4
- Mouseover of long addon names will show the whole addon name.

09/14/2014 version 2.0.3
- Update for Warlords of Draenor.
- Fix for WoD-specific bug where CPU profiling wouldn't enable.

10/25/2014 version 2.0.1
- Rewrite/facelift.
- Added realtime CPU monitoring option.

09/11/2013 version 1.14
- toc update for 5.4

05/21/2013 version 1.13
- toc update for 5.3

08/28/2012 version 1.12
- Fixed underscore (_) tainting.

08/28/2012 version 1.11
- Update for Mists of Pandaria.

04/10/2009 version 1.1
- Fix for scrollbar change.

07/14/2008 version 1.0
- Initial release.