# Prat 3.0

## [3.7.57](https://github.com/sylvanaar/prat-3-0/tree/3.7.57) (2020-05-17)
[Full Changelog](https://github.com/sylvanaar/prat-3-0/compare/3.7.53...3.7.57)

- Merge branch 'master' of github.com:sylvanaar/prat-3-0  
    # Conflicts:  
    #	addon/locales.lua  
    #	modules/ChatFrames.lua  
- Locales: Tweak the first char pattern a little  
- Chatframes: Stop trying to hook multiple times  
- Try to address #53. Update the name matching patterns to bettter support UTF8  
- Reformatted all source files  
- Fix typo for RegisterSmartGroup in OnDisable  
- Stop processing loot messages  
- Merge branch 'master' of github.com:sylvanaar/prat-3-0  
- Revert previous changes affecting editbox fonts, and fix fornt when first setting value  
- Merge pull request #22 from amakinen/blizz-timestamps-taint-fix  
    Hiding default UI timestamps without breaking Communities UI - setfenv solution  
- Merge branch 'master' into blizz-timestamps-taint-fix  
- Remove CF\_MEH hook which taints timestamp  
- Add .editorconfig  
- Support for community channels in sound module  
- Fix the channel list  
    Blizzard changed the ordering of data in the channel list and this was preventing the full list of channels from showing.  
- Disable Blizzard timestamps on Timestamps module init instead of enable  
    Init is called only once and earlier, reducing chance that it is already  
    hooked.  
- Hide Blizzard chat timestamps by using setfenv  
    to redirect the CHAT\_TIMESTAMPS\_FORMAT read instead of modifying and  
    tainting the global.  
    CF\_MEH does not write globals or create functions that do, so __newindex  
    is not strictly necessary, but use it anyway to avoid hard to debug  
    issues if it is ever changed to do so.  
- Revert "Hide Blizzard chat timestamps when using the Timestamps module"  
    While this implementation correctly hid default timestamps in chat and  
    kept them in the Communities UI, tainting CHAT\_TIMESTAMP\_FORMAT breaks  
    other, secure features of the Communities UI and a different solution is  
    needed.  
