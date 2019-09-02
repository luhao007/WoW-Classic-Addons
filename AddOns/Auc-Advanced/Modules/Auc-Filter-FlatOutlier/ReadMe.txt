FlatOutlier
Scan Filter plugin for Auctioneer

FlatOutlier is a rewrite of the old version of the Outlier filter. It may be used alongside the new Outlier to catch some items Outlier misses.

Price Model Selection
* For speed, use faster general price models, such as Stat-StdDev or Stat-Simple
* Avoid using slow complex price models, such as Market or Appraiser

Second Price Model Selection
If a second price model is selected, FlatOutlier will calculate both prices, and use the lower one. If either price model does not return a useful value, FlatOutlier will just use the other.
* Use a second model as a backup for price models that may not return price for all items, such as using Stat-Sales or Enchantrix.

Price Database AddOns
Some price database AddOns can provide prices to Auctioneer (some will need an additional 'patch' plugin for this).
* Using one of these price database AddOns as a price model can help detect outliers while you are still building up scan info on a new server
