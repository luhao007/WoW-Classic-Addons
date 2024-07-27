## Support me
<a href="https://www.paypal.com/donate/?hosted_button_id=NYWTBA4XM6ZS6" alt="Paypal">
  <img src="https://www.paypalobjects.com/en_US/BE/i/btn/btn_donateCC_LG.gif" />
</a>
<a href="https://www.patreon.com/Krowi" alt="Patreon">
  <img src="https://raw.githubusercontent.com/codebard/patron-button-and-widgets-by-codebard/master/images/become_a_patron_button.png" />
</a>
<a href='https://ko-fi.com/E1E6G64LS' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi2.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

## Locations
<a href="https://www.curseforge.com/wow/addons/krowi-achievement-filter" alt="Curseforge">
  <img src="https://img.shields.io/badge/Curseforge-Krowi's%20Achievement%20Filter-orange" />
</a>
<br>
<a href="https://addons.wago.io/addons/krowi-achievement-filter" alt="Wago.io">
  <img src="https://img.shields.io/badge/Wago.io-Krowi's%20Achievement%20Filter-red" />
</a>
<br>
<a href="https://www.wowinterface.com/downloads/info26229-KrowisAchievementFilter" alt="WowInterface">
  <img src="https://img.shields.io/badge/WowInterface-Krowi's%20Achievement%20Filter-yellow" />
</a>

[Click here for full description](Descriptions/Wago.io.md)

# Existing data
Existing data is tracked in this ticket: https://github.com/TheKrowi/Krowi_AchievementFilter_TooltipData/issues/1

# Contribute data
Contributing data is very welcome as maintaining this data and keeping it up to date is a timeconsuming task.

## Workflow
I initiall assume you know how to work with git. The preffered way of contributing is creating a branch and committing pull requests with your data which will be approved by me. More details on how github works will be added later.

## Where to add data
In the `Data` folder you find 3 sub-folders and 2 files.
One of the files (that you will also find in the 3 sub-folders) is `Files.xml`. This one tells WoW which files to load.
The other file is `Shared.lua` and contains "shared" resources multiple other files need without having to repeat yourself.

The 3 sub-folders contain the data for each build of WoW.
- 00_Mainline = Dragonflight (The War Within later)
- 03_WrathClassic = Wrath Classic
- 04_CataClassic = Cata Classic

In each sub-folder there are multiple files per expansion. Data is added to the expansion file when it was added, not which expansion content they apply to.
Example: if an achievement was added in Wrath of the Lich King, tooltip data should be added to `03_Wrath.lua`

## Functions
There are 2 ways to add data with either the `datum` or `data` functions.

### Single criteria addition
The `datum` function is generally used when an achievement has a single criteria that needs to be added to a tooltip. It can also be used for each criteria individually but not preferred.
```lua
{datum, 17899, 0, type.Unit, 190326}, -- Flashfrost Flyover Challenge: Gold
```

#### Format
The function can be split up in multiple parts. The earlier examples will be used.
```lua
{datum, ACHIEVEMENT ID, ACHIEVEMENT CRITERIA INDEX, OBJECT TYPE, OBJECT ID, FACTION}, -- ACHIEVEMENT NAME
```

- **datum** : required, function that will be called in KAF
- **ACHIEVEMENT ID** : the achievement id
- **ACHIEVEMENT CRITERIA INDEX** : the achievement criteria index; 0 if the achievement has no criteria
- **OBJECT TYPE** : the id of the type of the object that will show the tooltip
- **OBJECT ID** : the id of the object that will show the tooltip
- **FACTION** : optional, the faction if the criteria is faction specific
- **ACHIEVEMENT NAME** : the name of the achievement

### Multiple criteria addition
The `data` function is used when an achievement has multiple criteria that need to be added to a tooltip.
```lua
{ -- Zaralek Cavern Basic / Advanced / Reverse
    data, {17483, 17484, 17485, 17486, 17487, 17488, 17489, 17490, 17491}, type.Unit,
    {
        {1, 202524}, -- Crystal Circuit
        {2, 202676}, -- Caldera Cruise
        {3, 202749}, -- Brimstone Scramble
        {4, 202772}, -- Shimmering Slalom
        {5, 202795}, -- Loamm Roamm
        {6, 202973}, -- Sulfur Sprint
    }
},
```

