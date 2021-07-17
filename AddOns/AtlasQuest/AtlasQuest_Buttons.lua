--[[

	AtlasQuest, a World of Warcraft addon.
	Email me at mystery8@gmail.com

	This file is part of AtlasQuest.

	AtlasQuest is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	AtlasQuest is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with AtlasQuest; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]


-- Colours
--
local RED = "|cffFF0000";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff1EFF00";
local GREY = "|cff9D9D9D";
local BLUE = "|cff0070DD";
local ORANGE = "|cffFF8000"; 
local YELLOW = "|cffFFD200";
local BLACK = "|c0000000F";

local AQQuestfarbe



-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------
function AQClearALL()
       AQPageCount:SetText();
       HideUIPanel(AQNextPageButton_Right);
       HideUIPanel(AQNextPageButton_Left);
       QuestName:SetText("");
       QuestLeveltext:SetText("");
       Prequesttext:SetText("");
       QuestAttainLeveltext:SetText("");
       REWARDstext:SetText();
       AQFQ_TEXT:SetText();
       HideUIPanel(AQFinishedQuest);
       for b=1, 6 do
          getglobal("AtlasQuestItemframe"..b.."_Icon"):SetTexture();
          getglobal("AtlasQuestItemframe"..b.."_Name"):SetText();
          getglobal("AtlasQuestItemframe"..b.."_Extra"):SetText();
          getglobal("AtlasQuestItemframe"..b):Disable();
       end
end


-----------------------------------------------------------------------------
-- Option button, shows option frame or hides if shown
-----------------------------------------------------------------------------
function AQOPTION1_OnClick()
   if (AtlasQuestOptionFrame:IsVisible()) then
     HideUIPanel(AtlasQuestOptionFrame);
   else
     ShowUIPanel(AtlasQuestOptionFrame);
   end
end


-----------------------------------------------------------------------------
-- upper right button / to show/close panel
-----------------------------------------------------------------------------
function AQCLOSE_OnClick()
      AQ_AtlasOrAlphamap();
      if(AtlasQuestFrame:IsVisible()) then
          HideUIPanel(AtlasQuestFrame);
          HideUIPanel(AtlasQuestInsideFrame);
      else
          ShowUIPanel(AtlasQuestFrame);
      end
      AQUpdateNOW = true;
end


-----------------------------------------------------------------------------
-- upper left button on the panel for closing
-----------------------------------------------------------------------------
function AQCLOSE1_OnClick()
   HideUIPanel(AtlasQuestFrame);
end


-----------------------------------------------------------------------------
-- inside button to close the quest display
-----------------------------------------------------------------------------
function AQCLOSE2_OnClick()
    HideUIPanel(AtlasQuestInsideFrame);
    WHICHBUTTON = 0;
end


-----------------------------------------------------------------------------
-- Checkbox for Alliance
-----------------------------------------------------------------------------
function Alliance_OnClick()
     Allianceorhorde = 1
     AQHCB:SetChecked(false);
     AQACB:SetChecked(true);
     HideUIPanel(AtlasQuestInsideFrame);
     AQUpdateNOW = true;
end


-----------------------------------------------------------------------------
-- Checkbox for Horde
-----------------------------------------------------------------------------
function Horde_OnClick()
     Allianceorhorde = 2
     AQHCB:SetChecked(true);
     AQACB:SetChecked(false);
     HideUIPanel(AtlasQuestInsideFrame);
     AQUpdateNOW = true;
end


-----------------------------------------------------------------------------
-- Button
-----------------------------------------------------------------------------
function Quest_OnClick(arg1)
local AQactiveWindow = ChatEdit_GetActiveWindow();
   if (AQactiveWindow and IsShiftKeyDown()) then
     AQInsertQuestInformation();
   else
     AQHideAL();
     if (AtlasQuestInsideFrame:IsVisible() == false) then
         ShowUIPanel(AtlasQuestInsideFrame);
         WHICHBUTTON = AQSHOWNQUEST;
         AQButton_SetText();
     elseif ( WHICHBUTTON == AQSHOWNQUEST) then
         HideUIPanel(AtlasQuestInsideFrame);
         WHICHBUTTON = 0;
     else
       WHICHBUTTON = AQSHOWNQUEST;
       AQButton_SetText();
     end
   end
end


-----------------------------------------------------------------------------
-- Hide the AtlasLoot Frame if available
-----------------------------------------------------------------------------
function AQHideAL()
       if ( AtlasLootItemsFrame ~= nil) then
            AtlasLootItemsFrame:Hide(); -- hide atlasloot
       end
end


-----------------------------------------------------------------------------
-- Insert Quest Link into the chat box
-----------------------------------------------------------------------------
function AQInsertQuestInformation()
local OnlyQuestNameRemovedNumber
local Quest
local AQactiveWindow = ChatEdit_GetActiveWindow();
Quest = AQSHOWNQUEST;


-- Grab the Quest ID and then the QuestLink string.
if (Allianceorhorde == 1) then
	AQ_QuestID = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_QuestID");
	AQ_QuestLevel = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Level");
else
	AQ_QuestID = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_QuestID");
	AQ_QuestLevel = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Level");
end


-- Remove the beginning number from the quest name
if (Quest <= 9) then
	if (Allianceorhorde == 1) then
		AQ_QuestName = strsub(getglobal("Inst"..AQINSTANZ.."Quest"..Quest), 4)

	elseif (Allianceorhorde == 2) then
		AQ_QuestName = strsub(getglobal("Inst"..AQINSTANZ.."Quest"..Quest.."_HORDE"), 4)
	end
elseif (Quest > 9) then
	if (Allianceorhorde == 1) then
		AQ_QuestName = strsub(getglobal("Inst"..AQINSTANZ.."Quest"..Quest), 5)
	elseif (Allianceorhorde == 2) then
		AQ_QuestName = strsub(getglobal("Inst"..AQINSTANZ.."Quest"..Quest.."_HORDE"), 5)
	end
end


-- Code from Denival to remove parentheses and anything in it from Quest Name string
ps, pe = strfind(AQ_QuestName," %(.*%)")
if (ps) then
	AQ_QuestName = strsub(AQ_QuestName,1,ps-1)
end


-- Grab the Quest Link string using the ID and hopefully use the localized quest name for the link.
local AQ_QuestLink = "\124cffffff00\124Hquest:"..AQ_QuestID..":"..AQ_QuestLevel.."\124h["..AQ_QuestName.."]\124h\124r";


--[[ Debug Stuff
ChatFrame1:AddMessage("Quest ID: "..AQ_QuestID);
ChatFrame1:AddMessage("Quest Level: "..AQ_QuestLevel);
ChatFrame1:AddMessage("Quest Name: "..AQ_QuestName);
ChatFrame1:AddMessage("Quest Link: "..AQ_QuestLink);
--]]

-- Verify that the variable was set then output to chat window
if ( AQ_QuestLink ) then
	AQactiveWindow:Insert(AQ_QuestLink);
else
	-- Otherwise, post the quest name and level. NOTE: This code is presently obsolete. Will remove later.	
	if ( Allianceorhorde == 1) then
		AQactiveWindow:Insert("["..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Level").."] ["..AQ_QuestName.."] ");
	else
		AQactiveWindow:Insert("["..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Level").."] ["..AQ_QuestName.."]");
	end
end


end


-----------------------------------------------------------------------------
-- set the Quest text
-- executed when you push a button
-----------------------------------------------------------------------------
function AQButton_SetText()
local SHOWNID
local name
local nameDATA
local colour
local itemName, itemQuality



     AQClearALL();
     -- Show the finished button
     ShowUIPanel(AQFinishedQuest);
     AQFQ_TEXT:SetText(BLUE..AQFinishedTEXT);
     --
     if ( Allianceorhorde == 1) then
       AQColourCheck(1); --CC swaped out (see below)
       AQCompareQLtoAQ(Quest)
         QuestName:SetText(AQQuestfarbe..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST));
         QuestLeveltext:SetText(BLUE..AQDiscription_LEVEL..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Level"));
         QuestAttainLeveltext:SetText(BLUE..AQDiscription_ATTAIN..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Attain")); 
         Prequesttext:SetText(BLUE..AQDiscription_PREQUEST..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Prequest").."\n \n"..BLUE..AQDiscription_FOLGEQUEST..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Folgequest").."\n \n"..BLUE..AQDiscription_START..WHITE.."\n"..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Location").."\n \n"..BLUE..AQDiscription_AIM.."\n"..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Aim").."\n \n"..BLUE..AQDiscription_NOTE.."\n"..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Note"));

         for b=1, 6 do
           REWARDstext:SetText(getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."Rewardtext"))
           if ( getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ID"..b) ~= nil) then

             SHOWNID = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ID"..b);

               colour = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ITC"..b);
               nameDATA = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."name"..b);

             getglobal("AtlasQuestItemframe"..b.."_Icon"):SetTexture(GetItemIcon(SHOWNID));
             getglobal("AtlasQuestItemframe"..b.."_Name"):SetText(AQgetItemInformation(b,"name"));
             getglobal("AtlasQuestItemframe"..b.."_Extra"):SetText(AQgetItemInformation(b,"extra"));
             getglobal("AtlasQuestItemframe"..b):Enable();
           else
             getglobal("AtlasQuestItemframe"..b.."_Icon"):SetTexture();
             getglobal("AtlasQuestItemframe"..b.."_Name"):SetText();
             getglobal("AtlasQuestItemframe"..b.."_Extra"):SetText();
             getglobal("AtlasQuestItemframe"..b):Disable();
           end
         end
     end
     if ( Allianceorhorde == 2) then
      AQColourCheck(0) --CC swaped out (see below)
       QuestName:SetText(AQQuestfarbe..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE"));
       QuestLeveltext:SetText(BLUE..AQDiscription_LEVEL..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Level"));
       QuestAttainLeveltext:SetText(BLUE..AQDiscription_ATTAIN..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Attain"));       
       Prequesttext:SetText(BLUE..AQDiscription_PREQUEST..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Prequest").."\n \n"..BLUE..AQDiscription_FOLGEQUEST..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Folgequest").."\n \n"..BLUE..AQDiscription_START.."\n"..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Location").."\n \n"..BLUE..AQDiscription_AIM..WHITE.."\n"..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Aim").."\n \n"..BLUE..AQDiscription_NOTE.."\n"..WHITE..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Note"));

       for b=1, 6 do
           REWARDstext:SetText(getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."Rewardtext_HORDE"))
           if ( getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ID"..b.."_HORDE") ~= nil) then
           
             SHOWNID = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ID"..b.."_HORDE");

               colour = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ITC"..b.."_HORDE");
               nameDATA = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."name"..b.."_HORDE");
           
             getglobal("AtlasQuestItemframe"..b.."_Icon"):SetTexture(GetItemIcon(SHOWNID));
             getglobal("AtlasQuestItemframe"..b.."_Name"):SetText(AQgetItemInformation(b,"name"));
             getglobal("AtlasQuestItemframe"..b.."_Extra"):SetText(AQgetItemInformation(b,"extra"));
             getglobal("AtlasQuestItemframe"..b):Enable();
           else
             getglobal("AtlasQuestItemframe"..b.."_Icon"):SetTexture();
             getglobal("AtlasQuestItemframe"..b.."_Name"):SetText();
             getglobal("AtlasQuestItemframe"..b.."_Extra"):SetText();
             getglobal("AtlasQuestItemframe"..b):Disable();
           end
         end
     end
     AQQuestFinishedSetChecked();
end


-----------------------------------------------------------------------------
-- improve the localisation through giving back the right and translated questname
-- sets the description text too
-- adds a error message to the description if item not available
-----------------------------------------------------------------------------
function AQgetItemInformation(count,what)
local itemId
local itemtext;
local itemdiscription;
local itemName, itemQuality

if ( Allianceorhorde == 2) then
  itemId = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ID"..count.."_HORDE")
  itemdiscription = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."description"..count.."_HORDE")
  itemTEXTSAVED = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ITC"..count.."_HORDE")..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."name"..count.."_HORDE");
