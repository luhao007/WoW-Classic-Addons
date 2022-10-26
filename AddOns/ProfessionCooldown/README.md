# Profession Cooldown v. 1.18
Profession Cooldown (PCD) tracks the cooldown of profession abilities across the characters on your account. It's fairly simple, and mostly consists of a simple overview.
By default, the addon will only track a given profession cooldown when the ability first goes on cooldown. That means, if one is to create a piece of Spellcloth, the addon will track it. Optionally the player can choose to update on spell id (still in beta, not considered 'stable' yet), enabled from the options frame.
Your profession window has to be open, in order to record active cooldowns. Currently it tracks:

- Leatherworking: Salt shaker.
- Alchemy: All transmutes, Northrend Research
- Jewelcrafting: Brilliant Glass, Icy Prism
- Tailoring: TBC cloths, WotLK cloths, Glacial Bag
- Enchanting: Void Sphere
- Mining: Smelt Titansteel
- Inscription: Minor research, Northrend research

## Commands:

- /pcd - toggles the visibility of the window.
- /pcd filters - opens the filtering menu.
- /pcd reset - resets the position of the window.
- /pcd resetalldata - resets all data for the addon.
- /pcd reset charactername - resets the data for the given charactername. Useful if changing professions or deleting a character.
- /pcd options - opens the options window.
- /pcd update - fetches cooldowns based on spell id. Still in development, and not considered stable.

## Feedback
Please leave any feedback you may have in the comments. You are also welcome to create issues on Github.
It also helps if you can DM me a link to pastebin, with the data from the addon. You can find this in:
WorldOfWarcraft\_classic_\WTF\Account\YourAccountName\SavedVariables\ProfessionCooldown.lua

## To do list: Currently no ETA.
- Data broker / titan panel improvements. (color coding)
- Cross-account sync.
- Alerts / notifications.
