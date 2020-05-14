-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Locale = TSM.Init("Locale")
local L = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Locale.GetTable()
	return L
end



-- ============================================================================
-- Locale Table
-- ============================================================================

do
	local locale = GetLocale()
	if locale == "enUS" or locale == "enGB" then
		L["%d Groups"] = "%d Groups"
		L["%d Items"] = "%d Items"
		L["%d Operations"] = "%d Operations"
		L["%d Posted Auctions"] = "%d Posted Auctions"
		L["%d Sold Auctions"] = "%d Sold Auctions"
		L["%d auctions"] = "%d auctions"
		L["%d of %d"] = "%d of %d"
		L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group:Groups; Selected (%d |4Item:Items;)"
		L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s bags, %s bank, %s AH, %s mail)"
		L["%s (%s player, %s alts, %s AH)"] = "%s (%s player, %s alts, %s AH)"
		L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s player, %s alts, %s guild, %s AH)"
		L["%s (%s profit)"] = "%s (%s profit)"
		L["%s Crafts"] = "%s Crafts"
		L["%s Operations"] = "%s Operations"
		L["%s ago"] = "%s ago"
		L["%s group is already up to date."] = "%s group is already up to date."
		L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
		L["%s in guild vault"] = "%s in guild vault"
		L["%s is a valid custom price but %s is an invalid item."] = "%s is a valid custom price but %s is an invalid item."
		L["%s is a valid custom price but did not give a value for %s."] = "%s is a valid custom price but did not give a value for %s."
		L["%s is not a valid custom price and gave the following error: %s"] = "%s is not a valid custom price and gave the following error: %s"
		L["%s operation"] = "%s operation"
		L["%s operations"] = "%s operations"
		L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
		L["%s removed."] = "%s removed."
		L["%s sent you %s"] = "%s sent you %s"
		L["%s sent you %s and %s"] = "%s sent you %s and %s"
		L["%s sent you a COD of %s for %s"] = "%s sent you a COD of %s for %s"
		L["%s sent you a message: %s"] = "%s sent you a message: %s"
		L["%s total"] = "%s total"
		L["%sDrag%s to move this button"] = "%sDrag%s to move this button"
		L["%sLeft-Click%s to open the main window"] = "%sLeft-Click%s to open the main window"
		L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."
		L["(%d/500 Characters)"] = "(%d/500 Characters)"
		L["(max %d)"] = "(max %d)"
		L["(max 5000)"] = "(max 5000)"
		L["(min %d - max %d)"] = "(min %d - max %d)"
		L["(min 0 - max 10000)"] = "(min 0 - max 10000)"
		L["(minimum 0 - maximum 20)"] = "(minimum 0 - maximum 20)"
		L["(minimum 0 - maximum 2000)"] = "(minimum 0 - maximum 2000)"
		L["(minimum 0 - maximum 905)"] = "(minimum 0 - maximum 905)"
		L["(minimum 0.5 - maximum 10)"] = "(minimum 0.5 - maximum 10)"
		L["1 Group"] = "1 Group"
		L["1 Item"] = "1 Item"
		L["12 hr"] = "12 hr"
		L["2 hr"] = "2 hr"
		L["24 hr"] = "24 hr"
		L["48 hr"] = "48 hr"
		L["8 hr"] = "8 hr"
		L["A custom price of %s for %s evaluates to %s."] = "A custom price of %s for %s evaluates to %s."
		L["A maximum of 1 convert() function is allowed."] = "A maximum of 1 convert() function is allowed."
		L["A profile with that name already exists on the target account. Rename it first and try again."] = "A profile with that name already exists on the target account. Rename it first and try again."
		L["A profile with this name already exists."] = "A profile with this name already exists."
		L["A scan is already in progress. Please stop that scan before starting another one."] = "A scan is already in progress. Please stop that scan before starting another one."
		L["ADD %d ITEMS"] = "ADD %d ITEMS"
		L["ADD NEW CUSTOM PRICE SOURCE"] = "ADD NEW CUSTOM PRICE SOURCE"
		L["ADD OPERATION"] = "ADD OPERATION"
		L["ADD TO MAIL"] = "ADD TO MAIL"
		L["AH"] = "AH"
		L["AH (Crafting)"] = "AH (Crafting)"
		L["AH (Disenchanting)"] = "AH (Disenchanting)"
		L["AH BUSY"] = "AH BUSY"
		L["AH Frame Options"] = "AH Frame Options"
		L["AHDB Minimum Bid"] = "AHDB Minimum Bid"
		L["AHDB Minimum Buyout"] = "AHDB Minimum Buyout"
		L["AMOUNT"] = "AMOUNT"
		L["APPLY FILTERS"] = "APPLY FILTERS"
		L["AUCTION DETAILS"] = "AUCTION DETAILS"
		L["Above max expires."] = "Above max expires."
		L["Above max price. Not posting."] = "Above max price. Not posting."
		L["Above max price. Posting at max."] = "Above max price. Posting at max."
		L["Above max price. Posting at min."] = "Above max price. Posting at min."
		L["Above max price. Posting at normal."] = "Above max price. Posting at normal."
		L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
		L["Accepting this item will cost"] = "Accepting this item will cost"
		L["Account Syncing"] = "Account Syncing"
		L["Account sync removed. Please delete the account sync from the other account as well."] = "Account sync removed. Please delete the account sync from the other account as well."
		L["Accounting"] = "Accounting"
		L["Accounting Tooltips"] = "Accounting Tooltips"
		L["Activity Type"] = "Activity Type"
		L["Add / Remove Items"] = "Add / Remove Items"
		L["Add Player"] = "Add Player"
		L["Add Subject / Description"] = "Add Subject / Description"
		L["Add Subject / Description (Optional)"] = "Add Subject / Description (Optional)"
		L["Added %s to %s."] = "Added %s to %s."
		L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
		L["Additional error suppressed"] = "Additional error suppressed"
		L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Adjust the settings below to set how groups attached to this operation will be auctioned."
		L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
		L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
		L["Advanced Item Search"] = "Advanced Item Search"
		L["Advanced Options"] = "Advanced Options"
		L["Alarm Clock"] = "Alarm Clock"
		L["All Auctions"] = "All Auctions"
		L["All Characters and Guilds"] = "All Characters and Guilds"
		L["All Item Classes"] = "All Item Classes"
		L["All Professions"] = "All Professions"
		L["All Subclasses"] = "All Subclasses"
		L["Allow partial stack?"] = "Allow partial stack?"
		L["Allows for testing of custom prices"] = "Allows for testing of custom prices"
		L["Alt Guild Bank"] = "Alt Guild Bank"
		L["Alts"] = "Alts"
		L["Alts AH"] = "Alts AH"
		L["Amount"] = "Amount"
		L["Amount of Bag Space to Keep Free"] = "Amount of Bag Space to Keep Free"
		L["An old TSM addon was found installed. Please remove %s and any other old TSM addons to avoid issues."] = "An old TSM addon was found installed. Please remove %s and any other old TSM addons to avoid issues."
		L["Apply operation to group:"] = "Apply operation to group:"
		L["Are you sure you want to clear old accounting data?"] = "Are you sure you want to clear old accounting data?"
		L["Are you sure you want to delete this group?"] = "Are you sure you want to delete this group?"
		L["Are you sure you want to delete this operation?"] = "Are you sure you want to delete this operation?"
		L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
		L["At above max price and not undercut."] = "At above max price and not undercut."
		L["At normal price and not undercut."] = "At normal price and not undercut."
		L["Auction"] = "Auction"
		L["Auction Bid"] = "Auction Bid"
		L["Auction Buyout"] = "Auction Buyout"
		L["Auction Duration"] = "Auction Duration"
		L["Auction House Cut"] = "Auction House Cut"
		L["Auction Sale Sound"] = "Auction Sale Sound"
		L["Auction Window Close"] = "Auction Window Close"
		L["Auction Window Open"] = "Auction Window Open"
		L["Auction has been bid on."] = "Auction has been bid on."
		L["AuctionDB - Historical Price (via TSM App)"] = "AuctionDB - Historical Price (via TSM App)"
		L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
		L["AuctionDB - Minimum Buyout"] = "AuctionDB - Minimum Buyout"
		L["AuctionDB - Region Historical Price (via TSM App)"] = "AuctionDB - Region Historical Price (via TSM App)"
		L["AuctionDB - Region Market Value Average (via TSM App)"] = "AuctionDB - Region Market Value Average (via TSM App)"
		L["AuctionDB - Region Minimum Buyout Average (via TSM App)"] = "AuctionDB - Region Minimum Buyout Average (via TSM App)"
		L["AuctionDB - Region Sale Average (via TSM App)"] = "AuctionDB - Region Sale Average (via TSM App)"
		L["AuctionDB - Region Sale Rate (via TSM App)"] = "AuctionDB - Region Sale Rate (via TSM App)"
		L["AuctionDB - Region Sold Per Day (via TSM App)"] = "AuctionDB - Region Sold Per Day (via TSM App)"
		L["Auctionator - Auction Value"] = "Auctionator - Auction Value"
		L["Auctioneer - Appraiser"] = "Auctioneer - Appraiser"
		L["Auctioneer - Market Value"] = "Auctioneer - Market Value"
		L["Auctioneer - Minimum Buyout"] = "Auctioneer - Minimum Buyout"
		L["Auctioning"] = "Auctioning"
		L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
		L["Auctioning Log"] = "Auctioning Log"
		L["Auctioning Operation"] = "Auctioning Operation"
		L["Auctioning Tooltips"] = "Auctioning Tooltips"
		L["Auctions"] = "Auctions"
		L["Auto Quest Complete"] = "Auto Quest Complete"
		L["Average Earned Per Day:"] = "Average Earned Per Day:"
		L["Average Prices:"] = "Average Prices:"
		L["Average Profit Per Day:"] = "Average Profit Per Day:"
		L["Average Spent Per Day:"] = "Average Spent Per Day:"
		L["Avg Buy Price"] = "Avg Buy Price"
		L["Avg Resale Profit"] = "Avg Resale Profit"
		L["Avg Sell Price"] = "Avg Sell Price"
		L["BACK"] = "BACK"
		L["BACK TO LIST"] = "BACK TO LIST"
		L["BBG 14-Day Price"] = "BBG 14-Day Price"
		L["BBG 3-Day Price"] = "BBG 3-Day Price"
		L["BBG Global Mean"] = "BBG Global Mean"
		L["BBG Global Median"] = "BBG Global Median"
		L["BID"] = "BID"
		L["BUSY"] = "BUSY"
		L["BUY"] = "BUY"
		L["BUY GROUPS"] = "BUY GROUPS"
		L["BUYBACK ALL"] = "BUYBACK ALL"
		L["BUYOUT"] = "BUYOUT"
		L["BUYS"] = "BUYS"
		L["Back to List"] = "Back to List"
		L["Bag"] = "Bag"
		L["Bags"] = "Bags"
		L["Banks"] = "Banks"
		L["Base Group"] = "Base Group"
		L["Base Item"] = "Base Item"
		L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."
		L["Below custom price:"] = "Below custom price:"
		L["Below min price. Posting at max."] = "Below min price. Posting at max."
		L["Below min price. Posting at min."] = "Below min price. Posting at min."
		L["Below min price. Posting at normal."] = "Below min price. Posting at normal."
		L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
		L["Bid %d / %d"] = "Bid %d / %d"
		L["Bid (item)"] = "Bid (item)"
		L["Bid (stack)"] = "Bid (stack)"
		L["Bid Price"] = "Bid Price"
		L["Bid Sniper Paused"] = "Bid Sniper Paused"
		L["Bid Sniper Running"] = "Bid Sniper Running"
		L["Bidding Auction"] = "Bidding Auction"
		L["Blacklisted players:"] = "Blacklisted players:"
		L["Bought"] = "Bought"
		L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
		L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
		L["Bound Actions"] = "Bound Actions"
		L["Buy"] = "Buy"
		L["Buy %d / %d"] = "Buy %d / %d"
		L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
		L["Buy Options"] = "Buy Options"
		L["Buy from AH"] = "Buy from AH"
		L["Buy from Vendor"] = "Buy from Vendor"
		L["Buyer/Seller"] = "Buyer/Seller"
		L["Buyout (item)"] = "Buyout (item)"
		L["Buyout (stack)"] = "Buyout (stack)"
		L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
		L["Buyout Price"] = "Buyout Price"
		L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
		L["Buyout Sniper Running"] = "Buyout Sniper Running"
		L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
		L["CANCELS"] = "CANCELS"
		L["CHARACTER"] = "CHARACTER"
		L["CLEAR DATA"] = "CLEAR DATA"
		L["COD"] = "COD"
		L["CONTACTS"] = "CONTACTS"
		L["CRAFT"] = "CRAFT"
		L["CRAFT ALL"] = "CRAFT ALL"
		L["CRAFT NEXT"] = "CRAFT NEXT"
		L["CRAFTER"] = "CRAFTER"
		L["CRAFTING"] = "CRAFTING"
		L["CREATE MACRO"] = "CREATE MACRO"
		L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
		L["CURRENT SEARCH"] = "CURRENT SEARCH"
		L["CUSTOM POST"] = "CUSTOM POST"
		L["Can't load TSM tooltip while in combat"] = "Can't load TSM tooltip while in combat"
		L["Cancel Scan"] = "Cancel Scan"
		L["Cancel auctions with bids"] = "Cancel auctions with bids"
		L["Cancel to repost higher?"] = "Cancel to repost higher?"
		L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
		L["Canceling"] = "Canceling"
		L["Canceling %d / %d"] = "Canceling %d / %d"
		L["Canceling %d Auctions..."] = "Canceling %d Auctions..."
		L["Canceling Settings"] = "Canceling Settings"
		L["Canceling auction you've undercut."] = "Canceling auction you've undercut."
		L["Canceling disabled."] = "Canceling disabled."
		L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
		L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
		L["Canceling to repost higher."] = "Canceling to repost higher."
		L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
		L["Canceling undercut auctions."] = "Canceling undercut auctions."
		L["Cancelled"] = "Cancelled"
		L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
		L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
		L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
		L["Cash Register"] = "Cash Register"
		L["Changes to the specified profile (i.e. '/tsm profile Default' changes to the 'Default' profile)"] = "Changes to the specified profile (i.e. '/tsm profile Default' changes to the 'Default' profile)"
		L["Character"] = "Character"
		L["Chat Tab"] = "Chat Tab"
		L["Cheapest auction below min price."] = "Cheapest auction below min price."
		L["Clear"] = "Clear"
		L["Clear All"] = "Clear All"
		L["Clear Filters"] = "Clear Filters"
		L["Clear Old Data"] = "Clear Old Data"
		L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
		L["Clear Queue"] = "Clear Queue"
		L["Clear Selection"] = "Clear Selection"
		L["Coins (%s)"] = "Coins (%s)"
		L["Collapse All Groups"] = "Collapse All Groups"
		L["Combine Partial Stacks"] = "Combine Partial Stacks"
		L["Combining..."] = "Combining..."
		L["Completed full AH scan (%d auctions)!"] = "Completed full AH scan (%d auctions)!"
		L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
		L["Confirm"] = "Confirm"
		L["Confirm Complete Sound"] = "Confirm Complete Sound"
		L["Confirming %d / %d"] = "Confirming %d / %d"
		L["Connected to %s"] = "Connected to %s"
		L["Connecting to %s"] = "Connecting to %s"
		L["Contacts Menu"] = "Contacts Menu"
		L["Cooldown"] = "Cooldown"
		L["Cooldowns"] = "Cooldowns"
		L["Cost"] = "Cost"
		L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
		L["Could not find profile '%s'. Possible profiles: '%s'"] = "Could not find profile '%s'. Possible profiles: '%s'"
		L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
		L["Craft"] = "Craft"
		L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
		L["Craft (When Profitable)"] = "Craft (When Profitable)"
		L["Craft All"] = "Craft All"
		L["Craft Name"] = "Craft Name"
		L["Craft value method:"] = "Craft value method:"
		L["Crafting"] = "Crafting"
		L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
		L["Crafting Cost"] = "Crafting Cost"
		L["Crafting Material Cost"] = "Crafting Material Cost"
		L["Crafting Queue"] = "Crafting Queue"
		L["Crafting Tooltips"] = "Crafting Tooltips"
		L["Crafts"] = "Crafts"
		L["Crafts %d"] = "Crafts %d"
		L["Create New Operation"] = "Create New Operation"
		L["Create Profession Group"] = "Create Profession Group"
		L["Current Profiles"] = "Current Profiles"
		L["Custom Price"] = "Custom Price"
		L["Custom Price Source"] = "Custom Price Source"
		L["Custom Sources"] = "Custom Sources"
		L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
		L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
		L["DOWN"] = "DOWN"
		L["Database Sources"] = "Database Sources"
		L["Default Craft Value Method:"] = "Default Craft Value Method:"
		L["Default Material Cost Method:"] = "Default Material Cost Method:"
		L["Default Price"] = "Default Price"
		L["Default Price Configuration"] = "Default Price Configuration"
		L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
		L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
		L["Delete this record?"] = "Delete this record?"
		L["Deposit"] = "Deposit"
		L["Deposit Cost"] = "Deposit Cost"
		L["Deposit Price"] = "Deposit Price"
		L["Deselect All Groups"] = "Deselect All Groups"
		L["Deselect All Items"] = "Deselect All Items"
		L["Destroy Next"] = "Destroy Next"
		L["Destroy Value"] = "Destroy Value"
		L["Destroy Value Source"] = "Destroy Value Source"
		L["Destroying"] = "Destroying"
		L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
		L["Destroying Tooltips"] = "Destroying Tooltips"
		L["Destroying..."] = "Destroying..."
		L["Details"] = "Details"
		L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
		L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
		L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
		L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
		L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
		L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
		L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
		L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
		L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
		L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
		L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
		L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
		L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
		L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
		L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
		L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
		L["Disable invalid price warnings"] = "Disable invalid price warnings"
		L["Disenchant Search"] = "Disenchant Search"
		L["Disenchant Search Options"] = "Disenchant Search Options"
		L["Disenchant Value"] = "Disenchant Value"
		L["Disenchanting Options"] = "Disenchanting Options"
		L["Display Operation Names"] = "Display Operation Names"
		L["Display auctioning values"] = "Display auctioning values"
		L["Display cancelled since last sale"] = "Display cancelled since last sale"
		L["Display crafting cost"] = "Display crafting cost"
		L["Display detailed destroy info"] = "Display detailed destroy info"
		L["Display disenchant value"] = "Display disenchant value"
		L["Display expired auctions"] = "Display expired auctions"
		L["Display group name"] = "Display group name"
		L["Display historical price"] = "Display historical price"
		L["Display market value"] = "Display market value"
		L["Display mill value"] = "Display mill value"
		L["Display min buyout"] = "Display min buyout"
		L["Display prospect value"] = "Display prospect value"
		L["Display purchase info"] = "Display purchase info"
		L["Display region historical price"] = "Display region historical price"
		L["Display region market value avg"] = "Display region market value avg"
		L["Display region min buyout avg"] = "Display region min buyout avg"
		L["Display region sale avg"] = "Display region sale avg"
		L["Display region sale rate"] = "Display region sale rate"
		L["Display region sold per day"] = "Display region sold per day"
		L["Display sale info"] = "Display sale info"
		L["Display sale rate"] = "Display sale rate"
		L["Display shopping max price"] = "Display shopping max price"
		L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
		L["Display transform value"] = "Display transform value"
		L["Display vendor buy price"] = "Display vendor buy price"
		L["Display vendor sell price"] = "Display vendor sell price"
		L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
		L["Don't Post Items"] = "Don't Post Items"
		L["Don't post after this many expires:"] = "Don't post after this many expires:"
		L["Don't prompt to record trades"] = "Don't prompt to record trades"
		L["Done Canceling"] = "Done Canceling"
		L["Done Posting"] = "Done Posting"
		L["Done Scanning"] = "Done Scanning"
		L["Done rebuilding item cache."] = "Done rebuilding item cache."
		L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
		L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
		L["Duplicate"] = "Duplicate"
		L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
		L["EMPTY BAGS"] = "EMPTY BAGS"
		L["ENCHANT"] = "ENCHANT"
		L["ERROR: A full AH scan has recently been performed and is on cooldown. Log out to reset this cooldown."] = "ERROR: A full AH scan has recently been performed and is on cooldown. Log out to reset this cooldown."
		L["ERROR: The AH is currently busy with another scan. Please try again once that scan has completed."] = "ERROR: The AH is currently busy with another scan. Please try again once that scan has completed."
		L["ERROR: The auction house must be open in order to do a scan."] = "ERROR: The auction house must be open in order to do a scan."
		L["EXPENSES"] = "EXPENSES"
		L["EXPIRES"] = "EXPIRES"
		L["Elevate your gold-making!"] = "Elevate your gold-making!"
		L["Embed TSM tooltips"] = "Embed TSM tooltips"
		L["Empty parentheses are not allowed"] = "Empty parentheses are not allowed"
		L["Empty price string."] = "Empty price string."
		L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
		L["Enable automatic stack combination"] = "Enable automatic stack combination"
		L["Enable buying?"] = "Enable buying?"
		L["Enable inbox chat messages"] = "Enable inbox chat messages"
		L["Enable restock?"] = "Enable restock?"
		L["Enable selling?"] = "Enable selling?"
		L["Enable sending chat messages"] = "Enable sending chat messages"
		L["Enchant Vellum"] = "Enchant Vellum"
		L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
		L["Enter Filter"] = "Enter Filter"
		L["Enter Keyword"] = "Enter Keyword"
		L["Enter a name for the new profile"] = "Enter a name for the new profile"
		L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
		L["Enter player name"] = "Enter player name"
		L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establishing connection to %s. Make sure that you've entered this character's name on the other account."
		L["Estimated Cost:"] = "Estimated Cost:"
		L["Estimated Profit:"] = "Estimated Profit:"
		L["Estimated deliver time"] = "Estimated deliver time"
		L["Exact Match Only?"] = "Exact Match Only?"
		L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
		L["Expand All Groups"] = "Expand All Groups"
		L["Expenses"] = "Expenses"
		L["Expirations"] = "Expirations"
		L["Expired"] = "Expired"
		L["Expired Auctions"] = "Expired Auctions"
		L["Expired Since Last Sale"] = "Expired Since Last Sale"
		L["Expires"] = "Expires"
		L["Expires Since Last Sale"] = "Expires Since Last Sale"
		L["Expiring Mails"] = "Expiring Mails"
		L["Exploration"] = "Exploration"
		L["Export"] = "Export"
		L["Export List"] = "Export List"
		L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
		L["Failed Auctions"] = "Failed Auctions"
		L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
		L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
		L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
		L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
		L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
		L["Failed to cancel auction due to the auction house being busy. Ensure no other addons are scanning the AH and try again."] = "Failed to cancel auction due to the auction house being busy. Ensure no other addons are scanning the AH and try again."
		L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
		L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
		L["Failed to send profile."] = "Failed to send profile."
		L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
		L["Favorite Scans"] = "Favorite Scans"
		L["Favorite Searches"] = "Favorite Searches"
		L["Filter Auctions by Duration"] = "Filter Auctions by Duration"
		L["Filter Auctions by Keyword"] = "Filter Auctions by Keyword"
		L["Filter Items"] = "Filter Items"
		L["Filter Shopping"] = "Filter Shopping"
		L["Filter by Keyword"] = "Filter by Keyword"
		L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
		L["Finding Selected Auction"] = "Finding Selected Auction"
		L["Fishing Reel In"] = "Fishing Reel In"
		L["Forget Character"] = "Forget Character"
		L["Found auction sound"] = "Found auction sound"
		L["Friends"] = "Friends"
		L["From"] = "From"
		L["Full"] = "Full"
		L["GOLD ON HAND"] = "GOLD ON HAND"
		L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
		L["GVault"] = "GVault"
		L["Garrison"] = "Garrison"
		L["Gathering"] = "Gathering"
		L["Gathering Search"] = "Gathering Search"
		L["General Options"] = "General Options"
		L["Get from Bank"] = "Get from Bank"
		L["Get from Guild Bank"] = "Get from Guild Bank"
		L["Gets items from the bank or guild bank matching the item or partial text entered."] = "Gets items from the bank or guild bank matching the item or partial text entered."
		L["Global Operation Confirmation"] = "Global Operation Confirmation"
		L["Gold"] = "Gold"
		L["Gold Earned:"] = "Gold Earned:"
		L["Gold Spent:"] = "Gold Spent:"
		L["Great Deals Search"] = "Great Deals Search"
		L["Group Management"] = "Group Management"
		L["Group Operations"] = "Group Operations"
		L["Group Settings"] = "Group Settings"
		L["Group already exists."] = "Group already exists."
		L["Grouped Items"] = "Grouped Items"
		L["Groups"] = "Groups"
		L["Guild"] = "Guild"
		L["Guild Bank"] = "Guild Bank"
		L["Have"] = "Have"
		L["Have Materials"] = "Have Materials"
		L["Have Skill Up"] = "Have Skill Up"
		L["Hide Description"] = "Hide Description"
		L["Hide auctions with bids"] = "Hide auctions with bids"
		L["Hide minimap icon"] = "Hide minimap icon"
		L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
		L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
		L["High Bidder"] = "High Bidder"
		L["Historical Price"] = "Historical Price"
		L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
		L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
		L["Hr"] = "Hr"
		L["Hrs"] = "Hrs"
		L["IMPORT"] = "IMPORT"
		L["ITEM CLASS"] = "ITEM CLASS"
		L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
		L["ITEM SEARCH"] = "ITEM SEARCH"
		L["ITEM SELECTION"] = "ITEM SELECTION"
		L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
		L["ITEMS"] = "ITEMS"
		L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
		L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"
		L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
		L["Ignore Characters"] = "Ignore Characters"
		L["Ignore Guilds"] = "Ignore Guilds"
		L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
		L["Ignore item variations?"] = "Ignore item variations?"
		L["Ignore operation on characters:"] = "Ignore operation on characters:"
		L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
		L["Ignored Cooldowns"] = "Ignored Cooldowns"
		L["Ignored Items"] = "Ignored Items"
		L["Import"] = "Import"
		L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
		L["Import Groups & Operations"] = "Import Groups & Operations"
		L["Imported Items"] = "Imported Items"
		L["Inbox Settings"] = "Inbox Settings"
		L["Include Attached Operations"] = "Include Attached Operations"
		L["Include operations?"] = "Include operations?"
		L["Include soulbound items"] = "Include soulbound items"
		L["Information"] = "Information"
		L["Invalid custom price entered."] = "Invalid custom price entered."
		L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
		L["Invalid custom price."] = "Invalid custom price."
		L["Invalid function."] = "Invalid function."
		L["Invalid gold value."] = "Invalid gold value."
		L["Invalid group name."] = "Invalid group name."
		L["Invalid import string."] = "Invalid import string."
		L["Invalid item link."] = "Invalid item link."
		L["Invalid operation name."] = "Invalid operation name."
		L["Invalid operator at end of custom price."] = "Invalid operator at end of custom price."
		L["Invalid parameter to price source."] = "Invalid parameter to price source."
		L["Invalid player name."] = "Invalid player name."
		L["Invalid price source in convert."] = "Invalid price source in convert."
		L["Invalid price source."] = "Invalid price source."
		L["Invalid search filter"] = "Invalid search filter"
		L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
		L["Invalid word: '%s'"] = "Invalid word: '%s'"
		L["Inventory"] = "Inventory"
		L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
		L["Inventory / Mailing"] = "Inventory / Mailing"
		L["Inventory Options"] = "Inventory Options"
		L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
		L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
		L["It looks like you're trying to reference an old global price source which no longer exists."] = "It looks like you're trying to reference an old global price source which no longer exists."
		L["Item"] = "Item"
		L["Item Level"] = "Item Level"
		L["Item Name"] = "Item Name"
		L["Item Quality"] = "Item Quality"
		L["Item Value"] = "Item Value"
		L["Item links may only be used as parameters to price sources."] = "Item links may only be used as parameters to price sources."
		L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
		L["Items"] = "Items"
		L["Items in Bags"] = "Items in Bags"
		L["Keep in bags quantity:"] = "Keep in bags quantity:"
		L["Keep in bank quantity:"] = "Keep in bank quantity:"
		L["Keep posted:"] = "Keep posted:"
		L["Keep quantity:"] = "Keep quantity:"
		L["Keep this amount in bags:"] = "Keep this amount in bags:"
		L["Keep this amount:"] = "Keep this amount:"
		L["Keeping %d."] = "Keeping %d."
		L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
		L["LAST 30 DAYS"] = "LAST 30 DAYS"
		L["LAST 7 DAYS"] = "LAST 7 DAYS"
		L["LIMIT"] = "LIMIT"
		L["Last 14 Days"] = "Last 14 Days"
		L["Last 3 Days"] = "Last 3 Days"
		L["Last 30 Days"] = "Last 30 Days"
		L["Last 60 Days"] = "Last 60 Days"
		L["Last 7 Days"] = "Last 7 Days"
		L["Last Data Update:"] = "Last Data Update:"
		L["Last Purchased"] = "Last Purchased"
		L["Last Sold"] = "Last Sold"
		L["Level Up"] = "Level Up"
		L["Link to Another Operation"] = "Link to Another Operation"
		L["List"] = "List"
		L["List materials in tooltip"] = "List materials in tooltip"
		L["Loading Mails..."] = "Loading Mails..."
		L["Loading..."] = "Loading..."
		L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."
		L["Loop detected in the following custom price:"] = "Loop detected in the following custom price:"
		L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
		L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
		L["MAX"] = "MAX"
		L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
		L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
		L["MINIMUM RARITY"] = "MINIMUM RARITY"
		L["MOVE"] = "MOVE"
		L["MOVE TO BAGS"] = "MOVE TO BAGS"
		L["MOVE TO BANK"] = "MOVE TO BANK"
		L["MOVING"] = "MOVING"
		L["Macro Setup"] = "Macro Setup"
		L["Macro created and scroll wheel bound!"] = "Macro created and scroll wheel bound!"
		L["Mail"] = "Mail"
		L["Mail Disenchantables"] = "Mail Disenchantables"
		L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
		L["Mail to %s"] = "Mail to %s"
		L["Mailing"] = "Mailing"
		L["Mailing Options"] = "Mailing Options"
		L["Mailing all to %s."] = "Mailing all to %s."
		L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
		L["Main Settings"] = "Main Settings"
		L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
		L["Management Options"] = "Management Options"
		L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
		L["Map Ping"] = "Map Ping"
		L["Market Value"] = "Market Value"
		L["Market Value Price Source"] = "Market Value Price Source"
		L["Market Value Source"] = "Market Value Source"
		L["Mat Cost"] = "Mat Cost"
		L["Mat Price"] = "Mat Price"
		L["Match stack size?"] = "Match stack size?"
		L["Match whitelisted players"] = "Match whitelisted players"
		L["Material Name"] = "Material Name"
		L["Materials"] = "Materials"
		L["Materials to Gather"] = "Materials to Gather"
		L["Max Buy Price"] = "Max Buy Price"
		L["Max Sell Price"] = "Max Sell Price"
		L["Max Shopping Price"] = "Max Shopping Price"
		L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
		L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
		L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
		L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
		L["Maximum amount already posted."] = "Maximum amount already posted."
		L["Maximum disenchant level:"] = "Maximum disenchant level:"
		L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
		L["Maximum quantity:"] = "Maximum quantity:"
		L["Maximum restock quantity:"] = "Maximum restock quantity:"
		L["Mill Value"] = "Mill Value"
		L["Min"] = "Min"
		L["Min Buy Price"] = "Min Buy Price"
		L["Min Buyout"] = "Min Buyout"
		L["Min Sell Price"] = "Min Sell Price"
		L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
		L["Minimum Days Old"] = "Minimum Days Old"
		L["Minimum disenchant level:"] = "Minimum disenchant level:"
		L["Minimum expires:"] = "Minimum expires:"
		L["Minimum profit:"] = "Minimum profit:"
		L["Minimum restock quantity:"] = "Minimum restock quantity:"
		L["Misplaced comma"] = "Misplaced comma"
		L["Missing Materials"] = "Missing Materials"
		L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
		L["Modifiers:"] = "Modifiers:"
		L["Money Frame Open"] = "Money Frame Open"
		L["Money Transfer"] = "Money Transfer"
		L["Most Profitable Item:"] = "Most Profitable Item:"
		L["Move Quantity Settings"] = "Move Quantity Settings"
		L["Move already grouped items?"] = "Move already grouped items?"
		L["Moving"] = "Moving"
		L["Multiple Items"] = "Multiple Items"
		L["My Auctions"] = "My Auctions"
		L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
		L["NEED MATS"] = "NEED MATS"
		L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
		L["NO ITEMS"] = "NO ITEMS"
		L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
		L["NOT OPEN"] = "NOT OPEN"
		L["NPC"] = "NPC"
		L["Neat Stacks only?"] = "Neat Stacks only?"
		L["New Group"] = "New Group"
		L["New Operation"] = "New Operation"
		L["No Attachments"] = "No Attachments"
		L["No Crafts"] = "No Crafts"
		L["No Data"] = "No Data"
		L["No Materials to Gather"] = "No Materials to Gather"
		L["No Operation Selected"] = "No Operation Selected"
		L["No Profession Opened"] = "No Profession Opened"
		L["No Profession Selected"] = "No Profession Selected"
		L["No Sound"] = "No Sound"
		L["No group selected"] = "No group selected"
		L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
		L["No posting."] = "No posting."
		L["No profile specified. Possible profiles: '%s'"] = "No profile specified. Possible profiles: '%s'"
		L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
		L["None"] = "None"
		L["None (Always Show)"] = "None (Always Show)"
		L["None Selected"] = "None Selected"
		L["Normal"] = "Normal"
		L["Not Connected"] = "Not Connected"
		L["Not Scanned"] = "Not Scanned"
		L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
		L["Not canceling auction below min price."] = "Not canceling auction below min price."
		L["Not canceling."] = "Not canceling."
		L["Not enough items in bags."] = "Not enough items in bags."
		L["Not enough money to cancel."] = "Not enough money to cancel."
		L["Nothing to move."] = "Nothing to move."
		L["Number Owned"] = "Number Owned"
		L["OPEN"] = "OPEN"
		L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
		L["Offline"] = "Offline"
		L["On Cooldown"] = "On Cooldown"
		L["Only show craftable"] = "Only show craftable"
		L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
		L["Open Mail"] = "Open Mail"
		L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
		L["Open Task List"] = "Open Task List"
		L["Opens the Destroying frame if there's stuff in your bags to be destroyed."] = "Opens the Destroying frame if there's stuff in your bags to be destroyed."
		L["Operation"] = "Operation"
		L["Operations"] = "Operations"
		L["Other Character"] = "Other Character"
		L["Other Settings"] = "Other Settings"
		L["Other Shopping Searches"] = "Other Shopping Searches"
		L["Override default craft value method?"] = "Override default craft value method?"
		L["Override parent operations"] = "Override parent operations"
		L["POST"] = "POST"
		L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
		L["POST SELECTED"] = "POST SELECTED"
		L["POSTAGE"] = "POSTAGE"
		L["PRICE SOURCE"] = "PRICE SOURCE"
		L["PROFESSION"] = "PROFESSION"
		L["PROFIT"] = "PROFIT"
		L["PURCHASE DATA"] = "PURCHASE DATA"
		L["Parent Items"] = "Parent Items"
		L["Past 7 Days"] = "Past 7 Days"
		L["Past Day"] = "Past Day"
		L["Past Month"] = "Past Month"
		L["Past Year"] = "Past Year"
		L["Paste string here"] = "Paste string here"
		L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
		L["Per Item"] = "Per Item"
		L["Per Stack"] = "Per Stack"
		L["Per Unit"] = "Per Unit"
		L["Performs a full, manual scan of the AH to populate some AuctionDB data if none is otherwise available."] = "Performs a full, manual scan of the AH to populate some AuctionDB data if none is otherwise available."
		L["Player Gold"] = "Player Gold"
		L["Player Invite Accept"] = "Player Invite Accept"
		L["Please select a group to export"] = "Please select a group to export"
		L["Post Scan"] = "Post Scan"
		L["Post at Maximum Price"] = "Post at Maximum Price"
		L["Post at Minimum Price"] = "Post at Minimum Price"
		L["Post at Normal Price"] = "Post at Normal Price"
		L["Postage"] = "Postage"
		L["Posted Auctions %s:"] = "Posted Auctions %s:"
		L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
		L["Posting"] = "Posting"
		L["Posting %d / %d"] = "Posting %d / %d"
		L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
		L["Posting Settings"] = "Posting Settings"
		L["Posting at normal price."] = "Posting at normal price."
		L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
		L["Posting at your current price."] = "Posting at your current price."
		L["Posting disabled."] = "Posting disabled."
		L["Posts"] = "Posts"
		L["Potential"] = "Potential"
		L["Price Per Item"] = "Price Per Item"
		L["Price Settings"] = "Price Settings"
		L["Price Variables"] = "Price Variables"
		L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
		L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
		L["Prints out the available price sources for use in custom prices"] = "Prints out the available price sources for use in custom prices"
		L["Prints out the version numbers of all installed modules"] = "Prints out the version numbers of all installed modules"
		L["Prints the slash command help listing"] = "Prints the slash command help listing"
		L["Processing scan results..."] = "Processing scan results..."
		L["Profession Filters"] = "Profession Filters"
		L["Profession Info"] = "Profession Info"
		L["Profession loading..."] = "Profession loading..."
		L["Professions Used In"] = "Professions Used In"
		L["Profile changed to '%s'."] = "Profile changed to '%s'."
		L["Profiles"] = "Profiles"
		L["Profit"] = "Profit"
		L["Prospect Value"] = "Prospect Value"
		L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
		L["Purchased (Total Price)"] = "Purchased (Total Price)"
		L["Purchases"] = "Purchases"
		L["Purchasing Auction"] = "Purchasing Auction"
		L["Puts items matching the item or partial text entered into the bank or guild bank."] = "Puts items matching the item or partial text entered into the bank or guild bank."
		L["QUEUE"] = "QUEUE"
		L["Qty"] = "Qty"
		L["Qty (%d available)"] = "Qty (%d available)"
		L["Quantity"] = "Quantity"
		L["Quantity Bought:"] = "Quantity Bought:"
		L["Quantity Sold:"] = "Quantity Sold:"
		L["Quantity to move:"] = "Quantity to move:"
		L["Quest Added"] = "Quest Added"
		L["Quest Completed"] = "Quest Completed"
		L["Quest Objectives Complete"] = "Quest Objectives Complete"
		L["Quick Sell Options"] = "Quick Sell Options"
		L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
		L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
		L["RECIPIENT"] = "RECIPIENT"
		L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
		L["REPAIR"] = "REPAIR"
		L["REPLY"] = "REPLY"
		L["REPORT SPAM"] = "REPORT SPAM"
		L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
		L["RESCAN"] = "RESCAN"
		L["RESET"] = "RESET"
		L["RESTART"] = "RESTART"
		L["RESTOCK BAGS"] = "RESTOCK BAGS"
		L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
		L["RESTORE BAGS"] = "RESTORE BAGS"
		L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
		L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
		L["RUN POST SCAN"] = "RUN POST SCAN"
		L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
		L["Raid Warning"] = "Raid Warning"
		L["Read More"] = "Read More"
		L["Ready Check"] = "Ready Check"
		L["Ready to Cancel"] = "Ready to Cancel"
		L["Realm Data Tooltips"] = "Realm Data Tooltips"
		L["Recent Scans"] = "Recent Scans"
		L["Recent Searches"] = "Recent Searches"
		L["Recently Mailed"] = "Recently Mailed"
		L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
		L["Region Data Tooltips"] = "Region Data Tooltips"
		L["Region Historical Price"] = "Region Historical Price"
		L["Region Market Value Avg"] = "Region Market Value Avg"
		L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
		L["Region Sale Avg"] = "Region Sale Avg"
		L["Region Sale Rate"] = "Region Sale Rate"
		L["Reload"] = "Reload"
		L["Removed a total of %s old records."] = "Removed a total of %s old records."
		L["Removed custom price source (%s) which has an invalid name."] = "Removed custom price source (%s) which has an invalid name."
		L["Rename"] = "Rename"
		L["Rename Profile"] = "Rename Profile"
		L["Repair Bill"] = "Repair Bill"
		L["Replace duplicate operations?"] = "Replace duplicate operations?"
		L["Repost Higher Threshold"] = "Repost Higher Threshold"
		L["Required Level"] = "Required Level"
		L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
		L["Resale"] = "Resale"
		L["Reset All"] = "Reset All"
		L["Reset Filters"] = "Reset Filters"
		L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
		L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
		L["Restock Quantity Settings"] = "Restock Quantity Settings"
		L["Restock Settings"] = "Restock Settings"
		L["Restock help for %s: %s"] = "Restock help for %s: %s"
		L["Restock quantity:"] = "Restock quantity:"
		L["Restock target to max quantity?"] = "Restock target to max quantity?"
		L["Restocking to %d."] = "Restocking to %d."
		L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
		L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
		L["Resume Scan"] = "Resume Scan"
		L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
		L["Revenue"] = "Revenue"
		L["Round normal price"] = "Round normal price"
		L["Run Bid Sniper"] = "Run Bid Sniper"
		L["Run Buyout Sniper"] = "Run Buyout Sniper"
		L["Running Sniper Scan"] = "Running Sniper Scan"
		L["SALE DATA"] = "SALE DATA"
		L["SALES"] = "SALES"
		L["SCAN ALL"] = "SCAN ALL"
		L["SCANNING"] = "SCANNING"
		L["SELL ALL"] = "SELL ALL"
		L["SELL BOES"] = "SELL BOES"
		L["SELL GROUPS"] = "SELL GROUPS"
		L["SELL TRASH"] = "SELL TRASH"
		L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
		L["SEND GOLD"] = "SEND GOLD"
		L["SEND MAIL"] = "SEND MAIL"
		L["SENDING"] = "SENDING"
		L["SENDING..."] = "SENDING..."
		L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
		L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
		L["SKIP"] = "SKIP"
		L["SOURCE %d"] = "SOURCE %d"
		L["SOURCES"] = "SOURCES"
		L["STOP"] = "STOP"
		L["SUBJECT"] = "SUBJECT"
		L["Sale"] = "Sale"
		L["Sale Price"] = "Sale Price"
		L["Sale Rate"] = "Sale Rate"
		L["Sales"] = "Sales"
		L["Sales Summary"] = "Sales Summary"
		L["Scan Complete Sound"] = "Scan Complete Sound"
		L["Scan Paused"] = "Scan Paused"
		L["Scan was slowed down by %s seconds by other AH addons."] = "Scan was slowed down by %s seconds by other AH addons."
		L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
		L["Scanning is %d%% complete"] = "Scanning is %d%% complete"
		L["Scroll wheel direction:"] = "Scroll wheel direction:"
		L["Search"] = "Search"
		L["Search Bags"] = "Search Bags"
		L["Search Groups"] = "Search Groups"
		L["Search Inbox"] = "Search Inbox"
		L["Search Operations"] = "Search Operations"
		L["Search Patterns"] = "Search Patterns"
		L["Search Usable Items Only?"] = "Search Usable Items Only?"
		L["Search Vendor"] = "Search Vendor"
		L["Select Action"] = "Select Action"
		L["Select All Groups"] = "Select All Groups"
		L["Select All Items"] = "Select All Items"
		L["Select Auction to Cancel"] = "Select Auction to Cancel"
		L["Select Duration"] = "Select Duration"
		L["Select Items to Add"] = "Select Items to Add"
		L["Select Items to Remove"] = "Select Items to Remove"
		L["Select Operation"] = "Select Operation"
		L["Select a Source"] = "Select a Source"
		L["Select crafter"] = "Select crafter"
		L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
		L["Select operation"] = "Select operation"
		L["Select professions"] = "Select professions"
		L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
		L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
		L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
		L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
		L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
		L["Selected Groups"] = "Selected Groups"
		L["Selected Operations"] = "Selected Operations"
		L["Sell"] = "Sell"
		L["Sell Options"] = "Sell Options"
		L["Sell soulbound items?"] = "Sell soulbound items?"
		L["Sell to Vendor"] = "Sell to Vendor"
		L["Seller"] = "Seller"
		L["Selling soulbound items."] = "Selling soulbound items."
		L["Send"] = "Send"
		L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
		L["Send Money"] = "Send Money"
		L["Send Profile"] = "Send Profile"
		L["Send grouped items individually"] = "Send grouped items individually"
		L["Sending %s individually to %s"] = "Sending %s individually to %s"
		L["Sending %s to %s"] = "Sending %s to %s"
		L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
		L["Sending Settings"] = "Sending Settings"
		L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
		L["Set Maximum Price:"] = "Set Maximum Price:"
		L["Set Minimum Price:"] = "Set Minimum Price:"
		L["Set Normal Price:"] = "Set Normal Price:"
		L["Set auction duration to:"] = "Set auction duration to:"
		L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
		L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
		L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
		L["Set maximum quantity?"] = "Set maximum quantity?"
		L["Set minimum profit?"] = "Set minimum profit?"
		L["Set move quantity?"] = "Set move quantity?"
		L["Set post cap to:"] = "Set post cap to:"
		L["Set posted stack size to:"] = "Set posted stack size to:"
		L["Set stack size for restock?"] = "Set stack size for restock?"
		L["Set stack size?"] = "Set stack size?"
		L["Setup"] = "Setup"
		L["Shopping"] = "Shopping"
		L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
		L["Shopping Tooltips"] = "Shopping Tooltips"
		L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
		L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
		L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
		L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
		L["Show Description"] = "Show Description"
		L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
		L["Show auctions above max price?"] = "Show auctions above max price?"
		L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
		L["Show material cost"] = "Show material cost"
		L["Show on Modifier"] = "Show on Modifier"
		L["Showing %d Mail"] = "Showing %d Mail"
		L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
		L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
		L["Showing all %d Mails"] = "Showing all %d Mails"
		L["Simple"] = "Simple"
		L["Skip Import confirmation?"] = "Skip Import confirmation?"
		L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
		L["Slash Commands:"] = "Slash Commands:"
		L["Sniper"] = "Sniper"
		L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
		L["Sniper Options"] = "Sniper Options"
		L["Sniper Settings"] = "Sniper Settings"
		L["Sniping items below a max price"] = "Sniping items below a max price"
		L["Sold"] = "Sold"
		L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
		L["Sold %s worth of items."] = "Sold %s worth of items."
		L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
		L["Sold (Total Price)"] = "Sold (Total Price)"
		L["Sold Auctions %s:"] = "Sold Auctions %s:"
		L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
		L["Source"] = "Source"
		L["Sources"] = "Sources"
		L["Sources to include for restock:"] = "Sources to include for restock:"
		L["Stack"] = "Stack"
		L["Stack / Quantity"] = "Stack / Quantity"
		L["Stack size multiple:"] = "Stack size multiple:"
		L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
		L["Start either a 'Buyout' sniper using the button above."] = "Start either a 'Buyout' sniper using the button above."
		L["Starting Scan..."] = "Starting Scan..."
		L["Starting full AH scan. Please note that this scan may cause your game client to lag or crash. This scan generally takes 1-2 minutes."] = "Starting full AH scan. Please note that this scan may cause your game client to lag or crash. This scan generally takes 1-2 minutes."
		L["Stop Scan"] = "Stop Scan"
		L["Store operations globally"] = "Store operations globally"
		L["Subject"] = "Subject"
		L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
		L["Switch to %s"] = "Switch to %s"
		L["Switch to WoW UI"] = "Switch to WoW UI"
		L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
		L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
		L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
		L["Sync Status"] = "Sync Status"
		L["TAKE ALL"] = "TAKE ALL"
		L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
		L["TIME FRAME"] = "TIME FRAME"
		L["TINKER"] = "TINKER"
		L["TSM Banking"] = "TSM Banking"
		L["TSM Crafting"] = "TSM Crafting"
		L["TSM Destroying"] = "TSM Destroying"
		L["TSM Mailing"] = "TSM Mailing"
		L["TSM TASK LIST"] = "TSM TASK LIST"
		L["TSM Vendoring"] = "TSM Vendoring"
		L["TSM Version Info:"] = "TSM Version Info:"
		L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
		L["TSM does not have recent AuctionDB data. Would you like to run a full AH scan?"] = "TSM does not have recent AuctionDB data. Would you like to run a full AH scan?"
		L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
		L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
		L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
		L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
		L["TSM is not yet ready to establish a new sync connection. Please try again later."] = "TSM is not yet ready to establish a new sync connection. Please try again later."
		L["TSM4"] = "TSM4"
		L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
		L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
		L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
		L["TUJ Global Mean"] = "TUJ Global Mean"
		L["TUJ Global Median"] = "TUJ Global Median"
		L["Take Attachments"] = "Take Attachments"
		L["Target Character"] = "Target Character"
		L["Tasks Added to Task List"] = "Tasks Added to Task List"
		L["Tells you why a specific item is not being restocked and added to the queue."] = "Tells you why a specific item is not being restocked and added to the queue."
		L["Text (%s)"] = "Text (%s)"
		L["The '%s' custom price source is invalid."] = "The '%s' custom price source is invalid."
		L["The 'Craft Value Method' did not return a value for this item."] = "The 'Craft Value Method' did not return a value for this item."
		L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
		L["The buyout price for %s would be above the maximum allowed price. Skipping this item."] = "The buyout price for %s would be above the maximum allowed price. Skipping this item."
		L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
		L["The min profit did not evalulate to a valid value for this item."] = "The min profit did not evalulate to a valid value for this item."
		L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "The name can ONLY contain letters. No spaces, numbers, or special characters."
		L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
		L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
		L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
		L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
		L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
		L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
		L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
		L["This item is not in a TSM group."] = "This item is not in a TSM group."
		L["This item will be added to the queue when you restock its group. If this isn't happening, please visit http://support.tradeskillmaster.com for further assistance."] = "This item will be added to the queue when you restock its group. If this isn't happening, please visit http://support.tradeskillmaster.com for further assistance."
		L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
		L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
		L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
		L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
		L["Time"] = "Time"
		L["Time Format"] = "Time Format"
		L["Time Frame"] = "Time Frame"
		L["Toggles the TSM Banking UI if either the bank or guild bank is currently open."] = "Toggles the TSM Banking UI if either the bank or guild bank is currently open."
		L["Toggles the TSM Crafting UI."] = "Toggles the TSM Crafting UI."
		L["Toggles the TSM Task List UI"] = "Toggles the TSM Task List UI"
		L["Toggles the main TSM window"] = "Toggles the main TSM window"
		L["Tooltip Price Format"] = "Tooltip Price Format"
		L["Tooltip Settings"] = "Tooltip Settings"
		L["Top Buyers:"] = "Top Buyers:"
		L["Top Item:"] = "Top Item:"
		L["Top Sellers:"] = "Top Sellers:"
		L["Total"] = "Total"
		L["Total Gold"] = "Total Gold"
		L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
		L["Total Gold Earned:"] = "Total Gold Earned:"
		L["Total Gold Spent:"] = "Total Gold Spent:"
		L["Total Price"] = "Total Price"
		L["Total Profit:"] = "Total Profit:"
		L["Total Value"] = "Total Value"
		L["Total Value of All Items"] = "Total Value of All Items"
		L["Total price"] = "Total price"
		L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
		L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
		L["Transform Value"] = "Transform Value"
		L["Type"] = "Type"
		L["Type Something"] = "Type Something"
		L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
		L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
		L["Unbalanced parentheses."] = "Unbalanced parentheses."
		L["Undercut amount:"] = "Undercut amount:"
		L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
		L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
		L["Undercutting competition."] = "Undercutting competition."
		L["Ungrouped Items"] = "Ungrouped Items"
		L["Unknown Item"] = "Unknown Item"
		L["Unwrap Gift"] = "Unwrap Gift"
		L["Up"] = "Up"
		L["Up to date"] = "Up to date"
		L["Updating"] = "Updating"
		L["Usage: /tsm price <ItemLink> <Price String>"] = "Usage: /tsm price <ItemLink> <Price String>"
		L["Use smart average for purchase price"] = "Use smart average for purchase price"
		L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
		L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
		L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
		L["VENDOR SEARCH"] = "VENDOR SEARCH"
		L["ValueSources"] = "ValueSources"
		L["Variable Name"] = "Variable Name"
		L["Vendor"] = "Vendor"
		L["Vendor Buy Price"] = "Vendor Buy Price"
		L["Vendor Search"] = "Vendor Search"
		L["Vendor Sell"] = "Vendor Sell"
		L["Vendor Sell Price"] = "Vendor Sell Price"
		L["Vendoring"] = "Vendoring"
		L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
		L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
		L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNING: The macro was too long, so was truncated to fit by WoW."
		L["WARNING: Your minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: Your minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
		L["Warehousing"] = "Warehousing"
		L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
		L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
		L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
		L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
		L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
		L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
		L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
		L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
		L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
		L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
		L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
		L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
		L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
		L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
		L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
		L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
		L["When above maximum:"] = "When above maximum:"
		L["When below minimum:"] = "When below minimum:"
		L["Whitelist"] = "Whitelist"
		L["Whitelisted Players"] = "Whitelisted Players"
		L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
		L["You cannot use %s as part of this custom price."] = "You cannot use %s as part of this custom price."
		L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
		L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
		L["You don't know how to craft this item."] = "You don't know how to craft this item."
		L["You either already have at least your max restock quantity of this item or the number which would be queued is less than the min restock quantity."] = "You either already have at least your max restock quantity of this item or the number which would be queued is less than the min restock quantity."
		L["You must reload your UI for these settings to take effect. Reload now?"] = "You must reload your UI for these settings to take effect. Reload now?"
		L["You won an auction for %sx%d for %s"] = "You won an auction for %sx%d for %s"
		L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
		L["You've been undercut."] = "You've been undercut."
		L["Your Buyout"] = "Your Buyout"
		L["Your auction has not been undercut."] = "Your auction has not been undercut."
		L["Your auction of %s expired"] = "Your auction of %s expired"
		L["Your auction of %s has sold for %s!"] = "Your auction of %s has sold for %s!"
		L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
		L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
		L["Your task list is currently empty."] = "Your task list is currently empty."
		L["ilvl"] = "ilvl"
		L["of"] = "of"
		L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
		L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
		L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
		L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Left-Click|r to ignore an item this session."
		L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Left-Click|r to ignore it permanently."
	elseif locale == "deDE" then
L = L or {}
L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Gruppe:Gruppen; ausgewählt (%d |4Item:Items;)"
L["%d auctions"] = "%d Auktionen"
L["%d Groups"] = "%d Gruppen"
L["%d Items"] = "%d Items"
L["%d of %d"] = "%d von %d"
L["%d Operations"] = "%d Operationen"
L["%d Posted Auctions"] = "%d gelistete Auktionen"
L["%d Sold Auctions"] = "%d verkaufte Auktionen"
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s Taschen, %s Bank, %s AH, %s Post)"
L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s Spieler, %s Twinks, %s Gilde, %s AH)"
L["%s (%s profit)"] = "%s (%s Gewinn)"
--[[Translation missing --]]
L["%s |4operation:operations;"] = "%s |4operation:operations;"
L["%s ago"] = "vor %s"
L["%s Crafts"] = "%s Rezepte"
--[[Translation missing --]]
L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
L["%s in guild vault"] = "%s im Gildentresor"
L["%s is a valid custom price but %s is an invalid item."] = "%s ist ein gültiger eigener Preis, aber %s ist ein ungültiges Item."
L["%s is a valid custom price but did not give a value for %s."] = "%s ist ein gültiger eigener Preis, ergibt aber keinen Wert für %s."
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' ist eine ungültige Operation! Die minimale Wiederauffüllungsmenge von %d ist höher als die maximale Wiederauffüllungsmenge von %d."
L["%s is not a valid custom price and gave the following error: %s"] = "%s ist kein gültiger eigener Preis und führte zu folgendem Fehler: %s"
L["%s Operations"] = "%s Operationen"
--[[Translation missing --]]
L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
L["%s removed."] = "%s entfernt."
L["%s sent you %s"] = "%s hat dir %s gesendet"
L["%s sent you %s and %s"] = "%s sendet dir %s und %s"
L["%s sent you a COD of %s for %s"] = "%s hat dir eine Nachnahmegebühr von %s für %s gesendet"
L["%s sent you a message: %s"] = "%s hat dir eine Nachricht gesendet: %s"
L["%s total"] = "%s Gesamt"
L["%sDrag%s to move this button"] = "%sZiehen%s, um diesen Button zu verschieben"
L["%sLeft-Click%s to open the main window"] = "%sLinksklick%s, um das Hauptfenster zu öffnen"
L["(%d/500 Characters)"] = "(%d/500 Zeichen)"
L["(max %d)"] = "(max %d)"
L["(max 5000)"] = "(max 5000)"
L["(min %d - max %d)"] = "(%d bis %d)"
L["(min 0 - max 10000)"] = "(0 bis 10000)"
L["(minimum 0 - maximum 20)"] = "(0 bis 20)"
L["(minimum 0 - maximum 2000)"] = "(0 bis 2000)"
L["(minimum 0 - maximum 905)"] = "(0 bis 905)"
L["(minimum 0.5 - maximum 10)"] = "(0.5 bis 10)"
L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Zeigt diese Hilfeliste an"
L["/tsm|r - opens the main TSM window."] = "/tsm|r - Öffnet das TSM-Hauptfenster."
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000WICHTIG:|r Beim letzten Versuch von TSM_Accounting die Daten für diesen Server zu speichern, waren diese zu umfangreich für, woraufhin alte Datenteile automatisch verworfen wurden, um andere zu speichernde Variablen vor Beschädigung zu schützen. Die letzten %s der Einkaufsdaten wurden gerettet."
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000WICHTIG:|r Die neuesten, via TSM_Accounting abgerufenen Daten für diesen Realm sind zu groß und können von WoW nicht verarbeitet werden, demzufolge wurden alte Daten teilweise entfernt, um eine Beschädigung der gespeicherten Variablen zu verhindern. Die letzten %s der Verkaufsdaten sind weiterhin verfügbar."
L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Linksklick|r, um ein Item für diese Sitzung zu ignorieren. Halte |cffffd839Umschalt|r gedrückt, um es dauerhaft zu ignorieren. In den Vendoring-Einstellungen kann das permanente Ignorieren von Items rückgängig gemacht werden."
L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Linksklick|r, um ein Item für diese Sitzung zu ignorieren."
L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Umschalt+Linksklick|r, um es dauerhaft zu ignorieren."
L["1 Group"] = "1 Gruppe"
L["1 Item"] = "1 Item"
L["12 hr"] = "12 Std"
L["24 hr"] = "24 Std"
L["48 hr"] = "48 Std"
L["A custom price of %s for %s evaluates to %s."] = "Ein eigener Preis von %s für %s ergibt %s."
L["A maximum of 1 convert() function is allowed."] = "Es ist maximal 1 convert() Funktion erlaubt."
L["A profile with that name already exists on the target account. Rename it first and try again."] = "Ein Profil mit diesem Namen existiert bereits im Ziel-Account. Benenne es zuerst um und versuche es noch einmal."
L["A profile with this name already exists."] = "Ein Profil mit diesem Namen ist schon vorhanden."
L["A scan is already in progress. Please stop that scan before starting another one."] = "Ein Scan wird bereits durchgeführt. Bitte beende diesen Scan, bevor du einen weiteren startest."
L["Above max expires."] = "Über max Abläufe."
L["Above max price. Not posting."] = "Über Maximum. Erstelle keine Auktion."
L["Above max price. Posting at max price."] = "Über Maximum. Nutze Höchstpreis."
L["Above max price. Posting at min price."] = "Über Maximum. Nutze Mindestpreis."
L["Above max price. Posting at normal price."] = "Über Maximum. Nutze Normalpreis."
L["Accepting these item(s) will cost"] = "Der Kauf dieser Items kostet"
L["Accepting this item will cost"] = "Der Kauf dieses Items kostet"
L["Account sync removed. Please delete the account sync from the other account as well."] = "Account-Sync entfernt. Bitte entferne den Account-Sync auch auf dem anderen Account."
L["Account Syncing"] = "Account-Sync"
L["Accounting"] = "Accounting"
L["Accounting Tooltips"] = "Accounting-Tooltips"
L["Activity Type"] = "Aktivitätstyp"
L["ADD %d ITEMS"] = "%d ITEMS HINZUFÜGEN"
L["Add / Remove Items"] = "Items hinzufügen / entfernen"
L["ADD NEW CUSTOM PRICE SOURCE"] = "NEUE EIGENE PREISQUELLE HINZUFÜGEN"
L["ADD OPERATION"] = "HINZUFÜGEN"
L["Add Player"] = "Spieler hinzufügen"
L["Add Subject / Description"] = "Betreff / Beschreibung hinzufügen"
L["Add Subject / Description (Optional)"] = "Betreff / Beschreibung hinzufügen (optional)"
L["ADD TO MAIL"] = "ZUR MAIL HINZUFÜGEN"
--[[Translation missing --]]
L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
L["Added %s to %s."] = "Die Operation %s wurde zur Gruppe %s hinzugefügt."
L["Additional error suppressed"] = "Zusätzlicher Fehler unterdrückt"
L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Lege fest, wie die Gruppen von dieser Operation auktioniert werden sollen."
L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Lege fest, wie die Gruppen von dieser Operation abgebrochen werden sollen."
L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Lege fest, wie die Gruppen von dieser Operation preislich behandelt werden sollen."
L["Advanced Item Search"] = "Erweiterte Itemsuche"
L["Advanced Options"] = "Erweiterte Optionen"
L["AH"] = "AH"
L["AH (Crafting)"] = "AH (Herstellen)"
L["AH (Disenchanting)"] = "AH (Entzaubern)"
L["AH BUSY"] = "AH BESCHÄFTIGT"
L["AH Frame Options"] = "Optionen für das AH-Fenster"
L["Alarm Clock"] = "Wecker"
L["All Auctions"] = "Alle Auktionen"
L["All Characters and Guilds"] = "Alle Charaktere und Gilden"
L["All Item Classes"] = "Alle Gegenstandsklassen"
L["All Professions"] = "Alle Berufe"
L["All Subclasses"] = "Alle Unterklassen"
L["Allow partial stack?"] = "Teilstapel zulassen?"
L["Alt Guild Bank"] = "Twink Gildenbank"
L["Alts"] = "Twinks"
L["Alts AH"] = "Twinks AH"
L["Amount"] = "Betrag"
L["AMOUNT"] = "BETRAG"
L["Amount of Bag Space to Keep Free"] = "Anzahl der Taschenplätze, die leer bleiben sollen"
L["APPLY FILTERS"] = "FILTER ANWENDEN"
L["Apply operation to group:"] = "Operation anwenden auf die Gruppe:"
L["Are you sure you want to clear old accounting data?"] = "Bist du sicher, dass du alle Accounting-Daten löschen möchtest?"
L["Are you sure you want to delete this group?"] = "Willst du diese Gruppe wirklich löschen?"
L["Are you sure you want to delete this operation?"] = "Diese Operation wirklich löschen?"
L["Are you sure you want to reset all operation settings?"] = "Bist du sicher, dass du alle Operationseinstellungen zurücksetzen möchtest?"
L["At above max price and not undercut."] = "Zum Höchstpreis aber nicht unterbieten."
L["At normal price and not undercut."] = "Zum Normalpreis aber nicht unterbieten."
L["Auction"] = "Auktion"
L["Auction Bid"] = "Gebot"
L["Auction Buyout"] = "Sofortkauf"
L["AUCTION DETAILS"] = "AUKTIONSDETAILS"
L["Auction Duration"] = "Auktionslaufzeit"
L["Auction has been bid on."] = "Auf die Auktion wurde geboten."
L["Auction House Cut"] = "Auktionshausgebühr"
L["Auction Sale Sound"] = "Auktions-Verkauf Klang"
L["Auction Window Close"] = "Auktionsfenster schließen"
L["Auction Window Open"] = "Auktionsfenster öffnen"
L["Auctionator - Auction Value"] = "Auctionator - Auktionswert"
--[[Translation missing --]]
L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
L["Auctioneer - Appraiser"] = "Auctioneer - Appraiser"
L["Auctioneer - Market Value"] = "Auctioneer - Marktwert"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - Mindestsofortkauf"
L["Auctioning"] = "Auctioning"
L["Auctioning Log"] = "Auctioning-Protokoll"
L["Auctioning Operation"] = "Auctioning-Operation"
L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning-Button 'EINSTELLEN'/'ABBRECHEN'"
--[[Translation missing --]]
L["Auctioning Tooltips"] = "Auctioning Tooltips"
L["Auctions"] = "Aukts"
L["Auto Quest Complete"] = "Auto-Quest abgeschlossen"
L["Average Earned Per Day:"] = "Durchschnittlich verdient pro Tag:"
L["Average Prices:"] = "Durchschnittspreise:"
L["Average Profit Per Day:"] = "Durchschnittlicher Gewinn pro Tag:"
L["Average Spent Per Day:"] = "Durchschnittliche Ausgaben pro Tag:"
L["Avg Buy Price"] = "Ø Kaufpreis"
L["Avg Resale Profit"] = "Ø Wiederverkaufsgewinn"
L["Avg Sell Price"] = "Ø Verkaufspreis"
L["BACK"] = "ZURÜCK"
L["BACK TO LIST"] = "ZURÜCK ZUR LISTE"
L["Back to List"] = "Zurück zur Liste"
L["Bag"] = "Tasche"
L["Bags"] = "Tasche"
L["Banks"] = "Bank"
L["Base Group"] = "Basisgruppe"
L["Base Item"] = "Grund-Item"
L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Deine aktuell verfügbaren Preisquellen, sortiert nach Modul. Das %sSchlüsselwort|r benutzt man in der Regel in einem Feld mit eigener Preisangabe."
L["Below custom price:"] = "Unter eigenem Preis:"
L["Below min price. Posting at max price."] = "Unter Minimum. Nutze Höchstpreis."
L["Below min price. Posting at min price."] = "Unter Minimum. Nutze Mindestpreis."
L["Below min price. Posting at normal price."] = "Unter Minimum. Nutze Normalpreis."
L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Erstelle Profile mit unterschiedlichen Sets von Gruppen."
L["BID"] = "GEBOT"
L["Bid %d / %d"] = "Bieten %d / %d"
L["Bid (item)"] = "Gebot (Item)"
L["Bid (stack)"] = "Gebot (Stapel)"
L["Bid Price"] = "Gebotspreis"
L["Bid Sniper Paused"] = "Gebot-Sniper pausiert"
L["Bid Sniper Running"] = "Gebot-Sniper läuft"
L["Bidding Auction"] = "Gebots-Auktion"
L["Blacklisted players:"] = "Spieler auf schwarzer Liste:"
L["Bought"] = "Gekauft"
--[[Translation missing --]]
L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
L["Bought %sx%d for %s from %s"] = "%sx%d gekauft für %s von %s"
L["Bound Actions"] = "Gebundene Aktionen"
L["BUSY"] = "BESCHÄFTIGT"
L["BUY"] = "KAUFEN"
L["Buy"] = "Kaufen"
L["Buy %d / %d"] = "Kaufe %d / %d"
L["Buy %d / %d (Confirming %d / %d)"] = "Kaufe %d / %d (Bestätige %d / %d)"
L["Buy from AH"] = "Im AH kaufen"
L["Buy from Vendor"] = "Vom Händler kaufen"
L["BUY GROUPS"] = "GRUPPEN KAUFEN"
L["Buy Options"] = "Kaufoptionen"
L["BUYBACK ALL"] = "ALLES ZURÜCKKAUFEN"
L["Buyer/Seller"] = "Käufer/Verkäufer"
L["BUYOUT"] = "SOFORTKAUF"
L["Buyout (item)"] = "Sofortkauf (Item)"
L["Buyout (stack)"] = "Sofortkauf (Stapel)"
L["Buyout Confirmation Alert"] = "Sofortkauf Bestätigungs-Alarm"
L["Buyout Price"] = "Sofortkauf"
L["Buyout Sniper Paused"] = "Sofortkauf-Sniper pausiert"
L["Buyout Sniper Running"] = "Sofortkauf-Sniper läuft"
L["BUYS"] = "EINKÄUFE"
L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "Standardmäßig enthält diese Gruppe alle Items, die keiner Gruppe zugeordnet sind. Du kannst diese Gruppe weder ändern noch löschen."
L["Cancel auctions with bids"] = "Auktionen mit Geboten abbrechen"
L["Cancel Scan"] = "Scan abbrechen"
L["Cancel to repost higher?"] = "Abbrechen, um Auktion mit höherem Preis zu erstellen?"
L["Cancel undercut auctions?"] = "Unterbotene Auktionen abbrechen?"
L["Canceling"] = "Abbrechen"
L["Canceling %d / %d"] = "Abbrechen %d / %d"
L["Canceling %d Auctions..."] = "Breche %d Auktionen ab..."
L["Canceling all auctions."] = "Breche alle Auktionen ab."
L["Canceling auction which you've undercut."] = "Breche Auktionen ab, bei denen du unterboten wurdest."
L["Canceling disabled."] = "Abbrechen deaktiviert."
L["Canceling Settings"] = "Abbruchseinstellungen"
L["Canceling to repost at higher price."] = "Breche ab, um zum höheren Preis zu erstellen."
L["Canceling to repost at reset price."] = "Abbrechen, um zum Reset-Preis wieder einzustellen."
L["Canceling to repost higher."] = "Breche ab, um zum höheren Preis zu erstellen."
L["Canceling undercut auctions and to repost higher."] = "Breche unterbotene Auktionen ab um sie zu einem höheren Preis zu listen."
L["Canceling undercut auctions."] = "Breche unterbotene Auktionen ab."
L["Cancelled"] = "Abgebrochen"
L["Cancelled auction of %sx%d"] = "Abgebrochene Auktion von %sx%d"
L["Cancelled Since Last Sale"] = "Abgebrochen seit letztem Verkauf"
L["CANCELS"] = "ABGEBROCHENE"
L["Cannot repair from the guild bank!"] = "Kann nicht aus der Gildenbank repariert werden!"
L["Can't load TSM tooltip while in combat"] = "TSM-Tooltip kann während eines Kampfes nicht geladen werden"
L["Cash Register"] = "Registrierkasse"
L["CHARACTER"] = "CHARAKTER"
L["Character"] = "Charakter"
L["Chat Tab"] = "Chat-Tab"
L["Cheapest auction below min price."] = "Billigste Auktion unter Mindestpreis."
L["Clear"] = "Leeren"
L["Clear All"] = "Alles leeren"
L["CLEAR DATA"] = "DATEN LÖSCHEN"
L["Clear Filters"] = "Filter leeren"
L["Clear Old Data"] = "Alte Daten löschen"
L["Clear Old Data Confirmation"] = "Löschen alter Daten bestätigen"
L["Clear Queue"] = "Leeren"
L["Clear Selection"] = "Auswahl aufheben"
L["COD"] = "Nachnahme"
L["Coins (%s)"] = "Münzen (%s)"
L["Collapse All Groups"] = "Alle Gruppen zusammenklappen"
L["Combine Partial Stacks"] = "Geteilte Bündel verbinden"
L["Combining..."] = "Kombinieren..."
L["Configuration Scroll Wheel"] = "Mausrad-Konfiguration"
L["Confirm"] = "Bestätigen"
L["Confirm Complete Sound"] = "Sound, wenn die Bestätigung fertig ist"
L["Confirming %d / %d"] = "Bestätige %d / %d"
L["Connected to %s"] = "Verbunden mit %s ß"
L["Connecting to %s"] = "Verbinde zu %s"
L["CONTACTS"] = "KONTAKTE"
L["Contacts Menu"] = "Kontakte"
L["Cooldown"] = "Abklingzeit"
L["Cooldowns"] = "Abklingzeiten"
L["Cost"] = "Kosten"
L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Makro konnte nicht erstellt werden, da du bereits zu viele hast. Lösche ein vorhandenes Makro und versuche es erneut."
L["Could not find profile '%s'. Possible profiles: '%s'"] = "Profil '%s' konnte nicht gefunden werden. Mögliche Profile: '%s'"
L["Could not sell items due to not having free bag space available to split a stack of items."] = "Items konnten nicht verkaufen werden, da kein freier Taschenplatz verfügbar ist, um ein Stapel aufzuteilen."
L["Craft"] = "Herst"
L["CRAFT"] = "HERSTELLEN"
L["Craft (Unprofitable)"] = "Herstellen (unprofitabel)"
L["Craft (When Profitable)"] = "Herstellen (wenn profitabel)"
L["Craft All"] = "Alle herstellen"
L["CRAFT ALL"] = "ALLE HERSTELLEN"
L["Craft Name"] = "Rezeptname"
L["CRAFT NEXT"] = "NÄCHSTES HERSTELLEN"
L["Craft value method:"] = "Methode zur Ermittlung des Marktwertes:"
L["CRAFTER"] = "HERSTELLER"
L["CRAFTING"] = "HERSTELLEN"
L["Crafting"] = "Herstellen"
L["Crafting Cost"] = "Herst Kosten"
L["Crafting 'CRAFT NEXT' Button"] = "Crafting-Button 'NÄCHTES HERSTELLEN'"
L["Crafting Queue"] = "Herstellungswarteschlange"
L["Crafting Tooltips"] = "Herstellungsstooltips"
L["Crafts"] = "Rezepte"
L["Crafts %d"] = "Stellt %d her"
L["CREATE MACRO"] = "MAKRO ERSTELLEN"
L["Create New Operation"] = "Neue Operation erstellen"
L["CREATE NEW PROFILE"] = "NEUES PROFIL ERSTELLEN"
L["Create Profession Group"] = "Erstelle Berufs-Gruppe"
L["Created custom price source: |cff99ffff%s|r"] = "Erstelle individuelle Preisquelle: |cff99ffff%s|r"
L["Crystals"] = "Kristalle"
L["Current Profiles"] = "Aktuelle Profile"
L["CURRENT SEARCH"] = "AKTUELLE SUCHE"
L["CUSTOM POST"] = "EIGENES ERSTELLEN"
L["Custom Price"] = "Eigener Preis"
L["Custom Price Source"] = "Eigene Preisquelle"
L["Custom Sources"] = "Eigene Quellen"
L["Database Sources"] = "Datenbankquellen"
L["Default Craft Value Method:"] = "Standardmethode zur Ermittlung des Marktwertes:"
L["Default Material Cost Method:"] = "Standardmethode für Materialkosten:"
L["Default Price"] = "Standardpreis"
L["Default Price Configuration"] = "Konfiguration von Standardpreisen"
--[[Translation missing --]]
L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
L["Delete Profile Confirmation"] = "Löschen des Profils bestätigen"
--[[Translation missing --]]
L["Delete this record?"] = "Delete this record?"
L["Deposit"] = "Anzahlung"
L["Deposit Cost"] = "Anzahlungs-Kosten"
L["Deposit Price"] = "Anzahlungs-Preis"
L["DEPOSIT REAGENTS"] = "REAGENZIEN EINLAGERN"
L["Deselect All Groups"] = "Alle Gruppen abwählen"
L["Deselect All Items"] = "Alle Items abwählen"
L["Destroy Next"] = "Nächstes zerstören"
L["Destroy Value"] = "Zerstörungswert"
L["Destroy Value Source"] = "Zerstörungswertquelle"
L["Destroying"] = "Destroying"
L["Destroying 'DESTROY NEXT' Button"] = "Destroying-Button 'NÄCHSTES ZERSTÖREN'"
L["Destroying Tooltips"] = "Destroying-Tooltips"
L["Destroying..."] = "Zerstören..."
L["Details"] = "Details"
L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Schwellenwert zum Abbrechen einer Auktion, um sie neu zu erstellen (%s), ungültig ist. Überprüfe deine Einstellungen."
L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Höchstpreis (%s) ungültig ist. Überprüfe deine Einstellungen."
L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Höchstpreis (%s) niedriger ist als dein Mindestpreis (%s). Überprüfe deine Einstellungen."
L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Mindestpreis (%s) ungültig ist. Überprüfe deine Einstellungen."
L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein normaler Preis (%s) ungültig ist. Überprüfe deine Einstellungen."
L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein normaler Preis (%s) niedriger ist als dein Mindestpreis (%s). Überprüfe deine Einstellungen."
L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Unterbieten (%s) ungültig ist. Überprüfe deine Einstellungen."
L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Die Auktion von %s wurde nicht erstellt, weil Blizzard nicht alle notwendigen Informationen dafür bereitgestellt hat. Versuche es später noch einmal."
L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Auktion für %s wurde nicht erstellt, da der Besitzer der günstigsten Auktion (%s) sowohl auf der schwarzen als auch auf der weißen Liste steht, was nicht erlaubt ist. Passe deine Einstellungen an, um dieses Problem zu beheben."
L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Auktion für %s wurde nicht erstellt, weil du oder einer deiner Twinks (%s) auf der schwarzen Liste steht, was nicht erlaubt ist. Entferne diesen Charakter aus deiner schwarzen Liste."
L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein Höchstpreis (%s) ungültig ist. Überprüfe deine Einstellungen."
L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein Höchstpreis (%s) niedriger ist als dein Mindestpreis (%s). Überprüfe deine Einstellungen."
L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein Mindestpreis (%s) ungültig ist. Überprüfe deine Einstellungen."
L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein normaler Preis (%s) ungültig ist. Überprüfe deine Einstellungen."
L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein normaler Preis (%s) niedriger ist als dein Mindestpreis (%s). Überprüfe deine Einstellungen."
L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein Unterbieten (%s) ungültig ist. Überprüfe deine Einstellungen."
L["Disable invalid price warnings"] = "Warnungen über ungültige Preise deaktivieren"
L["Disenchant Search"] = "Entzauberungssuche"
L["DISENCHANT SEARCH"] = "ENTZAUBERUNGSSUCHE"
L["Disenchant Search Options"] = "Optionen für die Entzauberungssuche"
L["Disenchant Value"] = "Entzauberungswert"
L["Disenchanting Options"] = "Entzauberungsoptionen"
L["Display auctioning values"] = "Auctioning-Werte anzeigen"
L["Display cancelled since last sale"] = "Auktionen anzeigen, die seit dem letzten Verkauf abgebrochen wurden"
L["Display crafting cost"] = "Herstellungskosten anzeigen"
L["Display detailed destroy info"] = "Detaillierte Destroying-Informationen anzeigen"
L["Display disenchant value"] = "Entzauberungswert anzeigen"
L["Display expired auctions"] = "Ausgelaufene Auktionen anzeigen"
L["Display group name"] = "Gruppennamen anzeigen"
L["Display historical price"] = "Historischen Preis anzeigen"
L["Display market value"] = "Marktwert anzeigen"
L["Display mill value"] = "Mahlenwert anzeigen"
L["Display min buyout"] = "Mindestsofortkaufpreis anzeigen"
L["Display Operation Names"] = "Operationsnamen anzeigen"
L["Display prospect value"] = "Sondierungswert anzeigen"
L["Display purchase info"] = "Einkaufsinformationen anzeigen"
L["Display region historical price"] = "Regionalen historischen Preis anzeigen"
L["Display region market value avg"] = "Regionalen Durchschnitt des Marktwerts anzeigen"
L["Display region min buyout avg"] = "Regionalen Durchschnitt des Mindestsofortkaufpreises anzeigen"
L["Display region sale avg"] = "Regionalen Durchschnitt des Verkaufspreises anzeigen"
L["Display region sale rate"] = "Regionale Verkaufsrate anzeigen"
L["Display region sold per day"] = "Regionalen Durchschnitt täglicher Verkäufe anzeigen"
L["Display sale info"] = "Verkaufsinformationen anzeigen"
L["Display sale rate"] = "Verkaufsrate anzeigen"
L["Display shopping max price"] = "Maximalen Einkaufspreis anzeigen"
L["Display total money recieved in chat?"] = "Gesamtmenge des erhaltenen Goldes im Chat anzeigen?"
L["Display transform value"] = "Transformierungswert anzeigen"
L["Display vendor buy price"] = "Händlereinkaufpreis anzeigen"
L["Display vendor sell price"] = "Händlerverkaufpreis anzeigen"
L["Doing so will also remove any sub-groups attached to this group."] = "Dadurch werden auch alle Untergruppen entfernt, die mit dieser Gruppe verbunden sind."
L["Done Canceling"] = "Abbrechen abgeschlossen"
L["Done Posting"] = "Erfolgreich Auktion erstellt"
--[[Translation missing --]]
L["Done rebuilding item cache."] = "Done rebuilding item cache."
L["Done Scanning"] = "Scannen erledigt"
L["Don't post after this many expires:"] = "Keine Auktionserstellung nach so vielen abgelaufenen Auktionen:"
L["Don't Post Items"] = "Keine Items auktionieren"
L["Don't prompt to record trades"] = "Keine Rückfrage zur Protokollierung von Handelsaktivitäten"
L["DOWN"] = "Runter"
L["Drag in Additional Items (%d/%d Items)"] = "Füge weitere Items ein (%d/%d Items)"
L["Drag Item(s) Into Box"] = "Ziehe Items in dieses Feld"
L["Duplicate"] = "Kopieren"
L["Duplicate Profile Confirmation"] = "Profil-Kopie Bestätigen"
L["Dust"] = "Staub"
L["Elevate your gold-making!"] = "Beschleunige dein Gold-Einkommen!"
L["Embed TSM tooltips"] = "TSM-Tooltip in den Standard-Tooltip integrieren"
L["EMPTY BAGS"] = "TASCHE LEEREN"
L["Empty parentheses are not allowed"] = "Leere Klammern sind nicht erlaubt"
L["Empty price string."] = "Leerer Preistext."
L["Enable automatic stack combination"] = "Automatisches Zusammenführen von Stapeln aktivieren"
L["Enable buying?"] = "Kaufen aktivieren?"
L["Enable inbox chat messages"] = "Posteingang-Chatnachrichten aktivieren"
L["Enable restock?"] = "Wiederauffüllen aktivieren?"
L["Enable selling?"] = "Verkaufen aktivieren?"
L["Enable sending chat messages"] = "Senden-Chatnachrichten aktivieren"
L["Enable TSM Tooltips"] = "TSM-Tooltips aktivieren"
L["Enable tweet enhancement"] = "Tweet-Erweiterung aktivieren"
L["Enchant Vellum"] = "Pergament verzaubern"
--[[Translation missing --]]
L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
L["Enter a name for the new profile"] = "Trage einen Namen für das neue Profil ein"
L["Enter Filter"] = "Filter eintragen"
L["Enter Keyword"] = "Suchbegriff eingeben"
L["Enter name of logged-in character from other account"] = "Trage den Namen eines anderen angemeldeten Charakters ein"
L["Enter player name"] = "Spielername eintragen"
L["Essences"] = "Essenzen"
L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Verbindung mit %s wird hergestellt. Achte darauf, dass dieser Charaktername im anderen Account angegeben ist."
L["Estimated Cost:"] = "Geschätzte Kosten:"
--[[Translation missing --]]
L["Estimated deliver time"] = "Estimated deliver time"
L["Estimated Profit:"] = "Geschätzter Gewinn:"
L["Exact Match Only?"] = "Nur exakte Übereinstimmung?"
L["Exclude crafts with cooldowns"] = "Rezepte mit Abklingzeiten ausschließen"
L["Expand All Groups"] = "Alle Gruppen aufklappen"
L["Expenses"] = "Ausgaben"
L["EXPENSES"] = "AUSGABEN"
L["Expirations"] = "Ausgelaufene Auktionen"
L["Expired"] = "Abgelaufen"
L["Expired Auctions"] = "Ausgelaufene Auktionen"
L["Expired Since Last Sale"] = "Abgelaufen seit letztem Verkauf"
L["Expires"] = "Läuft ab"
L["EXPIRES"] = "ABGELAUFENE"
L["Expires Since Last Sale"] = "Ausgelaufene Auktionen seit letztem Verkauf"
L["Expiring Mails"] = "Auslaufende Mails"
L["Exploration"] = "Erkundung"
L["Export"] = "Export"
L["Export List"] = "Exportliste"
L["Failed Auctions"] = "Gescheiterte Auktionen"
L["Failed Since Last Sale (Expired/Cancelled)"] = "Fehlgeschlagen seit letztem Verkauf (Abgelaufen/Abgebrochen)"
--[[Translation missing --]]
L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
L["Failed to bid on auction of %s."] = "Fehler beim Bieten auf Auktion von %s."
--[[Translation missing --]]
L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
L["Failed to buy auction of %s."] = "Fehler beim Kaufen der Auktion von %s."
L["Failed to find auction for %s, so removing it from the results."] = "Eine Auktion für %s konnte nicht gefunden werden und wurde aus den Ergebnissen entfernt."
--[[Translation missing --]]
L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
L["Failed to send profile."] = "Profil senden fehlgeschlagen"
--[[Translation missing --]]
L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
L["Favorite Scans"] = "Favorisierte Scans"
L["Favorite Searches"] = "Favorisierte Suchanfragen"
L["Filter Auctions by Duration"] = "Auktionen anhand ihrer Laufzeit filtern"
L["Filter Auctions by Keyword"] = "Auktionen nach Suchwort filtern"
L["Filter by Keyword"] = "Nach Suchwort filtern"
L["FILTER BY KEYWORD"] = "NACH SUCHWORT FILTERN"
L["Filter group item lists based on the following price source"] = "Gruppierte Itemlisten anhand folgender Preisquelle filtern:"
L["Filter Items"] = "Items filtern"
L["Filter Shopping"] = "Shopping filtern"
L["Finding Selected Auction"] = "Suche ausgewählte Auktion"
L["Fishing Reel In"] = "Angelrolle"
L["Forget Character"] = "Charakter vergessen"
L["Found auction sound"] = "Sound, wenn eine Auktion gefunden wurde"
L["Friends"] = "Freunde"
L["From"] = "Von"
L["Full"] = "Vollständig"
L["Garrison"] = "Garnison"
L["Gathering"] = "Sammeln"
L["Gathering Search"] = "Sammelsuche"
L["General Options"] = "Allgemeine Optionen"
L["Get from Bank"] = "Aus Bank nehmen"
L["Get from Guild Bank"] = "Aus Gildenbank nehmen"
L["Global Operation Confirmation"] = "Globale Bestätigung für Operationen"
L["Gold"] = "Gold"
L["Gold Earned:"] = "Gold bekommen:"
L["GOLD ON HAND"] = "VERFÜGBARES GOLD"
L["Gold Spent:"] = "Gold ausgegeben:"
L["GREAT DEALS SEARCH"] = "SCHNÄPPCHENSUCHE"
L["Group already exists."] = "Gruppe besteht bereits."
L["Group Management"] = "Gruppenverwaltung"
L["Group Operations"] = "Gruppenoperationen"
L["Group Settings"] = "Gruppeneinstellungen"
L["Grouped Items"] = "Gruppierte Items"
L["Groups"] = "Gruppen"
L["Guild"] = "Gilde"
L["Guild Bank"] = "Gildenbank"
L["GVault"] = "GTresor"
L["Have"] = "Haben"
L["Have Materials"] = "Materialien verfügbar"
L["Have Skill Up"] = "Kann die Berufsstufe erhöhen"
L["Hide auctions with bids"] = "Auktionen mit Geboten nicht anzeigen"
L["Hide Description"] = "Beschreibung ausblenden"
L["Hide minimap icon"] = "Minikartensymbol ausblenden"
L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Verberge das TSM Banking Interface. Tippe '/tsm bankui' um es erneut zu öffnen."
L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Die TSM Aufgabenliste wird ausgeblendet. Tippe '/tsm tasklist', um sie erneut zu öffnen."
L["High Bidder"] = "Höchstbietender"
L["Historical Price"] = "Historischerpreis"
L["Hold ALT to repair from the guild bank."] = "Halte ALT und auf Kosten der Gildenbank zu reparieren."
--[[Translation missing --]]
L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
L["Hr"] = "Std"
L["Hrs"] = "Std"
L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "Ich habe soeben [%s]x%d für %s gekauft! %s #TSM4 #warcraft"
L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "Ich habe soeben [%s] für %s verkauft! %s #TSM4 #warcraft"
L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "Wenn du einen anderen Spieler nicht unterbieten möchtest, kannst du ihn zu deiner weißen Liste hinzufügen. TSM wird diesen Spieler nicht unterbieten. Hinweis: Wenn ein Spieler aus deiner weißen Liste mit deinem Sofortkaufpreis übereinstimmt, aber ein niedrigeres Gebot aufführt, wird TSM weiterhin davon ausgehen, dass er dich unterbieten will."
L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Wenn du mehrere Profile mit diesen Operationen eingerichtet hast, wird das Aktivieren dieser Einstellung dazu führen, dass so gut wie alle Operationen des aktuellen Profils unwiderruflich verloren gehen. Willst du wirklich fortfahren?"
L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "Wenn du die Twitter-Integration von WoW hast, wird TSM einen Share-Link zu den erweiterten Nachrichten beim Verkauf/Einkauf von Auktionen hinzufügen sowie alle URLs mit einem TSM-Link ersetzen."
L["Ignore Auctions Below Min"] = "Auktionen unter Minimum ignorieren"
L["Ignore auctions by duration?"] = "Auktionen anhand ihrer Laufzeit ignorieren?"
L["Ignore Characters"] = "Charaktere ignorieren"
L["Ignore Guilds"] = "Gilden ignorieren"
--[[Translation missing --]]
L["Ignore item variations?"] = "Ignore item variations?"
L["Ignore operation on characters:"] = "Operation ignorieren bei den Charakteren:"
L["Ignore operation on faction-realms:"] = "Operation ignorieren auf den Fraktionsrealms:"
L["Ignored Cooldowns"] = "Ignorierte Abklingzeiten"
L["Ignored Items"] = "Ignorierte Items"
L["ilvl"] = "ilvl"
L["Import"] = "Importieren"
L["IMPORT"] = "IMPORTIEREN"
L["Import %d Items and %s Operations?"] = "Sollen %d Items und %s Operationen importiert werden?"
L["Import Groups & Operations"] = "Gruppen & Operationen importieren"
L["Imported Items"] = "Importierte Items"
L["Inbox Settings"] = "Posteingang-Einstellungen"
L["Include Attached Operations"] = "Zugewiesene Operationen einbeziehen"
L["Include operations?"] = "Operationen einbeziehen?"
L["Include soulbound items"] = "Seelengebundene Items einbeziehen"
L["Information"] = "Informationen"
L["Invalid custom price entered."] = "Ungültiger eigener Preis eingegeben."
L["Invalid custom price source for %s. %s"] = "Ungültige eigene Preisquelle für %s. %s"
L["Invalid custom price."] = "Ungültiger eigener Preis."
L["Invalid function."] = "Ungültige Funktion."
--[[Translation missing --]]
L["Invalid gold value."] = "Invalid gold value."
L["Invalid group name."] = "Ungültiger Gruppenname."
--[[Translation missing --]]
L["Invalid import string."] = "Invalid import string."
L["Invalid item link."] = "Ungültiger Item-Link."
L["Invalid operation name."] = "Ungültiger Operationsname."
L["Invalid operator at end of custom price."] = "Ungültiger Operator am Ende des eigenen Preises."
L["Invalid parameter to price source."] = "Ungültiger Parameter für Preisquelle."
L["Invalid player name."] = "Ungültiger Spielername."
L["Invalid price source in convert."] = "Ungültige Preisquelle in Formel."
L["Invalid price source."] = "Ungültige Preisquelle"
L["Invalid search filter"] = "Ungültiges Suchwort"
L["Invalid seller data returned by server."] = "Ungültige Daten zum Verkäufer vom Server gemeldet."
L["Invalid word: '%s'"] = "Ungültiges Wort: '%s'"
L["Inventory"] = "Inventar"
--[[Translation missing --]]
L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
L["Inventory / Mailing"] = "Inventar / Mailing"
L["Inventory Options"] = "Inventaroptionen"
L["Inventory Tooltip Format"] = "Anzeigeformat des Inventars im Tooltip"
--[[Translation missing --]]
L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
L["Item"] = "Item"
L["ITEM CLASS"] = "GEGENSTANDSKLASSE"
L["Item Level"] = "Item Level"
L["ITEM LEVEL RANGE"] = "BEREICH DER ITEMSTUFE"
L["Item links may only be used as parameters to price sources."] = "Item-Links dürfen nur als Parameter für Preisquellen verwendet werden."
L["Item Name"] = "Name des Items"
L["Item Quality"] = "Item Qualität"
L["ITEM SEARCH"] = "ITEM SUCHE"
L["ITEM SELECTION"] = "ITEM AUSWAHL"
L["ITEM SUBCLASS"] = "GEGENSTAND UNTERKATEGORIE"
L["Item Value"] = "Item Wert"
L["Item/Group is invalid (see chat)."] = "Gegenstand/Gruppe ist ungültig (siehe Chat)."
L["ITEMS"] = "ITEMS"
L["Items"] = "Items"
L["Items in Bags"] = "Items in der Tasche"
L["Keep in bags quantity:"] = "In der Tasche zu behaltene Menge:"
L["Keep in bank quantity:"] = "In der Bank zu behaltene Menge:"
L["Keep posted:"] = "Auktionen behalten:"
L["Keep quantity:"] = "Anzahl behalten:"
L["Keep this amount in bags:"] = "Diese Anzahl in den Taschen behalten:"
L["Keep this amount:"] = "Diese Anzahl behalten:"
L["Keeping %d."] = "Behalte %d."
L["Keeping undercut auctions posted."] = "Behalte unterbotene Auktionen."
L["Last 14 Days"] = "Letzten 14 Tage"
L["Last 3 Days"] = "Letzten 3 Tage"
L["Last 30 Days"] = "Letzten 30 Tage"
L["LAST 30 DAYS"] = "LETZTEN 30 TAGE"
L["Last 60 Days"] = "Letzten 60 Tage"
L["Last 7 Days"] = "Letzten 7 Tage"
L["LAST 7 DAYS"] = "LETZTEN 7 TAGE"
L["Last Data Update:"] = "Letztes Datenupdate:"
L["Last Purchased"] = "Letzter Einkauf"
L["Last Sold"] = "Letzter Verkauf"
L["Level Up"] = "Stufe aufgestiegen"
L["LIMIT"] = "LIMIT"
L["Link to Another Operation"] = "Verbinde mit einer anderen Operation"
L["List"] = "Liste"
L["List materials in tooltip"] = "Materialien im Tooltip auflisten"
L["Loading Mails..."] = "Lade Mails..."
L["Loading..."] = "Laden..."
L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Es scheint so, als wäre TradeSkillMaster auf einen Fehler gestoßen. Du kannst dem Autor dabei helfen, diesen Fehler zu beheben, indem du die folgenden Anweisungen befolgst."
L["Loop detected in the following custom price:"] = "Schleife im folgenden eigenen Preis entdeckt:"
L["Lowest auction by whitelisted player."] = "Günstigste Auktion von Spieler aus weißer Liste."
L["Macro created and scroll wheel bound!"] = "Makro erstellt und mit Mausrad verbunden!"
L["Macro Setup"] = "Makro-Setup"
L["Mail"] = "Briefk"
L["Mail Disenchantables"] = "Entzauberbare Items versenden"
L["Mail Disenchantables Max Quality"] = "Entzauberbare Items versenden mit maximaler Qualität:"
L["MAIL SELECTED GROUPS"] = "AN AUSGEWÄHLTE GRUPPEN SENDEN"
L["Mail to %s"] = "Post an %s"
L["Mailing"] = "Mailing"
L["Mailing all to %s."] = "Sende alles an %s."
L["Mailing Options"] = "Mailing-Optionen"
L["Mailing up to %d to %s."] = "Sende bis zu %d an %s."
L["Main Settings"] = "Grundeinstellungen"
L["Make Cash On Delivery?"] = "Mit Nachnahmegebühr?"
L["Management Options"] = "Verwaltungsoptionen"
L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Viele häufig verwendete Aktionen in TSM können in ein Makro umgewandelt und an dein Mausrad gebunden werden. Benutze dazu die folgenden Optionen."
L["Map Ping"] = "Klick auf Minimap"
L["Market Value"] = "Marktwert"
L["Market Value Price Source"] = "Marktwert-Preisquelle"
L["Market Value Source"] = "Marktwertquelle"
L["Mat Cost"] = "Mat Kosten"
L["Mat Price"] = "Mat Preis"
L["Match stack size?"] = "Nur mit Angeboten gleicher Stackgröße konkurrieren?"
L["Match whitelisted players"] = "Spieler aus der weißen Liste überprüfen"
L["Material Name"] = "Materialname"
L["Materials"] = "Materialien"
L["Materials to Gather"] = "Zu sammelnde Materialien"
L["MAX"] = "MAX"
L["Max Buy Price"] = "Max Kaufpreis"
L["MAX EXPIRES TO BANK"] = "MAX ABLÄUFE ZUR BANK"
L["Max Sell Price"] = "Max Verkaufpreis"
L["Max Shopping Price"] = "Maximaler Einkaufspreis"
L["Maximum amount already posted."] = "Maximale Anzahl von Auktionen bereits erstellt."
L["Maximum Auction Price (Per Item)"] = "Maximaler Auktionspreis (pro Item)"
L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximaler Zerstörungswert (Trage '0c' ein, um es zu deaktivieren)"
L["Maximum disenchant level:"] = "Maximale Entzauberungsstufe:"
L["Maximum Disenchant Quality"] = "Maximale Entzauberungsqualität:"
L["Maximum disenchant search percentage:"] = "Maximaler Prozentsatz der Entzauberungssuche:"
L["Maximum Market Value (Enter '0c' to disable)"] = "Maximaler Marktwert (Trage '0c' ein, um es zu deaktivieren)"
L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMALMENGE ZUM KAUFEN:"
L["Maximum quantity:"] = "Maximale Menge:"
L["Maximum restock quantity:"] = "Maximale Wiederauffüllungsmenge:"
L["Mill Value"] = "Mahlenwert"
L["Min"] = "Min"
L["Min Buy Price"] = "Min Kaufpreis"
L["Min Buyout"] = "Min Sofortkaufpreis"
L["Min Sell Price"] = "Min Verkaufpreis"
L["Min/Normal/Max Prices"] = "Min/Normal/Max Preise"
L["Minimum Days Old"] = "Mindestens folgende Tage alt"
L["Minimum disenchant level:"] = "Minimale Entzauberungsstufe:"
L["Minimum expires:"] = "Minimum abgelaufene Items:"
L["Minimum profit:"] = "Mindestgewinn"
L["MINIMUM RARITY"] = "MINIMALE RARITÄT"
L["Minimum restock quantity:"] = "Minimale Wiederauffüllungsmenge:"
L["Misplaced comma"] = "Falsch gesetztes Komma"
L["Missing Materials"] = "Fehlende Materialien"
--[[Translation missing --]]
L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
L["Modifiers:"] = "Modifikatoren:"
L["Money Frame Open"] = "Geldfenster öffnen"
L["Money Transfer"] = "Geldtransfer"
L["Most Profitable Item:"] = "Ertragreichstes Item:"
L["MOVE"] = "BEWEGEN"
L["Move already grouped items?"] = "Bereits gruppierte Items verschieben?"
L["Move Quantity Settings"] = "Einstellungen für das Verschieben von Mengen"
L["MOVE TO BAGS"] = "IN TASCHE SCHIEBEN"
L["MOVE TO BANK"] = "IN BANK SCHIEBEN"
L["MOVING"] = "BEWEGEN"
L["Moving"] = "Bewegen"
L["Multiple Items"] = "Mehrere Gegenstände"
L["My Auctions"] = "Meine Auktionen"
L["My Auctions 'CANCEL' Button"] = "Meine Auktionen-Button 'ABBRECHEN'"
L["Neat Stacks only?"] = "Nur gleichmäßige Stapel?"
L["NEED MATS"] = "KEINE MATS"
L["New Group"] = "Neue Gruppe"
L["New Operation"] = "Neue Operation"
L["NEWS AND INFORMATION"] = "NEWS UND INFORMATIONEN"
L["No Attachments"] = "Keine Anhänge"
L["No Crafts"] = "Keine Rezepte"
L["No Data"] = "Keine Daten"
L["No group selected"] = "Keine Gruppe ausgewählt"
L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "Kein Gegenstand spezifiziert. Nutze: /tsm restock_help [ITEM_LINK]"
L["NO ITEMS"] = "KEINE ITEMS"
L["No Materials to Gather"] = "Keine zu sammelnden Materialien"
L["No Operation Selected"] = "Keine Operation ausgewählt"
L["No posting."] = "Keine Auktion erstellen."
L["No Profession Opened"] = "Keinen Beruf geöffnet"
L["No Profession Selected"] = "Keinen Beruf ausgewählt"
L["No profile specified. Possible profiles: '%s'"] = "Kein Profil angegeben. Mögliche Profile: '%s'"
L["No recent AuctionDB scan data found."] = "Keine aktuellen AuctionDB Scan-Daten gefunden."
L["No Sound"] = "Kein Sound"
L["None"] = "Nichts"
L["None (Always Show)"] = "Keine (immer zeigen)"
L["None Selected"] = "Nichts ausgewählt"
L["NONGROUP TO BANK"] = "NICHT-GRUPPIERT ZUR BANK"
L["Normal"] = "Normal"
L["Not canceling auction at reset price."] = "Wird nicht abgebrochen, Auktion bei Reset-Preis."
L["Not canceling auction below min price."] = "Wird nicht abgebrochen, Auktion unter Mindestpreis."
L["Not canceling."] = "Wird nicht abgebrochen."
L["Not Connected"] = "Nicht verbunden"
L["Not enough items in bags."] = "Nicht genügend Gegenstände in den Taschen."
L["NOT OPEN"] = "AUFSUCHEN"
L["Not Scanned"] = "Nicht gescannt"
--[[Translation missing --]]
L["Nothing to move."] = "Nothing to move."
L["NPC"] = "NPC"
L["Number Owned"] = "Anzahl in Besitz"
L["of"] = "von"
L["Offline"] = "Offline"
L["On Cooldown"] = "Auf Abklingzeit"
L["Only show craftable"] = "Nur herstellbare Items"
L["Only show items with disenchant value above custom price"] = "Nur Items mit einem Entzauberungswert über dem eigenen Preis anzeigen"
L["OPEN"] = "ÖFFNEN"
L["OPEN ALL MAIL"] = "ALLE MAILS ÖFFNEN"
L["Open Mail"] = "Mail öffnen"
L["Open Mail Complete Sound"] = "Sound, wenn das Öffnen der Mails fertig ist"
L["Open Task List"] = "Aufgabenliste öffnen"
L["Operation"] = "Operation"
L["Operations"] = "Operationen"
L["Other Character"] = "Anderer Charakter"
L["Other Settings"] = "Sonstige Einstellungen"
L["Other Shopping Searches"] = "Sonstige Suchfunktionen"
L["Override default craft value method?"] = "Die Standardmethode zur Ermittlung des Marktwertes überschreiben?"
L["Override parent operations"] = "Übergeordnete Operationen überschreiben"
L["Parent Items"] = "Übergeordnete Gegenstände"
L["Past 7 Days"] = "Letzen 7 Tage"
L["Past Day"] = "Letzter Tag"
L["Past Month"] = "Letzter Monat"
L["Past Year"] = "Letztes Jahr"
L["Paste string here"] = "Zeichenfolge hier einfügen"
L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Füge deine Import-Zeichenfolge in das Feld unten ein und klicke auf 'IMPORTIEREN'. Du kannst alles importieren, von komma-getrennten Itemlisten bis hin zu ganzen Gruppen & Operationen."
L["Per Item"] = "Pro Item"
L["Per Stack"] = "Pro Stapel"
L["Per Unit"] = "Pro EInheit"
L["Player Gold"] = "Spielergold"
L["Player Invite Accept"] = "Spielereinladung akzeptieren"
L["Please select a group to export"] = "Bitte eine Gruppe für den Export auswählen"
L["POST"] = "EINSTELLEN"
L["Post at Maximum Price"] = "Zum Höchstpreis erstellen"
L["Post at Minimum Price"] = "Zum Mindestpreis erstellen"
L["Post at Normal Price"] = "Zum Normalpreis erstellen"
L["POST CAP TO BAGS"] = "HÖCHSTMENGE IN TASCHE SCHIEBEN"
L["Post Scan"] = "Einstellungsscan"
L["POST SELECTED"] = "AUSGEWÄHLTES EINSTELLEN"
L["POSTAGE"] = "VERSANDKOSTEN"
L["Postage"] = "Versandkosten"
L["Posted at whitelisted player's price."] = "Zum Preis des Spielers aus weißer Liste gelistet."
L["Posted Auctions %s:"] = "Gelistete Auktionen %s:"
L["Posting"] = "Auktionserstellung"
L["Posting %d / %d"] = "Erstelle Auktion %d / %d"
L["Posting %d stack(s) of %d for %d hours."] = "Erstelle %d Stapel von %d für %d Stunden."
L["Posting at normal price."] = "Erstelle zum Normalpreis."
L["Posting at whitelisted player's price."] = "Erstelle zum Preis des Spielers aus der weißen Liste."
L["Posting at your current price."] = "Erstelle zu deinem aktuellen Preis."
L["Posting disabled."] = "Auktion erstellen deaktiviert."
L["Posting Settings"] = "Einstellungen für Auktionserstellungen"
L["Posts"] = "Angebote"
L["Potential"] = "Potential"
L["Price Per Item"] = "Preis pro Item"
L["Price Settings"] = "Einstellungen für Preise"
L["PRICE SOURCE"] = "PREISQUELLE"
L["Price source with name '%s' already exists."] = "Die Preisquelle mit dem Namen '%s' existiert bereits."
L["Price Variables"] = "Preisvariablen"
L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Preisvariablen ermöglichen es dir, anspruchsvollere eigene Preise innerhalb des Addons zu erstellen. Du kannst diese neuen Variablen auf die gleiche Weise wie die internen Preisquellen wie z. B. 'vendorsell' und 'vendorbuy' verwenden."
L["PROFESSION"] = "BERUF"
L["Profession Filters"] = "Berufsfilter"
L["Profession Info"] = "Berufs-Info"
L["Profession loading..."] = "Lade Beruf..."
L["Professions Used In"] = "Relevant für die Berufe"
L["Profile changed to '%s'."] = "Profil wurde auf '%s' geändert."
L["Profiles"] = "Profile"
L["PROFIT"] = "GEWINN"
L["Profit"] = "Gewinn"
L["Prospect Value"] = "Sondierungswert"
L["PURCHASE DATA"] = "KAUFDATEN"
L["Purchased (Min/Avg/Max Price)"] = "Gekauft (Min/Ø/Max Preis)"
L["Purchased (Total Price)"] = "Gekauft (Gesamtpreis)"
L["Purchases"] = "Einkäufe"
L["Purchasing Auction"] = "Kaufe Auktion"
L["Qty"] = "Anz"
L["Quantity Bought:"] = "Anzahl gekauft:"
L["Quantity Sold:"] = "Anzahl verkauft:"
L["Quantity to move:"] = "Anzahl zum bewegen:"
L["Quest Added"] = "Quest hinzugefügt"
L["Quest Completed"] = "Quest abgeschlossen"
L["Quest Objectives Complete"] = "Questziel erreicht"
L["QUEUE"] = "EINREIHEN"
L["Quick Sell Options"] = "Schnellverkauf-Optionen"
L["Quickly mail all excess disenchantable items to a character"] = "Überschuss an entzauberbaren Items an Charakter senden"
L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Goldüberschuss (begrenzt auf eine bestimmte Menge) an Charakter senden"
L["Raid Warning"] = "Schlachtzugwarnung"
L["Read More"] = "Mehr lesen"
L["Ready Check"] = "Bereitschaftscheck"
L["Ready to Cancel"] = "Bereit zum Abbrechen"
L["Realm Data Tooltips"] = "Realm-Daten-Tooltips"
L["Recent Scans"] = "Scanverlauf"
L["Recent Searches"] = "Suchverlauf"
L["Recently Mailed"] = "Kürzlich kontaktiert"
L["RECIPIENT"] = "EMPFÄNGER"
L["Region Avg Daily Sold"] = "Regionaler Ø täglicher Verkäufe"
L["Region Data Tooltips"] = "Regional-Daten-Tooltips"
L["Region Historical Price"] = "Regionaler historischer Preis"
L["Region Market Value Avg"] = "Regionaler Marktwert Ø"
L["Region Min Buyout Avg"] = "Regionaler Min Sofortkauf Ø"
L["Region Sale Avg"] = "Regionaler Verkaufs Ø"
L["Region Sale Rate"] = "Regionale Verkaufsrate"
L["Reload"] = "Neuladen"
--[[Translation missing --]]
L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
L["Removed a total of %s old records."] = "Es wurden insgesamt %s alte Daten entfernt."
L["Rename"] = "Umbennen"
L["Rename Profile"] = "Profil umbennen"
L["REPAIR"] = "REPARIEREN"
L["Repair Bill"] = "Reparaturrechnung"
--[[Translation missing --]]
L["Replace duplicate operations?"] = "Replace duplicate operations?"
L["REPLY"] = "ANTWORTEN"
L["REPORT SPAM"] = "SPAM MELDEN"
L["Repost Higher Threshold"] = "Erneute Auktionen mit höherem Schwellenwert erstellen:"
L["Required Level"] = "Erforderliche Stufe"
L["REQUIRED LEVEL RANGE"] = "ERFORDERLICHER STUFENBEREICH"
L["Requires TSM Desktop Application"] = "Benötigt TSM Desktop Application"
L["Resale"] = "Wiederverkauf"
L["RESCAN"] = "NEU SCANNEN"
L["RESET"] = "ZURÜCKSETZEN"
L["Reset All"] = "Leeren"
L["Reset Filters"] = "Filter leeren"
L["Reset Profile Confirmation"] = "Bestätigung zum Zurücksetzen des Profils"
L["RESTART"] = "NEU STARTEN"
L["Restart Delay (minutes)"] = "Neustartverzögerung (Minuten)"
L["RESTOCK BAGS"] = "TASCHE NEU AUFFÜLLEN"
L["Restock help for %s:"] = "Wiederauffüllungshilfe für %s:"
L["Restock Quantity Settings"] = "Einstellungen für die Wiederauffüllungsmenge"
L["Restock quantity:"] = "Wiederauffüllungsmenge:"
L["RESTOCK SELECTED GROUPS"] = "GEWÄHLTE GRUPPEN NEU AUFFÜLLEN"
L["Restock Settings"] = "Einstellungen für die Wiederauffüllung"
L["Restock target to max quantity?"] = "Bis zur Höchstmenge wieder auffüllen?"
L["Restocking to %d."] = "Fülle auf %d wieder auf."
L["Restocking to a max of %d (min of %d) with a min profit."] = "Fülle bis zu %d (min. auf %d) mit einem Mindestgewinn wieder auf."
L["Restocking to a max of %d (min of %d) with no min profit."] = "Fülle bis zu %d (min. auf %d) ohne Mindestgewinn wieder auf."
L["RESTORE BAGS"] = "TASCHE WIEDERHERSTELLEN"
L["Resume Scan"] = "Scan fortführen"
L["Retrying %d auction(s) which failed."] = "Wiederhole %d gescheiterte Auktion(en)."
L["Revenue"] = "Einnahmen"
L["Round normal price"] = "Normalen Preis runden"
L["RUN ADVANCED ITEM SEARCH"] = "ERWEITERTE GEGENSTANDSUCHE AUSFÜHREN"
L["Run Bid Sniper"] = "Gebot-Sniper starten"
L["Run Buyout Sniper"] = "Sofortkauf-Sniper starten"
L["RUN CANCEL SCAN"] = "Starte Abbruchsscan"
L["RUN POST SCAN"] = "Starte Einstellungsscan"
L["RUN SHOPPING SCAN"] = "STARTE KAUFSUCHE"
L["Running Sniper Scan"] = "Sniper-Scan läuft"
L["Sale"] = "Verkauf"
L["SALE DATA"] = "VERKAUFSDATEN"
L["Sale Price"] = "Verkaufspreis"
L["Sale Rate"] = "Verkaufsrate"
L["Sales"] = "Umsatz"
L["SALES"] = "VERKÄUFE"
L["Sales Summary"] = "Verkaufszusammenfassung"
L["SCAN ALL"] = "ALLE SCANNEN"
L["Scan Complete Sound"] = "Sound, wenn der Scan fertig ist"
L["Scan Paused"] = "Scan pausiert"
L["SCANNING"] = "SCANNEN"
L["Scanning %d / %d (Page %d / %d)"] = "Scanne %d / %d (Seite %d / %d)"
L["Scroll wheel direction:"] = "Richtung des Mausrades:"
L["Search"] = "Suche"
L["Search Bags"] = "Taschen durchsuchen"
L["Search Groups"] = "Gruppen durchsuchen"
L["Search Inbox"] = "Posteingang durchsuchen"
L["Search Operations"] = "Operationen durchsuchen"
L["Search Patterns"] = "Rezepte durchsuchen"
L["Search Usable Items Only?"] = "Nur benutzbare Gegenstände suchen?"
L["Search Vendor"] = "Händlersuche"
L["Select a Source"] = "Wähle eine Quelle"
L["Select Action"] = "Aktion auswählen"
L["Select All Groups"] = "Alle Gruppen auswählen"
L["Select All Items"] = "Alle Items auswählen"
L["Select Auction to Cancel"] = "Wähle eine Auktion zum abbrechen"
L["Select crafter"] = "Handwerker auswählen"
L["Select custom price sources to include in item tooltips"] = "Wähle eigene Preisquellen aus, um diese in den Tooltips der Items zu integrieren"
L["Select Duration"] = "Laufzeit auswählen"
L["Select Items to Add"] = "Wähle Items zum Hinzufügen aus"
L["Select Items to Remove"] = "Wähle Items zum Entfernen aus"
L["Select Operation"] = "Operation auswählen"
L["Select professions"] = "Berufe auswählen"
L["Select which accounting information to display in item tooltips."] = "Lege fest, welche Accounting-Informationen im Tooltip eines Items angezeigt werden sollen."
L["Select which auctioning information to display in item tooltips."] = "Lege fest, welche Auctioning-Informationen im Tooltip eines Items angezeigt werden sollen."
L["Select which crafting information to display in item tooltips."] = "Lege fest, welche Herstellungsinformationen im Tooltip eines Items angezeigt werden sollen."
L["Select which destroying information to display in item tooltips."] = "Lege fest, welche Destroying-Informationen im Tooltip eines Items angezeigt werden sollen."
L["Select which shopping information to display in item tooltips."] = "Lege fest, welche Shopping-Informationen im Tooltip eines Items angezeigt werden sollen."
L["Selected Groups"] = "Ausgewählte Gruppen"
L["Selected Operations"] = "Ausgewählte Operationen"
L["Sell"] = "Verkaufen"
L["SELL ALL"] = "ALLES VERKAUFEN"
L["SELL BOES"] = "Verkaufe BOES"
L["SELL GROUPS"] = "GRUPPEN VERKAUFEN"
L["Sell Options"] = "Verkaufs Optionen"
L["Sell soulbound items?"] = "Seelengebundene Items verkaufen?"
L["Sell to Vendor"] = "An Händler verkaufen"
L["SELL TRASH"] = "MÜLL VERKAUFEN"
L["Seller"] = "Verkäufer"
L["Selling soulbound items."] = "Verkaufe seelengebundene Items."
L["Send"] = "Senden"
L["SEND DISENCHANTABLES"] = "ENTZAUBERBARE ITEMS SENDEN"
L["Send Excess Gold to Banker"] = "Goldüberschuss an Banker senden"
L["SEND GOLD"] = "GOLD SENDEN"
L["Send grouped items individually"] = "Gruppierte Items einzeln versenden"
L["SEND MAIL"] = "MAIL SENDEN"
L["Send Money"] = "Gold senden"
L["Send Profile"] = "Profil senden"
L["SENDING"] = "SENDEN"
L["Sending %s individually to %s"] = "Sende %s einzeln an %s"
L["Sending %s to %s"] = "Sende %s an %s"
L["Sending %s to %s with a COD of %s"] = "Sende %s an %s mit einer Nachnahmegebühr von %s"
L["Sending Settings"] = "Senden-Einstellungen"
--[[Translation missing --]]
L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
L["SENDING..."] = "SENDEN..."
L["Set auction duration to:"] = "Voreingestellte Auktionslaufzeit wählen"
L["Set bid as percentage of buyout:"] = "Gebot als Prozentsatz des Sofortkaufpreises:"
L["Set keep in bags quantity?"] = "In der Tasche zu behaltene Menge setzen?"
L["Set keep in bank quantity?"] = "In der Bank zu behaltene Menge setzen?"
L["Set Maximum Price:"] = "Höchstpreis setzen:"
L["Set maximum quantity?"] = "Maximale Menge setzen?"
L["Set Minimum Price:"] = "Mindestpreis setzen:"
L["Set minimum profit?"] = "Mindestgewinn setzen?"
L["Set move quantity?"] = "Zu verschiebende Menge setzen?"
L["Set Normal Price:"] = "Normalpreis setzen:"
L["Set post cap to:"] = "Maximale Auktionserstellungen:"
L["Set posted stack size to:"] = "Stapelgröße des Angebots setzen auf:"
--[[Translation missing --]]
L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
L["Set stack size?"] = "Set stack size?"
L["Setup"] = "Setup"
L["SETUP ACCOUNT SYNC"] = "ACCOUNT SYNC EINSTELLEN"
L["Shards"] = "Splitter"
L["Shopping"] = "Shopping"
L["Shopping 'BUYOUT' Button"] = "Shopping-Button 'SOFORTKAUF'"
L["Shopping for auctions including those above the max price."] = "Kaufe Auktionen ein, einschließlich solcher über dem Höchstpreis."
L["Shopping for auctions with a max price set."] = "Kaufe Auktionen mit einem festgelegten Höchstpreis ein."
L["Shopping for even stacks including those above the max price"] = "Kaufe gleichmäßige Stapel ein, einschließlich solcher über dem Höchstpreis."
L["Shopping for even stacks with a max price set."] = "Kaufe gleichmäßige Stapel mit einem festgelegten Höchstpreis ein."
L["Shopping Tooltips"] = "Shopping-Tooltips"
L["SHORTFALL TO BAGS"] = "FEHLMENGE ZUR TASCHE"
L["Show auctions above max price?"] = "Auktionen über dem Höchstpreis anzeigen?"
L["Show confirmation alert if buyout is above the alert price"] = "Zeige Bestätigungs-Alarm wenn der Sofortkauf über dem Alarm-Preis liegt."
L["Show Description"] = "Zeige Beschreibung"
L["Show Destroying frame automatically"] = "Destroying-Fenster automatisch anzeigen"
L["Show material cost"] = "Materialkosten anzeigen"
L["Show on Modifier"] = "Beim Drücken folgender Zusatztaste anzeigen"
L["Showing %d Mail"] = "Zeige %d Sendung an"
L["Showing %d of %d Mail"] = "Zeige %d von %d Post"
L["Showing %d of %d Mails"] = "Zeige %d von %d Mails an"
L["Showing all %d Mails"] = "Zeige alle %d Mails an"
L["Simple"] = "Einfach"
L["SKIP"] = "NÄCHSTE"
--[[Translation missing --]]
L["Skip Import confirmation?"] = "Skip Import confirmation?"
L["Skipped: No assigned operation"] = "Übersprungen: Keine Operation zugewiesen"
L["Slash Commands:"] = "Slash-Befehle:"
--[[Translation missing --]]
L["Sniper"] = "Sniper"
L["Sniper 'BUYOUT' Button"] = "Sniper-Button 'SOFORTKAUF'"
L["Sniper Options"] = "Sniper-Optionen"
L["Sniper Settings"] = "Sniper-Einstellungen"
L["Sniping items below a max price"] = "Suche gezielt Items unter einem Höchstpreis"
L["Sold"] = "Verkauft"
--[[Translation missing --]]
L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
L["Sold %s worth of items."] = "Items im Wert von %s verkauft."
L["Sold (Min/Avg/Max Price)"] = "Verkauft (Min/Ø/Max Preis)"
L["Sold (Total Price)"] = "Verkauft (Gesamtpreis)"
L["Sold [%s]x%d for %s to %s"] = "Verkauft [%s]x%d für %s an %s"
L["Sold Auctions %s:"] = "Auktionen verkauft: %s"
L["Source"] = "Quelle"
L["SOURCE %d"] = "QUELLE %d"
L["SOURCES"] = "QUELLEN"
L["Sources"] = "Quellen"
L["Sources to include for restock:"] = "Einzubeziehende Quellen zum Auffüllen:"
L["Stack"] = "Stapel"
L["Stack / Quantity"] = "Stapel / Anzahl"
L["Stack size multiple:"] = "Stapelgröße mehrfach:"
L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Klicke auf einen der Buttons oben, um einen Sofortkauf- oder Gebot-Sniper zu starten."
L["Starting Scan..."] = "Starte Scan..."
L["STOP"] = "STOP"
L["Store operations globally"] = "Operationen global speichern"
L["Subject"] = "Betreff"
L["SUBJECT"] = "BETREFF"
--[[Translation missing --]]
L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
L["Switch to %s"] = "Zum %s wechseln"
L["Switch to WoW UI"] = "Zum WoW UI"
L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync-Setup-Fehler: Der angegebene Spieler ist auf dem anderen Account gerade offline."
L["Sync Setup Error: This character is already part of a known account."] = "Sync-Setup-Fehler: Dieser Charakter gehört bereits zu einem bekannten Account."
L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync-Setup-Fehler: Du hast nicht den Charakter auf dem anderen Account, sondern den Namen des aktuellen Charakters eingegeben."
--[[Translation missing --]]
L["Sync Status"] = "Sync Status"
L["TAKE ALL"] = "ALLES NEHMEN"
L["Take Attachments"] = "Anhänge nehmen"
L["Target Character"] = "Zielcharakter"
L["TARGET SHORTFALL TO BAGS"] = "ZIELFEHLMENGE ZUR TASCHE"
L["Tasks Added to Task List"] = "Aufgabe wurde zur Aufgabenliste hinzugefügt"
L["Text (%s)"] = "Text (%s)"
L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "Der Canlearn-Filter wurde ignoriert, da das Addon CanIMogIt nicht gefunden wurde."
L["The 'Craft Value Method' (%s) did not return a value for this item."] = "Die Ermittlung des Marktwertes für dieses Item ergab keinen gültigen Preis, verwendete Methode: (%s)"
L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "Die Preisquelle 'disenchant' wurde mit der allgemeineren Preisquelle 'destroy' ersetzt. Bitte aktualisiere deine eigenen Preise."
L["The min profit (%s) did not evalulate to a valid value for this item."] = "Der errechnete Mindestgewinn (%s) ist kein gültiger Wert für dieses Item."
L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "Der Name darf NUR Buchstaben enthalten. Leerzeichen, Zahlen oder Sonderzeichen sind nicht erlaubt."
L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "Die einzureihende Menge (%d) ist kleiner als die minimale Wiederauffüllungsmenge (%d)."
L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "Die angewandte Operation auf dieses Item ist ungültig! Die minimale Wiederauffüllungsmenge von %d ist höher als die maximale Wiederauffüllungsmenge von %d."
L["The player \"%s\" is already on your whitelist."] = "Der Spieler \"%s\" ist bereits auf deiner weißen Liste."
L["The profit of this item (%s) is below the min profit (%s)."] = "Der Gewinn für dieses Item (%s) ist kleiner als der Mindestgewinn (%s)."
--[[Translation missing --]]
L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "Der Unlearned-Filter wurde ignoriert, da das Addon CanIMogIt nicht gefunden wurde."
--[[Translation missing --]]
L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Dies ist kein gültiger Profilname. Profilnamen müssen mindestens 1 Zeichen lang sein und dürfen keine @-Zeichen enthalten."
L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "Dieses Item hat keine Herstellungskosten. Überprüfe, ob all seine Materialien Materialpreise haben."
L["This item is not in a TSM group."] = "Dieser Gegenstand ist in keiner TSM Gruppe."
--[[Translation missing --]]
L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
L["This looks like an exported operation and not a custom price."] = "Dies sieht aus wie eine exportierte Operation und nicht wie ein eigener Preis."
L["This will copy the settings from '%s' into your currently-active one."] = "Kopiere die Einstellungen von Profil '%s' in dein derzeit aktiviertes Profil?"
L["This will permanently delete the '%s' profile."] = "Dies wird das Profil '%s‘ dauerhaft löschen."
L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "Dieser Vorgang wird alle Gruppen und Operationen (sofern nicht global gespeichert) zurücksetzen, um sie aus diesem Profil zu tilgen."
L["Time"] = "Zeit"
L["Time Format"] = "Zeitformat"
L["Time Frame"] = "Zeitraum"
L["TIME FRAME"] = "ZEITRAUM"
L["TINKER"] = "BASTELN"
L["Tooltip Price Format"] = "Preisformat im Tooltip"
L["Tooltip Settings"] = "Tooltip-Einstellungen"
L["Top Buyers:"] = "Top Käufe:"
L["Top Item:"] = "Top Item:"
L["Top Sellers:"] = "Top Verkäufe:"
L["Total"] = "Anz"
L["Total Gold"] = "Summe Gold"
L["Total Gold Collected: %s"] = "Summe Gold abgeholt: %s"
L["Total Gold Earned:"] = "Summe Gold verdient:"
L["Total Gold Spent:"] = "Summe Gold ausgegeben:"
L["Total Price"] = "Gesamtpreis"
L["Total Profit:"] = "Gesamter Gewinn:"
L["Total Value"] = "Gesamtwert"
L["Total Value of All Items"] = "Gesamtwert aller Items"
L["Track Sales / Purchases via trade"] = "Verkäufe / Einkäufe via Handel protokollieren"
L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
L["Transform Value"] = "Transformierungswert"
L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
L["TSM Crafting"] = "TSM Crafting"
L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM konnte einige Auktionen nicht scannen. Bitte starte den Scan erneut."
--[[Translation missing --]]
L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM fehlen wichtige Informationen aus der TSM-Desktop-App. Bitte stell sicher, dass die TSM-Desktop-App läuft und ordnungsgemäß konfiguriert ist."
L["TSM Mailing"] = "TSM Mailing"
L["TSM TASK LIST"] = "TSM AUFGABENLISTE"
L["TSM Vendoring"] = "TSM Vendoring"
L["TSM Version Info:"] = "TSM-Versionsinfo:"
L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting hat festgestellt, dass du gerade %s %s gegen %s getauscht hast. Möchtest du, dass Accounting eine Aufzeichnung dieses Handels speichert?"
L["TSM4"] = "TSM4"
--[[Translation missing --]]
L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
L["TUJ 3-Day Price"] = "TUJ 3-Tage-Preis"
--[[Translation missing --]]
L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
L["TUJ Global Median"] = "TUJ Global Median"
L["Twitter Integration"] = "Twitter-Integration"
L["Twitter Integration Not Enabled"] = "Twitter Integration wurde nicht aktiviert"
L["Type"] = "Typ"
L["Type Something"] = "Schreibe etwas"
--[[Translation missing --]]
L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
L["Unbalanced parentheses."] = "Ungleichmäßige Klammerung."
L["Undercut amount:"] = "Unterbietungsbetrag:"
L["Undercut by whitelisted player."] = "Unterboten von Spieler aus weißer Liste."
L["Undercutting blacklisted player."] = "Unterbiete Spieler aus schwarzer Liste."
L["Undercutting competition."] = "Unterbiete Wettbewerber."
L["Ungrouped Items"] = "Nicht gruppierte Items"
L["Unknown Item"] = "Unbekanntes Item"
L["Unwrap Gift"] = "Geschenk auspacken"
L["Up"] = "Hoch"
L["Up to date"] = "Aktuell"
L["UPDATE EXISTING MACRO"] = "VORHANDENES MAKRO AKTUALISIEREN"
L["Updating"] = "Wird aktualisiert"
L["Usage: /tsm price <ItemLink> <Price String>"] = "Benutzung: /tsm price <ItemLink> <Preistext>"
L["Use smart average for purchase price"] = "Intelligenten Durchschnitt für den Einkaufspreis verwenden"
L["Use the field below to search the auction house by filter"] = "Über folgendes Eingabefeld kannst du das AH anhand eines Suchworts filtern"
L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Wähle aus der Liste links die Gruppen und Operationen, die du exportieren willst."
L["VALUE PRICE SOURCE"] = "WERTPREISQUELLE"
L["ValueSources"] = "ValueSources"
L["Variable Name"] = "Variablenname"
L["Vendor"] = "Verkäufer"
L["Vendor Buy Price"] = "Händler Kaufpreis"
L["Vendor Search"] = "Händlersuche"
L["VENDOR SEARCH"] = "HÄNDLERSUCHE"
L["Vendor Sell"] = "Händlerverkauf"
L["Vendor Sell Price"] = "Händler Verkaufspreis"
L["Vendoring 'SELL ALL' Button"] = "Vendoring-Button 'ALLES VERKAUFEN'"
L["View ignored items in the Destroying options."] = "Ignorierte Items sind in den Destroying-Optionen zu finden."
L["Warehousing"] = "Warehousing"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist, oder %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist, oder %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
L["Warehousing will move a max of %d of each item in this group."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe."
L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist, oder jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist, oder jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist."
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
L["Warehousing will move all of the items in this group."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe."
L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNUNG: Das Makro war zu lang und wurde deshalb von WoW auf eine passende Größe gekürzt."
L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNUNG: Dein Mindestpreis für %s ist kleiner als der Händlerverkaufspreis (inklusive AH-Gebühren). Erwäge, deinen Mindestpreis zu erhöhen oder das Item beim Händler zu verkaufen."
--[[Translation missing --]]
L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
L["When above maximum:"] = "Wenn über Höchstpreis:"
L["When below minimum:"] = "Wenn unter Mindestpreis:"
L["Whitelist"] = "Weiße Liste"
L["Whitelisted Players"] = "Spieler auf der weißen Liste"
L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "Die Menge dieses Items entspricht bereits der maximalen Wiederauffüllungsmenge. Du hast %d und die maximale Wiederauffüllungsmenge ist %d"
L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "Du kannst die Optionen unten benutzen, um veraltete Daten zu löschen. Es wird empfohlen, veraltete Daten gelegentlich zu löschen, damit das Accounting-Modul problemlos funktioniert. Wähle die Anzahl vergangener Tage, die entfernt werden sollen, und klicke dann auf '%s'."
L["You cannot use %s as part of this custom price."] = "Du kannst %s nicht als Teil dieses eigenen Preises verwenden."
L["You cannot use %s within convert() as part of this custom price."] = "Du kannst %s innerhalb von convert() nicht als Teil dieses eigenen Preises verwenden."
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "Du brauchst \"%s\" nicht hinzufügen. Twinks kommen automatisch auf die weiße Liste."
L["You don't know how to craft this item."] = "Du weißt nicht, wie man dieses Item herstellt."
L["You must reload your UI for these settings to take effect. Reload now?"] = "Du musst dein UI neu laden, um diese Einstellungen wirksam werden zu lassen. Jetzt neu laden?"
L["You won an auction for %sx%d for %s"] = "Du hast die Auktion %sx%d mit %s gewonnen"
L["Your auction has not been undercut."] = "Deine Auktion wurde nicht unterboten."
L["Your auction of %s expired"] = "Deine Auktion von %s ist ausgelaufen."
L["Your auction of %s has sold for %s!"] = "Deine Auktion %s wurde für %s verkauft!"
L["Your Buyout"] = "Dein Sofortkaufpreis"
L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Deine Methode zur Marktwertermittlung von '%s' war ungültig und wurde auf den Standardwert zurückgesetzt. Details: %s"
L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Deine Standardmethode zur Marktwertermittlung war ungültig und wurde auf den Standardwert zurückgesetzt. Details: %s"
L["Your task list is currently empty."] = "Deine Aufgabenliste ist aktuell leer."
L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Ein Bug seitens Blizzard hat dazu geführt, dass das AH nicht mehr funktioniert (du wurdest in eine andere Phase verschoben). Bitte schließe und öffne erneut das AH und starte den Sniper neu."
L["You've been undercut."] = "Du wurdest unterboten."
	elseif locale == "esES" then
L = L or {}
L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Grupo:Grupos; Seleccionados (%d |4Artículo:Artículos;)"
L["%d auctions"] = "%d subastas"
L["%d Groups"] = "%d Grupos"
L["%d Items"] = "%d Artículos"
L["%d of %d"] = "%d de %d"
L["%d Operations"] = "%d Operaciones"
L["%d Posted Auctions"] = "%d Subastas publicadas"
L["%d Sold Auctions"] = "%d Subastas vendidas"
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s bolsas, %s banco, %s casa de subastas, %s correo)"
L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s jugador, %s alters, %s hermandad, %s casa de subastas)"
L["%s (%s profit)"] = "%s (%s de beneficio)"
L["%s |4operation:operations;"] = "%s |4operación:operaciones;"
L["%s ago"] = "hace %s"
L["%s Crafts"] = "%s Creados"
--[[Translation missing --]]
L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
L["%s in guild vault"] = "%s en la cámara de hermandad"
L["%s is a valid custom price but %s is an invalid item."] = "%s es un precio personalizado válido pero %s es un objeto no válido."
L["%s is a valid custom price but did not give a value for %s."] = "%s es un precio personalizado válido pero no dio ningún valor para %s."
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "¡'%s' es una operación inválida! Reabastecer (Mín.) %d es mayor que Reabastecer (Máx.) %d."
L["%s is not a valid custom price and gave the following error: %s"] = "%s es un precio personalizado no válido que provocó el siguiente error: %s"
L["%s Operations"] = "%s Operaciones"
--[[Translation missing --]]
L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
L["%s removed."] = "%s borrado."
L["%s sent you %s"] = "%s te ha enviado %s"
L["%s sent you %s and %s"] = "%s te ha enviado %s y %s"
L["%s sent you a COD of %s for %s"] = "%s te ha enviado un correo a contrarreembolso de %s por %s"
L["%s sent you a message: %s"] = "%s te ha enviado un mensaje: %s"
L["%s total"] = "%s total"
L["%sDrag%s to move this button"] = "%sDrag%s para mover este botón"
L["%sLeft-Click%s to open the main window"] = "%sLeft-Click%s para abrir la ventana principal"
L["(%d/500 Characters)"] = "(%d/500 caracteres)"
L["(max %d)"] = "(máx. %d)"
L["(max 5000)"] = "(max 5000)"
L["(min %d - max %d)"] = "(mín. %d - máx. %d)"
L["(min 0 - max 10000)"] = "(mín. 0 - máx. 10000)"
L["(minimum 0 - maximum 20)"] = "(mínimo 0 - máxima 20)"
L["(minimum 0 - maximum 2000)"] = "(mínimo 0 - máximo 2000)"
L["(minimum 0 - maximum 905)"] = "(mínimo 0 - máximo 905)"
L["(minimum 0.5 - maximum 10)"] = "(mínimo 0,5 - máximo 10)"
L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Muestra este listado de ayuda."
L["/tsm|r - opens the main TSM window."] = "/tsm|r - Abre la ventana principal de TSM."
--[[Translation missing --]]
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
--[[Translation missing --]]
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
--[[Translation missing --]]
L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Clic izquierdo|r para ignorar un artículo durante esta sesión."
L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Mayús+Clic izquierdo|r para ignorarlo permanentemente."
L["1 Group"] = "1 Grupo"
L["1 Item"] = "1 artículo"
L["12 hr"] = "12 hr"
L["24 hr"] = "24 hr"
L["48 hr"] = "48 hr"
L["A custom price of %s for %s evaluates to %s."] = "Un precio personalizado de %s para %s se estima en %s."
L["A maximum of 1 convert() function is allowed."] = "Sólo se permite una única función convert()."
L["A profile with that name already exists on the target account. Rename it first and try again."] = "Ya existe un perfil con ese nombre en la cuenta de destino. Cámbiale el nombre primero e inténtalo nuevamente."
L["A profile with this name already exists."] = "Ya existe un perfil con este nombre."
--[[Translation missing --]]
L["A scan is already in progress. Please stop that scan before starting another one."] = "A scan is already in progress. Please stop that scan before starting another one."
--[[Translation missing --]]
L["Above max expires."] = "Above max expires."
--[[Translation missing --]]
L["Above max price. Not posting."] = "Above max price. Not posting."
--[[Translation missing --]]
L["Above max price. Posting at max price."] = "Above max price. Posting at max price."
--[[Translation missing --]]
L["Above max price. Posting at min price."] = "Above max price. Posting at min price."
--[[Translation missing --]]
L["Above max price. Posting at normal price."] = "Above max price. Posting at normal price."
--[[Translation missing --]]
L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
--[[Translation missing --]]
L["Accepting this item will cost"] = "Accepting this item will cost"
L["Account sync removed. Please delete the account sync from the other account as well."] = "Sincronización de cuenta eliminada. Por favor, elimina la sincronización de cuenta de la otra cuenta también."
L["Account Syncing"] = "Sincronizar Cuentas"
L["Accounting"] = "Contabilidad"
--[[Translation missing --]]
L["Accounting Tooltips"] = "Accounting Tooltips"
L["Activity Type"] = "Tipo de actividad"
--[[Translation missing --]]
L["ADD %d ITEMS"] = "ADD %d ITEMS"
L["Add / Remove Items"] = "Añadir / Eliminar artículos"
--[[Translation missing --]]
L["ADD NEW CUSTOM PRICE SOURCE"] = "ADD NEW CUSTOM PRICE SOURCE"
L["ADD OPERATION"] = "AÑADIR OPERACIÓN"
L["Add Player"] = "Añadir jugador"
--[[Translation missing --]]
L["Add Subject / Description"] = "Add Subject / Description"
--[[Translation missing --]]
L["Add Subject / Description (Optional)"] = "Add Subject / Description (Optional)"
L["ADD TO MAIL"] = "AÑADIR AL CORREO"
--[[Translation missing --]]
L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
--[[Translation missing --]]
L["Added %s to %s."] = "Added %s to %s."
L["Additional error suppressed"] = "Error adicional suprimido"
--[[Translation missing --]]
L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Adjust the settings below to set how groups attached to this operation will be auctioned."
--[[Translation missing --]]
L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
--[[Translation missing --]]
L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
L["Advanced Item Search"] = "Búsqueda avanzada de artículos"
L["Advanced Options"] = "Opciones avanzadas"
L["AH"] = "Casa de Subastas"
L["AH (Crafting)"] = "AH (Artesanía)"
L["AH (Disenchanting)"] = "AH (Desencantar)"
--[[Translation missing --]]
L["AH BUSY"] = "AH BUSY"
--[[Translation missing --]]
L["AH Frame Options"] = "AH Frame Options"
L["Alarm Clock"] = "Alarma"
L["All Auctions"] = "Todas las subastas"
L["All Characters and Guilds"] = "Todos los personajes y hermandades"
L["All Item Classes"] = "Todos los tipos de artículos"
L["All Professions"] = "Todas las profesiones"
L["All Subclasses"] = "Todas las subclases"
L["Allow partial stack?"] = "¿Permitir montones parciales?"
L["Alt Guild Bank"] = "Banco de hermandad de alter"
L["Alts"] = "Alters"
L["Alts AH"] = "AH de alters"
L["Amount"] = "Cantidad"
L["AMOUNT"] = "IMPORTE"
--[[Translation missing --]]
L["Amount of Bag Space to Keep Free"] = "Amount of Bag Space to Keep Free"
L["APPLY FILTERS"] = "APLICAR FILTROS"
L["Apply operation to group:"] = "Aplicar operación al grupo:"
L["Are you sure you want to clear old accounting data?"] = "¿Estás seguro de que quieres borrar los datos antiguos de cuentas?"
L["Are you sure you want to delete this group?"] = "¿Seguro que quieres borrar este grupo?"
L["Are you sure you want to delete this operation?"] = "¿Seguro que quieres borrar esta operación?"
--[[Translation missing --]]
L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
--[[Translation missing --]]
L["At above max price and not undercut."] = "At above max price and not undercut."
--[[Translation missing --]]
L["At normal price and not undercut."] = "At normal price and not undercut."
L["Auction"] = "Subasta"
L["Auction Bid"] = "Subasta"
L["Auction Buyout"] = "Compra"
L["AUCTION DETAILS"] = "DETALLES DE SUBASTA"
L["Auction Duration"] = "Duración de subasta"
--[[Translation missing --]]
L["Auction has been bid on."] = "Auction has been bid on."
--[[Translation missing --]]
L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
L["Auction Sale Sound"] = "Auction Sale Sound"
L["Auction Window Close"] = "Cerrar Ventana de Subasta"
L["Auction Window Open"] = "Abrir Ventana de Subasta"
L["Auctionator - Auction Value"] = "Auctionator - Valor de la subasta"
L["AuctionDB - Market Value"] = "AuctionDB - Valor de mercado"
L["Auctioneer - Appraiser"] = "Auctioneer - Tasador"
L["Auctioneer - Market Value"] = "Auctioneer - Valor de Mercado"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - Precio de compra mínimo"
L["Auctioning"] = "Subastar"
L["Auctioning Log"] = "Registro de subastas"
--[[Translation missing --]]
L["Auctioning Operation"] = "Auctioning Operation"
--[[Translation missing --]]
L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
--[[Translation missing --]]
L["Auctioning Tooltips"] = "Auctioning Tooltips"
L["Auctions"] = "Subastas"
L["Auto Quest Complete"] = "Autocompletar Misiones"
L["Average Earned Per Day:"] = "Promedio de ingresos por día:"
L["Average Prices:"] = "Precios medios:"
L["Average Profit Per Day:"] = "Ganancia promedio por día:"
L["Average Spent Per Day:"] = "Promedio de gasto por día:"
L["Avg Buy Price"] = "Precio medio de compra"
L["Avg Resale Profit"] = "Promedio de beneficios de reventa"
L["Avg Sell Price"] = "Precio medio de venta"
L["BACK"] = "ATRÁS"
L["BACK TO LIST"] = "VOLVER A LA LISTA"
L["Back to List"] = "Volver a la lista"
L["Bag"] = "Bolsa"
L["Bags"] = "Bolsas"
L["Banks"] = "Bancos"
L["Base Group"] = "Grupo base"
--[[Translation missing --]]
L["Base Item"] = "Base Item"
L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Aquí se muestran las listas de precios disponibles por módulos. Se muestra como %skey|r Lo que puedes escribir en las casillas de precios."
L["Below custom price:"] = "Por debajo del precio personalizado:"
--[[Translation missing --]]
L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
--[[Translation missing --]]
L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
--[[Translation missing --]]
L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
--[[Translation missing --]]
L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
--[[Translation missing --]]
L["BID"] = "BID"
--[[Translation missing --]]
L["Bid %d / %d"] = "Bid %d / %d"
--[[Translation missing --]]
L["Bid (item)"] = "Bid (item)"
--[[Translation missing --]]
L["Bid (stack)"] = "Bid (stack)"
--[[Translation missing --]]
L["Bid Price"] = "Bid Price"
L["Bid Sniper Paused"] = "Búsqueda de pujas de sniper pausada"
L["Bid Sniper Running"] = "Ejecutando búsqueda de pujas de sniper"
--[[Translation missing --]]
L["Bidding Auction"] = "Bidding Auction"
--[[Translation missing --]]
L["Blacklisted players:"] = "Blacklisted players:"
L["Bought"] = "Comprado"
--[[Translation missing --]]
L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
--[[Translation missing --]]
L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
--[[Translation missing --]]
L["Bound Actions"] = "Bound Actions"
L["BUSY"] = "OCUPADO"
L["BUY"] = "COMPRA"
L["Buy"] = "Compra"
L["Buy %d / %d"] = "Compra %d / %d"
--[[Translation missing --]]
L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
--[[Translation missing --]]
L["Buy from AH"] = "Buy from AH"
L["Buy from Vendor"] = "Comprar al Vendedor"
L["BUY GROUPS"] = "GRUPOS DE COMPRA"
L["Buy Options"] = "Opciones de compra"
--[[Translation missing --]]
L["BUYBACK ALL"] = "BUYBACK ALL"
--[[Translation missing --]]
L["Buyer/Seller"] = "Buyer/Seller"
--[[Translation missing --]]
L["BUYOUT"] = "BUYOUT"
--[[Translation missing --]]
L["Buyout (item)"] = "Buyout (item)"
--[[Translation missing --]]
L["Buyout (stack)"] = "Buyout (stack)"
--[[Translation missing --]]
L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
--[[Translation missing --]]
L["Buyout Price"] = "Buyout Price"
L["Buyout Sniper Paused"] = "Búsqueda de compras de sniper pausada"
L["Buyout Sniper Running"] = "Ejecutando búsqueda de compras de sniper"
--[[Translation missing --]]
L["BUYS"] = "BUYS"
L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "Por defecto, este grupo contiene todos los artículos que no están asignados a un grupo. Este grupo no se puede modificar ni eliminar."
--[[Translation missing --]]
L["Cancel auctions with bids"] = "Cancel auctions with bids"
L["Cancel Scan"] = "Cancelar escaneo"
L["Cancel to repost higher?"] = "¿Cancelar para revenderlo más caro?"
--[[Translation missing --]]
L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
L["Canceling"] = "Cancelando"
L["Canceling %d / %d"] = "Cancelando %d / %d"
L["Canceling %d Auctions..."] = "Cancelando %d subastas..."
L["Canceling all auctions."] = "Cancelando todas las subastas."
--[[Translation missing --]]
L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
L["Canceling disabled."] = "Cancelación desactivada."
--[[Translation missing --]]
L["Canceling Settings"] = "Canceling Settings"
L["Canceling to repost at higher price."] = "Cancelando para revender más caro."
--[[Translation missing --]]
L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
--[[Translation missing --]]
L["Canceling to repost higher."] = "Canceling to repost higher."
--[[Translation missing --]]
L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
--[[Translation missing --]]
L["Canceling undercut auctions."] = "Canceling undercut auctions."
L["Cancelled"] = "Cancelado"
--[[Translation missing --]]
L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
--[[Translation missing --]]
L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
--[[Translation missing --]]
L["CANCELS"] = "CANCELS"
--[[Translation missing --]]
L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
L["Can't load TSM tooltip while in combat"] = "No se puede cargar la información del TSM mientras estás en combate"
L["Cash Register"] = "Caja registradora"
L["CHARACTER"] = "PERSONAJE"
L["Character"] = "Personaje"
L["Chat Tab"] = "Pestaña de Chat"
--[[Translation missing --]]
L["Cheapest auction below min price."] = "Cheapest auction below min price."
L["Clear"] = "Restablecer"
L["Clear All"] = "Limpiar todo"
L["CLEAR DATA"] = "BORRAR DATOS"
L["Clear Filters"] = "Borrar Filtros"
L["Clear Old Data"] = "Borrar datos antiguos"
--[[Translation missing --]]
L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
--[[Translation missing --]]
L["Clear Queue"] = "Clear Queue"
L["Clear Selection"] = "Restablecer Selección"
--[[Translation missing --]]
L["COD"] = "COD"
L["Coins (%s)"] = "Monedas (%s)"
--[[Translation missing --]]
L["Collapse All Groups"] = "Collapse All Groups"
--[[Translation missing --]]
L["Combine Partial Stacks"] = "Combine Partial Stacks"
--[[Translation missing --]]
L["Combining..."] = "Combining..."
--[[Translation missing --]]
L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
L["Confirm"] = "Confirmar"
--[[Translation missing --]]
L["Confirm Complete Sound"] = "Confirm Complete Sound"
--[[Translation missing --]]
L["Confirming %d / %d"] = "Confirming %d / %d"
L["Connected to %s"] = "Conectado con %s"
--[[Translation missing --]]
L["Connecting to %s"] = "Connecting to %s"
L["CONTACTS"] = "CONTACTOS"
--[[Translation missing --]]
L["Contacts Menu"] = "Contacts Menu"
--[[Translation missing --]]
L["Cooldown"] = "Cooldown"
--[[Translation missing --]]
L["Cooldowns"] = "Cooldowns"
L["Cost"] = "Precio"
--[[Translation missing --]]
L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
L["Could not find profile '%s'. Possible profiles: '%s'"] = "No se pudo encontrar el perfil \"%s\". Sugerencias: \"%s\""
--[[Translation missing --]]
L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
--[[Translation missing --]]
L["Craft"] = "Craft"
--[[Translation missing --]]
L["CRAFT"] = "CRAFT"
--[[Translation missing --]]
L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
--[[Translation missing --]]
L["Craft (When Profitable)"] = "Craft (When Profitable)"
--[[Translation missing --]]
L["Craft All"] = "Craft All"
--[[Translation missing --]]
L["CRAFT ALL"] = "CRAFT ALL"
--[[Translation missing --]]
L["Craft Name"] = "Craft Name"
--[[Translation missing --]]
L["CRAFT NEXT"] = "CRAFT NEXT"
--[[Translation missing --]]
L["Craft value method:"] = "Craft value method:"
--[[Translation missing --]]
L["CRAFTER"] = "CRAFTER"
--[[Translation missing --]]
L["CRAFTING"] = "CRAFTING"
--[[Translation missing --]]
L["Crafting"] = "Crafting"
--[[Translation missing --]]
L["Crafting Cost"] = "Crafting Cost"
--[[Translation missing --]]
L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
--[[Translation missing --]]
L["Crafting Queue"] = "Crafting Queue"
--[[Translation missing --]]
L["Crafting Tooltips"] = "Crafting Tooltips"
--[[Translation missing --]]
L["Crafts"] = "Crafts"
--[[Translation missing --]]
L["Crafts %d"] = "Crafts %d"
--[[Translation missing --]]
L["CREATE MACRO"] = "CREATE MACRO"
L["Create New Operation"] = "Crear Nueva Operación"
--[[Translation missing --]]
L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
--[[Translation missing --]]
L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
L["Crystals"] = "Cristales"
--[[Translation missing --]]
L["Current Profiles"] = "Current Profiles"
--[[Translation missing --]]
L["CURRENT SEARCH"] = "CURRENT SEARCH"
--[[Translation missing --]]
L["CUSTOM POST"] = "CUSTOM POST"
--[[Translation missing --]]
L["Custom Price"] = "Custom Price"
L["Custom Price Source"] = "Fuente de Precio Personalizado"
--[[Translation missing --]]
L["Custom Sources"] = "Custom Sources"
--[[Translation missing --]]
L["Database Sources"] = "Database Sources"
--[[Translation missing --]]
L["Default Craft Value Method:"] = "Default Craft Value Method:"
--[[Translation missing --]]
L["Default Material Cost Method:"] = "Default Material Cost Method:"
--[[Translation missing --]]
L["Default Price"] = "Default Price"
--[[Translation missing --]]
L["Default Price Configuration"] = "Default Price Configuration"
--[[Translation missing --]]
L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
--[[Translation missing --]]
L["Delete this record?"] = "Delete this record?"
--[[Translation missing --]]
L["Deposit"] = "Deposit"
--[[Translation missing --]]
L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
L["Deposit Price"] = "Deposit Price"
--[[Translation missing --]]
L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
L["Deselect All Groups"] = "Desmarcar Todos los Grupos"
--[[Translation missing --]]
L["Deselect All Items"] = "Deselect All Items"
--[[Translation missing --]]
L["Destroy Next"] = "Destroy Next"
L["Destroy Value"] = "Valor de Destrucción"
--[[Translation missing --]]
L["Destroy Value Source"] = "Destroy Value Source"
--[[Translation missing --]]
L["Destroying"] = "Destroying"
--[[Translation missing --]]
L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
--[[Translation missing --]]
L["Destroying Tooltips"] = "Destroying Tooltips"
--[[Translation missing --]]
L["Destroying..."] = "Destroying..."
--[[Translation missing --]]
L["Details"] = "Details"
--[[Translation missing --]]
L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
L["Disenchant Search"] = "Disenchant Search"
L["DISENCHANT SEARCH"] = "BÚSQUEDA DE DESENCANTAR"
--[[Translation missing --]]
L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
L["Display cancelled since last sale"] = "Display cancelled since last sale"
--[[Translation missing --]]
L["Display crafting cost"] = "Display crafting cost"
--[[Translation missing --]]
L["Display detailed destroy info"] = "Display detailed destroy info"
--[[Translation missing --]]
L["Display disenchant value"] = "Display disenchant value"
--[[Translation missing --]]
L["Display expired auctions"] = "Display expired auctions"
--[[Translation missing --]]
L["Display group name"] = "Display group name"
--[[Translation missing --]]
L["Display historical price"] = "Display historical price"
--[[Translation missing --]]
L["Display market value"] = "Display market value"
--[[Translation missing --]]
L["Display mill value"] = "Display mill value"
L["Display min buyout"] = "Mostrar compra mínima"
--[[Translation missing --]]
L["Display Operation Names"] = "Display Operation Names"
--[[Translation missing --]]
L["Display prospect value"] = "Display prospect value"
--[[Translation missing --]]
L["Display purchase info"] = "Display purchase info"
--[[Translation missing --]]
L["Display region historical price"] = "Display region historical price"
--[[Translation missing --]]
L["Display region market value avg"] = "Display region market value avg"
--[[Translation missing --]]
L["Display region min buyout avg"] = "Display region min buyout avg"
--[[Translation missing --]]
L["Display region sale avg"] = "Display region sale avg"
--[[Translation missing --]]
L["Display region sale rate"] = "Display region sale rate"
--[[Translation missing --]]
L["Display region sold per day"] = "Display region sold per day"
L["Display sale info"] = "Mostrar información de venta"
L["Display sale rate"] = "Mostrar tasa de venta"
--[[Translation missing --]]
L["Display shopping max price"] = "Display shopping max price"
--[[Translation missing --]]
L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
--[[Translation missing --]]
L["Display transform value"] = "Display transform value"
--[[Translation missing --]]
L["Display vendor buy price"] = "Display vendor buy price"
--[[Translation missing --]]
L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
L["Done Canceling"] = "Done Canceling"
--[[Translation missing --]]
L["Done Posting"] = "Done Posting"
--[[Translation missing --]]
L["Done rebuilding item cache."] = "Done rebuilding item cache."
L["Done Scanning"] = "Escaneo realizado"
--[[Translation missing --]]
L["Don't post after this many expires:"] = "Don't post after this many expires:"
--[[Translation missing --]]
L["Don't Post Items"] = "Don't Post Items"
--[[Translation missing --]]
L["Don't prompt to record trades"] = "Don't prompt to record trades"
L["DOWN"] = "ABAJO"
--[[Translation missing --]]
L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
--[[Translation missing --]]
L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
--[[Translation missing --]]
L["Duplicate"] = "Duplicate"
--[[Translation missing --]]
L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
L["Dust"] = "Polvo"
--[[Translation missing --]]
L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
L["Embed TSM tooltips"] = "Embed TSM tooltips"
--[[Translation missing --]]
L["EMPTY BAGS"] = "EMPTY BAGS"
L["Empty parentheses are not allowed"] = "Paréntesis vacíos no permitidos"
L["Empty price string."] = "Cadena de precio vacía."
--[[Translation missing --]]
L["Enable automatic stack combination"] = "Enable automatic stack combination"
L["Enable buying?"] = "¿Habilitar la compra?"
L["Enable inbox chat messages"] = "Habilitar los mensajes de chat de la bandeja de entrada"
L["Enable restock?"] = "¿Habilitar el reponer?"
L["Enable selling?"] = "¿Habilitar venta?"
--[[Translation missing --]]
L["Enable sending chat messages"] = "Enable sending chat messages"
--[[Translation missing --]]
L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
--[[Translation missing --]]
L["Enable tweet enhancement"] = "Enable tweet enhancement"
--[[Translation missing --]]
L["Enchant Vellum"] = "Enchant Vellum"
--[[Translation missing --]]
L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
L["Enter a name for the new profile"] = "Enter a name for the new profile"
L["Enter Filter"] = "Introduce un filtro"
--[[Translation missing --]]
L["Enter Keyword"] = "Enter Keyword"
--[[Translation missing --]]
L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
--[[Translation missing --]]
L["Enter player name"] = "Enter player name"
L["Essences"] = "Esencias"
L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establecimiendo conexión con %s. Asegúrate de que has introducido el nombre de este personaje en la otra cuenta."
--[[Translation missing --]]
L["Estimated Cost:"] = "Estimated Cost:"
--[[Translation missing --]]
L["Estimated deliver time"] = "Estimated deliver time"
--[[Translation missing --]]
L["Estimated Profit:"] = "Estimated Profit:"
--[[Translation missing --]]
L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
L["Expand All Groups"] = "Expand All Groups"
L["Expenses"] = "Gastos"
L["EXPENSES"] = "GASTOS"
--[[Translation missing --]]
L["Expirations"] = "Expirations"
--[[Translation missing --]]
L["Expired"] = "Expired"
--[[Translation missing --]]
L["Expired Auctions"] = "Expired Auctions"
--[[Translation missing --]]
L["Expired Since Last Sale"] = "Expired Since Last Sale"
L["Expires"] = "Vence"
--[[Translation missing --]]
L["EXPIRES"] = "EXPIRES"
--[[Translation missing --]]
L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
L["Expiring Mails"] = "Expiring Mails"
L["Exploration"] = "Exploración"
--[[Translation missing --]]
L["Export"] = "Export"
L["Export List"] = "Lista a exportar"
--[[Translation missing --]]
L["Failed Auctions"] = "Failed Auctions"
--[[Translation missing --]]
L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
--[[Translation missing --]]
L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
--[[Translation missing --]]
L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
L["Favorite Scans"] = "Escaneos favoritos"
L["Favorite Searches"] = "Búsquedas favoritas"
--[[Translation missing --]]
L["Filter Auctions by Duration"] = "Filter Auctions by Duration"
--[[Translation missing --]]
L["Filter Auctions by Keyword"] = "Filter Auctions by Keyword"
--[[Translation missing --]]
L["Filter by Keyword"] = "Filter by Keyword"
--[[Translation missing --]]
L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
--[[Translation missing --]]
L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
L["Filter Items"] = "Filtrar artículos"
L["Filter Shopping"] = "Filtro de compras"
--[[Translation missing --]]
L["Finding Selected Auction"] = "Finding Selected Auction"
L["Fishing Reel In"] = "Pesca - recoger el sedal"
--[[Translation missing --]]
L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
L["Found auction sound"] = "Found auction sound"
--[[Translation missing --]]
L["Friends"] = "Friends"
--[[Translation missing --]]
L["From"] = "From"
L["Full"] = "Completo"
--[[Translation missing --]]
L["Garrison"] = "Garrison"
--[[Translation missing --]]
L["Gathering"] = "Gathering"
--[[Translation missing --]]
L["Gathering Search"] = "Gathering Search"
L["General Options"] = "Opciones Generales"
--[[Translation missing --]]
L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
L["Global Operation Confirmation"] = "Global Operation Confirmation"
--[[Translation missing --]]
L["Gold"] = "Gold"
--[[Translation missing --]]
L["Gold Earned:"] = "Gold Earned:"
--[[Translation missing --]]
L["GOLD ON HAND"] = "GOLD ON HAND"
--[[Translation missing --]]
L["Gold Spent:"] = "Gold Spent:"
L["GREAT DEALS SEARCH"] = "BÚSQUEDA DE CHOLLOS"
--[[Translation missing --]]
L["Group already exists."] = "Group already exists."
L["Group Management"] = "Administrar Grupo"
L["Group Operations"] = "Operaciones del grupo"
--[[Translation missing --]]
L["Group Settings"] = "Group Settings"
L["Grouped Items"] = "Artículos agrupados"
L["Groups"] = "Grupos"
--[[Translation missing --]]
L["Guild"] = "Guild"
--[[Translation missing --]]
L["Guild Bank"] = "Guild Bank"
L["GVault"] = "Cámara Herm."
--[[Translation missing --]]
L["Have"] = "Have"
--[[Translation missing --]]
L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
L["Hide auctions with bids"] = "Hide auctions with bids"
--[[Translation missing --]]
L["Hide Description"] = "Hide Description"
--[[Translation missing --]]
L["Hide minimap icon"] = "Hide minimap icon"
--[[Translation missing --]]
L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
L["High Bidder"] = "High Bidder"
--[[Translation missing --]]
L["Historical Price"] = "Historical Price"
--[[Translation missing --]]
L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
--[[Translation missing --]]
L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
L["Hr"] = "Hr"
--[[Translation missing --]]
L["Hrs"] = "Hrs"
--[[Translation missing --]]
L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Si tienes otros Perfiles configurados con diferentes Operaciones, activar esto hará que todas las Operaciones salvo la del Perfil actual se pierdan de manera irreversible. ¿Seguro que quieres continuar?"
--[[Translation missing --]]
L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
--[[Translation missing --]]
L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
--[[Translation missing --]]
L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
--[[Translation missing --]]
L["Ignore Characters"] = "Ignore Characters"
L["Ignore Guilds"] = "Ignorar Hermandades"
--[[Translation missing --]]
L["Ignore item variations?"] = "Ignore item variations?"
--[[Translation missing --]]
L["Ignore operation on characters:"] = "Ignore operation on characters:"
--[[Translation missing --]]
L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
--[[Translation missing --]]
L["Ignored Cooldowns"] = "Ignored Cooldowns"
--[[Translation missing --]]
L["Ignored Items"] = "Ignored Items"
L["ilvl"] = "ilvl"
L["Import"] = "Importar"
L["IMPORT"] = "IMPORTAR"
L["Import %d Items and %s Operations?"] = "Importar %d Artículos y %s Operaciones"
L["Import Groups & Operations"] = "Importar Grupos y Operaciones"
L["Imported Items"] = "Importar Artículos"
L["Inbox Settings"] = "Configuración de la bandeja de entrada"
L["Include Attached Operations"] = "Incluir operaciones adjuntas"
--[[Translation missing --]]
L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
L["Include soulbound items"] = "Include soulbound items"
--[[Translation missing --]]
L["Information"] = "Information"
--[[Translation missing --]]
L["Invalid custom price entered."] = "Invalid custom price entered."
--[[Translation missing --]]
L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
L["Invalid custom price."] = "Precio Personalizado no válido."
L["Invalid function."] = "Función no válida."
--[[Translation missing --]]
L["Invalid gold value."] = "Invalid gold value."
--[[Translation missing --]]
L["Invalid group name."] = "Invalid group name."
--[[Translation missing --]]
L["Invalid import string."] = "Invalid import string."
L["Invalid item link."] = "Enlace a objeto no válido."
--[[Translation missing --]]
L["Invalid operation name."] = "Invalid operation name."
L["Invalid operator at end of custom price."] = "Operador no válido al final del precio personalizado."
L["Invalid parameter to price source."] = "Parámetro no válido para fuente de precio."
--[[Translation missing --]]
L["Invalid player name."] = "Invalid player name."
L["Invalid price source in convert."] = "Fuente de precio en conversión no válida."
--[[Translation missing --]]
L["Invalid price source."] = "Invalid price source."
--[[Translation missing --]]
L["Invalid search filter"] = "Invalid search filter"
--[[Translation missing --]]
L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
L["Invalid word: '%s'"] = "Palabra no válida: \"%s\""
--[[Translation missing --]]
L["Inventory"] = "Inventory"
--[[Translation missing --]]
L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
L["Inventory / Mailing"] = "Inventory / Mailing"
--[[Translation missing --]]
L["Inventory Options"] = "Inventory Options"
--[[Translation missing --]]
L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
--[[Translation missing --]]
L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
L["Item"] = "Objeto"
--[[Translation missing --]]
L["ITEM CLASS"] = "ITEM CLASS"
--[[Translation missing --]]
L["Item Level"] = "Item Level"
--[[Translation missing --]]
L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
L["Item links may only be used as parameters to price sources."] = "Los enlaces de objetos sólo pueden ser utilizados como parámetros para Fuentes de Precio."
L["Item Name"] = "Nombre de Objeto"
--[[Translation missing --]]
L["Item Quality"] = "Item Quality"
--[[Translation missing --]]
L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
--[[Translation missing --]]
L["Item Value"] = "Item Value"
--[[Translation missing --]]
L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
--[[Translation missing --]]
L["ITEMS"] = "ITEMS"
L["Items"] = "Objetos"
--[[Translation missing --]]
L["Items in Bags"] = "Items in Bags"
--[[Translation missing --]]
L["Keep in bags quantity:"] = "Keep in bags quantity:"
--[[Translation missing --]]
L["Keep in bank quantity:"] = "Keep in bank quantity:"
--[[Translation missing --]]
L["Keep posted:"] = "Keep posted:"
--[[Translation missing --]]
L["Keep quantity:"] = "Keep quantity:"
--[[Translation missing --]]
L["Keep this amount in bags:"] = "Keep this amount in bags:"
--[[Translation missing --]]
L["Keep this amount:"] = "Keep this amount:"
--[[Translation missing --]]
L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
--[[Translation missing --]]
L["Last 14 Days"] = "Last 14 Days"
--[[Translation missing --]]
L["Last 3 Days"] = "Last 3 Days"
--[[Translation missing --]]
L["Last 30 Days"] = "Last 30 Days"
--[[Translation missing --]]
L["LAST 30 DAYS"] = "LAST 30 DAYS"
--[[Translation missing --]]
L["Last 60 Days"] = "Last 60 Days"
--[[Translation missing --]]
L["Last 7 Days"] = "Last 7 Days"
--[[Translation missing --]]
L["LAST 7 DAYS"] = "LAST 7 DAYS"
L["Last Data Update:"] = "Última actualización de datos:"
--[[Translation missing --]]
L["Last Purchased"] = "Last Purchased"
--[[Translation missing --]]
L["Last Sold"] = "Last Sold"
--[[Translation missing --]]
L["Level Up"] = "Level Up"
--[[Translation missing --]]
L["LIMIT"] = "LIMIT"
--[[Translation missing --]]
L["Link to Another Operation"] = "Link to Another Operation"
--[[Translation missing --]]
L["List"] = "List"
--[[Translation missing --]]
L["List materials in tooltip"] = "List materials in tooltip"
--[[Translation missing --]]
L["Loading Mails..."] = "Loading Mails..."
--[[Translation missing --]]
L["Loading..."] = "Loading..."
L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Parece que TradeSkillMaster ha encontrado un error. Por favor, ayudar al autor corregir este error, siga las instrucciones que se muestran."
L["Loop detected in the following custom price:"] = "Reduncia cíclica detectada en el precio personalizado seguido:"
--[[Translation missing --]]
L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
L["Macro created and scroll wheel bound!"] = "Macro creado y rueda de desplazamiento enlazada!"
L["Macro Setup"] = "Configuración de macro."
L["Mail"] = "Correo"
--[[Translation missing --]]
L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
L["Mailing"] = "Mailing"
--[[Translation missing --]]
L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
--[[Translation missing --]]
L["Main Settings"] = "Main Settings"
--[[Translation missing --]]
L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
--[[Translation missing --]]
L["Management Options"] = "Management Options"
--[[Translation missing --]]
L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
--[[Translation missing --]]
L["Map Ping"] = "Map Ping"
--[[Translation missing --]]
L["Market Value"] = "Market Value"
--[[Translation missing --]]
L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
L["Material Name"] = "Material Name"
--[[Translation missing --]]
L["Materials"] = "Materials"
--[[Translation missing --]]
L["Materials to Gather"] = "Materials to Gather"
--[[Translation missing --]]
L["MAX"] = "MAX"
--[[Translation missing --]]
L["Max Buy Price"] = "Max Buy Price"
--[[Translation missing --]]
L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
--[[Translation missing --]]
L["Max Sell Price"] = "Max Sell Price"
--[[Translation missing --]]
L["Max Shopping Price"] = "Max Shopping Price"
--[[Translation missing --]]
L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
--[[Translation missing --]]
L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
--[[Translation missing --]]
L["Maximum quantity:"] = "Maximum quantity:"
--[[Translation missing --]]
L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
L["Mill Value"] = "Mill Value"
--[[Translation missing --]]
L["Min"] = "Min"
--[[Translation missing --]]
L["Min Buy Price"] = "Min Buy Price"
--[[Translation missing --]]
L["Min Buyout"] = "Min Buyout"
--[[Translation missing --]]
L["Min Sell Price"] = "Min Sell Price"
--[[Translation missing --]]
L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
--[[Translation missing --]]
L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
L["Minimum expires:"] = "Minimum expires:"
--[[Translation missing --]]
L["Minimum profit:"] = "Minimum profit:"
--[[Translation missing --]]
L["MINIMUM RARITY"] = "MINIMUM RARITY"
--[[Translation missing --]]
L["Minimum restock quantity:"] = "Minimum restock quantity:"
L["Misplaced comma"] = "Coma fuera de lugar."
--[[Translation missing --]]
L["Missing Materials"] = "Missing Materials"
--[[Translation missing --]]
L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
L["Modifiers:"] = "Modificado."
--[[Translation missing --]]
L["Money Frame Open"] = "Money Frame Open"
--[[Translation missing --]]
L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
L["Most Profitable Item:"] = "Most Profitable Item:"
--[[Translation missing --]]
L["MOVE"] = "MOVE"
--[[Translation missing --]]
L["Move already grouped items?"] = "Move already grouped items?"
--[[Translation missing --]]
L["Move Quantity Settings"] = "Move Quantity Settings"
--[[Translation missing --]]
L["MOVE TO BAGS"] = "MOVE TO BAGS"
--[[Translation missing --]]
L["MOVE TO BANK"] = "MOVE TO BANK"
--[[Translation missing --]]
L["MOVING"] = "MOVING"
--[[Translation missing --]]
L["Moving"] = "Moving"
--[[Translation missing --]]
L["Multiple Items"] = "Multiple Items"
L["My Auctions"] = "Mis subastas"
--[[Translation missing --]]
L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
--[[Translation missing --]]
L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
L["NEED MATS"] = "NEED MATS"
L["New Group"] = "Nuevo Grupo"
L["New Operation"] = "Nueva operación"
--[[Translation missing --]]
L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
--[[Translation missing --]]
L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
L["No Crafts"] = "No Crafts"
--[[Translation missing --]]
L["No Data"] = "No Data"
--[[Translation missing --]]
L["No group selected"] = "No group selected"
--[[Translation missing --]]
L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
--[[Translation missing --]]
L["NO ITEMS"] = "NO ITEMS"
--[[Translation missing --]]
L["No Materials to Gather"] = "No Materials to Gather"
--[[Translation missing --]]
L["No Operation Selected"] = "No Operation Selected"
--[[Translation missing --]]
L["No posting."] = "No posting."
--[[Translation missing --]]
L["No Profession Opened"] = "No Profession Opened"
--[[Translation missing --]]
L["No Profession Selected"] = "No Profession Selected"
L["No profile specified. Possible profiles: '%s'"] = "Perfil no especificado. Perfiles posibles: '%s'"
--[[Translation missing --]]
L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
L["No Sound"] = "Sin sonido"
L["None"] = "Ninguno"
L["None (Always Show)"] = "Ninguno (Mostrar siempre)"
--[[Translation missing --]]
L["None Selected"] = "None Selected"
--[[Translation missing --]]
L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
--[[Translation missing --]]
L["Normal"] = "Normal"
--[[Translation missing --]]
L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
--[[Translation missing --]]
L["Not canceling auction below min price."] = "Not canceling auction below min price."
--[[Translation missing --]]
L["Not canceling."] = "Not canceling."
--[[Translation missing --]]
L["Not Connected"] = "Not Connected"
--[[Translation missing --]]
L["Not enough items in bags."] = "Not enough items in bags."
--[[Translation missing --]]
L["NOT OPEN"] = "NOT OPEN"
--[[Translation missing --]]
L["Not Scanned"] = "Not Scanned"
--[[Translation missing --]]
L["Nothing to move."] = "Nothing to move."
--[[Translation missing --]]
L["NPC"] = "NPC"
--[[Translation missing --]]
L["Number Owned"] = "Number Owned"
--[[Translation missing --]]
L["of"] = "of"
L["Offline"] = "Desconectado"
--[[Translation missing --]]
L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
--[[Translation missing --]]
L["OPEN"] = "OPEN"
--[[Translation missing --]]
L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
--[[Translation missing --]]
L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
L["Open Task List"] = "Open Task List"
--[[Translation missing --]]
L["Operation"] = "Operation"
L["Operations"] = "Operaciones"
--[[Translation missing --]]
L["Other Character"] = "Other Character"
--[[Translation missing --]]
L["Other Settings"] = "Other Settings"
L["Other Shopping Searches"] = "Otras búsquedas de compras"
--[[Translation missing --]]
L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
L["Parent Items"] = "Parent Items"
--[[Translation missing --]]
L["Past 7 Days"] = "Past 7 Days"
--[[Translation missing --]]
L["Past Day"] = "Past Day"
--[[Translation missing --]]
L["Past Month"] = "Past Month"
--[[Translation missing --]]
L["Past Year"] = "Past Year"
--[[Translation missing --]]
L["Paste string here"] = "Paste string here"
--[[Translation missing --]]
L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
--[[Translation missing --]]
L["Per Item"] = "Per Item"
--[[Translation missing --]]
L["Per Stack"] = "Per Stack"
--[[Translation missing --]]
L["Per Unit"] = "Per Unit"
L["Player Gold"] = "Oro del personaje"
L["Player Invite Accept"] = "Aceptar invitación de jugador."
--[[Translation missing --]]
L["Please select a group to export"] = "Please select a group to export"
--[[Translation missing --]]
L["POST"] = "POST"
--[[Translation missing --]]
L["Post at Maximum Price"] = "Post at Maximum Price"
--[[Translation missing --]]
L["Post at Minimum Price"] = "Post at Minimum Price"
--[[Translation missing --]]
L["Post at Normal Price"] = "Post at Normal Price"
--[[Translation missing --]]
L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
--[[Translation missing --]]
L["Post Scan"] = "Post Scan"
--[[Translation missing --]]
L["POST SELECTED"] = "POST SELECTED"
--[[Translation missing --]]
L["POSTAGE"] = "POSTAGE"
--[[Translation missing --]]
L["Postage"] = "Postage"
--[[Translation missing --]]
L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
L["Posted Auctions %s:"] = "Posted Auctions %s:"
--[[Translation missing --]]
L["Posting"] = "Posting"
--[[Translation missing --]]
L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
L["Posting disabled."] = "Posting disabled."
--[[Translation missing --]]
L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
L["Posts"] = "Posts"
--[[Translation missing --]]
L["Potential"] = "Potential"
--[[Translation missing --]]
L["Price Per Item"] = "Price Per Item"
--[[Translation missing --]]
L["Price Settings"] = "Price Settings"
--[[Translation missing --]]
L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
--[[Translation missing --]]
L["PROFESSION"] = "PROFESSION"
--[[Translation missing --]]
L["Profession Filters"] = "Profession Filters"
--[[Translation missing --]]
L["Profession Info"] = "Profession Info"
--[[Translation missing --]]
L["Profession loading..."] = "Profession loading..."
--[[Translation missing --]]
L["Professions Used In"] = "Professions Used In"
L["Profile changed to '%s'."] = "Perfil cambiado a '%s'."
L["Profiles"] = "Perfiles"
--[[Translation missing --]]
L["PROFIT"] = "PROFIT"
--[[Translation missing --]]
L["Profit"] = "Profit"
--[[Translation missing --]]
L["Prospect Value"] = "Prospect Value"
--[[Translation missing --]]
L["PURCHASE DATA"] = "PURCHASE DATA"
--[[Translation missing --]]
L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
--[[Translation missing --]]
L["Purchased (Total Price)"] = "Purchased (Total Price)"
--[[Translation missing --]]
L["Purchases"] = "Purchases"
--[[Translation missing --]]
L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
L["Qty"] = "Qty"
--[[Translation missing --]]
L["Quantity Bought:"] = "Quantity Bought:"
--[[Translation missing --]]
L["Quantity Sold:"] = "Quantity Sold:"
--[[Translation missing --]]
L["Quantity to move:"] = "Quantity to move:"
L["Quest Added"] = "Misión añadida."
L["Quest Completed"] = "Misión completada"
L["Quest Objectives Complete"] = "Objetivos de misión completados."
--[[Translation missing --]]
L["QUEUE"] = "QUEUE"
--[[Translation missing --]]
L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
L["Raid Warning"] = "Alerta de Raid"
--[[Translation missing --]]
L["Read More"] = "Read More"
--[[Translation missing --]]
L["Ready Check"] = "Ready Check"
--[[Translation missing --]]
L["Ready to Cancel"] = "Ready to Cancel"
--[[Translation missing --]]
L["Realm Data Tooltips"] = "Realm Data Tooltips"
L["Recent Scans"] = "Escaneos recientes"
L["Recent Searches"] = "Búsquedas recientes"
--[[Translation missing --]]
L["Recently Mailed"] = "Recently Mailed"
--[[Translation missing --]]
L["RECIPIENT"] = "RECIPIENT"
--[[Translation missing --]]
L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
L["Region Sale Rate"] = "Region Sale Rate"
--[[Translation missing --]]
L["Reload"] = "Reload"
--[[Translation missing --]]
L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
--[[Translation missing --]]
L["Removed a total of %s old records."] = "Removed a total of %s old records."
--[[Translation missing --]]
L["Rename"] = "Rename"
--[[Translation missing --]]
L["Rename Profile"] = "Rename Profile"
--[[Translation missing --]]
L["REPAIR"] = "REPAIR"
--[[Translation missing --]]
L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
L["Replace duplicate operations?"] = "Replace duplicate operations?"
--[[Translation missing --]]
L["REPLY"] = "REPLY"
--[[Translation missing --]]
L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
L["Repost Higher Threshold"] = "Repost Higher Threshold"
--[[Translation missing --]]
L["Required Level"] = "Required Level"
--[[Translation missing --]]
L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
--[[Translation missing --]]
L["Resale"] = "Resale"
--[[Translation missing --]]
L["RESCAN"] = "RESCAN"
--[[Translation missing --]]
L["RESET"] = "RESET"
--[[Translation missing --]]
L["Reset All"] = "Reset All"
--[[Translation missing --]]
L["Reset Filters"] = "Reset Filters"
--[[Translation missing --]]
L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
--[[Translation missing --]]
L["RESTART"] = "RESTART"
--[[Translation missing --]]
L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
L["Revenue"] = "Revenue"
--[[Translation missing --]]
L["Round normal price"] = "Round normal price"
--[[Translation missing --]]
L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
L["Run Bid Sniper"] = "Ejecutar búsqueda de pujas de sniper"
L["Run Buyout Sniper"] = "Ejecutar búsqueda de compras de sniper"
--[[Translation missing --]]
L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
L["RUN POST SCAN"] = "RUN POST SCAN"
L["RUN SHOPPING SCAN"] = "ESCANEAR COMPRAS"
L["Running Sniper Scan"] = "Ejecutando escaneo de sniper"
--[[Translation missing --]]
L["Sale"] = "Sale"
--[[Translation missing --]]
L["SALE DATA"] = "SALE DATA"
--[[Translation missing --]]
L["Sale Price"] = "Sale Price"
--[[Translation missing --]]
L["Sale Rate"] = "Sale Rate"
--[[Translation missing --]]
L["Sales"] = "Sales"
--[[Translation missing --]]
L["SALES"] = "SALES"
--[[Translation missing --]]
L["Sales Summary"] = "Sales Summary"
--[[Translation missing --]]
L["SCAN ALL"] = "SCAN ALL"
--[[Translation missing --]]
L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
L["Scan Paused"] = "Scan Paused"
--[[Translation missing --]]
L["SCANNING"] = "SCANNING"
--[[Translation missing --]]
L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
L["Scroll wheel direction:"] = "Scroll wheel direction:"
--[[Translation missing --]]
L["Search"] = "Search"
--[[Translation missing --]]
L["Search Bags"] = "Search Bags"
L["Search Groups"] = "Buscar grupos"
L["Search Inbox"] = "Buscar en la bandeja de entrada"
L["Search Operations"] = "Buscar operaciones"
--[[Translation missing --]]
L["Search Patterns"] = "Search Patterns"
--[[Translation missing --]]
L["Search Usable Items Only?"] = "Search Usable Items Only?"
--[[Translation missing --]]
L["Search Vendor"] = "Search Vendor"
--[[Translation missing --]]
L["Select a Source"] = "Select a Source"
--[[Translation missing --]]
L["Select Action"] = "Select Action"
L["Select All Groups"] = "Seleccionar todos los Grupos"
--[[Translation missing --]]
L["Select All Items"] = "Select All Items"
--[[Translation missing --]]
L["Select Auction to Cancel"] = "Select Auction to Cancel"
--[[Translation missing --]]
L["Select crafter"] = "Select crafter"
--[[Translation missing --]]
L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
--[[Translation missing --]]
L["Select Duration"] = "Select Duration"
L["Select Items to Add"] = "Seleccionar elementos a añadir"
L["Select Items to Remove"] = "Seleccionar elementos a eliminar"
--[[Translation missing --]]
L["Select Operation"] = "Select Operation"
--[[Translation missing --]]
L["Select professions"] = "Select professions"
--[[Translation missing --]]
L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
L["Selected Groups"] = "Grupos seleccionados"
L["Selected Operations"] = "Operaciones seleccionadas"
--[[Translation missing --]]
L["Sell"] = "Sell"
--[[Translation missing --]]
L["SELL ALL"] = "SELL ALL"
--[[Translation missing --]]
L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
L["SELL GROUPS"] = "SELL GROUPS"
--[[Translation missing --]]
L["Sell Options"] = "Sell Options"
--[[Translation missing --]]
L["Sell soulbound items?"] = "Sell soulbound items?"
L["Sell to Vendor"] = "Vender al Vendedor"
--[[Translation missing --]]
L["SELL TRASH"] = "SELL TRASH"
--[[Translation missing --]]
L["Seller"] = "Seller"
--[[Translation missing --]]
L["Selling soulbound items."] = "Selling soulbound items."
--[[Translation missing --]]
L["Send"] = "Send"
--[[Translation missing --]]
L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
--[[Translation missing --]]
L["SEND GOLD"] = "SEND GOLD"
--[[Translation missing --]]
L["Send grouped items individually"] = "Send grouped items individually"
--[[Translation missing --]]
L["SEND MAIL"] = "SEND MAIL"
--[[Translation missing --]]
L["Send Money"] = "Send Money"
--[[Translation missing --]]
L["Send Profile"] = "Send Profile"
--[[Translation missing --]]
L["SENDING"] = "SENDING"
--[[Translation missing --]]
L["Sending %s individually to %s"] = "Sending %s individually to %s"
--[[Translation missing --]]
L["Sending %s to %s"] = "Sending %s to %s"
--[[Translation missing --]]
L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
--[[Translation missing --]]
L["Sending Settings"] = "Sending Settings"
--[[Translation missing --]]
L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
--[[Translation missing --]]
L["SENDING..."] = "SENDING..."
--[[Translation missing --]]
L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
L["Setup"] = "Setup"
--[[Translation missing --]]
L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
L["Shards"] = "Fragmentos"
L["Shopping"] = "Compras"
--[[Translation missing --]]
L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
--[[Translation missing --]]
L["Show Description"] = "Show Description"
--[[Translation missing --]]
L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
--[[Translation missing --]]
L["Show material cost"] = "Show material cost"
--[[Translation missing --]]
L["Show on Modifier"] = "Show on Modifier"
--[[Translation missing --]]
L["Showing %d Mail"] = "Showing %d Mail"
--[[Translation missing --]]
L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
--[[Translation missing --]]
L["Showing all %d Mails"] = "Showing all %d Mails"
L["Simple"] = "Sencillo."
--[[Translation missing --]]
L["SKIP"] = "SKIP"
--[[Translation missing --]]
L["Skip Import confirmation?"] = "Skip Import confirmation?"
--[[Translation missing --]]
L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
L["Slash Commands:"] = "Comandos de barra:"
L["Sniper"] = "Sniper"
L["Sniper 'BUYOUT' Button"] = "Botón «COMPRAR» de Sniper"
L["Sniper Options"] = "Opciones de sniper"
L["Sniper Settings"] = "Ajustes de sniper"
--[[Translation missing --]]
L["Sniping items below a max price"] = "Sniping items below a max price"
--[[Translation missing --]]
L["Sold"] = "Sold"
--[[Translation missing --]]
L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
L["Sold %s worth of items."] = "Sold %s worth of items."
--[[Translation missing --]]
L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
--[[Translation missing --]]
L["Sold (Total Price)"] = "Sold (Total Price)"
--[[Translation missing --]]
L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
--[[Translation missing --]]
L["Sold Auctions %s:"] = "Sold Auctions %s:"
--[[Translation missing --]]
L["Source"] = "Source"
--[[Translation missing --]]
L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
L["SOURCES"] = "SOURCES"
L["Sources"] = "Fuentes"
--[[Translation missing --]]
L["Sources to include for restock:"] = "Sources to include for restock:"
--[[Translation missing --]]
L["Stack"] = "Stack"
--[[Translation missing --]]
L["Stack / Quantity"] = "Stack / Quantity"
--[[Translation missing --]]
L["Stack size multiple:"] = "Stack size multiple:"
L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Inicia una «Compra» o «Puja» de sniper con los botones de arriba."
--[[Translation missing --]]
L["Starting Scan..."] = "Starting Scan..."
--[[Translation missing --]]
L["STOP"] = "STOP"
--[[Translation missing --]]
L["Store operations globally"] = "Store operations globally"
--[[Translation missing --]]
L["Subject"] = "Subject"
--[[Translation missing --]]
L["SUBJECT"] = "SUBJECT"
--[[Translation missing --]]
L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
L["Switch to %s"] = "Cambiar a %s"
L["Switch to WoW UI"] = "Cambiar a IU de WoW"
--[[Translation missing --]]
L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
L["Sync Status"] = "Sync Status"
--[[Translation missing --]]
L["TAKE ALL"] = "TAKE ALL"
--[[Translation missing --]]
L["Take Attachments"] = "Take Attachments"
--[[Translation missing --]]
L["Target Character"] = "Target Character"
--[[Translation missing --]]
L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
L["Tasks Added to Task List"] = "Tasks Added to Task List"
L["Text (%s)"] = "Texto (%s)"
--[[Translation missing --]]
L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "El nombre SOLO puede contener letras. No puede contener espacios, números o caracteres especiales."
--[[Translation missing --]]
L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Este no es un nombre de perfil válido. Los nombres de perfil tienen que tener ser al menos un carácter de longitud y no pueden tener '@'."
--[[Translation missing --]]
L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
--[[Translation missing --]]
L["This item is not in a TSM group."] = "This item is not in a TSM group."
--[[Translation missing --]]
L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
L["This looks like an exported operation and not a custom price."] = "Esto parece una operación exportada y no un precio personalizado."
--[[Translation missing --]]
L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
--[[Translation missing --]]
L["Time"] = "Time"
--[[Translation missing --]]
L["Time Format"] = "Time Format"
--[[Translation missing --]]
L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
L["TINKER"] = "TINKER"
--[[Translation missing --]]
L["Tooltip Price Format"] = "Tooltip Price Format"
--[[Translation missing --]]
L["Tooltip Settings"] = "Tooltip Settings"
--[[Translation missing --]]
L["Top Buyers:"] = "Top Buyers:"
--[[Translation missing --]]
L["Top Item:"] = "Top Item:"
--[[Translation missing --]]
L["Top Sellers:"] = "Top Sellers:"
L["Total"] = "Total"
--[[Translation missing --]]
L["Total Gold"] = "Total Gold"
--[[Translation missing --]]
L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
--[[Translation missing --]]
L["Total Gold Earned:"] = "Total Gold Earned:"
--[[Translation missing --]]
L["Total Gold Spent:"] = "Total Gold Spent:"
--[[Translation missing --]]
L["Total Price"] = "Total Price"
--[[Translation missing --]]
L["Total Profit:"] = "Total Profit:"
L["Total Value"] = "Valor total"
--[[Translation missing --]]
L["Total Value of All Items"] = "Total Value of All Items"
--[[Translation missing --]]
L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
--[[Translation missing --]]
L["Transform Value"] = "Transform Value"
--[[Translation missing --]]
L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
--[[Translation missing --]]
L["TSM Crafting"] = "TSM Crafting"
--[[Translation missing --]]
L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
--[[Translation missing --]]
L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
--[[Translation missing --]]
L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
--[[Translation missing --]]
L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
--[[Translation missing --]]
L["TSM Mailing"] = "TSM Mailing"
--[[Translation missing --]]
L["TSM TASK LIST"] = "TSM TASK LIST"
--[[Translation missing --]]
L["TSM Vendoring"] = "TSM Vendoring"
L["TSM Version Info:"] = "TSM Versión Info:"
--[[Translation missing --]]
L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
--[[Translation missing --]]
L["TSM4"] = "TSM4"
--[[Translation missing --]]
L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
--[[Translation missing --]]
L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
--[[Translation missing --]]
L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
L["TUJ Global Median"] = "TUJ Global Median"
L["Twitter Integration"] = "Integración de Twitter"
--[[Translation missing --]]
L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
--[[Translation missing --]]
L["Type"] = "Type"
--[[Translation missing --]]
L["Type Something"] = "Type Something"
--[[Translation missing --]]
L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
L["Unbalanced parentheses."] = "Paréntesis no balanceados."
--[[Translation missing --]]
L["Undercut amount:"] = "Undercut amount:"
--[[Translation missing --]]
L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
--[[Translation missing --]]
L["Undercutting competition."] = "Undercutting competition."
L["Ungrouped Items"] = "Artículos sin grupo"
--[[Translation missing --]]
L["Unknown Item"] = "Unknown Item"
L["Unwrap Gift"] = "Abrir regalo"
L["Up"] = "Arriba"
L["Up to date"] = "A día de hoy"
--[[Translation missing --]]
L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
L["Updating"] = "Actualizando"
L["Usage: /tsm price <ItemLink> <Price String>"] = "Uso: / tsm price <ItemLink> <Price String>"
--[[Translation missing --]]
L["Use smart average for purchase price"] = "Use smart average for purchase price"
L["Use the field below to search the auction house by filter"] = "Usa el siguiente campo para buscar en la casa de subastas por filtro"
L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Usa la lista de la izquierda para seleccionar los grupos y operaciones para los que deseas crear cadenas de exportación."
--[[Translation missing --]]
L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
L["Variable Name"] = "Variable Name"
--[[Translation missing --]]
L["Vendor"] = "Vendor"
--[[Translation missing --]]
L["Vendor Buy Price"] = "Vendor Buy Price"
--[[Translation missing --]]
L["Vendor Search"] = "Vendor Search"
L["VENDOR SEARCH"] = "BÚSQUEDA DE VENDEDORES"
--[[Translation missing --]]
L["Vendor Sell"] = "Vendor Sell"
--[[Translation missing --]]
L["Vendor Sell Price"] = "Vendor Sell Price"
--[[Translation missing --]]
L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNING: The macro was too long, so was truncated to fit by WoW."
--[[Translation missing --]]
L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
--[[Translation missing --]]
L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
--[[Translation missing --]]
L["When above maximum:"] = "When above maximum:"
--[[Translation missing --]]
L["When below minimum:"] = "When below minimum:"
L["Whitelist"] = "Lista blanca"
L["Whitelisted Players"] = "Jugadores de la lista blanca"
--[[Translation missing --]]
L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
L["You cannot use %s as part of this custom price."] = "No se puede utilizar %s como parte de este precio personalizado."
--[[Translation missing --]]
L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
--[[Translation missing --]]
L["You don't know how to craft this item."] = "You don't know how to craft this item."
L["You must reload your UI for these settings to take effect. Reload now?"] = "Debes volver a cargar la interfaz de usuario para esta configuración surta efecto. ¿Actualizar ahora?"
L["You won an auction for %sx%d for %s"] = "Has ganado el artículo %sx%d en subasta por %s"
--[[Translation missing --]]
L["Your auction has not been undercut."] = "Your auction has not been undercut."
--[[Translation missing --]]
L["Your auction of %s expired"] = "Your auction of %s expired"
L["Your auction of %s has sold for %s!"] = "Tu subasta %s ha sido vendida por %s!"
--[[Translation missing --]]
L["Your Buyout"] = "Your Buyout"
--[[Translation missing --]]
L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
L["Your task list is currently empty."] = "Your task list is currently empty."
L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Has sido faseado, lo que ha causado que la AH deje de funcionar debido a un error por parte de Blizzard. Por favor, cierra y vuelve a abrir la AH y reinicia Sniper."
--[[Translation missing --]]
L["You've been undercut."] = "You've been undercut."
	elseif locale == "esMX" then

	elseif locale == "frFR" then
L = L or {}
L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group:Groups; Sélectionné (%d |4Objet:Objets;)"
L["%d auctions"] = "%d enchères"
L["%d Groups"] = "%d Groupes"
L["%d Items"] = "%d Objets"
L["%d of %d"] = "%d de %d"
L["%d Operations"] = "%d Opérations"
L["%d Posted Auctions"] = "%d Enchères publiées"
L["%d Sold Auctions"] = "%d Enchères vendues"
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s sacs, %s banque, %s HV, %s courrier)"
L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s joueur, %s alts, %s guilde, %s AH)"
L["%s (%s profit)"] = "%s (%s gain)"
L["%s |4operation:operations;"] = "%s |4operation:operations;"
L["%s ago"] = "%s depuis"
L["%s Crafts"] = "%s Artisanat"
L["%s group updated with %d items and %d materials."] = "Groupe %s mis à jour avec %d objets et %d matériaux."
L["%s in guild vault"] = "%s dans la banque de guilde"
L["%s is a valid custom price but %s is an invalid item."] = "%s est un prix personnalisé valide mais %s est un objet invalide."
L["%s is a valid custom price but did not give a value for %s."] = "%s est un prix personnalisé valide mais ne donne aucune valeur pour %s."
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' est une opération invalide ! Le stock minimum de %d est plus élevé que le stock maximum de %d"
L["%s is not a valid custom price and gave the following error: %s"] = "%s est un prix personnalisé invalide car il affiche cette erreur : %s"
L["%s Operations"] = "%s Opérations"
L["%s previously had the max number of operations, so removed %s."] = "%s avait auparavant le nombre maximal d'opérations, donc supprimé %s."
L["%s removed."] = "%s supprimé."
L["%s sent you %s"] = "%s vous a envoyé %s"
L["%s sent you %s and %s"] = "%s vous a envoyé %s et %s"
L["%s sent you a COD of %s for %s"] = "%s vous a envoyé un courrier C.R. de %s pour %s"
L["%s sent you a message: %s"] = "%s vous a envoyé un message %s"
L["%s total"] = "%s au total"
L["%sDrag%s to move this button"] = "%sFaites glisser%s pour déplacer ce bouton"
L["%sLeft-Click%s to open the main window"] = "%sClic gauche%s pour ouvrir la fenêtre principale"
L["(%d/500 Characters)"] = "(%d/500 Personnages)"
L["(max %d)"] = "(max %d)"
L["(max 5000)"] = "(max 5000)"
L["(min %d - max %d)"] = "(min %d - max %d)"
L["(min 0 - max 10000)"] = "(min 0 - max 10000)"
L["(minimum 0 - maximum 20)"] = "(minimum 0 - maximum 20)"
L["(minimum 0 - maximum 2000)"] = "(minimum 0 - maximum 2000)"
L["(minimum 0 - maximum 905)"] = "(minimum 0 - maximum 905)"
L["(minimum 0.5 - maximum 10)"] = "(minimum 0.5 - maximum 10)"
L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Afficher cette liste d'aide"
L["/tsm|r - opens the main TSM window."] = "/tsm|r - Ouvrir la fenêtre principale de TSM."
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r Lorsque TSM_Accounting a sauvegardé les données pour ce royaume, leur volume était trop grand pour être géré par le jeu, les anciennes données ont ainsi étés automatiquement tronquées afin d'éviter toute corruption des variables sauvegardées. Les derniers %s de données d’achat ont été préservées."
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r Lors de la dernière sauvegarde de TSM_Accounting dans ce royaume, il était trop volumineux pour être supporté par WOW, donc les anciennes données ont étés automatiquement tronquées afin d'éviter toute corruption des variables sauvegardées. Les derniers %s des données de vente ont été préservés."
L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Clic gauche|r pour ignorer un objet pour cette session. Maintenir |cffffd839Shift|r pour ignorer définitivement. Vous pouvez supprimer les objets ignorés de façon permanente dans les paramètres de vente."
L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Clic gauche|r pour ignorer un objet pour cette session."
L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Clic gauche|r pour l'ignorer de façon permanente."
L["1 Group"] = "1 Groupe"
L["1 Item"] = "1 Objet"
L["12 hr"] = "12 h"
L["24 hr"] = "24H"
L["48 hr"] = "48H"
L["A custom price of %s for %s evaluates to %s."] = "Un prix personnalisé de %s pour %s évalué à %s."
L["A maximum of 1 convert() function is allowed."] = "Un maximum d'une fonction convert() est autorisé."
L["A profile with that name already exists on the target account. Rename it first and try again."] = "Un profil portant ce nom existe déjà sur le compte cible. Renommez-le d'abord et réessayez."
L["A profile with this name already exists."] = "Un profil portant ce nom existe déjà."
L["A scan is already in progress. Please stop that scan before starting another one."] = "Un scan est en cours actuellement. Arrêtez le scan avant d'en démarrer un nouveau."
L["Above max expires."] = "Nombre maximal de dépôts atteind"
L["Above max price. Not posting."] = "Au-dessus du prix maximum. Pas d'enchère créée."
L["Above max price. Posting at max price."] = "Au-dessus du prix maximum. Poster au prix max."
L["Above max price. Posting at min price."] = "Au-dessus du prix maximum. Poster au prix min."
L["Above max price. Posting at normal price."] = "Au-dessus du prix maximum. Poster au prix normal"
L["Accepting these item(s) will cost"] = "Accepter ces objets coûtera"
L["Accepting this item will cost"] = "Accepter cet objet coûtera"
L["Account sync removed. Please delete the account sync from the other account as well."] = "La synchronisation de compte a été supprimée. Supprimez également la synchronisation de compte de l'autre compte."
L["Account Syncing"] = "Synchronisation de compte"
L["Accounting"] = "Comptabilité"
L["Accounting Tooltips"] = "Info-bulles de comptabilité"
L["Activity Type"] = "Type d'activité"
L["ADD %d ITEMS"] = "AJOUTER %d OBJETS"
L["Add / Remove Items"] = "Ajouter / Supprimer des objets"
L["ADD NEW CUSTOM PRICE SOURCE"] = "AJOUTER UNE NOUVELLE SOURCE DE PRIX PERSONNALISÉE"
L["ADD OPERATION"] = "AJOUTER  UNE OPÉRATION"
L["Add Player"] = "Ajouter un joueur"
L["Add Subject / Description"] = "Ajouter un sujet / Description"
L["Add Subject / Description (Optional)"] = "Ajouter un sujet / une description (facultatif)"
L["ADD TO MAIL"] = "AJOUTER AU MAIL"
L["Added '%s' profile which was received from %s."] = "Le profil '%s' ajouté a été reçu de %s."
L["Added %s to %s."] = "Ajout de %s à %s."
L["Additional error suppressed"] = "Erreur(s) additionelle(s) supprimée(s)"
L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Ajustez les paramètres ci-dessous pour définir le mode de vente aux enchères des groupes liés à cette opération."
L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Ajustez les paramètres ci-dessous pour définir le mode d'annulation des groupes liés à cette opération."
L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Ajustez les paramètres ci-dessous pour définir la mise à prix des groupes liés à cette opération."
L["Advanced Item Search"] = "Recherche avancée d'objet"
L["Advanced Options"] = "Options avancées"
L["AH"] = "HV"
L["AH (Crafting)"] = "HV (Artisanat)"
L["AH (Disenchanting)"] = "HV (Désenchantement)"
L["AH BUSY"] = "HV OCCUPÉ"
L["AH Frame Options"] = "HV Panneau des options"
L["Alarm Clock"] = "Alarme"
L["All Auctions"] = "Toutes les enchères"
L["All Characters and Guilds"] = "Tous les personnages et Guildes"
L["All Item Classes"] = "Toutes les classes d'objets"
L["All Professions"] = "Tous les métiers"
L["All Subclasses"] = "Toutes les sous-classes"
L["Allow partial stack?"] = "Autoriser les piles partielles ?"
L["Alt Guild Bank"] = "Banque de guilde du reroll"
L["Alts"] = "Rerolls"
L["Alts AH"] = "AH des rerolls"
L["Amount"] = "Montant"
L["AMOUNT"] = "MONTANT"
L["Amount of Bag Space to Keep Free"] = "Nombre d'emplacements de sac à garder vide."
L["APPLY FILTERS"] = "APPLIQUER LES FILTRES"
L["Apply operation to group:"] = "Appliquer l'opération au groupe :"
L["Are you sure you want to clear old accounting data?"] = "Êtes-vous sûr de vouloir effacer les anciennes données comptable ?"
L["Are you sure you want to delete this group?"] = "Êtes-vous sûr de vouloir supprimer ce groupe ?"
L["Are you sure you want to delete this operation?"] = "Êtes-vous sûr de vouloir supprimer cette opération ?"
L["Are you sure you want to reset all operation settings?"] = "Êtes-vous sûr de vouloir réinitialiser tous les paramètres de fonctionnement ?"
L["At above max price and not undercut."] = "Au delà du prix maxi, sans concurrence."
L["At normal price and not undercut."] = "Prix normal, sans concurrence."
L["Auction"] = "Enchère"
L["Auction Bid"] = "Offre en enchère"
L["Auction Buyout"] = "Achat aux enchères"
L["AUCTION DETAILS"] = "DÉTAILS DE L’ENCHÈRE"
L["Auction Duration"] = "Durée de l'enchère"
L["Auction has been bid on."] = "L'offre a été mise aux enchères."
L["Auction House Cut"] = "Commission de l'hôtel des ventes"
L["Auction Sale Sound"] = "Notification sonore du placement d'enchères"
L["Auction Window Close"] = "Fermer la fenêtre d’enchère"
L["Auction Window Open"] = "Ouvrir la fenêtre d’enchère"
L["Auctionator - Auction Value"] = "Auctionator - Valeur de l'enchère"
L["AuctionDB - Market Value"] = "AuctionDB - Valeur marchande"
L["Auctioneer - Appraiser"] = "Auctioneer - Expertise"
L["Auctioneer - Market Value"] = "Auctioneer - Valeur du marché"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - Achat minimum"
L["Auctioning"] = "Mise aux Enchères"
L["Auctioning Log"] = "Historique des mises aux enchères"
L["Auctioning Operation"] = "Opération de vente aux enchères"
L["Auctioning 'POST'/'CANCEL' Button"] = "Mise aux enchères bouton 'POST' / 'ANNULER'"
L["Auctioning Tooltips"] = "Info-bulles d'enchères"
L["Auctions"] = "Enchères"
L["Auto Quest Complete"] = "Valider les quêtes automatiquement"
L["Average Earned Per Day:"] = "Moyenne gagnée par jour :"
L["Average Prices:"] = "Prix moyens :"
L["Average Profit Per Day:"] = "Bénéfice moyen par jour :"
L["Average Spent Per Day:"] = "Moyenne des dépenses par jour:"
L["Avg Buy Price"] = "Prix d'achat moyen"
L["Avg Resale Profit"] = "Bénéfice moyen de revente"
L["Avg Sell Price"] = "Prix de vente moyen"
L["BACK"] = "RETOUR"
L["BACK TO LIST"] = "RETOUR À LA LISTE"
L["Back to List"] = "Retour à la liste"
L["Bag"] = "Sac"
L["Bags"] = "Sacs"
L["Banks"] = "Banques"
L["Base Group"] = "Groupe par défaut"
L["Base Item"] = "Élément de base"
L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Ci-dessous sont organisées les source de prix disponibles par module. La %skey|r serait ce que vous taperiez dans un champ de prix personnalisé."
L["Below custom price:"] = "En dessous du prix personnalisé:"
L["Below min price. Posting at max price."] = "En dessous du prix min. Posté au prix max."
L["Below min price. Posting at min price."] = "En dessous du prix min. posté au prix min."
L["Below min price. Posting at normal price."] = "En dessous du prix min. Posté au prix normal."
L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Ci-dessous, vous pouvez gérer vos profils, ce qui vous permet d’avoir des ensembles de groupes entièrement différents."
L["BID"] = "OFFRE"
L["Bid %d / %d"] = "Offre %d / %d"
L["Bid (item)"] = "Offre (acticle)"
L["Bid (stack)"] = "Offre (pile)"
L["Bid Price"] = "Prix de l'offre"
L["Bid Sniper Paused"] = "Sniper d'enchères en pause"
L["Bid Sniper Running"] = "Sniper d'enchères démarré"
L["Bidding Auction"] = "Offre aux enchères"
L["Blacklisted players:"] = "Joueurs sur la liste noire:"
L["Bought"] = "Acheté"
L["Bought %d of %s from %s for %s"] = "A acheté %d de %s à %s pour %s"
L["Bought %sx%d for %s from %s"] = "A acheté %sx%d pour %s à %s"
L["Bound Actions"] = "Actions liées"
L["BUSY"] = "OCCUPÉE"
L["BUY"] = "ACHETER"
L["Buy"] = "Acheter"
L["Buy %d / %d"] = "Achetez %d / %d"
L["Buy %d / %d (Confirming %d / %d)"] = "Achetez %d  /%d (Confirmant %d / %d)"
L["Buy from AH"] = "Acheter à HV"
L["Buy from Vendor"] = "Acheter au marchand"
L["BUY GROUPS"] = "ACHETER LES GROUPES"
L["Buy Options"] = "Options d'achat"
L["BUYBACK ALL"] = "TOUT ACHETER"
L["Buyer/Seller"] = "Acheteur/Vendeur"
L["BUYOUT"] = "ACHETER"
L["Buyout (item)"] = "Acheter (item)"
L["Buyout (stack)"] = "Acheter (pile)"
L["Buyout Confirmation Alert"] = "Alerte de confirmation de rachat"
L["Buyout Price"] = "Prix de rachat"
L["Buyout Sniper Paused"] = "Sniper de rachat en pause"
L["Buyout Sniper Running"] = "Sniper en cours d'exécution"
L["BUYS"] = "ACHETER"
L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "Par défaut, ce groupe héberge tous les éléments non affectés à un groupe. Vous ne pouvez pas modifier ou supprimer ce groupe."
L["Cancel auctions with bids"] = "Annuler les enchères avec des offres."
L["Cancel Scan"] = "Annuler le scan"
L["Cancel to repost higher?"] = "Annuler pour recréer plus haut?"
L["Cancel undercut auctions?"] = "Annuler enchères concurrencées ?"
L["Canceling"] = "Annuler"
L["Canceling %d / %d"] = "Annulation %d / %d"
L["Canceling %d Auctions..."] = "Annulation des %d enchères ..."
L["Canceling all auctions."] = "Annuler toutes les enchères."
L["Canceling auction which you've undercut."] = "Annuler vos propres sous-enchères."
L["Canceling disabled."] = "Annulation désactivée."
L["Canceling Settings"] = "Annuler les paramètres"
L["Canceling to repost at higher price."] = "Annuler pour recréer à un prix plus élevé."
L["Canceling to repost at reset price."] = "Annuler pour recréer au prix initial."
L["Canceling to repost higher."] = "Annuler pour recréer plus haut."
L["Canceling undercut auctions and to repost higher."] = "Annuler enchères concurrencées et  replacement à prix plus élevé."
L["Canceling undercut auctions."] = "Retirer enchères concurrencées."
L["Cancelled"] = "Annulé"
L["Cancelled auction of %sx%d"] = "Annuler la vente aux enchères de %sx%d"
L["Cancelled Since Last Sale"] = "Annulé depuis la dernière vente"
L["CANCELS"] = "ANNULE"
L["Cannot repair from the guild bank!"] = "Impossible de réparer depuis la banque de guilde!"
L["Can't load TSM tooltip while in combat"] = "Ne pas charger l'infobulle TSM pendant le combat"
L["Cash Register"] = "Caisse"
L["CHARACTER"] = "PERSONNAGE"
L["Character"] = "Personnage"
L["Chat Tab"] = "Onglet Chat"
L["Cheapest auction below min price."] = "Meilleure enchère en dessous du prix minimum."
L["Clear"] = "Effacer"
L["Clear All"] = "Tout effacer"
L["CLEAR DATA"] = "EFFACER LES DONNÉES"
L["Clear Filters"] = "Effacer les filtres"
L["Clear Old Data"] = "Effacer les anciennes données"
L["Clear Old Data Confirmation"] = "Confirmation d'effacer toutes les anciennes données."
L["Clear Queue"] = "Effacer la file d'attente"
L["Clear Selection"] = "Effacer la sélection"
L["COD"] = "C.R."
L["Coins (%s)"] = "Pièces (%s)"
L["Collapse All Groups"] = "Réduire tous les groupes"
L["Combine Partial Stacks"] = "Combiner des piles partielles"
L["Combining..."] = "Compilation...."
L["Configuration Scroll Wheel"] = "configuration de la molette de défilement"
L["Confirm"] = "Confirmer"
L["Confirm Complete Sound"] = "Confirmer le son complet"
L["Confirming %d / %d"] = "Confirmation de %d / %d"
L["Connected to %s"] = "Connecté à %s"
L["Connecting to %s"] = "Connexion à %s"
L["CONTACTS"] = "CONTACTS"
L["Contacts Menu"] = "Menu des contacts"
L["Cooldown"] = "Cooldown"
L["Cooldowns"] = "Cooldowns"
L["Cost"] = "Coût"
L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Impossible de créer une macro car vous en avez déjà trop. Supprimez l'une de vos macros existantes et réessayez."
L["Could not find profile '%s'. Possible profiles: '%s'"] = "Profil '%s' introuvable. Profils possibles: '%s'"
L["Could not sell items due to not having free bag space available to split a stack of items."] = "Impossible de vendre des articles en raison du manque d'espace libre dans votre sac pour séparer une pile d'articles."
L["Craft"] = "Artisanat"
L["CRAFT"] = "ARTISANAT"
L["Craft (Unprofitable)"] = "Artisanat (non rentable)"
L["Craft (When Profitable)"] = "Artisanat (rentable)"
L["Craft All"] = "Fabriquer tout"
L["CRAFT ALL"] = "FABRIQUER TOUT"
L["Craft Name"] = "Nom de l'artisanat"
L["CRAFT NEXT"] = "FABRIQUER LE SUIVANT"
L["Craft value method:"] = "Méthode d'évaluation de l'artisanat :"
L["CRAFTER"] = "ARTISAN"
L["CRAFTING"] = "ARTISANAT"
L["Crafting"] = "Artisanat"
L["Crafting Cost"] = "Cout de l'artisanat"
L["Crafting 'CRAFT NEXT' Button"] = "Fabriquer avec le bouton 'FABRIQUER LE SUIVANT'"
L["Crafting Queue"] = "File d'attente d'artisanat"
L["Crafting Tooltips"] = "Info-bulles d’artisanat"
L["Crafts"] = "Artisanat"
L["Crafts %d"] = "Artisanat %d"
L["CREATE MACRO"] = "CRÉER MACRO"
L["Create New Operation"] = "Créer  une Nouvelle Opération"
L["CREATE NEW PROFILE"] = "CRÉER UN NOUVEAU PROFIL"
L["Create Profession Group"] = "Créer un groupe de professions"
L["Created custom price source: |cff99ffff%s|r"] = "Source de prix personnalisée créée: |cff99ffff%s|r"
L["Crystals"] = "Cristaux"
L["Current Profiles"] = "Profils actuels"
L["CURRENT SEARCH"] = "RECHERCHE ACTUELLE"
L["CUSTOM POST"] = "MISE AUX ENCHÈRES PERSONNALISÉ"
L["Custom Price"] = "Prix personnalisé"
L["Custom Price Source"] = "Source de prix spécifique"
L["Custom Sources"] = "Source personnalisé"
L["Database Sources"] = "Sources de la base de données"
L["Default Craft Value Method:"] = "Méthode de valeur de l'artisanat par défaut:"
L["Default Material Cost Method:"] = "Méthode de coût des matériaux par défaut:"
L["Default Price"] = "Prix par défaut"
L["Default Price Configuration"] = "Configuration des prix par défaut"
L["Define what priority Gathering gives certain sources."] = "Définir avec quelle priorité récolter donne certaines sources."
L["Delete Profile Confirmation"] = "Confirmation de la suppression du profil"
L["Delete this record?"] = "Supprimer cet enregistrement ?"
L["Deposit"] = "Dépôt"
L["Deposit Cost"] = "Coût du dépôt"
L["Deposit Price"] = "Prix du dépôt"
L["DEPOSIT REAGENTS"] = "RÉACTIFS DE DÉPÔT"
L["Deselect All Groups"] = "Déselectionner tous les groupes"
L["Deselect All Items"] = "Désélectionner tous les objets"
L["Destroy Next"] = "Détruire le suivant"
L["Destroy Value"] = "Détruire Valeur"
L["Destroy Value Source"] = "Détruire la source de valeur"
L["Destroying"] = "Détruire"
L["Destroying 'DESTROY NEXT' Button"] = "Détruire le bouton 'DÉTRUIRE LE SUIVANT'."
L["Destroying Tooltips"] = "Info-bulle de destruction"
L["Destroying..."] = "Destruction..."
L["Details"] = "Détails"
L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "N'a pas annulé %s car votre seuil d'annulation pour remettre aux enchères (%s) n'est pas valide. Vérifiez vos paramètres."
L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "N'a pas annulé %s parce que votre prix maximum (%s) est invalide. Vérifiez vos paramètres."
L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "N'a pas annulé %s parce que votre prix maximum (%s) est plus bas que votre prix minimum (%s). Vérifiez vos paramètres."
L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "N'a pas annulé %s parce que votre prix minimum (%s) est invalide. Vérifiez vos paramètres."
L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "N'a pas annulé %s parce que votre prix normal (%s) est invalide. Vérifiez vos paramètres."
L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "N'a pas annulé %s parce que votre prix normal (%s) est plus bas que votre prix minimum (%s). Vérifiez vos paramètres."
L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "%s non annulé car votre sous-enchère (%s) est invalide. Vérifiez vos paramètres."
L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "N'a pas inscrit %s parce que Blizzard n'a pas fourni toutes les informations nécessaires pour cela. Réessayer plus tard."
L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "N'a pas inscrit %s parce que le propriétaire de l'enchère la plus basse (%s) est à la fois sur la liste noire et la liste blanche ce qui n'est pas permis. Ajuster vos paramètres pour corriger cette erreur."
L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "N'a pas inscrit %s parce que vous ou un de vos rerolls (%s) est sur la liste noire ce qui n'est pas permis. Retirez ce personnage de votre liste noire."
L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "N'a pas inscrit %s parce que votre prix maximum (%s) est invalide. Vérifiez vos paramètres."
L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "N'a pas inscrit %s parce que votre prix maximum (%s) est plus bas que votre prix minimum (%s). Vérifiez vos paramètres."
L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "N'a pas inscrit %s parce que votre prix minimum (%s) est invalide. Vérifiez vos paramètres."
L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "N'a pas inscrit %s parce que votre prix normal (%s) est invalide. Vérifiez vos paramètres."
L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "N'a pas inscrit %s parce que votre prix normal (%s) est plus bas que votre prix minimum (%s). Vérifiez vos paramètres."
L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "%s non placée car votre sous-enchère (%s) est invalide. Vérifiez vos paramètres."
L["Disable invalid price warnings"] = "Désactiver les alertes des prix invalides."
L["Disenchant Search"] = "Recherche désenchantement"
L["DISENCHANT SEARCH"] = "RECHERCHE DESENCHANTEMENT"
L["Disenchant Search Options"] = "Option de la recherche désenchantement"
L["Disenchant Value"] = "Valeur de désenchantement"
L["Disenchanting Options"] = "Option de désenchantement"
L["Display auctioning values"] = "Afficher les valeurs d'enchères"
L["Display cancelled since last sale"] = "Afficher les annulés depuis la dernière vente"
L["Display crafting cost"] = "Afficher le coût des objets artisanaux"
L["Display detailed destroy info"] = "Afficher les informations détaillées de destruction"
L["Display disenchant value"] = "Afficher la valeur de désenchantement"
L["Display expired auctions"] = "Afficher les enchères expirées"
L["Display group name"] = "Afficher le nom du groupe"
L["Display historical price"] = "Afficher le prix historique"
L["Display market value"] = "Afficher la valeur du marché"
L["Display mill value"] = "Afficher la valeur du broyeur"
L["Display min buyout"] = "Afficher le prix de rachat min"
L["Display Operation Names"] = "Afficher le nom des opérations"
L["Display prospect value"] = "Afficher la valeur de prospection"
L["Display purchase info"] = "Afficher les informations d'achat"
L["Display region historical price"] = "Afficher le prix historique régional"
L["Display region market value avg"] = "Afficher la valeur moyenne du marché régional"
L["Display region min buyout avg"] = "Afficher l'achat minimum moyen régional"
L["Display region sale avg"] = "Afficher la vente moyenne régionale"
L["Display region sale rate"] = "Afficher le taux de vente régional"
L["Display region sold per day"] = "Afficher les ventes par jour régionales"
L["Display sale info"] = "Afficher les informations de vente"
L["Display sale rate"] = "Afficher le taux de vente"
L["Display shopping max price"] = "Afficher le prix maximum d'achat"
L["Display total money recieved in chat?"] = "Afficher le total de l'argent reçu dans la messagerie ?"
L["Display transform value"] = "Afficher la valeur de transformation"
L["Display vendor buy price"] = "Afficher le prix d'achat du vendeur"
L["Display vendor sell price"] = "Afficher le prix de vente au vendeur."
L["Doing so will also remove any sub-groups attached to this group."] = "Faire ceci va aussi enlever tous les sous-groupes attachés à ce groupe."
L["Done Canceling"] = "Faire l'annulation"
L["Done Posting"] = "Faire l'inscription"
L["Done rebuilding item cache."] = "Faire une reconstruction du cache des objets."
L["Done Scanning"] = "Faire le scan"
L["Don't post after this many expires:"] = "N'inscrivez plus après ce nombre de fois :"
L["Don't Post Items"] = "Ne pas inscrire les objets"
L["Don't prompt to record trades"] = "Ne pas demander d'enregistrer les transactions"
L["DOWN"] = "BAS"
L["Drag in Additional Items (%d/%d Items)"] = "Glisser dans les objets additionnels (%d/%d Objets)"
L["Drag Item(s) Into Box"] = "Glisser les objet(s) dans la boite"
L["Duplicate"] = "Dupliqué"
L["Duplicate Profile Confirmation"] = "Confirmation de la duplication du profile"
L["Dust"] = "Poussière"
L["Elevate your gold-making!"] = "Augmenter votre gain d'or !"
L["Embed TSM tooltips"] = "info-bulles TSM embarquées"
L["EMPTY BAGS"] = "SACS VIDES"
L["Empty parentheses are not allowed"] = "Les parenthèses vides ne sont pas autorisées"
L["Empty price string."] = "Chaine de prix vide."
L["Enable automatic stack combination"] = "Activer la combinaison automatique des piles"
L["Enable buying?"] = "Permettre l'achat ?"
L["Enable inbox chat messages"] = "Activer les messages de discussion dans la boîte de réception"
L["Enable restock?"] = "Activer le réapprovisionnement?"
L["Enable selling?"] = "Activer la vente ?"
L["Enable sending chat messages"] = "Activer l'envoi de messages de discussion"
L["Enable TSM Tooltips"] = "Activer les info-bulles TSM"
L["Enable tweet enhancement"] = "Activer l'amélioration Tweeter"
L["Enchant Vellum"] = "Vélin d'enchantement"
L["Ensure both characters are online and try again."] = "Assurez vous que les deux personnages connectés et réessayez"
L["Enter a name for the new profile"] = "Saisir un nom pour le nouveau profil"
L["Enter Filter"] = "Entrer un filtre"
L["Enter Keyword"] = "Entrer un mot-clé"
L["Enter name of logged-in character from other account"] = "Saisir le nom du personnage authentifié depuis un autre compte"
L["Enter player name"] = "Entrer le nom d'un joueur"
L["Essences"] = "Essences"
L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Connexion en cours avec %s. Assurez-vous d'avoir bien entré le nom de ce personnage sur l'autre compte."
L["Estimated Cost:"] = "Coût estimé :"
L["Estimated deliver time"] = "Temps de livraison estimé"
L["Estimated Profit:"] = "Bénéfice estimé :"
L["Exact Match Only?"] = "Correspondance exacte ?"
L["Exclude crafts with cooldowns"] = "Exclure les fabrications avec un durée de recharge"
L["Expand All Groups"] = "Développer tous les groupes."
L["Expenses"] = "Frais"
L["EXPENSES"] = "FRAIS"
L["Expirations"] = "Expirations"
L["Expired"] = "Expiré"
L["Expired Auctions"] = "Enchères expirées"
L["Expired Since Last Sale"] = "Expiré depuis la dernière vente"
L["Expires"] = "Expire"
L["EXPIRES"] = "EXPIRE"
L["Expires Since Last Sale"] = "Expiré depuis la dernière vente."
L["Expiring Mails"] = "Courriels expirés"
L["Exploration"] = "Exploration"
L["Export"] = "Export"
L["Export List"] = "Exporter la liste"
L["Failed Auctions"] = "Enchères échouées"
L["Failed Since Last Sale (Expired/Cancelled)"] = "Échoué depuis la dernière vente (Expiré/Annulé)"
L["Failed to bid on auction of %s (x%s) for %s."] = "Échec de l'offre sur l'enchère de %s (x%s) pour %s."
L["Failed to bid on auction of %s."] = "Échec de l'offre sur l'enchère de %s."
L["Failed to buy auction of %s (x%s) for %s."] = "Échec d'achat de l'enchère de %s (x%s) pour %s."
L["Failed to buy auction of %s."] = "Échec de l'achat de l'enchère de %s."
L["Failed to find auction for %s, so removing it from the results."] = "Échec de la recherche de l'enchère pour %s, donc le retirer des résultats."
L["Failed to post %sx%d as the item no longer exists in your bags."] = "A échoué à poster %sx%d puisque l'objet n'existe plus dans vos sacs."
L["Failed to send profile."] = "Échec d'envoi du profile."
L["Failed to send profile. Ensure both characters are online and try again."] = "Échec d'envoi du profil. Assurez vous que les deux personnages sont connectés et réessayez."
L["Favorite Scans"] = "Scans favoris"
L["Favorite Searches"] = "Recherches favorites"
L["Filter Auctions by Duration"] = "Filtrer les enchères par durée"
L["Filter Auctions by Keyword"] = "Filtrer les enchères par mot-clé"
L["Filter by Keyword"] = "Filtrer par mot-clé"
L["FILTER BY KEYWORD"] = "FILTRER PAR MOT-CLÉ"
L["Filter group item lists based on the following price source"] = "Filtrer les listes d'articles du groupe en fonction de la source de prix suivante"
L["Filter Items"] = "Filtrer les objets"
L["Filter Shopping"] = "Filtrer les achats"
L["Finding Selected Auction"] = "Trouver l'enchère sélectionnée"
L["Fishing Reel In"] = "Moulinet de pêche dans"
L["Forget Character"] = "Oublier le personnage"
L["Found auction sound"] = "Trouver le son d'enchère"
L["Friends"] = "Amis"
L["From"] = "De"
L["Full"] = "Plein"
L["Garrison"] = "Garnison"
L["Gathering"] = "Récolte"
L["Gathering Search"] = "Recherche de récolte"
L["General Options"] = "Options générales"
L["Get from Bank"] = "Obtenir de la banque"
L["Get from Guild Bank"] = "Obtenir de la banque de guilde"
L["Global Operation Confirmation"] = "Confirmation d'opération globale"
L["Gold"] = "Or"
L["Gold Earned:"] = "Or gagné :"
L["GOLD ON HAND"] = "RICHESSE ACTUELLE"
L["Gold Spent:"] = "Or dépensé :"
L["GREAT DEALS SEARCH"] = "RECHERCHE DE BONNES AFFAIRES"
L["Group already exists."] = "Le groupe existe déjà."
L["Group Management"] = "Gestion des groupes"
L["Group Operations"] = "Opérations de groupe"
L["Group Settings"] = "Paramètres de groupe"
L["Grouped Items"] = "Objets groupés"
L["Groups"] = "Groupes"
L["Guild"] = "Guilde"
L["Guild Bank"] = "Banque de guilde"
L["GVault"] = "BanqueDeGuilde"
L["Have"] = "Avoir"
L["Have Materials"] = "Avoir du matériel"
L["Have Skill Up"] = "Avoir des compétences"
L["Hide auctions with bids"] = "Masquer les enchères avec des offres"
L["Hide Description"] = "Masquer la description"
L["Hide minimap icon"] = "Cacher l'icône de la mini-carte"
L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Masquer l'interface utilisateur de TSM Bancaire. Tapez  '/tsm bankui' pour la rouvrir."
L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Masquer l'interface utilisateur de la liste e tâches TSM. Tapez '/tsm tasklist' pour la rouvrir."
L["High Bidder"] = "Meilleur offre"
L["Historical Price"] = "Historique des prix"
L["Hold ALT to repair from the guild bank."] = "Maintenir ALT pour réparer à partir d'une banque de guilde."
L["Hold shift to move the items to the parent group instead of removing them."] = "Maintenir Majuscule pour déplacer les objets dans le groupe parent au lieu de les supprimer."
L["Hr"] = "Hr"
L["Hrs"] = "Hrs"
L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "Je viens d'acheter [%s]x%d for %s! %s #TSM4 #warcraft"
L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "Je viens de vendre [%s] pour %s ! %s #TSM4 #warcraft"
L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "Si vous ne souhaitez pas sous-enchérir sur un joueur en particulier, l'ajouter à votre liste blanche permettra à TSM d'ignorer ses sous-enchères. Cependant si un tel joueur place une enchère dont son prix initial est inférieur au vôtre (bien que le prix d'achat soit identique), TSM considèrera alors qu'il s'agit tout de même d'une sous-enchère et placera ainsi vos enchères en conséquence."
L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Si vous avez de multiples profiles configurés avec des opérations, entraînera la perte irréversible de toutes les opérations en cours des profils. Es-vous sur de vouloir continuer ?"
L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "Si vous disposez de la configuration d’intégration Twitter de WoW, TSM ajoutera un lien de partage à ses messages améliorés de vente aux enchères / achat et remplacera les URL par un lien TSM."
L["Ignore Auctions Below Min"] = "Ignorer les enchères sous le minimum"
L["Ignore auctions by duration?"] = "Ignorer les enchères par durée ?"
L["Ignore Characters"] = "Ignorer les personnages"
L["Ignore Guilds"] = "Ignorer les guildes"
L["Ignore item variations?"] = "Ignorer les variations de l'objet ?"
L["Ignore operation on characters:"] = "Ignorer l'opération sur les personnages :"
L["Ignore operation on faction-realms:"] = "Ignorer les opérations sur les royaumes liés à la faction :"
L["Ignored Cooldowns"] = "Temps de recharge ignorés"
L["Ignored Items"] = "Objets ignorés"
L["ilvl"] = "ilvl"
L["Import"] = "Importer"
L["IMPORT"] = "IMPORTER"
L["Import %d Items and %s Operations?"] = "Importer les objets %d et les opérations %s ?"
L["Import Groups & Operations"] = "Importer les Groupes & Opérations"
L["Imported Items"] = "Objets importés"
L["Inbox Settings"] = "Paramètres de boite de réception"
--[[Translation missing --]]
L["Include Attached Operations"] = "Include Attached Operations"
L["Include operations?"] = "Inclure les opérations ?"
L["Include soulbound items"] = "Inclure objets liés"
L["Information"] = "Information"
L["Invalid custom price entered."] = "Prix personnalisé renseigné invalide."
L["Invalid custom price source for %s. %s"] = "La source du prix personnalisable pour %s n'est pas valide. %s"
L["Invalid custom price."] = "Prix spécifique invalide."
L["Invalid function."] = "Fonction invalide."
L["Invalid gold value."] = "Valeur d'or invalide."
L["Invalid group name."] = "Nom de groupe invalide."
L["Invalid import string."] = "Chaine d'import non-valide."
L["Invalid item link."] = "Lien de l'objet invalide."
L["Invalid operation name."] = "Nom d'opération invalide."
L["Invalid operator at end of custom price."] = "Symbole non-valide à la fin du prix paramétrable."
L["Invalid parameter to price source."] = "Paramètre invalide dans la formule du prix"
L["Invalid player name."] = "Nom de joueur invalide."
L["Invalid price source in convert."] = "La source du prix personnalisable dans la conversion n'est pas valide."
L["Invalid price source."] = "La source de prix n'est pas valide."
L["Invalid search filter"] = "Filtre de recherche invalide"
L["Invalid seller data returned by server."] = "L'information du vendeur envoyée par le serveur est non-valide."
L["Invalid word: '%s'"] = "Mot invalide: '%s'"
L["Inventory"] = "Inventaire"
L["Inventory / Gold Graph"] = "Inventaire / Graphique"
L["Inventory / Mailing"] = "Inventaire / Envois"
L["Inventory Options"] = "Options de l'inventaire"
L["Inventory Tooltip Format"] = "Format de l'info-bulle de l'inventaire"
L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "Il semblerait que vous ayez manuellement copié les donnes de TSM depuis un autre répertoire \"saved variables\", ce qui empêchera la synchronisation automatique de fonctionner. Vous devez soit, retirer ce dossier soit le supprimer sur les deux comptes (alors que le jeu est fermé) afin de corriger le problème."
L["Item"] = "Objet"
L["ITEM CLASS"] = "CLASSE D'OBJET"
L["Item Level"] = "Niveau de l'objet"
L["ITEM LEVEL RANGE"] = "ÉCHELLE DE NIVEAU D'OBJET"
L["Item links may only be used as parameters to price sources."] = "Seuls les liens d'objets peuvent-être utilisés en tant que source de prix."
L["Item Name"] = "Nom de l'objet"
L["Item Quality"] = "Qualité de l'objet"
L["ITEM SEARCH"] = "RECHERCHE D'OBJETS"
L["ITEM SELECTION"] = "SELECTION D'OBJETS"
L["ITEM SUBCLASS"] = "SOUS-CATÉGORIE D'OBJET"
L["Item Value"] = "Valeur de l'objet"
L["Item/Group is invalid (see chat)."] = "L'Objet/Groupe est invalide (voir le tchat)."
L["ITEMS"] = "OBJETS"
L["Items"] = "Objets"
L["Items in Bags"] = "Objets dans les sacs"
L["Keep in bags quantity:"] = "Quantité gardée dans les sacs :"
L["Keep in bank quantity:"] = "Quantité gardée dans la banque :"
--[[Translation missing --]]
L["Keep posted:"] = "Keep posted:"
L["Keep quantity:"] = "Quantité gardée:"
L["Keep this amount in bags:"] = "Garder ce montant dans les sacs :"
L["Keep this amount:"] = "Garder ce montant :"
L["Keeping %d."] = "Conserve %d."
L["Keeping undercut auctions posted."] = "Conserve le prix actuel, même si concurrencé."
L["Last 14 Days"] = "14 derniers jours"
L["Last 3 Days"] = "3 derniers jours"
L["Last 30 Days"] = "30 derniers jours"
L["LAST 30 DAYS"] = "30 DERNIERS JOURS"
L["Last 60 Days"] = "60 derniers jours"
L["Last 7 Days"] = "7 derniers jours"
L["LAST 7 DAYS"] = "7 DERNIERS JOURS"
L["Last Data Update:"] = "Dernière MAJ des données :"
L["Last Purchased"] = "Dernier acheté"
L["Last Sold"] = "Dernier vendu"
L["Level Up"] = "Niveau supérieur"
L["LIMIT"] = "LIMITE"
L["Link to Another Operation"] = "Lien vers une autre opération"
L["List"] = "Liste"
L["List materials in tooltip"] = "Lister les composants dans l'info-bulle"
L["Loading Mails..."] = "Chargement du courrier..."
L["Loading..."] = "Chargement..."
L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Il semblerait que TradeSkillMaster ai rencontré une erreur. Merci d'aider les développeurs à la corriger en suivant les instructions affichées."
L["Loop detected in the following custom price:"] = "Boucle détectée pour le prix spécifique suivant :"
L["Lowest auction by whitelisted player."] = "Dernière enchère par joueur autorisé."
L["Macro created and scroll wheel bound!"] = "Macro créée et associée à la molette de la souris !"
L["Macro Setup"] = "Configuration de la Macro"
L["Mail"] = "Mail"
L["Mail Disenchantables"] = "Envoyer les objets désenchantables"
L["Mail Disenchantables Max Quality"] = "Envoyer les objets désenchantables de qualité supérieure"
L["MAIL SELECTED GROUPS"] = "ENVOI AUX GROUPES SÉLECTIONNÉS"
L["Mail to %s"] = "Envoi à %s"
L["Mailing"] = "Envoi"
L["Mailing all to %s."] = "Envoi intégral à %s."
L["Mailing Options"] = "Options d'envoi de courriers"
L["Mailing up to %d to %s."] = "Envoi jusque %d à %s."
L["Main Settings"] = "Paramètres principaux"
L["Make Cash On Delivery?"] = "Envoi en contre-remboursement ?"
--[[Translation missing --]]
L["Management Options"] = "Management Options"
L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Un grand nombre d'actions usuelles de TSM peuvent être ajoutées à une macro et associées à la molette de la souris. Utilisez les options ci-dessous pour paramétrer cette fonction."
L["Map Ping"] = "Ping sur la carte"
L["Market Value"] = "Valeur marchande"
--[[Translation missing --]]
L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
L["Market Value Source"] = "Market Value Source"
L["Mat Cost"] = "Coût des matières premières"
L["Mat Price"] = "Prix des matières premières"
L["Match stack size?"] = "Faire correspondre le nombre d'objets empilables ?"
L["Match whitelisted players"] = "Faire correspondre aux joueurs de la liste blanche"
L["Material Name"] = "Nom du matériau"
L["Materials"] = "Matériaux"
L["Materials to Gather"] = "Matériaux à rassembler"
--[[Translation missing --]]
L["MAX"] = "MAX"
L["Max Buy Price"] = "Prix d'achat max"
--[[Translation missing --]]
L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
L["Max Sell Price"] = "Prix de vente max"
L["Max Shopping Price"] = "Prix d'achat max"
--[[Translation missing --]]
L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
L["MAXIMUM QUANTITY TO BUY:"] = "QUANTITÉ MAXIMALE À ACHETER :"
L["Maximum quantity:"] = "Quantité maximum :"
--[[Translation missing --]]
L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
L["Mill Value"] = "Mill Value"
L["Min"] = "Min"
L["Min Buy Price"] = "Prix d'achat min"
L["Min Buyout"] = "Prix de rachat min"
L["Min Sell Price"] = "Prix de vente min"
L["Min/Normal/Max Prices"] = "Prix Min/Normal/Max"
--[[Translation missing --]]
L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
L["Minimum expires:"] = "Minimum expires:"
L["Minimum profit:"] = "Bénéfice minimum :"
L["MINIMUM RARITY"] = "RARETÉ MINIMUM"
--[[Translation missing --]]
L["Minimum restock quantity:"] = "Minimum restock quantity:"
L["Misplaced comma"] = "Virgule mal placée"
L["Missing Materials"] = "Matériaux manquants"
--[[Translation missing --]]
L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
L["Modifiers:"] = "Modificateurs:"
--[[Translation missing --]]
L["Money Frame Open"] = "Money Frame Open"
L["Money Transfer"] = "Transfert d'argent"
L["Most Profitable Item:"] = "Article le plus rentable:"
L["MOVE"] = "DEPLACER"
L["Move already grouped items?"] = "Déplacer les objets déjà groupés ?"
--[[Translation missing --]]
L["Move Quantity Settings"] = "Move Quantity Settings"
L["MOVE TO BAGS"] = "DEPLACER VERS LES SACS"
L["MOVE TO BANK"] = "DEPLACER VERS LA BANQUE"
L["MOVING"] = "EN DÉPLACEMENT"
L["Moving"] = "En déplacement"
L["Multiple Items"] = "Plusieurs objets"
L["My Auctions"] = "Mes Enchères"
L["My Auctions 'CANCEL' Button"] = "Bouton \"ANNULER\" de mes enchères"
--[[Translation missing --]]
L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
L["NEED MATS"] = "NEED MATS"
L["New Group"] = "Nouveau groupe"
L["New Operation"] = "Nouvelle opération"
L["NEWS AND INFORMATION"] = "NOUVELLES ET INFORMATION"
--[[Translation missing --]]
L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
L["No Crafts"] = "No Crafts"
L["No Data"] = "Aucune donnée"
L["No group selected"] = "Aucun groupe sélectionné"
L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "Aucun objet spécifié. Usage : /tsm restock_help [ITEM_LINK]"
L["NO ITEMS"] = "AUCUN OBJET"
L["No Materials to Gather"] = "Pas de matériaux à rassembler"
L["No Operation Selected"] = "Aucune opération sélectionnée"
--[[Translation missing --]]
L["No posting."] = "No posting."
L["No Profession Opened"] = "Aucun métier ouvert"
L["No Profession Selected"] = "Aucun métier sélectionné"
L["No profile specified. Possible profiles: '%s'"] = "Aucun profil spécifié. Profils possibles : '%s'"
L["No recent AuctionDB scan data found."] = "Pas de scan AuctionDB récent trouvé."
L["No Sound"] = "Pas de son"
L["None"] = "Rien"
L["None (Always Show)"] = "Aucun (toujours afficher)"
L["None Selected"] = "Aucun sélectionné"
--[[Translation missing --]]
L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
L["Normal"] = "Normal"
L["Not canceling auction at reset price."] = "Ne pas annuler les enchères sous le prix de réinitialisation."
L["Not canceling auction below min price."] = "Ne pas annuler les enchères sous le prix minimal."
L["Not canceling."] = "Ne pas annuler."
L["Not Connected"] = "Non connecté"
L["Not enough items in bags."] = "Pas assez d'objets dans les sacs."
L["NOT OPEN"] = "FERMÉ"
L["Not Scanned"] = "Non scanné"
L["Nothing to move."] = "Rien à déplacer."
L["NPC"] = "PNJ"
L["Number Owned"] = "Nombre possédé"
L["of"] = "de"
L["Offline"] = "Hors ligne"
L["On Cooldown"] = "Sur le temps de recharge"
L["Only show craftable"] = "Montrer que les fabriquables"
--[[Translation missing --]]
L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
L["OPEN"] = "OUVERT"
L["OPEN ALL MAIL"] = "TOUT OUVRIR"
L["Open Mail"] = "Ouvrir le courrier"
--[[Translation missing --]]
L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
L["Open Task List"] = "Ouvrir Liste des Tâches"
L["Operation"] = "Opération"
L["Operations"] = "Opérations"
L["Other Character"] = "Autre personnage"
L["Other Settings"] = "Autres paramètres"
L["Other Shopping Searches"] = "Autres recherches d'Achat"
--[[Translation missing --]]
L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
L["Parent Items"] = "Parent Items"
L["Past 7 Days"] = "7 derniers jours"
L["Past Day"] = "Dernières 24 heures"
L["Past Month"] = "30 derniers jours"
L["Past Year"] = "12 derniers mois"
L["Paste string here"] = "Coller du texte ici"
L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Collez votre formule d'importation (import string) dans le champ ci-dessous et cliquez sur 'IMPORTER'. Vous pouvez importer tout ce que vous voulez depuis des listes d'objets (séparées par des virgules svp) à des groupes entiers et structures d'opérations."
L["Per Item"] = "Par objet"
L["Per Stack"] = "Par pile"
L["Per Unit"] = "Par unité"
L["Player Gold"] = "Or du joueur"
L["Player Invite Accept"] = "Accepter l'invitation d'autres joueurs"
L["Please select a group to export"] = "Veuillez sélectionner un groupe à exporter"
--[[Translation missing --]]
L["POST"] = "POST"
L["Post at Maximum Price"] = "Poster au prix maximum"
L["Post at Minimum Price"] = "Poster au prix minimum"
L["Post at Normal Price"] = "Poster au prix normal"
--[[Translation missing --]]
L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
L["Post Scan"] = "Poster le scan"
L["POST SELECTED"] = "POSTER LA SÉLECTION"
L["POSTAGE"] = "FRAIS D'ENVOI"
L["Postage"] = "Frais d'envoi"
L["Posted at whitelisted player's price."] = "Enchère placée au prix d'un joueur en liste blanche."
L["Posted Auctions %s:"] = "Enchères placées %s :"
--[[Translation missing --]]
L["Posting"] = "Posting"
--[[Translation missing --]]
L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
L["Posting at your current price."] = "Posting at your current price."
L["Posting disabled."] = "Mise en vente désactivée."
--[[Translation missing --]]
L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
L["Posts"] = "Posts"
--[[Translation missing --]]
L["Potential"] = "Potential"
L["Price Per Item"] = "Prix par objet"
--[[Translation missing --]]
L["Price Settings"] = "Price Settings"
--[[Translation missing --]]
L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
L["PROFESSION"] = "MÉTIER"
L["Profession Filters"] = "Filtres de métier"
L["Profession Info"] = "Info de métier"
L["Profession loading..."] = "Chargement de métier..."
L["Professions Used In"] = "Métiers utilisés dans"
--[[Translation missing --]]
L["Profile changed to '%s'."] = "Profile changed to '%s'."
L["Profiles"] = "Profils"
L["PROFIT"] = "BENEFICE"
L["Profit"] = "Bénéfice"
L["Prospect Value"] = "Valeur de Prospection"
L["PURCHASE DATA"] = "DONNÉES D'ACHAT"
L["Purchased (Min/Avg/Max Price)"] = "Acheté (Prix Min/Moyen/Max)"
L["Purchased (Total Price)"] = "Acheté (Prix total)"
L["Purchases"] = "Achats"
--[[Translation missing --]]
L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
L["Qty"] = "Qty"
L["Quantity Bought:"] = "Quantité Achetée"
L["Quantity Sold:"] = "quantité vendue :"
L["Quantity to move:"] = "Quantité à déplacer :"
L["Quest Added"] = "Quête ajoutée"
L["Quest Completed"] = "Quête terminée"
--[[Translation missing --]]
L["Quest Objectives Complete"] = "Quest Objectives Complete"
--[[Translation missing --]]
L["QUEUE"] = "QUEUE"
L["Quick Sell Options"] = "Options de Vente Rapide"
L["Quickly mail all excess disenchantable items to a character"] = "Envoie tout objet désenchantable au personnage de votre choix."
L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Envoie tout montant d'Or (limité à un montant restant minimum) à un personnage."
L["Raid Warning"] = "Alerte de Raid"
L["Read More"] = "Lire plus"
--[[Translation missing --]]
L["Ready Check"] = "Ready Check"
L["Ready to Cancel"] = "PRÊT À ANNULER"
--[[Translation missing --]]
L["Realm Data Tooltips"] = "Realm Data Tooltips"
L["Recent Scans"] = "Scans récents"
L["Recent Searches"] = "Recherches récentes"
--[[Translation missing --]]
L["Recently Mailed"] = "Recently Mailed"
L["RECIPIENT"] = "DESTINATAIRE"
--[[Translation missing --]]
L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
L["Region Sale Rate"] = "Region Sale Rate"
L["Reload"] = "Recharger"
L["REMOVE %d |4ITEM:ITEMS;"] = "SUPPRIMER %d |4OBJET:OBJETS;"
--[[Translation missing --]]
L["Removed a total of %s old records."] = "Removed a total of %s old records."
L["Rename"] = "Renommer"
L["Rename Profile"] = "Renommer le profil"
L["REPAIR"] = "RÉPARER"
--[[Translation missing --]]
L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
L["Replace duplicate operations?"] = "Replace duplicate operations?"
L["REPLY"] = "RÉPONDRE"
--[[Translation missing --]]
L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
L["Repost Higher Threshold"] = "Repost Higher Threshold"
L["Required Level"] = "Niveau requis"
--[[Translation missing --]]
L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
L["Requires TSM Desktop Application"] = "Nécessite que l'application TSM soit lancée"
L["Resale"] = "Revendre"
L["RESCAN"] = "RESCANNER"
L["RESET"] = "RÉINITIALISER"
L["Reset All"] = "Tout réinitialiser"
L["Reset Filters"] = "Réinitialiser les filtres"
--[[Translation missing --]]
L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
L["RESTART"] = "REDÉMARRER"
--[[Translation missing --]]
L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
L["Revenue"] = "Revenue"
--[[Translation missing --]]
L["Round normal price"] = "Round normal price"
L["RUN ADVANCED ITEM SEARCH"] = "LANCER LA RECHERCHE AVANCÉE D'OBJETS"
L["Run Bid Sniper"] = "Scan d'OFFRES \"Sniper\""
L["Run Buyout Sniper"] = "Lancer le sniper de rachat"
L["RUN CANCEL SCAN"] = "Scan d'ANNULATION"
L["RUN POST SCAN"] = "Scan de MISE EN VENTE"
L["RUN SHOPPING SCAN"] = "Scan d'ACHATS"
L["Running Sniper Scan"] = "Scan \"SNIPER\""
L["Sale"] = "Vente"
L["SALE DATA"] = "DONNÉES DE VENTE"
L["Sale Price"] = "Prix de vente"
L["Sale Rate"] = "Taux de vente"
L["Sales"] = "Ventes"
L["SALES"] = "VENTES"
L["Sales Summary"] = "Résumé des ventes"
L["SCAN ALL"] = "TOUT SCANNER"
--[[Translation missing --]]
L["Scan Complete Sound"] = "Scan Complete Sound"
L["Scan Paused"] = "Scan Interrompu"
L["SCANNING"] = "SCAN EN COURS"
--[[Translation missing --]]
L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
L["Scroll wheel direction:"] = "Scroll wheel direction:"
L["Search"] = "Recherche"
--[[Translation missing --]]
L["Search Bags"] = "Search Bags"
L["Search Groups"] = "Chercher les groupes"
L["Search Inbox"] = "Rechercher"
--[[Translation missing --]]
L["Search Operations"] = "Search Operations"
--[[Translation missing --]]
L["Search Patterns"] = "Search Patterns"
L["Search Usable Items Only?"] = "Chercher les objets utilisables seulement ?"
L["Search Vendor"] = "Sélectionner un vendeur"
--[[Translation missing --]]
L["Select a Source"] = "Select a Source"
L["Select Action"] = "Sélectionner une action"
L["Select All Groups"] = "Sélectionner tous les groupes"
L["Select All Items"] = "Sélectionner tous les objets"
L["Select Auction to Cancel"] = "Sélectionner une enchère à annuler"
L["Select crafter"] = "Sélectionnez artisan"
L["Select custom price sources to include in item tooltips"] = "Sélectionner des sources de prix personnalisées à inclure dans les info-bulles des articles"
L["Select Duration"] = "Sélectionnez la durée"
L["Select Items to Add"] = "Sélectionner les éléments à ajouter"
L["Select Items to Remove"] = "Sélectionnez les éléments à supprimer"
L["Select Operation"] = "Sélectionnez l'opération"
L["Select professions"] = "Sélectionnez des professions"
--[[Translation missing --]]
L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
L["Selected Groups"] = "Groupes sélectionnés"
L["Selected Operations"] = "Opérations sélectionnées"
L["Sell"] = "Vendre"
L["SELL ALL"] = "Tout vendre"
L["SELL BOES"] = "VENDRE LQE"
--[[Translation missing --]]
L["SELL GROUPS"] = "SELL GROUPS"
L["Sell Options"] = "Options de vente"
L["Sell soulbound items?"] = "Vendre des objets liés?"
L["Sell to Vendor"] = "Vendre au vendeur"
--[[Translation missing --]]
L["SELL TRASH"] = "SELL TRASH"
L["Seller"] = "Vendeur"
--[[Translation missing --]]
L["Selling soulbound items."] = "Selling soulbound items."
L["Send"] = "Envoyer"
L["SEND DISENCHANTABLES"] = "ENVOI DÉSENCHANTABLES"
L["Send Excess Gold to Banker"] = "Envoi de pièces d'Or à votre personnage banquier"
L["SEND GOLD"] = "ENVOYER DE L'OR"
L["Send grouped items individually"] = "Envoyer individuellement les objets groupés"
L["SEND MAIL"] = "ENVOYER COURRIER"
L["Send Money"] = "Envoyer argent"
L["Send Profile"] = "Envoyer profil"
L["SENDING"] = "ENVOI"
L["Sending %s individually to %s"] = "Envoi %s individuellement à %s"
L["Sending %s to %s"] = "Envoi %s à %s"
--[[Translation missing --]]
L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
L["Sending Settings"] = "Paramètres d'envoi"
L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Envoi du profil '%s' à %s. Laissez les deux personnages connectés tant que ce n'est pas terminé. Cela prendra environ :%s"
L["SENDING..."] = "ENVOI..."
--[[Translation missing --]]
L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
L["Setup"] = "Setup"
--[[Translation missing --]]
L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
L["Shards"] = "Eclats"
--[[Translation missing --]]
L["Shopping"] = "Shopping"
--[[Translation missing --]]
L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
L["Show Description"] = "Montrer la description"
--[[Translation missing --]]
L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
L["Show material cost"] = "Montrer le coût du matériel"
--[[Translation missing --]]
L["Show on Modifier"] = "Show on Modifier"
L["Showing %d Mail"] = "Affichage de %d courrier."
L["Showing %d of %d Mail"] = "Affichage du courrier : %d sur %d."
L["Showing %d of %d Mails"] = "Affichage des courriers : %d sur %d."
L["Showing all %d Mails"] = "Affichage de tous les courriers (%d)."
L["Simple"] = "Simple"
L["SKIP"] = "PASSER"
L["Skip Import confirmation?"] = "Passer la confirmation d'import ?"
L["Skipped: No assigned operation"] = "Passé : Aucune opération assignée"
L["Slash Commands:"] = "Commandes Slash:"
L["Sniper"] = "Sniper"
L["Sniper 'BUYOUT' Button"] = "Bouton 'RACHAT' du sniper"
L["Sniper Options"] = "Options du sniper"
L["Sniper Settings"] = "Paramètres du sniper"
--[[Translation missing --]]
L["Sniping items below a max price"] = "Sniping items below a max price"
L["Sold"] = "Vendu"
--[[Translation missing --]]
L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
L["Sold %s worth of items."] = "Sold %s worth of items."
L["Sold (Min/Avg/Max Price)"] = "Vendu (Prix Min/Moyen/Max)"
L["Sold (Total Price)"] = "Vendu (prix total)"
--[[Translation missing --]]
L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
L["Sold Auctions %s:"] = "Enchères vendues %s :"
L["Source"] = "Source"
L["SOURCE %d"] = "SOURCE %d"
L["SOURCES"] = "SOURCES"
L["Sources"] = "Sources"
--[[Translation missing --]]
L["Sources to include for restock:"] = "Sources to include for restock:"
L["Stack"] = "Pile"
L["Stack / Quantity"] = "Pile / Quantité"
--[[Translation missing --]]
L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
L["Starting Scan..."] = "Début du scan ..."
L["STOP"] = "ARRÊTER"
--[[Translation missing --]]
L["Store operations globally"] = "Store operations globally"
L["Subject"] = "Sujet"
L["SUBJECT"] = "SUJET"
--[[Translation missing --]]
L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
L["Switch to %s"] = "Switch to %s"
L["Switch to WoW UI"] = "Revenir sur l'IU de WoW"
--[[Translation missing --]]
L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
L["Sync Status"] = "Sync Status"
L["TAKE ALL"] = "PRENDRE TOUT"
--[[Translation missing --]]
L["Take Attachments"] = "Take Attachments"
L["Target Character"] = "Personnage sélectionné"
--[[Translation missing --]]
L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
L["Tasks Added to Task List"] = "Tasks Added to Task List"
L["Text (%s)"] = "Texte (%s)"
--[[Translation missing --]]
L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
--[[Translation missing --]]
L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "The name can ONLY contain letters. No spaces, numbers, or special characters."
--[[Translation missing --]]
L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "L'add-on TradeSkillMaster_AppHelper est installé, mais non activé. TSM l'a activé de lui-même, mais recharger l'interface est requis."
--[[Translation missing --]]
L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
--[[Translation missing --]]
L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
--[[Translation missing --]]
L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
L["This item is not in a TSM group."] = "Cet objet n'est pas dans un groupe TSM"
--[[Translation missing --]]
L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
--[[Translation missing --]]
L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
--[[Translation missing --]]
L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
L["This will permanently delete the '%s' profile."] = "Cela supprimera définitivement le profil '%s'."
--[[Translation missing --]]
L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
L["Time"] = "Temps"
--[[Translation missing --]]
L["Time Format"] = "Time Format"
--[[Translation missing --]]
L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
L["TINKER"] = "TINKER"
L["Tooltip Price Format"] = "Format du prix dans l'info-bulle"
L["Tooltip Settings"] = "Paramètre de l'info-bulle"
L["Top Buyers:"] = "Top acheteurs:"
L["Top Item:"] = "Meilleur objet :"
L["Top Sellers:"] = "Top vendeurs :"
L["Total"] = "Total"
L["Total Gold"] = "Pièces d'Or"
L["Total Gold Collected: %s"] = "Pièces d'Or collectées : %s"
L["Total Gold Earned:"] = "Total de pièces d'Or gagnées :"
L["Total Gold Spent:"] = "Total de pièces d'Or dépensées :"
L["Total Price"] = "Prix total"
L["Total Profit:"] = "Profit total:"
L["Total Value"] = "Valeur totale"
L["Total Value of All Items"] = "Valeur totale de tous les objets"
--[[Translation missing --]]
L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
L["Transform Value"] = "Valeur de transformation"
L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
L["TSM Crafting"] = "TSM Crafting"
L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM a échoué à scanner quelques ventes. Veuillez relancer le scan."
--[[Translation missing --]]
L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM ne parvient pas à accéder à d'importantes informations de l'application de bureau TSM Desktop. Assurez-vous s'il vous plaît que TSM Desktop fonctionne et soit correctement configuré."
L["TSM Mailing"] = "TSM Mailing"
L["TSM TASK LIST"] = "TSM LISTE DE TACHES"
L["TSM Vendoring"] = "TSM Vendoring"
L["TSM Version Info:"] = "Version de TSM :"
--[[Translation missing --]]
L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
L["TSM4"] = "TSM4"
--[[Translation missing --]]
L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
--[[Translation missing --]]
L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
--[[Translation missing --]]
L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
L["TUJ Global Median"] = "TUJ Global Median"
L["Twitter Integration"] = "Intégration Twitter"
L["Twitter Integration Not Enabled"] = "Intégration Twitter désactivée"
--[[Translation missing --]]
L["Type"] = "Type"
L["Type Something"] = "Écrire quelque chose"
--[[Translation missing --]]
L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
--[[Translation missing --]]
L["Unbalanced parentheses."] = "Unbalanced parentheses."
L["Undercut amount:"] = "Montant de la réduction:"
L["Undercut by whitelisted player."] = "Sous-enchère d'un joueur en liste blanche."
L["Undercutting blacklisted player."] = "Sous-enchère d'un joueur en liste noire."
L["Undercutting competition."] = "Sous-enchérir."
L["Ungrouped Items"] = "Objets non-groupés"
L["Unknown Item"] = "Objet inconnu"
L["Unwrap Gift"] = "Déballer le cadeau"
--[[Translation missing --]]
L["Up"] = "Up"
L["Up to date"] = "À jour"
L["UPDATE EXISTING MACRO"] = "METTRE A JOUR LA MACRO EXISTANTE"
L["Updating"] = "Mise à jour"
L["Usage: /tsm price <ItemLink> <Price String>"] = "Conseil d'utilisation: /tsm price <ItemLink> <Price String>"
--[[Translation missing --]]
L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
L["Variable Name"] = "Variable Name"
L["Vendor"] = "Vendeur"
L["Vendor Buy Price"] = "Prix d'achat au vendeur"
--[[Translation missing --]]
L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
L["VENDOR SEARCH"] = "VENDOR SEARCH"
L["Vendor Sell"] = "vendre au marchant"
L["Vendor Sell Price"] = "Prix de vente au marchant"
--[[Translation missing --]]
L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
L["Warehousing"] = "Entreposage"
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "ATTENTION : La macro est trop longue, elle a donc été tronquée par défaut par WoW"
L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "ATTENTION : les marchands achètent %s à un montant supérieur à votre prix minimum (frais de mise en enchère et commission inclus). Augmentez votre prix minimum, ou vendez-le à un marchand."
--[[Translation missing --]]
L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
L["When above maximum:"] = "Lorsqu'au-dessus du maximum :"
L["When below minimum:"] = "Lorsqu'en-dessous du minimum :"
L["Whitelist"] = "Liste blanche"
L["Whitelisted Players"] = "Joueurs autorisés"
--[[Translation missing --]]
L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
L["You cannot use %s as part of this custom price."] = "Vous ne pouvez pas utiliser %s comme prix spécifique."
--[[Translation missing --]]
L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
L["You don't know how to craft this item."] = "Vous ne savez pas fabriquer cet objet."
L["You must reload your UI for these settings to take effect. Reload now?"] = "Vous devez recharger votre UI pour que ces paramètres soient pris en compte. Recharger maintenant ?"
L["You won an auction for %sx%d for %s"] = "Vous avez gagné une enchère pour %sx%d pour %s"
L["Your auction has not been undercut."] = "Enchère non concurrencée."
L["Your auction of %s expired"] = "Votre mise aux enchères de %s est expirée."
L["Your auction of %s has sold for %s!"] = "Votre mise aux enchères de %s a été vendue pour %s !"
L["Your Buyout"] = "Votre rachat"
--[[Translation missing --]]
L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
L["Your task list is currently empty."] = "Votre liste de tâche est actuellement vide."
L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Vous avez été mis en phase, ce qui a amené l'HV à cesser de fonctionner en raison d'un bug sur le layering de Blizzard. Veuillez fermer et rouvrir HV, puis redémarrer Sniper."
L["You've been undercut."] = "Sous-enchère constatée."
	elseif locale == "itIT" then
L = L or {}
L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Gruppo:Gruppi; Selezionati (%d |4Oggetto:Oggetti;)"
L["%d auctions"] = "%d aste"
L["%d Groups"] = "%d Gruppi"
L["%d Items"] = "%d Oggetti"
L["%d of %d"] = "%d di %d"
L["%d Operations"] = "%d Operazioni"
L["%d Posted Auctions"] = "%d Aste Pubblicate"
L["%d Sold Auctions"] = "%d Aste Vendute"
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s borse, %s banca, %s CdA, %s posta)"
L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s giocatore, %s alts, %s gilda, %s CdA)"
L["%s (%s profit)"] = "%s (%s profitto)"
L["%s |4operation:operations;"] = "%s |4operazione:operazioni;"
L["%s ago"] = "%s fa"
--[[Translation missing --]]
L["%s Crafts"] = "%s Crafts"
L["%s group updated with %d items and %d materials."] = "%s gruppo aggiornato con %d voci e %d materiali."
L["%s in guild vault"] = "%s nella banca di gilda"
L["%s is a valid custom price but %s is an invalid item."] = "%s è un valido prezzo personalizzato ma %s non è un oggetto valido."
L["%s is a valid custom price but did not give a value for %s."] = "%s è un valido prezzo personalizzato ma non ha dato un valore per %s."
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' è un'operazione non valida! Il rifornimento minimo di %d è superiore al rifornimento massimo di %d."
L["%s is not a valid custom price and gave the following error: %s"] = "%s non è un valido prezzo personalizzato ed ha restituito il seguente errore: %s"
L["%s Operations"] = "%s Operazioni"
--[[Translation missing --]]
L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
L["%s removed."] = "%s rimosso."
L["%s sent you %s"] = "%s ti ha mandato %s"
L["%s sent you %s and %s"] = "%s ti ha mandato %s e %s"
L["%s sent you a COD of %s for %s"] = "%s ti ha mandato un PAC di %s per %s"
L["%s sent you a message: %s"] = "%s ti ha inviato un messaggio: %s"
L["%s total"] = "%s totale"
L["%sDrag%s to move this button"] = "%sTrascina%s per spostare questo pulsante"
L["%sLeft-Click%s to open the main window"] = "%sClic-Sinistro%s per aprire la finestra principale"
L["(%d/500 Characters)"] = "(%d/500 Caratteri)"
L["(max %d)"] = "(max %d)"
L["(max 5000)"] = "(max 5000)"
L["(min %d - max %d)"] = "(min %d - max %d)"
L["(min 0 - max 10000)"] = "(min 0 - max 10000)"
L["(minimum 0 - maximum 20)"] = "(minimo 0 - massimo 20)"
L["(minimum 0 - maximum 2000)"] = "(minimo 0 - massimo 2000)"
L["(minimum 0 - maximum 905)"] = "(minimo 0 - massimo 905)"
L["(minimum 0.5 - maximum 10)"] = "(minimo 0.5 - massimo 10)"
L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Mostra questa lista d'aiuto"
L["/tsm|r - opens the main TSM window."] = "/tsm|r - apre la finestra principale di TSM"
--[[Translation missing --]]
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
--[[Translation missing --]]
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
--[[Translation missing --]]
L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
--[[Translation missing --]]
L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Left-Click|r to ignore an item this session."
--[[Translation missing --]]
L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Left-Click|r to ignore it permanently."
L["1 Group"] = "1 Gruppo"
L["1 Item"] = "1 Oggetto"
L["12 hr"] = "12 h"
L["24 hr"] = "24 h"
L["48 hr"] = "48 h"
L["A custom price of %s for %s evaluates to %s."] = "Un prezzo personalizzato di %s per %s valutati in %s."
L["A maximum of 1 convert() function is allowed."] = "Un massimo di una funzione convert() è consentita."
L["A profile with that name already exists on the target account. Rename it first and try again."] = "Un profilo con quel nome esiste già nell'account di destinazione. Rinominalo e riprova."
L["A profile with this name already exists."] = "Esiste già un profilo con questo nome."
L["A scan is already in progress. Please stop that scan before starting another one."] = "Una scansione è già in corso. Interrompere la scansione prima di avviarne un'altra."
L["Above max expires."] = "Sopra la massima scadenza."
L["Above max price. Not posting."] = "Sopra il prezzo massimo Non pubblicare."
--[[Translation missing --]]
L["Above max price. Posting at max price."] = "Above max price. Posting at max price."
--[[Translation missing --]]
L["Above max price. Posting at min price."] = "Above max price. Posting at min price."
--[[Translation missing --]]
L["Above max price. Posting at normal price."] = "Above max price. Posting at normal price."
--[[Translation missing --]]
L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
--[[Translation missing --]]
L["Accepting this item will cost"] = "Accepting this item will cost"
--[[Translation missing --]]
L["Account sync removed. Please delete the account sync from the other account as well."] = "Account sync removed. Please delete the account sync from the other account as well."
L["Account Syncing"] = "Sincronizzazione Account"
--[[Translation missing --]]
L["Accounting"] = "Accounting"
--[[Translation missing --]]
L["Accounting Tooltips"] = "Accounting Tooltips"
--[[Translation missing --]]
L["Activity Type"] = "Activity Type"
--[[Translation missing --]]
L["ADD %d ITEMS"] = "ADD %d ITEMS"
--[[Translation missing --]]
L["Add / Remove Items"] = "Add / Remove Items"
--[[Translation missing --]]
L["ADD NEW CUSTOM PRICE SOURCE"] = "ADD NEW CUSTOM PRICE SOURCE"
--[[Translation missing --]]
L["ADD OPERATION"] = "ADD OPERATION"
--[[Translation missing --]]
L["Add Player"] = "Add Player"
--[[Translation missing --]]
L["Add Subject / Description"] = "Add Subject / Description"
--[[Translation missing --]]
L["Add Subject / Description (Optional)"] = "Add Subject / Description (Optional)"
--[[Translation missing --]]
L["ADD TO MAIL"] = "ADD TO MAIL"
--[[Translation missing --]]
L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
--[[Translation missing --]]
L["Added %s to %s."] = "Added %s to %s."
L["Additional error suppressed"] = "Errore addizionale soppresso"
--[[Translation missing --]]
L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Adjust the settings below to set how groups attached to this operation will be auctioned."
--[[Translation missing --]]
L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
--[[Translation missing --]]
L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
--[[Translation missing --]]
L["Advanced Item Search"] = "Advanced Item Search"
--[[Translation missing --]]
L["Advanced Options"] = "Advanced Options"
L["AH"] = "CdA"
--[[Translation missing --]]
L["AH (Crafting)"] = "AH (Crafting)"
--[[Translation missing --]]
L["AH (Disenchanting)"] = "AH (Disenchanting)"
--[[Translation missing --]]
L["AH BUSY"] = "AH BUSY"
--[[Translation missing --]]
L["AH Frame Options"] = "AH Frame Options"
L["Alarm Clock"] = "Sveglia"
--[[Translation missing --]]
L["All Auctions"] = "All Auctions"
--[[Translation missing --]]
L["All Characters and Guilds"] = "All Characters and Guilds"
--[[Translation missing --]]
L["All Item Classes"] = "All Item Classes"
--[[Translation missing --]]
L["All Professions"] = "All Professions"
--[[Translation missing --]]
L["All Subclasses"] = "All Subclasses"
--[[Translation missing --]]
L["Allow partial stack?"] = "Allow partial stack?"
--[[Translation missing --]]
L["Alt Guild Bank"] = "Alt Guild Bank"
--[[Translation missing --]]
L["Alts"] = "Alts"
--[[Translation missing --]]
L["Alts AH"] = "Alts AH"
--[[Translation missing --]]
L["Amount"] = "Amount"
--[[Translation missing --]]
L["AMOUNT"] = "AMOUNT"
--[[Translation missing --]]
L["Amount of Bag Space to Keep Free"] = "Amount of Bag Space to Keep Free"
--[[Translation missing --]]
L["APPLY FILTERS"] = "APPLY FILTERS"
--[[Translation missing --]]
L["Apply operation to group:"] = "Apply operation to group:"
--[[Translation missing --]]
L["Are you sure you want to clear old accounting data?"] = "Are you sure you want to clear old accounting data?"
L["Are you sure you want to delete this group?"] = "Sei sicuro di voler eliminare questo gruppo?"
L["Are you sure you want to delete this operation?"] = "Sei sicuro di voler eliminare questa operazione?"
--[[Translation missing --]]
L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
--[[Translation missing --]]
L["At above max price and not undercut."] = "At above max price and not undercut."
--[[Translation missing --]]
L["At normal price and not undercut."] = "At normal price and not undercut."
--[[Translation missing --]]
L["Auction"] = "Auction"
--[[Translation missing --]]
L["Auction Bid"] = "Auction Bid"
--[[Translation missing --]]
L["Auction Buyout"] = "Auction Buyout"
--[[Translation missing --]]
L["AUCTION DETAILS"] = "AUCTION DETAILS"
--[[Translation missing --]]
L["Auction Duration"] = "Auction Duration"
--[[Translation missing --]]
L["Auction has been bid on."] = "Auction has been bid on."
--[[Translation missing --]]
L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
L["Auction Sale Sound"] = "Auction Sale Sound"
--[[Translation missing --]]
L["Auction Window Close"] = "Auction Window Close"
--[[Translation missing --]]
L["Auction Window Open"] = "Auction Window Open"
L["Auctionator - Auction Value"] = "Auctionator - Valore d'Asta"
--[[Translation missing --]]
L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
L["Auctioneer - Appraiser"] = "Auctioneer - Valutatore"
L["Auctioneer - Market Value"] = "Auctioneer - Valore di Mercato"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - Acquisto Minimo"
--[[Translation missing --]]
L["Auctioning"] = "Auctioning"
--[[Translation missing --]]
L["Auctioning Log"] = "Auctioning Log"
--[[Translation missing --]]
L["Auctioning Operation"] = "Auctioning Operation"
--[[Translation missing --]]
L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
--[[Translation missing --]]
L["Auctioning Tooltips"] = "Auctioning Tooltips"
L["Auctions"] = "Aste"
--[[Translation missing --]]
L["Auto Quest Complete"] = "Auto Quest Complete"
--[[Translation missing --]]
L["Average Earned Per Day:"] = "Average Earned Per Day:"
--[[Translation missing --]]
L["Average Prices:"] = "Average Prices:"
--[[Translation missing --]]
L["Average Profit Per Day:"] = "Average Profit Per Day:"
--[[Translation missing --]]
L["Average Spent Per Day:"] = "Average Spent Per Day:"
--[[Translation missing --]]
L["Avg Buy Price"] = "Avg Buy Price"
--[[Translation missing --]]
L["Avg Resale Profit"] = "Avg Resale Profit"
--[[Translation missing --]]
L["Avg Sell Price"] = "Avg Sell Price"
--[[Translation missing --]]
L["BACK"] = "BACK"
--[[Translation missing --]]
L["BACK TO LIST"] = "BACK TO LIST"
--[[Translation missing --]]
L["Back to List"] = "Back to List"
--[[Translation missing --]]
L["Bag"] = "Bag"
L["Bags"] = "Borse"
--[[Translation missing --]]
L["Banks"] = "Banks"
--[[Translation missing --]]
L["Base Group"] = "Base Group"
--[[Translation missing --]]
L["Base Item"] = "Base Item"
L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Di seguito sono elencate le fonti di prezzo attualmente disponibili organizzate per modulo. La %skey|r è ciò che dovrai digitare in un campo prezzo personalizzato."
--[[Translation missing --]]
L["Below custom price:"] = "Below custom price:"
--[[Translation missing --]]
L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
--[[Translation missing --]]
L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
--[[Translation missing --]]
L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
--[[Translation missing --]]
L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
--[[Translation missing --]]
L["BID"] = "BID"
--[[Translation missing --]]
L["Bid %d / %d"] = "Bid %d / %d"
--[[Translation missing --]]
L["Bid (item)"] = "Bid (item)"
--[[Translation missing --]]
L["Bid (stack)"] = "Bid (stack)"
--[[Translation missing --]]
L["Bid Price"] = "Bid Price"
--[[Translation missing --]]
L["Bid Sniper Paused"] = "Bid Sniper Paused"
--[[Translation missing --]]
L["Bid Sniper Running"] = "Bid Sniper Running"
--[[Translation missing --]]
L["Bidding Auction"] = "Bidding Auction"
--[[Translation missing --]]
L["Blacklisted players:"] = "Blacklisted players:"
--[[Translation missing --]]
L["Bought"] = "Bought"
--[[Translation missing --]]
L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
--[[Translation missing --]]
L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
--[[Translation missing --]]
L["Bound Actions"] = "Bound Actions"
--[[Translation missing --]]
L["BUSY"] = "BUSY"
--[[Translation missing --]]
L["BUY"] = "BUY"
--[[Translation missing --]]
L["Buy"] = "Buy"
--[[Translation missing --]]
L["Buy %d / %d"] = "Buy %d / %d"
--[[Translation missing --]]
L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
--[[Translation missing --]]
L["Buy from AH"] = "Buy from AH"
L["Buy from Vendor"] = "Compra dal Mercante"
--[[Translation missing --]]
L["BUY GROUPS"] = "BUY GROUPS"
--[[Translation missing --]]
L["Buy Options"] = "Buy Options"
--[[Translation missing --]]
L["BUYBACK ALL"] = "BUYBACK ALL"
--[[Translation missing --]]
L["Buyer/Seller"] = "Buyer/Seller"
--[[Translation missing --]]
L["BUYOUT"] = "BUYOUT"
--[[Translation missing --]]
L["Buyout (item)"] = "Buyout (item)"
--[[Translation missing --]]
L["Buyout (stack)"] = "Buyout (stack)"
--[[Translation missing --]]
L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
--[[Translation missing --]]
L["Buyout Price"] = "Buyout Price"
--[[Translation missing --]]
L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
--[[Translation missing --]]
L["Buyout Sniper Running"] = "Buyout Sniper Running"
--[[Translation missing --]]
L["BUYS"] = "BUYS"
--[[Translation missing --]]
L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
--[[Translation missing --]]
L["Cancel auctions with bids"] = "Cancel auctions with bids"
--[[Translation missing --]]
L["Cancel Scan"] = "Cancel Scan"
--[[Translation missing --]]
L["Cancel to repost higher?"] = "Cancel to repost higher?"
--[[Translation missing --]]
L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
--[[Translation missing --]]
L["Canceling"] = "Canceling"
--[[Translation missing --]]
L["Canceling %d / %d"] = "Canceling %d / %d"
--[[Translation missing --]]
L["Canceling %d Auctions..."] = "Canceling %d Auctions..."
--[[Translation missing --]]
L["Canceling all auctions."] = "Canceling all auctions."
--[[Translation missing --]]
L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
--[[Translation missing --]]
L["Canceling disabled."] = "Canceling disabled."
--[[Translation missing --]]
L["Canceling Settings"] = "Canceling Settings"
--[[Translation missing --]]
L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
--[[Translation missing --]]
L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
--[[Translation missing --]]
L["Canceling to repost higher."] = "Canceling to repost higher."
--[[Translation missing --]]
L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
--[[Translation missing --]]
L["Canceling undercut auctions."] = "Canceling undercut auctions."
--[[Translation missing --]]
L["Cancelled"] = "Cancelled"
--[[Translation missing --]]
L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
--[[Translation missing --]]
L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
--[[Translation missing --]]
L["CANCELS"] = "CANCELS"
--[[Translation missing --]]
L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
L["Can't load TSM tooltip while in combat"] = "Impossibile caricare il tooltip di TSM in combattimento"
L["Cash Register"] = "Registratore di Cassa"
--[[Translation missing --]]
L["CHARACTER"] = "CHARACTER"
--[[Translation missing --]]
L["Character"] = "Character"
L["Chat Tab"] = "Scheda di Chat"
--[[Translation missing --]]
L["Cheapest auction below min price."] = "Cheapest auction below min price."
L["Clear"] = "Azzera"
--[[Translation missing --]]
L["Clear All"] = "Clear All"
--[[Translation missing --]]
L["CLEAR DATA"] = "CLEAR DATA"
--[[Translation missing --]]
L["Clear Filters"] = "Clear Filters"
--[[Translation missing --]]
L["Clear Old Data"] = "Clear Old Data"
--[[Translation missing --]]
L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
--[[Translation missing --]]
L["Clear Queue"] = "Clear Queue"
L["Clear Selection"] = "Azzera Selezione"
--[[Translation missing --]]
L["COD"] = "COD"
L["Coins (%s)"] = "Monete (%s)"
--[[Translation missing --]]
L["Collapse All Groups"] = "Collapse All Groups"
--[[Translation missing --]]
L["Combine Partial Stacks"] = "Combine Partial Stacks"
--[[Translation missing --]]
L["Combining..."] = "Combining..."
--[[Translation missing --]]
L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
--[[Translation missing --]]
L["Confirm"] = "Confirm"
--[[Translation missing --]]
L["Confirm Complete Sound"] = "Confirm Complete Sound"
--[[Translation missing --]]
L["Confirming %d / %d"] = "Confirming %d / %d"
L["Connected to %s"] = "Collegato a %s"
--[[Translation missing --]]
L["Connecting to %s"] = "Connecting to %s"
--[[Translation missing --]]
L["CONTACTS"] = "CONTACTS"
--[[Translation missing --]]
L["Contacts Menu"] = "Contacts Menu"
--[[Translation missing --]]
L["Cooldown"] = "Cooldown"
--[[Translation missing --]]
L["Cooldowns"] = "Cooldowns"
--[[Translation missing --]]
L["Cost"] = "Cost"
--[[Translation missing --]]
L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
L["Could not find profile '%s'. Possible profiles: '%s'"] = "Impossibile trovare il profilo '%s'. Possibile profilo: '%s'"
--[[Translation missing --]]
L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
--[[Translation missing --]]
L["Craft"] = "Craft"
--[[Translation missing --]]
L["CRAFT"] = "CRAFT"
--[[Translation missing --]]
L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
--[[Translation missing --]]
L["Craft (When Profitable)"] = "Craft (When Profitable)"
--[[Translation missing --]]
L["Craft All"] = "Craft All"
--[[Translation missing --]]
L["CRAFT ALL"] = "CRAFT ALL"
--[[Translation missing --]]
L["Craft Name"] = "Craft Name"
--[[Translation missing --]]
L["CRAFT NEXT"] = "CRAFT NEXT"
--[[Translation missing --]]
L["Craft value method:"] = "Craft value method:"
--[[Translation missing --]]
L["CRAFTER"] = "CRAFTER"
--[[Translation missing --]]
L["CRAFTING"] = "CRAFTING"
--[[Translation missing --]]
L["Crafting"] = "Crafting"
--[[Translation missing --]]
L["Crafting Cost"] = "Crafting Cost"
--[[Translation missing --]]
L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
--[[Translation missing --]]
L["Crafting Queue"] = "Crafting Queue"
--[[Translation missing --]]
L["Crafting Tooltips"] = "Crafting Tooltips"
--[[Translation missing --]]
L["Crafts"] = "Crafts"
--[[Translation missing --]]
L["Crafts %d"] = "Crafts %d"
--[[Translation missing --]]
L["CREATE MACRO"] = "CREATE MACRO"
L["Create New Operation"] = "Crea Nuova Operazione"
--[[Translation missing --]]
L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
--[[Translation missing --]]
L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
L["Crystals"] = "Cristalli"
--[[Translation missing --]]
L["Current Profiles"] = "Current Profiles"
--[[Translation missing --]]
L["CURRENT SEARCH"] = "CURRENT SEARCH"
--[[Translation missing --]]
L["CUSTOM POST"] = "CUSTOM POST"
--[[Translation missing --]]
L["Custom Price"] = "Custom Price"
--[[Translation missing --]]
L["Custom Price Source"] = "Custom Price Source"
--[[Translation missing --]]
L["Custom Sources"] = "Custom Sources"
--[[Translation missing --]]
L["Database Sources"] = "Database Sources"
--[[Translation missing --]]
L["Default Craft Value Method:"] = "Default Craft Value Method:"
--[[Translation missing --]]
L["Default Material Cost Method:"] = "Default Material Cost Method:"
--[[Translation missing --]]
L["Default Price"] = "Default Price"
--[[Translation missing --]]
L["Default Price Configuration"] = "Default Price Configuration"
--[[Translation missing --]]
L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
--[[Translation missing --]]
L["Delete this record?"] = "Delete this record?"
--[[Translation missing --]]
L["Deposit"] = "Deposit"
--[[Translation missing --]]
L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
L["Deposit Price"] = "Deposit Price"
--[[Translation missing --]]
L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
L["Deselect All Groups"] = "Deseleziona Tutti i Gruppi"
--[[Translation missing --]]
L["Deselect All Items"] = "Deselect All Items"
--[[Translation missing --]]
L["Destroy Next"] = "Destroy Next"
--[[Translation missing --]]
L["Destroy Value"] = "Destroy Value"
--[[Translation missing --]]
L["Destroy Value Source"] = "Destroy Value Source"
--[[Translation missing --]]
L["Destroying"] = "Destroying"
--[[Translation missing --]]
L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
--[[Translation missing --]]
L["Destroying Tooltips"] = "Destroying Tooltips"
--[[Translation missing --]]
L["Destroying..."] = "Destroying..."
--[[Translation missing --]]
L["Details"] = "Details"
--[[Translation missing --]]
L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
L["Disenchant Search"] = "Disenchant Search"
--[[Translation missing --]]
L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
--[[Translation missing --]]
L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
L["Display cancelled since last sale"] = "Display cancelled since last sale"
--[[Translation missing --]]
L["Display crafting cost"] = "Display crafting cost"
--[[Translation missing --]]
L["Display detailed destroy info"] = "Display detailed destroy info"
--[[Translation missing --]]
L["Display disenchant value"] = "Display disenchant value"
--[[Translation missing --]]
L["Display expired auctions"] = "Display expired auctions"
--[[Translation missing --]]
L["Display group name"] = "Display group name"
--[[Translation missing --]]
L["Display historical price"] = "Display historical price"
--[[Translation missing --]]
L["Display market value"] = "Display market value"
--[[Translation missing --]]
L["Display mill value"] = "Display mill value"
--[[Translation missing --]]
L["Display min buyout"] = "Display min buyout"
--[[Translation missing --]]
L["Display Operation Names"] = "Display Operation Names"
--[[Translation missing --]]
L["Display prospect value"] = "Display prospect value"
--[[Translation missing --]]
L["Display purchase info"] = "Display purchase info"
--[[Translation missing --]]
L["Display region historical price"] = "Display region historical price"
--[[Translation missing --]]
L["Display region market value avg"] = "Display region market value avg"
--[[Translation missing --]]
L["Display region min buyout avg"] = "Display region min buyout avg"
--[[Translation missing --]]
L["Display region sale avg"] = "Display region sale avg"
--[[Translation missing --]]
L["Display region sale rate"] = "Display region sale rate"
--[[Translation missing --]]
L["Display region sold per day"] = "Display region sold per day"
--[[Translation missing --]]
L["Display sale info"] = "Display sale info"
--[[Translation missing --]]
L["Display sale rate"] = "Display sale rate"
--[[Translation missing --]]
L["Display shopping max price"] = "Display shopping max price"
--[[Translation missing --]]
L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
--[[Translation missing --]]
L["Display transform value"] = "Display transform value"
--[[Translation missing --]]
L["Display vendor buy price"] = "Display vendor buy price"
--[[Translation missing --]]
L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
L["Done Canceling"] = "Done Canceling"
--[[Translation missing --]]
L["Done Posting"] = "Done Posting"
--[[Translation missing --]]
L["Done rebuilding item cache."] = "Done rebuilding item cache."
--[[Translation missing --]]
L["Done Scanning"] = "Done Scanning"
--[[Translation missing --]]
L["Don't post after this many expires:"] = "Don't post after this many expires:"
--[[Translation missing --]]
L["Don't Post Items"] = "Don't Post Items"
--[[Translation missing --]]
L["Don't prompt to record trades"] = "Don't prompt to record trades"
--[[Translation missing --]]
L["DOWN"] = "DOWN"
--[[Translation missing --]]
L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
--[[Translation missing --]]
L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
--[[Translation missing --]]
L["Duplicate"] = "Duplicate"
--[[Translation missing --]]
L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
L["Dust"] = "Polvere"
--[[Translation missing --]]
L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
L["Embed TSM tooltips"] = "Embed TSM tooltips"
--[[Translation missing --]]
L["EMPTY BAGS"] = "EMPTY BAGS"
--[[Translation missing --]]
L["Empty parentheses are not allowed"] = "Empty parentheses are not allowed"
L["Empty price string."] = "Stringa del prezzo vuota."
--[[Translation missing --]]
L["Enable automatic stack combination"] = "Enable automatic stack combination"
--[[Translation missing --]]
L["Enable buying?"] = "Enable buying?"
--[[Translation missing --]]
L["Enable inbox chat messages"] = "Enable inbox chat messages"
--[[Translation missing --]]
L["Enable restock?"] = "Enable restock?"
--[[Translation missing --]]
L["Enable selling?"] = "Enable selling?"
--[[Translation missing --]]
L["Enable sending chat messages"] = "Enable sending chat messages"
--[[Translation missing --]]
L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
--[[Translation missing --]]
L["Enable tweet enhancement"] = "Enable tweet enhancement"
--[[Translation missing --]]
L["Enchant Vellum"] = "Enchant Vellum"
--[[Translation missing --]]
L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
L["Enter a name for the new profile"] = "Enter a name for the new profile"
--[[Translation missing --]]
L["Enter Filter"] = "Enter Filter"
--[[Translation missing --]]
L["Enter Keyword"] = "Enter Keyword"
--[[Translation missing --]]
L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
--[[Translation missing --]]
L["Enter player name"] = "Enter player name"
L["Essences"] = "Essenze"
--[[Translation missing --]]
L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establishing connection to %s. Make sure that you've entered this character's name on the other account."
--[[Translation missing --]]
L["Estimated Cost:"] = "Estimated Cost:"
--[[Translation missing --]]
L["Estimated deliver time"] = "Estimated deliver time"
--[[Translation missing --]]
L["Estimated Profit:"] = "Estimated Profit:"
--[[Translation missing --]]
L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
L["Expand All Groups"] = "Expand All Groups"
--[[Translation missing --]]
L["Expenses"] = "Expenses"
--[[Translation missing --]]
L["EXPENSES"] = "EXPENSES"
--[[Translation missing --]]
L["Expirations"] = "Expirations"
--[[Translation missing --]]
L["Expired"] = "Expired"
--[[Translation missing --]]
L["Expired Auctions"] = "Expired Auctions"
--[[Translation missing --]]
L["Expired Since Last Sale"] = "Expired Since Last Sale"
--[[Translation missing --]]
L["Expires"] = "Expires"
--[[Translation missing --]]
L["EXPIRES"] = "EXPIRES"
--[[Translation missing --]]
L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
L["Expiring Mails"] = "Expiring Mails"
--[[Translation missing --]]
L["Exploration"] = "Exploration"
--[[Translation missing --]]
L["Export"] = "Export"
--[[Translation missing --]]
L["Export List"] = "Export List"
--[[Translation missing --]]
L["Failed Auctions"] = "Failed Auctions"
--[[Translation missing --]]
L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
--[[Translation missing --]]
L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
--[[Translation missing --]]
L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
--[[Translation missing --]]
L["Favorite Scans"] = "Favorite Scans"
--[[Translation missing --]]
L["Favorite Searches"] = "Favorite Searches"
--[[Translation missing --]]
L["Filter Auctions by Duration"] = "Filter Auctions by Duration"
--[[Translation missing --]]
L["Filter Auctions by Keyword"] = "Filter Auctions by Keyword"
--[[Translation missing --]]
L["Filter by Keyword"] = "Filter by Keyword"
--[[Translation missing --]]
L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
--[[Translation missing --]]
L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
--[[Translation missing --]]
L["Filter Items"] = "Filter Items"
--[[Translation missing --]]
L["Filter Shopping"] = "Filter Shopping"
--[[Translation missing --]]
L["Finding Selected Auction"] = "Finding Selected Auction"
--[[Translation missing --]]
L["Fishing Reel In"] = "Fishing Reel In"
--[[Translation missing --]]
L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
L["Found auction sound"] = "Found auction sound"
--[[Translation missing --]]
L["Friends"] = "Friends"
--[[Translation missing --]]
L["From"] = "From"
--[[Translation missing --]]
L["Full"] = "Full"
--[[Translation missing --]]
L["Garrison"] = "Garrison"
--[[Translation missing --]]
L["Gathering"] = "Gathering"
--[[Translation missing --]]
L["Gathering Search"] = "Gathering Search"
L["General Options"] = "Opzioni Generale"
--[[Translation missing --]]
L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
L["Global Operation Confirmation"] = "Global Operation Confirmation"
--[[Translation missing --]]
L["Gold"] = "Gold"
--[[Translation missing --]]
L["Gold Earned:"] = "Gold Earned:"
--[[Translation missing --]]
L["GOLD ON HAND"] = "GOLD ON HAND"
--[[Translation missing --]]
L["Gold Spent:"] = "Gold Spent:"
--[[Translation missing --]]
L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
--[[Translation missing --]]
L["Group already exists."] = "Group already exists."
--[[Translation missing --]]
L["Group Management"] = "Group Management"
--[[Translation missing --]]
L["Group Operations"] = "Group Operations"
--[[Translation missing --]]
L["Group Settings"] = "Group Settings"
--[[Translation missing --]]
L["Grouped Items"] = "Grouped Items"
--[[Translation missing --]]
L["Groups"] = "Groups"
--[[Translation missing --]]
L["Guild"] = "Guild"
--[[Translation missing --]]
L["Guild Bank"] = "Guild Bank"
--[[Translation missing --]]
L["GVault"] = "GVault"
--[[Translation missing --]]
L["Have"] = "Have"
--[[Translation missing --]]
L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
L["Hide auctions with bids"] = "Hide auctions with bids"
--[[Translation missing --]]
L["Hide Description"] = "Hide Description"
--[[Translation missing --]]
L["Hide minimap icon"] = "Hide minimap icon"
--[[Translation missing --]]
L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
L["High Bidder"] = "High Bidder"
--[[Translation missing --]]
L["Historical Price"] = "Historical Price"
--[[Translation missing --]]
L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
--[[Translation missing --]]
L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
L["Hr"] = "Hr"
--[[Translation missing --]]
L["Hrs"] = "Hrs"
--[[Translation missing --]]
L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
--[[Translation missing --]]
L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"
--[[Translation missing --]]
L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
--[[Translation missing --]]
L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
--[[Translation missing --]]
L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
--[[Translation missing --]]
L["Ignore Characters"] = "Ignore Characters"
--[[Translation missing --]]
L["Ignore Guilds"] = "Ignore Guilds"
--[[Translation missing --]]
L["Ignore item variations?"] = "Ignore item variations?"
--[[Translation missing --]]
L["Ignore operation on characters:"] = "Ignore operation on characters:"
--[[Translation missing --]]
L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
--[[Translation missing --]]
L["Ignored Cooldowns"] = "Ignored Cooldowns"
--[[Translation missing --]]
L["Ignored Items"] = "Ignored Items"
--[[Translation missing --]]
L["ilvl"] = "ilvl"
--[[Translation missing --]]
L["Import"] = "Import"
--[[Translation missing --]]
L["IMPORT"] = "IMPORT"
--[[Translation missing --]]
L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
--[[Translation missing --]]
L["Import Groups & Operations"] = "Import Groups & Operations"
--[[Translation missing --]]
L["Imported Items"] = "Imported Items"
--[[Translation missing --]]
L["Inbox Settings"] = "Inbox Settings"
--[[Translation missing --]]
L["Include Attached Operations"] = "Include Attached Operations"
--[[Translation missing --]]
L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
L["Include soulbound items"] = "Include soulbound items"
--[[Translation missing --]]
L["Information"] = "Information"
--[[Translation missing --]]
L["Invalid custom price entered."] = "Invalid custom price entered."
--[[Translation missing --]]
L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
--[[Translation missing --]]
L["Invalid custom price."] = "Invalid custom price."
--[[Translation missing --]]
L["Invalid function."] = "Invalid function."
--[[Translation missing --]]
L["Invalid gold value."] = "Invalid gold value."
--[[Translation missing --]]
L["Invalid group name."] = "Invalid group name."
--[[Translation missing --]]
L["Invalid import string."] = "Invalid import string."
--[[Translation missing --]]
L["Invalid item link."] = "Invalid item link."
--[[Translation missing --]]
L["Invalid operation name."] = "Invalid operation name."
--[[Translation missing --]]
L["Invalid operator at end of custom price."] = "Invalid operator at end of custom price."
--[[Translation missing --]]
L["Invalid parameter to price source."] = "Invalid parameter to price source."
--[[Translation missing --]]
L["Invalid player name."] = "Invalid player name."
--[[Translation missing --]]
L["Invalid price source in convert."] = "Invalid price source in convert."
--[[Translation missing --]]
L["Invalid price source."] = "Invalid price source."
--[[Translation missing --]]
L["Invalid search filter"] = "Invalid search filter"
--[[Translation missing --]]
L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
--[[Translation missing --]]
L["Invalid word: '%s'"] = "Invalid word: '%s'"
--[[Translation missing --]]
L["Inventory"] = "Inventory"
--[[Translation missing --]]
L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
L["Inventory / Mailing"] = "Inventory / Mailing"
--[[Translation missing --]]
L["Inventory Options"] = "Inventory Options"
--[[Translation missing --]]
L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
--[[Translation missing --]]
L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
--[[Translation missing --]]
L["Item"] = "Item"
--[[Translation missing --]]
L["ITEM CLASS"] = "ITEM CLASS"
--[[Translation missing --]]
L["Item Level"] = "Item Level"
--[[Translation missing --]]
L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
--[[Translation missing --]]
L["Item links may only be used as parameters to price sources."] = "Item links may only be used as parameters to price sources."
--[[Translation missing --]]
L["Item Name"] = "Item Name"
--[[Translation missing --]]
L["Item Quality"] = "Item Quality"
--[[Translation missing --]]
L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
--[[Translation missing --]]
L["Item Value"] = "Item Value"
--[[Translation missing --]]
L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
--[[Translation missing --]]
L["ITEMS"] = "ITEMS"
--[[Translation missing --]]
L["Items"] = "Items"
--[[Translation missing --]]
L["Items in Bags"] = "Items in Bags"
--[[Translation missing --]]
L["Keep in bags quantity:"] = "Keep in bags quantity:"
--[[Translation missing --]]
L["Keep in bank quantity:"] = "Keep in bank quantity:"
--[[Translation missing --]]
L["Keep posted:"] = "Keep posted:"
--[[Translation missing --]]
L["Keep quantity:"] = "Keep quantity:"
--[[Translation missing --]]
L["Keep this amount in bags:"] = "Keep this amount in bags:"
--[[Translation missing --]]
L["Keep this amount:"] = "Keep this amount:"
--[[Translation missing --]]
L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
--[[Translation missing --]]
L["Last 14 Days"] = "Last 14 Days"
--[[Translation missing --]]
L["Last 3 Days"] = "Last 3 Days"
--[[Translation missing --]]
L["Last 30 Days"] = "Last 30 Days"
--[[Translation missing --]]
L["LAST 30 DAYS"] = "LAST 30 DAYS"
--[[Translation missing --]]
L["Last 60 Days"] = "Last 60 Days"
--[[Translation missing --]]
L["Last 7 Days"] = "Last 7 Days"
--[[Translation missing --]]
L["LAST 7 DAYS"] = "LAST 7 DAYS"
--[[Translation missing --]]
L["Last Data Update:"] = "Last Data Update:"
--[[Translation missing --]]
L["Last Purchased"] = "Last Purchased"
--[[Translation missing --]]
L["Last Sold"] = "Last Sold"
--[[Translation missing --]]
L["Level Up"] = "Level Up"
--[[Translation missing --]]
L["LIMIT"] = "LIMIT"
--[[Translation missing --]]
L["Link to Another Operation"] = "Link to Another Operation"
--[[Translation missing --]]
L["List"] = "List"
--[[Translation missing --]]
L["List materials in tooltip"] = "List materials in tooltip"
--[[Translation missing --]]
L["Loading Mails..."] = "Loading Mails..."
--[[Translation missing --]]
L["Loading..."] = "Loading..."
L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Sembra che TradeSkillMaster abbia riscontrato un errore. Aiuta l'autore a riparare l'errore seguendo le istruzioni mostrate."
--[[Translation missing --]]
L["Loop detected in the following custom price:"] = "Loop detected in the following custom price:"
--[[Translation missing --]]
L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
--[[Translation missing --]]
L["Macro created and scroll wheel bound!"] = "Macro created and scroll wheel bound!"
--[[Translation missing --]]
L["Macro Setup"] = "Macro Setup"
--[[Translation missing --]]
L["Mail"] = "Mail"
--[[Translation missing --]]
L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
L["Mailing"] = "Mailing"
--[[Translation missing --]]
L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
--[[Translation missing --]]
L["Main Settings"] = "Main Settings"
--[[Translation missing --]]
L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
--[[Translation missing --]]
L["Management Options"] = "Management Options"
--[[Translation missing --]]
L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
--[[Translation missing --]]
L["Map Ping"] = "Map Ping"
--[[Translation missing --]]
L["Market Value"] = "Market Value"
--[[Translation missing --]]
L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
L["Material Name"] = "Material Name"
--[[Translation missing --]]
L["Materials"] = "Materials"
--[[Translation missing --]]
L["Materials to Gather"] = "Materials to Gather"
--[[Translation missing --]]
L["MAX"] = "MAX"
--[[Translation missing --]]
L["Max Buy Price"] = "Max Buy Price"
--[[Translation missing --]]
L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
--[[Translation missing --]]
L["Max Sell Price"] = "Max Sell Price"
--[[Translation missing --]]
L["Max Shopping Price"] = "Max Shopping Price"
--[[Translation missing --]]
L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
--[[Translation missing --]]
L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
--[[Translation missing --]]
L["Maximum quantity:"] = "Maximum quantity:"
--[[Translation missing --]]
L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
L["Mill Value"] = "Mill Value"
--[[Translation missing --]]
L["Min"] = "Min"
--[[Translation missing --]]
L["Min Buy Price"] = "Min Buy Price"
--[[Translation missing --]]
L["Min Buyout"] = "Min Buyout"
--[[Translation missing --]]
L["Min Sell Price"] = "Min Sell Price"
--[[Translation missing --]]
L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
--[[Translation missing --]]
L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
L["Minimum expires:"] = "Minimum expires:"
--[[Translation missing --]]
L["Minimum profit:"] = "Minimum profit:"
--[[Translation missing --]]
L["MINIMUM RARITY"] = "MINIMUM RARITY"
--[[Translation missing --]]
L["Minimum restock quantity:"] = "Minimum restock quantity:"
--[[Translation missing --]]
L["Misplaced comma"] = "Misplaced comma"
--[[Translation missing --]]
L["Missing Materials"] = "Missing Materials"
--[[Translation missing --]]
L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
--[[Translation missing --]]
L["Modifiers:"] = "Modifiers:"
--[[Translation missing --]]
L["Money Frame Open"] = "Money Frame Open"
--[[Translation missing --]]
L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
L["Most Profitable Item:"] = "Most Profitable Item:"
--[[Translation missing --]]
L["MOVE"] = "MOVE"
--[[Translation missing --]]
L["Move already grouped items?"] = "Move already grouped items?"
--[[Translation missing --]]
L["Move Quantity Settings"] = "Move Quantity Settings"
--[[Translation missing --]]
L["MOVE TO BAGS"] = "MOVE TO BAGS"
--[[Translation missing --]]
L["MOVE TO BANK"] = "MOVE TO BANK"
--[[Translation missing --]]
L["MOVING"] = "MOVING"
--[[Translation missing --]]
L["Moving"] = "Moving"
--[[Translation missing --]]
L["Multiple Items"] = "Multiple Items"
--[[Translation missing --]]
L["My Auctions"] = "My Auctions"
--[[Translation missing --]]
L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
--[[Translation missing --]]
L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
L["NEED MATS"] = "NEED MATS"
--[[Translation missing --]]
L["New Group"] = "New Group"
--[[Translation missing --]]
L["New Operation"] = "New Operation"
--[[Translation missing --]]
L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
--[[Translation missing --]]
L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
L["No Crafts"] = "No Crafts"
--[[Translation missing --]]
L["No Data"] = "No Data"
--[[Translation missing --]]
L["No group selected"] = "No group selected"
--[[Translation missing --]]
L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
--[[Translation missing --]]
L["NO ITEMS"] = "NO ITEMS"
--[[Translation missing --]]
L["No Materials to Gather"] = "No Materials to Gather"
--[[Translation missing --]]
L["No Operation Selected"] = "No Operation Selected"
--[[Translation missing --]]
L["No posting."] = "No posting."
--[[Translation missing --]]
L["No Profession Opened"] = "No Profession Opened"
--[[Translation missing --]]
L["No Profession Selected"] = "No Profession Selected"
--[[Translation missing --]]
L["No profile specified. Possible profiles: '%s'"] = "No profile specified. Possible profiles: '%s'"
--[[Translation missing --]]
L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
--[[Translation missing --]]
L["No Sound"] = "No Sound"
--[[Translation missing --]]
L["None"] = "None"
--[[Translation missing --]]
L["None (Always Show)"] = "None (Always Show)"
--[[Translation missing --]]
L["None Selected"] = "None Selected"
--[[Translation missing --]]
L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
--[[Translation missing --]]
L["Normal"] = "Normal"
--[[Translation missing --]]
L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
--[[Translation missing --]]
L["Not canceling auction below min price."] = "Not canceling auction below min price."
--[[Translation missing --]]
L["Not canceling."] = "Not canceling."
--[[Translation missing --]]
L["Not Connected"] = "Not Connected"
--[[Translation missing --]]
L["Not enough items in bags."] = "Not enough items in bags."
--[[Translation missing --]]
L["NOT OPEN"] = "NOT OPEN"
--[[Translation missing --]]
L["Not Scanned"] = "Not Scanned"
--[[Translation missing --]]
L["Nothing to move."] = "Nothing to move."
--[[Translation missing --]]
L["NPC"] = "NPC"
--[[Translation missing --]]
L["Number Owned"] = "Number Owned"
--[[Translation missing --]]
L["of"] = "of"
--[[Translation missing --]]
L["Offline"] = "Offline"
--[[Translation missing --]]
L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
--[[Translation missing --]]
L["OPEN"] = "OPEN"
--[[Translation missing --]]
L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
--[[Translation missing --]]
L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
L["Open Task List"] = "Open Task List"
--[[Translation missing --]]
L["Operation"] = "Operation"
--[[Translation missing --]]
L["Operations"] = "Operations"
--[[Translation missing --]]
L["Other Character"] = "Other Character"
--[[Translation missing --]]
L["Other Settings"] = "Other Settings"
--[[Translation missing --]]
L["Other Shopping Searches"] = "Other Shopping Searches"
--[[Translation missing --]]
L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
L["Parent Items"] = "Parent Items"
--[[Translation missing --]]
L["Past 7 Days"] = "Past 7 Days"
--[[Translation missing --]]
L["Past Day"] = "Past Day"
--[[Translation missing --]]
L["Past Month"] = "Past Month"
--[[Translation missing --]]
L["Past Year"] = "Past Year"
--[[Translation missing --]]
L["Paste string here"] = "Paste string here"
--[[Translation missing --]]
L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
--[[Translation missing --]]
L["Per Item"] = "Per Item"
--[[Translation missing --]]
L["Per Stack"] = "Per Stack"
--[[Translation missing --]]
L["Per Unit"] = "Per Unit"
--[[Translation missing --]]
L["Player Gold"] = "Player Gold"
--[[Translation missing --]]
L["Player Invite Accept"] = "Player Invite Accept"
--[[Translation missing --]]
L["Please select a group to export"] = "Please select a group to export"
--[[Translation missing --]]
L["POST"] = "POST"
--[[Translation missing --]]
L["Post at Maximum Price"] = "Post at Maximum Price"
--[[Translation missing --]]
L["Post at Minimum Price"] = "Post at Minimum Price"
--[[Translation missing --]]
L["Post at Normal Price"] = "Post at Normal Price"
--[[Translation missing --]]
L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
--[[Translation missing --]]
L["Post Scan"] = "Post Scan"
--[[Translation missing --]]
L["POST SELECTED"] = "POST SELECTED"
--[[Translation missing --]]
L["POSTAGE"] = "POSTAGE"
--[[Translation missing --]]
L["Postage"] = "Postage"
--[[Translation missing --]]
L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
L["Posted Auctions %s:"] = "Posted Auctions %s:"
--[[Translation missing --]]
L["Posting"] = "Posting"
--[[Translation missing --]]
L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
L["Posting disabled."] = "Posting disabled."
--[[Translation missing --]]
L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
L["Posts"] = "Posts"
--[[Translation missing --]]
L["Potential"] = "Potential"
--[[Translation missing --]]
L["Price Per Item"] = "Price Per Item"
--[[Translation missing --]]
L["Price Settings"] = "Price Settings"
--[[Translation missing --]]
L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
--[[Translation missing --]]
L["PROFESSION"] = "PROFESSION"
--[[Translation missing --]]
L["Profession Filters"] = "Profession Filters"
--[[Translation missing --]]
L["Profession Info"] = "Profession Info"
--[[Translation missing --]]
L["Profession loading..."] = "Profession loading..."
--[[Translation missing --]]
L["Professions Used In"] = "Professions Used In"
--[[Translation missing --]]
L["Profile changed to '%s'."] = "Profile changed to '%s'."
--[[Translation missing --]]
L["Profiles"] = "Profiles"
--[[Translation missing --]]
L["PROFIT"] = "PROFIT"
--[[Translation missing --]]
L["Profit"] = "Profit"
--[[Translation missing --]]
L["Prospect Value"] = "Prospect Value"
--[[Translation missing --]]
L["PURCHASE DATA"] = "PURCHASE DATA"
--[[Translation missing --]]
L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
--[[Translation missing --]]
L["Purchased (Total Price)"] = "Purchased (Total Price)"
--[[Translation missing --]]
L["Purchases"] = "Purchases"
--[[Translation missing --]]
L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
L["Qty"] = "Qty"
--[[Translation missing --]]
L["Quantity Bought:"] = "Quantity Bought:"
--[[Translation missing --]]
L["Quantity Sold:"] = "Quantity Sold:"
--[[Translation missing --]]
L["Quantity to move:"] = "Quantity to move:"
--[[Translation missing --]]
L["Quest Added"] = "Quest Added"
--[[Translation missing --]]
L["Quest Completed"] = "Quest Completed"
--[[Translation missing --]]
L["Quest Objectives Complete"] = "Quest Objectives Complete"
--[[Translation missing --]]
L["QUEUE"] = "QUEUE"
--[[Translation missing --]]
L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
--[[Translation missing --]]
L["Raid Warning"] = "Raid Warning"
--[[Translation missing --]]
L["Read More"] = "Read More"
--[[Translation missing --]]
L["Ready Check"] = "Ready Check"
--[[Translation missing --]]
L["Ready to Cancel"] = "Ready to Cancel"
--[[Translation missing --]]
L["Realm Data Tooltips"] = "Realm Data Tooltips"
--[[Translation missing --]]
L["Recent Scans"] = "Recent Scans"
--[[Translation missing --]]
L["Recent Searches"] = "Recent Searches"
--[[Translation missing --]]
L["Recently Mailed"] = "Recently Mailed"
--[[Translation missing --]]
L["RECIPIENT"] = "RECIPIENT"
--[[Translation missing --]]
L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
L["Region Sale Rate"] = "Region Sale Rate"
--[[Translation missing --]]
L["Reload"] = "Reload"
--[[Translation missing --]]
L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
--[[Translation missing --]]
L["Removed a total of %s old records."] = "Removed a total of %s old records."
--[[Translation missing --]]
L["Rename"] = "Rename"
--[[Translation missing --]]
L["Rename Profile"] = "Rename Profile"
--[[Translation missing --]]
L["REPAIR"] = "REPAIR"
--[[Translation missing --]]
L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
L["Replace duplicate operations?"] = "Replace duplicate operations?"
--[[Translation missing --]]
L["REPLY"] = "REPLY"
--[[Translation missing --]]
L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
L["Repost Higher Threshold"] = "Repost Higher Threshold"
--[[Translation missing --]]
L["Required Level"] = "Required Level"
--[[Translation missing --]]
L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
--[[Translation missing --]]
L["Resale"] = "Resale"
--[[Translation missing --]]
L["RESCAN"] = "RESCAN"
--[[Translation missing --]]
L["RESET"] = "RESET"
--[[Translation missing --]]
L["Reset All"] = "Reset All"
--[[Translation missing --]]
L["Reset Filters"] = "Reset Filters"
--[[Translation missing --]]
L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
--[[Translation missing --]]
L["RESTART"] = "RESTART"
--[[Translation missing --]]
L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
L["Revenue"] = "Revenue"
--[[Translation missing --]]
L["Round normal price"] = "Round normal price"
--[[Translation missing --]]
L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
--[[Translation missing --]]
L["Run Bid Sniper"] = "Run Bid Sniper"
--[[Translation missing --]]
L["Run Buyout Sniper"] = "Run Buyout Sniper"
--[[Translation missing --]]
L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
L["RUN POST SCAN"] = "RUN POST SCAN"
--[[Translation missing --]]
L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
--[[Translation missing --]]
L["Running Sniper Scan"] = "Running Sniper Scan"
--[[Translation missing --]]
L["Sale"] = "Sale"
--[[Translation missing --]]
L["SALE DATA"] = "SALE DATA"
--[[Translation missing --]]
L["Sale Price"] = "Sale Price"
--[[Translation missing --]]
L["Sale Rate"] = "Sale Rate"
--[[Translation missing --]]
L["Sales"] = "Sales"
--[[Translation missing --]]
L["SALES"] = "SALES"
--[[Translation missing --]]
L["Sales Summary"] = "Sales Summary"
--[[Translation missing --]]
L["SCAN ALL"] = "SCAN ALL"
--[[Translation missing --]]
L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
L["Scan Paused"] = "Scan Paused"
--[[Translation missing --]]
L["SCANNING"] = "SCANNING"
--[[Translation missing --]]
L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
L["Scroll wheel direction:"] = "Scroll wheel direction:"
--[[Translation missing --]]
L["Search"] = "Search"
--[[Translation missing --]]
L["Search Bags"] = "Search Bags"
--[[Translation missing --]]
L["Search Groups"] = "Search Groups"
--[[Translation missing --]]
L["Search Inbox"] = "Search Inbox"
--[[Translation missing --]]
L["Search Operations"] = "Search Operations"
--[[Translation missing --]]
L["Search Patterns"] = "Search Patterns"
--[[Translation missing --]]
L["Search Usable Items Only?"] = "Search Usable Items Only?"
--[[Translation missing --]]
L["Search Vendor"] = "Search Vendor"
--[[Translation missing --]]
L["Select a Source"] = "Select a Source"
--[[Translation missing --]]
L["Select Action"] = "Select Action"
--[[Translation missing --]]
L["Select All Groups"] = "Select All Groups"
--[[Translation missing --]]
L["Select All Items"] = "Select All Items"
--[[Translation missing --]]
L["Select Auction to Cancel"] = "Select Auction to Cancel"
--[[Translation missing --]]
L["Select crafter"] = "Select crafter"
--[[Translation missing --]]
L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
--[[Translation missing --]]
L["Select Duration"] = "Select Duration"
--[[Translation missing --]]
L["Select Items to Add"] = "Select Items to Add"
--[[Translation missing --]]
L["Select Items to Remove"] = "Select Items to Remove"
--[[Translation missing --]]
L["Select Operation"] = "Select Operation"
--[[Translation missing --]]
L["Select professions"] = "Select professions"
--[[Translation missing --]]
L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
--[[Translation missing --]]
L["Selected Groups"] = "Selected Groups"
--[[Translation missing --]]
L["Selected Operations"] = "Selected Operations"
--[[Translation missing --]]
L["Sell"] = "Sell"
--[[Translation missing --]]
L["SELL ALL"] = "SELL ALL"
--[[Translation missing --]]
L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
L["SELL GROUPS"] = "SELL GROUPS"
--[[Translation missing --]]
L["Sell Options"] = "Sell Options"
--[[Translation missing --]]
L["Sell soulbound items?"] = "Sell soulbound items?"
--[[Translation missing --]]
L["Sell to Vendor"] = "Sell to Vendor"
--[[Translation missing --]]
L["SELL TRASH"] = "SELL TRASH"
--[[Translation missing --]]
L["Seller"] = "Seller"
--[[Translation missing --]]
L["Selling soulbound items."] = "Selling soulbound items."
--[[Translation missing --]]
L["Send"] = "Send"
--[[Translation missing --]]
L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
--[[Translation missing --]]
L["SEND GOLD"] = "SEND GOLD"
--[[Translation missing --]]
L["Send grouped items individually"] = "Send grouped items individually"
--[[Translation missing --]]
L["SEND MAIL"] = "SEND MAIL"
--[[Translation missing --]]
L["Send Money"] = "Send Money"
--[[Translation missing --]]
L["Send Profile"] = "Send Profile"
--[[Translation missing --]]
L["SENDING"] = "SENDING"
--[[Translation missing --]]
L["Sending %s individually to %s"] = "Sending %s individually to %s"
--[[Translation missing --]]
L["Sending %s to %s"] = "Sending %s to %s"
--[[Translation missing --]]
L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
--[[Translation missing --]]
L["Sending Settings"] = "Sending Settings"
--[[Translation missing --]]
L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
--[[Translation missing --]]
L["SENDING..."] = "SENDING..."
--[[Translation missing --]]
L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
L["Setup"] = "Setup"
--[[Translation missing --]]
L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
L["Shards"] = "Frammenti"
--[[Translation missing --]]
L["Shopping"] = "Shopping"
--[[Translation missing --]]
L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
--[[Translation missing --]]
L["Show Description"] = "Show Description"
--[[Translation missing --]]
L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
--[[Translation missing --]]
L["Show material cost"] = "Show material cost"
--[[Translation missing --]]
L["Show on Modifier"] = "Show on Modifier"
--[[Translation missing --]]
L["Showing %d Mail"] = "Showing %d Mail"
--[[Translation missing --]]
L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
--[[Translation missing --]]
L["Showing all %d Mails"] = "Showing all %d Mails"
--[[Translation missing --]]
L["Simple"] = "Simple"
--[[Translation missing --]]
L["SKIP"] = "SKIP"
--[[Translation missing --]]
L["Skip Import confirmation?"] = "Skip Import confirmation?"
--[[Translation missing --]]
L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
L["Slash Commands:"] = "Comandi Slash:"
--[[Translation missing --]]
L["Sniper"] = "Sniper"
--[[Translation missing --]]
L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
--[[Translation missing --]]
L["Sniper Options"] = "Sniper Options"
--[[Translation missing --]]
L["Sniper Settings"] = "Sniper Settings"
--[[Translation missing --]]
L["Sniping items below a max price"] = "Sniping items below a max price"
--[[Translation missing --]]
L["Sold"] = "Sold"
--[[Translation missing --]]
L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
L["Sold %s worth of items."] = "Sold %s worth of items."
--[[Translation missing --]]
L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
--[[Translation missing --]]
L["Sold (Total Price)"] = "Sold (Total Price)"
--[[Translation missing --]]
L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
--[[Translation missing --]]
L["Sold Auctions %s:"] = "Sold Auctions %s:"
--[[Translation missing --]]
L["Source"] = "Source"
--[[Translation missing --]]
L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
L["SOURCES"] = "SOURCES"
--[[Translation missing --]]
L["Sources"] = "Sources"
--[[Translation missing --]]
L["Sources to include for restock:"] = "Sources to include for restock:"
--[[Translation missing --]]
L["Stack"] = "Stack"
--[[Translation missing --]]
L["Stack / Quantity"] = "Stack / Quantity"
--[[Translation missing --]]
L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
--[[Translation missing --]]
L["Starting Scan..."] = "Starting Scan..."
--[[Translation missing --]]
L["STOP"] = "STOP"
--[[Translation missing --]]
L["Store operations globally"] = "Store operations globally"
--[[Translation missing --]]
L["Subject"] = "Subject"
--[[Translation missing --]]
L["SUBJECT"] = "SUBJECT"
--[[Translation missing --]]
L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
L["Switch to %s"] = "Switch to %s"
--[[Translation missing --]]
L["Switch to WoW UI"] = "Switch to WoW UI"
--[[Translation missing --]]
L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
L["Sync Status"] = "Sync Status"
--[[Translation missing --]]
L["TAKE ALL"] = "TAKE ALL"
--[[Translation missing --]]
L["Take Attachments"] = "Take Attachments"
--[[Translation missing --]]
L["Target Character"] = "Target Character"
--[[Translation missing --]]
L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
L["Tasks Added to Task List"] = "Tasks Added to Task List"
--[[Translation missing --]]
L["Text (%s)"] = "Text (%s)"
--[[Translation missing --]]
L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
--[[Translation missing --]]
L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "The name can ONLY contain letters. No spaces, numbers, or special characters."
--[[Translation missing --]]
L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
--[[Translation missing --]]
L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
--[[Translation missing --]]
L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
--[[Translation missing --]]
L["This item is not in a TSM group."] = "This item is not in a TSM group."
--[[Translation missing --]]
L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
--[[Translation missing --]]
L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
--[[Translation missing --]]
L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
--[[Translation missing --]]
L["Time"] = "Time"
--[[Translation missing --]]
L["Time Format"] = "Time Format"
--[[Translation missing --]]
L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
L["TINKER"] = "TINKER"
--[[Translation missing --]]
L["Tooltip Price Format"] = "Tooltip Price Format"
--[[Translation missing --]]
L["Tooltip Settings"] = "Tooltip Settings"
--[[Translation missing --]]
L["Top Buyers:"] = "Top Buyers:"
--[[Translation missing --]]
L["Top Item:"] = "Top Item:"
--[[Translation missing --]]
L["Top Sellers:"] = "Top Sellers:"
--[[Translation missing --]]
L["Total"] = "Total"
--[[Translation missing --]]
L["Total Gold"] = "Total Gold"
--[[Translation missing --]]
L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
--[[Translation missing --]]
L["Total Gold Earned:"] = "Total Gold Earned:"
--[[Translation missing --]]
L["Total Gold Spent:"] = "Total Gold Spent:"
--[[Translation missing --]]
L["Total Price"] = "Total Price"
--[[Translation missing --]]
L["Total Profit:"] = "Total Profit:"
--[[Translation missing --]]
L["Total Value"] = "Total Value"
--[[Translation missing --]]
L["Total Value of All Items"] = "Total Value of All Items"
--[[Translation missing --]]
L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
--[[Translation missing --]]
L["Transform Value"] = "Transform Value"
--[[Translation missing --]]
L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
--[[Translation missing --]]
L["TSM Crafting"] = "TSM Crafting"
--[[Translation missing --]]
L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
--[[Translation missing --]]
L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
--[[Translation missing --]]
L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
--[[Translation missing --]]
L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
--[[Translation missing --]]
L["TSM Mailing"] = "TSM Mailing"
--[[Translation missing --]]
L["TSM TASK LIST"] = "TSM TASK LIST"
--[[Translation missing --]]
L["TSM Vendoring"] = "TSM Vendoring"
--[[Translation missing --]]
L["TSM Version Info:"] = "TSM Version Info:"
--[[Translation missing --]]
L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
--[[Translation missing --]]
L["TSM4"] = "TSM4"
--[[Translation missing --]]
L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
--[[Translation missing --]]
L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
--[[Translation missing --]]
L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
L["TUJ Global Median"] = "TUJ Global Median"
--[[Translation missing --]]
L["Twitter Integration"] = "Twitter Integration"
--[[Translation missing --]]
L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
--[[Translation missing --]]
L["Type"] = "Type"
--[[Translation missing --]]
L["Type Something"] = "Type Something"
--[[Translation missing --]]
L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
--[[Translation missing --]]
L["Unbalanced parentheses."] = "Unbalanced parentheses."
--[[Translation missing --]]
L["Undercut amount:"] = "Undercut amount:"
--[[Translation missing --]]
L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
--[[Translation missing --]]
L["Undercutting competition."] = "Undercutting competition."
--[[Translation missing --]]
L["Ungrouped Items"] = "Ungrouped Items"
--[[Translation missing --]]
L["Unknown Item"] = "Unknown Item"
--[[Translation missing --]]
L["Unwrap Gift"] = "Unwrap Gift"
--[[Translation missing --]]
L["Up"] = "Up"
--[[Translation missing --]]
L["Up to date"] = "Up to date"
--[[Translation missing --]]
L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
--[[Translation missing --]]
L["Updating"] = "Updating"
--[[Translation missing --]]
L["Usage: /tsm price <ItemLink> <Price String>"] = "Usage: /tsm price <ItemLink> <Price String>"
--[[Translation missing --]]
L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
L["Variable Name"] = "Variable Name"
--[[Translation missing --]]
L["Vendor"] = "Vendor"
--[[Translation missing --]]
L["Vendor Buy Price"] = "Vendor Buy Price"
--[[Translation missing --]]
L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
L["VENDOR SEARCH"] = "VENDOR SEARCH"
--[[Translation missing --]]
L["Vendor Sell"] = "Vendor Sell"
--[[Translation missing --]]
L["Vendor Sell Price"] = "Vendor Sell Price"
--[[Translation missing --]]
L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNING: The macro was too long, so was truncated to fit by WoW."
--[[Translation missing --]]
L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
--[[Translation missing --]]
L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
--[[Translation missing --]]
L["When above maximum:"] = "When above maximum:"
--[[Translation missing --]]
L["When below minimum:"] = "When below minimum:"
--[[Translation missing --]]
L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
L["Whitelisted Players"] = "Whitelisted Players"
--[[Translation missing --]]
L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
L["You cannot use %s as part of this custom price."] = "Non puoi usare %s come prezzo personalizzato."
--[[Translation missing --]]
L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
--[[Translation missing --]]
L["You don't know how to craft this item."] = "You don't know how to craft this item."
--[[Translation missing --]]
L["You must reload your UI for these settings to take effect. Reload now?"] = "You must reload your UI for these settings to take effect. Reload now?"
--[[Translation missing --]]
L["You won an auction for %sx%d for %s"] = "You won an auction for %sx%d for %s"
--[[Translation missing --]]
L["Your auction has not been undercut."] = "Your auction has not been undercut."
--[[Translation missing --]]
L["Your auction of %s expired"] = "Your auction of %s expired"
--[[Translation missing --]]
L["Your auction of %s has sold for %s!"] = "Your auction of %s has sold for %s!"
--[[Translation missing --]]
L["Your Buyout"] = "Your Buyout"
--[[Translation missing --]]
L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
L["Your task list is currently empty."] = "Your task list is currently empty."
--[[Translation missing --]]
L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
--[[Translation missing --]]
L["You've been undercut."] = "You've been undercut."
	elseif locale == "koKR" then

	elseif locale == "ptBR" then
L = L or {}
L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Grupo:Grupos; Selecionado (%d |4Item:Itens;)"
L["%d auctions"] = "%d leilões"
L["%d Groups"] = "%d Grupos"
L["%d Items"] = "%d Itens"
L["%d of %d"] = "%d de %d"
L["%d Operations"] = "%d Operações"
L["%d Posted Auctions"] = "%d Leilões Postados"
L["%d Sold Auctions"] = "%d Leilões Vendidos"
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s bolsas, %s banco, %s CdL, %s correio)"
L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s jogador, %s alts, %s guilda, %s CdL)"
L["%s (%s profit)"] = "%s (%s lucro)"
L["%s |4operation:operations;"] = "%s |4operação:operações;"
L["%s ago"] = "%s atrás"
L["%s Crafts"] = "%s Criações"
L["%s group updated with %d items and %d materials."] = "Grupo %s atualizado com %d itens e %d materiais."
L["%s in guild vault"] = "%s no banco da guilda"
L["%s is a valid custom price but %s is an invalid item."] = "%s é um preço personalizado válido mas %s é um item inválido."
L["%s is a valid custom price but did not give a value for %s."] = "%s é um preço personalizado válido mas deu um valor para %s."
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' é uma operação inválida! O reabastecimento mínimo de %d é maior que o reabastecimento máximo de %d."
L["%s is not a valid custom price and gave the following error: %s"] = "%s não é um preço personalizado válido e deu o seguinte erro: %s"
L["%s Operations"] = "%s Operações"
L["%s previously had the max number of operations, so removed %s."] = "%s antes tinha o número máximo de operações, então removemos %s."
L["%s removed."] = "%s removido."
L["%s sent you %s"] = "%s lhe enviou %s"
L["%s sent you %s and %s"] = "%s lhe enviou %s e %s"
L["%s sent you a COD of %s for %s"] = "%s lhe enviou uma Carta a Cobrar de %s por %s"
L["%s sent you a message: %s"] = "%s lhe enviou uma mensagem: %s"
L["%s total"] = "%s total"
L["%sDrag%s to move this button"] = "%sArraste%s para mover este botão"
L["%sLeft-Click%s to open the main window"] = "%sClique-Esquerdo%s para abrir a janela principal"
L["(%d/500 Characters)"] = "(%d/500 Caracteres)"
L["(max %d)"] = "(máximo %d)"
L["(max 5000)"] = "(máximo 5000)"
L["(min %d - max %d)"] = "(mínimo %d - máximo %d)"
L["(min 0 - max 10000)"] = "(mínimo 0 - máximo 10000)"
L["(minimum 0 - maximum 20)"] = "(mínimo 0 - máximo 20)"
L["(minimum 0 - maximum 2000)"] = "(mínimo 0 - máximo 2000)"
L["(minimum 0 - maximum 905)"] = "(mínimo 0 - máximo 905)"
L["(minimum 0.5 - maximum 10)"] = "(mínimo 0.5 - máximo 10)"
L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Mostra esta lista de ajuda"
L["/tsm|r - opens the main TSM window."] = "/tsm|r - abre a janela principal do TSM."
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANTE:|r Quando o TSM_Accounting salvou os dados para este reino pela última vez, eles eram muito grandes para o WoW processar, então os dados antigos foram automaticamente cortados para evitar a corrupção das variáveis salvas. Os últimos %s de dados de compras foram preservados."
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANTE:|r Quando o TSM_Accounting salvou os dados para este reino pela última vez, eles eram muito grandes para o WoW processar, então os dados antigos foram automaticamente cortados para evitar a corrupção das variáveis salvas. Os últimos %s de dados de vendas foram preservados."
L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Clique com o botão esquerdo|r para ignorar este item nesta seção. Segure |cffffd839Shift|r para ignorá-lo permanentemente. Você pode remover itens ignorados permanentemente nas configurações de Venda."
L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Clique com o botão esquerdo|r para ignorar um item nesta sessão."
L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift + Clique com o botão esquerdo|r para ignorar isto permanentemente."
L["1 Group"] = "1 Grupo"
L["1 Item"] = "1 Item"
L["12 hr"] = "12hs"
L["24 hr"] = "24hs"
L["48 hr"] = "48hs"
L["A custom price of %s for %s evaluates to %s."] = "O preço personalizado de %s para %s calcula %s."
L["A maximum of 1 convert() function is allowed."] = "É permitida no máximo 1 função convert()."
L["A profile with that name already exists on the target account. Rename it first and try again."] = "Um perfil com este nome já existe na conta alvo. Renomeie-o primeiro e tente novamente."
L["A profile with this name already exists."] = "Um perfil com este nome já existe."
L["A scan is already in progress. Please stop that scan before starting another one."] = "Um escaneamento está em progresso atualmente. Por favor, pare este escaneamento antes de iniciar outro."
L["Above max expires."] = "Acima do limite de expiração."
L["Above max price. Not posting."] = "Acima do preço máximo. Não será postado."
L["Above max price. Posting at max price."] = "Acima do preço máximo. Postando no preço máximo."
L["Above max price. Posting at min price."] = "Acima do preço máximo. Postando no preço mínimo."
L["Above max price. Posting at normal price."] = "Acima do preço máximo. Postando no preço normal."
L["Accepting these item(s) will cost"] = "Aceitar estes itens custará"
L["Accepting this item will cost"] = "Aceitar este item custará"
L["Account sync removed. Please delete the account sync from the other account as well."] = "Sincronização de conta removida. Por favor, remova a sincronização da outra conta também."
L["Account Syncing"] = "Sincronização da Conta"
L["Accounting"] = "Contabilidade"
L["Accounting Tooltips"] = "Tooltips de Contabilidade"
L["Activity Type"] = "Atividade"
L["ADD %d ITEMS"] = "ADICIONAR %d ITENS"
L["Add / Remove Items"] = "Adiciona / Remove Itens"
L["ADD NEW CUSTOM PRICE SOURCE"] = "ADICIONAR UMA NOVA FONTE DE PREÇO PERSONALIZADO"
L["ADD OPERATION"] = "ADICIONAR OPERAÇÃO"
L["Add Player"] = "Adicionar Jogador"
L["Add Subject / Description"] = "Adicionar Assunto / Descrição"
L["Add Subject / Description (Optional)"] = "Adicionar Assunto / Descrição (Opcional)"
L["ADD TO MAIL"] = "ADICIONAR À CARTA"
L["Added '%s' profile which was received from %s."] = "O Perfil '%s', recebido de %s, foi adicionado."
L["Added %s to %s."] = "%s adicionado a %s."
L["Additional error suppressed"] = "Erro adicional suprimido"
L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Ajuste as configurações abaixo para definir como os grupos ligados à esta operação serão postados."
L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Ajuste as configurações abaixo para definir como os grupos ligados à esta operação serão cancelados."
L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Ajuste as configurações abaixo para definir como os preços dos grupos ligados à esta operação serão definidos."
L["Advanced Item Search"] = "Busca Avançada de Item"
L["Advanced Options"] = "Opções Avançadas"
L["AH"] = "CdL"
L["AH (Crafting)"] = "CdL (Criação)"
L["AH (Disenchanting)"] = "CdL (Desencantamento)"
L["AH BUSY"] = "CdL OCUPADA"
L["AH Frame Options"] = "Opções da Janela de CdL"
L["Alarm Clock"] = "Despertador"
L["All Auctions"] = "Todos os Leilões"
L["All Characters and Guilds"] = "Todos os Personagens e Guildas"
L["All Item Classes"] = "Todas as Classes de Item"
L["All Professions"] = "Todas as Profissões"
L["All Subclasses"] = "Todas as Subclasses"
L["Allow partial stack?"] = "Permitir lote parcial?"
L["Alt Guild Bank"] = "Banco de Guilda do Alt"
L["Alts"] = "Alts"
L["Alts AH"] = "Alts CdL"
L["Amount"] = "Quantidade"
L["AMOUNT"] = "QUANTIDADE"
L["Amount of Bag Space to Keep Free"] = "Quantidade de espaços da Bolsa para manter vazio"
L["APPLY FILTERS"] = "APLICAR FILTROS"
L["Apply operation to group:"] = "Aplicar operação ao grupo:"
L["Are you sure you want to clear old accounting data?"] = "Você tem certeza que quer excluir seus dados antigos de contabilidade?"
L["Are you sure you want to delete this group?"] = "Você tem certeza que quer excluir esse grupo?"
L["Are you sure you want to delete this operation?"] = "Você tem certeza que você quer excluir essa operação?"
L["Are you sure you want to reset all operation settings?"] = "Você tem certeza que quer redefinir todas as configurações da operação?"
L["At above max price and not undercut."] = "Acima do preço máximo e sem corte de preço."
L["At normal price and not undercut."] = "No preço normal e sem corte de preço."
L["Auction"] = "Leilão"
L["Auction Bid"] = "Lance do Leilão"
L["Auction Buyout"] = "Arremate do Leilão"
L["AUCTION DETAILS"] = "DETALHES DO LEILÃO"
L["Auction Duration"] = "Duração do Leilão"
L["Auction has been bid on."] = "O Leilão tem um lance."
L["Auction House Cut"] = "Desconto da Casa de Leilão"
L["Auction Sale Sound"] = "Som de Venda de Leilão"
L["Auction Window Close"] = "Fechar Janela de Leilão"
L["Auction Window Open"] = "Abrir Janela de Leilão"
L["Auctionator - Auction Value"] = "Auctionator - Valor de Leilão"
L["AuctionDB - Market Value"] = "AuctionDB - Preço de Mercado"
L["Auctioneer - Appraiser"] = "Auctioneer - Avaliador"
L["Auctioneer - Market Value"] = "Auctioneer - Valor de Mercado"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - Arremate Mínimo"
L["Auctioning"] = "Postagem"
L["Auctioning Log"] = "Registro de Postagem"
L["Auctioning Operation"] = "Operação de Postagem"
L["Auctioning 'POST'/'CANCEL' Button"] = "Botão 'POSTAR'/'CANCELAR' em Postagem"
L["Auctioning Tooltips"] = "Tooltips de Postagem"
L["Auctions"] = "Leilões"
L["Auto Quest Complete"] = "Busca Automática Concluída"
L["Average Earned Per Day:"] = "Média de Ganhos Por Dia:"
L["Average Prices:"] = "Preços Médios:"
L["Average Profit Per Day:"] = "Média de Lucro Por Dia:"
L["Average Spent Per Day:"] = "Média de Gastos Por Dia:"
L["Avg Buy Price"] = "Média de Preço de Compra"
L["Avg Resale Profit"] = "Média de Lucro de Revenda"
L["Avg Sell Price"] = "Média de Preço de Venda"
L["BACK"] = "VOLTAR"
L["BACK TO LIST"] = "VOLTAR PARA A LISTA"
L["Back to List"] = "Voltar para a Lista"
L["Bag"] = "Bolsa"
L["Bags"] = "Bolsas"
L["Banks"] = "Bancos"
L["Base Group"] = "Grupo Base"
L["Base Item"] = "Item Base"
L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Abaixo estão suas fontes de preços atualmente disponíveis e organizadas por módulo. O %skey|r é o que você digitaria em uma caixa de preço personalizado."
L["Below custom price:"] = "Abaixo do preço personalizado:"
L["Below min price. Posting at max price."] = "Abaixo do preço mínimo. Postando no preço máximo."
L["Below min price. Posting at min price."] = "Abaixo do preço mínimo. Postando no preço mínimo."
L["Below min price. Posting at normal price."] = "Abaixo do preço mínimo. Postando no preço normal."
L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Abaixo você pode gerenciar seus perfis, o que permite que tenha um conjunto totalmente diferente de grupos."
L["BID"] = "LANCE"
L["Bid %d / %d"] = "Lance %d / %d"
L["Bid (item)"] = "Lance (item)"
L["Bid (stack)"] = "Lance (lote)"
L["Bid Price"] = "Preço de Lance"
L["Bid Sniper Paused"] = "Sniper de Lances Interrompido"
L["Bid Sniper Running"] = "Sniper de Lances Rodando"
L["Bidding Auction"] = "Dando Lance no Leilão"
L["Blacklisted players:"] = "Jogadores na lista negra:"
L["Bought"] = "Comprado"
L["Bought %d of %s from %s for %s"] = "Comprou %d de %s de %s por %s"
L["Bought %sx%d for %s from %s"] = "Comprou %sx%d por %s de %s"
L["Bound Actions"] = "Ações Vinculadas"
L["BUSY"] = "OCUPADO"
L["BUY"] = "COMPRAR"
L["Buy"] = "Compra"
L["Buy %d / %d"] = "Comprar %d / %d"
L["Buy %d / %d (Confirming %d / %d)"] = "Comprar %d / %d (Confirmando %d / %d)"
L["Buy from AH"] = "Comprar da CdL"
L["Buy from Vendor"] = "Comprar do Comerciante"
L["BUY GROUPS"] = "COMPRAR GRUPOS"
L["Buy Options"] = "Opções de Compra"
L["BUYBACK ALL"] = "COMPRAR TUDO DE VOLTA"
L["Buyer/Seller"] = "Personagem"
L["BUYOUT"] = "ARREMATE"
L["Buyout (item)"] = "Arremate (item)"
L["Buyout (stack)"] = "Arremate (lote)"
L["Buyout Confirmation Alert"] = "Alerta de Confirmação de Arremate"
L["Buyout Price"] = "Preço de Arremate"
L["Buyout Sniper Paused"] = "Sniper de Arremate Interrompido"
L["Buyout Sniper Running"] = "Sniper de Arremate Rodando"
L["BUYS"] = "COMPRAS"
L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "Por padrão, este grupo armazena todos os itens que não estão atribuídos à um grupo. Você não pode modificar ou excluir este grupo."
L["Cancel auctions with bids"] = "Cancelar leilões com lances"
L["Cancel Scan"] = "Escanear para Cancelamento"
L["Cancel to repost higher?"] = "Cancelar para repostar mais caro?"
L["Cancel undercut auctions?"] = "Cancelar leilões com preços cortados?"
L["Canceling"] = "Cancelando"
L["Canceling %d / %d"] = "Cancelando %d / %d"
L["Canceling %d Auctions..."] = "Cancelando %d Leilões..."
L["Canceling all auctions."] = "Cancelando todos os leilões."
L["Canceling auction which you've undercut."] = "Cancelando leilão que você fez o corte de preço."
L["Canceling disabled."] = "Cancelamento desabilitado."
L["Canceling Settings"] = "Configurações de Cancelamento"
L["Canceling to repost at higher price."] = "Cancelando para repostar por preço mais alto."
L["Canceling to repost at reset price."] = "Cancelando para repostar a preço de reset."
L["Canceling to repost higher."] = "Cancelando para repostar mais caro."
L["Canceling undercut auctions and to repost higher."] = "Cancelando leilões com preços cortados para postar mais alto."
L["Canceling undercut auctions."] = "Cancelando leilões com preços cortados."
L["Cancelled"] = "Cancelado"
L["Cancelled auction of %sx%d"] = "Leilão cancelado de %sx%d"
L["Cancelled Since Last Sale"] = "Cancelados Desde a Última Venda"
L["CANCELS"] = "CANCELADOS"
L["Cannot repair from the guild bank!"] = "Não pode reparar usando o banco de guilda!"
L["Can't load TSM tooltip while in combat"] = "Não é possível carregar as tooltips do TSM enquanto em combate"
L["Cash Register"] = "Caixa Registradora"
L["CHARACTER"] = "PERSONAGEM"
L["Character"] = "Personagem"
L["Chat Tab"] = "Aba de Bate-Papo"
L["Cheapest auction below min price."] = "Leilão mais barato abaixo do preço mínimo."
L["Clear"] = "Limpar"
L["Clear All"] = "Limpar Tudo"
L["CLEAR DATA"] = "LIMPAR DADOS"
L["Clear Filters"] = "Limpar Filtros"
L["Clear Old Data"] = "Limpeza de Dados Antigos"
L["Clear Old Data Confirmation"] = "Confirmação da Limpeza de Dados Antigos"
L["Clear Queue"] = "Limpar Fila"
L["Clear Selection"] = "Limpar Seleção"
L["COD"] = "Carta a Cobrar"
L["Coins (%s)"] = "Moedas (%s)"
L["Collapse All Groups"] = "Recolher Todos os Grupos"
L["Combine Partial Stacks"] = "Combinar Lotes Parciais"
L["Combining..."] = "Combinando..."
L["Configuration Scroll Wheel"] = "Configuração da Roda do Mouse"
L["Confirm"] = "Confirmar"
L["Confirm Complete Sound"] = "Som de Confirmação Completo"
L["Confirming %d / %d"] = "Confirmando %d / %d"
L["Connected to %s"] = "Conectado a %s"
L["Connecting to %s"] = "Conectandoa %s"
L["CONTACTS"] = "CONTATOS"
L["Contacts Menu"] = "Menu de Contatos"
L["Cooldown"] = "Recarga"
L["Cooldowns"] = "Recargas"
L["Cost"] = "Custo"
L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Não foi possível criar a macro pois você já possui várias. Exclua uma de suas macros existentes e tente novamente."
L["Could not find profile '%s'. Possible profiles: '%s'"] = "Não foi possível encontrar o perfil '%s'. Possíveis perfis: '%s'"
L["Could not sell items due to not having free bag space available to split a stack of items."] = "Não foi possível vender os itens por não haver espaço de bolsa disponível para separar os lotes de itens."
L["Craft"] = "Cria"
L["CRAFT"] = "CRIAR"
L["Craft (Unprofitable)"] = "Criar (Sem lucro)"
L["Craft (When Profitable)"] = "Criar (Quando existir Lucro)"
L["Craft All"] = "Criar Todos"
L["CRAFT ALL"] = "CRIAR TODOS"
L["Craft Name"] = "Nome do Item"
L["CRAFT NEXT"] = "CRIAR PRÓXIMO"
L["Craft value method:"] = "Método de valor da criação:"
L["CRAFTER"] = "CRIADOR"
L["CRAFTING"] = "CRIAÇÃO"
L["Crafting"] = "Criação"
L["Crafting Cost"] = "Custo de Criação"
L["Crafting 'CRAFT NEXT' Button"] = "Botão 'CRIAR PRÓXIMO' em Criação"
L["Crafting Queue"] = "Fila de Criação"
L["Crafting Tooltips"] = "Tooltips de Criação"
L["Crafts"] = "Criações"
L["Crafts %d"] = "Criações %d"
L["CREATE MACRO"] = "CRIAR MACRO"
L["Create New Operation"] = "Criar Nova Operação"
L["CREATE NEW PROFILE"] = "CRIAR NOVO PERFIL"
L["Create Profession Group"] = "Criar Grupo de Profissão"
L["Created custom price source: |cff99ffff%s|r"] = "Fonte de preço personalizada criada: |cff99ffff%s|r"
L["Crystals"] = "Cristais"
L["Current Profiles"] = "Perfis Atuais"
L["CURRENT SEARCH"] = "BUSCA ATUAL"
L["CUSTOM POST"] = "POSTAR PERSONALIZADO"
L["Custom Price"] = "Preço Personalizado"
L["Custom Price Source"] = "Fonte de Preço Personalizado"
L["Custom Sources"] = "Fontes Personalizadas"
L["Database Sources"] = "Fontes da Base de Dados"
L["Default Craft Value Method:"] = "Método de Valor de Criação Padrão:"
L["Default Material Cost Method:"] = "Método de Valor de Material Padrão:"
L["Default Price"] = "Preço Padrão"
L["Default Price Configuration"] = "Configuração de Preço Padrão"
L["Define what priority Gathering gives certain sources."] = "Defina qual a prioridade de Coleta dá à certas fontes."
L["Delete Profile Confirmation"] = "Confirmação de Exclusão de Perfil"
L["Delete this record?"] = "Apagar este registro?"
L["Deposit"] = "Depósito"
L["Deposit Cost"] = "Custo de Depósito"
L["Deposit Price"] = "Preço de Depósito"
L["DEPOSIT REAGENTS"] = "DEPOSITAR REAGENTES"
L["Deselect All Groups"] = "Desselecionar Todos os Grupos"
L["Deselect All Items"] = "Desselecionar Todos os Itens"
L["Destroy Next"] = "Destruir Próximo"
L["Destroy Value"] = "Valor de Destruição"
L["Destroy Value Source"] = "Fonte do Valor de Destruição"
L["Destroying"] = "Destruição"
L["Destroying 'DESTROY NEXT' Button"] = "Botão 'DESTRUIR PRÓXIMO' em Destruição"
L["Destroying Tooltips"] = "Tooltips de Destruição"
L["Destroying..."] = "Destruindo..."
L["Details"] = "Detalhes"
L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Não cancelou %s porque seu limite de cancelar para repostar (%s) é invalido. Confira suas configurações."
L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Não cancelou %s porque preço máximo (%s) é inválido. Confira suas configurações."
L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Não cancelou %s porque seu preço máximo (%s) é menor que seu preço mínimo (%s). Confira suas configurações."
L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Não cancelou %s porque seu preço mínimo (%s) é inválido. Confira suas configurações."
L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Não cancelou %s porque seu preço normal (%s) é inválido. Confira suas configurações."
L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Não cancelou %s porque seu preço normal (%s) é menor que seu preço mínimo (%s). Confira suas configurações."
L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Não cancelou %s porque seu corte de preço (%s) é inválido. Confira suas configurações."
L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Não postou %s porque a Blizzard não dispôs toda a informação necessária para isso. Tente novamente depois."
L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Não postou %s porque o dono do leilão mais baixo (%s) está tanto na lista negra quanto na lista de permissão, o que não é permitido. Ajuste suas configurações para corrigir o problema."
L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Não postou %s porque um de seus alts (%s) está na lista negra, o que não é permitido. Remova este personagem de sua lista negra."
L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Não postou %s porque o seu preço máximo (%s) é inválido. Confira suas configurações."
L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Não postou %s porque o seu preço máximo (%s) é menor que seu preço mínimo (%s). Confira suas configurações."
L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Não postou %s porque o seu preço mínimo (%s) é inválido. Confira suas configurações."
L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Não postou %s porque o seu preço normal (%s) é inválido. Confira suas configurações."
L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Não postou %s porque o seu preço normal (%s) é  menor que seu preço mínimo (%s). Confira suas configurações."
L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Não postou %s porque seu corte de preço (%s) é inválido. Confira suas configurações."
L["Disable invalid price warnings"] = "Desabilitar alertas de preço inválido"
L["Disenchant Search"] = "Busca para Desencantamento"
L["DISENCHANT SEARCH"] = "BUSCA PARA DESENCANTAMENTO"
L["Disenchant Search Options"] = "Opções da Busca para Desencantamento"
L["Disenchant Value"] = "Valor de Desencantamento"
L["Disenchanting Options"] = "Opções de Desencantamento"
L["Display auctioning values"] = "Exibir valores de postagem no leilão"
L["Display cancelled since last sale"] = "Exibir cancelamentos desde a última venda"
L["Display crafting cost"] = "Exibir custo de criação"
L["Display detailed destroy info"] = "Exibir informação detalhada de destruição"
L["Display disenchant value"] = "Exibir valor de desencantamento"
L["Display expired auctions"] = "Exibir leilões expirados"
L["Display group name"] = "Exibir nome do grupo"
L["Display historical price"] = "Exibir preço histórico"
L["Display market value"] = "Exibir valor de mercado"
L["Display mill value"] = "Exibir preço de trituração"
L["Display min buyout"] = "Exibir arremate mínimo"
L["Display Operation Names"] = "Exibir Nomes das Operações"
L["Display prospect value"] = "Exibir valores de prospecção"
L["Display purchase info"] = "Exibir informações de compra"
L["Display region historical price"] = "Exibir preço histórico da região"
L["Display region market value avg"] = "Exibir preço médio de mercado da região"
L["Display region min buyout avg"] = "Exibir média de arremate mínimo da região"
L["Display region sale avg"] = "Exibir média de vendas na região"
L["Display region sale rate"] = "Exibir taxa de venda na região"
L["Display region sold per day"] = "Exibir número de vendas diárias na região"
L["Display sale info"] = "Exibir informações de venda"
L["Display sale rate"] = "Exibir taxa de venda"
L["Display shopping max price"] = "Exibir preço máximo de compra"
L["Display total money recieved in chat?"] = "Exibir o valor total de dinheiro recebido no chat?"
L["Display transform value"] = "Exibir valor de transformação"
L["Display vendor buy price"] = "Exibir valor de compra no comerciante"
L["Display vendor sell price"] = "Exibir valor de venda no comerciante"
L["Doing so will also remove any sub-groups attached to this group."] = "Fazer isso também removerá qualquer subgrupo ligado à este grupo."
L["Done Canceling"] = "Cancelamento Finalizado"
L["Done Posting"] = "Postagem Finalizada"
L["Done rebuilding item cache."] = "Reconstrução de cache de itens concluída."
L["Done Scanning"] = "Escaneamento Finalizado"
L["Don't post after this many expires:"] = "Não postar após esta quantidade de expirações:"
L["Don't Post Items"] = "Não Postar Itens"
L["Don't prompt to record trades"] = "Não abrir janela para armazenar trocas"
L["DOWN"] = "ABAIXO"
L["Drag in Additional Items (%d/%d Items)"] = "Arrastar Itens Adicionais (%d/%d Itens)"
L["Drag Item(s) Into Box"] = "Arraste Item(ns) para Dentro da Caixa"
L["Duplicate"] = "Duplicar"
L["Duplicate Profile Confirmation"] = "Confirmação de Duplicação de Perfil"
L["Dust"] = "Pó"
L["Elevate your gold-making!"] = "Eleve seus Ganhos de Ouro!"
L["Embed TSM tooltips"] = "Anexar Tooltips do TSM"
L["EMPTY BAGS"] = "ESVAZIAR BOLSAS"
L["Empty parentheses are not allowed"] = "Parênteses vazios não são permitidos"
L["Empty price string."] = "Preço vazio"
L["Enable automatic stack combination"] = "Habilitar combinação automática de lotes"
L["Enable buying?"] = "Habilitar compra?"
L["Enable inbox chat messages"] = "Habilitar mensagens da caixa de entrada no chat"
L["Enable restock?"] = "Habilitar reestoque?"
L["Enable selling?"] = "Habilitar venda?"
L["Enable sending chat messages"] = "Habilitar mensagens de envio no chat"
L["Enable TSM Tooltips"] = "Habilitar Tooltips do TSM"
L["Enable tweet enhancement"] = "Habilitar melhoria de tweet"
L["Enchant Vellum"] = "Encantar Velino"
L["Ensure both characters are online and try again."] = "Certifique-se que ambos os personagens estejam online e tente novamente."
L["Enter a name for the new profile"] = "Defina um nome para o novo perfil"
L["Enter Filter"] = "Digite o Filtro"
L["Enter Keyword"] = "Digite a Palavra-chave"
L["Enter name of logged-in character from other account"] = "Digite o nome de um personagem logado de outra conta"
L["Enter player name"] = "Digite o nome do jogador"
L["Essences"] = "Essências"
L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Estabelecendo conexão com %s. Certifique-se de ter inserido o nome deste personagem na outra conta."
L["Estimated Cost:"] = "Custo Estimado:"
L["Estimated deliver time"] = "Tempo estimado de entrega"
L["Estimated Profit:"] = "Lucro Estimado:"
L["Exact Match Only?"] = "Apenas Correspondência Exata?"
L["Exclude crafts with cooldowns"] = "Excluir criações com recargas"
L["Expand All Groups"] = "Expandir Todos os Grupos"
L["Expenses"] = "Gastos"
L["EXPENSES"] = "GASTOS"
L["Expirations"] = "Expirações"
L["Expired"] = "Expirado"
L["Expired Auctions"] = "Leilões Expirados"
L["Expired Since Last Sale"] = "Expirados Desde a Última Venda"
L["Expires"] = "Expirados"
L["EXPIRES"] = "EXPIRADOS"
L["Expires Since Last Sale"] = "Expirados Desde a Última Venda"
L["Expiring Mails"] = "Cartas Expirando"
L["Exploration"] = "Exploração"
L["Export"] = "Exportar"
L["Export List"] = "Exportar Lista"
L["Failed Auctions"] = "Leilões Retornados"
L["Failed Since Last Sale (Expired/Cancelled)"] = "Leilões Retornados Desde a Última Venda (Expirado/Cancelado)"
L["Failed to bid on auction of %s (x%s) for %s."] = "Falha ao dar lance no leilão de %s (x%s) por %s."
L["Failed to bid on auction of %s."] = "Falha ao dar lance no leilão de %s."
L["Failed to buy auction of %s (x%s) for %s."] = "Falha ao comprar o leilão de %s (x%s) por %s."
L["Failed to buy auction of %s."] = "Falha ao arrematar o leilão de %s."
L["Failed to find auction for %s, so removing it from the results."] = "Falha ao encontrar o leilão de %s, removendo dos resultados."
L["Failed to post %sx%d as the item no longer exists in your bags."] = "Falha ao postar %sx%d pois o item não existe mais nas suas bolsas."
L["Failed to send profile."] = "Falha ao enviar perfil."
L["Failed to send profile. Ensure both characters are online and try again."] = "Falha ao enviar perfil. Certifique-se que ambos os personagens estejam online e tente novamente."
L["Favorite Scans"] = "Escaneamentos Favoritos"
L["Favorite Searches"] = "Buscas Favoritas"
L["Filter Auctions by Duration"] = "Filtrar Leilões por Duração"
L["Filter Auctions by Keyword"] = "Filtrar Leilões por Palavra-chave"
L["Filter by Keyword"] = "Filtrar por Palavra-chave"
L["FILTER BY KEYWORD"] = "FILTRAR POR PALAVRA-CHAVE"
L["Filter group item lists based on the following price source"] = "Filtrar as listas de itens agrupados baseado na seguinte fonte de preços"
L["Filter Items"] = "Filtrar Itens"
L["Filter Shopping"] = "Filtrar Compra"
L["Finding Selected Auction"] = "Encontrando o Leilão Selecionado"
L["Fishing Reel In"] = "Puxão do Molinete de Pesca"
L["Forget Character"] = "Esquecer Personagem"
L["Found auction sound"] = "Som de leilão encontrado"
L["Friends"] = "Amigos"
L["From"] = "De"
L["Full"] = "Completo"
L["Garrison"] = "Guarnição"
L["Gathering"] = "Coleta"
L["Gathering Search"] = "Busca para Coleta"
L["General Options"] = "Opções Gerais"
L["Get from Bank"] = "Pegar do Banco"
L["Get from Guild Bank"] = "Pegar do Banco de Guilda"
L["Global Operation Confirmation"] = "Confirmação de Operação Global"
L["Gold"] = "Ouro"
L["Gold Earned:"] = "Ouro Ganho:"
L["GOLD ON HAND"] = "OURO EM MÃOS"
L["Gold Spent:"] = "Ouro Gasto:"
L["GREAT DEALS SEARCH"] = "BUSCA DE PECHINCHAS"
L["Group already exists."] = "Grupo já existe."
L["Group Management"] = "Gerenciamento de Grupo"
L["Group Operations"] = "Operações do Grupo"
L["Group Settings"] = "Configurações do Grupo"
L["Grouped Items"] = "Itens Agrupados"
L["Groups"] = "Grupos"
L["Guild"] = "Guilda"
L["Guild Bank"] = "Banco de Guilda"
L["GVault"] = "Cofre da Guilda"
L["Have"] = "Possui"
L["Have Materials"] = "Possui Materiais"
L["Have Skill Up"] = "Aumenta Perícia"
L["Hide auctions with bids"] = "Ocultar leilões com lances"
L["Hide Description"] = "Ocultar Descrição"
L["Hide minimap icon"] = "Ocultar ícone no mini-mapa"
L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Ocultando a UI do Módulo de Armazenamento do TSM. Digite '/tsm bankui' para reabri-la."
L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Ocultando a UI da Lista de Tarefas do TSM. Digite '/tsm tasklist' para reabri-la."
L["High Bidder"] = "Lance mais Alto"
L["Historical Price"] = "Preço Histórico"
L["Hold ALT to repair from the guild bank."] = "Segure ALT para reparar usando o banco de guilda."
L["Hold shift to move the items to the parent group instead of removing them."] = "Segure shift para mover os itens para o grupo pai ao invés de removê-los."
L["Hr"] = "H"
L["Hrs"] = "Hs"
L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "Acabei de comprar [%s]x%d por %s! %s #TSM4 #warcraft"
L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "Acabei de vender [%s] por %s! %s #TSM4 #warcraft"
L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "Se você não quer cortar os preços de outro jogador, você pode adicioná-lo à sua lista de permissões e o TSM não irá cortar seus preços. Note que se alguém de sua lista de permissões igualar seu arremate porém com um valor de lance menor, o TSM ainda considerará que eles estão cortando seu preço."
L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Se você tiver múltiplos perfis configurados com operações, habilitar isto fará com que todas as operações, exceto as do perfil atual, sejam irreversivelmente perdidas. Você tem certeza que quer continuar?"
L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "Se você tem a Integração do WoW com o Twitter habilitada, o TSM irá adicionar um link de compartilhamento para suas mensagens melhoradas de venda / compra, assim como substituir as URLs com um link do TSM."
L["Ignore Auctions Below Min"] = "Ignorar Leilões Abaixo do Mínimo"
L["Ignore auctions by duration?"] = "Ignorar Leilões por duração?"
L["Ignore Characters"] = "Ignorar Personagens"
L["Ignore Guilds"] = "Ignorar Guildas"
L["Ignore item variations?"] = "Ignorar variação de itens?"
L["Ignore operation on characters:"] = "Ignorar operação nos personagens:"
L["Ignore operation on faction-realms:"] = "Ignorar operação nas facções - reinos:"
L["Ignored Cooldowns"] = "Recargas Ignoradas"
L["Ignored Items"] = "Itens Ignorados"
L["ilvl"] = "nvli"
L["Import"] = "Importar"
L["IMPORT"] = "IMPORTAR"
L["Import %d Items and %s Operations?"] = "Importar %d Itens e %s Operações?"
L["Import Groups & Operations"] = "Importar Grupos & Operações"
L["Imported Items"] = "Itens Importados"
L["Inbox Settings"] = "Configurações da Caixa de Entrada"
L["Include Attached Operations"] = "Incluir Operações Anexadas"
L["Include operations?"] = "Incluir operações?"
L["Include soulbound items"] = "Incluir itens vinculados"
L["Information"] = "Informação"
L["Invalid custom price entered."] = "O preço personalizado inserido é inválido."
L["Invalid custom price source for %s. %s"] = "Fonte de preço personalizado para %s é inválida. %s"
L["Invalid custom price."] = "Preço personalizado inválido."
L["Invalid function."] = "Função inválida."
L["Invalid gold value."] = "Valor em ouro inválido."
L["Invalid group name."] = "Nome de grupo inválido."
L["Invalid import string."] = "Código de importação inválido."
L["Invalid item link."] = "Link inválido de item."
L["Invalid operation name."] = "Nome de operação inválido."
L["Invalid operator at end of custom price."] = "Operador inválido no final do preço personalizado."
L["Invalid parameter to price source."] = "Parâmetro inválido para fonte de preço;"
L["Invalid player name."] = "Nome de jogador inválido."
L["Invalid price source in convert."] = "Fonte de preço de conversão inválido."
L["Invalid price source."] = "Fonte de preço inválida."
L["Invalid search filter"] = "Filtro de busca inválido"
L["Invalid seller data returned by server."] = "Informação de vendedor inválida retornada pelo servidor."
L["Invalid word: '%s'"] = "Palavra inválida: '%s'"
L["Inventory"] = "Inventário"
L["Inventory / Gold Graph"] = "Inventário / Gráfico de Ouro"
L["Inventory / Mailing"] = "Inventário / Correio"
L["Inventory Options"] = "Opções de Inventário"
L["Inventory Tooltip Format"] = "Formato da Tooltip de Inventário"
L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "Aparentemente você copiou manualmente as variáveis salvas entre contas, o que pode fazer com que a sincronização automática do TSM não funcione. Você precisará desfazer isto, e/ou deletar as variáveis salvas do TradeSkillMaster em ambas as contas (com o WoW fechado) para corrigir isto."
L["Item"] = "Item"
L["ITEM CLASS"] = "CATEGORIA DO ITEM"
L["Item Level"] = "Nível de Item"
L["ITEM LEVEL RANGE"] = "FAIXA DE NÍVEL DE ITEM"
L["Item links may only be used as parameters to price sources."] = "Os links de itens só podem ser usados como parâmetros para fontes de preço."
L["Item Name"] = "Nome do Item"
L["Item Quality"] = "Qualidade do Item"
L["ITEM SEARCH"] = "BUSCA DE ITEM"
L["ITEM SELECTION"] = "SELEÇÃO DE ITEM"
L["ITEM SUBCLASS"] = "SUBCATEGORIA DO ITEM"
L["Item Value"] = "Valor do Item"
L["Item/Group is invalid (see chat)."] = "O Item/Grupo é inválido (veja o chat)."
L["ITEMS"] = "ITENS"
L["Items"] = "Itens"
L["Items in Bags"] = "Itens nas Bolsas"
L["Keep in bags quantity:"] = "Quantidade a manter nas bolsas:"
L["Keep in bank quantity:"] = "Quantidade a manter no banco:"
L["Keep posted:"] = "Quantidade a manter postado:"
L["Keep quantity:"] = "Quantidade a manter:"
L["Keep this amount in bags:"] = "Manter esta quantidade nas bolsas:"
L["Keep this amount:"] = "Manter esta quantidade:"
L["Keeping %d."] = "Mantendo %d."
L["Keeping undercut auctions posted."] = "Manter leilões com preços cortados postados."
L["Last 14 Days"] = "Últimos 14 Dias"
L["Last 3 Days"] = "Últimos 3 Dias"
L["Last 30 Days"] = "Últimos 30 Dias"
L["LAST 30 DAYS"] = "ÚLTIMOS 20 DIAS"
L["Last 60 Days"] = "Últimos 60 Dias"
L["Last 7 Days"] = "Últimos 7 Dias"
L["LAST 7 DAYS"] = "ÚLTIMOS 7 DIAS"
L["Last Data Update:"] = "Última Atualização de Dados:"
L["Last Purchased"] = "Comprado pela Última Vez"
L["Last Sold"] = "Vendido pela Última Vez"
L["Level Up"] = "Subir de Nível"
L["LIMIT"] = "LIMITE"
L["Link to Another Operation"] = "Vincular à Outra Operação"
L["List"] = "Listar"
L["List materials in tooltip"] = "Listar materiais na tooltip"
L["Loading Mails..."] = "Carregando Mensagens..."
L["Loading..."] = "Carregando..."
L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Parece que o TradeSkillMaster encontrou um erro. Por favor, ajude o autor a corrigir este erro seguindo as instruções exibidas."
L["Loop detected in the following custom price:"] = "Repetição detectada no seguinte preço personalizado:"
L["Lowest auction by whitelisted player."] = "Leilão mais baixo pertence a jogador da lista de permissões."
L["Macro created and scroll wheel bound!"] = "Macro criada e atribuída ao botão de rolagem!"
L["Macro Setup"] = "Configuração de Macro"
L["Mail"] = "Correio"
L["Mail Disenchantables"] = "Enviar Desencantáveis"
L["Mail Disenchantables Max Quality"] = "Qualidade Máxima para Envio de Desencantáveis"
L["MAIL SELECTED GROUPS"] = "ENVIAR GRUPOS SELECIONADOS"
L["Mail to %s"] = "Envio para %s"
L["Mailing"] = "Correio"
L["Mailing all to %s."] = "Enviando tudo para %s."
L["Mailing Options"] = "Operações de Correio"
L["Mailing up to %d to %s."] = "Enviando até %d para %s."
L["Main Settings"] = "Configurações Principais"
L["Make Cash On Delivery?"] = "Enviar Carta a Cobrar?"
L["Management Options"] = "Opções de Gerenciamento"
L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Várias tarefas constantemente usadas no TSM podem ser adicionadas à uma macro e vinculadas ao botão de rolagem de seu mouse. Use as opções abaixo para ajustar esta macro e vinculá-la."
L["Map Ping"] = "Mapeamento"
L["Market Value"] = "Valor de Mercado"
L["Market Value Price Source"] = "Fonte de Preço de Valor de Mercado"
L["Market Value Source"] = "Fonte de Valor de Mercado"
L["Mat Cost"] = "Custo do Material"
L["Mat Price"] = "Preço do Material"
L["Match stack size?"] = "Igualar tamanho de lote?"
L["Match whitelisted players"] = "Igualar jogadores da lista de permissões"
L["Material Name"] = "Nome do Material"
L["Materials"] = "Materiais"
L["Materials to Gather"] = "Materiais a Coletar"
L["MAX"] = "MÁX"
L["Max Buy Price"] = "Preço Máximo de Compra"
L["MAX EXPIRES TO BANK"] = "LIMITE DE EXPIRADOS PARA O BANCO"
L["Max Sell Price"] = "Preço Máximo de Venda"
L["Max Shopping Price"] = "Preço Máximo de Compra"
L["Maximum amount already posted."] = "Quantidade máxima já postada."
L["Maximum Auction Price (Per Item)"] = "Preço Máximo por Leilão (Por Item)"
L["Maximum Destroy Value (Enter '0c' to disable)"] = "Valor Máximo para Destruição (Digite '0c' para desabilitar)"
L["Maximum disenchant level:"] = "Nível máximo para desencantamento:"
L["Maximum Disenchant Quality"] = "Qualidade Máxima para Desencantamento"
L["Maximum disenchant search percentage:"] = "Porcentagem máxima para busca de desencantamento:"
L["Maximum Market Value (Enter '0c' to disable)"] = "Valor de Mercado Máximo (Digite '0c' para desabilitar)"
L["MAXIMUM QUANTITY TO BUY:"] = "QUANTIDADE MÁXIMA A COMPRAR:"
L["Maximum quantity:"] = "Quantidade máxima:"
L["Maximum restock quantity:"] = "Quantidade máxima de restoque:"
L["Mill Value"] = "Valor de Trituração"
L["Min"] = "Mínimo"
L["Min Buy Price"] = "Preço Mínimo de Compra"
L["Min Buyout"] = "Arremate Mínimo"
L["Min Sell Price"] = "Preço Mínimo de Venda"
L["Min/Normal/Max Prices"] = "Preços Mínimo/Normal/Máximo"
L["Minimum Days Old"] = "Mínimo de Dias de Existência"
L["Minimum disenchant level:"] = "Nível mínimo para desencantamento:"
L["Minimum expires:"] = "Mínimo de expirados:"
L["Minimum profit:"] = "Lucro mínimo:"
L["MINIMUM RARITY"] = "RARIDADE MÍNIMA"
L["Minimum restock quantity:"] = "Quantidade mínima para restoque:"
L["Misplaced comma"] = "Vírgula mal colocada"
L["Missing Materials"] = "Faltam Materiais"
L["Missing operator between sets of parenthesis"] = "Falta o operador entre os conjuntos de parênteses"
L["Modifiers:"] = "Modificadores:"
L["Money Frame Open"] = "Abre Quadro de Dinheiro"
L["Money Transfer"] = "Transferência de Dinheiro"
L["Most Profitable Item:"] = "Item Mais Lucrativo:"
L["MOVE"] = "MOVER"
L["Move already grouped items?"] = "Mover itens já agrupados?"
L["Move Quantity Settings"] = "Configurações de Quantidade a Mover"
L["MOVE TO BAGS"] = "MOVER PARA BOLSAS"
L["MOVE TO BANK"] = "MOVER PARA BANCO"
L["MOVING"] = "MOVENDO"
L["Moving"] = "Movendo"
L["Multiple Items"] = "Múltiplos Itens"
L["My Auctions"] = "Meus Leilões"
L["My Auctions 'CANCEL' Button"] = "Botão 'CANCELAR' em Meus Leilões"
L["Neat Stacks only?"] = "Apenas Lotes Ajustados?"
L["NEED MATS"] = "PRECISA DE MATERIAIS"
L["New Group"] = "Novo grupo"
L["New Operation"] = "Nova Operação"
L["NEWS AND INFORMATION"] = "NOVIDADES E INFORMAÇÃO"
L["No Attachments"] = "Nenhum Anexo"
L["No Crafts"] = "Nenhuma Criação"
L["No Data"] = "Nenhum Dado"
L["No group selected"] = "Nenhum grupo selecionado"
L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "Nenhum item especificado. Uso /tsm restock_help [LINK_DO_ITEM]"
L["NO ITEMS"] = "SEM ITENS"
L["No Materials to Gather"] = "Nenhum Material a Coletar"
L["No Operation Selected"] = "Nenhuma Operação Selecionada"
L["No posting."] = "Não postará."
L["No Profession Opened"] = "Nenhuma Profissão Aberta"
L["No Profession Selected"] = "Nenhuma Profissão Selecionada"
L["No profile specified. Possible profiles: '%s'"] = "Nenhum perfil especificado. Possíveis perfis: '%s'"
L["No recent AuctionDB scan data found."] = "Nenhum dado recente de escaneamento do AuctionDB encontrado."
L["No Sound"] = "Sem Som"
L["None"] = "Nenhum"
L["None (Always Show)"] = "Nenhum (Exibir Sempre)"
L["None Selected"] = "Nada Selecionado"
L["NONGROUP TO BANK"] = "NÃO AGRUPADOS PARA BANCO"
L["Normal"] = "Normal"
L["Not canceling auction at reset price."] = "Não cancelando leilão ao preço de reset."
L["Not canceling auction below min price."] = "Não cancelando leilão abaixo do preço mínimo."
L["Not canceling."] = "Não cancelando."
L["Not Connected"] = "Não Conectado"
L["Not enough items in bags."] = "Não há itens suficientes nas bolsas."
L["NOT OPEN"] = "NÃO ABERTO"
L["Not Scanned"] = "Não escaneado"
L["Nothing to move."] = "Nada a mover."
L["NPC"] = "PNJ"
L["Number Owned"] = "Quantidade à Disposição"
L["of"] = "de"
L["Offline"] = "Desconectado"
L["On Cooldown"] = "Em Recarga"
L["Only show craftable"] = "Exibir apenas criáveis"
L["Only show items with disenchant value above custom price"] = "Apenas exibir itens com valor para desencantamento acima do preço personalizado"
L["OPEN"] = "ABRIR"
L["OPEN ALL MAIL"] = "ABRIR TODAS CARTAS"
L["Open Mail"] = "Abrir Carta"
L["Open Mail Complete Sound"] = "Som de Abertura de Cartas Completo"
L["Open Task List"] = "Abrir Lista de Tarefas"
L["Operation"] = "Operação"
L["Operations"] = "Operações"
L["Other Character"] = "Outro Personagem"
L["Other Settings"] = "Outras Configurações"
L["Other Shopping Searches"] = "Outras Opções de Compra"
L["Override default craft value method?"] = "Substituir o método de valor de criação padrão?"
L["Override parent operations"] = "Substituir operação pai"
L["Parent Items"] = "Itens Pai"
L["Past 7 Days"] = "Últimos 7 Dias"
L["Past Day"] = "Último Dia"
L["Past Month"] = "Mês Passado"
L["Past Year"] = "Ano Passado"
L["Paste string here"] = "Cole o código aqui"
L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Cole seu código de importação no campo abaixo e então clique em 'IMPORTAR'. Você por importar de uma lista de itens (separados por vírgula, por favor) a estruturas completas de grupo & operações."
L["Per Item"] = "Por Item"
L["Per Stack"] = "Por Lote"
L["Per Unit"] = "Por Unidade"
L["Player Gold"] = "Ouro do Jogador"
L["Player Invite Accept"] = "Convite de Jogador Aceito"
L["Please select a group to export"] = "Por favor, selecione um grupo para exportar"
L["POST"] = "POSTAR"
L["Post at Maximum Price"] = "Postar pelo Valor Máximo"
L["Post at Minimum Price"] = "Postar pelo Valor Mínimo"
L["Post at Normal Price"] = "Postar pelo Preço Normal"
L["POST CAP TO BAGS"] = "LIMITE DE POSTAGEM PARA AS BAGS"
L["Post Scan"] = "Escanear para Venda"
L["POST SELECTED"] = "POSTAR SELECIONADO"
L["POSTAGE"] = "POSTAGEM"
L["Postage"] = "Postagem"
L["Posted at whitelisted player's price."] = "Postado ao preço de jogador da lista de permitidos."
L["Posted Auctions %s:"] = "Leilões Postados %s:"
L["Posting"] = "Postando"
L["Posting %d / %d"] = "Postando %d / %d"
L["Posting %d stack(s) of %d for %d hours."] = "Postando %d lote(s) de %d por %d horas."
L["Posting at normal price."] = "Postando no preço normal."
L["Posting at whitelisted player's price."] = "Postando no preço do jogador da lista de permissões."
L["Posting at your current price."] = "Postando no seu preço atual."
L["Posting disabled."] = "Postagem desabilitada."
L["Posting Settings"] = "Configurações de Postagem"
L["Posts"] = "Postagens"
L["Potential"] = "Potencial"
L["Price Per Item"] = "Preço Por Item"
L["Price Settings"] = "Configurações de Preço"
L["PRICE SOURCE"] = "FONTE DE PREÇO"
L["Price source with name '%s' already exists."] = "A fonte de preço com o nome '%s' já existe."
L["Price Variables"] = "Variáveis de Preço"
L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "As Variáveis de Preço permitem que você crie mais preços personalizados para uso no addon. Você poderá usar estas novas variáveis da mesma forma que você pode utilizar fontes de preço padrão como 'vendorsell' e 'vendorbuy',"
L["PROFESSION"] = "PROFISSÃO"
L["Profession Filters"] = "Filtros de Profissão"
L["Profession Info"] = "Info de Profissão"
L["Profession loading..."] = "Carregando profissão..."
L["Professions Used In"] = "Usado nas Profissões"
L["Profile changed to '%s'."] = "Perfil alterado para '%s'."
L["Profiles"] = "Perfis"
L["PROFIT"] = "LUCRO"
L["Profit"] = "Lucro"
L["Prospect Value"] = "Valor de Prospecção"
L["PURCHASE DATA"] = "DADOS DE COMPRA"
L["Purchased (Min/Avg/Max Price)"] = "Comprado (Preço Mínimo/Médio/Máximo)"
L["Purchased (Total Price)"] = "Comprado (Preço Total)"
L["Purchases"] = "Compras"
L["Purchasing Auction"] = "Comprando Leilão"
L["Qty"] = "Qtde"
L["Quantity Bought:"] = "Quantidade Comprada:"
L["Quantity Sold:"] = "Quantidade Vendida:"
L["Quantity to move:"] = "Quantidade a mover:"
L["Quest Added"] = "Missão Recebida"
L["Quest Completed"] = "Missão Concluída."
L["Quest Objectives Complete"] = "Objetivos da Missão Completos"
L["QUEUE"] = "FILA"
L["Quick Sell Options"] = "Opções de Venda Rápida"
L["Quickly mail all excess disenchantable items to a character"] = "Envie rapidamente todos os itens desencantáveis em excesso para um personagem"
L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Envie rapidamente todo o ouro em excesso (limitado à uma certa quantidade) para um personagem"
L["Raid Warning"] = "Aviso de Raide"
L["Read More"] = "Ler Mais"
L["Ready Check"] = "Todos Prontos?"
L["Ready to Cancel"] = "Pronto para Cancelar"
L["Realm Data Tooltips"] = "Tooltips de Dados do Reino"
L["Recent Scans"] = "Escaneamentos Recentes"
L["Recent Searches"] = "Buscas Recentes"
L["Recently Mailed"] = "Enviado Recentemente"
L["RECIPIENT"] = "PARA"
L["Region Avg Daily Sold"] = "Média de Vendidos Diariamente na Região"
L["Region Data Tooltips"] = "Tooltips de Dados da Região"
L["Region Historical Price"] = "Preço Histórico da Região"
L["Region Market Value Avg"] = "Média de Valor de Mercado da Região"
L["Region Min Buyout Avg"] = "Média Regional de Arremate Mínimo"
L["Region Sale Avg"] = "Média de Valor de Venda na Região"
L["Region Sale Rate"] = "Taxa de Vendas na Região"
L["Reload"] = "Recarregar"
L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVER %d |4ITEM:ITENS;"
L["Removed a total of %s old records."] = "Um total de %s  dados antigos foram removidos."
L["Rename"] = "Renomear"
L["Rename Profile"] = "Renomear Perfil"
L["REPAIR"] = "REPARAR"
L["Repair Bill"] = "Conta de Reparo"
L["Replace duplicate operations?"] = "Substituir operações duplicadas?"
L["REPLY"] = "RESPONDER"
L["REPORT SPAM"] = "REPORTAR SPAM"
L["Repost Higher Threshold"] = "Limite de Repostagem mais Alta"
L["Required Level"] = "Nível Necessário"
L["REQUIRED LEVEL RANGE"] = "LIMITE DE NÍVEL NECESSÁRIO"
L["Requires TSM Desktop Application"] = "Requer o App para Desktop do TSM"
L["Resale"] = "Revenda"
L["RESCAN"] = "REESCANEAR"
L["RESET"] = "RESETAR"
L["Reset All"] = "Resetar Tudo"
L["Reset Filters"] = "Resetar Filtros"
L["Reset Profile Confirmation"] = "Confirmação do Reset de Perfil"
L["RESTART"] = "REDEFINIR"
L["Restart Delay (minutes)"] = "Atraso de Reinício (minutos)"
L["RESTOCK BAGS"] = "RESTOCAR BOLSAS"
L["Restock help for %s:"] = "Ajuda de restoque para %s:"
L["Restock Quantity Settings"] = "Configurações da Quantidade de Restoque"
L["Restock quantity:"] = "Quantidade para Restoque:"
L["RESTOCK SELECTED GROUPS"] = "RESTOCAR GRUPOS SELECIONADOS"
L["Restock Settings"] = "Configurações de Restoque"
L["Restock target to max quantity?"] = "Restocar alvo para quantidade máxima?"
L["Restocking to %d."] = "Restocando para %d."
L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocando para um máximo de %d (mínimo de %d) com um lucro mínimo."
L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocando para um máximo de %d (mínimo de %d) sem lucro mínimo."
L["RESTORE BAGS"] = "RESTAURAR BOLSAS"
L["Resume Scan"] = "Continuar Escaneamento"
L["Retrying %d auction(s) which failed."] = "Tentando novamente %d leilão(ões) que falharam."
L["Revenue"] = "Receita"
L["Round normal price"] = "Arrendondar preço normal"
L["RUN ADVANCED ITEM SEARCH"] = "EXECUTAR BUSCA AVANÇADA DE ITEM"
L["Run Bid Sniper"] = "Executar Sniper de Lance"
L["Run Buyout Sniper"] = "Executar Sniper de Arremate"
L["RUN CANCEL SCAN"] = "ESCANEAR P/ CANCELAMENTO"
L["RUN POST SCAN"] = "ESCANEAR P/ VENDA"
L["RUN SHOPPING SCAN"] = "ESCANEAR PARA COMPRA"
L["Running Sniper Scan"] = "Executando Escaneamento Sniper"
L["Sale"] = "Venda"
L["SALE DATA"] = "DADOS DE VENDA"
L["Sale Price"] = "Preço de Venda"
L["Sale Rate"] = "Taxa de Venda"
L["Sales"] = "Vendas"
L["SALES"] = "VENDAS"
L["Sales Summary"] = "Resumo das Vendas"
L["SCAN ALL"] = "ESCANEAR TUDO"
L["Scan Complete Sound"] = "Som de Escaneamento Completo"
L["Scan Paused"] = "Escaneamento Pausado"
L["SCANNING"] = "ESCANEANDO"
L["Scanning %d / %d (Page %d / %d)"] = "Escaneando %d / %d (Página %d / %d)"
L["Scroll wheel direction:"] = "Direção da roda do mouse:"
L["Search"] = "Buscar"
L["Search Bags"] = "Buscar nas Bolsas"
L["Search Groups"] = "Buscar Grupos"
L["Search Inbox"] = "Buscar Caixa de Entrada"
L["Search Operations"] = "Buscar Operações"
L["Search Patterns"] = "Buscar Padrões"
L["Search Usable Items Only?"] = "Buscar Apenas Itens Usáveis?"
L["Search Vendor"] = "Buscar no Comerciante"
L["Select a Source"] = "Selecione uma Fonte"
L["Select Action"] = "Selecione a Ação"
L["Select All Groups"] = "Selecionar todos os grupos"
L["Select All Items"] = "Selecionar Todos os Itens"
L["Select Auction to Cancel"] = "Selecione o Leilão a Cancelar"
L["Select crafter"] = "Selecione o personagem"
L["Select custom price sources to include in item tooltips"] = "Selecione uma fonte de preço personalizado para incluir nas tooltips de itens"
L["Select Duration"] = "Selecione a Duração"
L["Select Items to Add"] = "Selecione Itens a Adicionar"
L["Select Items to Remove"] = "Selecione Itens a Remover"
L["Select Operation"] = "Selecionar Operações"
L["Select professions"] = "Selecionar profissões"
L["Select which accounting information to display in item tooltips."] = "Selecione quais informações de contabilidade você quer exibir nas tooltips de um item."
L["Select which auctioning information to display in item tooltips."] = "Selecione quais informações de leilão você quer exibir nas tooltips de um item."
L["Select which crafting information to display in item tooltips."] = "Selecione quais informações de criação você quer exibir nas tooltips de um item."
L["Select which destroying information to display in item tooltips."] = "Selecione quais informações de destruilçai você quer exibir nas tooltips de um item."
L["Select which shopping information to display in item tooltips."] = "Selecione quais informações de compras você quer exibir nas tooltips de um item."
L["Selected Groups"] = "Grupos Selecionados"
L["Selected Operations"] = "Operações Selecionadas"
L["Sell"] = "Venda"
L["SELL ALL"] = "VENDER TUDO"
L["SELL BOES"] = "VENDER NÃO VINCULADOS"
L["SELL GROUPS"] = "VENDER GRUPOS"
L["Sell Options"] = "Opções de Venda"
L["Sell soulbound items?"] = "Vender itens vinculados?"
L["Sell to Vendor"] = "Vender para Comerciante"
L["SELL TRASH"] = "VENDER LIXO"
L["Seller"] = "Vendedor"
L["Selling soulbound items."] = "Vendendo itens vinculados."
L["Send"] = "Enviar"
L["SEND DISENCHANTABLES"] = "ENVIAR DESENCANTÁVEIS"
L["Send Excess Gold to Banker"] = "Enviar Excesso de Ouro para Alt Banco"
L["SEND GOLD"] = "ENVIAR OURO"
L["Send grouped items individually"] = "Enviar itens agrupados individualmente"
L["SEND MAIL"] = "ENVIAR CARTA"
L["Send Money"] = "Enviar Dinheiro"
L["Send Profile"] = "Enviar Perfil"
L["SENDING"] = "ENVIANDO"
L["Sending %s individually to %s"] = "Enviando %s individualmente para %s"
L["Sending %s to %s"] = "Enviando %s para %s"
L["Sending %s to %s with a COD of %s"] = "Enviando %s para %s com uma CaC de %s"
L["Sending Settings"] = "Configurações de Envio"
L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Enviando seu perfil '%s' para %s. Por favor, mantenha ambos personagens conectados até isto ser completado. Isto levará aproximadamente: %s"
L["SENDING..."] = "ENVIANDO..."
L["Set auction duration to:"] = "Definir a duração do leilão para:"
L["Set bid as percentage of buyout:"] = "Definir lance como porcentagem do arremate:"
L["Set keep in bags quantity?"] = "Definir quantidade a manter nas bolsas?"
L["Set keep in bank quantity?"] = "Definir quantidade a manter no banco?"
L["Set Maximum Price:"] = "Definir Preço Máximo:"
L["Set maximum quantity?"] = "Definir quantidade máxima?"
L["Set Minimum Price:"] = "Definir Preço Mínimo:"
L["Set minimum profit?"] = "Definir lucro mínimo?"
L["Set move quantity?"] = "Definir quantidade a mover?"
L["Set Normal Price:"] = "Definir preço Normal:"
L["Set post cap to:"] = "Definir limite de postagem em:"
L["Set posted stack size to:"] = "Definir o tamanho do lote postado em:"
L["Set stack size for restock?"] = "Definir tamanho de lote para restoque?"
L["Set stack size?"] = "Definir tamanho de lote?"
L["Setup"] = "Configuração"
L["SETUP ACCOUNT SYNC"] = "AJUSTAR SINCRONIZAÇÃO DE CONTAS"
L["Shards"] = "Estilhaço"
L["Shopping"] = "Comprar"
L["Shopping 'BUYOUT' Button"] = "Botão 'ARREMATAR' em Comprar"
L["Shopping for auctions including those above the max price."] = "Comprando leilões, incluindo aqueles acima do preço máximo."
L["Shopping for auctions with a max price set."] = "Comprando leilões com um preço máximo definido."
L["Shopping for even stacks including those above the max price"] = "Comprando lotes ajustados, incluindo aqueles acima do preço"
L["Shopping for even stacks with a max price set."] = "Comprando lotes ajustados com um preço máximo definido."
L["Shopping Tooltips"] = "Tooltips de Compras"
L["SHORTFALL TO BAGS"] = "REPOSIÇÕES PARA BOLSAS"
L["Show auctions above max price?"] = "Exibir leilões acima do preço?"
L["Show confirmation alert if buyout is above the alert price"] = "Exibir confirmação de arremate se o preço está acima do preço de alerta"
L["Show Description"] = "Exibir Descrição"
L["Show Destroying frame automatically"] = "Exibir janela de Destruição automaticamente"
L["Show material cost"] = "Exibir custo de material"
L["Show on Modifier"] = "Exibir no Modificador"
L["Showing %d Mail"] = "Exibindo %d Carta"
L["Showing %d of %d Mail"] = "Exibindo %d de %d Carta"
L["Showing %d of %d Mails"] = "Exibindo %d de %d Cartas"
L["Showing all %d Mails"] = "Exibindo todas %d Cartas"
L["Simple"] = "Simples"
L["SKIP"] = "PULAR"
L["Skip Import confirmation?"] = "Pular confirmação de Importação?"
L["Skipped: No assigned operation"] = "Ignorado: Nenhuma operação atribuída"
L["Slash Commands:"] = "Comandos de barra:"
L["Sniper"] = "Sniper"
L["Sniper 'BUYOUT' Button"] = "Botão 'ARREMATAR' em Sniper"
L["Sniper Options"] = "Opções do Sniper"
L["Sniper Settings"] = "Configurações do Sniper"
L["Sniping items below a max price"] = "Executando Snipe em itens abaixo de um preço máximo"
L["Sold"] = "Vendido"
L["Sold %d of %s to %s for %s"] = "Vendeu %d de %s para %s por %s"
L["Sold %s worth of items."] = "Vendeu %s em itens."
L["Sold (Min/Avg/Max Price)"] = "Vendido (Preço Mínimo/Médio/Máximo)"
L["Sold (Total Price)"] = "Vendido (Preço Total)"
L["Sold [%s]x%d for %s to %s"] = "Vendeu [%s]x%d por %s para %s"
L["Sold Auctions %s:"] = "Leilões Vendidos %s:"
L["Source"] = "Fonte"
L["SOURCE %d"] = "FONTE %d"
L["SOURCES"] = "FONTES"
L["Sources"] = "Fontes"
L["Sources to include for restock:"] = "Fontes à incluir no restoque:"
L["Stack"] = "Lote"
L["Stack / Quantity"] = "Lote / Quantidade"
L["Stack size multiple:"] = "Múltiplo para tamanho do lote:"
L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Comece escaneamento sniper de 'Arremate' ou 'Lance' usando os botões acima."
L["Starting Scan..."] = "Começando escaneamento..."
L["STOP"] = "PARAR"
L["Store operations globally"] = "Armazenar operações globalmente"
L["Subject"] = "Assunto"
L["SUBJECT"] = "ASSUNTO"
L["Successfully sent your '%s' profile to %s!"] = "Perfil '%s' enviado com sucesso para %s!"
L["Switch to %s"] = "Mudar para %s"
L["Switch to WoW UI"] = "IU do WoW"
L["Sync Setup Error: The specified player on the other account is not currently online."] = "Erro de Configuração de Sincronização: o jogador especificado na outra conta não está atualmente online."
L["Sync Setup Error: This character is already part of a known account."] = "Erro de Configuração de Sincronização: Este personagem já é parte de uma conta conhecida."
L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Erro de configuração de sincronização: você inseriu o nome do personagem atual e não o personagem da outra conta."
L["Sync Status"] = "Status de Sincronização"
L["TAKE ALL"] = "PEGAR TUDO"
L["Take Attachments"] = "Pegar Anexos"
L["Target Character"] = "Personagem Alvo"
L["TARGET SHORTFALL TO BAGS"] = "REPOSIÇÕES PARA BOLSAS DE ALVOS"
L["Tasks Added to Task List"] = "Tarefas Adicionadas à Lista de Tarefas"
L["Text (%s)"] = "Texto (%s)"
L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "O filtro canlearn foi ignorado porque o addon CanIMogit não foi encontrado."
L["The 'Craft Value Method' (%s) did not return a value for this item."] = "O 'Método de Valor de Criação' (%s)  não retornou um valor para este item."
L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "A fonte de preços 'disenchant' foi substituída pela fonte de preço mais geral, 'destroy'. Por favor, atualize seus preços personalizados."
L["The min profit (%s) did not evalulate to a valid value for this item."] = "O lucro mínimo (%s) não avaliou um preço válido para este item."
L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "O nome só pode conter APENAS letras. Sem espaços, números ou caracteres especiais."
L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "A quantidade que será enfileirada (%d) é menor que a quantidade mínima de restoque (%d)."
L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "A operação aplicada à este item é inválida! O restoque mínimo de %d é maior que o restoque máximo de %d."
L["The player \"%s\" is already on your whitelist."] = "O jogador \"%s\" já está em sua lista de permissões."
L["The profit of this item (%s) is below the min profit (%s)."] = "O lucro deste item (%s) está abaixo do lucro mínimo (%s)."
L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "O nome do vendedor para o leilão de %s não foi recuperado pelo servidor. Pulando este item."
L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "O TradeSkillMaster_AppHelper está instalado, mas não está habilitado. O TSM o reabilitou e requer um recarregamento."
L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "O filtro 'unlearned' foi ignorado porque o addon CanIMogIt não foi encontrado."
L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "Existe um preço de criação e valor de item criado, mas o TSM não foi capaz de calcular um lucro. Isso não deve acontecer!"
L["There is no Crafting operation applied to this item's TSM group (%s)."] = "Não há uma operação de Criação aplicada ao grupo TSM deste item (%s)."
L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Este não é um nome de perfil válido. Os nomes de perfil devem ter pelo menos um caractere e não podem conter caracteres '@'."
L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "Este item não possui um custo de criação. Certifique-se de que todos os materiais possuam valor de material."
L["This item is not in a TSM group."] = "Este item não está em um grupo do TSM."
L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "Este item será adicionado à fila quando você restocar seu grupo. Caso isto não aconteça, faça um post nos fóruns do TSM com uma screenshot da tooltip do item, configurações de operação e suas configurações gerais de Criação."
L["This looks like an exported operation and not a custom price."] = "Isto parece uma operação exportada e não um preço personalizado."
L["This will copy the settings from '%s' into your currently-active one."] = "Isto copiará as configurações de '%s\" dentro do seu ativo atualmente."
L["This will permanently delete the '%s' profile."] = "Isto excluirá permanentemente o perfil '%s'."
L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "Isto irá redefinir todos os grupos e operações (se estas não estiverem armazenadas globalmente), e limpá-las deste perfil."
L["Time"] = "Quando"
L["Time Format"] = "Formato de Hora"
L["Time Frame"] = "Período"
L["TIME FRAME"] = "PERÍODO"
L["TINKER"] = "INSTALAR"
L["Tooltip Price Format"] = "Formato de Preço da Tooltip"
L["Tooltip Settings"] = "Configurações de Tooltip"
L["Top Buyers:"] = "Top Compradores:"
L["Top Item:"] = "Top Item:"
L["Top Sellers:"] = "Top Vendedores:"
L["Total"] = "Total"
L["Total Gold"] = "Ouro Total"
L["Total Gold Collected: %s"] = "Ouro Total Coletado: %s"
L["Total Gold Earned:"] = "Total de Ouro Ganho:"
L["Total Gold Spent:"] = "Total de Ouro Gasto:"
L["Total Price"] = "Preço Total"
L["Total Profit:"] = "Total de Lucro:"
L["Total Value"] = "Valor Total"
L["Total Value of All Items"] = "Valor Total de Todos os Itens"
L["Track Sales / Purchases via trade"] = "Acompanhar Vendas / Compras via janela de troca"
L["TradeSkillMaster Info"] = "Info do TradeSkillMaster"
L["Transform Value"] = "Valor de Transformação"
L["TSM Banking"] = "TSM Armazenamento"
L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "O TSM pode sincronizar automaticamente dados entre múltiplas contas. Você também pode enviar seu perfil atual para contas conectadas para rapidamente enviar grupos e operações para outras contas."
L["TSM Crafting"] = "TSM Criação"
L["TSM Destroying"] = "TSM Destruição"
L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "O TSM atualmente não possui nenhum dado de AuctionDB para seu reino. Recomendamos o download do App de Desktop do TSM de |cff99ffffhttp://tradeskillmaster.com|r para automaticamente atualizar seus dados do AuctionDB (e fazer backup automático de suas configurações do TSM)"
L["TSM failed to scan some auctions. Please rerun the scan."] = "O TSM falhou em escanear alguns leilões. Por favor, execute-o novamente."
L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "O TSM está atualmente reconstruindo seu cache de itens, o que pode causar alguma queda de QPS e fazer com que o TSM não esteja totalmente funcional até que este processo seja completado. Isso é normal e geralmente leva menos de um minuto."
L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM está notando a ausência de algumas informações importantes  do App de Desktop do TSM. Por favor, certifique-se que o App de Desktop do TSM esteja rodando e esteja corretamente configurado."
L["TSM Mailing"] = "TSM Correio"
L["TSM TASK LIST"] = "TSM LISTA DE TAREFAS"
L["TSM Vendoring"] = "TSM Comerciante"
L["TSM Version Info:"] = "Informações da versão TSM:"
L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "O TSM_Accounting detectou que você trocou %s %s por %s. Você gostaria que a Contabilidade armazenasse o registro destra troca?"
L["TSM4"] = "TSM4"
L["TUJ 14-Day Price"] = "TUJ - Preço de 14 Dias"
L["TUJ 3-Day Price"] = "TUJ - Preço de 3 Dias"
L["TUJ Global Mean"] = "TUJ - Média Global"
L["TUJ Global Median"] = "TUJ - Mediana Global"
L["Twitter Integration"] = "Integração com Twitter"
L["Twitter Integration Not Enabled"] = "Integração com Twitter Não Habilitada"
L["Type"] = "Tipo"
L["Type Something"] = "Digite Algo"
L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Não foi possível processar a importação porque o grupo alvo (%s) não existe mais. Por favor, tente novamente."
L["Unbalanced parentheses."] = "Parênteses errados."
L["Undercut amount:"] = "Valor de corte:"
L["Undercut by whitelisted player."] = "Preço cortado por jogador na lista de permissões."
L["Undercutting blacklisted player."] = "Preço cortado por jogador na lista negra."
L["Undercutting competition."] = "Cortando preço da concorrência."
L["Ungrouped Items"] = "Itens Desagrupados"
L["Unknown Item"] = "Item Desconhecido"
L["Unwrap Gift"] = "Desembrulhar Presente"
L["Up"] = "Acima"
L["Up to date"] = "Atualizado"
L["UPDATE EXISTING MACRO"] = "ATUALIZAR MACRO EXISTENTE"
L["Updating"] = "Atualizando"
L["Usage: /tsm price <ItemLink> <Price String>"] = "Uso: /tsm price <Link Item> <Fonte de Preço>"
L["Use smart average for purchase price"] = "Usar média inteligente para preço de compra"
L["Use the field below to search the auction house by filter"] = "Use o campo abaixo para procurar na casa de leilões por filtro"
L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use a lista da esquerda para selecionar grupos & operações para as quais gostaria de criar códigos de exportação."
L["VALUE PRICE SOURCE"] = "FONTE DE VALOR"
L["ValueSources"] = "Fontes de Valor"
L["Variable Name"] = "Nome da Variável"
L["Vendor"] = "Comerciante"
L["Vendor Buy Price"] = "Preço de Compra do Comerciante"
L["Vendor Search"] = "Busca no Comerciante"
L["VENDOR SEARCH"] = "BUSCA PARA COMERCIANTE"
L["Vendor Sell"] = "Venda no Comerciante"
L["Vendor Sell Price"] = "Preço de Venda do Comerciante"
L["Vendoring 'SELL ALL' Button"] = "Botão 'VENDER TUDO' em Comerciante"
L["View ignored items in the Destroying options."] = "Visualize itens ignorados nas opções de Destruição."
L["Warehousing"] = "Armazenamento"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco e %d de cada item quando gbanco/banco > bolsas."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco e %d de cada item quando gbanco/banco > bolsas. Restoque irá manter %d itens em suas bolsas."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco. Restoque irá manter %d itens em suas bolsas."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando banco/gbanco > bolsas."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando banco/gbanco > bolsas. Restoque irá manter %d itens em suas bolsas."
L["Warehousing will move a max of %d of each item in this group."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo."
L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo. Restoque irá manter %d itens em suas bolsas."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco, %d de cada item quando banco/gbanco > bolsas."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco, %d de cada item quando banco/gbanco > bolsas. Restoque irá manter %d itens em suas bolsas."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco. Restoque irá manter %d itens em suas bolsas."
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando banco/gbanco > bolsas."
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando banco/gbanco > bolsas. Restoque irá manter %d itens em suas bolsas."
L["Warehousing will move all of the items in this group."] = "Armazenamento irá mover todos os itens neste grupo."
L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Armazenamento irá mover todos os itens neste grupo. Restoque irá manter %d itens em suas bolsas."
L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "AVISO: A macro era muito longa, então foi reduzida para ser ajustada pelo WoW."
L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "AVISO: Seu preço mínimo para %s está abaixo do seu valor de venda ao Comerciante (com o corte da CdL levado em consideração). Considere aumentar seu preço mínimo ou vendê-lo ao Comerciante."
L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Bem-vindo(a) ao TSM4! Todos os módulos antigos do TSM3 (ex.: Crafting, Shopping, etc) agora são vinculados ao addon principal do TSM, então você precisa apenas do TSM e TSM_AppHelper instalados. O TSM desabilitou os módulos antigos e requer recarreamento."
L["When above maximum:"] = "Quando acima do máximo:"
L["When below minimum:"] = "Quando abaixo do mínimo:"
L["Whitelist"] = "Lista de Permissões"
L["Whitelisted Players"] = "Jogadores na Lista de Permissões"
L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "Você já possui a sua quantidade máxima de restoque deste item. Você tem %d e a quantidade máxima para restoque é %d"
L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "Você pode utilizar a opção abaixo para limpar dados antigos. É recomendado excluir dados antigos ocasionalmente para manter o módulo de contabilidade rodando normalmente. Selecione o mínimo de dias para remover, e então clique em '%s'."
L["You cannot use %s as part of this custom price."] = "Você não pode usar %s como parte desse preço personalizado."
L["You cannot use %s within convert() as part of this custom price."] = "Você não pode usar %s dentro do convert() como parte deste preço personalizado."
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "Você não precisa adicionar \"%s\", alts são adicionados à Lista de Permissões automaticamente."
L["You don't know how to craft this item."] = "Você não sabe como criar este item."
L["You must reload your UI for these settings to take effect. Reload now?"] = "Você deve atualizar sua UI para que essas mudanças sejam aplicadas. Atualizar agora?"
L["You won an auction for %sx%d for %s"] = "Você ganhou um leilão de %sx%d por %s"
L["Your auction has not been undercut."] = "Seu leilão não teve o preço cortado."
L["Your auction of %s expired"] = "Seu leilão de %s expirou"
L["Your auction of %s has sold for %s!"] = "Seu leilão %s foi vendido por %s!"
L["Your Buyout"] = "Seu Arremate"
L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Seu método de valor de criação para '%s' era inválido então ele retornou o valor padrão. Detalhes: %s"
L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Seu método de valor de criação padrão era inválido então ele retornou o padrão. Detalhes: %s"
L["Your task list is currently empty."] = "Sua lista de tarefas está atualmente vazia."
L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Você foi faseado, o que fez com que a CdL parasse de funcionar devido à um erro no lado dos servidores Blizzards. Por favor, feche e reabra a janela da CdL e reinicie o Sniper."
L["You've been undercut."] = "Seu preço foi cortado."
	elseif locale == "ruRU" then
L = L or {}
L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "Выбрано: группы %d, предметы %d"
L["%d auctions"] = "лоты: %d"
L["%d Groups"] = "%d Группы"
L["%d Items"] = "%d Предметы"
L["%d of %d"] = "%d по %d"
L["%d Operations"] = "Операции: %d"
L["%d Posted Auctions"] = "Активные лоты: %d"
L["%d Sold Auctions"] = "Проданные лоты: %d"
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s сумки, %s банк, %s аукцион, %s почта)"
L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s игрок, %s альты, %s гильдия, %s аукцион)"
L["%s (%s profit)"] = "%s (%s прибыль)"
L["%s |4operation:operations;"] = "%s |4операция:операции;"
L["%s ago"] = "%s назад"
L["%s Crafts"] = "%s Создать"
L["%s group updated with %d items and %d materials."] = "%s группа обновлена содержащая %d предметов и %d материалов."
L["%s in guild vault"] = "%s в банке гильдии"
L["%s is a valid custom price but %s is an invalid item."] = "%s правильная пользовательская цена, но %s неподходящий предмет."
L["%s is a valid custom price but did not give a value for %s."] = "%s корректная индивидуальная цена, но не дает стоимость для %s."
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "%s недопустимая команда! Мин. пополнение %d больше, чем макс. %d."
L["%s is not a valid custom price and gave the following error: %s"] = "%s некорректная индивидуальная цена, ошибка: %s"
L["%s Operations"] = "%s Операции"
L["%s previously had the max number of operations, so removed %s."] = "%s прежде достигло максимального числа операций, поэтому удален %s"
L["%s removed."] = "%s удалено."
L["%s sent you %s"] = "%s отправил вам %s"
L["%s sent you %s and %s"] = "%s отправил вам %s и %s"
L["%s sent you a COD of %s for %s"] = "%s отправил вам наложенным платежом %s за %s"
L["%s sent you a message: %s"] = "%s отправил вам сообщение: %s"
L["%s total"] = "всего %s"
L["%sDrag%s to move this button"] = "%sПеретащите%s чтобы подвинуть эту кнопку"
L["%sLeft-Click%s to open the main window"] = "%sЛКМ%s для открытия главного окна"
L["(%d/500 Characters)"] = "%d / 500 символов"
L["(max %d)"] = "(макс. %d)"
L["(max 5000)"] = "(макс. 5000)"
L["(min %d - max %d)"] = "(мин. %d – макс. %d)"
L["(min 0 - max 10000)"] = "(мин 0 - макс 10000)"
L["(minimum 0 - maximum 20)"] = "(минимум 0 - максимум 20)"
L["(minimum 0 - maximum 2000)"] = "(минимум 0 - максимум 2000)"
L["(minimum 0 - maximum 905)"] = "(минимум 0 - максимум 905)"
L["(minimum 0.5 - maximum 10)"] = "(минимум 0.5 - максимум 10)"
L["/tsm help|r - Shows this help listing"] = "/tsm help|r — Команда покажет справку"
L["/tsm|r - opens the main TSM window."] = "/tsm|r — Команда открывает главное окно TSM."
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r Когда TSM_Accounting в последний раз сохранял данные для этого мира, они оказались большие что бы WoW их обработал, поэтому старые данные были урезаны в целях избежания повреждения сохраненных переменных. Последние %s данные покупок были сохранены."
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r Когда TSM_Accounting в последний раз сохранял данные для этого мира, они оказались большие что бы WoW их обработал, поэтому старые данные были урезаны в целях избежания повреждения сохраненных переменных. Последние %s данные продаж были сохранены."
L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839ЛКМ|r — игнорировать предмет в этой сессии. |cffffd839Shift+ЛКМ|r — игнорировать всегда. Удалить предмет из списка игнора можно в настройках на вкладке Vendoring."
L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839ЛКМ|r что бы игнорировать предмет в этой сессии."
L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift+ЛКМ|r чтобы игнорировать всегда."
L["1 Group"] = "1 Группа"
L["1 Item"] = "1 Предмет"
L["12 hr"] = "12 ч."
L["24 hr"] = "24 ч."
L["48 hr"] = "48 ч."
L["A custom price of %s for %s evaluates to %s."] = "Индивидуальная цена %s для %s оценивается в %s."
L["A maximum of 1 convert() function is allowed."] = "Допускается максимум 1 функция convert()."
L["A profile with that name already exists on the target account. Rename it first and try again."] = "Профиль с этим именем уже существует на целевом аккаунте. Сначала переименуйте его и попробуйте еще раз."
L["A profile with this name already exists."] = "Профиль с таким именем уже существует."
L["A scan is already in progress. Please stop that scan before starting another one."] = "Сканирование уже идёт. Остановите его, прежде чем начать новое."
L["Above max expires."] = "Превышены попытки выставить."
L["Above max price. Not posting."] = "Выше макс. Не выставляем."
L["Above max price. Posting at max price."] = "Выше макс. Ставим по макс. цене."
L["Above max price. Posting at min price."] = "Выше макс. Ставим по мин. цене."
L["Above max price. Posting at normal price."] = "Выше макс. Ставим по норм. цене."
L["Accepting these item(s) will cost"] = "Принять эти предметы будет стоить"
L["Accepting this item will cost"] = "Принять этот предмет будет стоить"
L["Account sync removed. Please delete the account sync from the other account as well."] = "Синхронизация аккаунта отключена. Отключите синхронизацию и на другом аккаунте."
L["Account Syncing"] = "Синхронизация аккаунта"
L["Accounting"] = "Статистика"
L["Accounting Tooltips"] = "Подсказки с вашей статистикой"
L["Activity Type"] = "Вид деятельности"
L["ADD %d ITEMS"] = "Добавить предметы: %d"
L["Add / Remove Items"] = "Список предметов"
L["ADD NEW CUSTOM PRICE SOURCE"] = "Добавить индивидуальный источник цен"
L["ADD OPERATION"] = "Операция"
L["Add Player"] = "Добавить игрока"
L["Add Subject / Description"] = "Тема и описание"
L["Add Subject / Description (Optional)"] = "Добавить тему и описание письма"
L["ADD TO MAIL"] = "Добавить к письму"
L["Added '%s' profile which was received from %s."] = "Добавлен '%s' профиль, который был получем из %s."
L["Added %s to %s."] = "Добавлен %s в %s."
L["Additional error suppressed"] = "Вывод дополнительных ошибок отключен"
L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Так предметы в группах, связанных с операцией, будут выставлены на аукцион."
L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Условия отмены аукционов для предметов в группах, связанных с операцией."
L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Установите алгоритмы расчёта цен для предметов в группах, связанных с операцией."
L["Advanced Item Search"] = "Расширенный поиск"
L["Advanced Options"] = "Расширенные настройки"
L["AH"] = "Аукцион"
L["AH (Crafting)"] = "Аук (Создание)"
L["AH (Disenchanting)"] = "Аукцион (Распыление)"
L["AH BUSY"] = "Аук занят"
L["AH Frame Options"] = "Настройки окна аукциона"
L["Alarm Clock"] = "Бyдильник"
L["All Auctions"] = "Все лоты на аукционе"
L["All Characters and Guilds"] = "Персонажи и гильдии"
L["All Item Classes"] = "Все Классы Предметов"
L["All Professions"] = "Все профессии"
L["All Subclasses"] = "Все Подклассы"
L["Allow partial stack?"] = "Выставлять неполные стаки?"
L["Alt Guild Bank"] = "Банк гильдии альтов"
L["Alts"] = "Альты"
L["Alts AH"] = "Аукционы альтов"
L["Amount"] = "Сумма"
L["AMOUNT"] = "СУММА"
L["Amount of Bag Space to Keep Free"] = "Оставлять свободных ячеек в сумках"
L["APPLY FILTERS"] = "Применить фильтры"
L["Apply operation to group:"] = "Применить операцию к группе:"
L["Are you sure you want to clear old accounting data?"] = "Очистить старые данные вашей статистики?"
L["Are you sure you want to delete this group?"] = "Удалить эту группу?"
L["Are you sure you want to delete this operation?"] = "Удалить эту операцию?"
L["Are you sure you want to reset all operation settings?"] = "Сбросить все настройки операции?"
L["At above max price and not undercut."] = "При превышении макс. цены и не перебит."
L["At normal price and not undercut."] = "По нормальной цене и не перебит."
L["Auction"] = "Аукцион"
L["Auction Bid"] = "Аукционная Ставка"
L["Auction Buyout"] = "Аукционный Выкуп"
L["AUCTION DETAILS"] = "Детали аукциона"
L["Auction Duration"] = "Длительность"
L["Auction has been bid on."] = "Аукцион был объявлен."
--[[Translation missing --]]
L["Auction House Cut"] = "Auction House Cut"
L["Auction Sale Sound"] = "Звук продажи аукциона"
L["Auction Window Close"] = "Закрыть окно аукциона"
L["Auction Window Open"] = "Открыть окно аукциона"
L["Auctionator - Auction Value"] = "Auctionator - рыночная стоимость"
L["AuctionDB - Market Value"] = "AuctionDB - Рыночная стоимость"
L["Auctioneer - Appraiser"] = "Auctioneer - Apprаiser"
L["Auctioneer - Market Value"] = "Auctioneer - рыночная стoимость"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - минимальный выкуп"
L["Auctioning"] = "Аукцион"
L["Auctioning Log"] = "Результаты сканирования"
L["Auctioning Operation"] = "Операции аукциона"
L["Auctioning 'POST'/'CANCEL' Button"] = "Кнопки «Выставить» и «Отменить» на аукционе"
--[[Translation missing --]]
L["Auctioning Tooltips"] = "Auctioning Tooltips"
L["Auctions"] = "Лоты"
L["Auto Quest Complete"] = "Автоматически завершающееся задание"
L["Average Earned Per Day:"] = "Средний заработок в день:"
L["Average Prices:"] = "Средняя цена:"
L["Average Profit Per Day:"] = "Средняя прибыль в день:"
L["Average Spent Per Day:"] = "Средние расходы в день:"
L["Avg Buy Price"] = "Ср. цена покупки"
L["Avg Resale Profit"] = "Ср. доход c перепродажи"
L["Avg Sell Price"] = "Ср. цена продажи"
L["BACK"] = "НАЗАД"
L["BACK TO LIST"] = "Вернуться к списку"
L["Back to List"] = "Вернуться к списку"
L["Bag"] = "Сумка"
L["Bags"] = "Сумки"
L["Banks"] = "Банки"
L["Base Group"] = "Базовая группа"
L["Base Item"] = "Базовый предмет"
L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Ниже показаны доступные источники цен. %skey|r  - это то, что вы должны ввести в поле индивидуальной цены."
L["Below custom price:"] = "Ниже индивидуальной цены:"
L["Below min price. Posting at max price."] = "Ниже мин. Ставим по макс. цене."
L["Below min price. Posting at min price."] = "Ниже мин. Ставим по мин. цене."
L["Below min price. Posting at normal price."] = "Ниже мин. Ставим по норм. цене."
L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Ниже настройки ваших профилей. Они позволят вам иметь разные наборы групп."
L["BID"] = "СТАВКА"
L["Bid %d / %d"] = "Ставка %d / %d"
L["Bid (item)"] = "Ставка (шт)"
L["Bid (stack)"] = "Ставка (стак)"
L["Bid Price"] = "Цена ставки"
L["Bid Sniper Paused"] = "Ставка «Снайпер» на паузе"
L["Bid Sniper Running"] = "Запущен «Снайпер» по ставкам"
--[[Translation missing --]]
L["Bidding Auction"] = "Bidding Auction"
L["Blacklisted players:"] = "Игроки в черном списке:"
L["Bought"] = "Купил"
L["Bought %d of %s from %s for %s"] = "Куплено %d %s у %s за %s"
L["Bought %sx%d for %s from %s"] = "Купил %sx%d для %s от %s"
L["Bound Actions"] = "Связанные действия"
L["BUSY"] = "Занят"
L["BUY"] = "Купить"
L["Buy"] = "Купить"
L["Buy %d / %d"] = "Купить %d / %d"
L["Buy %d / %d (Confirming %d / %d)"] = "Покупка %d / %d (Подтверждение %d / %d)"
L["Buy from AH"] = "Купить на аукционе"
L["Buy from Vendor"] = "Купить у торговца"
L["BUY GROUPS"] = "Купить группы"
L["Buy Options"] = "Настройки покупки"
L["BUYBACK ALL"] = "Выкупить всё"
L["Buyer/Seller"] = "Покупатель/Продавец"
L["BUYOUT"] = "ВЫКУП"
L["Buyout (item)"] = "Выкуп (шт)"
L["Buyout (stack)"] = "Выкуп (стак)"
L["Buyout Confirmation Alert"] = "Предупреждение подтверждающее выкуп"
L["Buyout Price"] = "Цена выкупа"
L["Buyout Sniper Paused"] = "Выкуп «Снайпер» на паузе"
L["Buyout Sniper Running"] = "Запущен «Снайпер» на выкуп"
L["BUYS"] = "Покупки"
L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "В эту группу по умолчанию входят все предметы, которые вы не добавили в другие группы. Эту группу нельзя изменить или удалить."
L["Cancel auctions with bids"] = "Отменять аукционы со ставками"
L["Cancel Scan"] = "Скан. для отмены"
L["Cancel to repost higher?"] = "Отменять для повышения цены?"
L["Cancel undercut auctions?"] = "Отменять перебитые аукционы?"
L["Canceling"] = "Отмена"
L["Canceling %d / %d"] = "Отмена %d / %d"
L["Canceling %d Auctions..."] = "Отмена лотов: %d..."
L["Canceling all auctions."] = "Отмена всех аукционов."
L["Canceling auction which you've undercut."] = "Отмена лота, который вы перебили."
L["Canceling disabled."] = "Отмена отключена."
L["Canceling Settings"] = "Настройки отмены аукциона"
L["Canceling to repost at higher price."] = "Отмена для повышения цены."
L["Canceling to repost at reset price."] = "Отмена для выставления по сниженной цене."
L["Canceling to repost higher."] = "Отмена для повышения цены."
L["Canceling undercut auctions and to repost higher."] = "Отмена сбитых лотов и повышение цены."
L["Canceling undercut auctions."] = "Отмена сбитых лотов."
L["Cancelled"] = "Отменен"
L["Cancelled auction of %sx%d"] = "Отмена лота %sx%d"
L["Cancelled Since Last Sale"] = "Отменено с последней продажи"
L["CANCELS"] = "Отменённые"
L["Cannot repair from the guild bank!"] = "Невозможно починиться за счёт гильдии!"
L["Can't load TSM tooltip while in combat"] = "Нельзя вывести подсказку TSM в бою"
L["Cash Register"] = "Сумма зарегистрирована"
L["CHARACTER"] = "ПЕРСОНАЖ"
L["Character"] = "Персонаж"
L["Chat Tab"] = "Вкладка чата"
L["Cheapest auction below min price."] = "Самый дешевый лот ниже мин. цены."
L["Clear"] = "Очистить"
L["Clear All"] = "Очистить все"
L["CLEAR DATA"] = "Очистить данные"
L["Clear Filters"] = "Очистить"
L["Clear Old Data"] = "Очистить старые данные"
L["Clear Old Data Confirmation"] = "Подтверждение очистки старых данных"
L["Clear Queue"] = "Очистить"
L["Clear Selection"] = "Очистить выбранное"
L["COD"] = "наложенный платеж"
L["Coins (%s)"] = "Монеты (%s)"
L["Collapse All Groups"] = "Свернуть все группы"
L["Combine Partial Stacks"] = "Объединить неполные стаки"
L["Combining..."] = "Объединение..."
L["Configuration Scroll Wheel"] = "Настройка колеса мыши"
L["Confirm"] = "Подтвердить"
L["Confirm Complete Sound"] = "Звук окончания подтверждения"
L["Confirming %d / %d"] = "Подтверждение %d / %d"
L["Connected to %s"] = "Подключен к %s"
L["Connecting to %s"] = "Подключение к %s"
L["CONTACTS"] = "Контакты"
L["Contacts Menu"] = "Список контактов"
L["Cooldown"] = "Кулдаун"
L["Cooldowns"] = "Кулдауны"
L["Cost"] = "Цена"
L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Макрос не создан, потому что их уже слишком много. Удалите один из них и попробуйте снова."
L["Could not find profile '%s'. Possible profiles: '%s'"] = "Профиль '%s' не найден. Доступные профили: '%s'"
L["Could not sell items due to not having free bag space available to split a stack of items."] = "Не могу продать товары из-за отсутствия места в сумках для разделения стака."
L["Craft"] = "Создать"
L["CRAFT"] = "Создать"
L["Craft (Unprofitable)"] = "Создать (Невыгодный)"
L["Craft (When Profitable)"] = "Создать (Когда выгодно)"
L["Craft All"] = "Создать всё"
L["CRAFT ALL"] = "Создать всё"
L["Craft Name"] = "Название рецепта"
L["CRAFT NEXT"] = "Создать след."
L["Craft value method:"] = "Метод расчета стоимости крафта:"
L["CRAFTER"] = "СОЗДАТЕЛЬ"
L["CRAFTING"] = "КРАФТ"
L["Crafting"] = "Крафт"
L["Crafting Cost"] = "Стоимость создания"
L["Crafting 'CRAFT NEXT' Button"] = "Кнопка «Создать след.»"
L["Crafting Queue"] = "Очередь производства"
L["Crafting Tooltips"] = "Подсказки об изготовлении предметов"
L["Crafts"] = "Рецепты"
L["Crafts %d"] = "Создать %d за раз"
L["CREATE MACRO"] = "СОЗДАТЬ МАКРОС"
L["Create New Operation"] = "Создать новую операцию"
L["CREATE NEW PROFILE"] = "СОЗДАТЬ НОВЫЙ ПРОФИЛЬ"
L["Create Profession Group"] = "Создать группу профессии"
L["Created custom price source: |cff99ffff%s|r"] = "Созданный пользовательский источник цен: |cff99ffff%s|r"
L["Crystals"] = "Кристаллы"
L["Current Profiles"] = "Ваши профили"
L["CURRENT SEARCH"] = "ТЕКУЩИЙ ПОИСК"
L["CUSTOM POST"] = "Пользовательское сообщение"
L["Custom Price"] = "Индивидуальная цена"
L["Custom Price Source"] = "Индивидуальный источник цен"
L["Custom Sources"] = "Индивидуальный источник"
L["Database Sources"] = "Показ источников данных в подсказке"
L["Default Craft Value Method:"] = "Метод расчёта стоимости крафта по умолчанию:"
L["Default Material Cost Method:"] = "Метод расчёта стоимости материалов по умолчанию:"
L["Default Price"] = "Стандартная цена"
L["Default Price Configuration"] = "Конфигурация цены по умолчанию"
--[[Translation missing --]]
L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
L["Delete Profile Confirmation"] = "Подтвердите удаление профиля"
L["Delete this record?"] = "Удалить эту запись?"
--[[Translation missing --]]
L["Deposit"] = "Deposit"
--[[Translation missing --]]
L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
L["Deposit Price"] = "Deposit Price"
L["DEPOSIT REAGENTS"] = "Сложить реагенты"
L["Deselect All Groups"] = "Снять выделение"
L["Deselect All Items"] = "Снять выделение"
L["Destroy Next"] = "Уничтожить следующее"
L["Destroy Value"] = "Стоимость уничтожения"
L["Destroy Value Source"] = "Источник стоимости уничтожения"
L["Destroying"] = "Уничтожение"
L["Destroying 'DESTROY NEXT' Button"] = "Кнопка «Уничтожить следующее»"
L["Destroying Tooltips"] = "Подсказки уничтожения"
L["Destroying..."] = "Уничтожение..."
L["Details"] = "Детали"
L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Лот %s не отменен. Потому что ваш порог для отмены аукциона (%s) не корректен. Проверьте настройки."
L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Лот %s не отменен. Ваша максимальная цена (%s) не верна. Проверьте настройки."
L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Лот %s не отменен. Ваша максимальная цена (%s) ниже минимальной цены (%s). Проверьте настройки."
L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Лот %s не отменен. Ваша минимальная цена (%s) не верна. Проверьте настройки."
L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Лот %s не отменен. Ваша нормальная цена (%s) не верна. Проверьте настройки."
L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Лот %s не отменен. Ваша нормальная цена (%s) ниже минимальной цены (%s). Проверьте настройки."
L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Лот %s не отменен. Ваша цена сбивания (%s) не верна. Проверьте настройки."
L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Лот %s не выставлен. Blizzard не предоставила для этого нужную информацию. Попробуйте позже."
L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Лот %s не выставлен. Владелец лота (%s) с самой низкой ценой находится в вашем черном и белом списке одновременно, так быть не должно. Измените настройки, чтобы исправить эту проблему."
L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Лот %s не выставлен. Вы или ваш альт (%s) находитесь в черном списке, так быть не должно. Удалите персонажа из черного списка."
L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Лот %s не выставлен. Ваша максимальная цена (%s) не верна. Проверьте настройки."
L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Лот %s не выставлен. Ваша максимальная цена (%s) ниже, вашей минимальной цены (%s). Проверьте настройки."
L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Лот %s не выставлен. Ваша минимальная цена (%s) не верна. Проверьте настройки."
L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Лот %s не выставлен. Ваша нормальная цена (%s) не верна. Проверьте настройки."
L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Лот %s не выставлен. Ваша нормальная цена (%s) ниже, вашей минимальной цены (%s). Проверьте настройки."
L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Лот %s не выставлен. Ваша цена сбития (%s) не верна. Проверьте настройки."
L["Disable invalid price warnings"] = "Отключить предупреждения о неверной цене"
L["Disenchant Search"] = "Поиск для распыления"
L["DISENCHANT SEARCH"] = "Поиск для распыления"
L["Disenchant Search Options"] = "Настройки поиска предметов для распыления"
L["Disenchant Value"] = "Стоимость распыления"
L["Disenchanting Options"] = "Настройки распыления"
L["Display auctioning values"] = "Показать цены на аукционе"
L["Display cancelled since last sale"] = "Показать сколько раз отменено после последней продажи"
L["Display crafting cost"] = "Показать стоимость создания"
L["Display detailed destroy info"] = "Показать подробности уничтожения"
L["Display disenchant value"] = "Показать стоимость распыления"
L["Display expired auctions"] = "Показать истекшие лоты"
L["Display group name"] = "Показать имя группы"
L["Display historical price"] = "Показать историческую цену"
L["Display market value"] = "Показать рыночную стоимость"
L["Display mill value"] = "Показать стоимость измельчения"
L["Display min buyout"] = "Показать минимальную цену"
L["Display Operation Names"] = "Показать имена операций"
L["Display prospect value"] = "Показать стоимость просеивания"
L["Display purchase info"] = "Показать информацию о покупках"
L["Display region historical price"] = "Показать историческую цену по региону"
L["Display region market value avg"] = "Показать ср. рыночную стоимость по региону"
L["Display region min buyout avg"] = "Показать ср. минимальную цену по региону"
L["Display region sale avg"] = "Показать ср. цену продажи по региону"
L["Display region sale rate"] = "Показать шанс продажи по региону"
L["Display region sold per day"] = "Показать статистику ежедневных продаж по региону"
L["Display sale info"] = "Показать информацию о продажах"
L["Display sale rate"] = "Показать шанс продажи"
L["Display shopping max price"] = "Показать максимальную цену покупки"
L["Display total money recieved in chat?"] = "Показывать общую сумму полученных денег в чат?"
L["Display transform value"] = "Показать стоимость трансформации (например разделки рыбы)"
L["Display vendor buy price"] = "Показать цену покупки у торговца"
L["Display vendor sell price"] = "Показать цену продажи торговцу"
L["Doing so will also remove any sub-groups attached to this group."] = "Вместе с группой вы удалите все её подгруппы."
L["Done Canceling"] = "Лоты сняты с аукциона"
L["Done Posting"] = "Лоты выставлены"
--[[Translation missing --]]
L["Done rebuilding item cache."] = "Done rebuilding item cache."
L["Done Scanning"] = "Сканирование закончено"
L["Don't post after this many expires:"] = "Количество попыток выставить лот:"
L["Don't Post Items"] = "Не выставлять"
L["Don't prompt to record trades"] = "Не предлагать записывать сделки"
L["DOWN"] = "Вниз"
L["Drag in Additional Items (%d/%d Items)"] = "Предметы: %d / %d"
L["Drag Item(s) Into Box"] = "Перетащите предметы сюда"
L["Duplicate"] = "Скопировать"
L["Duplicate Profile Confirmation"] = "Подтвердите копирование данных"
L["Dust"] = "Пыль"
L["Elevate your gold-making!"] = "Прокачай свои доходы!"
L["Embed TSM tooltips"] = "Встроить TSM в стандартную подсказку"
L["EMPTY BAGS"] = "ПУСТЫЕ СУМКИ"
L["Empty parentheses are not allowed"] = "Не допускаются пустые скобки"
L["Empty price string."] = "Пустая строка цены"
L["Enable automatic stack combination"] = "Включить автоматическое создание стака"
L["Enable buying?"] = "Включить покупки?"
L["Enable inbox chat messages"] = "Уведомлять о входящих в чате"
L["Enable restock?"] = "Включить пополнение запасов?"
L["Enable selling?"] = "Включить продажи?"
L["Enable sending chat messages"] = "Включить сообщения в чат об исходящих"
L["Enable TSM Tooltips"] = "Показывать подсказки TSM"
L["Enable tweet enhancement"] = "Включить поддержку твитов"
L["Enchant Vellum"] = "Материал для свитка наложения чар"
--[[Translation missing --]]
L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
L["Enter a name for the new profile"] = "Введите имя нового профиля"
L["Enter Filter"] = "Строка поиска"
L["Enter Keyword"] = "Поиск"
L["Enter name of logged-in character from other account"] = "Введите имя персонажа от другого аккаунта"
L["Enter player name"] = "Введите имя игрока"
L["Essences"] = "Эссенции"
L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Установка соединения с %s. Убедитесь, что вы ввели имя этого персонажа на другой учётной записи."
L["Estimated Cost:"] = "Примерная стоимость:"
--[[Translation missing --]]
L["Estimated deliver time"] = "Estimated deliver time"
L["Estimated Profit:"] = "Планируемая прибыль:"
L["Exact Match Only?"] = "Только точное соответствие?"
L["Exclude crafts with cooldowns"] = "Исключить крафты с кулдауном"
L["Expand All Groups"] = "Развернуть все группы"
L["Expenses"] = "Расходы"
L["EXPENSES"] = "РАСХОДЫ"
--[[Translation missing --]]
L["Expirations"] = "Expirations"
L["Expired"] = "Истёк"
L["Expired Auctions"] = "Истекшие лоты"
L["Expired Since Last Sale"] = "Истёкший с момента последней продажи"
L["Expires"] = "Истёкшие"
L["EXPIRES"] = "Истёкшие"
--[[Translation missing --]]
L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
L["Expiring Mails"] = "Expiring Mails"
L["Exploration"] = "Исследование"
L["Export"] = "Экспорт"
L["Export List"] = "Экспорт"
L["Failed Auctions"] = "Неудавшиеся"
L["Failed Since Last Sale (Expired/Cancelled)"] = "Последние неудачные продажи (Истёкшие/Отмененные)"
--[[Translation missing --]]
L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
L["Failed to bid on auction of %s."] = "Не удалось сделать ставку на %s."
--[[Translation missing --]]
L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
L["Failed to buy auction of %s."] = "Не удалось купить лот %s."
L["Failed to find auction for %s, so removing it from the results."] = "Не удалось найти лот %s, поэтому он исключен из результатов."
--[[Translation missing --]]
L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
L["Favorite Scans"] = "Избранные сканирования"
L["Favorite Searches"] = "Избранные запросы"
L["Filter Auctions by Duration"] = "Фильтр по длительности"
L["Filter Auctions by Keyword"] = "Фильтр по ключевым словам"
L["Filter by Keyword"] = "Поиск по ключевым словам"
L["FILTER BY KEYWORD"] = "Поиск по ключевым словам"
L["Filter group item lists based on the following price source"] = "Фильтровать списки групп предметов на основе следующего источника цен"
L["Filter Items"] = "Поиск по предметам"
L["Filter Shopping"] = "Поиск на аукционе"
L["Finding Selected Auction"] = "Поиск выбранного лота"
L["Fishing Reel In"] = "Звук рыболовной катушки"
L["Forget Character"] = "Забыть персонажа"
L["Found auction sound"] = "Звук найденного лота"
L["Friends"] = "Друзья"
L["From"] = "От"
L["Full"] = "Полный"
L["Garrison"] = "Гарнизон"
L["Gathering"] = "Сбор"
L["Gathering Search"] = "Поиск"
L["General Options"] = "Основные настройки"
L["Get from Bank"] = "Забрать из банка"
L["Get from Guild Bank"] = "Забрать из банка гильдии"
L["Global Operation Confirmation"] = "Сделать операции глобальными?"
L["Gold"] = "Золото"
L["Gold Earned:"] = "Золота получено:"
L["GOLD ON HAND"] = "ЗОЛОТО ПЕРСОНАЖА"
L["Gold Spent:"] = "Золота потрачено:"
L["GREAT DEALS SEARCH"] = "Поиск выгодных предложений"
L["Group already exists."] = "Группа уже существует."
L["Group Management"] = "Менеджер групп"
L["Group Operations"] = "Операции группы"
L["Group Settings"] = "Настройки группы"
L["Grouped Items"] = "Предметы в группе"
L["Groups"] = "Группы"
L["Guild"] = "Гильдия"
L["Guild Bank"] = "Банк гильдии"
L["GVault"] = "Гильдбанк"
L["Have"] = "Есть"
L["Have Materials"] = "Есть материалы"
L["Have Skill Up"] = "Повышают уровень"
L["Hide auctions with bids"] = "Скрыть лоты со ставками"
L["Hide Description"] = "Скрыть описание"
L["Hide minimap icon"] = "Скрыть значок на миникарте"
L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Скрыть TSM Banking UI. Напишите /tsm bankui в чат, чтобы открыть снова."
L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Скрыть TSM Task List UI. Напишите /tsm tasklist в чат, чтобы открыть снова."
L["High Bidder"] = "Покупатель"
L["Historical Price"] = "Историческая цена"
L["Hold ALT to repair from the guild bank."] = "Удерживайте ALT для починки за счёт гильдии"
--[[Translation missing --]]
L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
L["Hr"] = "Час"
L["Hrs"] = "Часов"
L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "Я только что купил [%s]x%d за %s! %s #TSM4 #warcraft"
L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "Я только что продал [%s] за %s! %s #TSM4 #warcraft"
L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "Не хотите сбивать цены других игроков? Вы можете добавить их в белый список и TSM не будет сбивать их цены. Помните: если кто-то из списка выставит лот с вашей ценой выкупа, но меньшей ставкой, TSM всё равно будет сбивать цену такого лота."
L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Включив эту функцию, вы удалите операции всех своих профилей кроме текущего. С этого момента операции будут одинаковы для всех профилей. Уверены что хотите продолжить?"
L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "Если у вас установлена интеграция WoW с Twitter, TSM добавит к публикации дополнение в сообщения о продаже / покупке, а также заменит URL-адреса ссылкой TSM."
L["Ignore Auctions Below Min"] = "Игнорировать аукционы ниже минимума"
L["Ignore auctions by duration?"] = "Игнорировать по длительности?"
L["Ignore Characters"] = "Игнорировать персонажей"
L["Ignore Guilds"] = "Игнорировать гильдии"
--[[Translation missing --]]
L["Ignore item variations?"] = "Ignore item variations?"
L["Ignore operation on characters:"] = "Игнор. операцию на персонажах:"
L["Ignore operation on faction-realms:"] = "Игнор. для фракции/сервера:"
L["Ignored Cooldowns"] = "Игнорировать кулдауны"
L["Ignored Items"] = "Игнорируемые предметы"
L["ilvl"] = "ilvl"
L["Import"] = "Импорт"
L["IMPORT"] = "Импорт"
L["Import %d Items and %s Operations?"] = "Импортировать предметы: %d, операции: %s."
L["Import Groups & Operations"] = "Импорт групп и операций"
L["Imported Items"] = "Импортированные предметы"
L["Inbox Settings"] = "Настройки входящих"
L["Include Attached Operations"] = "Экспорт вместе со связанными операциями"
L["Include operations?"] = "Включить операции?"
L["Include soulbound items"] = "Включить связанные предметы"
L["Information"] = "Информация"
L["Invalid custom price entered."] = "Введена неверная индивидуальная цена."
L["Invalid custom price source for %s. %s"] = "Неверный источник индивидуальной цены для %s. %s"
L["Invalid custom price."] = "Недопустимая индивидуальная цена."
L["Invalid function."] = "Недопустимая функция."
--[[Translation missing --]]
L["Invalid gold value."] = "Invalid gold value."
L["Invalid group name."] = "Неверное название группы."
--[[Translation missing --]]
L["Invalid import string."] = "Invalid import string."
L["Invalid item link."] = "Недопустимая ссылка на предмет."
L["Invalid operation name."] = "Неверное название операции."
L["Invalid operator at end of custom price."] = "Некорректный оператор в конце индивидуальной цены."
L["Invalid parameter to price source."] = "Некорректный параметр в источнике цены."
L["Invalid player name."] = "Неверное имя игрока."
L["Invalid price source in convert."] = "Недопустимая цена источника при преобразовании."
L["Invalid price source."] = "Неверный источник цены."
--[[Translation missing --]]
L["Invalid search filter"] = "Invalid search filter"
L["Invalid seller data returned by server."] = "Сервер вернул неверные данные о продавце."
L["Invalid word: '%s'"] = "Недопустимое слово: '%s'"
L["Inventory"] = "Инвентарь"
--[[Translation missing --]]
L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
L["Inventory / Mailing"] = "Инвентарь/Почта"
L["Inventory Options"] = "Настройки инвентаря"
L["Inventory Tooltip Format"] = "Формат инвентаря в подсказке"
L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "Это сообщение появилось, потому что вы вручную скопировали ваши сохраненные переменные между аккаунтами, что остановит работу автоматическую синхронизацию TSM. Вам нужно будет отменить это, и/или удалить файлы с сохраненными переменными TradeSkillMaster на обоих аккаунтах (с закрытым WoW), чтобы исправить это."
L["Item"] = "Предмет"
L["ITEM CLASS"] = "Категория предметов"
L["Item Level"] = "Уровень предмета"
L["ITEM LEVEL RANGE"] = "Диапазон уровней предметов"
L["Item links may only be used as parameters to price sources."] = "Ссылка на предмет может быть использована только как параметр для цены источника."
L["Item Name"] = "Название предмета"
L["Item Quality"] = "Качество предмета"
L["ITEM SEARCH"] = "Поиск предмета"
L["ITEM SELECTION"] = "ВЫБОР ПРЕДМЕТА"
L["ITEM SUBCLASS"] = "Подкатегория предметов"
L["Item Value"] = "Цена предмета"
L["Item/Group is invalid (see chat)."] = "Предмет/Группа не верна (см. чат)."
L["ITEMS"] = "Предметы"
L["Items"] = "Предметы"
L["Items in Bags"] = "Предметы в сумках"
L["Keep in bags quantity:"] = "Оставлять в сумках:"
L["Keep in bank quantity:"] = "Оставлять в банке:"
L["Keep posted:"] = "Оставить выставленным:"
L["Keep quantity:"] = "Сколько оставлять:"
L["Keep this amount in bags:"] = "Оставить в сумках:"
L["Keep this amount:"] = "Сколько оставлять:"
L["Keeping %d."] = "Оставляем %d."
L["Keeping undercut auctions posted."] = "Оставляем перебитые лоты."
L["Last 14 Days"] = "Последние 14 дней"
L["Last 3 Days"] = "Последние 3 дня"
L["Last 30 Days"] = "Последние 30 дней"
L["LAST 30 DAYS"] = "ПОСЛЕДНИЕ 30 ДНЕЙ"
L["Last 60 Days"] = "Последние 60 дней"
L["Last 7 Days"] = "Последние 7 дней"
L["LAST 7 DAYS"] = "ПОСЛЕДНИЕ 7 ДНЕЙ"
L["Last Data Update:"] = "Обновление данных:"
L["Last Purchased"] = "Последняя покупка"
L["Last Sold"] = "Последняя продажа"
L["Level Up"] = "Новый уровень"
L["LIMIT"] = "ЛИМИТ"
L["Link to Another Operation"] = "Ссылка на другую операцию"
L["List"] = "Список"
L["List materials in tooltip"] = "Показать список материалов"
L["Loading Mails..."] = "Загрузка почты..."
L["Loading..."] = "Загрузка..."
L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Кажется, в TradeSkillMaster произошла ошибка. Пожалуйста, помогите автору проекта её исправить. Следуйте инструкциям ниже."
L["Loop detected in the following custom price:"] = "В индивидуальной цене обнаружен цикл:"
L["Lowest auction by whitelisted player."] = "Наименьший лот у игрока из белого списка."
L["Macro created and scroll wheel bound!"] = "Макрос создан и привязан к колесу мыши!"
L["Macro Setup"] = "Настройки макросов"
L["Mail"] = "Почта"
L["Mail Disenchantables"] = "Отправка распыляемых предметов"
L["Mail Disenchantables Max Quality"] = "Макс. качество распыляемых предметов для отправки"
L["MAIL SELECTED GROUPS"] = "Отправить выбранные группы"
L["Mail to %s"] = "Письмо %s"
L["Mailing"] = "Отправка"
L["Mailing all to %s."] = "Отправка всего %s."
L["Mailing Options"] = "Настройки почты"
L["Mailing up to %d to %s."] = "Отправка от %d до %s."
L["Main Settings"] = "Настройки"
L["Make Cash On Delivery?"] = "Наложенный платёж"
L["Management Options"] = "Дополнительные настройки"
L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Многие часто используемые действия в TSM можно привязать к прокрутке колеса мыши с помощью макросов. Используйте настройки ниже, чтобы экономить время."
L["Map Ping"] = "Звук пингования по карте"
L["Market Value"] = "Рыночная стоимость"
L["Market Value Price Source"] = "Источник «рыночной стоимости»"
L["Market Value Source"] = "Источник «рыночной стоимости»"
L["Mat Cost"] = "Цена мат."
L["Mat Price"] = "Цена мат."
L["Match stack size?"] = "Точное совпадение размера стака"
L["Match whitelisted players"] = "Использовать белый список игроков"
L["Material Name"] = "Название материала"
L["Materials"] = "Материалы"
L["Materials to Gather"] = "Материалы для сбора"
--[[Translation missing --]]
L["MAX"] = "MAX"
L["Max Buy Price"] = "Макс цена Покупки"
L["MAX EXPIRES TO BANK"] = "Макс. истёкшие в банк"
L["Max Sell Price"] = "Макс цена Продажи"
L["Max Shopping Price"] = "Макс. закупочная цена"
L["Maximum amount already posted."] = "Макс. количество уже выставлено."
L["Maximum Auction Price (Per Item)"] = "Максимальная цена лота (за шт)"
L["Maximum Destroy Value (Enter '0c' to disable)"] = "Макс. стоимость уничтожения (введите \"0c\" для отключения)"
L["Maximum disenchant level:"] = "Макс. уровень для распыления:"
L["Maximum Disenchant Quality"] = "Макс. качество для распыления"
L["Maximum disenchant search percentage:"] = "Макс. процент поиска для распыления:"
L["Maximum Market Value (Enter '0c' to disable)"] = "Макс. рыночная стоимость (Впишите '0с' что бы отключить)"
L["MAXIMUM QUANTITY TO BUY:"] = "Максимальное количество для покупки:"
L["Maximum quantity:"] = "Максимальное количество:"
L["Maximum restock quantity:"] = "Макс. пополнение запасов:"
L["Mill Value"] = "Стоимость измельчения"
L["Min"] = "Мин"
L["Min Buy Price"] = "Мин цена Покупки"
L["Min Buyout"] = "Минимальная цена"
L["Min Sell Price"] = "Мин цена Продажи"
L["Min/Normal/Max Prices"] = "Мин./Норм./Макс. цена"
L["Minimum Days Old"] = "Минимум дней"
L["Minimum disenchant level:"] = "Мин. уровень для распыления:"
L["Minimum expires:"] = "Минимальный срок действия:"
L["Minimum profit:"] = "Минимальная прибыль:"
L["MINIMUM RARITY"] = "Минимальное качество"
L["Minimum restock quantity:"] = "Мин. пополнение запасов:"
L["Misplaced comma"] = "Запятая не в том месте"
L["Missing Materials"] = "Не хватает материалов"
--[[Translation missing --]]
L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
L["Modifiers:"] = "Модификаторы:"
L["Money Frame Open"] = "Открытие фрейма с монетами"
L["Money Transfer"] = "Перевод денег"
L["Most Profitable Item:"] = "Самый выгодный предмет:"
L["MOVE"] = "Переместить"
L["Move already grouped items?"] = "Переместить уже сгруппированное?"
L["Move Quantity Settings"] = "Настройки перемещения"
L["MOVE TO BAGS"] = "Положить в сумки"
L["MOVE TO BANK"] = "Положить в банк"
L["MOVING"] = "Перемещение"
L["Moving"] = "Перемещение"
L["Multiple Items"] = "Разные предметы"
L["My Auctions"] = "Мои лоты"
L["My Auctions 'CANCEL' Button"] = "Кнопка «Отмена» моих лотов"
L["Neat Stacks only?"] = "Только полные стаки?"
L["NEED MATS"] = "Нужны мат."
L["New Group"] = "Новая группа"
L["New Operation"] = "Новая операция"
L["NEWS AND INFORMATION"] = "Новости и информация"
L["No Attachments"] = "Нет вложений"
--[[Translation missing --]]
L["No Crafts"] = "No Crafts"
L["No Data"] = "Нет данных"
L["No group selected"] = "Выберите группу"
L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "Не указан предмет. Введите: /tsm restock_help [ITEM_LINK]"
L["NO ITEMS"] = "Нет предметов"
L["No Materials to Gather"] = "Список сбора материалов пуст"
L["No Operation Selected"] = "Выберите операцию"
L["No posting."] = "Нет лотов на аукционе"
L["No Profession Opened"] = "Профессия не открыта"
L["No Profession Selected"] = "Выберите профессию"
L["No profile specified. Possible profiles: '%s'"] = "Не выбран профиль. Возможные профили: '%s'"
L["No recent AuctionDB scan data found."] = "Нет последних данных сканирования AuctionDB."
L["No Sound"] = "Без звука"
L["None"] = "Нет"
L["None (Always Show)"] = "Нет (всегда отображать)"
L["None Selected"] = "Ничего не выбрано"
L["NONGROUP TO BANK"] = "Без группы в банк"
L["Normal"] = "Обычный"
L["Not canceling auction at reset price."] = "Не отменять лот для сброса цены."
L["Not canceling auction below min price."] = "Не отменять лот ниже минимальной цены."
L["Not canceling."] = "Не отменяется."
--[[Translation missing --]]
L["Not Connected"] = "Not Connected"
L["Not enough items in bags."] = "Не хватает предметов в сумках."
L["NOT OPEN"] = "Не открыто"
L["Not Scanned"] = "Не сканировано"
--[[Translation missing --]]
L["Nothing to move."] = "Nothing to move."
L["NPC"] = "НПС"
L["Number Owned"] = "Имеется"
L["of"] = "по"
L["Offline"] = "Оффлайн"
L["On Cooldown"] = "Восстанавливается"
L["Only show craftable"] = "Есть материалы"
L["Only show items with disenchant value above custom price"] = "Показывать предметы только где стоимость распыления выше индивидуальной цены"
L["OPEN"] = "Открыть"
L["OPEN ALL MAIL"] = "Открыть все письма"
L["Open Mail"] = "Открыть письмо"
L["Open Mail Complete Sound"] = "Звук после открытия всех писем"
L["Open Task List"] = "Открыть список задач"
L["Operation"] = "Операция"
L["Operations"] = "Операции"
L["Other Character"] = "Другой персонаж"
L["Other Settings"] = "Другие настройки"
L["Other Shopping Searches"] = "Другие варианты поиска"
L["Override default craft value method?"] = "Свой метод расчёта стоимости:"
L["Override parent operations"] = "Отменить родительские операции"
L["Parent Items"] = "Предметы родительской группы"
L["Past 7 Days"] = "За последние 7 дней"
L["Past Day"] = "За последний день"
L["Past Month"] = "За последний месяц"
L["Past Year"] = "За последний год"
L["Paste string here"] = "Вставьте «строку импорта» сюда"
L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Вставьте «строку импорта» в поле и нажмите «Импорт». Предметы в строке разделяются запятой. Вы можете импортировать целые структуры групп и операций."
L["Per Item"] = "За шт"
L["Per Stack"] = "За стак"
L["Per Unit"] = "За единицу"
L["Player Gold"] = "Золото игрока"
L["Player Invite Accept"] = "Игрок принял приглашение"
L["Please select a group to export"] = "Выберите группу для экспорта"
L["POST"] = "Выставить"
L["Post at Maximum Price"] = "Выставить по максимальной цене"
L["Post at Minimum Price"] = "Выставить по минимальной цене"
L["Post at Normal Price"] = "Выставить по норм. цене"
L["POST CAP TO BAGS"] = "Заполнить сумки"
L["Post Scan"] = "Скан. для продажи"
L["POST SELECTED"] = "Выставить выбранное"
L["POSTAGE"] = "Почтовый сбор"
L["Postage"] = "Почтовый сбор"
L["Posted at whitelisted player's price."] = "Выставить по цене игрока из белого списка."
L["Posted Auctions %s:"] = "Активные лоты %s:"
L["Posting"] = "Продажа"
L["Posting %d / %d"] = "Выставить %d / %d"
L["Posting %d stack(s) of %d for %d hours."] = "Выставить стаки: %d по %d на %d ч."
L["Posting at normal price."] = "Выставить по нормальной цене."
L["Posting at whitelisted player's price."] = "Выставить по цене игрока из белого списка."
L["Posting at your current price."] = "Выставить по текущей цене."
L["Posting disabled."] = "Выставление отключено."
L["Posting Settings"] = "Параметры продажи"
--[[Translation missing --]]
L["Posts"] = "Posts"
L["Potential"] = "Потенциал"
--[[Translation missing --]]
L["Price Per Item"] = "Price Per Item"
L["Price Settings"] = "Настройки цены"
L["PRICE SOURCE"] = "ИСТОЧНИК ЦЕН"
L["Price source with name '%s' already exists."] = "Источник цены с названием \"%s\" уже существует."
L["Price Variables"] = "Переменная цены"
L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Переменные позволяют создавать продвинутые индивидуальные цены. Вы сможете использовать эти переменные так же, как и встроенные источники цен, такие как «vendorsell» и «vendorbuy»."
L["PROFESSION"] = "ПРОФЕССИЯ"
L["Profession Filters"] = "Фильтр рецептов"
--[[Translation missing --]]
L["Profession Info"] = "Profession Info"
L["Profession loading..."] = "Профессия загружается..."
L["Professions Used In"] = "Используется в профессиях"
L["Profile changed to '%s'."] = "Профиль изменён на '%s'."
L["Profiles"] = "Профили"
L["PROFIT"] = "ПРИБЫЛЬ"
L["Profit"] = "Прибыль"
L["Prospect Value"] = "Стоимость просеивания"
L["PURCHASE DATA"] = "Данные о покупке"
L["Purchased (Min/Avg/Max Price)"] = "Куплено (Мин./Ср./Макс. цена)"
L["Purchased (Total Price)"] = "Куплено (Общая цена)"
L["Purchases"] = "Покупки"
--[[Translation missing --]]
L["Purchasing Auction"] = "Purchasing Auction"
L["Qty"] = "Кол."
L["Quantity Bought:"] = "Сколько куплено:"
L["Quantity Sold:"] = "Сколько продано:"
L["Quantity to move:"] = "Кол-во перемещаемого:"
L["Quest Added"] = "Добавлено задание"
L["Quest Completed"] = "Задание выполнено"
L["Quest Objectives Complete"] = "Цели задания выполнены"
L["QUEUE"] = "В очередь"
L["Quick Sell Options"] = "Настройки быстрой продажи"
L["Quickly mail all excess disenchantable items to a character"] = "Быстрая отправка лишних предметов, которые можно распылить"
L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Быстрая отправка лишнего золота сверх указанного в поле лимита"
L["Raid Warning"] = "Предупреждение рейда"
L["Read More"] = "Подробнее"
L["Ready Check"] = "Проверка готовности"
L["Ready to Cancel"] = "Готово для отмены"
L["Realm Data Tooltips"] = "Данные сервера"
L["Recent Scans"] = "Недавние сканирования"
L["Recent Searches"] = "Последние поисковые запросы"
L["Recently Mailed"] = "Последние получ."
L["RECIPIENT"] = "ПОЛУЧАТЕЛЬ"
L["Region Avg Daily Sold"] = "Ежедневно покупают по региону"
L["Region Data Tooltips"] = "Данные региона"
L["Region Historical Price"] = "Историческая цена по региону"
L["Region Market Value Avg"] = "Ср. рыночная стоимость по региону"
L["Region Min Buyout Avg"] = "Ср. минимальная цена по региону"
L["Region Sale Avg"] = "Ср. цена продажи по региону"
L["Region Sale Rate"] = "Шанс продажи по региону"
L["Reload"] = "Перезагрузить"
--[[Translation missing --]]
L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
L["Removed a total of %s old records."] = "Удалено старых записей: %s"
--[[Translation missing --]]
L["Rename"] = "Rename"
--[[Translation missing --]]
L["Rename Profile"] = "Rename Profile"
L["REPAIR"] = "Ремонт"
L["Repair Bill"] = "Счёт за ремонт"
--[[Translation missing --]]
L["Replace duplicate operations?"] = "Replace duplicate operations?"
L["REPLY"] = "Повтор"
L["REPORT SPAM"] = "Жалоба на спам"
L["Repost Higher Threshold"] = "Порог для выставления дороже:"
L["Required Level"] = "Требуемый уровень"
L["REQUIRED LEVEL RANGE"] = "Диапазон требуемых уровней"
L["Requires TSM Desktop Application"] = "Требуется TSM Desktop Application"
L["Resale"] = "Перепродажа"
L["RESCAN"] = "Пересканировать"
L["RESET"] = "Сброс"
L["Reset All"] = "Сбросить всё"
L["Reset Filters"] = "Сбросить"
L["Reset Profile Confirmation"] = "Сбросить подтверждение профиля"
L["RESTART"] = "Перезапуск"
L["Restart Delay (minutes)"] = "Время перезагрузки (в минутах)"
L["RESTOCK BAGS"] = "Пополнить сумки"
L["Restock help for %s:"] = "Помощь в пополнении запасов %s:"
L["Restock Quantity Settings"] = "Настройки пополнения запасов"
L["Restock quantity:"] = "Пополнение запасов:"
L["RESTOCK SELECTED GROUPS"] = "Пополнить запасы предметов из выбранных групп"
L["Restock Settings"] = "Настройки пополнения запасов"
L["Restock target to max quantity?"] = "Пополнить до макс. количества?"
L["Restocking to %d."] = "Пополнить до %d."
L["Restocking to a max of %d (min of %d) with a min profit."] = "Пополнить до макс. из %d (мин. %d) с мин. прибылью."
L["Restocking to a max of %d (min of %d) with no min profit."] = "Пополнить до макс. из %d (мин. %d) без мин. прибыли."
L["RESTORE BAGS"] = "Заполнить сумки"
L["Resume Scan"] = "Продолжить скан."
L["Retrying %d auction(s) which failed."] = "Снова пробуем выставить лот %d."
L["Revenue"] = "Доходы"
L["Round normal price"] = "Округление нормальной цены"
L["RUN ADVANCED ITEM SEARCH"] = "Запустить расширенный поиск"
L["Run Bid Sniper"] = "«Снайпер» по ставкам"
L["Run Buyout Sniper"] = "«Снайпер» на выкуп"
L["RUN CANCEL SCAN"] = "Сканировать для отмены"
L["RUN POST SCAN"] = "Сканировать для продажи"
L["RUN SHOPPING SCAN"] = "Сканировать для покупки"
L["Running Sniper Scan"] = "Запущено сканирование «Снайпер»"
L["Sale"] = "Продажа"
L["SALE DATA"] = "Данные о продаже"
--[[Translation missing --]]
L["Sale Price"] = "Sale Price"
L["Sale Rate"] = "Шанс продажи"
L["Sales"] = "Продажи"
L["SALES"] = "Продажи"
L["Sales Summary"] = "Сводка продаж"
L["SCAN ALL"] = "Сканировать все"
L["Scan Complete Sound"] = "Звук окончания сканирования"
L["Scan Paused"] = "Сканирование на паузе"
L["SCANNING"] = "Сканирование"
L["Scanning %d / %d (Page %d / %d)"] = "Сканирование %d / %d (Страница %d / %d)"
L["Scroll wheel direction:"] = "Направление колеса мыши:"
L["Search"] = "Поиск"
L["Search Bags"] = "Искать в сумках"
L["Search Groups"] = "Поиск группы"
L["Search Inbox"] = "Поиск в почте"
L["Search Operations"] = "Поиск операции"
L["Search Patterns"] = "Поиск по рецептам"
L["Search Usable Items Only?"] = "Искать только используемые предметы?"
L["Search Vendor"] = "Поиск у торговца"
L["Select a Source"] = "Выберите источник"
L["Select Action"] = "Выберите действие"
L["Select All Groups"] = "Выбрать все группы"
L["Select All Items"] = "Выбрать всё"
L["Select Auction to Cancel"] = "Выберите лот для отмены"
L["Select crafter"] = "Выберите крафтера"
L["Select custom price sources to include in item tooltips"] = "Выберите источник пользовательской цены для показа в подсказке"
L["Select Duration"] = "Выбрать длительность"
L["Select Items to Add"] = "Выберите предметы для добавления"
L["Select Items to Remove"] = "Выберите предметы для удаления"
L["Select Operation"] = "Выбрать операцию"
L["Select professions"] = "Выбрать профессии"
L["Select which accounting information to display in item tooltips."] = "Выберите, какую информацию показывать в подсказке предмета."
L["Select which auctioning information to display in item tooltips."] = "Выберите, какую информацию показывать в подсказке предмета."
L["Select which crafting information to display in item tooltips."] = "Выберите, какую информацию об изготовлении показывать в подсказке предмета."
L["Select which destroying information to display in item tooltips."] = "Выберите, какую информацию показывать в подсказке предмета."
L["Select which shopping information to display in item tooltips."] = "Выберите, какую информацию показывать в подсказке предмета."
L["Selected Groups"] = "Выбранные группы"
L["Selected Operations"] = "Выбранные операции"
L["Sell"] = "Продать"
L["SELL ALL"] = "Продать всё"
L["SELL BOES"] = "Продать BoE"
L["SELL GROUPS"] = "Продать группы"
L["Sell Options"] = "Настройки продажи"
L["Sell soulbound items?"] = "Продавать персональные предметы"
L["Sell to Vendor"] = "Продать торговцу"
L["SELL TRASH"] = "Продать хлам"
L["Seller"] = "Продавец"
L["Selling soulbound items."] = "Продажа персональных предметов."
L["Send"] = "Отправка"
L["SEND DISENCHANTABLES"] = "Отправить распыляемое"
L["Send Excess Gold to Banker"] = "Отправка лишнего золота"
L["SEND GOLD"] = "Отправить золото"
L["Send grouped items individually"] = "Отправлять сгруппированные предметы поштучно"
L["SEND MAIL"] = "Отправить"
L["Send Money"] = "Отправить деньги"
--[[Translation missing --]]
L["Send Profile"] = "Send Profile"
L["SENDING"] = "Отправка"
L["Sending %s individually to %s"] = "Отправка %s поштучно для %s"
L["Sending %s to %s"] = "Отправка %s для %s"
L["Sending %s to %s with a COD of %s"] = "Отправка %s для %s с наложенным платежом %s"
L["Sending Settings"] = "Настройки отправки"
--[[Translation missing --]]
L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
L["SENDING..."] = "Отправка..."
L["Set auction duration to:"] = "Длительность аукциона:"
L["Set bid as percentage of buyout:"] = "Ставка в процентах от цены выкупа:"
L["Set keep in bags quantity?"] = "Сколько оставить в сумках?"
L["Set keep in bank quantity?"] = "Сколько оставить в банке?"
L["Set Maximum Price:"] = "Максимальная цена:"
L["Set maximum quantity?"] = "Установить макс. количество?"
L["Set Minimum Price:"] = "Минимальная цена:"
L["Set minimum profit?"] = "Установить мин. прибыль?"
L["Set move quantity?"] = "Установить сколько перемещать?"
L["Set Normal Price:"] = "Укажите нормальную цену:"
L["Set post cap to:"] = "Сколько лотов выставлять:"
L["Set posted stack size to:"] = "Установить размер стака:"
--[[Translation missing --]]
L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
L["Set stack size?"] = "Set stack size?"
L["Setup"] = "Настройка"
L["SETUP ACCOUNT SYNC"] = "Синхронизировать аккаунт"
L["Shards"] = "Осколки"
L["Shopping"] = "Покупка"
L["Shopping 'BUYOUT' Button"] = "Кнопка «Выкупить» при покупке"
L["Shopping for auctions including those above the max price."] = "Покупка лотов с ценой, выше максимальной."
L["Shopping for auctions with a max price set."] = "Покупка лотов с максимальной ценой."
L["Shopping for even stacks including those above the max price"] = "Покупка полных стаков с ценой, выше максимальной"
L["Shopping for even stacks with a max price set."] = "Покупка полных стаков с максимальной ценой."
L["Shopping Tooltips"] = "Подсказки о покупке"
L["SHORTFALL TO BAGS"] = "Недостаточно в сумках"
L["Show auctions above max price?"] = "Показать лоты выше макс. цены?"
--[[Translation missing --]]
L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
L["Show Description"] = "Показать описание"
L["Show Destroying frame automatically"] = "Показывать окно уничтожения автоматически"
L["Show material cost"] = "Показать стоимость материалов"
L["Show on Modifier"] = "Модификатор для показа подсказки"
L["Showing %d Mail"] = "Показано писем: %d"
L["Showing %d of %d Mail"] = "Показано писем: %d из %d"
L["Showing %d of %d Mails"] = "Показано писем: %d из %d"
L["Showing all %d Mails"] = "Показаны все письма: %d"
L["Simple"] = "Простой"
L["SKIP"] = "Пропуск"
--[[Translation missing --]]
L["Skip Import confirmation?"] = "Skip Import confirmation?"
L["Skipped: No assigned operation"] = "Пропущено: Нет связанной операции"
L["Slash Commands:"] = "Команды:"
--[[Translation missing --]]
L["Sniper"] = "Sniper"
L["Sniper 'BUYOUT' Button"] = "Кнопка «Выкупить» в режиме «Снайпер»"
L["Sniper Options"] = "Настройки режима «Снайпер»"
L["Sniper Settings"] = "Настройки режима «Снайпер»"
L["Sniping items below a max price"] = "Предметы «Снайпера» ниже макс. цены"
L["Sold"] = "Продан"
--[[Translation missing --]]
L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
L["Sold %s worth of items."] = "Продано %s предметов."
L["Sold (Min/Avg/Max Price)"] = "Продано (Мин./Ср./Макс. цена)"
L["Sold (Total Price)"] = "Продано (Общая цена)"
L["Sold [%s]x%d for %s to %s"] = "Продано [%s]x%d для %s %s"
L["Sold Auctions %s:"] = "Проданные лоты %s:"
L["Source"] = "Источник"
L["SOURCE %d"] = "Источник %d"
L["SOURCES"] = "ИСТОЧНИКИ"
L["Sources"] = "Источники"
L["Sources to include for restock:"] = "Учитывать при пополнении:"
L["Stack"] = "Стак"
L["Stack / Quantity"] = "Стаков / шт. в стаке"
L["Stack size multiple:"] = "Размер стака:"
L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Запустите режим «Снайпер», используя кнопки «Ставка» или «Выкуп»."
L["Starting Scan..."] = "Запуск сканирования..."
L["STOP"] = "Стоп"
L["Store operations globally"] = "Глобальные операции, общие для всех профилей"
L["Subject"] = "Тема"
L["SUBJECT"] = "ТЕМА"
--[[Translation missing --]]
L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
L["Switch to %s"] = "Переключиться на %s"
L["Switch to WoW UI"] = "К интерфейсу WoW"
L["Sync Setup Error: The specified player on the other account is not currently online."] = "Ошибка синхронизации: Выбранный игрок на другой учетной записи в настоящий момент не в сети."
L["Sync Setup Error: This character is already part of a known account."] = "Ошибка синхронизации: Этот персонаж уже является частью известной учетной записи."
L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Ошибка синхронизации: Вы ввели имя текущего персонажа, а не персонажа другой учётной записи."
--[[Translation missing --]]
L["Sync Status"] = "Sync Status"
L["TAKE ALL"] = "Взять всё"
L["Take Attachments"] = "Прикрепить вложения"
L["Target Character"] = "Имя персонажа"
L["TARGET SHORTFALL TO BAGS"] = "Этого в сумках недостаточно"
L["Tasks Added to Task List"] = "Задача добавлена в ваш список"
L["Text (%s)"] = "Текст (%s)"
L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "Фильтр canlearn игнорировался, поскольку аддон CanIMogIt не был найден."
L["The 'Craft Value Method' (%s) did not return a value for this item."] = "Метод расчета стоимости крафта (%s) не вернул значение для этого предмета."
L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "Цена 'disenchant' была заменена общим источником цен 'destroy'. Обновите свои индивидуальные цены."
L["The min profit (%s) did not evalulate to a valid value for this item."] = "Минимальная прибыль (%s) не определена для этого предмета."
L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "Название может содержать ТОЛЬКО буквы. Без пробелов, чисел или символов."
L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "В очередь поставлено (%d) меньше мин. значения пополнения (%d)."
L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "Операция для этого предмета не верна. Мин. запас %d больше макс. запаса %d."
L["The player \"%s\" is already on your whitelist."] = "Игрок \"%s\" уже в белом списке."
L["The profit of this item (%s) is below the min profit (%s)."] = "Прибыль от предмета (%s) это ниже мин. прибыли (%s)"
L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "Сервер не вернул имя продавца с самым дешёвым лотом %s. Предмет пропущен."
--[[Translation missing --]]
L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "Неизвестный фильтр был проигнорирован, т.к. аддон CanIMogIt не найден."
--[[Translation missing --]]
L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Некорректное имя профиля. Имя должно содержать хотя бы один символ и не содержать специальные символы."
L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "У предмета нет цены создания. Проверьте чтобы все материалы имели цену."
L["This item is not in a TSM group."] = "Этот предмет не в группе TSM."
--[[Translation missing --]]
L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
L["This looks like an exported operation and not a custom price."] = "Это выглядит как экспортированная операция, а не как индивидуальная цена."
L["This will copy the settings from '%s' into your currently-active one."] = "Хотите скопировать все настройки из «%s» в текущий активный профиль?"
L["This will permanently delete the '%s' profile."] = "Хотите навсегда удалить профиль «%s»?"
L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "Это удалит все группы и операции (не сохраняющиеся глобально) из этого профиля."
L["Time"] = "Время"
L["Time Format"] = "Формат времени"
L["Time Frame"] = "Когда"
L["TIME FRAME"] = "КОГДА"
L["TINKER"] = "Быстрый ремонт"
L["Tooltip Price Format"] = "Формат цен в подсказке"
L["Tooltip Settings"] = "Подсказки"
L["Top Buyers:"] = "Лучший покупатель:"
L["Top Item:"] = "Лучший предмет:"
L["Top Sellers:"] = "Лучший продавец:"
L["Total"] = "Итого"
L["Total Gold"] = "Всего золота"
--[[Translation missing --]]
L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
L["Total Gold Earned:"] = "Всего золота получено:"
L["Total Gold Spent:"] = "Всего золота потрачено:"
L["Total Price"] = "Общая цена"
L["Total Profit:"] = "Общая прибыль:"
L["Total Value"] = "Общая стоимость"
--[[Translation missing --]]
L["Total Value of All Items"] = "Total Value of All Items"
L["Track Sales / Purchases via trade"] = "Отслеживать продажи / покупки через торговлю"
L["TradeSkillMaster Info"] = "Информация TSM"
L["Transform Value"] = "Стоимость трансформации"
L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
L["TSM Crafting"] = "TSM Crafting"
L["TSM Destroying"] = "TSM Destroying"
L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM не имеет никаких данных цен AuctionDB для вашего игрового мира. Мы рекомендуем вам скачать TSM Приложение |cff99ffffhttp://tradeskillmaster.com|r чтобы автоматически обновлять ваши данные AuctionDB (и автоматически делать резервные копии ваших настроек TSM)"
L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM не смог просканировать некоторые лоты. Запустите новое сканирование."
--[[Translation missing --]]
L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "В TSM отсутствует важная информация из TSM Desktop Application. Убедитесь, что эта программа запущена и правильно настроена."
L["TSM Mailing"] = "TSM Почта"
L["TSM TASK LIST"] = "TSM Список задач"
L["TSM Vendoring"] = "TSM Торговля"
L["TSM Version Info:"] = "Информация о версии TSM:"
L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting обнаружил, что вы поменяли %s %s на %s. Хотите, чтобы Accounting сделал запись об этом обмене?"
L["TSM4"] = "TSM4"
--[[Translation missing --]]
L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
L["TUJ 3-Day Price"] = "3-х дневная цена из TUJ"
--[[Translation missing --]]
L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
L["TUJ Global Median"] = "TUJ Global Median"
L["Twitter Integration"] = "Интеграция с Twitter"
L["Twitter Integration Not Enabled"] = "Интеграция с Twitter не включена"
L["Type"] = "Тип"
L["Type Something"] = "Ищите по названию предметов"
L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Невозможно импортировать потому что выбранная группа (%s) больше не существует. Попробуйте еще раз."
L["Unbalanced parentheses."] = "Незакрытые скобки."
L["Undercut amount:"] = "Снижать цену на:"
L["Undercut by whitelisted player."] = "Перебито игроком из белого списка."
L["Undercutting blacklisted player."] = "Сбивать цену игроков из черного списка."
L["Undercutting competition."] = "Сбиваем цену конкурентов."
L["Ungrouped Items"] = "Предметы без группы"
L["Unknown Item"] = "Неизвестный предмет"
L["Unwrap Gift"] = "Развернуть подарок"
L["Up"] = "Вверх"
--[[Translation missing --]]
L["Up to date"] = "Up to date"
L["UPDATE EXISTING MACRO"] = "Обновить существующий макрос"
--[[Translation missing --]]
L["Updating"] = "Updating"
L["Usage: /tsm price <ItemLink> <Price String>"] = "Использование: /tsm price <Предмет> <Цена>"
L["Use smart average for purchase price"] = "Использовать умную усредненную цену для покупки"
L["Use the field below to search the auction house by filter"] = "Для поиска на аукционе используйте поле ниже"
L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Выберите группы в списке слева и настройте экспорт операций, связанных с ними. При импорте структура групп сохранится."
L["VALUE PRICE SOURCE"] = "Источник цены"
L["ValueSources"] = "Источники цен"
L["Variable Name"] = "Имя переменной"
L["Vendor"] = "Торговец"
L["Vendor Buy Price"] = "Покупка у торговца"
L["Vendor Search"] = "Поиск для продажи торговцу"
L["VENDOR SEARCH"] = "Поиск для продажи торговцу"
L["Vendor Sell"] = "Продажа торговцу"
L["Vendor Sell Price"] = "Продажа торговцу"
L["Vendoring 'SELL ALL' Button"] = "Кнопка «Продать всё» торговцу"
L["View ignored items in the Destroying options."] = "Показать игнорируемые предметы в настройках уничтожения."
L["Warehousing"] = "Хранение"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в сумках > банка/гбанка, %d когда в банке/гбанке > сумок."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в сумках > банка/гбанка, %d когда в банке/гбанке > сумок. Пополнение запасов оставит %d предметов в сумках."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в сумках > банка/гбанка."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в сумках > банка/гбанка. Пополнение запасов оставит %d предметов в сумках."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в банке/гбанке > сумок."
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в банке/гбанке > сумок. Пополнение запасов оставит %d предметов в сумках."
L["Warehousing will move a max of %d of each item in this group."] = "Склад переместит макс. %d предметов из группы."
L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Склад переместит макс. %d предметов из группы. Пополнение запасов оставит %d предметов в сумках."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в сумках > банка/гбанка, %d когда в банке/гбанке > сумок."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в сумках > банка/гбанка, %d когда в банке/гбанке > сумок. Пополнение запасов оставит %d предметов в сумках."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в сумках > банка/гбанка."
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в сумках > банка/гбанка. Пополнение запасов оставит %d предметов в сумках."
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в банке/гбанке > сумок."
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в банке/гбанке > сумок. Пополнение запасов оставит %d предметов в сумках."
L["Warehousing will move all of the items in this group."] = "Склад будет перемещать все предметы из группы."
L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Склад будет перемещать все предметы из группы. Пополнение запасов оставит %d в сумках."
L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "ВНИМАНИЕ: Макрос был слишком длинным, поэтому он обрезан игрой."
L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "ВНИМАНИЕ: Ваша минимальная цена для %s ниже, чем продажа предмета торговцу (с учётом сбивания цены на аукционе). Советуем увеличить минимальную цену или продать предмет торговцу."
L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Добро пожаловать в TSM4! Все старые модули из TSM3 (Crafting, Shopping и т.д.) теперь встроены в основной TSM аддон, поэтому вам нужен только TSM и установленный TSM_AppHelper. TSM отключил старые модули и требует перезагрузки."
L["When above maximum:"] = "Когда выше максимума:"
L["When below minimum:"] = "Когда ниже минимума:"
L["Whitelist"] = "Белый список"
L["Whitelisted Players"] = "Добавление игроков в белый список"
L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "У вас уже достаточно этих предметов. У вас есть %d, а максимально вам нужно %d"
L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "Используйте настройки ниже для очистки старых данных. Мы рекомендуем периодически чистить данные, чтобы модуль статистики работал исправно. Выберите минимальное количество дней, которое нужно удалить, затем нажмите '%s'."
L["You cannot use %s as part of this custom price."] = "Вы не можете использовать %s как часть индивидуальной цены."
L["You cannot use %s within convert() as part of this custom price."] = "Вы не можете использовать %s без convert() как часть этой индивидуальной цены."
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "Вам не нужно добавлять «%s», альты попадают в белый список автоматически."
L["You don't know how to craft this item."] = "Вы не умеете создавать этот предмет."
L["You must reload your UI for these settings to take effect. Reload now?"] = "Вы должны перезагрузить свой интерфейс, чтобы эти настройки вступили в силу. Перезагрузить сейчас?"
L["You won an auction for %sx%d for %s"] = "Вы выиграли лот %sx%d за %s"
L["Your auction has not been undercut."] = "Ваш лот не перебит."
L["Your auction of %s expired"] = "Время вашего лота %s истекло"
L["Your auction of %s has sold for %s!"] = "Ваш лот %s был продан за %s!"
L["Your Buyout"] = "Выкуп"
L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Ваш метод расчета стоимости крафта для '%s' не верен, поэтому был использован метод по умолчанию. Подробности: %s"
L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Ваш метод определения стоимости создания был некорректен поэтому он был возвращен по умолчанию. Подробности: %s"
L["Your task list is currently empty."] = "Ваш список задач пуст."
L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Из-за ошибки на стороне Blizzard аукцион перестал работать. Закройте и снова откройте аукцион и перезапустите «Снайпер»."
L["You've been undercut."] = "Вашу цену сбили."
	elseif locale == "zhCN" then
L = L or {}
L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4组:组; 已选中 (%d |4物品:物品;)"
L["%d auctions"] = "%d拍卖"
L["%d Groups"] = "%d分组"
L["%d Items"] = "%d物品"
L["%d of %d"] = "发布%d堆，每堆%d个"
L["%d Operations"] = "%d操作"
L["%d Posted Auctions"] = "已发布%d个物品"
L["%d Sold Auctions"] = "%d个物品已卖出"
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s 背包, %s 银行, %s 拍卖行, %s 邮件)"
L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s 玩家, %s 小号, %s 公会, %s 拍卖行)"
L["%s (%s profit)"] = "%s (%s利润)"
L["%s |4operation:operations;"] = "%s |4操作:操作;"
L["%s ago"] = "%s之前"
L["%s Crafts"] = "%s专业"
L["%s group updated with %d items and %d materials."] = "%s分组已更新%d件和%d件材料"
L["%s in guild vault"] = "公会仓库中 %s"
L["%s is a valid custom price but %s is an invalid item."] = "%s 是一个有效的自定义价格但 %s 是一个无效的物品。"
L["%s is a valid custom price but did not give a value for %s."] = "%s 是一个有效的自定义价格但没有为 %s 给出一个值。"
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s'是一个无效的操作! 因为最小补货数量%d超过最高补货数量%d。"
L["%s is not a valid custom price and gave the following error: %s"] = "%s 不是一个有效的自定义价格,错误信息: %s"
L["%s Operations"] = "%s 操作"
L["%s previously had the max number of operations, so removed %s."] = "%s 预先配置了最大数量，所以移除 %s"
L["%s removed."] = "移除 %s 。"
L["%s sent you %s"] = "%s邮寄给你 %s"
L["%s sent you %s and %s"] = "%s邮寄给你 %s 和 %s"
L["%s sent you a COD of %s for %s"] = "%s给你发送付费邮件%s以 %s 的价格"
L["%s sent you a message: %s"] = "%s 发送给你一条消息：%s"
L["%s total"] = "共计%s"
L["%sDrag%s to move this button"] = "%s按住 %s 以拖动此按钮"
L["%sLeft-Click%s to open the main window"] = "%s左键单击%s打开主窗口"
L["(%d/500 Characters)"] = "(%d/500 个角色)"
L["(max %d)"] = "(最高%d)"
L["(max 5000)"] = "(最多5000)"
L["(min %d - max %d)"] = "(最低 %d - 最高 %d)"
L["(min 0 - max 10000)"] = "(最低 0 - 最高 10000)"
L["(minimum 0 - maximum 20)"] = "(最低 0 - 最高 20)"
L["(minimum 0 - maximum 2000)"] = "(最低 0 - 最高 2000)"
L["(minimum 0 - maximum 905)"] = "(最低 0 - 最高 905)"
L["(minimum 0.5 - maximum 10)"] = "(最低 0.5 - 最高 10)"
L["/tsm help|r - Shows this help listing"] = "/tsm help - 显示此帮助列表"
L["/tsm|r - opens the main TSM window."] = "/tsm - 打开 TSM 主窗口。"
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000重要通知:|r TSM_Accounting在本服务器最后的存储数据对WOW来说太大了，旧的数据将被自动删除以避免损坏已保存的参数。最后的 %s 购买数据已保留。"
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000重要通知:|r 当 TSM_Accounting 在本服务器最后的存储数据对 WOW 来说太大难以处理,旧的数据将被削减以避免损坏已保存的参数. 最后的 %s 出售数据已保存"
L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839左键点击|r 临时忽略物品。按住|cffffd839Shift|r 左键点击永久忽略物品。你可以在Vendoring设置中从永久忽略列表中移除物品"
L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839左键点击|r临时忽略物品。"
L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift+左键|r永久忽略物品。"
L["1 Group"] = "1 组."
L["1 Item"] = "1 项"
L["12 hr"] = "12 小时"
L["24 hr"] = "24 小时"
L["48 hr"] = "48 小时"
L["A custom price of %s for %s evaluates to %s."] = "%s的自定义价格为%s到%s。"
L["A maximum of 1 convert() function is allowed."] = "最多允许1兑换函数。"
L["A profile with that name already exists on the target account. Rename it first and try again."] = "目标账号上已存在同名档案。请在重新命名后重试。"
L["A profile with this name already exists."] = "已存在同名档案。"
L["A scan is already in progress. Please stop that scan before starting another one."] = "扫描已在进行中。请先停止该扫描然后再开始另一扫描。"
L["Above max expires."] = "超过上限会过期。"
L["Above max price. Not posting."] = "高于最高价。不发布。"
L["Above max price. Posting at max price."] = "超出最高价。以最高价发布。"
L["Above max price. Posting at min price."] = "超出最高价。以最低价发布。"
L["Above max price. Posting at normal price."] = "高于最高价。以正常价格发布。"
L["Accepting these item(s) will cost"] = "接受这些物品将花费"
L["Accepting this item will cost"] = "接受此项目将花费"
L["Account sync removed. Please delete the account sync from the other account as well."] = "帐户同步已删除, 请同时从其他帐户中删除帐户同步."
L["Account Syncing"] = "账务同步"
L["Accounting"] = "会计"
L["Accounting Tooltips"] = "会计工具提示"
L["Activity Type"] = "活动类型"
L["ADD %d ITEMS"] = "添加%d物品"
L["Add / Remove Items"] = "添加/删除项目"
L["ADD NEW CUSTOM PRICE SOURCE"] = "添加新的自定义价格来源"
L["ADD OPERATION"] = "添加操作"
L["Add Player"] = "添加玩家"
L["Add Subject / Description"] = "添加主题/描述"
L["Add Subject / Description (Optional)"] = "添加主题/描述（可选）"
L["ADD TO MAIL"] = "加入邮件"
L["Added '%s' profile which was received from %s."] = "添加了从%s收到的'%s'个人资料。"
L["Added %s to %s."] = "增加 %s 到 %s."
L["Additional error suppressed"] = "已阻止的其他错误"
L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "调整以下设置以设置如何拍卖与该操作关联的组。"
L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "调整以下设置以设置如何取消此操作的组。"
L["Adjust the settings below to set how groups attached to this operation will be priced."] = "调整以下设置以设置添加到此操作分组组的定价方式。"
L["Advanced Item Search"] = "高级项目搜索"
L["Advanced Options"] = "高级选项"
L["AH"] = "拍卖行"
L["AH (Crafting)"] = "拍卖行（制造业）"
L["AH (Disenchanting)"] = "拍卖行（分解）"
L["AH BUSY"] = "拍卖行繁忙"
L["AH Frame Options"] = "拍卖行框架选项"
L["Alarm Clock"] = "闹钟"
L["All Auctions"] = "所有拍卖"
L["All Characters and Guilds"] = "所有角色和专精"
L["All Item Classes"] = "所有物品类别"
L["All Professions"] = "所有专业"
L["All Subclasses"] = "所有子类别"
L["Allow partial stack?"] = "允许部分堆叠"
L["Alt Guild Bank"] = "小号工会银行"
L["Alts"] = "小号"
L["Alts AH"] = "小号AH"
L["Amount"] = "数量"
L["AMOUNT"] = "数量"
L["Amount of Bag Space to Keep Free"] = "可用的背包剩余空间"
L["APPLY FILTERS"] = "应用过滤器"
L["Apply operation to group:"] = "将操作应用于组："
L["Are you sure you want to clear old accounting data?"] = "确定清除旧的账务数据吗？"
L["Are you sure you want to delete this group?"] = "你确定要删除这个分组吗？"
L["Are you sure you want to delete this operation?"] = "你确定要删除这个操作吗？"
L["Are you sure you want to reset all operation settings?"] = "确定要重置操作设置吗？"
L["At above max price and not undercut."] = "高于最高价格且未被压价。"
L["At normal price and not undercut."] = "处于正常价格且未被压价。"
L["Auction"] = "拍卖"
L["Auction Bid"] = "竞标价格"
L["Auction Buyout"] = "拍卖买断"
L["AUCTION DETAILS"] = "拍卖细节"
L["Auction Duration"] = "拍卖时效"
L["Auction has been bid on."] = "已被竞标。"
L["Auction House Cut"] = "拍卖打折"
L["Auction Sale Sound"] = "拍卖声音"
L["Auction Window Close"] = "拍卖窗口关闭"
L["Auction Window Open"] = "拍卖窗口打开"
L["Auctionator - Auction Value"] = "Auctionator - 拍卖价格"
L["AuctionDB - Market Value"] = "AuctionDB-市场价值"
L["Auctioneer - Appraiser"] = "Auctioneer - 估价"
L["Auctioneer - Market Value"] = "Auctioneer - 市场价"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - 最低一口价"
L["Auctioning"] = "拍卖"
L["Auctioning Log"] = "拍卖日志"
L["Auctioning Operation"] = "拍卖操作"
L["Auctioning 'POST'/'CANCEL' Button"] = "拍卖 '发布'/'取消' 按钮"
L["Auctioning Tooltips"] = "拍卖工具提示"
L["Auctions"] = "拍卖"
L["Auto Quest Complete"] = "自动完成任务"
L["Average Earned Per Day:"] = "每日平均收入："
L["Average Prices:"] = "平均价："
L["Average Profit Per Day:"] = "每日平均利润："
L["Average Spent Per Day:"] = "每日平均花费："
L["Avg Buy Price"] = "平均买入价"
L["Avg Resale Profit"] = "平均转卖利润"
L["Avg Sell Price"] = "平均卖出价"
L["BACK"] = "返回"
L["BACK TO LIST"] = "返回列表"
L["Back to List"] = "返回列表"
L["Bag"] = "背包"
L["Bags"] = "背包"
L["Banks"] = "银行"
L["Base Group"] = "基础分组"
L["Base Item"] = "基础物品"
L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "以下是按模块分类的当前可用价格来源。您将在自定义价格框中输入%skey|r。"
L["Below custom price:"] = "低于自定义价格："
L["Below min price. Posting at max price."] = "低于最低价。按最高价发布。"
L["Below min price. Posting at min price."] = "低于最低价。按最低价发布。"
L["Below min price. Posting at normal price."] = "低于最低价。按正常价发布。"
L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "以下，您可以管理您的配置文件，这些配置文件允许您拥有完全不同的分组。"
L["BID"] = "竞拍"
L["Bid %d / %d"] = "竞拍%d / %d"
L["Bid (item)"] = "竞拍（物品）"
L["Bid (stack)"] = "竞拍（堆叠）"
L["Bid Price"] = "竞拍价格"
L["Bid Sniper Paused"] = "狙击竞价暂停"
L["Bid Sniper Running"] = "运行狙击竞标"
L["Bidding Auction"] = "竞标拍卖"
L["Blacklisted players:"] = "黑名单玩家:"
L["Bought"] = "买入"
L["Bought %d of %s from %s for %s"] = "从%d向%s购买了%s，共%s"
L["Bought %sx%d for %s from %s"] = "买入 %sx%d 为 %s 从 %s"
L["Bound Actions"] = "限制操作"
L["BUSY"] = "繁忙"
L["BUY"] = "购买"
L["Buy"] = "购买"
L["Buy %d / %d"] = "购买%d / %d"
L["Buy %d / %d (Confirming %d / %d)"] = "购买 %d / %d (确认 %d / %d)"
L["Buy from AH"] = "从拍卖行购买"
L["Buy from Vendor"] = "从NPC购买"
L["BUY GROUPS"] = "购买分组"
L["Buy Options"] = "购买选项"
L["BUYBACK ALL"] = "全部回购"
L["Buyer/Seller"] = "购买者/出售者"
L["BUYOUT"] = "一口价"
L["Buyout (item)"] = "一口价（物品）"
L["Buyout (stack)"] = "一口价（堆叠）"
L["Buyout Confirmation Alert"] = "一口价确认提醒"
L["Buyout Price"] = "一口价"
L["Buyout Sniper Paused"] = "狙击购买已暂停"
L["Buyout Sniper Running"] = "狙击购买中"
L["BUYS"] = "购买"
L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "默认情况下，此分组中的所有物品不能分配到分组中。此分组无法删除。"
L["Cancel auctions with bids"] = "取消已被竞标的拍卖"
L["Cancel Scan"] = "取消扫描"
L["Cancel to repost higher?"] = "取消并以更高价发布？"
L["Cancel undercut auctions?"] = "取消被压价的拍卖？"
L["Canceling"] = "取消"
L["Canceling %d / %d"] = "取消%d / %d"
L["Canceling %d Auctions..."] = "取消%d拍卖..."
L["Canceling all auctions."] = "取消全部拍卖。"
L["Canceling auction which you've undercut."] = "取消被压价的拍卖。"
L["Canceling disabled."] = "取消禁用"
L["Canceling Settings"] = "取消设置"
L["Canceling to repost at higher price."] = "取消并以更高价格发布。"
L["Canceling to repost at reset price."] = "取消并以转卖价发布。"
L["Canceling to repost higher."] = "取消并以更高价发布。"
L["Canceling undercut auctions and to repost higher."] = "取消被压价拍卖并以更高价发布。"
L["Canceling undercut auctions."] = "取消被压价拍卖。"
L["Cancelled"] = "已取消"
L["Cancelled auction of %sx%d"] = "取消%sx%d的拍卖"
L["Cancelled Since Last Sale"] = "自上次售出之后取消拍卖"
L["CANCELS"] = "取消"
L["Cannot repair from the guild bank!"] = "无法从公会银行修理"
L["Can't load TSM tooltip while in combat"] = "战斗中不能载入TSM鼠标提示"
L["Cash Register"] = "收银台"
L["CHARACTER"] = "角色"
L["Character"] = "角色"
L["Chat Tab"] = "聊天标签"
L["Cheapest auction below min price."] = "低于最低价的拍卖。"
L["Clear"] = "清除"
L["Clear All"] = "清除所有"
L["CLEAR DATA"] = "清除数据"
L["Clear Filters"] = "清除筛选"
L["Clear Old Data"] = "清除旧数据"
L["Clear Old Data Confirmation"] = "清除旧数据确认"
L["Clear Queue"] = "清除队列"
L["Clear Selection"] = "取消选择"
L["COD"] = "付费邮件"
L["Coins (%s)"] = "(%s) 金币"
L["Collapse All Groups"] = "折叠所有群组"
L["Combine Partial Stacks"] = "合并堆叠"
L["Combining..."] = "合并中..."
L["Configuration Scroll Wheel"] = "配置滚轮"
L["Confirm"] = "确认"
L["Confirm Complete Sound"] = "确认完成音效"
L["Confirming %d / %d"] = "确认%d / %d"
L["Connected to %s"] = "已连接 %s..."
L["Connecting to %s"] = "正在连接到%s"
L["CONTACTS"] = "联络"
L["Contacts Menu"] = "联络菜单"
L["Cooldown"] = "冷却"
L["Cooldowns"] = "冷却"
L["Cost"] = "成本"
L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "无法创建宏，因为你的宏已经满了。删除一些宏后重试。"
L["Could not find profile '%s'. Possible profiles: '%s'"] = "找不到配置文件 '%s' 。可能是配置文件 '%s' 。"
L["Could not sell items due to not having free bag space available to split a stack of items."] = "由于没有可用于分割一组堆叠物品的空余背包空间，因此无法出售物品"
L["Craft"] = "制造"
L["CRAFT"] = "制造"
L["Craft (Unprofitable)"] = "制造（无利润的）"
L["Craft (When Profitable)"] = "制造（有利润时）"
L["Craft All"] = "制造所有"
L["CRAFT ALL"] = "制造所有"
L["Craft Name"] = "制造品名称"
L["CRAFT NEXT"] = "制作下一个"
L["Craft value method:"] = "计算制造成本的方法："
L["CRAFTER"] = "制造者"
L["CRAFTING"] = "制造"
L["Crafting"] = "制造"
L["Crafting Cost"] = "制造成本"
L["Crafting 'CRAFT NEXT' Button"] = "制造\"制造下一个\"按钮"
L["Crafting Queue"] = "制造队列"
L["Crafting Tooltips"] = "制造鼠标提示"
L["Crafts"] = "制造"
L["Crafts %d"] = "制造%d"
L["CREATE MACRO"] = "创建宏"
L["Create New Operation"] = "创建新的操作"
L["CREATE NEW PROFILE"] = "创建新的配置"
L["Create Profession Group"] = "创建专业分组"
L["Created custom price source: |cff99ffff%s|r"] = "创建的自定义价格来源：|cff99ffff%s|r"
L["Crystals"] = "水晶"
L["Current Profiles"] = "当前配置档"
L["CURRENT SEARCH"] = "当前搜索"
L["CUSTOM POST"] = "自定义发布"
L["Custom Price"] = "自定义价格"
L["Custom Price Source"] = "自定义价格来源"
L["Custom Sources"] = "自定义源"
L["Database Sources"] = "数据库源"
L["Default Craft Value Method:"] = "默认制造价函数："
L["Default Material Cost Method:"] = "默认材料价函数："
L["Default Price"] = "默认价格"
L["Default Price Configuration"] = "默认价格配置"
L["Define what priority Gathering gives certain sources."] = "定义资源获取优先级"
L["Delete Profile Confirmation"] = "删除配置档确认"
L["Delete this record?"] = "删除此记录？"
L["Deposit"] = "寄存"
L["Deposit Cost"] = "寄存费"
L["Deposit Price"] = "寄存价"
L["DEPOSIT REAGENTS"] = "存储虚空物品"
L["Deselect All Groups"] = "取消选择所有分组"
L["Deselect All Items"] = "取消所有物品"
L["Destroy Next"] = "分解下一个"
L["Destroy Value"] = "分解价值"
L["Destroy Value Source"] = "分解价来源"
L["Destroying"] = "分解"
L["Destroying 'DESTROY NEXT' Button"] = "分解\"分解下一个\"按钮"
L["Destroying Tooltips"] = "分解鼠标提示"
L["Destroying..."] = "分解中"
L["Details"] = "细节"
L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "未取消%s，因为取消重新发布门槛(%s)无效。 检查您的设置."
L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "未取消%s，因为最高价(%s)无效。 检查您的设置。"
--[[Translation missing --]]
L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "未取消%s，因为最低价(%s)无效。 检查您的设置。"
L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "未取消%s，因为正常价(%s)无效。 检查您的设置。"
L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "未取消%s，因为您的正常价格(%s)低于最低价格(%s)。检查您的设置。"
L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "未取消%s因为你的底价 (%s) 无效。请检查你的设置。"
L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "未发布%s，因为暴雪未提供必要的信息,请重试"
L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "未发布%s，因为最低拍卖的拥有者(%s)同时出现在黑名单和白名单上，这是不允许的。 调整您的设置以更正此问题。"
L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "未发布%s，不允许您或您的角色(%s)在黑名单。 请从黑名单中删除。"
L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "未发布%s,因为最高价(%s) 无效,请检查您的设置."
L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "未发布%s，因为您的最高价格（%s）低于最低价格（%s）。检查您的设置。"
L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "由于您的最低价格（%s）无效，因此未发布%s。检查您的设置。"
L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "未发布%s,因为正常价(%s) 无效,请检查您的设置."
L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "未发布%s,因为正常价(%s) 低于最低价(%s),请检查您的设置."
L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "未发布%s因为你的压价(%s) 无效。请检查你的设置。"
L["Disable invalid price warnings"] = "禁用无效价格提醒"
L["Disenchant Search"] = "分解搜索"
L["DISENCHANT SEARCH"] = "分解搜索"
L["Disenchant Search Options"] = "分解搜索选项"
L["Disenchant Value"] = "分解值"
L["Disenchanting Options"] = "分解选项"
L["Display auctioning values"] = "显示拍卖价值"
L["Display cancelled since last sale"] = "显示被取消的"
L["Display crafting cost"] = "显示制造成本"
L["Display detailed destroy info"] = "显示详细的分解信息"
L["Display disenchant value"] = "显示分解价值"
L["Display expired auctions"] = "显示过期的拍卖"
L["Display group name"] = "显示分组名称"
L["Display historical price"] = "显示历史价"
L["Display market value"] = "显示市场价"
L["Display mill value"] = "显示研磨价"
L["Display min buyout"] = "显示最低一口价"
L["Display Operation Names"] = "显示操作名称"
L["Display prospect value"] = "显示预期价格"
L["Display purchase info"] = "显示购买信息"
L["Display region historical price"] = "显示区域历史价格"
L["Display region market value avg"] = "显示区域市场平均价格"
L["Display region min buyout avg"] = "显示区域最低平均一口价"
L["Display region sale avg"] = "显示区域出售平均"
L["Display region sale rate"] = "显示区域出售比例"
L["Display region sold per day"] = "显示区域每天出售"
L["Display sale info"] = "显示出售信息"
L["Display sale rate"] = "显示出售比例"
L["Display shopping max price"] = "显示购买最高价"
L["Display total money recieved in chat?"] = "曲线图显示收到的所有金币"
L["Display transform value"] = "显示转化价值"
L["Display vendor buy price"] = "显示NPC购买价"
L["Display vendor sell price"] = "显示NPC出售价"
L["Doing so will also remove any sub-groups attached to this group."] = "此操作还会删除附加到该组的所有子组"
L["Done Canceling"] = "取消完成"
L["Done Posting"] = "发布完成"
L["Done rebuilding item cache."] = "完成项目缓存重建。"
L["Done Scanning"] = "扫描完成"
L["Don't post after this many expires:"] = "在过期这个数量后不要发布："
L["Don't Post Items"] = "不发布物品"
L["Don't prompt to record trades"] = "请勿立即记录交易"
L["DOWN"] = "向下"
L["Drag in Additional Items (%d/%d Items)"] = "拖拽添加物品(%d/%d 物品)"
L["Drag Item(s) Into Box"] = "把要准备发送的物品拖到此框内"
L["Duplicate"] = "重复"
L["Duplicate Profile Confirmation"] = "重复的配置文件确认"
L["Dust"] = "尘"
L["Elevate your gold-making!"] = "提升你的gold-making!"
L["Embed TSM tooltips"] = "嵌入TSM鼠标提示"
L["EMPTY BAGS"] = "清空背包"
L["Empty parentheses are not allowed"] = "不允许清空括号"
L["Empty price string."] = "清空价格字符串。"
L["Enable automatic stack combination"] = "启用自动堆叠整理"
L["Enable buying?"] = "启用购买?"
L["Enable inbox chat messages"] = "开启对话框收件信息"
L["Enable restock?"] = "启用补货?"
L["Enable selling?"] = "启用出售?"
L["Enable sending chat messages"] = "开启对话框发件信息"
L["Enable TSM Tooltips"] = "启用TSM工具提示"
L["Enable tweet enhancement"] = "启用Tweet增强"
L["Enchant Vellum"] = "附魔羊皮纸"
L["Ensure both characters are online and try again."] = "确保两个人物都在线，然后重试。"
L["Enter a name for the new profile"] = "输入新配置文件的名称"
L["Enter Filter"] = "输入过滤名"
L["Enter Keyword"] = "输入关键字"
L["Enter name of logged-in character from other account"] = "输入已经登录的角色名"
L["Enter player name"] = "输入玩家姓名"
L["Essences"] = "精华"
L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "正在建立到 %s 的连接。确定你登陆过这个角色。"
L["Estimated Cost:"] = "预计成本:"
L["Estimated deliver time"] = "预计交货时间"
L["Estimated Profit:"] = "预计利润："
L["Exact Match Only?"] = "完全匹配?"
L["Exclude crafts with cooldowns"] = "忽略CD中的制造"
L["Expand All Groups"] = "展开所有群组"
L["Expenses"] = "支出"
L["EXPENSES"] = "支出"
L["Expirations"] = "过期"
L["Expired"] = "到期的"
L["Expired Auctions"] = "过期的拍卖"
L["Expired Since Last Sale"] = "上次出售到期的"
L["Expires"] = "到期"
L["EXPIRES"] = "到期"
L["Expires Since Last Sale"] = "自上次销售起过期"
L["Expiring Mails"] = "过期邮件"
L["Exploration"] = "探测"
L["Export"] = "导出"
L["Export List"] = "导出列表"
L["Failed Auctions"] = "拍卖失败"
L["Failed Since Last Sale (Expired/Cancelled)"] = "上次出售失败的(到期/取消)"
L["Failed to bid on auction of %s (x%s) for %s."] = "无法为%s的%s（x%s）竞标出价。"
L["Failed to bid on auction of %s."] = "竞标%s失败"
L["Failed to buy auction of %s (x%s) for %s."] = "失败用%s购买%s(x%s)的拍卖"
L["Failed to buy auction of %s."] = "购买%s失败"
L["Failed to find auction for %s, so removing it from the results."] = "查找%s失败,已经从结果移除"
L["Failed to post %sx%d as the item no longer exists in your bags."] = "无法发布%sx%d，因为该物品不存在于您的背包中。"
L["Failed to send profile."] = "无法发送个人资料。"
L["Failed to send profile. Ensure both characters are online and try again."] = "无法发送个人资料。确保两个人物都在线，然后重试。"
L["Favorite Scans"] = "收藏的扫描"
L["Favorite Searches"] = "收藏的搜索"
L["Filter Auctions by Duration"] = "按持续时间过滤拍卖"
L["Filter Auctions by Keyword"] = "按关键字过滤拍卖"
L["Filter by Keyword"] = "按关键字过滤"
L["FILTER BY KEYWORD"] = "按关键字过滤."
L["Filter group item lists based on the following price source"] = "根据以下价格源过滤分组物品"
L["Filter Items"] = "过滤物品"
L["Filter Shopping"] = "筛选购物"
L["Finding Selected Auction"] = "查找选定的拍卖"
L["Fishing Reel In"] = "钓鱼卷轴"
L["Forget Character"] = "遗忘角色"
L["Found auction sound"] = "找到拍卖音效"
L["Friends"] = "好友"
L["From"] = "从"
L["Full"] = "满了"
L["Garrison"] = "要塞"
L["Gathering"] = "收集"
L["Gathering Search"] = "采集搜索"
L["General Options"] = "常规选项"
L["Get from Bank"] = "从银行获得"
L["Get from Guild Bank"] = "从公会银行获得"
L["Global Operation Confirmation"] = "全局操作确认"
L["Gold"] = "金"
L["Gold Earned:"] = "赚取金币："
L["GOLD ON HAND"] = "背包中的金币"
L["Gold Spent:"] = "花费的金币："
L["GREAT DEALS SEARCH"] = "搜索有利润的物品"
L["Group already exists."] = "已存在的分组"
L["Group Management"] = "分组管理"
L["Group Operations"] = "分组操作"
L["Group Settings"] = "分组设置"
L["Grouped Items"] = "已分组的物品"
L["Groups"] = "分组"
L["Guild"] = "公会"
L["Guild Bank"] = "公会银行"
L["GVault"] = "公会银行"
L["Have"] = "拥有"
L["Have Materials"] = "拥有的材料"
L["Have Skill Up"] = "技能提升"
L["Hide auctions with bids"] = "隐藏已竞标的"
L["Hide Description"] = "隐藏描述"
L["Hide minimap icon"] = "隐藏小地图图标"
L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "隐藏TSM银行界面,输入/tsm bankui 可重新打开"
L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "隐藏TSM 任务列表UI,输入/tsm tasklist 可重新打开"
L["High Bidder"] = "高出价者"
L["Historical Price"] = "历史价格"
L["Hold ALT to repair from the guild bank."] = "按住 ALT 键进行公会修理"
L["Hold shift to move the items to the parent group instead of removing them."] = "按住shift键将项目移至父分组，而不是将其删除。"
L["Hr"] = "小时"
L["Hrs"] = "小时"
--[[Translation missing --]]
L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "我只卖了%s的[%s]！%s #TSM4 #warcraft"
L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "如果您不想压价一个玩家，可以将它添加到白名单中，TSM将不会压价它。 请注意，如果您的白名单中的某人与您的买断匹配但列出较低的出价，TSM仍会对它们进行压价。"
L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "如果您有多个配置文件建立了'操作'， 授权这个会导致除当前配置文件以外的所有的'操作'永久丢失，您确定要继续吗？"
L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "如果您拥有WoW的Twitter集成设置，TSM将为其增强的拍卖销售/购买消息添加共享链接，以及用TSM链接替换URL。"
L["Ignore Auctions Below Min"] = "忽略最低价以下的拍卖"
L["Ignore auctions by duration?"] = "按持续时间忽略拍卖？"
L["Ignore Characters"] = "忽略角色"
L["Ignore Guilds"] = "忽略公会"
L["Ignore item variations?"] = "忽略商品变化？"
L["Ignore operation on characters:"] = "忽略对角色的操作:"
L["Ignore operation on faction-realms:"] = "在阵营-服务器忽略操作："
L["Ignored Cooldowns"] = "忽略冷却"
L["Ignored Items"] = "忽略物品"
L["ilvl"] = "物品等级"
L["Import"] = "导入"
L["IMPORT"] = "导入"
L["Import %d Items and %s Operations?"] = "导入%d物品和%s操作?"
L["Import Groups & Operations"] = "导入分组&操作"
L["Imported Items"] = "已导入物品"
L["Inbox Settings"] = "收件设置"
L["Include Attached Operations"] = "包括附件操作"
L["Include operations?"] = "包括操作?"
L["Include soulbound items"] = "包括灵魂绑定物品"
L["Information"] = "信息"
L["Invalid custom price entered."] = "输入的自定义价格无效"
L["Invalid custom price source for %s. %s"] = "无效的自定义价格源%s. %s"
L["Invalid custom price."] = "无效的自定义价格。"
L["Invalid function."] = "无效功能。"
L["Invalid gold value."] = "无效的价格。"
L["Invalid group name."] = "无效分组名"
L["Invalid import string."] = "导入的字符串无效。"
L["Invalid item link."] = "无效的物品链接。"
L["Invalid operation name."] = "无效操作名"
L["Invalid operator at end of custom price."] = "无效的操作者自定义价格。"
L["Invalid parameter to price source."] = "无效的价格来源参数。"
L["Invalid player name."] = "无效玩家名"
L["Invalid price source in convert."] = "转换价格来源无效。"
L["Invalid price source."] = "无效价格来源"
L["Invalid search filter"] = "无效的搜索过滤器。"
L["Invalid seller data returned by server."] = "服务器返回无效的出售数据"
L["Invalid word: '%s'"] = "无效的单词：'%s'"
L["Inventory"] = "仓库"
L["Inventory / Gold Graph"] = "商品清单/金币图表"
L["Inventory / Mailing"] = "库存/邮寄"
L["Inventory Options"] = "库存设置"
L["Inventory Tooltip Format"] = "库存工具提示格式"
L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "你似乎在账号间手动复制了SavedVariables，导致TSM的自动同步无法工作。你需要撤销此更改，并且/或者关闭魔兽世界后删除这些账号的TSM SavedVariables来修复此问题。"
L["Item"] = "物品"
L["ITEM CLASS"] = "物品种类"
L["Item Level"] = "物品等级"
L["ITEM LEVEL RANGE"] = "物品等级区间"
L["Item links may only be used as parameters to price sources."] = "物品链接仅可用来参考价格来源。"
L["Item Name"] = "物品名称"
L["Item Quality"] = "物品品质"
L["ITEM SEARCH"] = "物品搜索"
L["ITEM SELECTION"] = "项目选择"
L["ITEM SUBCLASS"] = "物品子类"
L["Item Value"] = "物品价格"
L["Item/Group is invalid (see chat)."] = "物品/分组无效(查看聊天框)"
L["ITEMS"] = "物品"
L["Items"] = "物品"
L["Items in Bags"] = "背包中的物品"
L["Keep in bags quantity:"] = "保持背包数量"
L["Keep in bank quantity:"] = "保持银行数量:"
L["Keep posted:"] = "保持已发布的:"
L["Keep quantity:"] = "保持数量:"
L["Keep this amount in bags:"] = "将此数量保存在背包"
L["Keep this amount:"] = "持有数量"
L["Keeping %d."] = "持有%d."
L["Keeping undercut auctions posted."] = "保留被压数量"
L["Last 14 Days"] = "14日内"
L["Last 3 Days"] = "3日内"
L["Last 30 Days"] = "30日内"
L["LAST 30 DAYS"] = "30日内"
L["Last 60 Days"] = "60日内"
L["Last 7 Days"] = "7日内"
L["LAST 7 DAYS"] = "7日内"
L["Last Data Update:"] = "上次数据更新："
L["Last Purchased"] = "上次购买"
L["Last Sold"] = "上次售出"
L["Level Up"] = "等级上升"
L["LIMIT"] = "限制"
L["Link to Another Operation"] = "关联到另一个操作"
L["List"] = "列表"
L["List materials in tooltip"] = "鼠标提示显示材料"
L["Loading Mails..."] = "正在读取邮件 ……"
L["Loading..."] = "读取中 ……"
L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "TradeSkillMaster似乎发生了一个错误。请按以下所示说明来帮助作者修正这个错误。"
L["Loop detected in the following custom price:"] = "以下自定义价格循环检测："
L["Lowest auction by whitelisted player."] = "最低价的拍卖为白名单玩家"
L["Macro created and scroll wheel bound!"] = "已建立宏并且绑定鼠标滚轮！"
L["Macro Setup"] = "宏设置"
L["Mail"] = "邮件"
L["Mail Disenchantables"] = "邮寄可分解物品"
L["Mail Disenchantables Max Quality"] = "邮寄最大数量可分解物品"
L["MAIL SELECTED GROUPS"] = "邮递所选分组"
L["Mail to %s"] = "邮寄给 %s"
L["Mailing"] = "邮寄"
L["Mailing all to %s."] = "全部邮寄至 %s"
L["Mailing Options"] = "邮递选项"
L["Mailing up to %d to %s."] = "邮寄%d给%s"
L["Main Settings"] = "主设置"
L["Make Cash On Delivery?"] = "货到对方付款"
L["Management Options"] = "管理选项"
L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "TSM中的许多常用操作可以添加到宏并绑定到滚轮。 使用下面的选项设置宏和滚轮绑定。"
L["Map Ping"] = "地图Ping"
L["Market Value"] = "市场价格"
L["Market Value Price Source"] = "市场价来源"
L["Market Value Source"] = "市场价格来源"
L["Mat Cost"] = "原料花费"
L["Mat Price"] = "原料价格"
L["Match stack size?"] = "匹配堆叠数?"
L["Match whitelisted players"] = "匹配白名单玩家"
L["Material Name"] = "材料名称"
L["Materials"] = "材料"
L["Materials to Gather"] = "要收集的材料"
L["MAX"] = "最大"
L["Max Buy Price"] = "最高买入价"
L["MAX EXPIRES TO BANK"] = "银行最大到期日"
L["Max Sell Price"] = "最高卖价"
L["Max Shopping Price"] = "最高购买价"
L["Maximum amount already posted."] = "已发布最大数量"
L["Maximum Auction Price (Per Item)"] = "最高发布价(每件价格,不是每组)"
L["Maximum Destroy Value (Enter '0c' to disable)"] = "最高分解价值(输入 0c 禁用)"
L["Maximum disenchant level:"] = "最高分解等级:"
L["Maximum Disenchant Quality"] = "最高分解品质"
L["Maximum disenchant search percentage:"] = "最高分解比例"
L["Maximum Market Value (Enter '0c' to disable)"] = "最高市场价(输入 0c 禁用)"
L["MAXIMUM QUANTITY TO BUY:"] = "最大购买数量"
L["Maximum quantity:"] = "最大数量"
L["Maximum restock quantity:"] = "最大补货数量"
L["Mill Value"] = "邮递价格"
L["Min"] = "最小"
L["Min Buy Price"] = "最低买入价"
L["Min Buyout"] = "最低一口价"
L["Min Sell Price"] = "最低卖价"
L["Min/Normal/Max Prices"] = "最低/正常/最高 价格"
L["Minimum Days Old"] = "最小天数"
L["Minimum disenchant level:"] = "最低分解等级:"
L["Minimum expires:"] = "最短过期"
L["Minimum profit:"] = "最低利润"
L["MINIMUM RARITY"] = "最低品质"
L["Minimum restock quantity:"] = "最小补货数量"
L["Misplaced comma"] = "错误的分隔逗号"
L["Missing Materials"] = "缺少的材料"
L["Missing operator between sets of parenthesis"] = "括号之间缺少运算符"
L["Modifiers:"] = "编辑器："
L["Money Frame Open"] = "金钱框架打开"
L["Money Transfer"] = "金币交易量"
L["Most Profitable Item:"] = "有利润的物品"
L["MOVE"] = "移动"
L["Move already grouped items?"] = "移动在分组中的物品?"
L["Move Quantity Settings"] = "移动数量设置"
L["MOVE TO BAGS"] = "移到背包"
L["MOVE TO BANK"] = "移到银行"
L["MOVING"] = "移动中"
L["Moving"] = "移动中"
L["Multiple Items"] = "多个物品"
L["My Auctions"] = "我的拍卖"
L["My Auctions 'CANCEL' Button"] = "我的拍卖\"取消\"按钮"
L["Neat Stacks only?"] = "只移动整组"
L["NEED MATS"] = "需要材料"
L["New Group"] = "新的分组"
L["New Operation"] = "新操作"
L["NEWS AND INFORMATION"] = "新闻和信息"
L["No Attachments"] = "没有附件"
L["No Crafts"] = "没有专业物品"
L["No Data"] = "没有数据"
L["No group selected"] = "未选择分组"
L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "未物品指定。 用法：/tsm restock help [物品链接]"
L["NO ITEMS"] = "没有物品"
L["No Materials to Gather"] = "没有材料来收集"
L["No Operation Selected"] = "未选择操作"
L["No posting."] = "未发布"
L["No Profession Opened"] = "未打开专业"
L["No Profession Selected"] = "未选择专业"
L["No profile specified. Possible profiles: '%s'"] = "无指定配置。可能配置：'%s'"
L["No recent AuctionDB scan data found."] = "未找到AuctionDB扫描数据。"
L["No Sound"] = "无声"
L["None"] = "无"
L["None (Always Show)"] = "无（总是显示）"
L["None Selected"] = "未选择"
L["NONGROUP TO BANK"] = "未分组到银行"
L["Normal"] = "常规"
L["Not canceling auction at reset price."] = "不取消位于转卖价格的拍卖"
L["Not canceling auction below min price."] = "低于最低价格时不取消拍卖"
L["Not canceling."] = "未取消"
L["Not Connected"] = "未连接"
L["Not enough items in bags."] = "背包物品不足"
L["NOT OPEN"] = "未打开"
L["Not Scanned"] = "未扫描的"
L["Nothing to move."] = "没有可移动物品"
L["NPC"] = "NPC"
L["Number Owned"] = "拥有的数量"
L["of"] = "的"
L["Offline"] = "离线"
L["On Cooldown"] = "冷却中"
L["Only show craftable"] = "只显示可制作的"
L["Only show items with disenchant value above custom price"] = "只显示具有高于自定义价格的分解价值的商品"
L["OPEN"] = "打开"
L["OPEN ALL MAIL"] = "打开所有邮件"
L["Open Mail"] = "打开邮件"
L["Open Mail Complete Sound"] = "打开邮箱声音"
L["Open Task List"] = "打开任务列表"
L["Operation"] = "操作"
L["Operations"] = "操作"
L["Other Character"] = "其他角色"
L["Other Settings"] = "其他设置"
L["Other Shopping Searches"] = "其他Shopping 搜索"
L["Override default craft value method?"] = "覆盖默认制造价值参数"
L["Override parent operations"] = "覆盖父操作"
L["Parent Items"] = "父项目"
L["Past 7 Days"] = "过去七天"
L["Past Day"] = "昨天的"
L["Past Month"] = "过去一个月的"
L["Past Year"] = "过去一年的"
L["Paste string here"] = "在此粘贴字符串"
L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "将导入字符串粘贴到下面的字段中，然后点“导入”。 您可以导入任务物品到所有分组&操作结构到整个组和操作结构的所有内容（请逗号分隔）。"
L["Per Item"] = "每个物品"
L["Per Stack"] = "每组"
L["Per Unit"] = "每个"
L["Player Gold"] = "玩家金币"
L["Player Invite Accept"] = "接受玩家邀请"
L["Please select a group to export"] = "请选择一个分组来导出"
L["POST"] = "发布"
L["Post at Maximum Price"] = "以最高价发布"
L["Post at Minimum Price"] = "以最低价发布"
L["Post at Normal Price"] = "以正常价格发布"
L["POST CAP TO BAGS"] = "发布上限到背包"
L["Post Scan"] = "发布扫描"
L["POST SELECTED"] = "发布选择的"
L["POSTAGE"] = "邮费"
L["Postage"] = "邮费"
L["Posted at whitelisted player's price."] = "以白名单玩家价格发布"
L["Posted Auctions %s:"] = "发布的拍卖%s:"
L["Posting"] = "发布中"
L["Posting %d / %d"] = "发布中 %d / %d"
L["Posting %d stack(s) of %d for %d hours."] = "发布%d个堆叠的%d，持续时间为%d小时"
L["Posting at normal price."] = "以正常价发布"
L["Posting at whitelisted player's price."] = "正在以白名单玩家价格发布"
L["Posting at your current price."] = "正在以当前价格发布"
L["Posting disabled."] = "发布禁用"
L["Posting Settings"] = "发布设置"
L["Posts"] = "发布量"
L["Potential"] = "潜在"
L["Price Per Item"] = "单价"
L["Price Settings"] = "价格设置"
L["PRICE SOURCE"] = "价格来源"
L["Price source with name '%s' already exists."] = "价格来源名称 '%s' 已经存在"
L["Price Variables"] = "价格变量"
L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "价格变量允许您创建更高级的自定义价格，以便在整个插件中使用。 您将能够以与使用内置价格来源相同的方式使用这些新变量，例如'vendorsell'和'vendorbuy'"
L["PROFESSION"] = "专业"
L["Profession Filters"] = "专业过滤"
L["Profession Info"] = "专业信息"
L["Profession loading..."] = "专业加载中..."
L["Professions Used In"] = "涉及专业"
L["Profile changed to '%s'."] = "变更成'%s'配置。"
L["Profiles"] = "配置档"
L["PROFIT"] = "利润"
L["Profit"] = "利润"
L["Prospect Value"] = "预期价格"
L["PURCHASE DATA"] = "购买数据"
L["Purchased (Min/Avg/Max Price)"] = "购买（最小/平均/最高价)"
L["Purchased (Total Price)"] = "购买(总价)"
L["Purchases"] = "购买数量"
L["Purchasing Auction"] = "采购"
L["Qty"] = "数量"
L["Quantity Bought:"] = "买入数量"
L["Quantity Sold:"] = "售出数量"
L["Quantity to move:"] = "移动数量"
L["Quest Added"] = "任务已添加"
L["Quest Completed"] = "任务已完成"
L["Quest Objectives Complete"] = "任务目标完成"
L["QUEUE"] = "队列"
L["Quick Sell Options"] = "快速出售选项"
L["Quickly mail all excess disenchantable items to a character"] = "快速将所有多余的可分解物品邮寄给角色"
L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "快速将所有多余的金币（限制在一定数量）邮寄给角色"
L["Raid Warning"] = "副本警告"
L["Read More"] = "阅读更多"
L["Ready Check"] = "准备好检查"
L["Ready to Cancel"] = "准备取消"
L["Realm Data Tooltips"] = "鼠标提示阵营数据"
L["Recent Scans"] = "最近的扫描"
L["Recent Searches"] = "最近的搜索"
L["Recently Mailed"] = "最近的邮递"
L["RECIPIENT"] = "接受者"
L["Region Avg Daily Sold"] = "服务器平均每日出售"
L["Region Data Tooltips"] = "鼠标提示服务器数据"
L["Region Historical Price"] = "服务器历史价格"
L["Region Market Value Avg"] = "服务器市场平均价"
L["Region Min Buyout Avg"] = "区域最低平均一口价"
L["Region Sale Avg"] = "服务器平均出售"
L["Region Sale Rate"] = "服务器成交率"
L["Reload"] = "重载"
L["REMOVE %d |4ITEM:ITEMS;"] = "删除 %d |4ITEM:ITEMS;"
L["Removed a total of %s old records."] = "总共删除了%s 旧记录"
L["Rename"] = "重命名"
L["Rename Profile"] = "重命名个人资料"
L["REPAIR"] = "修复"
L["Repair Bill"] = "修复账单"
L["Replace duplicate operations?"] = "替换重复的操作？"
L["REPLY"] = "回复"
L["REPORT SPAM"] = "举报垃圾信息"
L["Repost Higher Threshold"] = "重新以更高价发布"
L["Required Level"] = "请求的等级"
L["REQUIRED LEVEL RANGE"] = "要求的等级范围"
L["Requires TSM Desktop Application"] = "要求TSM 桌面App"
L["Resale"] = "转卖"
L["RESCAN"] = "重新扫描"
L["RESET"] = "重置"
L["Reset All"] = "重置所有"
L["Reset Filters"] = "重置过滤"
L["Reset Profile Confirmation"] = "重置配置确认"
L["RESTART"] = "重新开始"
L["Restart Delay (minutes)"] = "自动邮件重启延迟（分钟）"
L["RESTOCK BAGS"] = "补货背包"
L["Restock help for %s:"] = "补货帮助%s:"
L["Restock Quantity Settings"] = "补货数量设置"
L["Restock quantity:"] = "补货数量"
L["RESTOCK SELECTED GROUPS"] = "选择的补货分组"
L["Restock Settings"] = "补货设置"
L["Restock target to max quantity?"] = "对目标进行最大补货?"
L["Restocking to %d."] = "补货到%d"
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
L["RESTORE BAGS"] = "恢复背包"
L["Resume Scan"] = "恢复扫描"
L["Retrying %d auction(s) which failed."] = "重试失败的%d拍卖"
L["Revenue"] = "收益"
L["Round normal price"] = "正常价格附近"
L["RUN ADVANCED ITEM SEARCH"] = "运行高级物品搜索"
L["Run Bid Sniper"] = "运行狙击竞价"
L["Run Buyout Sniper"] = "运行狙击一口价"
L["RUN CANCEL SCAN"] = "取消扫描"
L["RUN POST SCAN"] = "发布扫描"
L["RUN SHOPPING SCAN"] = "购买扫描"
L["Running Sniper Scan"] = "运行狙击扫描"
L["Sale"] = "出售"
L["SALE DATA"] = "出售数据"
L["Sale Price"] = "销售价格"
L["Sale Rate"] = "成交率"
L["Sales"] = "出售"
L["SALES"] = "出售"
L["Sales Summary"] = "出售总览"
L["SCAN ALL"] = "取消所有"
L["Scan Complete Sound"] = "扫描完成声音"
L["Scan Paused"] = "扫描被暂停"
L["SCANNING"] = "正在扫描"
L["Scanning %d / %d (Page %d / %d)"] = "正在扫描第%d项/共%d项(第%d页/共%d页)"
L["Scroll wheel direction:"] = "滚轮方向"
L["Search"] = "搜索"
L["Search Bags"] = "搜索背包"
L["Search Groups"] = "搜索分组"
L["Search Inbox"] = "搜索收件箱"
L["Search Operations"] = "搜索操作"
L["Search Patterns"] = "搜索模式"
L["Search Usable Items Only?"] = "仅搜索可用物品"
L["Search Vendor"] = "搜索NPC"
L["Select a Source"] = "选择一个源"
L["Select Action"] = "选择操作"
L["Select All Groups"] = "选择所有分组"
L["Select All Items"] = "选择所有物品"
L["Select Auction to Cancel"] = "选择取消拍卖"
L["Select crafter"] = "选择制造者"
L["Select custom price sources to include in item tooltips"] = "选择要包含在提示中的自定义价格来源"
L["Select Duration"] = "选择持续时间"
L["Select Items to Add"] = "选择要添加的物品"
L["Select Items to Remove"] = "选择要移除的物品"
L["Select Operation"] = "选择操作"
L["Select professions"] = "选择专业"
L["Select which accounting information to display in item tooltips."] = "选择要显示物品提示的账目信息"
L["Select which auctioning information to display in item tooltips."] = "选择要显示物品提示的拍卖信息"
L["Select which crafting information to display in item tooltips."] = "选择要显示物品提示的制造信息"
L["Select which destroying information to display in item tooltips."] = "选择要显示物品提示的分解信息"
L["Select which shopping information to display in item tooltips."] = "选择要显示物品提示的购买信息"
L["Selected Groups"] = "选择的分组"
L["Selected Operations"] = "选择的操作"
L["Sell"] = "出售"
L["SELL ALL"] = "出售所有"
L["SELL BOES"] = "出售boe物品"
L["SELL GROUPS"] = "出售分组"
L["Sell Options"] = "出售选项"
L["Sell soulbound items?"] = "出售灵魂绑定的物品?"
L["Sell to Vendor"] = "卖给NPC"
L["SELL TRASH"] = "出售垃圾"
L["Seller"] = "出售者"
L["Selling soulbound items."] = "出售灵魂绑定物品"
L["Send"] = "发送"
L["SEND DISENCHANTABLES"] = "发送待分解的装备"
L["Send Excess Gold to Banker"] = "发送超额金币给银行角色"
L["SEND GOLD"] = "发送金币"
L["Send grouped items individually"] = "单独发送分组物品"
L["SEND MAIL"] = "发送邮件"
L["Send Money"] = "发送金币"
L["Send Profile"] = "发送资料"
L["SENDING"] = "发送中"
L["Sending %s individually to %s"] = "将%s单独发送到%s"
L["Sending %s to %s"] = "发送%s到%s"
L["Sending %s to %s with a COD of %s"] = "正在发送%s货到付款%s 给%s."
L["Sending Settings"] = "发送设置"
--[[Translation missing --]]
L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
L["SENDING..."] = "发送中..."
L["Set auction duration to:"] = "设置拍卖持续时间:"
L["Set bid as percentage of buyout:"] = "将出价设置为一口价的百分比"
L["Set keep in bags quantity?"] = "设置背包持有数量"
L["Set keep in bank quantity?"] = "设置银行持有数量"
L["Set Maximum Price:"] = "设置最高价:"
L["Set maximum quantity?"] = "设置最大数量"
L["Set Minimum Price:"] = "设置最低价:"
L["Set minimum profit?"] = "设置最低利润?"
L["Set move quantity?"] = "设置移动数量?"
L["Set Normal Price:"] = "设置正常价:"
L["Set post cap to:"] = "设置发布上限到:"
L["Set posted stack size to:"] = "设置发布堆叠数:"
L["Set stack size for restock?"] = "设置进货的堆栈大小？"
L["Set stack size?"] = "设定叠大小"
L["Setup"] = "建立"
L["SETUP ACCOUNT SYNC"] = "设置账户同步"
L["Shards"] = "碎片"
L["Shopping"] = "购买"
L["Shopping 'BUYOUT' Button"] = "购买 \"一口价\" 按钮"
L["Shopping for auctions including those above the max price."] = "购买拍卖品(包括那些高于最高价格的)"
L["Shopping for auctions with a max price set."] = "购买拍卖品(在最高价格限定下)"
L["Shopping for even stacks including those above the max price"] = "购买整组,忽视最高价格选定"
L["Shopping for even stacks with a max price set."] = "购买整组,在最高价格限定下"
L["Shopping Tooltips"] = "购买提示"
L["SHORTFALL TO BAGS"] = "背包里的物品不够"
L["Show auctions above max price?"] = "显示高于最高价格的拍卖品"
L["Show confirmation alert if buyout is above the alert price"] = "如果一口价超过警惕价格，则显示确认提醒"
L["Show Description"] = "显示描述"
L["Show Destroying frame automatically"] = "自动显示分解窗口"
L["Show material cost"] = "显示材料成本"
L["Show on Modifier"] = "在调节器中显示"
L["Showing %d Mail"] = "显示 %d 邮件"
L["Showing %d of %d Mail"] = "显示 %d / %d 封邮件"
L["Showing %d of %d Mails"] = "显示 %d / %d 封邮件"
L["Showing all %d Mails"] = "显示所有 %d 邮件"
L["Simple"] = "简单"
L["SKIP"] = "跳过"
L["Skip Import confirmation?"] = "跳过导入确认？"
L["Skipped: No assigned operation"] = "已跳过:无指定操作"
L["Slash Commands:"] = "指令列表："
L["Sniper"] = "狙击"
L["Sniper 'BUYOUT' Button"] = "狙击\"一口价\"按钮"
L["Sniper Options"] = "狙击选项"
L["Sniper Settings"] = "狙击设置"
L["Sniping items below a max price"] = "狙击物品低于最高价"
L["Sold"] = "卖出"
--[[Translation missing --]]
L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
L["Sold %s worth of items."] = "售出%s物品"
L["Sold (Min/Avg/Max Price)"] = "出售(最小/平均/最高价)"
L["Sold (Total Price)"] = "售出(总价):"
L["Sold [%s]x%d for %s to %s"] = "卖出 [%s]x%d 为 %s 到 %s"
L["Sold Auctions %s:"] = "已售出拍卖%s:"
L["Source"] = "来源"
L["SOURCE %d"] = "来源%d"
L["SOURCES"] = "来源"
L["Sources"] = "来源"
L["Sources to include for restock:"] = "包括补货来源"
L["Stack"] = "堆叠"
L["Stack / Quantity"] = "堆叠/数量"
L["Stack size multiple:"] = "堆叠大小数量"
L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "使用上面的按钮启动“一口价”或“竞标”狙击搜索"
L["Starting Scan..."] = "开始扫描..."
L["STOP"] = "停止"
L["Store operations globally"] = "全局保存操作"
L["Subject"] = "邮件主题"
L["SUBJECT"] = "主题"
L["Successfully sent your '%s' profile to %s!"] = "成功将您的“%s”个人资料发送到%s！"
L["Switch to %s"] = "切换到%s"
L["Switch to WoW UI"] = "切换到WOW界面"
L["Sync Setup Error: The specified player on the other account is not currently online."] = "同步设置错误：另一个账号中的指定角色不在线。"
L["Sync Setup Error: This character is already part of a known account."] = "同步设置错误：该角色已经在一个已知账号中。"
L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "同步设置错误：您输入了当前角色名而非其他账号下的角色名。"
L["Sync Status"] = "同步状态"
L["TAKE ALL"] = "提取所有"
L["Take Attachments"] = "提取附件"
L["Target Character"] = "目标角色"
L["TARGET SHORTFALL TO BAGS"] = "补货到背包"
L["Tasks Added to Task List"] = "添加到任务列表"
L["Text (%s)"] = "文本 (%s)"
L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "canlearn过滤被忽略，因为找不到CanIMogIt插件。"
L["The 'Craft Value Method' (%s) did not return a value for this item."] = "这个物品的制造价值算法(%s)没有返回数值"
L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "“分解”价格来源已经被通用“摧毁”价格来源重置。请更新自定义价格。"
L["The min profit (%s) did not evalulate to a valid value for this item."] = "最低利润（%s）未评估此物品的有效值"
L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "该名称只能包含字母。不能有空格，数字或特殊字符。"
L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "请求数量 (%d)小于最低重新补货数量 (%d)"
L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "应用于此物品的操作无效！ %d最小补货高于%d的最大补货。"
L["The player \"%s\" is already on your whitelist."] = "玩家\"%s\"已经在白名单中"
L["The profit of this item (%s) is below the min profit (%s)."] = "此物品的利润 (%s)低于最低利润(%s)"
L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "%s最低价卖家名未提交到服务器。忽略此物品"
L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "TradeSkillMaster_AppHelper插件已安装，但未启用。TSM已启用它，需要重新加载。"
L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "unlearned过滤被忽略，因为找不到CanIMogIt插件"
--[[Translation missing --]]
L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "这是一个非法的配置文件名。配置文件名必须至少有一个字符长度并且不包含@字符。"
L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "此物品没有制造成本。 检查所有材料是否有材料价格"
L["This item is not in a TSM group."] = "此物品不在TSM分组"
--[[Translation missing --]]
L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
L["This looks like an exported operation and not a custom price."] = "这看起来想一个导出操作而不是一个自定义价格。"
L["This will copy the settings from '%s' into your currently-active one."] = "将'%s'中的设置复制到当前活动的设置中。"
L["This will permanently delete the '%s' profile."] = "此操作将永久删除'%s'配置档"
L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "此操作将重置所有分组和操作（如果未全局保存）。"
L["Time"] = "时间"
L["Time Format"] = "时间格式"
L["Time Frame"] = "时限"
L["TIME FRAME"] = "时限"
L["TINKER"] = "修理"
L["Tooltip Price Format"] = "鼠标提示价格格式"
L["Tooltip Settings"] = "鼠标提示设置"
L["Top Buyers:"] = "TOP 买家："
L["Top Item:"] = "TOP 物品："
L["Top Sellers:"] = "TOP 卖家:"
L["Total"] = "总计"
L["Total Gold"] = "总金币"
L["Total Gold Collected: %s"] = "收集的金币总数：%s"
L["Total Gold Earned:"] = "获得的总金额："
L["Total Gold Spent:"] = "花费总金币"
L["Total Price"] = "总价格："
L["Total Profit:"] = "总利润："
L["Total Value"] = "总价值"
L["Total Value of All Items"] = "所有物品的总价值"
L["Track Sales / Purchases via trade"] = "记录贸易买卖"
L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
L["Transform Value"] = "转化价格"
L["TSM Banking"] = "TSM银行"
L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM能在多个账号之间自动同步数据。此外您还可以将当前有效的档案发送到已关联的帐户，以便快速将您的群组和配置发送到其他帐户。"
L["TSM Crafting"] = "TSM制造"
L["TSM Destroying"] = "TSM分解"
L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM当前没有您所在领域的任何AuctionDB定价数据。我们建议您从| |cff99ffffhttp://tradeskillmaster.com|下载TSM桌面应用程序，以自动更新AuctionDB数据（并自动备份TSM设置）。"
L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM未能扫描拍卖。 请重新运行扫描。"
L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM当前正在重建其项目高速缓存，这可能会导致FPS下降并导致TSM在此过程完成之前无法完全发挥作用。这是正常现象，通常需要不到一分钟的时间。"
L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM缺少TSM桌面应用程序的重要信息。 请确保TSM桌面应用程序正在运行且配置正确。"
L["TSM Mailing"] = "TSM邮件"
L["TSM TASK LIST"] = "TSM 任务列表"
L["TSM Vendoring"] = "TSM自动售卖"
L["TSM Version Info:"] = "TSM版本信息："
L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting检测到您刚刚交易%s%s以赚取%s，您希望Accounting模块存储此交易的记录吗？"
L["TSM4"] = "TSM4"
L["TUJ 14-Day Price"] = "TUJ 十四天价格"
L["TUJ 3-Day Price"] = "TUJ中近3日价格"
L["TUJ Global Mean"] = "TUJ 全球整体均值"
L["TUJ Global Median"] = "TUJ全球中位数"
L["Twitter Integration"] = "整合推特"
L["Twitter Integration Not Enabled"] = "Twitter整合未启用"
L["Type"] = "类型"
L["Type Something"] = "输入一些东西"
L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "由于目标组（%s）不再存在，因此无法处理导入，请再试一次。"
L["Unbalanced parentheses."] = "残缺的括号。"
L["Undercut amount:"] = "压价金额:"
L["Undercut by whitelisted player."] = "被白名单玩家压价"
L["Undercutting blacklisted player."] = "压价黑名单"
L["Undercutting competition."] = "压价发布"
L["Ungrouped Items"] = "未分组的物品"
L["Unknown Item"] = "未知物品"
L["Unwrap Gift"] = "打开礼物包裹"
L["Up"] = "向上"
L["Up to date"] = "最新"
L["UPDATE EXISTING MACRO"] = "更新已有的宏"
L["Updating"] = "更新中"
L["Usage: /tsm price <ItemLink> <Price String>"] = "用法：/tsm price <物品链接> <价格字符串>"
L["Use smart average for purchase price"] = "使用智能均价作为购买价"
L["Use the field below to search the auction house by filter"] = "使用下面的字段按过滤搜索拍卖行"
L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "使用左侧的列表选择要为其创建导出字符串的分组和操作"
L["VALUE PRICE SOURCE"] = "价格来源"
L["ValueSources"] = "价格来源"
L["Variable Name"] = "变量名"
L["Vendor"] = "NPC"
L["Vendor Buy Price"] = "NPC购买价"
L["Vendor Search"] = "卖店价搜索"
L["VENDOR SEARCH"] = "卖店价搜索"
L["Vendor Sell"] = "出售"
L["Vendor Sell Price"] = "NPC出售价"
L["Vendoring 'SELL ALL' Button"] = "NPC \"出售所有\" 按钮"
L["View ignored items in the Destroying options."] = "在分解选项中查看忽略的物品"
L["Warehousing"] = "Warehousing"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从背包→银行/公会银行时每种物品保留%d件, 当从银行/公会银行→背包时每种物品保留%d件。"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从背包→银行/公会银行时每种物品保留%d件, 当从银行/公会银行→背包时每种物品保留%d件. 补货会保留%d件物品在你的背包里。"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从背包→银行/公会银行时每种物品保留%d件。"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从背包→银行/公会银行时每种物品保留%d件. 补货会保留%d件物品在你的背包里。"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从银行/公会银行→背包时每种物品保留%d件。"
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从银行/公会银行→背包时每种物品保留%d件。补货会保留%d件物品在背包里。"
L["Warehousing will move a max of %d of each item in this group."] = "Warehousing会移动这个分组中每种物品最多%d件。"
L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组中每种物品最多%d件。补货会保留%d件物品在背包里。"
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing会移动这个分组的所有物品, 当从背包→银行/公会银行时每种物品保留%d件, 当从银行/公会银行→背包时每种物品保留%d件。"
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组的所有物品, 当从背包→银行/公会银行时每种物品保留%d件, 当从银行/公会银行→背包时每种物品保留%d件。补货会在背包里保留%d件物品。"
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing会移动这个分组的所有物品, 当从背包→银行/公会银行时每种物品保留%d件。"
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组的所有物品, 当从背包→银行/公会银行时每种物品保留%d。补货会在背包里保留%d件物品。"
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing会移动这个分组的所有物品, 当从银行/公会银行→背包时每种物品保留%d件。"
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "当银行/工会银行>背包物品时仓库将移动该组中的所有物品，每个物品的%d保持不变。补货将在你的背包中保留%d"
L["Warehousing will move all of the items in this group."] = "移动所有Warehousing物品到该分组。"
L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing将移动该组中的所有项目。补货将在你的背包中保留%d物品"
L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "警告：宏过长，将被调整到适合的长度。"
L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "警告：你的%s的最低价格比卖给商人的价格更低（包含AH的手续费）。考虑提高你的最低价，或者直接卖店。"
L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "欢迎使用TSM4！现在，所有旧的TSM3模块（例如Crafting，Shopping等）都内置在主要TSM插件中，因此您只需要安装TSM和TSM_AppHelper。TSM禁用了旧模块，需要重新加载。"
L["When above maximum:"] = "当超过最大值："
L["When below minimum:"] = "当小于最小值："
L["Whitelist"] = "白名单"
L["Whitelisted Players"] = "白名单玩家"
L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "已经拥有此物品的的最多补货量。 已经有%d，最多补货量是%d"
L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "您可以使用以下选项清除旧数据。 建议偶尔清除旧数据，以遍accounting模块顺利运行。 选择要删除的最小天数，然后单击“%s”"
L["You cannot use %s as part of this custom price."] = "您不能使用 %s 作为自定义价格。"
L["You cannot use %s within convert() as part of this custom price."] = "你不能使用不超过转化价的%s作为自定义价格。"
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "无需添加“%s”，小号会自动列入白名单"
L["You don't know how to craft this item."] = "不知道如何制作此物品"
L["You must reload your UI for these settings to take effect. Reload now?"] = "你需要重载UI来使这些改动生效。是否现在重载？"
L["You won an auction for %sx%d for %s"] = "你成功购买%sx%d从%s"
L["Your auction has not been undercut."] = "未被压价"
L["Your auction of %s expired"] = "您的%s拍卖已过期"
L["Your auction of %s has sold for %s!"] = "你的%s拍卖以%s的价格卖出！"
L["Your Buyout"] = "你的一口价"
L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "'%s'制造方法无效，因此已返回默认值。 细节：%s"
L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "你的默认制造价值方法是无效的，所以已经回到初始状态。详细: %s"
L["Your task list is currently empty."] = "你的任务列表现在是空的。"
L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "由于暴雪结束时的错误导致AH停止工作，因此您已经分阶段进行了最小化。 请关闭并重新打开AH并重新启动Sniper"
L["You've been undercut."] = "已被压价"
	elseif locale == "zhTW" then
L = L or {}
L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group：群組; 已選擇（%d |4項目：項目;）"
L["%d auctions"] = "%d 拍賣"
L["%d Groups"] = "%d 分組"
L["%d Items"] = "%d 物品"
L["%d of %d"] = "发布%d堆，每堆%d个"
L["%d Operations"] = "%d 操作"
L["%d Posted Auctions"] = "已發布%d個拍賣"
L["%d Sold Auctions"] = "%d 個拍賣已售出"
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s 包包, %s 銀行, %s 拍賣場, %s 信箱)"
L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s 玩家, %s 小号, %s 公会, %s 拍卖行)"
L["%s (%s profit)"] = "%s (%s 利潤)"
--[[Translation missing --]]
L["%s |4operation:operations;"] = "%s |4operation:operations;"
L["%s ago"] = "%s前"
L["%s Crafts"] = "%s制造"
--[[Translation missing --]]
L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
--[[Translation missing --]]
L["%s in guild vault"] = "%s in guild vault"
L["%s is a valid custom price but %s is an invalid item."] = "%s 是一個有效的自定義價格但 %s 是一個無效的物品。"
L["%s is a valid custom price but did not give a value for %s."] = "%s 是一個有效的自定義價格但沒有為 %s 給出一個值。"
--[[Translation missing --]]
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."
L["%s is not a valid custom price and gave the following error: %s"] = "%s 不是一個有效的自定義價格,錯誤資訊: %s"
L["%s Operations"] = "%s 行動"
--[[Translation missing --]]
L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
L["%s removed."] = "%s 移除."
L["%s sent you %s"] = "%s 發送給你 %s"
L["%s sent you %s and %s"] = "%s 發送給你 %s 和 %s"
--[[Translation missing --]]
L["%s sent you a COD of %s for %s"] = "%s sent you a COD of %s for %s"
L["%s sent you a message: %s"] = "%s 發訊息給你: %s"
L["%s total"] = "%s 全部"
L["%sDrag%s to move this button"] = "%s拖曳%s 移動該按紐"
L["%sLeft-Click%s to open the main window"] = "%s點擊%s 開啟主視窗"
L["(%d/500 Characters)"] = "(%d/500 字符)"
L["(max %d)"] = "(最多 %d)"
L["(max 5000)"] = "(最多 5000)"
L["(min %d - max %d)"] = "(最少 %d - 最多 %d)"
L["(min 0 - max 10000)"] = "(最少 0 - max 最多)"
L["(minimum 0 - maximum 20)"] = "(最小值 0 - 最大值 20)"
L["(minimum 0 - maximum 2000)"] = "(最小值 0 - 最大值 2000)"
L["(minimum 0 - maximum 905)"] = "(最小值 0 - 最大值 905)"
L["(minimum 0.5 - maximum 10)"] = "(最小值 0.5 - 最大值 10)"
L["/tsm help|r - Shows this help listing"] = "/tsm help|r - 顯示幫助列表"
L["/tsm|r - opens the main TSM window."] = "/tsm|r - 開啟TSM主視窗。"
--[[Translation missing --]]
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
--[[Translation missing --]]
L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
--[[Translation missing --]]
L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
--[[Translation missing --]]
L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Left-Click|r to ignore an item this session."
--[[Translation missing --]]
L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Left-Click|r to ignore it permanently."
L["1 Group"] = "1 群組"
L["1 Item"] = "1 物品"
L["12 hr"] = "12小時"
L["24 hr"] = "24小時"
L["48 hr"] = "48小時"
L["A custom price of %s for %s evaluates to %s."] = "%s的自定義價格為%s到%s。"
L["A maximum of 1 convert() function is allowed."] = "最多只允許1個convert()函數。"
L["A profile with that name already exists on the target account. Rename it first and try again."] = "目標帳戶上已經存在具有該名稱的配置文件。 首先重命名，然後重試。"
L["A profile with this name already exists."] = "具有此名稱的配置文件已存在。"
L["A scan is already in progress. Please stop that scan before starting another one."] = "掃描已在進行中。 在開始另一掃描之前，請停止該掃描。"
L["Above max expires."] = "超過上限會過期。"
L["Above max price. Not posting."] = "高於最高價。 不發布。"
L["Above max price. Posting at max price."] = "高於最高價。 以最高價格發布。"
L["Above max price. Posting at min price."] = "高於最高價。 以最低價格發布。"
L["Above max price. Posting at normal price."] = [=[
高於最高價。 以正常價格發布。]=]
L["Accepting these item(s) will cost"] = "接受這些物品將花費"
L["Accepting this item will cost"] = "接受此項目將花費"
L["Account sync removed. Please delete the account sync from the other account as well."] = "帳戶同步已刪除。 請同時從另一個帳戶中刪除該帳戶同步。"
L["Account Syncing"] = "帳戶同步"
L["Accounting"] = "會計"
L["Accounting Tooltips"] = "會計工具提示"
L["Activity Type"] = "活動類型"
L["ADD %d ITEMS"] = "增加 %d 項目"
L["Add / Remove Items"] = "增加 / 移除 項目"
L["ADD NEW CUSTOM PRICE SOURCE"] = "添加新的自定義價格來源"
L["ADD OPERATION"] = "添加操作"
L["Add Player"] = "添加播放器"
L["Add Subject / Description"] = "添加主題/說明"
L["Add Subject / Description (Optional)"] = "添加主題/說明（可選）"
L["ADD TO MAIL"] = "加入郵件"
L["Added '%s' profile which was received from %s."] = "添加了從%s收到的'%s'個人資料。"
L["Added %s to %s."] = "已將%s添加到%s。"
L["Additional error suppressed"] = "隱藏的其他錯誤"
L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "調整以下設置以設置如何拍賣與該操作關聯的群組。"
L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "調整以下設置以設置如何取消此操作的群組。"
L["Adjust the settings below to set how groups attached to this operation will be priced."] = "調整以下設置以設置該操作附加群組的定價方式。"
L["Advanced Item Search"] = "進階項目搜索"
L["Advanced Options"] = "進階選項"
L["AH"] = "拍賣場"
--[[Translation missing --]]
L["AH (Crafting)"] = "AH (Crafting)"
--[[Translation missing --]]
L["AH (Disenchanting)"] = "AH (Disenchanting)"
--[[Translation missing --]]
L["AH BUSY"] = "AH BUSY"
--[[Translation missing --]]
L["AH Frame Options"] = "AH Frame Options"
L["Alarm Clock"] = "警示鐘"
L["All Auctions"] = "所有拍賣"
L["All Characters and Guilds"] = "所有角色和公會"
L["All Item Classes"] = "所有物品類別"
L["All Professions"] = "所有專業"
L["All Subclasses"] = "所有子分類"
--[[Translation missing --]]
L["Allow partial stack?"] = "Allow partial stack?"
--[[Translation missing --]]
L["Alt Guild Bank"] = "Alt Guild Bank"
L["Alts"] = "替代項"
--[[Translation missing --]]
L["Alts AH"] = "Alts AH"
L["Amount"] = "數量"
L["AMOUNT"] = "寄送金額"
L["Amount of Bag Space to Keep Free"] = "可用的袋子空間量"
L["APPLY FILTERS"] = "應用過濾器"
L["Apply operation to group:"] = "將操作應用於群組："
L["Are you sure you want to clear old accounting data?"] = "您確定要清除舊的會計數據嗎？"
L["Are you sure you want to delete this group?"] = "你確定要取消這個群組?"
L["Are you sure you want to delete this operation?"] = "你確定要取消這個動作?"
L["Are you sure you want to reset all operation settings?"] = "您確定要重設所有操作設置嗎？"
L["At above max price and not undercut."] = "以高於最高價的價格購買，並且不能削價。"
L["At normal price and not undercut."] = "價格正常且不削價。"
L["Auction"] = "拍賣"
L["Auction Bid"] = "競標價格"
L["Auction Buyout"] = "拍賣買斷"
L["AUCTION DETAILS"] = "拍賣細節"
L["Auction Duration"] = "拍賣時間"
L["Auction has been bid on."] = "拍賣已結標"
L["Auction House Cut"] = "拍賣費"
L["Auction Sale Sound"] = "拍賣銷售聲音"
L["Auction Window Close"] = "關閉拍賣視窗"
L["Auction Window Open"] = "開啟拍賣視窗"
L["Auctionator - Auction Value"] = "Auctionator - 拍賣價格"
L["AuctionDB - Market Value"] = "AuctionDB-市場價值"
L["Auctioneer - Appraiser"] = "Auctioneer - 出價"
L["Auctioneer - Market Value"] = "Auctioneer - 市場價格"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - 最小直購價"
L["Auctioning"] = "拍賣"
L["Auctioning Log"] = "拍賣日誌"
L["Auctioning Operation"] = "拍賣業務"
L["Auctioning 'POST'/'CANCEL' Button"] = "拍賣“ 張貼” /“ 取消”按鈕"
L["Auctioning Tooltips"] = "拍賣工具提示"
L["Auctions"] = "拍賣"
L["Auto Quest Complete"] = "自動任務完成"
L["Average Earned Per Day:"] = "每天平均收入："
L["Average Prices:"] = "平均價格："
L["Average Profit Per Day:"] = "每日平均利潤："
L["Average Spent Per Day:"] = "每天平均花費："
L["Avg Buy Price"] = "平均購買價"
L["Avg Resale Profit"] = "平均轉售利潤"
L["Avg Sell Price"] = "平均售價"
L["BACK"] = "返回"
L["BACK TO LIST"] = "返回目錄"
L["Back to List"] = "返回目錄"
L["Bag"] = "背包"
L["Bags"] = "背包"
L["Banks"] = "銀行"
L["Base Group"] = "基本群組"
L["Base Item"] = "基礎項目"
L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "以下是按模組分類的當前可用價格來源。您將在自定義價格框中輸入%skey|r。"
L["Below custom price:"] = "低於定制價格："
--[[Translation missing --]]
L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
--[[Translation missing --]]
L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
--[[Translation missing --]]
L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
--[[Translation missing --]]
L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
L["BID"] = "出價"
L["Bid %d / %d"] = "出價%d/%d"
L["Bid (item)"] = "出價（項目）"
L["Bid (stack)"] = "出價（堆疊）"
L["Bid Price"] = "競標"
L["Bid Sniper Paused"] = "競標狙擊手已暫停"
L["Bid Sniper Running"] = "競標狙擊手運行"
L["Bidding Auction"] = "招標拍賣"
L["Blacklisted players:"] = "列入黑名單的玩家："
--[[Translation missing --]]
L["Bought"] = "Bought"
L["Bought %d of %s from %s for %s"] = "從%d向%s購買了%s，共%s"
--[[Translation missing --]]
L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
--[[Translation missing --]]
L["Bound Actions"] = "Bound Actions"
--[[Translation missing --]]
L["BUSY"] = "BUSY"
L["BUY"] = "購買"
L["Buy"] = "購買"
L["Buy %d / %d"] = "購買%d/%d"
L["Buy %d / %d (Confirming %d / %d)"] = "購買%d/%d（確認%d/%d）"
L["Buy from AH"] = "從AH購買"
L["Buy from Vendor"] = "向商人購買"
L["BUY GROUPS"] = "購買群組"
L["Buy Options"] = "購買選項"
L["BUYBACK ALL"] = "全部購回"
L["Buyer/Seller"] = "買方/賣方"
L["BUYOUT"] = "買斷"
L["Buyout (item)"] = "直購 (項目)"
--[[Translation missing --]]
L["Buyout (stack)"] = "Buyout (stack)"
--[[Translation missing --]]
L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
L["Buyout Price"] = "直購價"
--[[Translation missing --]]
L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
--[[Translation missing --]]
L["Buyout Sniper Running"] = "Buyout Sniper Running"
--[[Translation missing --]]
L["BUYS"] = "BUYS"
--[[Translation missing --]]
L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
--[[Translation missing --]]
L["Cancel auctions with bids"] = "Cancel auctions with bids"
--[[Translation missing --]]
L["Cancel Scan"] = "Cancel Scan"
--[[Translation missing --]]
L["Cancel to repost higher?"] = "Cancel to repost higher?"
--[[Translation missing --]]
L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
--[[Translation missing --]]
L["Canceling"] = "Canceling"
--[[Translation missing --]]
L["Canceling %d / %d"] = "Canceling %d / %d"
--[[Translation missing --]]
L["Canceling %d Auctions..."] = "Canceling %d Auctions..."
--[[Translation missing --]]
L["Canceling all auctions."] = "Canceling all auctions."
--[[Translation missing --]]
L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
--[[Translation missing --]]
L["Canceling disabled."] = "Canceling disabled."
--[[Translation missing --]]
L["Canceling Settings"] = "Canceling Settings"
--[[Translation missing --]]
L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
--[[Translation missing --]]
L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
--[[Translation missing --]]
L["Canceling to repost higher."] = "Canceling to repost higher."
--[[Translation missing --]]
L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
--[[Translation missing --]]
L["Canceling undercut auctions."] = "Canceling undercut auctions."
--[[Translation missing --]]
L["Cancelled"] = "Cancelled"
--[[Translation missing --]]
L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
--[[Translation missing --]]
L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
--[[Translation missing --]]
L["CANCELS"] = "CANCELS"
--[[Translation missing --]]
L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
L["Can't load TSM tooltip while in combat"] = "戰鬥中無法載入TSM提示"
--[[Translation missing --]]
L["Cash Register"] = "Cash Register"
--[[Translation missing --]]
L["CHARACTER"] = "CHARACTER"
--[[Translation missing --]]
L["Character"] = "Character"
L["Chat Tab"] = "聊天標籤"
L["Cheapest auction below min price."] = "低於最低價的最便宜拍賣價"
L["Clear"] = "清除"
--[[Translation missing --]]
L["Clear All"] = "Clear All"
--[[Translation missing --]]
L["CLEAR DATA"] = "CLEAR DATA"
L["Clear Filters"] = "清除篩選"
--[[Translation missing --]]
L["Clear Old Data"] = "Clear Old Data"
--[[Translation missing --]]
L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
L["Clear Queue"] = "清除佇列"
L["Clear Selection"] = "消除選擇"
--[[Translation missing --]]
L["COD"] = "COD"
--[[Translation missing --]]
L["Coins (%s)"] = "Coins (%s)"
--[[Translation missing --]]
L["Collapse All Groups"] = "Collapse All Groups"
--[[Translation missing --]]
L["Combine Partial Stacks"] = "Combine Partial Stacks"
--[[Translation missing --]]
L["Combining..."] = "Combining..."
--[[Translation missing --]]
L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
L["Confirm"] = "確認"
--[[Translation missing --]]
L["Confirm Complete Sound"] = "Confirm Complete Sound"
--[[Translation missing --]]
L["Confirming %d / %d"] = "Confirming %d / %d"
--[[Translation missing --]]
L["Connected to %s"] = "Connected to %s"
--[[Translation missing --]]
L["Connecting to %s"] = "Connecting to %s"
L["CONTACTS"] = "聯絡人"
L["Contacts Menu"] = "聯絡簿"
L["Cooldown"] = "倒數"
L["Cooldowns"] = "倒數時間"
L["Cost"] = "成本"
--[[Translation missing --]]
L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
--[[Translation missing --]]
L["Could not find profile '%s'. Possible profiles: '%s'"] = "Could not find profile '%s'. Possible profiles: '%s'"
--[[Translation missing --]]
L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
L["Craft"] = "製造數量"
L["CRAFT"] = "製造"
--[[Translation missing --]]
L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
--[[Translation missing --]]
L["Craft (When Profitable)"] = "Craft (When Profitable)"
L["Craft All"] = "全部製造"
--[[Translation missing --]]
L["CRAFT ALL"] = "CRAFT ALL"
--[[Translation missing --]]
L["Craft Name"] = "Craft Name"
L["CRAFT NEXT"] = "製作下一項"
--[[Translation missing --]]
L["Craft value method:"] = "Craft value method:"
--[[Translation missing --]]
L["CRAFTER"] = "CRAFTER"
--[[Translation missing --]]
L["CRAFTING"] = "CRAFTING"
L["Crafting"] = "製造"
--[[Translation missing --]]
L["Crafting Cost"] = "Crafting Cost"
--[[Translation missing --]]
L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
L["Crafting Queue"] = "製造佇列"
--[[Translation missing --]]
L["Crafting Tooltips"] = "Crafting Tooltips"
L["Crafts"] = "製造數量"
--[[Translation missing --]]
L["Crafts %d"] = "Crafts %d"
--[[Translation missing --]]
L["CREATE MACRO"] = "CREATE MACRO"
--[[Translation missing --]]
L["Create New Operation"] = "Create New Operation"
--[[Translation missing --]]
L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
--[[Translation missing --]]
L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
L["Crystals"] = "水晶"
--[[Translation missing --]]
L["Current Profiles"] = "Current Profiles"
--[[Translation missing --]]
L["CURRENT SEARCH"] = "CURRENT SEARCH"
--[[Translation missing --]]
L["CUSTOM POST"] = "CUSTOM POST"
--[[Translation missing --]]
L["Custom Price"] = "Custom Price"
L["Custom Price Source"] = "自定義價格源"
--[[Translation missing --]]
L["Custom Sources"] = "Custom Sources"
--[[Translation missing --]]
L["Database Sources"] = "Database Sources"
--[[Translation missing --]]
L["Default Craft Value Method:"] = "Default Craft Value Method:"
--[[Translation missing --]]
L["Default Material Cost Method:"] = "Default Material Cost Method:"
--[[Translation missing --]]
L["Default Price"] = "Default Price"
--[[Translation missing --]]
L["Default Price Configuration"] = "Default Price Configuration"
--[[Translation missing --]]
L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
--[[Translation missing --]]
L["Delete this record?"] = "Delete this record?"
L["Deposit"] = "保證金"
L["Deposit Cost"] = "保證金"
--[[Translation missing --]]
L["Deposit Price"] = "Deposit Price"
--[[Translation missing --]]
L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
L["Deselect All Groups"] = "取消所有分組選定"
--[[Translation missing --]]
L["Deselect All Items"] = "Deselect All Items"
--[[Translation missing --]]
L["Destroy Next"] = "Destroy Next"
--[[Translation missing --]]
L["Destroy Value"] = "Destroy Value"
--[[Translation missing --]]
L["Destroy Value Source"] = "Destroy Value Source"
--[[Translation missing --]]
L["Destroying"] = "Destroying"
--[[Translation missing --]]
L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
--[[Translation missing --]]
L["Destroying Tooltips"] = "Destroying Tooltips"
--[[Translation missing --]]
L["Destroying..."] = "Destroying..."
--[[Translation missing --]]
L["Details"] = "Details"
--[[Translation missing --]]
L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
L["Disenchant Search"] = "Disenchant Search"
--[[Translation missing --]]
L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
--[[Translation missing --]]
L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
L["Display cancelled since last sale"] = "Display cancelled since last sale"
L["Display crafting cost"] = "展示製作成本"
L["Display detailed destroy info"] = "顯示詳細的銷毀信息"
L["Display disenchant value"] = "顯示分解價值"
L["Display expired auctions"] = "顯示過期的拍賣"
L["Display group name"] = "顯示群組名稱"
L["Display historical price"] = "顯示歷史價格"
L["Display market value"] = "顯示市場價值"
--[[Translation missing --]]
L["Display mill value"] = "Display mill value"
L["Display min buyout"] = "顯示最低買斷"
L["Display Operation Names"] = "顯示操作名稱"
L["Display prospect value"] = "顯示潛在價值"
L["Display purchase info"] = "顯示購買信息"
L["Display region historical price"] = "顯示區域歷史價格"
L["Display region market value avg"] = "顯示區域市場價值平均值"
L["Display region min buyout avg"] = "顯示區域最低買斷平均值"
L["Display region sale avg"] = "顯示區域銷售平均"
L["Display region sale rate"] = "顯示區域銷售率"
L["Display region sold per day"] = "每天售出的顯示區域"
L["Display sale info"] = "顯示銷售信息"
L["Display sale rate"] = "顯示銷售率"
L["Display shopping max price"] = "顯示購物最高價"
L["Display total money recieved in chat?"] = "顯示聊天中收到的總金額？"
--[[Translation missing --]]
L["Display transform value"] = "Display transform value"
--[[Translation missing --]]
L["Display vendor buy price"] = "Display vendor buy price"
--[[Translation missing --]]
L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
L["Done Canceling"] = "Done Canceling"
L["Done Posting"] = "發佈完成"
--[[Translation missing --]]
L["Done rebuilding item cache."] = "Done rebuilding item cache."
--[[Translation missing --]]
L["Done Scanning"] = "Done Scanning"
--[[Translation missing --]]
L["Don't post after this many expires:"] = "Don't post after this many expires:"
L["Don't Post Items"] = "不要發佈物品"
--[[Translation missing --]]
L["Don't prompt to record trades"] = "Don't prompt to record trades"
--[[Translation missing --]]
L["DOWN"] = "DOWN"
--[[Translation missing --]]
L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
L["Drag Item(s) Into Box"] = "將物品放在這裡隨郵件發送"
--[[Translation missing --]]
L["Duplicate"] = "Duplicate"
--[[Translation missing --]]
L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
L["Dust"] = "塵"
--[[Translation missing --]]
L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
L["Embed TSM tooltips"] = "Embed TSM tooltips"
--[[Translation missing --]]
L["EMPTY BAGS"] = "EMPTY BAGS"
--[[Translation missing --]]
L["Empty parentheses are not allowed"] = "Empty parentheses are not allowed"
L["Empty price string."] = "清空價格字串。"
--[[Translation missing --]]
L["Enable automatic stack combination"] = "Enable automatic stack combination"
--[[Translation missing --]]
L["Enable buying?"] = "Enable buying?"
--[[Translation missing --]]
L["Enable inbox chat messages"] = "Enable inbox chat messages"
--[[Translation missing --]]
L["Enable restock?"] = "Enable restock?"
--[[Translation missing --]]
L["Enable selling?"] = "Enable selling?"
--[[Translation missing --]]
L["Enable sending chat messages"] = "Enable sending chat messages"
--[[Translation missing --]]
L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
--[[Translation missing --]]
L["Enable tweet enhancement"] = "Enable tweet enhancement"
L["Enchant Vellum"] = "附魔皮紙"
--[[Translation missing --]]
L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
L["Enter a name for the new profile"] = "Enter a name for the new profile"
--[[Translation missing --]]
L["Enter Filter"] = "Enter Filter"
--[[Translation missing --]]
L["Enter Keyword"] = "Enter Keyword"
--[[Translation missing --]]
L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
--[[Translation missing --]]
L["Enter player name"] = "Enter player name"
L["Essences"] = "精華"
--[[Translation missing --]]
L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establishing connection to %s. Make sure that you've entered this character's name on the other account."
L["Estimated Cost:"] = "預計成本"
--[[Translation missing --]]
L["Estimated deliver time"] = "Estimated deliver time"
L["Estimated Profit:"] = "預計利潤"
--[[Translation missing --]]
L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
L["Expand All Groups"] = "Expand All Groups"
--[[Translation missing --]]
L["Expenses"] = "Expenses"
--[[Translation missing --]]
L["EXPENSES"] = "EXPENSES"
--[[Translation missing --]]
L["Expirations"] = "Expirations"
--[[Translation missing --]]
L["Expired"] = "Expired"
--[[Translation missing --]]
L["Expired Auctions"] = "Expired Auctions"
--[[Translation missing --]]
L["Expired Since Last Sale"] = "Expired Since Last Sale"
L["Expires"] = "信件退回時間"
--[[Translation missing --]]
L["EXPIRES"] = "EXPIRES"
--[[Translation missing --]]
L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
L["Expiring Mails"] = "Expiring Mails"
--[[Translation missing --]]
L["Exploration"] = "Exploration"
L["Export"] = "匯出"
--[[Translation missing --]]
L["Export List"] = "Export List"
--[[Translation missing --]]
L["Failed Auctions"] = "Failed Auctions"
--[[Translation missing --]]
L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
--[[Translation missing --]]
L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
--[[Translation missing --]]
L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
--[[Translation missing --]]
L["Favorite Scans"] = "Favorite Scans"
--[[Translation missing --]]
L["Favorite Searches"] = "Favorite Searches"
L["Filter Auctions by Duration"] = "以時間篩選拍賣"
L["Filter Auctions by Keyword"] = "以關鍵字篩選拍賣"
--[[Translation missing --]]
L["Filter by Keyword"] = "Filter by Keyword"
--[[Translation missing --]]
L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
--[[Translation missing --]]
L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
L["Filter Items"] = "篩選項目"
--[[Translation missing --]]
L["Filter Shopping"] = "Filter Shopping"
--[[Translation missing --]]
L["Finding Selected Auction"] = "Finding Selected Auction"
--[[Translation missing --]]
L["Fishing Reel In"] = "Fishing Reel In"
--[[Translation missing --]]
L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
L["Found auction sound"] = "Found auction sound"
L["Friends"] = "好友"
L["From"] = "來自"
--[[Translation missing --]]
L["Full"] = "Full"
--[[Translation missing --]]
L["Garrison"] = "Garrison"
L["Gathering"] = "採集"
--[[Translation missing --]]
L["Gathering Search"] = "Gathering Search"
L["General Options"] = "常規選項"
--[[Translation missing --]]
L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
L["Global Operation Confirmation"] = "Global Operation Confirmation"
L["Gold"] = "隨信寄送的金額"
--[[Translation missing --]]
L["Gold Earned:"] = "Gold Earned:"
L["GOLD ON HAND"] = "手上金額"
--[[Translation missing --]]
L["Gold Spent:"] = "Gold Spent:"
--[[Translation missing --]]
L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
--[[Translation missing --]]
L["Group already exists."] = "Group already exists."
--[[Translation missing --]]
L["Group Management"] = "Group Management"
L["Group Operations"] = "群組操作"
--[[Translation missing --]]
L["Group Settings"] = "Group Settings"
L["Grouped Items"] = "已群組物品"
L["Groups"] = "群組"
L["Guild"] = "公會"
L["Guild Bank"] = "公會銀行"
--[[Translation missing --]]
L["GVault"] = "GVault"
--[[Translation missing --]]
L["Have"] = "Have"
--[[Translation missing --]]
L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
L["Hide auctions with bids"] = "Hide auctions with bids"
--[[Translation missing --]]
L["Hide Description"] = "Hide Description"
--[[Translation missing --]]
L["Hide minimap icon"] = "Hide minimap icon"
--[[Translation missing --]]
L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
L["High Bidder"] = "High Bidder"
--[[Translation missing --]]
L["Historical Price"] = "Historical Price"
--[[Translation missing --]]
L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
--[[Translation missing --]]
L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
L["Hr"] = "Hr"
--[[Translation missing --]]
L["Hrs"] = "Hrs"
--[[Translation missing --]]
L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "警告：如果你在多個配置檔下設定了“操作”選項，該操作會導致除了當前配置檔以外的所有配置檔中的“操作”選項永久性丟失。你確定要繼續嗎？"
--[[Translation missing --]]
L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
--[[Translation missing --]]
L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
--[[Translation missing --]]
L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
--[[Translation missing --]]
L["Ignore Characters"] = "Ignore Characters"
--[[Translation missing --]]
L["Ignore Guilds"] = "Ignore Guilds"
--[[Translation missing --]]
L["Ignore item variations?"] = "Ignore item variations?"
--[[Translation missing --]]
L["Ignore operation on characters:"] = "Ignore operation on characters:"
--[[Translation missing --]]
L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
--[[Translation missing --]]
L["Ignored Cooldowns"] = "Ignored Cooldowns"
--[[Translation missing --]]
L["Ignored Items"] = "Ignored Items"
L["ilvl"] = "物品等級"
L["Import"] = "匯入"
--[[Translation missing --]]
L["IMPORT"] = "IMPORT"
--[[Translation missing --]]
L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
--[[Translation missing --]]
L["Import Groups & Operations"] = "Import Groups & Operations"
--[[Translation missing --]]
L["Imported Items"] = "Imported Items"
--[[Translation missing --]]
L["Inbox Settings"] = "Inbox Settings"
--[[Translation missing --]]
L["Include Attached Operations"] = "Include Attached Operations"
--[[Translation missing --]]
L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
L["Include soulbound items"] = "Include soulbound items"
--[[Translation missing --]]
L["Information"] = "Information"
--[[Translation missing --]]
L["Invalid custom price entered."] = "Invalid custom price entered."
--[[Translation missing --]]
L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
L["Invalid custom price."] = "無效的自定義價格。"
L["Invalid function."] = "無效函數。"
--[[Translation missing --]]
L["Invalid gold value."] = "Invalid gold value."
--[[Translation missing --]]
L["Invalid group name."] = "Invalid group name."
--[[Translation missing --]]
L["Invalid import string."] = "Invalid import string."
L["Invalid item link."] = "無效的物品鏈接。"
--[[Translation missing --]]
L["Invalid operation name."] = "Invalid operation name."
L["Invalid operator at end of custom price."] = "無效的自定義價格運算符"
L["Invalid parameter to price source."] = "無效的自定義價格源參數。"
--[[Translation missing --]]
L["Invalid player name."] = "Invalid player name."
L["Invalid price source in convert."] = "轉換價格來源無效"
--[[Translation missing --]]
L["Invalid price source."] = "Invalid price source."
--[[Translation missing --]]
L["Invalid search filter"] = "Invalid search filter"
--[[Translation missing --]]
L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
L["Invalid word: '%s'"] = "無效詞：“%s”"
L["Inventory"] = "庫存"
--[[Translation missing --]]
L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
L["Inventory / Mailing"] = "Inventory / Mailing"
--[[Translation missing --]]
L["Inventory Options"] = "Inventory Options"
--[[Translation missing --]]
L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
--[[Translation missing --]]
L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
L["Item"] = "物品"
--[[Translation missing --]]
L["ITEM CLASS"] = "ITEM CLASS"
--[[Translation missing --]]
L["Item Level"] = "Item Level"
--[[Translation missing --]]
L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
L["Item links may only be used as parameters to price sources."] = "物品鏈接只能作為價格源的參數。"
L["Item Name"] = "物品名稱"
--[[Translation missing --]]
L["Item Quality"] = "Item Quality"
--[[Translation missing --]]
L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
--[[Translation missing --]]
L["Item Value"] = "Item Value"
--[[Translation missing --]]
L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
L["ITEMS"] = "物品"
L["Items"] = "物品"
--[[Translation missing --]]
L["Items in Bags"] = "Items in Bags"
--[[Translation missing --]]
L["Keep in bags quantity:"] = "Keep in bags quantity:"
--[[Translation missing --]]
L["Keep in bank quantity:"] = "Keep in bank quantity:"
--[[Translation missing --]]
L["Keep posted:"] = "Keep posted:"
--[[Translation missing --]]
L["Keep quantity:"] = "Keep quantity:"
--[[Translation missing --]]
L["Keep this amount in bags:"] = "Keep this amount in bags:"
--[[Translation missing --]]
L["Keep this amount:"] = "Keep this amount:"
--[[Translation missing --]]
L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
--[[Translation missing --]]
L["Last 14 Days"] = "Last 14 Days"
--[[Translation missing --]]
L["Last 3 Days"] = "Last 3 Days"
--[[Translation missing --]]
L["Last 30 Days"] = "Last 30 Days"
--[[Translation missing --]]
L["LAST 30 DAYS"] = "LAST 30 DAYS"
--[[Translation missing --]]
L["Last 60 Days"] = "Last 60 Days"
--[[Translation missing --]]
L["Last 7 Days"] = "Last 7 Days"
--[[Translation missing --]]
L["LAST 7 DAYS"] = "LAST 7 DAYS"
L["Last Data Update:"] = "最後更新日期"
--[[Translation missing --]]
L["Last Purchased"] = "Last Purchased"
--[[Translation missing --]]
L["Last Sold"] = "Last Sold"
L["Level Up"] = "升級"
--[[Translation missing --]]
L["LIMIT"] = "LIMIT"
--[[Translation missing --]]
L["Link to Another Operation"] = "Link to Another Operation"
--[[Translation missing --]]
L["List"] = "List"
--[[Translation missing --]]
L["List materials in tooltip"] = "List materials in tooltip"
--[[Translation missing --]]
L["Loading Mails..."] = "Loading Mails..."
--[[Translation missing --]]
L["Loading..."] = "Loading..."
L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "看起來TradeSkillMaster似乎發生了一個錯誤。請按照下列指示協助作者修正此問題。"
L["Loop detected in the following custom price:"] = "在以下自定義價格中循環檢測："
--[[Translation missing --]]
L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
--[[Translation missing --]]
L["Macro created and scroll wheel bound!"] = "Macro created and scroll wheel bound!"
L["Macro Setup"] = "建立巨集"
L["Mail"] = "信箱"
--[[Translation missing --]]
L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
L["Mailing"] = "Mailing"
--[[Translation missing --]]
L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
--[[Translation missing --]]
L["Main Settings"] = "Main Settings"
L["Make Cash On Delivery?"] = "付款取信"
--[[Translation missing --]]
L["Management Options"] = "Management Options"
--[[Translation missing --]]
L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
--[[Translation missing --]]
L["Map Ping"] = "Map Ping"
--[[Translation missing --]]
L["Market Value"] = "Market Value"
--[[Translation missing --]]
L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
L["Material Name"] = "Material Name"
--[[Translation missing --]]
L["Materials"] = "Materials"
--[[Translation missing --]]
L["Materials to Gather"] = "Materials to Gather"
--[[Translation missing --]]
L["MAX"] = "MAX"
--[[Translation missing --]]
L["Max Buy Price"] = "Max Buy Price"
--[[Translation missing --]]
L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
--[[Translation missing --]]
L["Max Sell Price"] = "Max Sell Price"
--[[Translation missing --]]
L["Max Shopping Price"] = "Max Shopping Price"
--[[Translation missing --]]
L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
--[[Translation missing --]]
L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
--[[Translation missing --]]
L["Maximum quantity:"] = "Maximum quantity:"
--[[Translation missing --]]
L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
L["Mill Value"] = "Mill Value"
--[[Translation missing --]]
L["Min"] = "Min"
--[[Translation missing --]]
L["Min Buy Price"] = "Min Buy Price"
--[[Translation missing --]]
L["Min Buyout"] = "Min Buyout"
--[[Translation missing --]]
L["Min Sell Price"] = "Min Sell Price"
L["Min/Normal/Max Prices"] = "最低/一般/最高 拍賣價"
--[[Translation missing --]]
L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
L["Minimum expires:"] = "Minimum expires:"
--[[Translation missing --]]
L["Minimum profit:"] = "Minimum profit:"
--[[Translation missing --]]
L["MINIMUM RARITY"] = "MINIMUM RARITY"
--[[Translation missing --]]
L["Minimum restock quantity:"] = "Minimum restock quantity:"
L["Misplaced comma"] = "錯誤的逗號分隔"
L["Missing Materials"] = "缺少材料"
--[[Translation missing --]]
L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
--[[Translation missing --]]
L["Modifiers:"] = "Modifiers:"
--[[Translation missing --]]
L["Money Frame Open"] = "Money Frame Open"
--[[Translation missing --]]
L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
L["Most Profitable Item:"] = "Most Profitable Item:"
--[[Translation missing --]]
L["MOVE"] = "MOVE"
--[[Translation missing --]]
L["Move already grouped items?"] = "Move already grouped items?"
--[[Translation missing --]]
L["Move Quantity Settings"] = "Move Quantity Settings"
--[[Translation missing --]]
L["MOVE TO BAGS"] = "MOVE TO BAGS"
--[[Translation missing --]]
L["MOVE TO BANK"] = "MOVE TO BANK"
--[[Translation missing --]]
L["MOVING"] = "MOVING"
--[[Translation missing --]]
L["Moving"] = "Moving"
--[[Translation missing --]]
L["Multiple Items"] = "Multiple Items"
L["My Auctions"] = "我的拍賣"
--[[Translation missing --]]
L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
--[[Translation missing --]]
L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
L["NEED MATS"] = "NEED MATS"
L["New Group"] = "新分組"
--[[Translation missing --]]
L["New Operation"] = "New Operation"
--[[Translation missing --]]
L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
L["No Attachments"] = "沒有附件"
--[[Translation missing --]]
L["No Crafts"] = "No Crafts"
--[[Translation missing --]]
L["No Data"] = "No Data"
--[[Translation missing --]]
L["No group selected"] = "No group selected"
--[[Translation missing --]]
L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
--[[Translation missing --]]
L["NO ITEMS"] = "NO ITEMS"
--[[Translation missing --]]
L["No Materials to Gather"] = "No Materials to Gather"
--[[Translation missing --]]
L["No Operation Selected"] = "No Operation Selected"
--[[Translation missing --]]
L["No posting."] = "No posting."
--[[Translation missing --]]
L["No Profession Opened"] = "No Profession Opened"
--[[Translation missing --]]
L["No Profession Selected"] = "No Profession Selected"
--[[Translation missing --]]
L["No profile specified. Possible profiles: '%s'"] = "No profile specified. Possible profiles: '%s'"
--[[Translation missing --]]
L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
--[[Translation missing --]]
L["No Sound"] = "No Sound"
--[[Translation missing --]]
L["None"] = "None"
--[[Translation missing --]]
L["None (Always Show)"] = "None (Always Show)"
--[[Translation missing --]]
L["None Selected"] = "None Selected"
--[[Translation missing --]]
L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
--[[Translation missing --]]
L["Normal"] = "Normal"
--[[Translation missing --]]
L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
--[[Translation missing --]]
L["Not canceling auction below min price."] = "Not canceling auction below min price."
--[[Translation missing --]]
L["Not canceling."] = "Not canceling."
--[[Translation missing --]]
L["Not Connected"] = "Not Connected"
--[[Translation missing --]]
L["Not enough items in bags."] = "Not enough items in bags."
--[[Translation missing --]]
L["NOT OPEN"] = "NOT OPEN"
--[[Translation missing --]]
L["Not Scanned"] = "Not Scanned"
--[[Translation missing --]]
L["Nothing to move."] = "Nothing to move."
--[[Translation missing --]]
L["NPC"] = "NPC"
--[[Translation missing --]]
L["Number Owned"] = "Number Owned"
--[[Translation missing --]]
L["of"] = "of"
--[[Translation missing --]]
L["Offline"] = "Offline"
--[[Translation missing --]]
L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
--[[Translation missing --]]
L["OPEN"] = "OPEN"
L["OPEN ALL MAIL"] = "全部開啓"
--[[Translation missing --]]
L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
L["Open Task List"] = "Open Task List"
L["Operation"] = "操作"
L["Operations"] = "操作"
--[[Translation missing --]]
L["Other Character"] = "Other Character"
--[[Translation missing --]]
L["Other Settings"] = "Other Settings"
--[[Translation missing --]]
L["Other Shopping Searches"] = "Other Shopping Searches"
--[[Translation missing --]]
L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
L["Parent Items"] = "Parent Items"
--[[Translation missing --]]
L["Past 7 Days"] = "Past 7 Days"
--[[Translation missing --]]
L["Past Day"] = "Past Day"
--[[Translation missing --]]
L["Past Month"] = "Past Month"
--[[Translation missing --]]
L["Past Year"] = "Past Year"
--[[Translation missing --]]
L["Paste string here"] = "Paste string here"
--[[Translation missing --]]
L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
--[[Translation missing --]]
L["Per Item"] = "Per Item"
--[[Translation missing --]]
L["Per Stack"] = "Per Stack"
--[[Translation missing --]]
L["Per Unit"] = "Per Unit"
L["Player Gold"] = "玩家持有金錢"
--[[Translation missing --]]
L["Player Invite Accept"] = "Player Invite Accept"
--[[Translation missing --]]
L["Please select a group to export"] = "Please select a group to export"
L["POST"] = "發佈"
L["Post at Maximum Price"] = "以最高價格發佈"
L["Post at Minimum Price"] = "以最低價格發佈"
L["Post at Normal Price"] = "以一般價格發佈"
--[[Translation missing --]]
L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
--[[Translation missing --]]
L["Post Scan"] = "Post Scan"
--[[Translation missing --]]
L["POST SELECTED"] = "POST SELECTED"
L["POSTAGE"] = "郵資"
--[[Translation missing --]]
L["Postage"] = "Postage"
--[[Translation missing --]]
L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
L["Posted Auctions %s:"] = "Posted Auctions %s:"
L["Posting"] = "發佈"
--[[Translation missing --]]
L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
L["Posting at normal price."] = "以一般價格發佈."
--[[Translation missing --]]
L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
L["Posting disabled."] = "Posting disabled."
L["Posting Settings"] = "發佈設定"
--[[Translation missing --]]
L["Posts"] = "Posts"
--[[Translation missing --]]
L["Potential"] = "Potential"
--[[Translation missing --]]
L["Price Per Item"] = "Price Per Item"
L["Price Settings"] = "價格設定"
--[[Translation missing --]]
L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
--[[Translation missing --]]
L["PROFESSION"] = "PROFESSION"
--[[Translation missing --]]
L["Profession Filters"] = "Profession Filters"
--[[Translation missing --]]
L["Profession Info"] = "Profession Info"
--[[Translation missing --]]
L["Profession loading..."] = "Profession loading..."
--[[Translation missing --]]
L["Professions Used In"] = "Professions Used In"
--[[Translation missing --]]
L["Profile changed to '%s'."] = "Profile changed to '%s'."
L["Profiles"] = "配置檔"
--[[Translation missing --]]
L["PROFIT"] = "PROFIT"
L["Profit"] = "利潤"
--[[Translation missing --]]
L["Prospect Value"] = "Prospect Value"
--[[Translation missing --]]
L["PURCHASE DATA"] = "PURCHASE DATA"
--[[Translation missing --]]
L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
--[[Translation missing --]]
L["Purchased (Total Price)"] = "Purchased (Total Price)"
--[[Translation missing --]]
L["Purchases"] = "Purchases"
--[[Translation missing --]]
L["Purchasing Auction"] = "Purchasing Auction"
L["Qty"] = "數量"
--[[Translation missing --]]
L["Quantity Bought:"] = "Quantity Bought:"
--[[Translation missing --]]
L["Quantity Sold:"] = "Quantity Sold:"
--[[Translation missing --]]
L["Quantity to move:"] = "Quantity to move:"
--[[Translation missing --]]
L["Quest Added"] = "Quest Added"
--[[Translation missing --]]
L["Quest Completed"] = "Quest Completed"
--[[Translation missing --]]
L["Quest Objectives Complete"] = "Quest Objectives Complete"
L["QUEUE"] = "佇列"
--[[Translation missing --]]
L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
--[[Translation missing --]]
L["Raid Warning"] = "Raid Warning"
--[[Translation missing --]]
L["Read More"] = "Read More"
--[[Translation missing --]]
L["Ready Check"] = "Ready Check"
--[[Translation missing --]]
L["Ready to Cancel"] = "Ready to Cancel"
--[[Translation missing --]]
L["Realm Data Tooltips"] = "Realm Data Tooltips"
--[[Translation missing --]]
L["Recent Scans"] = "Recent Scans"
--[[Translation missing --]]
L["Recent Searches"] = "Recent Searches"
L["Recently Mailed"] = "最近郵寄"
L["RECIPIENT"] = "收件人"
--[[Translation missing --]]
L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
L["Region Sale Rate"] = "Region Sale Rate"
--[[Translation missing --]]
L["Reload"] = "Reload"
--[[Translation missing --]]
L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
--[[Translation missing --]]
L["Removed a total of %s old records."] = "Removed a total of %s old records."
--[[Translation missing --]]
L["Rename"] = "Rename"
--[[Translation missing --]]
L["Rename Profile"] = "Rename Profile"
L["REPAIR"] = "修理"
--[[Translation missing --]]
L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
L["Replace duplicate operations?"] = "Replace duplicate operations?"
L["REPLY"] = "回覆"
L["REPORT SPAM"] = "舉報玩家"
--[[Translation missing --]]
L["Repost Higher Threshold"] = "Repost Higher Threshold"
--[[Translation missing --]]
L["Required Level"] = "Required Level"
--[[Translation missing --]]
L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
--[[Translation missing --]]
L["Resale"] = "Resale"
--[[Translation missing --]]
L["RESCAN"] = "RESCAN"
--[[Translation missing --]]
L["RESET"] = "RESET"
--[[Translation missing --]]
L["Reset All"] = "Reset All"
--[[Translation missing --]]
L["Reset Filters"] = "Reset Filters"
--[[Translation missing --]]
L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
--[[Translation missing --]]
L["RESTART"] = "RESTART"
--[[Translation missing --]]
L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
L["Revenue"] = "Revenue"
--[[Translation missing --]]
L["Round normal price"] = "Round normal price"
--[[Translation missing --]]
L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
--[[Translation missing --]]
L["Run Bid Sniper"] = "Run Bid Sniper"
--[[Translation missing --]]
L["Run Buyout Sniper"] = "Run Buyout Sniper"
--[[Translation missing --]]
L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
L["RUN POST SCAN"] = "RUN POST SCAN"
--[[Translation missing --]]
L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
--[[Translation missing --]]
L["Running Sniper Scan"] = "Running Sniper Scan"
--[[Translation missing --]]
L["Sale"] = "Sale"
--[[Translation missing --]]
L["SALE DATA"] = "SALE DATA"
L["Sale Price"] = "出售價格"
--[[Translation missing --]]
L["Sale Rate"] = "Sale Rate"
--[[Translation missing --]]
L["Sales"] = "Sales"
--[[Translation missing --]]
L["SALES"] = "SALES"
--[[Translation missing --]]
L["Sales Summary"] = "Sales Summary"
--[[Translation missing --]]
L["SCAN ALL"] = "SCAN ALL"
--[[Translation missing --]]
L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
L["Scan Paused"] = "Scan Paused"
--[[Translation missing --]]
L["SCANNING"] = "SCANNING"
--[[Translation missing --]]
L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
L["Scroll wheel direction:"] = "Scroll wheel direction:"
--[[Translation missing --]]
L["Search"] = "Search"
--[[Translation missing --]]
L["Search Bags"] = "Search Bags"
--[[Translation missing --]]
L["Search Groups"] = "Search Groups"
L["Search Inbox"] = "搜索郵箱"
--[[Translation missing --]]
L["Search Operations"] = "Search Operations"
L["Search Patterns"] = "搜尋品項"
--[[Translation missing --]]
L["Search Usable Items Only?"] = "Search Usable Items Only?"
L["Search Vendor"] = "搜尋物品"
--[[Translation missing --]]
L["Select a Source"] = "Select a Source"
--[[Translation missing --]]
L["Select Action"] = "Select Action"
L["Select All Groups"] = "選擇所有分組"
--[[Translation missing --]]
L["Select All Items"] = "Select All Items"
--[[Translation missing --]]
L["Select Auction to Cancel"] = "Select Auction to Cancel"
--[[Translation missing --]]
L["Select crafter"] = "Select crafter"
--[[Translation missing --]]
L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
L["Select Duration"] = "選擇時間"
L["Select Items to Add"] = "選擇增加項目"
L["Select Items to Remove"] = "選擇移除項目"
--[[Translation missing --]]
L["Select Operation"] = "Select Operation"
--[[Translation missing --]]
L["Select professions"] = "Select professions"
--[[Translation missing --]]
L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
--[[Translation missing --]]
L["Selected Groups"] = "Selected Groups"
--[[Translation missing --]]
L["Selected Operations"] = "Selected Operations"
L["Sell"] = "售出"
L["SELL ALL"] = "全部售出"
--[[Translation missing --]]
L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
L["SELL GROUPS"] = "SELL GROUPS"
--[[Translation missing --]]
L["Sell Options"] = "Sell Options"
--[[Translation missing --]]
L["Sell soulbound items?"] = "Sell soulbound items?"
L["Sell to Vendor"] = "賣給商人"
L["SELL TRASH"] = "售出垃圾"
L["Seller"] = "賣家"
--[[Translation missing --]]
L["Selling soulbound items."] = "Selling soulbound items."
L["Send"] = "發件箱"
--[[Translation missing --]]
L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
--[[Translation missing --]]
L["SEND GOLD"] = "SEND GOLD"
--[[Translation missing --]]
L["Send grouped items individually"] = "Send grouped items individually"
L["SEND MAIL"] = "發送"
L["Send Money"] = "寄送金額"
--[[Translation missing --]]
L["Send Profile"] = "Send Profile"
--[[Translation missing --]]
L["SENDING"] = "SENDING"
--[[Translation missing --]]
L["Sending %s individually to %s"] = "Sending %s individually to %s"
--[[Translation missing --]]
L["Sending %s to %s"] = "Sending %s to %s"
--[[Translation missing --]]
L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
--[[Translation missing --]]
L["Sending Settings"] = "Sending Settings"
--[[Translation missing --]]
L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
L["SENDING..."] = "發送中..."
L["Set auction duration to:"] = "設定拍賣週期為"
--[[Translation missing --]]
L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
L["Set Maximum Price:"] = "設定最高價格"
--[[Translation missing --]]
L["Set maximum quantity?"] = "Set maximum quantity?"
L["Set Minimum Price:"] = "設定最低價格"
--[[Translation missing --]]
L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
L["Set move quantity?"] = "Set move quantity?"
L["Set Normal Price:"] = "設定一般價格"
L["Set post cap to:"] = "設定發佈上限為"
--[[Translation missing --]]
L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
L["Setup"] = "Setup"
--[[Translation missing --]]
L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
L["Shards"] = "碎片"
L["Shopping"] = "購買"
--[[Translation missing --]]
L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
--[[Translation missing --]]
L["Show Description"] = "Show Description"
--[[Translation missing --]]
L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
--[[Translation missing --]]
L["Show material cost"] = "Show material cost"
--[[Translation missing --]]
L["Show on Modifier"] = "Show on Modifier"
L["Showing %d Mail"] = "顯示 %d 信件"
--[[Translation missing --]]
L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
L["Showing all %d Mails"] = "顯示全部 %d 信件"
--[[Translation missing --]]
L["Simple"] = "Simple"
L["SKIP"] = "略過"
--[[Translation missing --]]
L["Skip Import confirmation?"] = "Skip Import confirmation?"
--[[Translation missing --]]
L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
L["Slash Commands:"] = "斜線命令列表："
L["Sniper"] = "買家"
--[[Translation missing --]]
L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
--[[Translation missing --]]
L["Sniper Options"] = "Sniper Options"
--[[Translation missing --]]
L["Sniper Settings"] = "Sniper Settings"
--[[Translation missing --]]
L["Sniping items below a max price"] = "Sniping items below a max price"
--[[Translation missing --]]
L["Sold"] = "Sold"
--[[Translation missing --]]
L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
L["Sold %s worth of items."] = "Sold %s worth of items."
--[[Translation missing --]]
L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
--[[Translation missing --]]
L["Sold (Total Price)"] = "Sold (Total Price)"
--[[Translation missing --]]
L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
--[[Translation missing --]]
L["Sold Auctions %s:"] = "Sold Auctions %s:"
--[[Translation missing --]]
L["Source"] = "Source"
--[[Translation missing --]]
L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
L["SOURCES"] = "SOURCES"
L["Sources"] = "來源"
--[[Translation missing --]]
L["Sources to include for restock:"] = "Sources to include for restock:"
--[[Translation missing --]]
L["Stack"] = "Stack"
L["Stack / Quantity"] = "堆疊 / 數量"
--[[Translation missing --]]
L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
--[[Translation missing --]]
L["Starting Scan..."] = "Starting Scan..."
--[[Translation missing --]]
L["STOP"] = "STOP"
--[[Translation missing --]]
L["Store operations globally"] = "Store operations globally"
L["Subject"] = "主題"
--[[Translation missing --]]
L["SUBJECT"] = "SUBJECT"
--[[Translation missing --]]
L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
L["Switch to %s"] = "Switch to %s"
L["Switch to WoW UI"] = "轉到魔獸界面"
--[[Translation missing --]]
L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
L["Sync Status"] = "Sync Status"
L["TAKE ALL"] = "全部取回"
L["Take Attachments"] = "拿取附件"
--[[Translation missing --]]
L["Target Character"] = "Target Character"
--[[Translation missing --]]
L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
L["Tasks Added to Task List"] = "Tasks Added to Task List"
--[[Translation missing --]]
L["Text (%s)"] = "Text (%s)"
--[[Translation missing --]]
L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "名稱只能包括字母！不能有空格、數字或特殊字符。"
--[[Translation missing --]]
L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
--[[Translation missing --]]
L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
--[[Translation missing --]]
L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
--[[Translation missing --]]
L["This item is not in a TSM group."] = "This item is not in a TSM group."
--[[Translation missing --]]
L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
--[[Translation missing --]]
L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
--[[Translation missing --]]
L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
--[[Translation missing --]]
L["Time"] = "Time"
--[[Translation missing --]]
L["Time Format"] = "Time Format"
--[[Translation missing --]]
L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
L["TINKER"] = "TINKER"
--[[Translation missing --]]
L["Tooltip Price Format"] = "Tooltip Price Format"
--[[Translation missing --]]
L["Tooltip Settings"] = "Tooltip Settings"
--[[Translation missing --]]
L["Top Buyers:"] = "Top Buyers:"
--[[Translation missing --]]
L["Top Item:"] = "Top Item:"
--[[Translation missing --]]
L["Top Sellers:"] = "Top Sellers:"
--[[Translation missing --]]
L["Total"] = "Total"
L["Total Gold"] = "全部金額"
--[[Translation missing --]]
L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
--[[Translation missing --]]
L["Total Gold Earned:"] = "Total Gold Earned:"
--[[Translation missing --]]
L["Total Gold Spent:"] = "Total Gold Spent:"
--[[Translation missing --]]
L["Total Price"] = "Total Price"
--[[Translation missing --]]
L["Total Profit:"] = "Total Profit:"
--[[Translation missing --]]
L["Total Value"] = "Total Value"
--[[Translation missing --]]
L["Total Value of All Items"] = "Total Value of All Items"
--[[Translation missing --]]
L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
L["TradeSkillMaster Info"] = "TradeSkillMaster 資訊"
--[[Translation missing --]]
L["Transform Value"] = "Transform Value"
--[[Translation missing --]]
L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
L["TSM Crafting"] = "TSM 製造"
--[[Translation missing --]]
L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
--[[Translation missing --]]
L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
--[[Translation missing --]]
L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
--[[Translation missing --]]
L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
--[[Translation missing --]]
L["TSM Mailing"] = "TSM Mailing"
L["TSM TASK LIST"] = "TSM任務清單"
--[[Translation missing --]]
L["TSM Vendoring"] = "TSM Vendoring"
L["TSM Version Info:"] = "TSM版本資訊:"
--[[Translation missing --]]
L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
--[[Translation missing --]]
L["TSM4"] = "TSM4"
--[[Translation missing --]]
L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
--[[Translation missing --]]
L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
--[[Translation missing --]]
L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
L["TUJ Global Median"] = "TUJ Global Median"
--[[Translation missing --]]
L["Twitter Integration"] = "Twitter Integration"
--[[Translation missing --]]
L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
--[[Translation missing --]]
L["Type"] = "Type"
L["Type Something"] = "輸入某種物品"
--[[Translation missing --]]
L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
L["Unbalanced parentheses."] = "缺少括弧。"
L["Undercut amount:"] = "削價金額:"
--[[Translation missing --]]
L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
L["Undercutting competition."] = "削價競爭"
L["Ungrouped Items"] = "未群組物品"
--[[Translation missing --]]
L["Unknown Item"] = "Unknown Item"
--[[Translation missing --]]
L["Unwrap Gift"] = "Unwrap Gift"
--[[Translation missing --]]
L["Up"] = "Up"
--[[Translation missing --]]
L["Up to date"] = "Up to date"
--[[Translation missing --]]
L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
--[[Translation missing --]]
L["Updating"] = "Updating"
L["Usage: /tsm price <ItemLink> <Price String>"] = "用法：/tsm price <ItemLink(物品鏈接)> <Price String(價格)>"
--[[Translation missing --]]
L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
L["Variable Name"] = "Variable Name"
--[[Translation missing --]]
L["Vendor"] = "Vendor"
L["Vendor Buy Price"] = "買價"
--[[Translation missing --]]
L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
L["VENDOR SEARCH"] = "VENDOR SEARCH"
--[[Translation missing --]]
L["Vendor Sell"] = "Vendor Sell"
L["Vendor Sell Price"] = "賣價"
--[[Translation missing --]]
L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNING: The macro was too long, so was truncated to fit by WoW."
--[[Translation missing --]]
L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
--[[Translation missing --]]
L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
--[[Translation missing --]]
L["When above maximum:"] = "When above maximum:"
L["When below minimum:"] = "當低於最低價格時:"
--[[Translation missing --]]
L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
L["Whitelisted Players"] = "Whitelisted Players"
--[[Translation missing --]]
L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
L["You cannot use %s as part of this custom price."] = "你不能使用%s作為自定義價格的一部份。"
--[[Translation missing --]]
L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
--[[Translation missing --]]
L["You don't know how to craft this item."] = "You don't know how to craft this item."
--[[Translation missing --]]
L["You must reload your UI for these settings to take effect. Reload now?"] = "You must reload your UI for these settings to take effect. Reload now?"
--[[Translation missing --]]
L["You won an auction for %sx%d for %s"] = "You won an auction for %sx%d for %s"
--[[Translation missing --]]
L["Your auction has not been undercut."] = "Your auction has not been undercut."
--[[Translation missing --]]
L["Your auction of %s expired"] = "Your auction of %s expired"
--[[Translation missing --]]
L["Your auction of %s has sold for %s!"] = "Your auction of %s has sold for %s!"
L["Your Buyout"] = "你的直購價"
--[[Translation missing --]]
L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
L["Your task list is currently empty."] = "您的任務列表當前為空。"
--[[Translation missing --]]
L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
L["You've been undercut."] = "你已經被削價了。"
	else
		error("Unknown locale: "..tostring(locale))
	end

	--local HAS_STRINGS = next(L) and true or false
	setmetatable(L, {
		__index = function(t, k)
			--assert(not HAS_STRINGS)
			local v = tostring(k)
			rawset(t, k, v)
			return v
		end,
		__newindex = function(t, k, v)
			error("Cannot write to the locale table")
		end,
	})
end
