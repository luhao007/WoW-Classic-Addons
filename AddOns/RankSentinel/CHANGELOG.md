# RankSentinel

## [v2.3.1](https://github.com/valkyrnstudios/RankSentinel/tree/v2.3.1) (2022-12-15)
[Full Changelog](https://github.com/valkyrnstudios/RankSentinel/compare/v2.3.0...v2.3.1) [Previous Releases](https://github.com/valkyrnstudios/RankSentinel/releases)

- Minor formatting changes  
- Minor formatting changes  
- Add global string translation back in  
- Optimize InGroupWith lookup  
- Performance pass (CLEU) + some bugfixes (#76)  
    * Add missing embeds  
    * precache unitids to avoid doing concat on every invocation  
    use the appropriate group iterator based on raid/party  
    call re-order to ensure we bail out as quickly as possible for trivial cases  
    * reorder c\_l_e\_u calls to get rid of long logic checks and bail out of trivial paths as quickly as possible  
    refactor IsMaxRank() and .isMaxRank to preserve both returns  
     - fixes a bug where low rank warning would only fire for uncached spells  
     - version update should clearcache and get rid of old/bad data  
    fix a logic bug in HasFullControl usage  
    remove some dead code, cleanup some unintended globals  
    make sure we get a proper 'self' in cleu handler  
- Move CLEU to non-CBH frame  
    fixes #75  
- Add frFR locale (#74)  
    Fixes #73  