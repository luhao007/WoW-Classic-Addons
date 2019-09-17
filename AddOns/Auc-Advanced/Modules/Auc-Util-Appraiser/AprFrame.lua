--[[
	Auctioneer - Appraisals and Auction Posting
	Version: 8.2.6417 (SwimmingSeadragon)
	Revision: $Id: AprFrame.lua 6417 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds an appraisals tab to the AH for
	easy posting of your auctionables when you are at the auction house.

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
if not AucAdvanced then return end

local lib = AucAdvanced.Modules.Util.Appraiser
if not lib then return end
local private = lib.Private_AprFrame
if not private then return end
lib.Private_AprFrame = nil
local Const = AucAdvanced.Const
local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()

local frame

local NUM_ITEMS = 12

local SigFromLink = AucAdvanced.API.GetSigFromLink
local GetDistribution, GetColored -- to be filled in when ScanData loads
AucAdvanced.RegisterModuleCallback("scandata", function(lib) GetDistribution = lib.GetDistribution; GetColored = lib.Colored end)

-- Check to see if we are embedded or not
local embedded = false
for _, module in ipairs(AucAdvanced.EmbeddedModules) do
	if module == "Auc-Util-Appraiser" then
		embedded = true
	end
end

function private.CreateFrames()
	private.CreateFrames = nil

	local SelectBox = LibStub:GetLibrary("SelectBox")
	local ScrollSheet = LibStub:GetLibrary("ScrollSheet")

	frame = CreateFrame("Frame", "AucAdvAppraiserFrame", AuctionFrame)
	private.frame = frame
	local DiffFromModel = 0
	local MatchString = ""
	frame.list = {}
	frame.distributioncache = {}
	frame.distributionqueue = {}
	frame.valuecache = {}

	function frame.GenerateList(repos)
		-- repos = flag to force reposition of scroller
		if not frame:IsVisible() then return end --If we don't have Appraiser open, we don't need to run this. It will run when we go to Appraiser tab
		local ItemList = frame.list
		wipe(ItemList)

		for bag=0, NUM_BAG_FRAMES do
			for slot=1,GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag,slot)
				if link then
					local isDirect = frame.direct == link

					if AucAdvanced.Post.IsAuctionable(bag, slot) or isDirect then
						local sig, linkType = SigFromLink(link)
						if sig then
							local texture, itemCount, locked, special, readable = GetContainerItemInfo(bag,slot)
							if not itemCount or itemCount < 0 then itemCount = 1 end
							local found = false
							for i = 1, #ItemList do
								local item = ItemList[i]
								if item[1] == sig then
									item[6] = item[6] + itemCount
									found = true
									break
								end
							end

							if not found then
								local ignore = get('util.appraiser.item.'..sig..".ignore")

								if frame.showHidden or (not ignore) or isDirect then
									local name, rarity, stack
									if linkType == "item" then
										local na, _,ra,_,_,_,_, st = GetItemInfo(link)
										name, rarity, stack = na, ra, st
										if not name then
											private.needListRefresh = true
										end
									elseif linkType == "battlepet" then
										local _, id, _, qu = strsplit(":", link)
										id = tonumber(id)
										if id then
											name = C_PetJournal.GetPetInfoBySpeciesID(id)
											rarity = tonumber(qu)
											stack = 1
										end
									end
									if name and rarity then
										local item = {sig, name, texture, rarity, stack, itemCount, link}
										if ignore then
											item.ignore = true
										end
										table.insert(ItemList, item)
									end
								end
							end
						end
					end
				end
			end
		end

		if frame.showAuctions then
			local auctionStart = #ItemList + 1
			for auc=1, GetNumAuctionItems("owner") do
				local name, texture, count, quality, _, _, _, _, _, _, _, _, _, _, _, _, itemId = GetAuctionItemInfo("owner", auc)
				local link = GetAuctionItemLink("owner", auc)

				local sig, linkType = SigFromLink(link)
				if sig then
					local found = false
					for i = auctionStart, #ItemList do
						local item = ItemList[i]
						if item[1] == sig then
							item[6] = item[6] + count
							found = true
							break
						end
					end

					if not found then
						local _,_,_,_,_,_,_,stack = GetItemInfo(itemId)
						if not stack then
							private.needListRefresh = true
							stack = 1
						end
						local item = {
							sig, name, texture, quality, stack, count, link,
							auction=true
						}
						if get('util.appraiser.item.'..sig..".ignore") then
							item.ignore = true
						end
						table.insert(ItemList, item)
					end
				end
			end
		end

		table.sort(ItemList, private.sortItems)

		local listLen = #ItemList
		-- find the current (or next) selected item and update stored details
		local pos
		local item
		local sig = frame.selected
		if sig then
			local selected = frame.selectedItem
			local wasAuction = selected and selected.auction
			for i = 1, listLen do
				local itm = ItemList[i]
				if itm[1] == sig then
					pos = i
					item = itm
					if not wasAuction or item.auction then
						break
					end
				end
			end
		end
		if not item then
			local selected = frame.selectedItem
			if selected then
				if selected[7] == frame.selectedRawLink then -- we had a raw link and it matches last selected item
					item = selected -- note that this item is not included in ItemList
					item[6] = AucAdvanced.Post.CountAvailableItems(sig) -- re-count available items
					sig = item[1]
					-- pos remains nil
				elseif get("util.appraiser.reselect") then
					for i = 1, listLen do
						local itm = ItemList[i]
						if itm.ignore then -- don't auto-select ignored item
							break -- stop now because all items after first ignored item will also be ignored
						end
						if not private.sortItems(itm, selected) then -- we want first itm >= selected (see defn of sortItems in AprSettings.lua)
							if not itm.auction then -- don't auto-select auction item
								pos = i
								item = itm
								sig = item[1]
								break
							end
						end
					end
				end
			end
		end
		if item then
			frame.DisplaySelectedItem(item, sig, pos)
		else
			frame.ClearSelectedItem()
		end
		-- set scroller
		if listLen <= NUM_ITEMS then
			frame.scroller:Hide()
			frame.scroller:SetMinMaxValues(0, 0)
			frame.scroller:SetValue(0)
		else
			frame.scroller:SetMinMaxValues(0, listLen-NUM_ITEMS)
			if repos then
				if pos then
					frame.scroller:SetValue(max(0, min(listLen-NUM_ITEMS+1, pos-(NUM_ITEMS/2))))
				else
					frame.scroller:SetValue(0)
				end
			end
			frame.scroller:Show()
		end
		-- redraw list buttons
		frame.SetScroll()

		return pos
	end

	function frame.SelectItem(obj, button, rawlink)
		local item,sig,pos

		if obj then
			if not obj.id then obj = obj:GetParent() end
			pos = floor(frame.scroller:GetValue()) + obj.id
			if button and pos == frame.selectedPos then
				pos = nil
			else
				item = frame.list[pos]
				if item then
					sig = item[1]
				else
					pos = nil
				end
			end
			frame.selectedRawLink = nil
		elseif rawlink then
			sig, linkType = SigFromLink(rawlink)
			if not sig then return end
			for i,itm in ipairs(frame.list) do
				if itm[1]==sig then
					item=itm
					pos=i
					break
				end
			end
			if not item then
				local name, texture, rarity, stack
				if linkType == "item" then
					local na, _,ra,_,_,_,_,st,_,tx = GetItemInfo(rawlink)
					name, rarity, stack, texture = na, ra, st, tx
				elseif linkType == "battlepet" then
					local _, id, _, qu = strsplit(":", rawlink)
					id = tonumber(id)
					if id then
						name, texture = C_PetJournal.GetPetInfoBySpeciesID(id)
						rarity = tonumber(qu)
						stack = 1
					end
				end
				if not name and rarity then
					return
				end
				local myCount = AucAdvanced.Post.CountAvailableItems(sig)
				item = {
					sig, name, texture, rarity, stack, myCount, rawlink,
					raw = true,
				}
			end
			frame.selectedRawLink = rawlink -- rawlinked item should stay selected until manually deselected
		end

		if sig then
			frame.DisplaySelectedItem(item, sig, pos)

			--Also pass this search to BeanCounter's frame
			if BeanCounter and BeanCounter.API.search and BeanCounter.API.isLoaded then
				BeanCounter.API.search(item[7], nil, nil, 50)
			end
		else
			frame.ClearSelectedItem()
		end
		frame.SetScroll()

	end

	--private.empty = {}
	function frame.ClearSelectedItem()
		frame.selected = nil
		frame.selectedPos = nil
		frame.selectedItem = nil
		frame.selectedPostable = nil
		frame.salebox.sig = nil
		frame.salebox.name:SetText(_TRANS('APPR_Interface_NoItemSelected') )--No item selected
		frame.salebox.name:SetTextColor(0.5, 0.5, 0.7)
		if not get("util.appraiser.classic") then
			frame.salebox.info:SetText(_TRANS('APPR_Interface_SelectItemLeft') )--Select an item to the left to begin auctioning...
		else
			frame.salebox.info:SetText(_TRANS('APPR_Interface_SelectItemAuctioning') )--Select an item to begin auctioning...
		end
		frame.salebox.info:SetTextColor(0.5, 0.5, 0.7)
		frame.UpdateImage() -- will cause image to be cleared, as frame.salebox.sig is nil
		--frame.imageview.sheet:SetData(private.empty)
		--frame.UpdatePricing()
		frame.UpdateDisplay()
	end

	function frame.DisplaySelectedItem(item, sig, pos)
		frame.selected = sig
		frame.selectedPos = pos
		frame.selectedItem = item
		frame.selectedPostable = not (item.auction or item[6]<1)
		frame.salebox.sig = sig
		local _,_,_, hex = GetItemQualityColor(item[4])
		frame.salebox.icon:SetNormalTexture(item[3])
		frame.salebox.name:SetText("|c"..hex.."["..item[2].."]|r")
		if item.auction then
			frame.salebox.info:SetText(_TRANS('APPR_Interface_HaveUpAuction'):format(item[6]) )--You have %s up for auction
		else
			frame.salebox.info:SetText(_TRANS('APPR_Interface_HaveAvailableAuction'):format(item[6]) )--You have %s available to auction
		end
		frame.salebox.info:SetTextColor(1,1,1, 0.8)
		frame.salebox.link = item[7]
		frame.salebox.stacksize = item[5]
		frame.salebox.count = item[6]

		frame.UpdateImage()
		frame.InitControls()
	end

	function frame.SelectNext()
		-- select next postable item
		local pos, item
		pos = frame.selectedPos
		if not pos then return end
		repeat
			pos = pos + 1
			item = ItemList[pos]
		until not item or (item[6] > 0 and not item.auction)
		if item then
			frame.DisplaySelectedItem(item, item[1], pos)
		else
			frame.ClearSelectedItem()
		end
	end

	function private.SelectNextOnPost(success, id, postresult, errcode)
		--[[ todo: add settings option to enable this feature
		local sig = postresult.sig or postresult[1]
		if sig == frame.selected then
			frame.SelectNext()
		end
		--]]
	end

	-- this function is not used - can it be removed? (along with the supporting code for frame.direct in GenerateList)
	function frame.DirectSelect(link)
		if frame.direct == link then return end
		frame.direct = link
		frame.GenerateList()
		frame.GetItemByLink(link)
		frame.GenerateList(true)
	end

	local lastImageSig
	local throttleImageNext = GetTime()
	local emptyData = {}
	-- Main Image Update entry point
	function frame.UpdateImage()
		local sig = frame.salebox.sig
		if not sig then
			if lastImageSig then
				frame.imageview.sheet:SetData(emptyData)
			end
			lastImageSig = nil
			private.needImageUpdate = nil
			return
		end
		-- schedule a call to DelayedImageUpdate for the next OnUpdate
		-- this prevents multiple image renders in a single frame/update cycle
		-- also creates an implied IsVisible check, as OnUpdate is only called for visible frames
		private.needImageUpdate = sig
	end
	-- Function to check for a delayed update, and force it to happen immediately
	-- Should be called only where the user is actually interacting with the image sheet, and we need to be certain it is up to date
	function frame.CheckImageUpdate()
		if private.needImageUpdate then -- there is an image update scheduled
			throttleImageNext = GetTime() -- override any existing throttle, to force an immediate update
			private.DelayedImageUpdate()
		end
	end
	-- The actual image update function is always delayed:
	-- Normally delayed by 1 frame (called from OnUpdate)
	-- Multiple updates without changing the selected item are throttled to 3 seconds
	-- Exception: CheckImageUpdate allows the throttle to be overridden if required
	local query = {} -- query table used for QueryImage
	local tleftlookup = {
		"|cff000001|cffe5e5e530m", -- 30m
		"|cff000002|cffe5e5e52h",  --2h
		"|cff000003|cffe5e5e512h", --12h
		"|cff000004|cffe5e5e548h"  --48h
	}

    if AucAdvanced.Classic then
        tleftlookup = {
            "|cff000001|cffe5e5e530m", --30m
            "|cff000002|cffe5e5e52h",  --2h
            "|cff000003|cffe5e5e58h",  --8h
            "|cff000004|cffe5e5e524h"  --24h
        }
    end

	function private.DelayedImageUpdate()
		local sig = frame.salebox.sig
		if not sig then -- sanity check
			frame.UpdateImage()
			return
		end
		local sigChanged = lastImageSig ~= sig or private.needImageUpdate ~= sig
		local now = GetTime()
		if not sigChanged and now < throttleImageNext then
			-- private.needImageUpdate is still set to sig
			return
		end

		private.needImageUpdate = nil
		throttleImageNext = now + 3 -- 3 second throttle
		lastImageSig = sig

		local sigType, property1, property2, property3 = AucAdvanced.API.DecodeSig(sig)
		if sigType == "item" then
			query.itemId = property1
			query.suffix = property2
			query.factor = property3
			query.speciesID = nil
			query.quality = nil
			query.minItemLevel = nil
			query.maxItemLevel = nil
		elseif sigType == "battlepet" then
			query.speciesID = property1
			query.quality = property3
			query.minItemLevel = property2
			query.maxItemLevel = property2
			query.itemId = 82800
			query.suffix = nil
			query.factor = nil
		else
			frame.imageview.sheet:SetData(emptyData)
			return
		end

		local results = AucAdvanced.API.QueryImage(query)
		local seen
		local seentext = ""
		if results[1] then
			seen = results[1][Const.TIME]
		end
		if not seen then
			local scanstats = AucAdvanced.API.GetScanStats()
			if scanstats then
				seen = scanstats.LastFullScan
				seentext = _TRANS("APPR_Interface_NotInScan")..".  " --Not seen in current scan
			end
		end
		if not seen then seen = 0 end
		if (time() - seen) < 60 then
			seentext = seentext .. _TRANS('APPR_Interface_Data1MinOld') --Data is < 1 minute old
		elseif ((time() - seen) / 3600) <= 48 then
			seentext = seentext .. _TRANS('APPR_Interface_DataIsXOld'):format(SecondsToTime(time() - seen, true)) --Data is %s old
		elseif seen == 0 then
			seentext = _TRANS('APPR_Interface_NoDataFor').." "..string.sub(frame.salebox.name:GetText(), 12, -4) --No data for
		else
			seentext = seentext .. _TRANS('APPR_Interface_Data48HoursOld') --Data is > 48 hours old
		end
		frame.age:SetText(seentext)


		local data = {}
		local style = {}
		for i = 1, #results do
			local result = results[i]
			local tLeft = tleftlookup[result[Const.TLEFT]] or ""
			local count = result[Const.COUNT]
			data[i] = {
				--result[Const.NAME],
				result[Const.SELLER],
				tLeft,
				count,
				math.floor(0.5+result[Const.MINBID]/count),
				math.floor(0.5+result[Const.CURBID]/count),
				math.floor(0.5+result[Const.BUYOUT]/count),
				result[Const.MINBID],
				result[Const.CURBID],
				result[Const.BUYOUT],
				result[Const.LINK]
			}
			local curbid = result[Const.CURBID]
			if curbid == 0 then
				curbid = result[Const.MINBID]
			end
			--price level color item
			local r, g, b, Alpha1, Alpha2, direction = frame.SetPriceColor(result[Const.LINK], count, curbid, result[Const.BUYOUT])
			if direction and r then
				style[i] = {}
				style[i][1] = {}
				style[i][1].rowColor = {r, g, b, Alpha1, Alpha2, direction}
			end
			--color ignored sellers
			if AucAdvanced.Modules.Filter.Basic and AucAdvanced.Modules.Filter.Basic.IsPlayerIgnored and AucAdvanced.Modules.Filter.Basic.IsPlayerIgnored(result[Const.SELLER]) then
				if not style[i] then style[i] = {} end
				style[i][1] = {}
				style[i][1].textColor = {1,0,0}
			end
		end
		frame.refresh:Enable()
		local sheet = frame.imageview.sheet
		sheet:EnableVerticalScrollReset(sigChanged)
		sheet:SetData(data, style)
		sheet:EnableVerticalScrollReset(false)
	end

	function frame.SetPriceColor(link, count, requiredBid, buyoutPrice, rDef, gDef, bDef)
		if get('util.appraiser.color') and AucAdvanced.Modules.Util.PriceLevel then
			if type(link) == "number" then
				local _, l = GetItemInfo(link)
				link = l
			end
			if not link then return end
			local _, _, r,g,b = AucAdvanced.Modules.Util.PriceLevel.CalcLevel(link, count, requiredBid, buyoutPrice)

			local direction = get("util.appraiser.colordirection")
			if (direction == "LEFT") then
				return r,g,b, 0, 0.2, "Horizontal"
			elseif (direction == "RIGHT") then
				return r,g,b, 0.2, 0, "Horizontal"
			elseif (direction == "BOTTOM") then
				return r,g,b, 0, 0.2, "Vertical"
			elseif (direction == "TOP") then
				return r,g,b, 0.2, 0, "Vertical"
			else
				return r,g,b
			end
		end
		return rDef,gDef,bDef
	end

	function frame.InitControls()
		frame.valuecache = {}

        local maxDuration = 2880;
        if AucAdvanced.Classic then maxDuration = 1440 end

		local curDuration = get('util.appraiser.item.'..frame.salebox.sig..".duration") or
			get('util.appraiser.duration') or maxDuration

		for i=1, #private.durations do
			if (curDuration == private.durations[i][1]) then
				frame.salebox.duration:SetValue(i)
				frame.valuecache.duration = i
				break
			end
		end

		local defStack = get("util.appraiser.stack")
		if defStack == "max" then
			defStack = frame.salebox.stacksize
		elseif (not (tonumber(defStack))) then
			defStack = frame.salebox.stacksize
			set("util.appraiser.stack", "max")
		end
		defStack = tonumber(defStack)
		if defStack > frame.salebox.stacksize then
			defStack = frame.salebox.stacksize
		end
		local curStack = get('util.appraiser.item.'..frame.salebox.sig..".stack") or defStack
		frame.salebox.stack:SetMinMaxValues(1, frame.salebox.stacksize)
		frame.salebox.stack:SetValue(curStack)
		frame.salebox.stackentry:SetNumber(curStack)
		frame.valuecache.stack = frame.salebox.stack:GetValue()
		frame.valuecache.stackentry = frame.salebox.stackentry:GetNumber()

		local defStack = get("util.appraiser.number")
		if defStack == "maxplus" then
			defStack = -1
		elseif defStack == "maxfull" then
			defStack = -2
		elseif (not (tonumber(defStack))) then
			defStack = -1
			set("util.appraiser.number", "maxplus")
		else
			defStack = tonumber(defStack)
		end
		local curNumber = get('util.appraiser.item.'..frame.salebox.sig..".number") or defStack
		local range = math.max(curNumber, math.floor(frame.salebox.count/frame.salebox.stacksize))
		if frame.salebox.stacksize > 1 then
			frame.salebox.number:SetAdjustedRange(range, -2, -1)--make sure the slider can handle the setting before we set it
		else
			frame.salebox.number:SetAdjustedRange(range, -1)--make sure the slider can handle the setting before we set it
		end
		frame.salebox.number:SetAdjustedValue(curNumber)
		if curNumber == -2 then
			frame.salebox.numberentry:SetText(_TRANS('APPR_Interface_Full') )--Full
		elseif curNumber == -1 then
			frame.salebox.numberentry:SetText(_TRANS('APPR_Interface_All') )--All
		else
			frame.salebox.numberentry:SetNumber(curNumber)
		end
		frame.valuecache.number = frame.salebox.number:GetAdjustedValue()
		frame.valuecache.numberentry = frame.salebox.numberentry:GetText()

		-- Only post above number of items, no more. (ie. keep track of current auctions)
		local curNumberOnly = get('util.appraiser.item.'..frame.salebox.sig..".numberonly")
		if curNumberOnly == "on" then
			frame.salebox.numberonly:SetChecked(true)
		elseif curNumberOnly == "off" then
			frame.salebox.numberonly:SetChecked(false)
		else
			frame.salebox.numberonly:SetChecked(curNumberOnly)
		end
		frame.valuecache.numberonly = frame.salebox.numberonly:GetChecked()

		local defMatch = get("util.appraiser.match")
		local curMatch = get('util.appraiser.item.'..frame.salebox.sig..".match")
		if curMatch == nil then
			curMatch = defMatch
		end
		if curMatch == "on" then
			frame.salebox.matcher:SetChecked(true)
		elseif curMatch == "off" then
			frame.salebox.matcher:SetChecked(false)
		else
			frame.salebox.matcher:SetChecked(curMatch)
		end
		frame.valuecache.matcher = frame.salebox.matcher:GetChecked()

		local ignore = get("util.appraiser.item."..frame.salebox.sig..".ignore") or false
		frame.salebox.ignore:SetChecked(ignore)
		frame.valuecache.ignore = frame.salebox.ignore:GetChecked()

		local curBulk = get('util.appraiser.item.'..frame.salebox.sig..".bulk") or false
		frame.salebox.bulk:SetChecked(curBulk)
		frame.valuecache.bulk = frame.salebox.bulk:GetChecked()


		local curModel = get('util.appraiser.item.'..frame.salebox.sig..".model") or "default"
		frame.salebox.model.value = curModel
		frame.salebox.model:UpdateValue()
		frame.valuecache.model = curModel

		frame.UpdatePricing()
		frame.UpdateDisplay()
		frame.salebox.config = nil -- ### not used?
	end

	function frame.ShowOwnAuctionDetails(itemLink)
        local colored = (get('util.appraiser.manifest.color') and AucAdvanced.Modules.Util.PriceLevel)
		local itemName
		local header, id = strsplit(":", itemLink)
		local lType = header:sub(-4)
		if lType == "item" then
			itemName = GetItemInfo(itemLink)
		elseif lType == "epet" then -- battlepet
			id = tonumber(id)
			if id then
				itemName = C_PetJournal.GetPetInfoBySpeciesID(id)
			end
		end
		if not itemName then return end

		local results = lib.ownResults[itemName]
		local counts = lib.ownCounts[itemName]

		if counts and #counts>0 then
			table.sort(counts)

			frame.manifest.lines:Add("")
			frame.manifest.lines:Add("Own auctions:       |cffffffff(price/each)", nil, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

			for _,count in ipairs(counts) do
				local res = results[count]
				local avgBid = res.countBid>0 and (res.sumBid / res.countBid) or nil
				local avgBO =  res.countBO>0 and (res.sumBO / res.countBO) or nil

				local r,g,b,_
				if colored then
					_, _, r,g,b = AucAdvanced.Modules.Util.PriceLevel.CalcLevel(itemLink, 1, avgBid, avgBO)
				end
				r,g,b = r or 1,g or 1, b or 1

				frame.manifest.lines:Add(format("  %2d lots of %2dx", res.stackCount, count)..
					(avgBO and "" or " (bid)"), avgBO or avgBid, r,g,b)
			end
		end
	end

	function frame.OnUpdate()
		if frame.updated then
			frame.CheckUpdates()
		end
		if private.needDistributionUpdate then
			private.DelayedDistributionUpdate()
		end
		if frame.scanFinished then
			frame.GenerateList()
			frame.scanFinished = nil
		end
		if private.needImageUpdate then
			private.DelayedImageUpdate()
		end
	end

	--This gets run whenever a setting has been changed manually
	--Each setting has its section to update other controls as needed, and update the saved and cached settings
	--frame.UpdateDisplay() gets run at the end
	--if the setting change might change the price, run frame.UpdatePricing() within the setting's section
	function frame.CheckUpdates()
		frame.updated = nil
		if not frame.salebox.sig then return end

		local stack = frame.salebox.stack:GetValue()
		local stackentry = frame.salebox.stackentry:GetNumber()
		local number = frame.salebox.number:GetAdjustedValue()
		local numberentry = frame.salebox.numberentry:GetText()
		if stack ~= frame.valuecache.stack then
			frame.valuecache.stack = stack
			frame.valuecache.stackentry = stack
			frame.salebox.stackentry:SetNumber(stack)
			set("util.appraiser.item."..frame.salebox.sig..".stack", stack)
		elseif stackentry ~= frame.valuecache.stackentry then
			frame.salebox.stack:SetValue(stackentry)
			stackentry = frame.salebox.stack:GetValue()
			frame.salebox.stackentry:SetNumber(stackentry)
			frame.valuecache.stack = stackentry
			frame.valuecache.stackentry = stackentry
			set("util.appraiser.item."..frame.salebox.sig..".stack", stackentry)
		elseif number ~= frame.valuecache.number then
			if number >= -2 and number < 0 then
				if number == -2 then
					frame.salebox.numberentry:SetText(_TRANS('APPR_Interface_Full') )--Full
				else
					frame.salebox.numberentry:SetText(_TRANS('APPR_Interface_All') )--All
				end
			else
				frame.salebox.numberentry:SetNumber(number)
			end
			frame.valuecache.number = number
			frame.valuecache.numberentry = frame.salebox.numberentry:GetText()
			set("util.appraiser.item."..frame.salebox.sig..".number", number)
		elseif numberentry ~= frame.valuecache.numberentry then
			if numberentry:lower() == _TRANS('APPR_Interface_Full'):lower() then --Full
				frame.salebox.number:SetAdjustedValue(-2)
				numberentry = _TRANS('APPR_Interface_Full') --Full
				set("util.appraiser.item."..frame.salebox.sig..".number", -2)
			elseif numberentry:lower() == _TRANS('APPR_Interface_All'):lower() then --All
				frame.salebox.number:SetAdjustedValue(-1)
				numberentry = _TRANS('APPR_Interface_All') --All
				set("util.appraiser.item."..frame.salebox.sig..".number", -1)
			elseif tonumber(numberentry) == nil then --we've typed in a partial word.  let them keep typing
			else
				numberentry = frame.salebox.numberentry:GetNumber()
				if numberentry > frame.salebox.number.maxStax then
					local n = #frame.salebox.number.extra
					frame.salebox.number.maxStax = numberentry
					frame.salebox.number:SetMinMaxValues(1, numberentry + n)
				end
				frame.salebox.number:SetAdjustedValue(numberentry)
				numberentry = frame.salebox.number:GetAdjustedValue()
				set("util.appraiser.item."..frame.salebox.sig..".number", numberentry)
			end
			frame.salebox.numberentry:SetText(numberentry)
			frame.valuecache.numberentry = frame.salebox.numberentry:GetText()
			frame.valuecache.number = frame.salebox.number:GetAdjustedValue()
		end

		local numberonly = frame.salebox.numberonly:GetChecked()
		if numberonly ~= frame.valuecache.numberonly then
			frame.valuecache.numberonly = numberonly
			if numberonly then
				numberonly = "on"
			else
				numberonly = "off"
			end
			set("util.appraiser.item."..frame.salebox.sig..".numberonly", numberonly)
		end

		local ignore = frame.salebox.ignore:GetChecked()
		if ignore ~= frame.valuecache.ignore then
			frame.valuecache.ignore = ignore
			if ignore then
				ignore = "on"
			else
				ignore = "off"
			end
			set("util.appraiser.item."..frame.salebox.sig..".ignore", ignore)
			frame.GenerateList()
		end

		local bulk = frame.salebox.bulk:GetChecked()
		if bulk ~= frame.valuecache.bulk then
			frame.valuecache.bulk = bulk
			if bulk then
				bulk = "on"
			else
				bulk = "off"
			end
			set("util.appraiser.item."..frame.salebox.sig..".bulk", bulk)

			frame.GenerateList()

		end

		local duration = frame.salebox.duration:GetValue()
		local matcher = frame.salebox.matcher:GetChecked()
		local bid = MoneyInputFrame_GetCopper(frame.salebox.bid)
		local buy = MoneyInputFrame_GetCopper(frame.salebox.buy)
		local model = frame.salebox.model.value
		if duration ~= frame.valuecache.duration then
			frame.valuecache.duration = duration
			set("util.appraiser.item."..frame.salebox.sig..".duration", private.durations[duration][1])
			frame.UpdatePricing()
		elseif matcher ~= frame.valuecache.matcher then
			frame.valuecache.matcher = matcher
			if matcher then
				matcher = "on"
			else
				matcher = "off"
			end
			set("util.appraiser.item."..frame.salebox.sig..".match", matcher)
			frame.UpdatePricing()
		elseif bid ~= frame.valuecache.bid then
			frame.valuecache.bid = bid
			frame.salebox.matcher:SetChecked(false)
			frame.valuecache.matcher = frame.salebox.matcher:GetChecked()
			set("util.appraiser.item."..frame.salebox.sig..".match", "off")
			set("util.appraiser.item."..frame.salebox.sig..".model", "fixed")
			frame.valuecache.model = "fixed"
			frame.salebox.model.value = "fixed"
			frame.salebox.model:UpdateValue()
			set("util.appraiser.item."..frame.salebox.sig..".fixed.bid", bid)
			set("util.appraiser.item."..frame.salebox.sig..".fixed.buy", buy)
			frame.UpdatePricing()
		elseif buy ~= frame.valuecache.buy then
			frame.valuecache.buy = buy
			frame.salebox.matcher:SetChecked(false)
			frame.valuecache.matcher = frame.salebox.matcher:GetChecked()
			set("util.appraiser.item."..frame.salebox.sig..".match", "off")
			set("util.appraiser.item."..frame.salebox.sig..".model", "fixed")
			frame.valuecache.model = "fixed"
			frame.salebox.model.value = "fixed"
			frame.salebox.model:UpdateValue()
			set("util.appraiser.item."..frame.salebox.sig..".fixed.bid", bid)
			set("util.appraiser.item."..frame.salebox.sig..".fixed.buy", buy)
			frame.UpdatePricing()
		elseif model ~= frame.valuecache.model then
			set("util.appraiser.item."..frame.salebox.sig..".model", model)
			frame.valuecache.model = model
			if model == "fixed" then
				frame.salebox.matcher:SetChecked(false)
				frame.valuecache.matcher = frame.salebox.matcher:GetChecked()
				set("util.appraiser.item."..frame.salebox.sig..".match", "off")
				set("util.appraiser.item."..frame.salebox.sig..".fixed.bid", bid)
				set("util.appraiser.item."..frame.salebox.sig..".fixed.buy", buy)
			else
				set("util.appraiser.item."..frame.salebox.sig..".fixed.bid")
				set("util.appraiser.item."..frame.salebox.sig..".fixed.buy")
			end
			frame.UpdatePricing()
		end
		frame.UpdateDisplay()
	end

	--Runs whenever the Pricing needs updating
	--frame.UpdateDisplay() should be called after calling this function
	function frame.UpdatePricing()
		if not frame.salebox.sig then return end
		local link = lib.GetLinkFromSig(frame.salebox.sig)
		local buy, bid, _, _, curModelText
		buy, bid, _, _, curModelText, MatchString = lib.GetPrice(link, nil, true)
		if not MatchString then
			MatchString = ""
		end

		local stack = frame.salebox.stack:GetValue() or 1
		MoneyInputFrame_SetCopper(frame.salebox.buy.stack, buy*stack)
		MoneyInputFrame_SetCopper(frame.salebox.bid.stack, bid*stack)
		MoneyInputFrame_SetCopper(frame.salebox.buy, buy)
		MoneyInputFrame_SetCopper(frame.salebox.bid, bid)

		frame.valuecache.bid = MoneyInputFrame_GetCopper(frame.salebox.bid)
		frame.valuecache.buy = MoneyInputFrame_GetCopper(frame.salebox.buy)
		frame.salebox.model:SetText(curModelText)
		--frame.UpdateImage()--Why? I dont see a need to recreate the complete scrollsheet.
	end

	--gets called whenever the display needs to be updated.
	--except for when selecting or deselecting an item
	--this function doesn't change any of the controls, merely the display
	function frame.UpdateDisplay()
		if (not frame.salebox.sig) then -- nothing selected
			frame.salebox.icon:SetAlpha(0)
			frame.salebox.stack:Hide()
			frame.salebox.number:Hide()
			frame.salebox.numberonly:Hide()
			frame.salebox.stackentry:Hide()
			frame.salebox.numberentry:Hide()
			frame.salebox.model:Hide()
			frame.salebox.matcher:Hide()
			frame.salebox.bid:Hide()
			frame.salebox.buy:Hide()
			--Stack saleboxes
			frame.salebox.bid.stack:Hide()
			frame.salebox.buy.stack:Hide()
			frame.salebox.duration:Hide()
			frame.manifest.lines:Clear()
			frame.manifest:Hide()
			frame.toggleManifest:Disable()
			frame.age:SetText("")
			frame.go:Disable()
			frame.salebox.ignore:Hide()
			frame.salebox.warn:SetText("")
			frame.salebox.bulk:Hide()
			frame.switchToStack:Hide()
			frame.switchToStack2:Hide()
			return
		end
		frame.salebox.icon:SetAlpha(1)
		frame.salebox.matcher:Show()
		--hides/shows the stack price money entry or per item money entry boxes
		if get("util.appraiser.classic") then
			frame.salebox.bid.stack:Show()
			frame.salebox.buy.stack:Show()
			frame.salebox.bid:Hide()
			frame.salebox.buy:Hide()
		else
			frame.salebox.bid:Show()
			frame.salebox.buy:Show()
			frame.salebox.bid.stack:Hide()
			frame.salebox.buy.stack:Hide()
		end
		frame.switchToStack:Show()
		frame.switchToStack2:Show()

		frame.salebox.model:Show()
		frame.salebox.duration:Show()
		frame.salebox.numberonly:Show()
		frame.manifest.lines:Clear()
		frame.manifest:SetFrameLevel(AuctionFrame:GetFrameLevel())

		frame.salebox.ignore:Show()
		frame.salebox.bulk:Show()
		if not frame.selectedPostable then
			frame.salebox.number:Hide()
			frame.salebox.stack:Hide()
			frame.salebox.stackentry:Hide()
			frame.salebox.numberentry:Hide()
		else
			frame.salebox.number:Show()
			frame.salebox.stack:Show()
			frame.salebox.stackentry:Show()
			frame.salebox.numberentry:Show()
		end

		frame.toggleManifest:Enable()
		if frame.toggleManifest:GetText() == "Close Sidebar" then
			frame.manifest:Show()
		end

		frame.refresh:Enable()
		local matchers = AucAdvanced.API.GetNumMatchers()
		if matchers == 0 then
			frame.salebox.matcher:Disable()
			frame.salebox.matcher.label:SetTextColor(.5, .5, .5)
		else
			frame.salebox.matcher:Enable()
			frame.salebox.matcher.label:SetTextColor(1, 1, 1)
		end

		local itemLink = frame.salebox.link

		local curDurationIdx = frame.salebox.duration:GetValue() or 3
		local curDurationMins = private.durations[curDurationIdx][1]
		local curDurationText = private.durations[curDurationIdx][2]
		frame.salebox.duration.label:SetText(_TRANS('APPR_Interface_Duration: %s'):format(curDurationText))--Duration: %s

		local curIgnore = frame.salebox.ignore:GetChecked()
		frame.salebox.icon:GetNormalTexture():SetDesaturated(curIgnore)

		local curModel = get('util.appraiser.item.'..frame.salebox.sig..".model") or "default"
		local curBid = MoneyInputFrame_GetCopper(frame.salebox.bid) or 0
		local curBuy = MoneyInputFrame_GetCopper(frame.salebox.buy) or 0

		local sig = frame.salebox.sig
		local totalBid, totalBuy = 0,0
		local totalDeposit
		local bidVal, buyVal, depositVal

		local r,g,b,a = 0,0,0,0
		local colored = get('util.appraiser.manifest.color')
		local tinted = get('util.appraiser.tint.color')
		if tinted then
			r,g,b = frame.SetPriceColor(itemLink, 1, curBuy, curBuy, r,g,b)
			if r then a = 0.4 end
		end
		AppraiserSaleboxBuyGold:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBuySilver:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBuyCopper:SetBackdropColor(r,g,b, a)

		AppraiserSaleboxBuyStackGold:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBuyStackSilver:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBuyStackCopper:SetBackdropColor(r,g,b, a)

		r,g,b,a=0,0,0,0
		if tinted then
			r,g,b = frame.SetPriceColor(itemLink, 1, curBid, curBid,  r,g,b)
			if r then a=0.4 end
		end
		AppraiserSaleboxBidGold:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBidSilver:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBidCopper:SetBackdropColor(r,g,b, a)

		AppraiserSaleboxBidStackGold:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBidStackSilver:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBidStackCopper:SetBackdropColor(r,g,b, a)

		if frame.selectedPostable then
			local curNumber = frame.salebox.number:GetAdjustedValue()
			-- used in GetDepositCost calls:
			local depositHours = curDurationMins / 60

			if frame.salebox.stacksize > 1 then
				local count = frame.salebox.count

				local curSize = frame.salebox.stack:GetValue()
				local extra = ""
				local maxStax = math.floor(count / curSize)
				local fullPop = maxStax*curSize
				local remain = count - fullPop
				--we don't want to lose any saved settings, so don't let the maxStax get below the saved value
				local SavedNumber = get('util.appraiser.item.'..frame.salebox.sig..".number") or 0
				if (tonumber(SavedNumber) > 0) and SavedNumber > maxStax then
					maxStax = SavedNumber
				end

				if (curSize > count) then
					extra = "  |cffffaa40" .. _TRANS('APPR_Interface_StackGreaterAvailable') --(Stack > Available)
				elseif ((curSize * maxStax) > count) then
					extra = "  |cffffaa40" .. _TRANS('APPR_Interface_NumberGreaterAvailable') --(Number > Available)
				end
				frame.salebox.stack.label:SetText(_TRANS('APPR_Interface_StackSize'):format(curSize)..extra)--Stack size: %d
				frame.salebox.number:SetAdjustedRange(maxStax, -2, -1)
				if (curNumber >= -2 and curNumber < 0) then
					if (curNumber == -2) then
						frame.salebox.number.label:SetText(_TRANS('APPR_Interface_NumberAllFullStacks'):format(maxStax, fullPop))--Number: All full stacks (%d) = %d
					else
						frame.salebox.number.label:SetText(_TRANS('APPR_Interface_NumberAllStacksPlus'):format(maxStax, remain, count))--Number: All stacks (%d) plus %d = %d
					end
					if (maxStax > 0) then
						frame.manifest.lines:Clear()
						frame.manifest.lines:Add(_TRANS('APPR_Interface_LotsOfStacks'):format(maxStax, curSize))--%d lots of %dx stacks:
						buyVal, bidVal = lib.RoundBuyBid(curBuy * curSize, curBid * curSize)
						depositVal = AucAdvanced.Post.GetDepositCost(frame.salebox.link, depositHours, bidVal, buyVal, curSize, 1)

						r,g,b=nil,nil,nil
						if colored then
							r,g,b = frame.SetPriceColor(itemLink, curSize, bidVal, bidVal)
						end
						frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_BidForX'):format(curSize), bidVal, r,g,b)--Bid for %dx
						r,g,b=nil,nil,nil
						if colored then
							r,g,b = frame.SetPriceColor(itemLink, curSize, buyVal, buyVal)
						end
						frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_BuyoutForX'):format(curSize), buyVal, r,g,b)--Buyout for %dx
						if depositVal then
							frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_DepositForX'):format(curSize), depositVal)--Deposit for %dx
							totalDeposit = depositVal * maxStax
						end
						totalBid = totalBid + (bidVal * maxStax)
						totalBuy = totalBuy + (buyVal * maxStax)
					end
					if curNumber == -1 and remain > 0 then
						buyVal, bidVal = lib.RoundBuyBid(curBuy * remain, curBid * remain)
						depositVal = AucAdvanced.Post.GetDepositCost(frame.salebox.link, depositHours, bidVal, buyVal, remain, 1)

						frame.manifest.lines:Add(_TRANS('APPR_Interface_LotsOfStacks') :format(1, remain))--%d lots of %dx stacks:
						r,g,b=nil,nil,nil
						if colored then
							r,g,b = frame.SetPriceColor(itemLink, remain, bidVal, bidVal)
						end
						frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_BidForX'):format(remain), bidVal, r,g,b)--Bid for %dx
						r,g,b=nil,nil,nil
						if colored then
							r,g,b = frame.SetPriceColor(itemLink, remain, buyVal, buyVal)
						end
						frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_BuyoutForX'):format(remain), buyVal, r,g,b)--Buyout for %dx
						if depositVal then
							frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_DepositForX'):format(remain), depositVal)--Deposit for %dx
							totalDeposit = (totalDeposit or 0) + depositVal
						end
						totalBid = totalBid + bidVal
						totalBuy = totalBuy + buyVal
					end
				else
					frame.salebox.number.label:SetText(_TRANS('APPR_Interface_NumberStacks'):format(curNumber, curNumber*curSize))--Number: %d stacks = %d
					frame.manifest.lines:Clear()
					frame.manifest.lines:Add(_TRANS('APPR_Interface_LotsOfStacks'):format(curNumber, curSize))--%d lots of %dx stacks:
					buyVal, bidVal = lib.RoundBuyBid(curBuy * curSize, curBid * curSize)
					depositVal = AucAdvanced.Post.GetDepositCost(frame.salebox.link, depositHours, bidVal, buyVal, curSize, 1)

					r,g,b=nil,nil,nil
					if colored then
						r,g,b = frame.SetPriceColor(itemLink, curSize, bidVal, bidVal)
					end
					frame.manifest.lines:Add(("  ".._TRANS('APPR_Interface_BidForX')):format(curSize), bidVal, r,g,b)--Bid for %dx
					r,g,b=nil,nil,nil
					if colored then
						r,g,b = frame.SetPriceColor(itemLink, curSize, buyVal, buyVal)
					end
					frame.manifest.lines:Add(("  ".._TRANS('APPR_Interface_BuyoutForX')):format(curSize), buyVal, r,g,b)--Buyout for %dx
					if depositVal then
						frame.manifest.lines:Add(("  ".._TRANS('APPR_Interface_DepositForX')):format(curSize), depositVal)--Deposit for %dx
						totalDeposit = depositVal * curNumber
					end
					totalBid = totalBid + (bidVal * curNumber)
					totalBuy = totalBuy + (buyVal * curNumber)
				end
			else -- non-stackable
				frame.salebox.stack.label:SetText(_TRANS('APPR_Interface_NotStackable')) --Item is not stackable
				local maxStax = frame.salebox.count
				local SavedNumber = get('util.appraiser.item.'..frame.salebox.sig..".number") or 0
				if (tonumber(SavedNumber) > 0) and SavedNumber > maxStax then
					maxStax = SavedNumber
				end
				frame.salebox.number:SetAdjustedRange(maxStax, -1)
				if (curNumber == -1) then
					curNumber = frame.salebox.count
					frame.salebox.number.label:SetText(_TRANS('APPR_Interface_NumberAllItems'):format(curNumber))--Number: All items = %d
				else
					frame.salebox.number.label:SetText(_TRANS('APPR_Interface_NumberItems'):format(curNumber))--Number: %d items
				end
				if curNumber > 0 then
					frame.manifest.lines:Clear()
					frame.manifest.lines:Add(_TRANS('APPR_Interface_Items'):format(curNumber))--%d items
					buyVal, bidVal = lib.RoundBuyBid(curBuy, curBid)
					depositVal = AucAdvanced.Post.GetDepositCost(frame.salebox.link, depositHours, curBid, curBuy, 1, 1)

					r,g,b=nil,nil,nil
					if colored then
						r,g,b = frame.SetPriceColor(itemLink, 1, bidVal, bidVal)
					end
					frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_Bid/item'), bidVal, r,g,b)--Bid /item
					r,g,b=nil,nil,nil
					if colored then
						r,g,b = frame.SetPriceColor(itemLink, 1, buyVal, buyVal)
					end
					frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_Buyout/item'), buyVal, r,g,b)--Buyout /item
					if depositVal then
						frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_Deposit/item'), depositVal)--Deposit /item
						totalDeposit = depositVal * curNumber
					end
					totalBid = totalBid + (bidVal * curNumber)
					totalBuy = totalBuy + (buyVal * curNumber)
				end
			end
			frame.manifest.lines:Add(_TRANS('APPR_Interface_Totals') )--Totals:
			frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_TotalBid'), totalBid)--Total Bid:
			frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_TotalBuyout'), totalBuy)--Total Buyout:
			if totalDeposit then
				frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_TotalDeposit'), totalDeposit)--Total Deposit:
			else
				frame.manifest.lines:Add("  ".._TRANS('APPR_Interface_UnknownDeposit'))--Unknown deposit cost
			end
			if (frame.salebox.matcher:GetChecked() and (frame.salebox.matcher:IsEnabled()) and (DiffFromModel)) then
				local MatchStringList = {strsplit("\n", MatchString)}
				for i in pairs(MatchStringList) do
					frame.manifest.lines:Add((MatchStringList[i]))
				end
			end

			if (totalBid < 1) then
				frame.manifest.lines:Add(("------------------------------"))
				frame.manifest.lines:Add(_TRANS('APPR_Interface_NoteNoAuctionableItems') )--Note: No auctionable items
			end
		end

		frame.ShowOwnAuctionDetails(itemLink)	-- Adds lines to frame.manifest

		frame.salebox.warn:SetText("")
		local warnvendor
		if GetSellValue then
			local sellValue = GetSellValue(frame.salebox.link)
			if (sellValue and sellValue > 0) then
				sellValue = sellValue + 1 -- the curBuy/curBid have been rounded up earlier, and they MAY be based on vendor values!
				sellValue = math.ceil(sellValue / (1 - (AucAdvanced.cutRate or 0.05)))
				if curBuy > 0 and curBuy <= sellValue then
			    	warnvendor = "buyout"
				elseif curBid > 0 and curBid <= sellValue then
                	warnvendor = "bid"
               	end
			end
		end

		local canAuction = true
		if curModel == "fixed" and curBid <= 0 then
			frame.salebox.warn:SetText(_TRANS('APPR_Interface_BidPriceMustGreater') )--Bid price must be > 0
			canAuction = false
		elseif (curBuy > 0 and curBid > curBuy) then
			frame.salebox.warn:SetText(_TRANS('APPR_Interface_BuyPriceMustGreater') )--Buy price must be > bid
			canAuction = false
		elseif warnvendor == "buyout" then
			frame.salebox.warn:SetText("|cffff8010".._TRANS('APPR_Interface_NoteBuyoutLessVendor'))--Note: Buyout <= Vendor
			if AucAdvanced.Settings.GetSetting("util.appraiser.bid.vendor") then
				canAuction = false
			end
		elseif warnvendor == "bid" then
			frame.salebox.warn:SetText("|cffeec900".._TRANS('APPR_Interface_NoteMinBidLessVendor'))--Note: Min Bid <= Vendor
			if AucAdvanced.Settings.GetSetting("util.appraiser.bid.vendor") then
				canAuction = false
			end
		else
			frame.salebox.warn:SetText("")
		end

		if totalBid < 1 then
			canAuction = false
		end

		if not frame.selectedPostable then
			canAuction = false
		end

		if canAuction then
			frame.go:Enable()
		else
			frame.go:Disable()
		end
	end

	function frame.ChangeUI()
		if get("util.appraiser.classic") then
			--Show per stack
			frame.switchToStack:SetText("Bid per Stack")
			frame.switchToStack2:SetText("Buy per Stack")

			frame.salebox.bid:Hide()
			frame.salebox.buy:Hide()
			frame.salebox.bid.stack:Show()
			frame.salebox.buy.stack:Show()
			frame.salebox:SetBackdropColor(0.1, 0.5, 0.9, 1)
		else
			--Show per each
			frame.switchToStack:SetText(_TRANS('APPR_Interface_BidPerItem') ) --Bid per item:
			frame.switchToStack2:SetText(_TRANS('APPR_Interface_BuyPerItem') )--Buy per item:

			frame.salebox.bid:Show()
			frame.salebox.buy:Show()
			frame.salebox.bid.stack:Hide()
			frame.salebox.buy.stack:Hide()
			frame.salebox:SetBackdropColor(0, 0, 0, 0.8)
		end

		frame.UpdateDisplay()
	end
	--syncs the stack and single item input boxes,
	--only the visible frame fires events
	function frame.SyncMoneyFrameSingleBid()
		local stack = frame.salebox.stack:GetValue()
		local bidStack = MoneyInputFrame_GetCopper(frame.salebox.bid.stack)
		MoneyInputFrame_SetCopper(frame.salebox.bid, bidStack/stack)
	end
	function frame.SyncMoneyFrameSingleBuy()
		local stack = frame.salebox.stack:GetValue()
		local buyStack = MoneyInputFrame_GetCopper(frame.salebox.buy.stack)
		MoneyInputFrame_SetCopper(frame.salebox.buy, buyStack/stack)
	end
	--Syncs single frame value changes to stack frame
	function frame.SyncMoneyFrameStackBid()
		local stack = frame.salebox.stack:GetValue()
		local bid = MoneyInputFrame_GetCopper(frame.salebox.bid)
		MoneyInputFrame_SetCopper(frame.salebox.bid.stack, bid*stack)
	end
	function frame.SyncMoneyFrameStackBuy()
		local stack = frame.salebox.stack:GetValue()
		local buy = MoneyInputFrame_GetCopper(frame.salebox.buy)
		MoneyInputFrame_SetCopper(frame.salebox.buy.stack, buy*stack)
	end

	function frame.GetItemByLink(link)
		local sig = SigFromLink(link)
		assert(sig, "Item must be a valid link")
		for i = 1, #(frame.list) do
			if frame.list[i] then
				if frame.list[i][1] == sig then
					local obj = {}
					obj.id = i
					local pos = math.floor(frame.scroller:GetValue())
					obj.id = obj.id - pos
					frame.SelectItem(obj)
					frame.scroller:SetValue(i-(NUM_ITEMS*(i/#frame.list)))
					return
				end
			end
		end
--		frame.DirectSelect(link)
        frame.SelectItem(nil,nil,link)
	end

	function frame.IconClicked()
		local objtype, _, itemlink = GetCursorInfo()
		ClearCursor()
		if objtype == "item" then
			frame.GetItemByLink(itemlink)
		else
			if not get("util.appraiser.classic") then
				frame.salebox.ignore:SetChecked(not frame.salebox.ignore:GetChecked())
				frame.updated = true
			end
		end
	end

	function frame.ToggleDisabled()
		if not frame.salebox.sig then return end
		local curDisable = get('util.appraiser.item.'..frame.salebox.sig..".ignore") or false
		set('util.appraiser.item.'..frame.salebox.sig..".ignore", not curDisable)
		frame.GenerateList()
	end

	function frame.RefreshView(background, link)
		local itemName, filterData
		if not link then
			link = frame.salebox.link
			if not link then
				-- The user attempted a single-item refresh without selecting anything, just re-enable the button and return.
			    aucPrint(_TRANS('APPR_Interface_NoItemsSelected') )--No items were selected for refresh.
				frame.refresh:Enable()
				return
			end
		end

		local lType, itemID = strsplit(":", link)
		itemID = tonumber(itemID)
		lType = lType:sub(-4)
		if not itemID then
			-- do nothing - itemName is not set so we will display an error message and reset at the end of the function
		elseif lType == "item" then
			local name, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(link)
			if name then
				itemName = name
				filterData = AucAdvanced.Scan.QueryFilterFromID(classID, subClassID)
			end
		elseif lType == "epet" then -- last 4 letters of "battlepet"
			-- all caged pets should have the default pet name (custom names are removed when caging)
			local petName, _, petType = C_PetJournal.GetPetInfoBySpeciesID(itemID)
			if petName then
				itemName = petName
				filterData = AucAdvanced.Scan.QueryFilterFromID(LE_ITEM_CLASS_BATTLEPET, Const.AC_PetType2SubClassID[petType])
			end
		-- else do nothing - itemName will not be set
		end

		if not itemName then
			-- Reuse same error message as above
			aucPrint(_TRANS('APPR_Interface_NoItemsSelected') )--No items were selected for refresh.
			frame.refresh:Enable()
			return
		else
			local exact = #itemName < 30 -- use exact match, except for very long names

			aucPrint(_TRANS('APPR_Interface_RefreshingView') :format(itemName))--Refreshing view of {{%s}}
			if background == true then
				-- Usage: StartPushedScan(name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData, options)
				AucAdvanced.Scan.StartPushedScan(itemName, nil, nil, nil, nil, exact, filterData)
			else
				AucAdvanced.Scan.PushScan()
				--Usage: StartScan(name, minUseLevel, maxUseLevel, isUsable, qualityIndex, GetAll, exactMatch, filterData, options)
				AucAdvanced.Scan.StartScan(itemName, nil, nil, nil, nil, nil, exact, filterData)
			end
		end
	end

	function frame.RefreshAll()
		local bg = false
		for i = 1, #(frame.list) do
			local item = frame.list[i]
			if item then
				local link = item[7]
				frame.RefreshView(bg, link)
				bg = true
			end
		end
	end

	-- We use this to make sure the correct number of parameters are passed to RefreshView; otherwise, we can end up with e.g. link="LeftButton".
	function frame.SmartRefresh()
		frame.refresh:Disable()
		if (not IsAltKeyDown()) then
			frame.RefreshView()
		else
			frame.RefreshAll()
		end
	end

	function frame.PostAuctions(obj)

		local postType = obj.postType
		if postType == "single" then
			frame.PostBySig(frame.salebox.sig, nil, true) -- singleclick flag for hardware event
		elseif postType == "batch" then
			if not IsModifierKeyDown() and GetMouseButtonClicked() ~= "RightButton" then
				message(_TRANS('APPR_Interface_BatchButtonCombination') )--This button requires you to press a combination of keys when clicked.\nSee help printed in the chat frame for further details.
				aucPrint(_TRANS('APPR_Help_BatchPostHelp1') )--The batch post mechanism will allow you to perform automated actions on all the items in your inventory marked for batch posting.
				aucPrint(_TRANS('APPR_Help_BatchPostHelp2') )--You must hold down one of the following keys when you click the button:
				aucPrint("  ".._TRANS('APPR_Help_BatchPostHelp3') )--- Alt = Auto-refresh all batch postable items.
				aucPrint("  ".._TRANS('APPR_Help_BatchPostHelp4') )--- Shift = List all auctions that would be posted without actually posting them.
				aucPrint("  ".._TRANS('APPR_Help_BatchPostHelp5') )--- RightClick = Auto-post all batch postable items.
				aucPrint("  ".._TRANS('APPR_Help_BatchPostHelp6') )--- Alt+RightClick on an item to toggle batch post on/off
				return
			end

			local a = IsAltKeyDown()
			local s = IsShiftKeyDown()
			local c = IsControlKeyDown()

			local mode

			-- Keeping old ability for Ctrl+Alt+Shift for users used to using this modifer setup.
			if (a and c and s) or (not (a or c or s) and GetMouseButtonClicked() == "RightButton") then mode = "autopost" end
			if a and not (c or s) then
				if GetMouseButtonClicked() == "RightButton" then
					-- toggle batch posting for current selected item
					local sig = frame.selected
					if sig then
						local curBulk = get('util.appraiser.item.'..sig..".bulk")
						set("util.appraiser.item."..sig..".bulk", not curBulk)
						frame.GenerateList() -- refresh the list and frame after toggling the bulk option.
					end
					return
				else
					mode = "refresh"
				end
			end
			if not (a or c) and s then mode = "list" end

			if not mode then
				message(_TRANS('APPR_Help_BatchUnknownKeyCombo') )--Unknown key combination pressed while clicking batch post button.
				return
			end

			if mode == "list" then
				aucPrint(_TRANS('APPR_Help_BatchFollowingWouldPosted'))--The following items would have be auto-posted:
			end

			local bg = false
			local obj = {}
			for i = 1, #(frame.list) do
				local item = frame.list[i]
				if item then
					local sig = item[1]
					if get('util.appraiser.item.'..sig..".bulk") then
						if mode == "autopost" then
							-- Auto post these items
							frame.PostBySig(sig)
						elseif mode == "list" then
							-- List these items
							frame.PostBySig(sig, true)
						elseif mode == "refresh" then
							-- Refresh these items
							local link = item[7]
							frame.RefreshView(bg, link)
							bg = true
						end
					end
				end
			end
		end
	end

	local function helperPostRequest(sig, stack, bidVal, buyVal, duration, numstacks, dryRun, singleclick)
		-- called from multiple places in PostBySig
		-- lifted out as a separate function, as it was getting increasingly unwieldy
		if dryRun then
			aucPrint(" - ".._TRANS('APPR_Help_PretendingPostStacks'):format(numstacks, stack, AucAdvanced.Coins(bidVal, true), AucAdvanced.Coins(buyVal, true)))--Pretending to post {{%d}} stacks of {{%d}} at {{%s}} min and {{%s}} buyout per stack
		elseif singleclick then
			local success, reason = AucAdvanced.Post.PostAuctionClick(sig, stack, bidVal, buyVal, duration, numstacks)
			if success then
				if stack > 1 then
					aucPrint(" - ".._TRANS('APPR_Help_PostingLots'):format(numstacks, stack))--Posting {{%d}} lots of {{%d}}
				else
					aucPrint(" - ".._TRANS('APPR_Help_PostingItems'):format(numstacks))--Posting {{%d}} items
				end
			else
				reason = AucAdvanced.Post.GetErrorText(reason)
				aucPrint(" * ".._TRANS('APPR_Help_CouldNotPost')..": "..reason)--Could not post item
			end
			return success, reason
		else
			local success, reason = AucAdvanced.Post.PostAuction(sig, stack, bidVal, buyVal, duration, numstacks)
			if success then
				if stack > 1 then
					aucPrint(" - ".._TRANS('APPR_Help_QueueingLots'):format(numstacks, stack))--Queueing {{%d}} lots of {{%d}}
				else
					aucPrint(" - ".._TRANS('APPR_Help_QueueingItems'):format(numstacks))--Queueing {{%d}} items
				end
			else
				reason = AucAdvanced.Post.GetErrorText(reason)
				aucPrint(" * ".._TRANS('APPR_Help_CouldNotQueue')..": "..reason)--Could not queue item
			end
			return success, reason
		end
	end

    local function isValidDuration(duration)
        if AucAdvanced.Classic then
            return (duration == 120 or duration == 480 or duration == 1440)
        else
            return (duration == 720 or duration == 1440 or duration == 2880)
        end
    end

	function frame.PostBySig(sig, dryRun, singleclick)
		local link, itemName = AucAdvanced.Modules.Util.Appraiser.GetLinkFromSig(sig)
		local total, _, unpostable = AucAdvanced.Post.CountAvailableItems(sig)
		if not (link and total) then
			UIErrorsFrame:AddMessage(_TRANS('APPR_Interface_UnablePostAuctions') )--Unable to post auctions at this time
			aucPrint(_TRANS('APPR_Help_CannotPostAuctions'), "Invalid item sig")--Cannot post auctions:
			return
		end
		local itemBuy, itemBid, _, _, _, _, stack, number, duration = AucAdvanced.Modules.Util.Appraiser.GetPrice(link, nil, true)
		local numberOnly = get('util.appraiser.item.'..sig..".numberonly")


		-- Just a quick bit of sanity checking first

		if not (stack and stack >= 1) then
			aucPrint(_TRANS('APPR_Help_SkippingNoStackSize'):format(link) )--Skipping %s: no stack size set
			return
		elseif (not number) or number < -2 or number == 0 then
			aucPrint(_TRANS('APPR_Help_SkippingInvalidNumberStacks'):format(link) )--Skipping %s: invalid number of stacks/items set
			return
		elseif (not itemBid) or itemBid <= 0 then
			aucPrint(_TRANS('APPR_Help_SkippingNoBidValue'):format(link) )--Skipping %s: no bid value set
			return
		elseif not (itemBuy and (itemBuy == 0 or itemBuy >= itemBid)) then
			aucPrint(_TRANS('APPR_Help_SkippingInvalidBuyoutValue'):format(link) )--Skipping %s: invalid buyout value
			return
		elseif not (duration and isValidDuration(duration) ) then
			aucPrint(_TRANS('APPR_Help_SkippingInvalidDuration'):format(link).." "..tostring(duration) )--Skipping %s: invalid duration:
			return
		elseif total == 0 then
			if unpostable > 0 then
				aucPrint(_TRANS('APPR_Help_SkippingNoAuctionableItem'):format(link) )--Skipping %s: no auctionable item in bags.  May need to repair item
				return
			else
				aucPrint(_TRANS('APPR_Help_SkippingNotEnoughItems'):format(link) )--Skipping %s: You do not have enough items to do that
				return
			end
		elseif (number > 0 and number * stack > total) and not numberOnly then
			aucPrint(_TRANS('APPR_Help_SkippingNotEnoughItems'):format(link) )--Skipping %s: You do not have enough items to do that
			return
		elseif (number ~= -1) and (stack > total) then
			aucPrint(_TRANS('APPR_Help_SkippingStackLargerAvailable'):format(link) )--Skipping %s: Stack size larger than available
			return
		end
        if numberOnly and number>0 then
            -- get current number of posted auctions
            local counts = AucAdvanced.Modules.Util.Appraiser.ownCounts[itemName]
            local results = AucAdvanced.Modules.Util.Appraiser.ownResults[itemName]
            local currentStackCount = 0
		    if counts and #counts>0 then
		    	for _,count in ipairs(counts) do
				    local res = results[count]
                    currentStackCount = currentStackCount + res.stackCount
                end
            end
            -- reduce number to post by existing amount
            number = number - currentStackCount
            if number < 1 then
                aucPrint(_TRANS('APPR_Help_StacksAreadyPosted'):format(currentStackCount, link))--%d stacks of %s already posted.
                return
            end
            if number*stack > total then
                aucPrint(_TRANS('APPR_Help_NeedOnlyHavePosting'):format(number*stack, link, total, math.floor(total/stack)*stack))--Need %d of %s only have %d, posting %d
                number = math.floor(total/stack)
            end
        end

		aucPrint(_TRANS('APPR_Help_PostingBatch'):format(link))--Posting batch of: %s

		aucPrint(" - ".._TRANS('APPR_Help_Duration'):format(AucAdvanced.Post.AuctionDurationHours(duration)))--Duration: {{%d hours}}

		local bidVal, buyVal
		local totalBid, totalBuy, totalNum = 0,0,0

		if (stack > 1) then
			local fullStacks = math.floor(total / stack)
			local fullPop = fullStacks * stack
			local remain = total - fullPop

			if (number < 0) then
				if (fullStacks > 0) then
					buyVal, bidVal = lib.RoundBuyBid(itemBuy * stack, itemBid * stack)

					if helperPostRequest(sig, stack, bidVal, buyVal, duration, fullStacks, dryRun, singleclick) then
						totalBid = totalBid + (bidVal * fullStacks)
						totalBuy = totalBuy + (buyVal * fullStacks)
						totalNum = totalNum + (stack * fullStacks)
					end
				end
				if (number == -1 and remain > 0) then
					buyVal, bidVal = lib.RoundBuyBid(itemBuy * remain, itemBid * remain)

					if helperPostRequest(sig, remain, bidVal, buyVal, duration, 1, dryRun, singleclick) then
						totalBid = totalBid + bidVal
						totalBuy = totalBuy + buyVal
						totalNum = totalNum + remain
					end
				end
			else
				buyVal, bidVal = lib.RoundBuyBid(itemBuy * stack, itemBid * stack)

				if helperPostRequest(sig, stack, bidVal, buyVal, duration, number, dryRun, singleclick) then
					totalBid = totalBid + (bidVal * number)
					totalBuy = totalBuy + (buyVal * number)
					totalNum = totalNum + (stack * number)
				end
			end
		else
			if number < 0 then number = total end
			buyVal, bidVal = lib.RoundBuyBid(itemBuy, itemBid)

			if helperPostRequest(sig, 1, bidVal, buyVal, duration, number, dryRun, singleclick) then
				totalBid = totalBid + (bidVal * number)
				totalBuy = totalBuy + (buyVal * number)
				totalNum = totalNum + number
			end
		end

		aucPrint("-----------------------------------")
		if dryRun then
			aucPrint(_TRANS('APPR_Help_PretendedItems'):format(totalNum))--Pretended {{%d}} items
		elseif singleclick then
			aucPrint(_TRANS('APPR_Help_PostedItems'):format(totalNum))--Posted {{%d}} items
		else
			aucPrint(_TRANS('APPR_Help_QueuedUpItems'):format(totalNum))--Queued up {{%d}} items
		end
		aucPrint(_TRANS('APPR_Help_TotalMinbidValue'):format(AucAdvanced.Coins(totalBid, true)))--Total minbid value: %s'
		aucPrint(_TRANS('APPR_Help_TotalBuyoutValue'):format(AucAdvanced.Coins(totalBuy, true)))--Total buyout value: %s
		aucPrint("-----------------------------------")
	end

	local function ShowDistInfoOnButton(distinfo, button, item) -- helper function for SetScroll and DelayedDistributionUpdate
		local info = ""
		if distinfo then
			local exact, suffix, base, colordist = unpack(distinfo)
			if colordist then
				info = GetColored(true, colordist, nil, true) -- use shortened format
			end
			if not info or info == "" then
				if suffix + base > 0 then
					-- we need to know what the itemtype is, to determine what suffix and base represent
					-- inspect the first byte of the sig
					local firstbyte = strbyte(item[1],1)
					if firstbyte == 80 then -- 'P' indicates battlepet
						-- suffix represents same breed and quality but different levels
						-- base represents different qualities - only possible for some pets
						if base > 0 then
							info = exact.." ("..suffix.." lvl + "..base.." qual)"
						else
							info = exact.." ("..suffix.." lvl)"
						end
					elseif firstbyte >= 48 and firstbyte <= 57 then -- numeric indicates normal item
						-- base represents same base item with different suffixes
						-- suffix represents same base item and suffix but different factors - this should never happen!
						info = exact.." ("..base.." base)"
					else
						-- unknown itemtype
						info = exact.." ???"
					end
				else
					info = tostring(exact)
				end
			end
		end
		button.info:SetText(info)
	end

	function private.DelayedDistributionUpdate()
		private.needDistributionUpdate = false
		local allow = true -- only allow one GetDistribution call per update

		for button, item in pairs(frame.distributionqueue) do
			local sig = item[1]
			local distinfo = frame.distributioncache[sig]
			if distinfo ~= nil then
				frame.distributionqueue[button] = nil
				ShowDistInfoOnButton(distinfo, button, item)
			elseif allow then
				local exact, suffix, base, colorDist = GetDistribution(item[7])
				if exact then
					distinfo = {exact, suffix, base, nil}
					frame.distributioncache[sig] = distinfo
					if exact > 0 then
						-- colorDist.exact can contain all 0 even if exact > 0 (e.g. if PriceLevel not installed)
						local hasDist = false
						for k,v in pairs(colorDist.exact) do
							if v > 0 then
								hasDist = true
								break
							end
						end
						if hasDist then
							-- only create & copy colordisttable if there were non-zero values
							local colordisttable = {}
							for k,v in pairs(colorDist.exact) do
								colordisttable[k] = v
							end
							distinfo[4] = colordisttable
						end
					end
				else -- no distribution info returned for this sig
					frame.distributioncache[sig] = false
				end
				frame.distributionqueue[button] = nil
				allow = false
				ShowDistInfoOnButton(distinfo, button, item)
			else -- distinfo is nil, cannot call GetDistribution again this cycle, schedule another update
				private.needDistributionUpdate = true
			end
		end
	end

	function frame.SetScroll(...)
		wipe(frame.distributionqueue)
		local pos = floor(frame.scroller:GetValue())
		for i = 1, NUM_ITEMS do
			local item = frame.list[pos+i]
			local button = frame.items[i]
			if item then
				local sig = item[1]
				local curIgnore = item.ignore
				local curAuction = item.auction
				local curBulk = get('util.appraiser.item.'..sig..".bulk") or false

				button.icon:SetTexture(item[3])
				button.icon:SetDrawLayer("ARTWORK");
				button.icon:SetDesaturated(curIgnore)

				local _,_,_, hex = GetItemQualityColor(item[4])
				hex = "|c"..hex
				local stackX = "x "
				if curAuction then
					stackX = ""
				end

				if curIgnore then
					hex = "|cff444444"
					stackX = hex..stackX
				end

				if curBulk then
				    button.batchTex:Show();
				else
				    button.batchTex:Hide();
				end

				button.name:SetText(hex..item[2].."|r")

				button.size:SetText(stackX..item[6])

				if curAuction then
					button.size:SetAlpha(0.7)
				else
					button.size:SetAlpha(1)
				end

				local distinfo
				if GetDistribution and not curIgnore then
					distinfo = frame.distributioncache[sig]
					if not distinfo then
						frame.distributionqueue[button] = item
						private.needDistributionUpdate = true
						if frame.olddistributioncache then
							-- see if there's an old cached entry for this sig that we can use temporarily
							-- this will be overwritten as soon as we can fetch updated distribution info
							-- doing this will help prevent the text from flickering after every scan
							distinfo = frame.olddistributioncache[sig]
						end
					end
				end
				ShowDistInfoOnButton(distinfo, button, item)

				local background = button.bg
				local alpha = 0.2

				if curAuction then
					background:SetVertexColor(0.9,0.3,0) -- very dark red
				else
					background:SetVertexColor(1,1,1)
				end

				if (sig == frame.selected) then
					alpha = 0.6
				elseif curIgnore then
					alpha = 0.1
    			end

				background:SetAlpha(alpha)
				background:SetDesaturated(curIgnore)

				button:Show()
			else
				button:Hide()
			end
		end
		frame.olddistributioncache = nil
	end

	function frame.SetButtonTooltip(self, text)
		if self and text and get("util.appraiser.buttontips") then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:SetText(text)
		end
	end

	frame.DoTooltip = function(self)
		local link, count, point, relFrame, relPoint, xoff, yoff
		if not self.id then self = self:GetParent() end
		if self.id then --we're mousing over the itemlist
			local id = self.id
			local pos = math.floor(frame.scroller:GetValue())
			local item = frame.list[pos + id]
			if item then
				link = item[7]
				count = item[6]
				point, relFrame, relPoint, xoff, yoff = "TOPLEFT", frame.itembox, "TOPRIGHT", 10, 0
			end
		else --we're mousing over the itemslot
			if frame.salebox.sig then
				link = frame.salebox.link
				count = frame.salebox.count
				point, relFrame, relPoint, xoff, yoff = "TOPRIGHT", frame.salebox.icon, "TOPLEFT", -10, 0
			end
		end
		if link then
			if strmatch(link, "|Hitem:") then
				GameTooltip:SetOwner(relFrame, "ANCHOR_NONE")
				AucAdvanced.ShowItemLink(GameTooltip, link, count)
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint(point, relFrame, relPoint, xoff, yoff)
			elseif strmatch(link, "|Hbattlepet") then
				AucAdvanced.ShowPetLink(BattlePetTooltip, link, count)
				BattlePetTooltip:ClearAllPoints()
				BattlePetTooltip:SetPoint(point, relFrame, relPoint, xoff, yoff)
			end
		end
	end
	frame.UndoTooltip = function ()
		GameTooltip:Hide()
		if BattlePetTooltip then
			BattlePetTooltip:Hide()
		end
	end

	frame:SetPoint("TOPLEFT", "AuctionFrame", "TOPLEFT", 10,-70)
	frame:SetPoint("BOTTOMRIGHT", "AuctionFrame", "BOTTOMRIGHT", 0,0)
	frame:SetScript("OnUpdate", frame.OnUpdate)

	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", frame, "TOPLEFT", 80, -16)
	title:SetText(_TRANS('APPR_Interface_AppraiserAuctionPostingInterface') )--Appraiser: Auction posting interface

	frame.toggleManifest = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.toggleManifest:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -26, -13)
	frame.toggleManifest:SetScript("OnClick", function()
		if frame.manifest:IsShown() then
			frame.toggleManifest:SetText("Open Sidebar")
			frame.manifest:Hide()
		else
			frame.toggleManifest:SetText("Close Sidebar")
			frame.manifest:Show()
		end
	end)
	frame.toggleManifest:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_SidebarINF_Tooltip_AdditionalInfo') ) end)--Open/Close sidebar with additional price info
	frame.toggleManifest:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.toggleManifest:SetWidth(120)
	frame.toggleManifest:SetText("Close Sidebar")
	frame.toggleManifest:Disable()
	frame.toggleManifest:Show()

	frame.config = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.config:SetPoint("TOPRIGHT", frame.toggleManifest, "TOPLEFT", 3, 0)
	frame.config:SetText(_TRANS('APPR_Interface_Configure') )--Configure
	frame.config:SetScript("OnClick", function()
		AucAdvanced.Settings.Show()
		private.gui:ActivateTab(private.guiId)
	end)

	frame.itembox = CreateFrame("Frame", nil, frame)
	frame.itembox:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.itembox:SetBackdropColor(0, 0, 0, 0.8)
	frame.itembox:SetPoint("TOPLEFT", frame, "TOPLEFT", 13, -71)
	frame.itembox:SetWidth(240)
	frame.itembox:SetHeight(340)

	-- "Show Auctions" checkbox
	frame.itembox.showAuctions = CreateFrame("CheckButton", "Auc_Util_Appraiser_ShowAuctions", frame.itembox, "OptionsCheckButtonTemplate")
	frame.itembox.showAuctions:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_IncludeAuctionsListing') ) end)--Include own auctions in the item listing
	frame.itembox.showAuctions:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.itembox.showAuctions:SetWidth(24)
	frame.itembox.showAuctions:SetHeight(24)
	Auc_Util_Appraiser_ShowAuctionsText:SetText(_TRANS('APPR_Interface_Auctions') )--Auctions
	frame.itembox.showAuctions:SetPoint("BOTTOMRIGHT", frame.itembox, "TOPRIGHT", 0-Auc_Util_Appraiser_ShowAuctionsText:GetWidth(), 0)
	frame.itembox.showAuctions:SetHitRectInsets(0, 0-Auc_Util_Appraiser_ShowAuctionsText:GetWidth(), 0, 0)
	frame.itembox.showAuctions:SetScript("OnClick", function(self)
		frame.showAuctions = self:GetChecked()
		frame.GenerateList(true)
		PlaySound(frame.showAuctions and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end)

	-- "Show Hidden" checkbox
	frame.itembox.showHidden = CreateFrame("CheckButton", "Auc_Util_Appraiser_ShowHidden", frame.itembox, "OptionsCheckButtonTemplate")
	frame.itembox.showHidden:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_IncludeItemsHiddenListing') ) end)--Include items tagged as 'hidden' in the item listing
	frame.itembox.showHidden:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.itembox.showHidden:SetWidth(24)
	frame.itembox.showHidden:SetHeight(24)
	Auc_Util_Appraiser_ShowHiddenText:SetText(_TRANS('APPR_Interface_Hidden') )--Hidden
	frame.itembox.showHidden:SetPoint("BOTTOMRIGHT", frame.itembox.showAuctions, "BOTTOMLEFT", 0-Auc_Util_Appraiser_ShowHiddenText:GetWidth(), 0)
	frame.itembox.showHidden:SetHitRectInsets(0, 0-Auc_Util_Appraiser_ShowHiddenText:GetWidth(), 0, 0)
	frame.itembox.showHidden:SetScript("OnClick", function(self)
		frame.showHidden = self:GetChecked()
		frame.GenerateList(true)
		PlaySound(frame.showHidden and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end)

	-- "Show:" label
	frame.itembox.showText = CreateFrame("Frame", nil, frame.itembox)
	frame.itembox.showText:SetPoint("BOTTOMRIGHT", frame.itembox.showHidden, "BOTTOMLEFT", 0,0)
	frame.itembox.showText.text = frame.itembox.showText:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.itembox.showText.text:SetAllPoints(frame.itembox.showText)
	frame.itembox.showText.text:SetText(_TRANS('APPR_Interface_Show').." " )--Show:
	frame.itembox.showText:SetWidth(frame.itembox.showText.text:GetWidth())
	frame.itembox.showText:SetHeight(frame.itembox.showAuctions:GetHeight())

	frame.items = {}
	local function itemButtonClick(self, button)
		-- when adding new mod-key combinations, rearrange lines in the the nested 'if' structure as appropriate
		local item = frame.list[floor(frame.scroller:GetValue()) + self.id]
		local mouseButton = GetMouseButtonClicked()

		if mouseButton == "LeftButton" then
			if IsShiftKeyDown() and not IsControlKeyDown() then
				if IsAltKeyDown() then -- shift/alt
					if item then
						frame.PostBySig(item[1])
						return
					end
				else -- shift only
					if item then
						ChatEdit_InsertLink(item[7])
						return
					end
				end
			end
		elseif mouseButton == "RightButton" then
			if IsAltKeyDown() and not IsShiftKeyDown() and not IsControlKeyDown() then -- Alt+RightClick
				if item then
					local curBulk = get('util.appraiser.item.'..item[1]..".bulk")
					set("util.appraiser.item."..item[1]..".bulk", not curBulk)
					frame.GenerateList() -- refresh the list and frame after toggling the bulk option.
					return
				else
					debugPrint("item fail")
				end
			end
		end

		frame.SelectItem(self, button)
	end
	local function itemIconClick(self, button)
		return itemButtonClick(self:GetParent(), button) -- go up one level, then tailcall
	end
	for i=1, NUM_ITEMS do
		local item = CreateFrame("Button", nil, frame.itembox)
		frame.items[i] = item

		item:SetScript("OnClick", itemButtonClick)
		if (i == 1) then
			item:SetPoint("TOPLEFT", frame.itembox, "TOPLEFT", 5,-8 )
		else
			item:SetPoint("TOPLEFT", frame.items[i-1], "BOTTOMLEFT", 0, -1)
		end
		item:SetPoint("RIGHT", frame.itembox, "RIGHT", -23,0)
		item:SetHeight(26)

		item.id = i

		item:RegisterForClicks("LeftButtonUp", "RightButtonUp")

		item.iconbutton = CreateFrame("Button", nil, item)
		item.iconbutton:SetHeight(26)
		item.iconbutton:SetWidth(26)
		item.iconbutton:SetPoint("LEFT", item, "LEFT", 3,0)
		item.iconbutton:SetScript("OnClick", itemIconClick)
		item.iconbutton:SetScript("OnEnter", function() frame.DoTooltip(item) end)
		item.iconbutton:SetScript("OnLeave", frame.UndoTooltip)
		item.iconbutton:RegisterForClicks("LeftButtonUp", "RightButtonUp")

		item.icon = item.iconbutton:CreateTexture(nil, "OVERLAY")
		item.icon:SetPoint("TOPLEFT", item.iconbutton, "TOPLEFT", 0,0)
		item.icon:SetPoint("BOTTOMRIGHT", item.iconbutton, "BOTTOMRIGHT", 0,0)
		item.icon:SetTexture("Interface\\InventoryItems\\WoWUnknownItem01")


    	-- This section is for the Batch Post texture that shows up when an item has the batch post option set
		item.batchTex = item.iconbutton:CreateTexture()

		if embedded then
			item.batchTex:SetTexture("Interface\\AddOns\\Auc-Advanced\\Modules\\Auc-Util-Appraiser\\Images\\BatchPostTriangle")
		else
			item.batchTex:SetTexture("Interface\\AddOns\\Auc-Util-Appraiser\\Images\\BatchPostTriangle")
		end

		item.batchTex:SetPoint("TOP", item.icon, "TOP", 0,-15)
		item.batchTex:SetPoint("LEFT", item.icon, "LEFT", 10,0)
		item.batchTex:SetPoint("RIGHT", item.icon, "RIGHT", -3,0)
		item.batchTex:SetPoint("BOTTOM", item.icon, "BOTTOM", 0,2)
		item.batchTex:SetDrawLayer("OVERLAY")
		item.batchTex:Hide()

		item.name = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		item.name:SetJustifyH("LEFT")
		item.name:SetJustifyV("TOP")
		item.name:SetWordWrap(false)
		item.name:SetPoint("TOPLEFT", item.icon, "TOPRIGHT", 3,-1)
		item.name:SetPoint("RIGHT", item, "RIGHT", -5,0)
		item.name:SetText(_TRANS('APPR_Interface_None') )--[None]

		item.size = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		item.size:SetJustifyH("RIGHT")
		item.size:SetJustifyV("BOTTOM")
		item.size:SetPoint("BOTTOMLEFT", item.icon, "BOTTOMRIGHT", 3,2)
		item.size:SetPoint("RIGHT", item, "RIGHT", -10,0)
		item.size:SetText(_TRANS('APPR_Interface_25x') )--25x

		item.info = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		item.info:SetJustifyH("LEFT")
		item.info:SetJustifyV("BOTTOM")
		item.info:SetPoint("BOTTOMLEFT", item.icon, "BOTTOMRIGHT", 3,2)
		item.info:SetPoint("RIGHT", item, "RIGHT", -10,0)
		item.info:SetText("" )

		item.bg = item:CreateTexture(nil, "ARTWORK")
		item.bg:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
		item.bg:SetPoint("TOPLEFT", item, "TOPLEFT", 0,0)
		item.bg:SetPoint("BOTTOMRIGHT", item, "BOTTOMRIGHT", 0,0)
		item.bg:SetAlpha(0.2)
		item.bg:SetBlendMode('ADD')

		item:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
	end
	local scroller = CreateFrame("Slider", "AucAppraiserItemScroll", frame.itembox)
	scroller:SetPoint("TOPRIGHT", frame.itembox, "TOPRIGHT", -1,-3)
	scroller:SetPoint("BOTTOM", frame.itembox, "BOTTOM", 0,3)
	scroller:SetWidth(20)
	scroller:SetOrientation("VERTICAL")
	scroller:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	scroller:SetMinMaxValues(0, 0)
	scroller:SetValue(0)
	scroller:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	scroller:SetBackdropColor(0, 0, 0, 0.8)
	scroller:SetScript("OnValueChanged", frame.SetScroll)
	scroller:Hide()
	frame.scroller = scroller

	frame.itembox:EnableMouseWheel(true)
	frame.itembox:SetScript("OnMouseWheel", function(obj, dir) scroller:SetValue(scroller:GetValue() - dir) frame.SetScroll() end)

	frame.salebox = CreateFrame("Frame", nil, frame)
	frame.salebox:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.salebox:SetBackdropColor(0, 0, 0, 0.8)
	frame.salebox:SetPoint("TOPLEFT", frame.itembox, "TOPRIGHT", -3,35)
	frame.salebox:SetPoint("RIGHT", frame, "RIGHT", -5,0)
	frame.salebox:SetHeight(170)

	frame.salebox.slot = frame.salebox:CreateTexture(nil, "BORDER")
	frame.salebox.slot:SetPoint("TOPLEFT", frame.salebox, "TOPLEFT", 10, -10)
	frame.salebox.slot:SetWidth(40)
	frame.salebox.slot:SetHeight(40)
	frame.salebox.slot:SetTexCoord(0.15, 0.85, 0.15, 0.85)
	frame.salebox.slot:SetTexture("Interface\\Buttons\\UI-EmptySlot")

	frame.salebox.icon = CreateFrame("Button", nil, frame.salebox)
	frame.salebox.icon:SetPoint("TOPLEFT", frame.salebox.slot, "TOPLEFT", 3, -3)
	frame.salebox.icon:SetWidth(32)
	frame.salebox.icon:SetHeight(32)
	frame.salebox.icon:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square.blp")
	frame.salebox.icon:SetScript("OnClick", frame.IconClicked)
	frame.salebox.icon:SetScript("OnReceiveDrag", frame.IconClicked)
	frame.salebox.icon:SetScript("OnEnter", function(self) frame.DoTooltip(self) end)
	frame.salebox.icon:SetScript("OnLeave", frame.UndoTooltip)

	frame.salebox.name = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	frame.salebox.name:SetPoint("TOPLEFT", frame.salebox.slot, "TOPRIGHT", 5,-2)
	frame.salebox.name:SetPoint("RIGHT", frame.salebox, "RIGHT", -15)
	frame.salebox.name:SetHeight(20)
	frame.salebox.name:SetJustifyH("LEFT")
	frame.salebox.name:SetJustifyV("TOP")
	frame.salebox.name:SetText(_TRANS('APPR_Interface_NoItemSelected') )--No item selected
	frame.salebox.name:SetTextColor(0.5, 0.5, 0.7)

	frame.salebox.info = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.salebox.info:SetPoint("BOTTOMLEFT", frame.salebox.slot, "BOTTOMRIGHT", 5,7)
	frame.salebox.info:SetHeight(20)
	frame.salebox.info:SetJustifyH("LEFT")
	frame.salebox.info:SetJustifyV("BOTTOM")
	frame.salebox.info:SetText("APPR_Interface_SelectItemLeftAuctioning")--Select an item to the left to begin auctioning...
	frame.salebox.info:SetText(_TRANS('APPR_Interface_SelectItemLeftAuctioning') )--Select an item to the left to begin auctioning...
	frame.salebox.info:SetText(_TRANS('APPR_Interface_SelectItemLeftAuctioning') )--Select an item from the list in the left column or drop an item in the square to begin auctioning.
	frame.salebox.info:SetTextColor(0.5, 0.5, 0.7)

	frame.salebox.warn = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.warn:SetPoint("TOPRIGHT", frame.salebox, "TOPRIGHT", -40,-40)
	frame.salebox.warn:SetHeight(12)
	frame.salebox.warn:SetTextColor(1, 0.3, 0.06)
	frame.salebox.warn:SetText("")
	frame.salebox.warn:SetJustifyH("RIGHT")
	frame.salebox.warn:SetJustifyV("BOTTOM")

	-- Options Slider helper functions
	local function SliderValueChanged(self, value)
		-- From WoW 5.4, dragging the slider's thumb results in values that are not correctly aligned to ValueStep [APPR-343]
		-- Values set by calling SetValue will be correctly aligned: use this to correct any erroneous values
		-- When calling SetValue from within OnValueChanged, protect against function re-entry
		-- Retrieve corrected value from GetValue; check it has actually changed before continuing
		if self.isReEntering then return end
		self.isReEntering = true
		self:SetValue(value)
		self.isReEntering = nil
		value = self:GetValue()
		if value == self.prevValue then return end
		self.prevValue = value
		-- (this correction code should be removed when Blizzard fixes the problem)

		frame.updated = true
	end
	local function SliderMouseWheel(self, delta)
		self:SetValue(self:GetValue() - delta)
	end

	frame.salebox.stack = CreateFrame("Slider", "AppraiserSaleboxStack", frame.salebox, "OptionsSliderTemplate")
	frame.salebox.stack:SetPoint("TOPLEFT", frame.salebox.slot, "BOTTOMLEFT", 0, -5)
	frame.salebox.stack:SetHitRectInsets(0,0,0,0)
	frame.salebox.stack:SetMinMaxValues(1,20)
	frame.salebox.stack:SetValueStep(1)
	frame.salebox.stack:SetValue(20)
	frame.salebox.stack:SetWidth(180)
	frame.salebox.stack:SetScript("OnValueChanged", SliderValueChanged)
	frame.salebox.stack:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_SetNumberPerStack') ) end)--Set the number of items per posted stack
	frame.salebox.stack:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.stack.element = "stack"
	frame.salebox.stack:Hide()
	frame.salebox.stack:EnableMouseWheel(1)
	frame.salebox.stack:SetScript("OnMouseWheel", SliderMouseWheel)
	AppraiserSaleboxStackLow:SetText("")
	AppraiserSaleboxStackHigh:SetText("")

	frame.salebox.stack.label = frame.salebox.stack:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.stack.label:SetPoint("TOPLEFT", frame.salebox.stack, "BOTTOMLEFT", 0,0)
	frame.salebox.stack.label:SetJustifyH("LEFT")
	frame.salebox.stack.label:SetJustifyV("CENTER")

	frame.salebox.stackentry = CreateFrame("EditBox", "AppraiserSaleboxStackEntry", frame.salebox, "InputBoxTemplate")
	frame.salebox.stackentry:SetPoint("LEFT", frame.salebox.stack, "RIGHT", 10, 0)
	frame.salebox.stackentry:SetNumeric(true)
	frame.salebox.stackentry:SetNumber(0)
	frame.salebox.stackentry:SetHeight(16)
	frame.salebox.stackentry:SetWidth(32)
	frame.salebox.stackentry:SetAutoFocus(false)
	frame.salebox.stackentry:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_SetNumberPerStack') ) end)--Set the number of items per posted stack
	frame.salebox.stackentry:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.stackentry:SetScript("OnEnterPressed", function()
		frame.salebox.stackentry:ClearFocus()
		frame.updated = true
	end)
	frame.salebox.stackentry:SetScript("OnTabPressed", function()
		frame.salebox.numberentry:SetFocus()
		frame.updated = true
	end)
	frame.salebox.stackentry:SetScript("OnTextChanged", function()
		local text = frame.salebox.stackentry:GetText()
		if text ~= "" then
			frame.updated = true
		end
	end)
	frame.salebox.stackentry:SetScript("OnEscapePressed", function()
		frame.salebox.stackentry:ClearFocus()
	end)
	frame.salebox.stackentry:Hide()

	frame.salebox.number = CreateFrame("Slider", "AppraiserSaleboxNumber", frame.salebox, "OptionsSliderTemplate")
	frame.salebox.number:SetPoint("TOPLEFT", frame.salebox.stack, "BOTTOMLEFT", 0, -15)
	frame.salebox.number:SetHitRectInsets(0,0,0,0)
	frame.salebox.number:SetMinMaxValues(1,1)
	frame.salebox.number:SetValueStep(1)
	frame.salebox.number:SetValue(1)
	frame.salebox.number:SetWidth(180)
	frame.salebox.number:SetScript("OnValueChanged", SliderValueChanged)
	frame.salebox.number:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_SetNumberStacksPosted') ) end)--Set the number of stacks to be posted
	frame.salebox.number:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.number.element = "number"
	frame.salebox.number:Hide()
	AppraiserSaleboxNumberLow:SetText("")
	AppraiserSaleboxNumberHigh:SetText("")
	function frame.salebox.number:GetAdjustedValue()
		local maxStax = self.maxStax or 0
		local value = self:GetValue()
		if value > maxStax then
			local extraPos = value - maxStax
			value = self.extra[extraPos]
		end
		return value or 1
	end
	function frame.salebox.number:SetAdjustedValue(value)
		local maxStax = self.maxStax or 0
		if value < 1 or value > maxStax then
			for i = 1, #self.extra do
				if self.extra[i] == value then
					value = maxStax + i
					break
				end
			end
		end
		self:SetValue(value)
	end
	frame.salebox.number.extra = {}
	function frame.salebox.number:SetAdjustedRange(maxStax, ...)
		maxStax = math.max(1,maxStax)
		local curVal = self:GetAdjustedValue()
		self.maxStax = maxStax
		local n = select("#", ...)
		for i = 1, #self.extra do self.extra[i] = nil end
		for i = 1, select("#", ...) do self.extra[i] = select(i, ...) end
		self:SetMinMaxValues(1, maxStax+n)
		self:SetAdjustedValue(math.min(curVal, maxStax))
	end
	frame.salebox.number:EnableMouseWheel(1)
	frame.salebox.number:SetScript("OnMouseWheel", SliderMouseWheel)

	frame.salebox.number.label = frame.salebox.number:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.number.label:SetPoint("TOPLEFT", frame.salebox.number, "BOTTOMLEFT", 0,-4)
	frame.salebox.number.label:SetJustifyH("LEFT")
	frame.salebox.number.label:SetJustifyV("CENTER")

	frame.salebox.numberentry = CreateFrame("EditBox", "AppraiserSaleboxNumberEntry", frame.salebox, "InputBoxTemplate")
	frame.salebox.numberentry:SetPoint("LEFT", frame.salebox.number, "RIGHT", 10, 0)
	frame.salebox.numberentry:SetNumeric(false)
	frame.salebox.numberentry:SetHeight(16)
	frame.salebox.numberentry:SetWidth(32)
	frame.salebox.numberentry:SetNumber(0)
	frame.salebox.numberentry:SetAutoFocus(false)
	frame.salebox.numberentry:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_SetNumberStacksPosted') ) end)--Set the number of stacks to be posted
	frame.salebox.numberentry:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.numberentry:SetScript("OnEnterPressed", function()
		frame.salebox.numberentry:ClearFocus()
		frame.updated = true
	end)
	frame.salebox.numberentry:SetScript("OnTabPressed", function()
		frame.salebox.stackentry:SetFocus()
		frame.updated = true
	end)
	frame.salebox.numberentry:SetScript("OnTextChanged", function()
		local text = frame.salebox.numberentry:GetText():lower()
		if (text ~= "") then
			frame.updated = true
		end
	end)
	frame.salebox.numberentry:SetScript("OnEscapePressed", function()
		frame.salebox.numberentry:ClearFocus()
	end)
	frame.salebox.numberentry:Hide()

   	frame.salebox.numberonly = CreateFrame("CheckButton", "AppraiserSaleboxNumberOnly", frame.salebox, "OptionsCheckButtonTemplate")
 	frame.salebox.numberonly:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_RestrictActiveAuctions') ) end)--Restrict active auctions to the 'number' value
	frame.salebox.numberonly:SetScript("OnLeave", function() return GameTooltip:Hide() end)
   -- Would rather the distance here matched the length of the "All Stacks" text and was recalculated.
	frame.salebox.numberonly:SetPoint("BOTTOMLEFT", frame.salebox.number.label, "BOTTOMRIGHT", 0, -4)
	frame.salebox.numberonly:SetHeight(20)
	frame.salebox.numberonly:SetWidth(20)
	frame.salebox.numberonly:SetChecked(false)
	frame.salebox.numberonly:SetScript("OnClick", function() frame.updated = true end)
	-- This is not the way to make a tooltip! Leaving there to fix when I know how. - Kinesia
    --	frame.salebox.numberonly:SetTip("Take existing auctions into account and only post what is needed to maintain this total number.")
	frame.salebox.numberonly.label = frame.salebox.numberonly:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.numberonly.label:SetPoint("BOTTOMLEFT", frame.salebox.numberonly, "BOTTOMRIGHT", 0, 4)
	frame.salebox.numberonly.label:SetText(_TRANS('APPR_Interface_Only') )--Only
	frame.salebox.numberonly:Hide()

	frame.salebox.duration = CreateFrame("Slider", "AppraiserSaleboxDuration", frame.salebox, "OptionsSliderTemplate")
	frame.salebox.duration:SetPoint("TOPLEFT", frame.salebox.number, "BOTTOMLEFT", 0,-25)
	frame.salebox.duration:SetHitRectInsets(0,0,0,0)
	frame.salebox.duration:SetMinMaxValues(1,3)
	frame.salebox.duration:SetValueStep(1)
	frame.salebox.duration:SetValue(3)
	frame.salebox.duration:SetWidth(80)
	frame.salebox.duration:SetScript("OnValueChanged", SliderValueChanged)
	frame.salebox.duration:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_SetTimePostItem') ) end)--Set the time to post this item for
	frame.salebox.duration:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.duration.element = "duration"
	frame.salebox.duration:Hide()
	AppraiserSaleboxDurationLow:SetText("")
	AppraiserSaleboxDurationHigh:SetText("")

	frame.salebox.duration:EnableMouseWheel(1)
	frame.salebox.duration:SetScript("OnMouseWheel", SliderMouseWheel)

	frame.salebox.duration.label = frame.salebox.duration:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.duration.label:SetPoint("LEFT", frame.salebox.duration, "RIGHT", 3,2)
	frame.salebox.duration.label:SetJustifyH("LEFT")
	frame.salebox.duration.label:SetJustifyV("CENTER")

	function frame.GetLinkPriceModels()
		return private.GetExtraPriceModels(frame.salebox.link)
	end

	frame.salebox.model = SelectBox:Create("AppraiserSaleboxModel", frame.salebox, 140, function() frame.updated = true end, frame.GetLinkPriceModels, "default")
	frame.salebox.model.button:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_SelectPricingModel') ) end)--Select the pricing model to use
	frame.salebox.model.button:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.model:SetPoint("BOTTOMRIGHT", frame.salebox, "BOTTOMRIGHT", 0, 0)
	frame.salebox.model.element = "model"
	frame.salebox.model:Hide()

	frame.salebox.model.label = frame.salebox.model:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.model.label:SetPoint("RIGHT", frame.salebox.model, "LEFT", 15, 5)
	frame.salebox.model.label:SetText(_TRANS('APPR_Interface_PricingModelUse') )--Pricing model to use:

	frame.salebox.matcher = CreateFrame("CheckButton", "AppraiserSaleboxMatch", frame.salebox, "OptionsCheckButtonTemplate")
 	frame.salebox.matcher:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_EnablesMatchersCalculatingPrices') ) end)--Enables the use of matchers (eg Undercut) when calculating prices
	frame.salebox.matcher:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.matcher:SetPoint("RIGHT", frame.salebox, "RIGHT", -158, -30)
	frame.salebox.matcher:SetHeight(20)
	frame.salebox.matcher:SetWidth(20)
	frame.salebox.matcher:SetChecked(false)
	frame.salebox.matcher:SetScript("OnClick", function() frame.updated = true end)
	frame.salebox.matcher:Hide()

	frame.salebox.matcher.label = frame.salebox.matcher:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.matcher.label:SetPoint("BOTTOMLEFT", frame.salebox.matcher, "BOTTOMRIGHT", 0, 5)
	frame.salebox.matcher.label:SetText(_TRANS('APPR_Interface_EnablePriceMatching') )--Enable price matching

	frame.salebox.ignore = CreateFrame("CheckButton", "AppraiserSaleboxIgnore", frame.salebox, "OptionsCheckButtonTemplate")
	frame.salebox.ignore:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_RemovesItemListing') ) end)--Removes this item from the item listing
	frame.salebox.ignore:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.ignore:SetPoint("TOPRIGHT", frame.salebox, "TOPRIGHT", -160, -3)
	frame.salebox.ignore:SetHeight(20)
	frame.salebox.ignore:SetWidth(20)
	frame.salebox.ignore:SetChecked(false)
	frame.salebox.ignore:SetScript("OnClick", function() frame.updated = true end)
	frame.salebox.ignore:Hide()

	frame.salebox.ignore.label = frame.salebox.ignore:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.ignore.label:SetPoint("BOTTOMLEFT", frame.salebox.ignore, "BOTTOMRIGHT", 0, 6)
	frame.salebox.ignore.label:SetText(_TRANS('APPR_Interface_HideThisItem') )--Hide this item

	frame.salebox.bulk = CreateFrame("CheckButton", "AppraiserSaleboxBulk", frame.salebox, "OptionsCheckButtonTemplate")
	frame.salebox.bulk:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_FlagsBatchPosting') ) end)--Flags this item to be included in Batch Posting
	frame.salebox.bulk:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.salebox.bulk:SetPoint("TOPRIGHT", frame.salebox.ignore, "BOTTOMRIGHT", 0, 3)
	frame.salebox.bulk:SetHeight(20)
	frame.salebox.bulk:SetWidth(20)
	frame.salebox.bulk:SetChecked(false)
	frame.salebox.bulk:SetScript("OnClick", function() frame.updated = true end)
	frame.salebox.bulk:Hide()

	frame.salebox.bulk.label = frame.salebox.bulk:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.bulk.label:SetPoint("BOTTOMLEFT", frame.salebox.bulk, "BOTTOMRIGHT", 0, 6)
	frame.salebox.bulk.label:SetText(_TRANS('APPR_Interface_EnableBatchPosting') )--Enable batch posting

	frame.salebox.bid = CreateFrame("Frame", "AppraiserSaleboxBid", frame.salebox, "MoneyInputFrameTemplate")
	frame.salebox.bid:SetPoint("RIGHT", frame.salebox, "RIGHT", 0, 20)
	frame.salebox.bid:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_EnterBidAmount') ) end)--Enter new bid amount to set a Fixed Price
	frame.salebox.bid:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	MoneyInputFrame_SetOnValueChangedFunc(frame.salebox.bid, function() frame.SyncMoneyFrameStackBid() frame.updated = true end)
	frame.salebox.bid.element = "bid"
	frame.salebox.bid:Hide()
	AppraiserSaleboxBidGold:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 3, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidGold:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBidSilver:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidSilver:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBidCopper:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidCopper:SetBackdropColor(0,0,0, 0)


	frame.salebox.bid.stack = CreateFrame("Frame", "AppraiserSaleboxBidStack", frame.salebox, "MoneyInputFrameTemplate")
	frame.salebox.bid.stack:SetPoint("RIGHT", frame.salebox, "RIGHT", 0, 20)
	frame.salebox.bid.stack:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_EnterBidAmount') ) end)--Enter new bid amount to set a Fixed Price
	frame.salebox.bid.stack:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	MoneyInputFrame_SetOnValueChangedFunc(frame.salebox.bid.stack, function() frame.SyncMoneyFrameSingleBid() frame.updated = true end)
	frame.salebox.bid.stack.element = "bidStack"
	frame.salebox.bid.stack:Hide()
	AppraiserSaleboxBidStackGold:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 3, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidStackGold:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBidStackSilver:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidStackSilver:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBidStackCopper:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidStackCopper:SetBackdropColor(0,0,0, 0)


	frame.salebox.buy = CreateFrame("Frame", "AppraiserSaleboxBuy", frame.salebox, "MoneyInputFrameTemplate")
	frame.salebox.buy:SetPoint("TOPLEFT", frame.salebox.bid, "BOTTOMLEFT", 0,-5)
	frame.salebox.buy:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_EnterBuyoutFixedPrice') ) end)--Enter new buyout amount to set a Fixed Price
	frame.salebox.buy:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	MoneyInputFrame_SetOnValueChangedFunc(frame.salebox.buy, function() frame.SyncMoneyFrameStackBuy() frame.updated = true end)
	frame.salebox.buy.element = "buy"
	frame.salebox.buy:Hide()
	AppraiserSaleboxBuyGold:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 3, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuyGold:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBuySilver:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuySilver:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBuyCopper:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuyCopper:SetBackdropColor(0,0,0, 0)

	MoneyInputFrame_SetNextFocus(frame.salebox.bid, AppraiserSaleboxBuyGold)
	MoneyInputFrame_SetPreviousFocus(frame.salebox.bid, AppraiserSaleboxBuyCopper)
	MoneyInputFrame_SetNextFocus(frame.salebox.buy, AppraiserSaleboxBidGold)
	MoneyInputFrame_SetPreviousFocus(frame.salebox.buy, AppraiserSaleboxBidCopper)

	frame.salebox.buy.stack = CreateFrame("Frame", "AppraiserSaleboxBuyStack", frame.salebox, "MoneyInputFrameTemplate")
	frame.salebox.buy.stack:SetPoint("TOPLEFT", frame.salebox.bid.stack, "BOTTOMLEFT", 0,-5)
	frame.salebox.buy.stack:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_EnterBuyoutFixedPrice') ) end)--Enter new buyout amount to set a Fixed Price
	frame.salebox.buy.stack:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	MoneyInputFrame_SetOnValueChangedFunc(frame.salebox.buy.stack, function() frame.SyncMoneyFrameSingleBuy() frame.updated = true end)
	frame.salebox.buy.stack.element = "buyStack"
	frame.salebox.buy.stack:Hide()
	AppraiserSaleboxBuyStackGold:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 3, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuyStackGold:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBuyStackSilver:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuyStackSilver:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBuyStackCopper:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuyStackCopper:SetBackdropColor(0,0,0, 0)

	--sets the tab to next field options
	MoneyInputFrame_SetNextFocus(frame.salebox.bid.stack, AppraiserSaleboxBuyStackGold)
	MoneyInputFrame_SetPreviousFocus(frame.salebox.bid.stack, AppraiserSaleboxBuyStackCopper)
	MoneyInputFrame_SetNextFocus(frame.salebox.buy.stack, AppraiserSaleboxBidStackGold)
	MoneyInputFrame_SetPreviousFocus(frame.salebox.buy.stack, AppraiserSaleboxBidStackCopper)


	--Button for Bid  frame  to toggle stack/single mode
	frame.switchToStack = CreateFrame("Button", nil, frame.salebox, "OptionsButtonTemplate")
	frame.switchToStack:SetPoint("RIGHT", frame.salebox.bid, "LEFT", -10, 0)
	frame.switchToStack:SetText("")
	local font = frame.switchToStack:GetNormalFontObject()
		font:SetTextColor(1, 1, 1, 1)
	frame.switchToStack:SetNormalFontObject(font)
	frame.switchToStack:SetWidth(100)
	frame.switchToStack:SetHeight(16)
	frame.switchToStack:SetScript("OnClick", function()
		set("util.appraiser.classic", (not get("util.appraiser.classic")))
		frame.ChangeUI()
	end)
	frame.switchToStack.TooltipText = _TRANS('APPR_HelpTooltip_PricingMethod')--Switch between 'Per Item' and 'Per Stack' Pricing.
	frame.switchToStack:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, self.TooltipText) end)
	frame.switchToStack:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.switchToStack:Enable()

	--Button for Buy  frame to toggle stack/single mode
	frame.switchToStack2 = CreateFrame("Button", nil, frame.salebox, "OptionsButtonTemplate")
	frame.switchToStack2:SetPoint("RIGHT", frame.salebox.buy, "LEFT", -10, 0)
	frame.switchToStack2:SetText("")
	frame.switchToStack2:SetNormalFontObject(font)
	frame.switchToStack2:SetWidth(100)
	frame.switchToStack2:SetHeight(16)
	frame.switchToStack2:SetScript("OnClick", function()
		set("util.appraiser.classic", (not get("util.appraiser.classic")))
		frame.ChangeUI()
	end)
	frame.switchToStack2.TooltipText = _TRANS('APPR_HelpTooltip_PricingMethod')--Switch between 'Per Item' and 'Per Stack' Pricing.
	frame.switchToStack2:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, self.TooltipText) end)
	frame.switchToStack2:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.switchToStack2:Enable()


	frame.go = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.go:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7,15)
	frame.go:SetText(_TRANS('APPR_Interface_PostItems') )--Post items
	frame.go:SetWidth(80)
	frame.go:SetScript("OnClick", frame.PostAuctions)
	frame.go:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_PostsCurrentItem') ) end)--Posts current item
	frame.go:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.go.postType = "single"
	frame.go:Disable()

	frame.gobatch = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.gobatch:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -87,15)
	frame.gobatch:SetText(_TRANS('APPR_Interface_BatchPost') )--Batch post
	frame.gobatch:SetWidth(80)
	frame.gobatch:SetScript("OnClick", frame.PostAuctions)
	frame.gobatch:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	frame.gobatch:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_RefreshesCurrentBatch') ) end)--Alt: Refreshes batch post items Shift: Lists current batch post items RightClick: Posts batch post items Alt+RightClick: Toggles an item's batch post option on/off
	frame.gobatch:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.gobatch.postType = "batch"
	frame.gobatch:Enable()

	frame.refresh = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.refresh:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -167,15)
	frame.refresh:SetText("Refresh")
	frame.refresh:SetWidth(80)
	frame.refresh:SetScript("OnClick", frame.SmartRefresh)
	frame.refresh:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_RefreshesCurrentItem') ) end)--Normal: Refreshes current item Alt: Refreshes whole item list
	frame.refresh:SetScript("OnLeave", function() return GameTooltip:Hide() end)

	frame.age = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.age:SetPoint("RIGHT", frame.refresh, "LEFT", -10, 0)
	frame.age:SetTextColor(1, 0.8, 0)
	frame.age:SetText("")
	frame.age:SetJustifyH("RIGHT")
	--frame.age:SetJustifyV("BOTTOM")

	frame.cancel = CreateFrame("Button", "AucAdvAppraiserCancelButton", frame, "OptionsButtonTemplate")
	frame.cancel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 180, 15)
	frame.cancel:SetWidth(22)
	frame.cancel:SetHeight(18)
	frame.cancel:Disable()
	frame.cancel:SetScript("OnClick", function()
		AucAdvanced.Post.CancelPostQueue()
		frame.cancel:Disable()
		frame.cancel.tex:SetVertexColor(0.3,0.3,0.3)
	end)
	frame.cancel:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_ClearsPostQueue') ) end)--Clears post queue
	frame.cancel:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.cancel.tex = frame.cancel:CreateTexture(nil, "OVERLAY")
	frame.cancel.tex:SetPoint("TOPLEFT", frame.cancel, "TOPLEFT", 4, -2)
	frame.cancel.tex:SetPoint("BOTTOMRIGHT", frame.cancel, "BOTTOMRIGHT", -4, 2)
	frame.cancel.tex:SetTexture("Interface\\Addons\\Auc-Advanced\\Textures\\NavButtons")
	frame.cancel.tex:SetTexCoord(0.25, 0.5, 0, 1)
	frame.cancel.tex:SetVertexColor(0.3, 0.3, 0.3)
	frame.cancel.label = frame.cancel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.cancel.label:SetPoint("LEFT", frame.cancel, "RIGHT", 5, 0)
	frame.cancel.label:SetTextColor(1, 0.8, 0)
	frame.cancel.label:SetText("")
	frame.cancel.label:SetJustifyH("LEFT")

	local lastPostProgress = 0
	local progressBarOptions = {barColor = {0,0,.6}}
	function private.UpdatePostQueueProgress(postnum)
		frame.cancel.label:SetText(tostring(postnum))
		--display a progress bar
		if postnum > lastPostProgress then lastPostProgress = postnum end
		local value = (100 - postnum * 100 / lastPostProgress) or 0
		AucAdvanced.API.ProgressBars("AppraiserBar", value, true, "Appraiser has "..postnum.." more items to post", progressBarOptions)

		if (postnum > 0) and not frame.cancel:IsEnabled() then
			frame.cancel:Enable()
			frame.cancel.tex:SetVertexColor(1.0, 0.9, 0.1)
		elseif (postnum == 0) and frame.cancel:IsEnabled() then
			frame.cancel:Disable()
			frame.cancel.tex:SetVertexColor(0.3,0.3,0.3)
			lastPostProgress = 0
			AucAdvanced.API.ProgressBars("AppraiserBar")
		end
	end

	frame.manifest = CreateFrame("Frame", nil, frame)
	frame.manifest:SetBackdrop({
		bgFile = "Interface\\Tooltips\\ChatBubble-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.manifest:SetBackdropColor(0, 0, 0, 1)
	frame.manifest:SetPoint("TOPLEFT", frame, "TOPRIGHT", -20,-30)
	frame.manifest:SetPoint("BOTTOM", frame, "BOTTOM", 0,30)
	frame.manifest:SetWidth(230)
	frame.manifest:SetFrameStrata("MEDIUM")
	frame.manifest:SetFrameLevel(AuctionFrame:GetFrameLevel())
	frame.manifest:Hide()

	frame.manifest.close = CreateFrame("Button", nil, frame.manifest)
	frame.manifest.close:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	frame.manifest.close:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	frame.manifest.close:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	frame.manifest.close:SetDisabledTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Disabled")
	frame.manifest.close:SetPoint("TOPRIGHT", frame.manifest, "TOPRIGHT", 0,0)
	frame.manifest.close:SetWidth(26)
	frame.manifest.close:SetHeight(26)
	frame.manifest.close:SetScript("OnClick", function()
		frame.manifest:Hide()
		frame.toggleManifest:SetText("Open Sidebar")
	end)

	local function lineHide(obj)
		local id = obj.id
		local line = frame.manifest.lines[id]
		line[1]:Hide()
		line[2]:Hide()
	end

	local function lineSet(obj, text, coins, r,g,b)
		local id = obj.id
		local line = frame.manifest.lines[id]
		line[1]:SetText(text)
		if r and g and b then
			line[1]:SetTextColor(r,g,b)
		else
			line[1]:SetTextColor(1,1,1)
		end
		line[1]:Show()

		if coins then
			line[2]:SetValue(math.floor(tonumber(coins) or 0))
			line[2]:Show()
		else
			line[2]:Hide()
		end
	end

	local function lineReset(obj, text, coins)
		local id = obj.id
		local line = frame.manifest.lines[id]
		line[1]:SetText("")
		line[2]:SetValue(0)
		line[2]:Hide()
	end

	local function linesClear(obj)
		obj.pos = 0
		for i = 1, obj.max do
			obj[i]:Hide()
		end
	end

	local function linesAdd(obj, text, coins, r,g,b)
		obj.pos = obj.pos + 1
		if (obj.pos > obj.max) then return end
		obj[obj.pos]:Set(text, coins, r,g,b)
	end

	local myStrata = frame.manifest:GetFrameStrata()

	frame.manifest.header = frame.manifest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.manifest.header:SetPoint("TOPLEFT", frame.manifest, "TOPLEFT", 24, -5)
	frame.manifest.header:SetPoint("RIGHT", frame.manifest, "RIGHT", 0,0)
	frame.manifest.header:SetJustifyH("LEFT")
	frame.manifest.header:SetText(_TRANS('APPR_Interface_AuctionDetail') )--Auction detail:

	local lines = { pos = 0, max = 40, Clear = linesClear, Add = linesAdd }
	for i=1, lines.max do
		local text = frame.manifest:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		if i == 1 then
			text:SetPoint("TOPLEFT", frame.manifest, "TOPLEFT", 26,-18)
		else
			text:SetPoint("TOPLEFT", lines[i-1][1], "BOTTOMLEFT", 0,0)
		end
		text:SetPoint("RIGHT", frame.manifest, "RIGHT", -8,0)
		text:SetJustifyH("LEFT")
		text:SetHeight(9)

		local coins = AucAdvanced.CreateMoney(8)
		coins:SetParent(frame.manifest)
		coins:SetPoint("RIGHT", text, "RIGHT", 0,0)
		coins:SetFrameStrata(myStrata)
		local line = { text, coins, id = i, Hide = lineHide, Set = lineSet, Reset = lineReset }
		lines[i] = line
	end
	frame.manifest.lines = lines

	frame.imageview = CreateFrame("Frame", nil, frame)
	frame.imageview:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.imageview:SetBackdropColor(0, 0, 0, 0.8)
	frame.imageview:SetPoint("TOPLEFT", frame.salebox, "BOTTOMLEFT", 0, 2)
	frame.imageview:SetPoint("TOPRIGHT", frame.salebox, "BOTTOMRIGHT", 0, 2)
	frame.imageview:SetPoint("BOTTOM", frame.itembox, "BOTTOM", 0, 20)
	--records the column width changes
	--store width by header name, that way if column reorginizing is added we apply size to proper column
	function private.onResize(self, column, width)
		if not width then
			set("util.appraiser.columnwidth."..self.labels[column]:GetText(), "default") --reset column if no width is passed. We use CTRL+rightclick to reset column
			self.labels[column].button:SetWidth(get("util.appraiser.columnwidth."..self.labels[column]:GetText()))
		else
			set("util.appraiser.columnwidth."..self.labels[column]:GetText(), width)
		end
	end

	function private.BuyAuction()
		aucPrint(private.buyselection.link)
		AucAdvanced.Buy.QueueBuy(private.buyselection.link, private.buyselection.seller, private.buyselection.stack, private.buyselection.minbid, private.buyselection.buyout, private.buyselection.buyout)
		frame.imageview.sheet.selected = nil
		private.onSelect()
	end
	function private.BidAuction()
		local bid = private.buyselection.minbid
		if private.buyselection.curbid and private.buyselection.curbid > 0 then
			bid = math.ceil(private.buyselection.curbid*1.05)
		end
		AucAdvanced.Buy.QueueBuy(private.buyselection.link, private.buyselection.seller, private.buyselection.stack, private.buyselection.minbid, private.buyselection.buyout, bid)
		frame.imageview.sheet.selected = nil
		private.onSelect()
	end

	private.buyselection = {}
	function private.onSelect()
		if frame.imageview.sheet.prevselected ~= frame.imageview.sheet.selected then
			frame.imageview.sheet.prevselected = frame.imageview.sheet.selected
			local selected = frame.imageview.sheet:GetSelection()
			if (not selected) or (not selected[10]) then
				private.buyselection = {}
				frame.imageview.purchase.buy:Disable()
				frame.imageview.purchase.buy.price:SetText("")
				frame.imageview.purchase.bid:Disable()
				frame.imageview.purchase.bid.price:SetText("")
			else
				private.buyselection.link = selected[10]
				private.buyselection.seller = selected[1]
				private.buyselection.stack = selected[3]
				private.buyselection.minbid = selected[7]
				private.buyselection.curbid = selected[8]
				private.buyselection.buyout = selected[9]
				--make sure that it's not one of our auctions, then enable based on buy/bid availability
				if (not AucAdvancedConfig["users."..Const.PlayerRealm.."."..private.buyselection.seller]) then
					if private.buyselection.buyout and (private.buyselection.buyout > 0) then
						frame.imageview.purchase.buy:Enable()
						frame.imageview.purchase.buy.price:SetText(AucAdvanced.Coins(private.buyselection.buyout, true))
					else
						frame.imageview.purchase.buy:Disable()
						frame.imageview.purchase.buy.price:SetText("")
					end

					if private.buyselection.minbid then
						if private.buyselection.curbid and private.buyselection.curbid > 0 then
							frame.imageview.purchase.bid.price:SetText(AucAdvanced.Coins(math.ceil(private.buyselection.curbid*1.05), true))
						else
							frame.imageview.purchase.bid.price:SetText(AucAdvanced.Coins(private.buyselection.minbid, true))
						end
						frame.imageview.purchase.bid:Enable()
					else
						frame.imageview.purchase.bid:Disable()
						frame.imageview.purchase.bid.price:SetText("")
					end
				else
					frame.imageview.purchase.buy:Disable()
					frame.imageview.purchase.buy.price:SetText("")
					frame.imageview.purchase.bid:Disable()
					frame.imageview.purchase.bid.price:SetText("")
				end
			end
		end
	end

	function private.onClick(button, row, index)
		if (IsAltKeyDown()) and frame.imageview.sheet.labels[index]:GetText() == "Seller" then
			local seller = frame.imageview.sheet.rows[row][index]:GetText()
			if AucAdvanced.Modules.Filter.Basic then
				AucAdvanced.Modules.Filter.Basic.PromptSellerIgnore(seller, frame.imageview.sheet.panel, "TOPLEFT", button, "BOTTOM")
			end
		end
	end

	frame.imageview.sheet = ScrollSheet:Create(frame.imageview, {
		--{ "Item",   "TEXT", get("util.appraiser.columnwidth.Item")}, -- Default width 105
		{ _TRANS('APPR_Interface_Seller') , "TEXT", get("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Seller'))},
		{ _TRANS('APPR_Interface_TimeLeft') ,   "INT",  get("util.appraiser.columnwidth.".._TRANS('APPR_Interface_TimeLeft'))},
		{ _TRANS('APPR_Interface_Stk') ,    "INT",  get("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Stk'))},
		{ _TRANS('APPR_Interface_Min/ea') , "COIN", get("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Min/ea')), { DESCENDING=true } },
		{ _TRANS('APPR_Interface_Cur/ea') , "COIN", get("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Cur/ea')), { DESCENDING=true } },
		{ _TRANS('APPR_Interface_Buy/ea') , "COIN", get("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Buy/ea')), { DESCENDING=true, DEFAULT=true } },
		{ _TRANS('APPR_Interface_MinBid') , "COIN", get("util.appraiser.columnwidth.".._TRANS('APPR_Interface_MinBid')), { DESCENDING=true } },
		{ _TRANS('APPR_Interface_CurBid') , "COIN", get("util.appraiser.columnwidth.".._TRANS('APPR_Interface_CurBid')), { DESCENDING=true } },
		{ _TRANS('APPR_Interface_Buyout') , "COIN", get("util.appraiser.columnwidth." .._TRANS('APPR_Interface_Buyout')), { DESCENDING=true } },
		{ "", "TEXT", get("util.appraiser.columnwidth.BLANK")}, --Hidden column to carry the link --0
	})

	frame.imageview.sheet:EnableSelect(true)

	frame.imageview.purchase = CreateFrame("Frame", nil, frame.imageview)
	frame.imageview.purchase:SetPoint("TOPLEFT", frame.imageview, "BOTTOMLEFT", 0, 4)
	frame.imageview.purchase:SetPoint("BOTTOMRIGHT", frame.imageview, "BOTTOMRIGHT", 0, -16)
	frame.imageview.purchase:SetBackdrop({
		bgFile = "Interface\\QuestFrame\\UI-QuestTitleHighlight"
	})
	frame.imageview.purchase:SetBackdropColor(0.5, 0.5, 0.5, 1)

	frame.imageview.purchase.buy = CreateFrame("Button", nil, frame.imageview.purchase, "OptionsButtonTemplate")
	frame.imageview.purchase.buy:SetPoint("TOPLEFT", frame.imageview.purchase, "TOPLEFT", 5, 0)
	frame.imageview.purchase.buy:SetWidth(30)
	frame.imageview.purchase.buy:SetText(_TRANS('APPR_Interface_Buy') )--Buy
	frame.imageview.purchase.buy:SetScript("OnClick", private.BuyAuction)
 	frame.imageview.purchase.buy:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_BuyoutSelectedAuction') ) end)--Buyout the selected competing auction
	frame.imageview.purchase.buy:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.imageview.purchase.buy:Disable()

	frame.imageview.purchase.buy.price = frame.imageview.purchase.buy:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.imageview.purchase.buy.price:SetPoint("TOPLEFT", frame.imageview.purchase.buy, "TOPRIGHT")
	frame.imageview.purchase.buy.price:SetPoint("BOTTOMLEFT", frame.imageview.purchase.buy, "BOTTOMRIGHT")
	frame.imageview.purchase.buy.price:SetJustifyV("MIDDLE")

	frame.imageview.purchase.bid = CreateFrame("Button", nil, frame.imageview.purchase, "OptionsButtonTemplate")
	frame.imageview.purchase.bid:SetPoint("TOPLEFT", frame.imageview.purchase.buy, "TOPLEFT", 120, 0)
	frame.imageview.purchase.bid:SetWidth(30)
	frame.imageview.purchase.bid:SetText(_TRANS('APPR_Interface_Bid') )--Bid
	frame.imageview.purchase.bid:SetScript("OnClick", private.BidAuction)
 	frame.imageview.purchase.bid:SetScript("OnEnter", function(self) return frame.SetButtonTooltip(self, _TRANS('APPR_HelpTooltip_BidSelectedAuction') ) end)--Place a bid on the selected competing auction
	frame.imageview.purchase.bid:SetScript("OnLeave", function() return GameTooltip:Hide() end)
	frame.imageview.purchase.bid:Disable()

	frame.imageview.purchase.bid.price = frame.imageview.purchase.bid:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.imageview.purchase.bid.price:SetPoint("TOPLEFT", frame.imageview.purchase.bid, "TOPRIGHT")
	frame.imageview.purchase.bid.price:SetPoint("BOTTOMLEFT", frame.imageview.purchase.bid, "BOTTOMRIGHT")
	frame.imageview.purchase.bid.price:SetJustifyV("MIDDLE")

	frame.ScanTab = CreateFrame("Button", "AuctionFrameTabUtilAppraiser", AuctionFrame, "AuctionTabTemplate")
	frame.ScanTab:SetText(_TRANS('APPR_Interface_Appraiser') )--Appraiser
	frame.ScanTab:Show()
	PanelTemplates_DeselectTab(frame.ScanTab) -- initialize tab layout
	frame.ScanTab.isdisplayed = false
	function frame.ScanTab:SetDisplay()
		if get("util.appraiser.displayauctiontab") then
			if not self.isdisplayed then
				-- Avoid calling AddTab if tab is already displayed, as that would cause a warning chat message
				AucAdvanced.AddTab(self, frame)
				self.isdisplayed = true
			end
		else
			if self.isdisplayed then
				AucAdvanced.RemoveTab(self, frame)
				self.isdisplayed = false
			end
		end
	end
	frame.ScanTab:SetDisplay()
	function frame.ScanTab.OnClick(self)
		local index = self:GetID()
		local tab = _G["AuctionFrameTab"..index]
		if (tab and tab:GetName() == "AuctionFrameTabUtilAppraiser") then
			AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopLeft")
			AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-Top")
			AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopRight")
			AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotLeft")
			AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-Bot")
			AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight")
			AuctionFrameMoneyFrame:Show()
			if (SideDressUpFrame:IsVisible()) then
				SideDressUpFrame:Hide()
				SideDressUpFrame.reshow = true
			end
			frame:Show()
			frame.GenerateList(true)
		else
			if (SideDressUpFrame.reshow) then
				SideDressUpFrame:Show()
				SideDressUpFrame.reshow = nil
			end
			AuctionFrameMoneyFrame:Show()
			frame:Hide()
		end
	end

	frame.ChangeUI()
	hooksecurefunc("AuctionFrameTab_OnClick", frame.ScanTab.OnClick)

	hooksecurefunc("HandleModifiedItemClick", function (link)
		if GetMouseButtonClicked() == "LeftButton" and IsAltKeyDown() and get("util.appraiser.clickhookany") then
			if link then
				frame.SelectItem(nil, nil, link)
			end
		end
	end)

	-- GetMouseButtonClicked doesn't work for chatlinks, so we hook SetItemRef as well
	hooksecurefunc("SetItemRef", function (shortlink, hyperlink, mousebutton, chatframe)
		if mousebutton == "LeftButton" and IsAltKeyDown() and frame:IsVisible() and get("util.appraiser.clickhookany") then
			local link = hyperlink or shortlink
			if link then
				frame.SelectItem(nil, nil, link)
			end
		end
	end)

	--[[These scrollframe functions need to be here to avoid errors, since many elements of appraisers frames are not finished when we create the scrollframe]]
	--If we have a saved column arrangement reapply
	if get("util.appraiser.columnorder") then
		frame.imageview.sheet:SetOrder(get("util.appraiser.columnorder") )
	end
	--Apply last column sort used
	if get("util.appraiser.columnsortcurSort") then
		frame.imageview.sheet.curSort = get("util.appraiser.columnsortcurSort") or 1
		frame.imageview.sheet.curDir = get("util.appraiser.columnsortcurDir") or 1
		frame.imageview.sheet:PerformSort()
	end
	--callback functions for frame.imageview.sheet events, register for callbacks AFTER we have applied any saved changes
	function frame.imageview.sheet.Processor(callback, self, button, column, row, order, curDir, ...)
		if callback == "OnEnterCell" then
			-- Use this callback to detect that the user is interacting with the sheet
			frame.CheckImageUpdate() -- If there is a scheduled (delayed) image update, do it now
		elseif (callback == "OnMouseDownCell")  then
			private.onSelect()
		elseif (callback == "OnClickCell") then
			private.onClick(button, row, column)
		elseif (callback == "ColumnOrder") then
			set("util.appraiser.columnorder", order)
		elseif (callback == "ColumnWidthSet") then
			private.onResize(self, column, button:GetWidth() )
		elseif (callback == "ColumnWidthReset") then
			private.onResize(self, column, nil)
		elseif (callback == "ColumnSort") then
			set("util.appraiser.columnsortcurDir", curDir)
			set("util.appraiser.columnsortcurSort", column)
		end
	end

end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-Appraiser/AprFrame.lua $", "$Rev: 6417 $")
