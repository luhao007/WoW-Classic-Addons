# Prat 3.0

## [3.8.8](https://github.com/sylvanaar/prat-3-0/tree/3.8.8) (2020-06-04)
[Full Changelog](https://github.com/sylvanaar/prat-3-0/compare/3.8.7...3.8.8)

- Core: Ensure that the options panel is updated after profile loading  
- Core: Try to put the modules in to the correct state after a profile load  
- Merge pull request #86 from sylvanaar/users/sylvanaar/memory-module  
    New Module: Memory - sync all the chat settings across your account.  
- Memory: Iterate over the standard 10 frames every time  
- Memory: Fix issues with profile switching  
- Memory: Finish the localizations  
- Memory: Fix issue restoring the shown state  
- Memory: Revise the default settings  
- Memory: Remove the commented out earlier implementation  
- Core: Revise the EVENT\_ID solution to user the Line ID instead  
- Memory: Revised implementation that seems more in line with the default UI  
- Scrollback: Do not save the buffer for temporary chatframes  
- Memory: Temporary UI in the options for loading/saving  
- Core: Allow additonal Print() lines to be re-routed to a debug frame  
- Memory: Clear our message and channel subscriptions before restoring  
- Memory: Remember the frame positions  
- Memory: Fix color restoration  
- Memory: Working prototype  
- Memory: Create a module to save all your chat settings to your profiel to sync accross characters  
- Playernames: Support for showing the BNet client icon  
- Core: Updated BNet support for classic to support restoring names in from history  
- Core: Remove Prat's implementation of Event ID in favor of using Blizzard's  
- Scrollback: Support proper saving and restoration of BNet names  
