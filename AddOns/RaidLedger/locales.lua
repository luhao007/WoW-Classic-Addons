local _, ADDONSELF = ...

local L = setmetatable({}, {
    __index = function(table, key)
        if key then
            table[key] = tostring(key)
        end
        return tostring(key)
    end,
})


ADDONSELF.L = L

--
-- Use https://www.curseforge.com/wow/addons/raidledger/localization to translate thanks
--
local locale = GetLocale()

if locale == 'enUs' then
L["# one item per line, can be item name or item id"] = true
L["#Try to convert to item link"] = true
L["/raidledger"] = true
L["[Unknown]"] = true
L["Auto recording blacklist"] = true
L["Auto recording loot"] = true
L["Auto recording loot: In Raid Only"] = true
L["Auto recording loot: Off"] = true
L["Auto recording loot: On"] = true
L["Auto recording quality"] = true
L["Beneficiary"] = true
L["Cannot find any debit entry in template, please check your template in options"] = true
L["Clear"] = true
L["Close text export"] = true
L["Compensation"] = true
L["Compensation added"] = true
L["Compensation: DPS"] = true
L["Compensation: Healer"] = true
L["Compensation: Other"] = true
L["Compensation: Repait Bot"] = true
L["Compensation: Tank"] = true
L["convert failed, text can be either item id or item name"] = true
L["Credit"] = true
L["CTRL + click for summary mode"] = true
L["CTRL + Click to apply debit template"] = true
L["Debit"] = true
L["Debit Template"] = true
L["Entry"] = true
L["Expense"] = true
L["Export as text"] = true
L["Feedback"] = true
L["Import from ledger"] = true
L["In Raid Only"] = true
L["Input only"] = true
L["Item added"] = true
L["Last used"] = true
L["Member credit for subgroup"] = true
L["Name of Debit template"] = true
L["Net Profit"] = true
L["Other"] = true
L["Per Member"] = true
L["Per Member credit"] = true
L["Raid Ledger"] = true
L["Remove all records?"] = true
L["Remove ALL SAME record?"] = true
L["Remove this record?"] = true
L["Rename"] = true
L["Report"] = true
L["Revenue"] = true
L["Right click to choose channel"] = true
L["Right click to remove record"] = true
L["Round down"] = true
L["Round per member credit down"] = true
L["Set split into number when team size changes automatically"] = true
L["Shift + item/name to add to record"] = true
L["Shift + Right click to remove ALL SAME record"] = true
L["Special Members"] = true
L["Split into"] = true
L["Split into (Current %d)"] = true
L["Subgroup total"] = true
L["TITLE"] = "Raid Ledger"
L["TOC_NOTES"] = "A ledger for GDKP/gold run raid. Feedback: farmer1992@gmail.com"
L["toggle Auto recording on/off"] = true
L["Top [%d] contributors"] = true
L["Value"] = true

elseif locale == 'deDE' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
L["#Try to convert to item link"] = "#Versuche zu Itemlink zu convertieren"
L["/raidledger"] = "/raidledger"
L["[Unknown]"] = "[Unbekannt]"
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
L["Auto recording loot"] = "Loot automatisch speichern"
L["Auto recording loot: In Raid Only"] = "Loot automatisch speichern: Nur im Raid"
L["Auto recording loot: Off"] = "Loot automatisch speichern: Aus"
L["Auto recording loot: On"] = "Loot automatisch speichern: An"
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
L["Beneficiary"] = "Begünstigster"
L["Cannot find any debit entry in template, please check your template in options"] = "Kann keine Lastposteneinträge in der Vorlage finden. Bitte checke deine Vorlagen in den Optionen"
L["Clear"] = "Neu"
L["Close text export"] = "Text Export schließen"
L["Compensation"] = "Vergütung"
L["Compensation added"] = "Vergütung hinzugefügt"
L["Compensation: DPS"] = "Vergütung: DPS"
L["Compensation: Healer"] = "Vergütung: Heiler"
L["Compensation: Other"] = "Vergütung: Andere"
L["Compensation: Repait Bot"] = "Vergütung: Rep Bot"
L["Compensation: Tank"] = "Vergütung: Tank"
L["convert failed, text can be either item id or item name"] = "Übertragung fehlgeschlagen. Text kann entweder die Item ID oder der Item Name sein."
L["Credit"] = "Guthaben"
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
L["CTRL + Click to apply debit template"] = "STRG + Click um die Lastpostenvorlage anzuwenden"
L["Debit"] = "Lastposten"
L["Debit Template"] = "Lastpostenvorlage"
L["Entry"] = "Eintrag"
L["Expense"] = "Ausgabe"
L["Export as text"] = "Als Text exportieren"
L["Feedback"] = "Feedback"
L["Import from ledger"] = "Aus dem Buch importieren"
L["In Raid Only"] = "Nur im Raid"
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
L["Item added"] = "Item hinzugefügt"
L["Last used"] = "Letztes Mal benutzt"
L["Member credit for subgroup"] = "Teilnehmerguthaben pro Untergruppe"
L["Name of Debit template"] = "Name der Lastpostenvorlage"
L["Net Profit"] = "Netto Gewinn"
L["Other"] = "Andere"
L["Per Member"] = "Pro Teilnehmer"
L["Per Member credit"] = "Teilnehmerguthaben"
L["Raid Ledger"] = "Raid Kassenbuch"
L["Remove all records?"] = "Alle Aufzeichnungen löschen?"
L["Remove ALL SAME record?"] = "Alle gleichen Aufzeichnungen löschen?"
L["Remove this record?"] = "Diese Aufzeichnung löschen?"
L["Rename"] = "Umbenennen"
L["Report"] = "Melden"
L["Revenue"] = "Einnahmen"
L["Right click to choose channel"] = "Rechtsklick um Kanal auszuwählen"
L["Right click to remove record"] = "Rechtsklick um Aufzeichnung zu löschen"
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
L["Shift + item/name to add to record"] = "Shift + Item/Name um zur Aufzeichnung hinzuzufügen"
L["Shift + Right click to remove ALL SAME record"] = "Shift + Rechtsklick um Alle gleichen Aufzeichnungen zu löschen"
L["Special Members"] = "Spezialteilnehmer"
L["Split into"] = "Aufteilen in.."
L["Split into (Current %d)"] = "Aufteilen in (Aktuelle  %d)"
L["Subgroup total"] = "Untergruppe Gesamt"
L["TITLE"] = "Titel"
L["TOC_NOTES"] = "Ein Kassenbuch für GDKP Raids. Feedback: farmer1992@gmail.com"
L["toggle Auto recording on/off"] = "Toggle automatische Aufzeichnung an/aus"
L["Top [%d] contributors"] = "Top [%d] Spender"
L["Value"] = "Wert"

