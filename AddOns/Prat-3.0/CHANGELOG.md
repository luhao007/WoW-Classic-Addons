# Prat 3.0

## [3.8.26](https://github.com/sylvanaar/prat-3-0/tree/3.8.26) (2020-07-08)
[Full Changelog](https://github.com/sylvanaar/prat-3-0/compare/3.8.25...3.8.26) 

- Memory: Fix spelling error  
- Memory: Smarter channel leaving behavior - only leave channels that are incorrect.  Prevents most instances of #114  
- Core: Better implementation of IsrRetail  
- Core: Trim whitespaces from all chat messages  
- Filtering: Change AI filtering from blacklist to whitelist. Improve feedback messges  
- Filtering: Improve the training UI a bilt by re-scoring the line after clicking the ++  or -- links  
- Filtering: Do not allow the API to filter our the player's own messages  
- Scrollback: Handle nil battletag case #107  
- Customfilters: Remove tristate options- too confusing  
- Customfilters: Another implementation of the option to apply a filter to specific channels #101  
- Revert "Revert "CustomFilters: Support filtering by channel #101""  
- Filtering: Support for ignoring certain chat types from AI filtering  
