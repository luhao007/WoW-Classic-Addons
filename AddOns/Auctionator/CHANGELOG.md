# Auctionator

## [10.0.26](https://github.com/Auctionator/Auctionator/tree/10.0.26) (2022-12-13)
[Full Changelog](https://github.com/Auctionator/Auctionator/compare/10.0.25...10.0.26) 

- [Fixes #1302] Mainline: Shopping: Reagents tier filter  
- Mainline: Fix nil reference error for unsupported tooltip handlers  
- Mainline: Tooltips: In SetItemKey fix wrong item being identified for the price  
- Mainline: Tooltip: Fix quantity for recipe reagents  
- Mainline: Rework tooltip hooks so that prices are shown when data repopulates  
    Previously when the in-game APIs redid the tooltip without calling  
    another Set.* handler the Auctionator data was removed and left gone  
- Classic: Buy: Use FormatLargeNumber on percentage in warning dialog  
- Classic: Buy: Warning dialog instead of delay when price increases in chain buy  
- Mainline: Tooltips: Show full tooltips on auction house items  
- [Fixes #1301] Mainline: Crafting Info: Error when reagents have no allocations  
