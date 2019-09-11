CensusPlusClassic

This is an interface addon for World of Warcraft: Classic which records details about characters currently online in your faction at the time of the polling. This is done with liberal use of the in-game /who command via the Wholib. The information is then stored in the CensusPlusClassic.lua in your account's SavedVariables folder, which you can be uploaded to the aggregator website [Wow Classic Population](https://wowclassicpopulation). This site sorts all uploaded information and then display it in chart and graph form.

Contribute 

These instructions will explain you how to install the addon and how you can participate in collecting census data.

Prerequisites

Donwload the latest version of the addon: https://github.com/christophrus/CensusPlusClassic/releases/latest/download/CensusPlusClassic.zip

Installing the addon

- Use an unzipping propram like 7zip and extract the CensusPlusClassic folder to your addons directory
- The beta addon directory is usually located here:
-- `C:\Program Files\World of Warcraft\_classic_beta_\Interface\AddOns`
- When you log into the game the CensusPlusClassic addon automatically starts collecting data. You can watch the progress through the minimap icon.
- After the census is taken you get a message in chat how many characters were recorded
- Logout or do a /reload to force the addon to write its data into the *.lua file
- Navigate to `C:\Program Files\World of Warcraft\_classic_beta_\WTF\Account\1234567#1\SavedVariables\` and find the CensusPlusClassic.lua (1234567#1 is a different number for you or your account name)
- Upload the `CensusPlusClassic.lua` on [WowClassicpopulation.com](https://wowclassicpopulation.com/contribute)