#### Format
The `data` function is a little bit more complex because of its flexibility. The function will default to this one if no function is defined. See the examples.
```lua
{ -- ACHIEVEMENT NAME
    data, ACHIEVEMENT ID,
    {
        {ACHIEVEMENT CRITERIA INDEX, {OBJECT ID1, OBJECT ID2, ...}, OBJECT TYPE, FACTION}, -- ACHIEVEMENT CRITERIA NAME
        {ACHIEVEMENT CRITERIA INDEX, OBJECT ID, OBJECT TYPE, FACTION}, -- ACHIEVEMENT CRITERIA NAME
        ...
    }
},
{ -- ACHIEVEMENT NAME
    {ACHIEVEMENT ID1, ACHIEVEMENT ID2, ...},
    {
        ObjectType = OBJECT TYPE,
        Faction = FACTION
    },
    {
        {ACHIEVEMENT CRITERIA INDEX, {OBJECT ID1, OBJECT ID2, ...}}, -- ACHIEVEMENT CRITERIA NAME
        {ACHIEVEMENT CRITERIA INDEX, OBJECT ID}, -- ACHIEVEMENT CRITERIA NAME
        ...
    }
},
{ -- ACHIEVEMENT NAME
    ACHIEVEMENT ID, OBJECT TYPE
    {
        {ACHIEVEMENT CRITERIA INDEX, {OBJECT ID1, OBJECT ID2, ...}}, -- ACHIEVEMENT CRITERIA NAME
        {ACHIEVEMENT CRITERIA INDEX, OBJECT ID}, -- ACHIEVEMENT CRITERIA NAME
        ...
    }
},
```

- **data** : optional, function that will be called in KAF, defaults to it if not defined
- **ACHIEVEMENT IDn** : the achievement id
- **ACHIEVEMENT CRITERIA INDEX** : the achievement criteria index; 0 if the achievement has no criteria
- **OBJECT TYPE** : the id of the type of the object that will show the tooltip
- **OBJECT ID** : the id of the object that will show the tooltip
- **FACTION** : optional, the faction if the criteria is faction specific
- **ACHIEVEMENT NAME** : the name of the achievement
- **ACHIEVEMENT CRITERIA NAME** : the name of the achievement criteria

A little bit more explanation.
- `ACHIEVEMENT ID`, a single achievement or `{ACHIEVEMENT ID1, ACHIEVEMENT ID2, ...}` multiple achievements that use the same data. One of these has to be defined, not both.
- From the 3rd element in the list on, the data becomes dynamic to reduce duplication but increases complexity. The 3rd element is either empty, skipped as seen in example 1, a list of data as seen in example 2 or the `OBJECT TYPE` as seen in example 3. When the 3rd element is a list of data, both the OBJECT TYPE and FACTION are defined there.
- The last element is always the list of achievement criteria. The order of elements per criteria is fixed but OBJECT TYPE and FACTION are optional here depending if either are defined in element 3 or just not required.

The best way to make yourself familiar with the format is to look at existing examples in the `data` sub-folders.

### Getting Object Type Id and Object Id
Enable debug mode in KAF, this will display npc data and item ids.

If the achievement is linked to an npc, check the long additional string in the npc's tooltip, this is the npc's GUID.
This is the format: [unitType]-0-[serverID]-[instanceID]-[zoneUID]-[ID]-[spawnUID]
If unitType is "Creature" or "Vehicle", the Object Type = type.Unit.
The Object Id is the ID.

If the text is not "Creature" or "Vehicle", please contact someone in https://discord.com/channels/805554495253643315/1150294582991523901

If the achievement is linked to an item, check the additional number in the item's tooltip, this is the Object Id.
In this case the Object Type Id = type.Item.