else
  itemId = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ID"..count)
  itemdiscription = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."description"..count)
  itemTEXTSAVED = getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ITC"..count)..getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."name"..count);
end

  if (GetItemInfo(itemId)) then
    itemName, _, itemQuality = GetItemInfo(itemId);
    local r, g, b, hex = GetItemQualityColor(itemQuality);
    itemtext = itemTEXTSAVED;
--  itemtext = hex..itemName;  -- Don't understand why this stopped working. Commented out January 17, 2012 by Thandrenn.
    if (what == "name") then
      return itemtext;
    elseif (what == "extra") then
      return itemdiscription;
    end
  else
    itemtext = itemTEXTSAVED
    if (what == "name") then
      return itemtext;
    elseif (what == "extra") then
      return itemdiscription;
    end
  end

end


-----------------------------------------------------------------------------
-- Set the Quest Name color
-- swapped out to get the code clear
-----------------------------------------------------------------------------
function AQColourCheck(arg1)
 local AQQuestlevelf
       if (arg1 == 1) then
         AQQuestlevelf = tonumber(getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_Level"));
         --DEFAULT_CHAT_FRAME:AddMessage("BLA");
       else
         AQQuestlevelf = tonumber(getglobal("Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE_Level"));
         --DEFAULT_CHAT_FRAME:AddMessage("BLUB");
       end
       if ( AQQuestlevelf ~= nil or AQQuestlevelf ~= 0 or AQQuestlevelf ~= "") then
          if ( AQQuestlevelf == UnitLevel("player") or AQQuestlevelf == UnitLevel("player") + 2 or AQQuestlevelf  == UnitLevel("player") - 2 or AQQuestlevelf == UnitLevel("player") + 1 or AQQuestlevelf  == UnitLevel("player") - 1) then
             AQQuestfarbe = YELLOW;
          elseif ( AQQuestlevelf > UnitLevel("player") + 2 and AQQuestlevelf <= UnitLevel("player") + 4) then
             AQQuestfarbe = ORANGE;
          elseif ( AQQuestlevelf >= UnitLevel("player") + 5 and AQQuestlevelf ~= 100) then
             AQQuestfarbe = RED;
          elseif ( AQQuestlevelf < UnitLevel("player") - 7) then
             AQQuestfarbe = GREY;
          elseif ( AQQuestlevelf >= UnitLevel("player") - 7 and AQQuestlevelf < UnitLevel("player") - 2) then
             AQQuestfarbe = GREEN;
          end
          if (AQNOColourCheck) then
             AQQuestfarbe = YELLOW;
          end
          if ( AQQuestlevelf == 100 or AQCompareQLtoAQ()) then
             AQQuestfarbe = BLUE;
          end
          if (arg1 == 1) then
            if ( AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST ] == 1) then
              AQQuestfarbe = WHITE;
            end
          else
            if ( AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE" ] == 1) then
              AQQuestfarbe = WHITE;
            end
          end
       end
end


-----------------------------------------------------------------------------
-- set the checkbox for the finished quest check
-- swaped out to get the code clear
-----------------------------------------------------------------------------
function AQQuestFinishedSetChecked()
  if ( Allianceorhorde == 1) then
    if ( AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST ] == 1) then
      AQFinishedQuest:SetChecked(true);
    else
      AQFinishedQuest:SetChecked(false);
    end
  else
    if ( AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE" ] == 1) then
      AQFinishedQuest:SetChecked(true);
    else
      AQFinishedQuest:SetChecked(false);
    end
  end
end



-----------------------------------------------------------------------------
-- Checkbox for the finished quest option
-----------------------------------------------------------------------------
function AQFinishedQuest_OnClick()
  if (AQFinishedQuest:GetChecked() and Allianceorhorde == 1) then
    AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST ] = 1;
    setglobal("AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST , 1);
  elseif (AQFinishedQuest:GetChecked() and Allianceorhorde == 2) then
    AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE" ] = 1;
  elseif ((not AQFinishedQuest:GetChecked()) and (Allianceorhorde == 1)) then
    AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST ] = nil;
  elseif ((not AQFinishedQuest:GetChecked()) and (Allianceorhorde == 2)) then
    AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE" ] = nil;
  end
  --save everything
  if (Allianceorhorde == 1) then
    AtlasQuest_Options[UnitName("player")]["AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST] = AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST ]
  elseif (Allianceorhorde == 2) then
    AtlasQuest_Options[UnitName("player")]["AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE"] = AQ[ "AQFinishedQuest_Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."_HORDE" ]
  end

  AtlasQuestSetTextandButtons()
  AQButton_SetText()
end


-----------------------------------------------------------------------------
-- General Information for the Instance
-----------------------------------------------------------------------------
function AQGeneral_OnClick(arg1)
  -- first clear display
  AQClearALL();
  AQHideAL();
  if(AtlasQuestInsideFrame:IsVisible()) then
    HideUIPanel(AtlasQuestInsideFrame);
  else
    ShowUIPanel(AtlasQuestInsideFrame);
  end

  --
  if (getglobal("Inst"..AQINSTANZ.."General") ~= nil) then
    QuestName:SetText(BLUE..getglobal("Inst"..AQINSTANZ.."General")[1][1]);
  end
end