elseif locale == 'esES' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
--[[Translation missing --]]
--[[ L["#Try to convert to item link"] = "#Try to convert to item link"--]] 
--[[Translation missing --]]
--[[ L["/raidledger"] = "/raidledger"--]] 
--[[Translation missing --]]
--[[ L["[Unknown]"] = "[Unknown]"--]] 
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot"] = "Auto recording loot"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: In Raid Only"] = "Auto recording loot: In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: Off"] = "Auto recording loot: Off"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: On"] = "Auto recording loot: On"--]] 
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
--[[Translation missing --]]
--[[ L["Beneficiary"] = "Beneficiary"--]] 
--[[Translation missing --]]
--[[ L["Cannot find any debit entry in template, please check your template in options"] = "Cannot find any debit entry in template, please check your template in options"--]] 
--[[Translation missing --]]
--[[ L["Clear"] = "Clear"--]] 
--[[Translation missing --]]
--[[ L["Close text export"] = "Close text export"--]] 
--[[Translation missing --]]
--[[ L["Compensation"] = "Compensation"--]] 
--[[Translation missing --]]
--[[ L["Compensation added"] = "Compensation added"--]] 
--[[Translation missing --]]
--[[ L["Compensation: DPS"] = "Compensation: DPS"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Healer"] = "Compensation: Healer"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Other"] = "Compensation: Other"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Repait Bot"] = "Compensation: Repait Bot"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Tank"] = "Compensation: Tank"--]] 
--[[Translation missing --]]
--[[ L["convert failed, text can be either item id or item name"] = "convert failed, text can be either item id or item name"--]] 
--[[Translation missing --]]
--[[ L["Credit"] = "Credit"--]] 
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
--[[Translation missing --]]
--[[ L["CTRL + Click to apply debit template"] = "CTRL + Click to apply debit template"--]] 
--[[Translation missing --]]
--[[ L["Debit"] = "Debit"--]] 
--[[Translation missing --]]
--[[ L["Debit Template"] = "Debit Template"--]] 
--[[Translation missing --]]
--[[ L["Entry"] = "Entry"--]] 
--[[Translation missing --]]
--[[ L["Expense"] = "Expense"--]] 
--[[Translation missing --]]
--[[ L["Export as text"] = "Export as text"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Import from ledger"] = "Import from ledger"--]] 
--[[Translation missing --]]
--[[ L["In Raid Only"] = "In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
--[[Translation missing --]]
--[[ L["Item added"] = "Item added"--]] 
--[[Translation missing --]]
--[[ L["Last used"] = "Last used"--]] 
--[[Translation missing --]]
--[[ L["Member credit for subgroup"] = "Member credit for subgroup"--]] 
--[[Translation missing --]]
--[[ L["Name of Debit template"] = "Name of Debit template"--]] 
--[[Translation missing --]]
--[[ L["Net Profit"] = "Net Profit"--]] 
--[[Translation missing --]]
--[[ L["Other"] = "Other"--]] 
--[[Translation missing --]]
--[[ L["Per Member"] = "Per Member"--]] 
--[[Translation missing --]]
--[[ L["Per Member credit"] = "Per Member credit"--]] 
--[[Translation missing --]]
--[[ L["Raid Ledger"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["Remove all records?"] = "Remove all records?"--]] 
--[[Translation missing --]]
--[[ L["Remove ALL SAME record?"] = "Remove ALL SAME record?"--]] 
--[[Translation missing --]]
--[[ L["Remove this record?"] = "Remove this record?"--]] 
--[[Translation missing --]]
--[[ L["Rename"] = "Rename"--]] 
--[[Translation missing --]]
--[[ L["Report"] = "Report"--]] 
--[[Translation missing --]]
--[[ L["Revenue"] = "Revenue"--]] 
--[[Translation missing --]]
--[[ L["Right click to choose channel"] = "Right click to choose channel"--]] 
--[[Translation missing --]]
--[[ L["Right click to remove record"] = "Right click to remove record"--]] 
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
--[[Translation missing --]]
--[[ L["Shift + item/name to add to record"] = "Shift + item/name to add to record"--]] 
--[[Translation missing --]]
--[[ L["Shift + Right click to remove ALL SAME record"] = "Shift + Right click to remove ALL SAME record"--]] 
--[[Translation missing --]]
--[[ L["Special Members"] = "Special Members"--]] 
--[[Translation missing --]]
--[[ L["Split into"] = "Split into"--]] 
--[[Translation missing --]]
--[[ L["Split into (Current %d)"] = "Split into (Current %d)"--]] 
--[[Translation missing --]]
--[[ L["Subgroup total"] = "Subgroup total"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "A ledger for GDKP/gold run raid. Feedback: farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["toggle Auto recording on/off"] = "toggle Auto recording on/off"--]] 
--[[Translation missing --]]
--[[ L["Top [%d] contributors"] = "Top [%d] contributors"--]] 
--[[Translation missing --]]
--[[ L["Value"] = "Value"--]] 

elseif locale == 'esMX' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
--[[Translation missing --]]
--[[ L["#Try to convert to item link"] = "#Try to convert to item link"--]] 
--[[Translation missing --]]
--[[ L["/raidledger"] = "/raidledger"--]] 
--[[Translation missing --]]
--[[ L["[Unknown]"] = "[Unknown]"--]] 
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot"] = "Auto recording loot"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: In Raid Only"] = "Auto recording loot: In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: Off"] = "Auto recording loot: Off"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: On"] = "Auto recording loot: On"--]] 
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
--[[Translation missing --]]
--[[ L["Beneficiary"] = "Beneficiary"--]] 
--[[Translation missing --]]
--[[ L["Cannot find any debit entry in template, please check your template in options"] = "Cannot find any debit entry in template, please check your template in options"--]] 
--[[Translation missing --]]
--[[ L["Clear"] = "Clear"--]] 
--[[Translation missing --]]
--[[ L["Close text export"] = "Close text export"--]] 
--[[Translation missing --]]
--[[ L["Compensation"] = "Compensation"--]] 
--[[Translation missing --]]
--[[ L["Compensation added"] = "Compensation added"--]] 
--[[Translation missing --]]
--[[ L["Compensation: DPS"] = "Compensation: DPS"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Healer"] = "Compensation: Healer"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Other"] = "Compensation: Other"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Repait Bot"] = "Compensation: Repait Bot"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Tank"] = "Compensation: Tank"--]] 
--[[Translation missing --]]
--[[ L["convert failed, text can be either item id or item name"] = "convert failed, text can be either item id or item name"--]] 
--[[Translation missing --]]
--[[ L["Credit"] = "Credit"--]] 
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
--[[Translation missing --]]
--[[ L["CTRL + Click to apply debit template"] = "CTRL + Click to apply debit template"--]] 
--[[Translation missing --]]
--[[ L["Debit"] = "Debit"--]] 
--[[Translation missing --]]
--[[ L["Debit Template"] = "Debit Template"--]] 
--[[Translation missing --]]
--[[ L["Entry"] = "Entry"--]] 
--[[Translation missing --]]
--[[ L["Expense"] = "Expense"--]] 
--[[Translation missing --]]
--[[ L["Export as text"] = "Export as text"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Import from ledger"] = "Import from ledger"--]] 
--[[Translation missing --]]
--[[ L["In Raid Only"] = "In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
--[[Translation missing --]]
--[[ L["Item added"] = "Item added"--]] 
--[[Translation missing --]]
--[[ L["Last used"] = "Last used"--]] 
--[[Translation missing --]]
--[[ L["Member credit for subgroup"] = "Member credit for subgroup"--]] 
--[[Translation missing --]]
--[[ L["Name of Debit template"] = "Name of Debit template"--]] 
--[[Translation missing --]]
--[[ L["Net Profit"] = "Net Profit"--]] 
--[[Translation missing --]]
--[[ L["Other"] = "Other"--]] 
--[[Translation missing --]]
--[[ L["Per Member"] = "Per Member"--]] 
--[[Translation missing --]]
--[[ L["Per Member credit"] = "Per Member credit"--]] 
--[[Translation missing --]]
--[[ L["Raid Ledger"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["Remove all records?"] = "Remove all records?"--]] 
--[[Translation missing --]]
--[[ L["Remove ALL SAME record?"] = "Remove ALL SAME record?"--]] 
--[[Translation missing --]]
--[[ L["Remove this record?"] = "Remove this record?"--]] 
--[[Translation missing --]]
--[[ L["Rename"] = "Rename"--]] 
--[[Translation missing --]]
--[[ L["Report"] = "Report"--]] 
--[[Translation missing --]]
--[[ L["Revenue"] = "Revenue"--]] 
--[[Translation missing --]]
--[[ L["Right click to choose channel"] = "Right click to choose channel"--]] 
--[[Translation missing --]]
--[[ L["Right click to remove record"] = "Right click to remove record"--]] 
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
--[[Translation missing --]]
--[[ L["Shift + item/name to add to record"] = "Shift + item/name to add to record"--]] 
--[[Translation missing --]]
--[[ L["Shift + Right click to remove ALL SAME record"] = "Shift + Right click to remove ALL SAME record"--]] 
--[[Translation missing --]]
--[[ L["Special Members"] = "Special Members"--]] 
--[[Translation missing --]]
--[[ L["Split into"] = "Split into"--]] 
--[[Translation missing --]]
--[[ L["Split into (Current %d)"] = "Split into (Current %d)"--]] 
--[[Translation missing --]]
--[[ L["Subgroup total"] = "Subgroup total"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "A ledger for GDKP/gold run raid. Feedback: farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["toggle Auto recording on/off"] = "toggle Auto recording on/off"--]] 
--[[Translation missing --]]
--[[ L["Top [%d] contributors"] = "Top [%d] contributors"--]] 
--[[Translation missing --]]
--[[ L["Value"] = "Value"--]] 

elseif locale == 'frFR' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
--[[Translation missing --]]
--[[ L["#Try to convert to item link"] = "#Try to convert to item link"--]] 
--[[Translation missing --]]
--[[ L["/raidledger"] = "/raidledger"--]] 
--[[Translation missing --]]
--[[ L["[Unknown]"] = "[Unknown]"--]] 
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot"] = "Auto recording loot"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: In Raid Only"] = "Auto recording loot: In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: Off"] = "Auto recording loot: Off"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: On"] = "Auto recording loot: On"--]] 
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
--[[Translation missing --]]
--[[ L["Beneficiary"] = "Beneficiary"--]] 
--[[Translation missing --]]
--[[ L["Cannot find any debit entry in template, please check your template in options"] = "Cannot find any debit entry in template, please check your template in options"--]] 
--[[Translation missing --]]
--[[ L["Clear"] = "Clear"--]] 
--[[Translation missing --]]
--[[ L["Close text export"] = "Close text export"--]] 
--[[Translation missing --]]
--[[ L["Compensation"] = "Compensation"--]] 
--[[Translation missing --]]
--[[ L["Compensation added"] = "Compensation added"--]] 
--[[Translation missing --]]
--[[ L["Compensation: DPS"] = "Compensation: DPS"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Healer"] = "Compensation: Healer"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Other"] = "Compensation: Other"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Repait Bot"] = "Compensation: Repait Bot"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Tank"] = "Compensation: Tank"--]] 
--[[Translation missing --]]
--[[ L["convert failed, text can be either item id or item name"] = "convert failed, text can be either item id or item name"--]] 
--[[Translation missing --]]
--[[ L["Credit"] = "Credit"--]] 
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
--[[Translation missing --]]
--[[ L["CTRL + Click to apply debit template"] = "CTRL + Click to apply debit template"--]] 
--[[Translation missing --]]
--[[ L["Debit"] = "Debit"--]] 
--[[Translation missing --]]
--[[ L["Debit Template"] = "Debit Template"--]] 
--[[Translation missing --]]
--[[ L["Entry"] = "Entry"--]] 
--[[Translation missing --]]
--[[ L["Expense"] = "Expense"--]] 
--[[Translation missing --]]
--[[ L["Export as text"] = "Export as text"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Import from ledger"] = "Import from ledger"--]] 
--[[Translation missing --]]
--[[ L["In Raid Only"] = "In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
--[[Translation missing --]]
--[[ L["Item added"] = "Item added"--]] 
--[[Translation missing --]]
--[[ L["Last used"] = "Last used"--]] 
--[[Translation missing --]]
--[[ L["Member credit for subgroup"] = "Member credit for subgroup"--]] 
--[[Translation missing --]]
--[[ L["Name of Debit template"] = "Name of Debit template"--]] 
--[[Translation missing --]]
--[[ L["Net Profit"] = "Net Profit"--]] 
--[[Translation missing --]]
--[[ L["Other"] = "Other"--]] 
--[[Translation missing --]]
--[[ L["Per Member"] = "Per Member"--]] 
--[[Translation missing --]]
--[[ L["Per Member credit"] = "Per Member credit"--]] 
--[[Translation missing --]]
--[[ L["Raid Ledger"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["Remove all records?"] = "Remove all records?"--]] 
--[[Translation missing --]]
--[[ L["Remove ALL SAME record?"] = "Remove ALL SAME record?"--]] 
--[[Translation missing --]]
--[[ L["Remove this record?"] = "Remove this record?"--]] 
--[[Translation missing --]]
--[[ L["Rename"] = "Rename"--]] 
--[[Translation missing --]]
--[[ L["Report"] = "Report"--]] 
--[[Translation missing --]]
--[[ L["Revenue"] = "Revenue"--]] 
--[[Translation missing --]]
--[[ L["Right click to choose channel"] = "Right click to choose channel"--]] 
--[[Translation missing --]]
--[[ L["Right click to remove record"] = "Right click to remove record"--]] 
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
--[[Translation missing --]]
--[[ L["Shift + item/name to add to record"] = "Shift + item/name to add to record"--]] 
--[[Translation missing --]]
--[[ L["Shift + Right click to remove ALL SAME record"] = "Shift + Right click to remove ALL SAME record"--]] 
--[[Translation missing --]]
--[[ L["Special Members"] = "Special Members"--]] 
--[[Translation missing --]]
--[[ L["Split into"] = "Split into"--]] 
--[[Translation missing --]]
--[[ L["Split into (Current %d)"] = "Split into (Current %d)"--]] 
--[[Translation missing --]]
--[[ L["Subgroup total"] = "Subgroup total"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "A ledger for GDKP/gold run raid. Feedback: farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["toggle Auto recording on/off"] = "toggle Auto recording on/off"--]] 
--[[Translation missing --]]
--[[ L["Top [%d] contributors"] = "Top [%d] contributors"--]] 
--[[Translation missing --]]
--[[ L["Value"] = "Value"--]] 

elseif locale == 'itIT' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
--[[Translation missing --]]
--[[ L["#Try to convert to item link"] = "#Try to convert to item link"--]] 
--[[Translation missing --]]
--[[ L["/raidledger"] = "/raidledger"--]] 
--[[Translation missing --]]
--[[ L["[Unknown]"] = "[Unknown]"--]] 
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot"] = "Auto recording loot"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: In Raid Only"] = "Auto recording loot: In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: Off"] = "Auto recording loot: Off"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: On"] = "Auto recording loot: On"--]] 
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
--[[Translation missing --]]
--[[ L["Beneficiary"] = "Beneficiary"--]] 
--[[Translation missing --]]
--[[ L["Cannot find any debit entry in template, please check your template in options"] = "Cannot find any debit entry in template, please check your template in options"--]] 
--[[Translation missing --]]
--[[ L["Clear"] = "Clear"--]] 
--[[Translation missing --]]
--[[ L["Close text export"] = "Close text export"--]] 
--[[Translation missing --]]
--[[ L["Compensation"] = "Compensation"--]] 
--[[Translation missing --]]
--[[ L["Compensation added"] = "Compensation added"--]] 
--[[Translation missing --]]
--[[ L["Compensation: DPS"] = "Compensation: DPS"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Healer"] = "Compensation: Healer"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Other"] = "Compensation: Other"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Repait Bot"] = "Compensation: Repait Bot"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Tank"] = "Compensation: Tank"--]] 
--[[Translation missing --]]
--[[ L["convert failed, text can be either item id or item name"] = "convert failed, text can be either item id or item name"--]] 
--[[Translation missing --]]
--[[ L["Credit"] = "Credit"--]] 
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
--[[Translation missing --]]
--[[ L["CTRL + Click to apply debit template"] = "CTRL + Click to apply debit template"--]] 
--[[Translation missing --]]
--[[ L["Debit"] = "Debit"--]] 
--[[Translation missing --]]
--[[ L["Debit Template"] = "Debit Template"--]] 
--[[Translation missing --]]
--[[ L["Entry"] = "Entry"--]] 
--[[Translation missing --]]
--[[ L["Expense"] = "Expense"--]] 
--[[Translation missing --]]
--[[ L["Export as text"] = "Export as text"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Import from ledger"] = "Import from ledger"--]] 
--[[Translation missing --]]
--[[ L["In Raid Only"] = "In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
--[[Translation missing --]]
--[[ L["Item added"] = "Item added"--]] 
--[[Translation missing --]]
--[[ L["Last used"] = "Last used"--]] 
--[[Translation missing --]]
--[[ L["Member credit for subgroup"] = "Member credit for subgroup"--]] 
--[[Translation missing --]]
--[[ L["Name of Debit template"] = "Name of Debit template"--]] 
--[[Translation missing --]]
--[[ L["Net Profit"] = "Net Profit"--]] 
--[[Translation missing --]]
--[[ L["Other"] = "Other"--]] 
--[[Translation missing --]]
--[[ L["Per Member"] = "Per Member"--]] 
--[[Translation missing --]]
--[[ L["Per Member credit"] = "Per Member credit"--]] 
--[[Translation missing --]]
--[[ L["Raid Ledger"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["Remove all records?"] = "Remove all records?"--]] 
--[[Translation missing --]]
--[[ L["Remove ALL SAME record?"] = "Remove ALL SAME record?"--]] 
--[[Translation missing --]]
--[[ L["Remove this record?"] = "Remove this record?"--]] 
--[[Translation missing --]]
--[[ L["Rename"] = "Rename"--]] 
--[[Translation missing --]]
--[[ L["Report"] = "Report"--]] 
--[[Translation missing --]]
--[[ L["Revenue"] = "Revenue"--]] 
--[[Translation missing --]]
--[[ L["Right click to choose channel"] = "Right click to choose channel"--]] 
--[[Translation missing --]]
--[[ L["Right click to remove record"] = "Right click to remove record"--]] 
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
--[[Translation missing --]]
--[[ L["Shift + item/name to add to record"] = "Shift + item/name to add to record"--]] 
--[[Translation missing --]]
--[[ L["Shift + Right click to remove ALL SAME record"] = "Shift + Right click to remove ALL SAME record"--]] 
--[[Translation missing --]]
--[[ L["Special Members"] = "Special Members"--]] 
--[[Translation missing --]]
--[[ L["Split into"] = "Split into"--]] 
--[[Translation missing --]]
--[[ L["Split into (Current %d)"] = "Split into (Current %d)"--]] 
--[[Translation missing --]]
--[[ L["Subgroup total"] = "Subgroup total"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "A ledger for GDKP/gold run raid. Feedback: farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["toggle Auto recording on/off"] = "toggle Auto recording on/off"--]] 
--[[Translation missing --]]
--[[ L["Top [%d] contributors"] = "Top [%d] contributors"--]] 
--[[Translation missing --]]
--[[ L["Value"] = "Value"--]] 

elseif locale == 'koKR' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
L["#Try to convert to item link"] = "#아이템 링크로 변환을 시도합니다."
L["/raidledger"] = "/raidledger"
L["[Unknown]"] = "[알 수 없음]"
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
L["Auto recording loot"] = "전리품 자동 기록"
L["Auto recording loot: In Raid Only"] = "전리품 자동 기록: 공격대에서만"
L["Auto recording loot: Off"] = "전리품 자동 기록: 끔"
L["Auto recording loot: On"] = "전리품 자동 기록: 켬"
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
L["Beneficiary"] = "수익자"
L["Cannot find any debit entry in template, please check your template in options"] = "템플릿에서 지출 항목을 찾을 수 없습니다. 옵션에서 템플릿을 확인하십시오."
L["Clear"] = "지우기"
L["Close text export"] = "문자 내보내기 닫기"
L["Compensation"] = "보상"
L["Compensation added"] = "보상 추가"
L["Compensation: DPS"] = "보상: DPS"
L["Compensation: Healer"] = "보상: 힐러"
L["Compensation: Other"] = "보상: 기타"
L["Compensation: Repait Bot"] = "보상: 로봇 수리"
L["Compensation: Tank"] = "보상: 탱커"
L["convert failed, text can be either item id or item name"] = "변환 실패, 문자는 아이템ID 또는 아이템명 일 수 있습니다."
L["Credit"] = "수입"
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
L["CTRL + Click to apply debit template"] = "CTRL + 클릭 지출 템플릿을 적용하려면 클릭하십시오."
L["Debit"] = "지출"
L["Debit Template"] = "지출 템플릿"
L["Entry"] = "항목"
L["Expense"] = "총지출"
L["Export as text"] = "문자로 내보내기"
L["Feedback"] = "피드백"
L["Import from ledger"] = "장부에서 가져오기"
L["In Raid Only"] = "레이드에서만"
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
L["Item added"] = "추가된 아이템"
L["Last used"] = "마지막 사용됨"
L["Member credit for subgroup"] = "하위 그룹의 회원 수입"
L["Name of Debit template"] = "지출 템플릿의 이름"
L["Net Profit"] = "순이익"
L["Other"] = "기타"
L["Per Member"] = "회원 당"
L["Per Member credit"] = "회원 당 수입"
L["Raid Ledger"] = "공격대 장부"
L["Remove all records?"] = "모든 기록을 삭제 하시겠습니까?"
L["Remove ALL SAME record?"] = "모든 SAME 레코드를 제거하시겠습니까?"
L["Remove this record?"] = "이 기록을 삭제 하시겠습니까?"
L["Rename"] = "이름바꾸기"
L["Report"] = "보고"
L["Revenue"] = "총수입"
L["Right click to choose channel"] = "우클릭으로 채널 선택"
L["Right click to remove record"] = "우클릭으로 기록 제거"
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
L["Shift + item/name to add to record"] = "Shift + 아이템/이름으로 기록에 추가"
L["Shift + Right click to remove ALL SAME record"] = "Shift + 우클릭으로 모든 SAME 레코드 제거"
L["Special Members"] = "특별 회원"
L["Split into"] = "돈을 나눈 사람 수"
L["Split into (Current %d)"] = "돈을 나눈 사람 수 (지금 %d)"
L["Subgroup total"] = "하위 그룹 합계"
L["TITLE"] = "공격대 장부"
L["TOC_NOTES"] = "공격대의 골드 분배 시행에 대한 장부, 피드백: farmer1992@gmail.com"
L["toggle Auto recording on/off"] = "자동 기록 켬/끔 전환"
L["Top [%d] contributors"] = "상위 [%d] 기부"
L["Value"] = "가격"

elseif locale == 'ptBR' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
--[[Translation missing --]]
--[[ L["#Try to convert to item link"] = "#Try to convert to item link"--]] 
--[[Translation missing --]]
--[[ L["/raidledger"] = "/raidledger"--]] 
--[[Translation missing --]]
--[[ L["[Unknown]"] = "[Unknown]"--]] 
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot"] = "Auto recording loot"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: In Raid Only"] = "Auto recording loot: In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: Off"] = "Auto recording loot: Off"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot: On"] = "Auto recording loot: On"--]] 
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
--[[Translation missing --]]
--[[ L["Beneficiary"] = "Beneficiary"--]] 
--[[Translation missing --]]
--[[ L["Cannot find any debit entry in template, please check your template in options"] = "Cannot find any debit entry in template, please check your template in options"--]] 
--[[Translation missing --]]
--[[ L["Clear"] = "Clear"--]] 
--[[Translation missing --]]
--[[ L["Close text export"] = "Close text export"--]] 
--[[Translation missing --]]
--[[ L["Compensation"] = "Compensation"--]] 
--[[Translation missing --]]
--[[ L["Compensation added"] = "Compensation added"--]] 
--[[Translation missing --]]
--[[ L["Compensation: DPS"] = "Compensation: DPS"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Healer"] = "Compensation: Healer"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Other"] = "Compensation: Other"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Repait Bot"] = "Compensation: Repait Bot"--]] 
--[[Translation missing --]]
--[[ L["Compensation: Tank"] = "Compensation: Tank"--]] 
--[[Translation missing --]]
--[[ L["convert failed, text can be either item id or item name"] = "convert failed, text can be either item id or item name"--]] 
--[[Translation missing --]]
--[[ L["Credit"] = "Credit"--]] 
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
--[[Translation missing --]]
--[[ L["CTRL + Click to apply debit template"] = "CTRL + Click to apply debit template"--]] 
--[[Translation missing --]]
--[[ L["Debit"] = "Debit"--]] 
--[[Translation missing --]]
--[[ L["Debit Template"] = "Debit Template"--]] 
--[[Translation missing --]]
--[[ L["Entry"] = "Entry"--]] 
--[[Translation missing --]]
--[[ L["Expense"] = "Expense"--]] 
--[[Translation missing --]]
--[[ L["Export as text"] = "Export as text"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Import from ledger"] = "Import from ledger"--]] 
--[[Translation missing --]]
--[[ L["In Raid Only"] = "In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
--[[Translation missing --]]
--[[ L["Item added"] = "Item added"--]] 
--[[Translation missing --]]
--[[ L["Last used"] = "Last used"--]] 
--[[Translation missing --]]
--[[ L["Member credit for subgroup"] = "Member credit for subgroup"--]] 
--[[Translation missing --]]
--[[ L["Name of Debit template"] = "Name of Debit template"--]] 
--[[Translation missing --]]
--[[ L["Net Profit"] = "Net Profit"--]] 
--[[Translation missing --]]
--[[ L["Other"] = "Other"--]] 
--[[Translation missing --]]
--[[ L["Per Member"] = "Per Member"--]] 
--[[Translation missing --]]
--[[ L["Per Member credit"] = "Per Member credit"--]] 
--[[Translation missing --]]
--[[ L["Raid Ledger"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["Remove all records?"] = "Remove all records?"--]] 
--[[Translation missing --]]
--[[ L["Remove ALL SAME record?"] = "Remove ALL SAME record?"--]] 
--[[Translation missing --]]
--[[ L["Remove this record?"] = "Remove this record?"--]] 
--[[Translation missing --]]
--[[ L["Rename"] = "Rename"--]] 
--[[Translation missing --]]
--[[ L["Report"] = "Report"--]] 
--[[Translation missing --]]
--[[ L["Revenue"] = "Revenue"--]] 
--[[Translation missing --]]
--[[ L["Right click to choose channel"] = "Right click to choose channel"--]] 
--[[Translation missing --]]
--[[ L["Right click to remove record"] = "Right click to remove record"--]] 
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
--[[Translation missing --]]
--[[ L["Shift + item/name to add to record"] = "Shift + item/name to add to record"--]] 
--[[Translation missing --]]
--[[ L["Shift + Right click to remove ALL SAME record"] = "Shift + Right click to remove ALL SAME record"--]] 
--[[Translation missing --]]
--[[ L["Special Members"] = "Special Members"--]] 
--[[Translation missing --]]
--[[ L["Split into"] = "Split into"--]] 
--[[Translation missing --]]
--[[ L["Split into (Current %d)"] = "Split into (Current %d)"--]] 
--[[Translation missing --]]
--[[ L["Subgroup total"] = "Subgroup total"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Raid Ledger"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "A ledger for GDKP/gold run raid. Feedback: farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["toggle Auto recording on/off"] = "toggle Auto recording on/off"--]] 
--[[Translation missing --]]
--[[ L["Top [%d] contributors"] = "Top [%d] contributors"--]] 
--[[Translation missing --]]
--[[ L["Value"] = "Value"--]] 

elseif locale == 'ruRU' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
L["#Try to convert to item link"] = "#Попробуйте преобразовать в ссылку элемента"
L["/raidledger"] = "/raidledger"
L["[Unknown]"] = "[Неизвестно]"
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
--[[Translation missing --]]
--[[ L["Auto recording loot"] = "Auto recording loot"--]] 
L["Auto recording loot: In Raid Only"] = "Автоматическая запись добычи: только в рейде"
L["Auto recording loot: Off"] = "Автоматическая запись добычи: Выкл."
L["Auto recording loot: On"] = "Автоматическая запись добычи: Вкл."
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
L["Beneficiary"] = "Бенефициарий"
--[[Translation missing --]]
--[[ L["Cannot find any debit entry in template, please check your template in options"] = "Cannot find any debit entry in template, please check your template in options"--]] 
L["Clear"] = "Очистить"
L["Close text export"] = "Закрыть экспорт текста"
L["Compensation"] = "Компенсация"
L["Compensation added"] = "Компенсация добавлена"
L["Compensation: DPS"] = "Компенсация: Боец"
L["Compensation: Healer"] = "Компенсация: Лекарь"
L["Compensation: Other"] = "Компенсация: Другое"
L["Compensation: Repait Bot"] = "Компенсации: Ремонтный бот"
L["Compensation: Tank"] = "Компенсация: Танк"
L["convert failed, text can be either item id or item name"] = "преобразование не удалось, текст может быть либо ID элемента или имя элемента"
L["Credit"] = "Кредит"
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
--[[Translation missing --]]
--[[ L["CTRL + Click to apply debit template"] = "CTRL + Click to apply debit template"--]] 
L["Debit"] = "Дебит"
--[[Translation missing --]]
--[[ L["Debit Template"] = "Debit Template"--]] 
L["Entry"] = "Вход"
L["Expense"] = "Расход"
L["Export as text"] = "Экспорт в виде текста"
L["Feedback"] = "Обратная связь"
--[[Translation missing --]]
--[[ L["Import from ledger"] = "Import from ledger"--]] 
--[[Translation missing --]]
--[[ L["In Raid Only"] = "In Raid Only"--]] 
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
L["Item added"] = "Пункт добавлен"
--[[Translation missing --]]
--[[ L["Last used"] = "Last used"--]] 
--[[Translation missing --]]
--[[ L["Member credit for subgroup"] = "Member credit for subgroup"--]] 
--[[Translation missing --]]
--[[ L["Name of Debit template"] = "Name of Debit template"--]] 
L["Net Profit"] = "Чистая прибыль"
L["Other"] = "Другое"
L["Per Member"] = "на одного члена"
--[[Translation missing --]]
--[[ L["Per Member credit"] = "Per Member credit"--]] 
L["Raid Ledger"] = "Рейдовая книга"
L["Remove all records?"] = "Удалить все записи?"
--[[Translation missing --]]
--[[ L["Remove ALL SAME record?"] = "Remove ALL SAME record?"--]] 
L["Remove this record?"] = "Удалить эту запись?"
--[[Translation missing --]]
--[[ L["Rename"] = "Rename"--]] 
L["Report"] = "Жалоба"
L["Revenue"] = "Доход"
--[[Translation missing --]]
--[[ L["Right click to choose channel"] = "Right click to choose channel"--]] 
L["Right click to remove record"] = "Щелкните правой кнопкой мыши, чтобы удалить запись"
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
L["Shift + item/name to add to record"] = "Shift + элемент/имя для добавления в запись"
--[[Translation missing --]]
--[[ L["Shift + Right click to remove ALL SAME record"] = "Shift + Right click to remove ALL SAME record"--]] 
--[[Translation missing --]]
--[[ L["Special Members"] = "Special Members"--]] 
L["Split into"] = "Разделить на"
L["Split into (Current %d)"] = "Разделить на (текущий %d)"
L["Subgroup total"] = "Всего подгрупп"
L["TITLE"] = "Рейдовая книга"
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "A ledger for GDKP/gold run raid. Feedback: farmer1992@gmail.com"--]] 
L["toggle Auto recording on/off"] = "включение/выключение автоматической записи"
L["Top [%d] contributors"] = "Лучшие [%d] участники"
L["Value"] = "Значение"

elseif locale == 'zhCN' then
L["# one item per line, can be item name or item id"] = "# 每行一条, 可以是物品名称或物品ID"
L["#Try to convert to item link"] = "#尝试转换为物品链接"
L["/raidledger"] = "/gtuan"
L["[Unknown]"] = "[未知]"
L["Auto recording blacklist"] = "自动拾取黑名单"
L["Auto recording loot"] = "自动拾取记录"
L["Auto recording loot: In Raid Only"] = "自动拾取记录: 仅团队中"
L["Auto recording loot: Off"] = "自动拾取记录关闭"
L["Auto recording loot: On"] = "自动拾取记录开启"
L["Auto recording quality"] = "自动拾取记录品质"
L["Beneficiary"] = "获取人"
L["Cannot find any debit entry in template, please check your template in options"] = "无法在支出模板中找到任何内容, 请在选项中检查模板内容"
L["Clear"] = "清空"
L["Close text export"] = "关闭文本模式"
L["Compensation"] = "补助"
L["Compensation added"] = "已经添补助"
L["Compensation: DPS"] = "补助: 输出"
L["Compensation: Healer"] = "补助: 治疗"
L["Compensation: Other"] = "补助: 其他"
L["Compensation: Repait Bot"] = "补助: 修理机器人"
L["Compensation: Tank"] = "补助: 坦克"
L["convert failed, text can be either item id or item name"] = "转换失败, 名称可以是物品ID, 物品名称"
L["Credit"] = "收入"
L["CTRL + click for summary mode"] = "CTRL + 点击以简介模式报告"
L["CTRL + Click to apply debit template"] = "CTRL + 点击应用支出模板"
L["Debit"] = "支出"
L["Debit Template"] = "支出模板"
L["Entry"] = "条目"
L["Expense"] = "总支出"
L["Export as text"] = "导出战报"
L["Feedback"] = "反馈"
L["Import from ledger"] = "从账本中提取"
L["In Raid Only"] = "仅团队中"
L["Input only"] = "仅输入"
L["Item added"] = "已添加物品"
L["Last used"] = "上次使用"
L["Member credit for subgroup"] = "小队收入明细"
L["Name of Debit template"] = "支出模板的标题"
L["Net Profit"] = "净收入"
L["Other"] = "其他"
L["Per Member"] = "平均每人"
L["Per Member credit"] = "平均每人收入"
L["Raid Ledger"] = "金团账本"
L["Remove all records?"] = "确定清空所有记录?"
L["Remove ALL SAME record?"] = "删除全部相同记录?"
L["Remove this record?"] = "确定删除这条记录?"
L["Rename"] = "重命名"
L["Report"] = "广播"
L["Revenue"] = "总收入"
L["Right click to choose channel"] = "右键点击选择频道"
L["Right click to remove record"] = "右键点击删除记录"
L["Round down"] = "抹零"
L["Round per member credit down"] = "人均收入自动抹零"
L["Set split into number when team size changes automatically"] = "团队人数变化是否自动设置分账人数"
L["Shift + item/name to add to record"] = "Shift + 人名/物品 自动添加到记录"
L["Shift + Right click to remove ALL SAME record"] = "Shift + 右键点击 删除 全部相同 记录"
L["Special Members"] = "特别成员"
L["Split into"] = "分钱人数"
L["Split into (Current %d)"] = "分钱人数 (当前 %d)"
L["Subgroup total"] = "小队总和"
L["TITLE"] = "Raid Ledger 金团账本"
L["TOC_NOTES"] = "金团账本，帮你在金团中记账 反馈问题 farmer1992@gmail.com"
L["toggle Auto recording on/off"] = "开启/关闭自动拾取记录"
L["Top [%d] contributors"] = "贡献钱 [%d] 的老板"
L["Value"] = "费用"

elseif locale == 'zhTW' then
--[[Translation missing --]]
--[[ L["# one item per line, can be item name or item id"] = "# one item per line, can be item name or item id"--]] 
L["#Try to convert to item link"] = "#嘗試轉換為物品連結"
L["/raidledger"] = "/gtuan"
L["[Unknown]"] = "[未知]"
--[[Translation missing --]]
--[[ L["Auto recording blacklist"] = "Auto recording blacklist"--]] 
L["Auto recording loot"] = "自動拾取紀錄"
L["Auto recording loot: In Raid Only"] = "自動拾取記錄: 僅團隊中"
L["Auto recording loot: Off"] = "自動拾取記錄關閉"
L["Auto recording loot: On"] = "自動拾取記錄開啟"
--[[Translation missing --]]
--[[ L["Auto recording quality"] = "Auto recording quality"--]] 
L["Beneficiary"] = "獲取人"
L["Cannot find any debit entry in template, please check your template in options"] = "無法在支出模板中找到任何內容, 請在選項中檢查模板內容"
L["Clear"] = "清空"
L["Close text export"] = "關閉文字模式"
L["Compensation"] = "補助"
L["Compensation added"] = "已經添補助"
L["Compensation: DPS"] = "補助: 輸出"
L["Compensation: Healer"] = "補助: 治療"
L["Compensation: Other"] = "補助: 其他"
L["Compensation: Repait Bot"] = "補助: 修理機器人"
L["Compensation: Tank"] = "補助: 坦克"
L["convert failed, text can be either item id or item name"] = "轉換失敗, 名稱可以是物品ID或物品名稱"
L["Credit"] = "收入"
--[[Translation missing --]]
--[[ L["CTRL + click for summary mode"] = "CTRL + click for summary mode"--]] 
L["CTRL + Click to apply debit template"] = "CTRL + 點擊應用支出模板"
L["Debit"] = "支出"
L["Debit Template"] = "支出模板"
L["Entry"] = "條目"
L["Expense"] = "總支出"
L["Export as text"] = "導出為文字"
L["Feedback"] = "反饋"
L["Import from ledger"] = "從賬本中提取"
L["In Raid Only"] = "僅團隊中"
--[[Translation missing --]]
--[[ L["Input only"] = "Input only"--]] 
L["Item added"] = "已添加物品"
L["Last used"] = "上次使用"
L["Member credit for subgroup"] = "小隊收入明細"
L["Name of Debit template"] = "支出模板的標題"
L["Net Profit"] = "淨收入"
L["Other"] = "其他"
L["Per Member"] = "平均每人"
L["Per Member credit"] = "平均每人收入"
L["Raid Ledger"] = "金團賬本"
L["Remove all records?"] = "確定清空所有記錄？"
L["Remove ALL SAME record?"] = "刪除全部相同紀錄？"
L["Remove this record?"] = "確定刪除這條記錄？"
L["Rename"] = "重命名"
L["Report"] = "廣播"
L["Revenue"] = "總收入"
L["Right click to choose channel"] = "右鍵點擊選擇頻道"
L["Right click to remove record"] = "右鍵點擊記錄刪除"
--[[Translation missing --]]
--[[ L["Round down"] = "Round down"--]] 
--[[Translation missing --]]
--[[ L["Round per member credit down"] = "Round per member credit down"--]] 
--[[Translation missing --]]
--[[ L["Set split into number when team size changes automatically"] = "Set split into number when team size changes automatically"--]] 
L["Shift + item/name to add to record"] = "Shift + 人名/物品 自動添加到記錄"
L["Shift + Right click to remove ALL SAME record"] = "Shift + 右鍵點擊 刪除全部相同記錄"
L["Special Members"] = "特別成員"
L["Split into"] = "分錢人數"
L["Split into (Current %d)"] = "分錢人數 (當前 %d)"
L["Subgroup total"] = "小隊總和"
L["TITLE"] = "金團賬本"
L["TOC_NOTES"] = "金團賬本，幫你在金團中記賬 反饋問題 farmer1992@gmail.com"
L["toggle Auto recording on/off"] = "開啟/關閉自動拾取記錄"
L["Top [%d] contributors"] = "貢獻錢 [%d] 的老闆"
L["Value"] = "費用"

end
