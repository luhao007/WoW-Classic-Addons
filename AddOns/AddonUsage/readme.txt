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
