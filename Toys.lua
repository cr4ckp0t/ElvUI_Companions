-------------------------------------------------------------------------------
-- ElvUI Companions (Toys) Datatext By Crackpotx
-------------------------------------------------------------------------------
local E, _, V, P, G, _ = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local F = CreateFrame("Frame", "ElvUI_CompanionsToyDatatext", E.UIParent, "UIDropDownMenuTemplate")
local L = LibStub("AceLocale-3.0"):GetLocale("ElvUI_Companions", false)

-- local api cache
local C_ToyBox_GetToyFromIndex = C_ToyBox.GetToyFromIndex
local C_ToyBox_GetToyInfo = C_ToyBox.GetToyInfo
local C_ToyBox_GetNumFilteredToys = C_ToyBox.GetNumFilteredToys
local C_ToyBox_SetIsFavorite = C_ToyBox.SetIsFavorite
local GetItemQualityColor = _G["GetItemQualityColor"]
local IsShiftKeyDown = _G["IsShiftKeyDown"]
local ToggleCollectionsJournal = _G["ToggleCollectionsJournal"]
local ToggleDropDownMenu = _G["ToggleDropDownMenu"]
local UIDropDownMenu_AddButton = _G["UIDropDownMenu_AddButton"]
local UseToy = _G["UseToy"]

local wipe = table.wipe
local tinsert = table.insert
local sort = table.sort
local format = string.format
local join = string.join

local displayString = ""
local lastPanel
local menu = {}
local startChar = {
	["AB"] = {
	},
	["CD"] = {
	},
	["EF"] = {
	},
	["GH"] = {
	},
	["IJ"] = {
	},
	["KL"] = {
	},
	["MN"] = {
	},
	["OP"] = {
	},
	["QR"] = {
	},
	["ST"] = {
	},
	["UV"] = {
	},
	["WX"] = {
	},
	["YZ"] = {
	}
}
local toys = {}

local function PairsByKeys(startChar, f)
	local a, i = {}, 0
	for n in pairs(startChar) do tinsert(a, n) end
	sort(a, f)
	local iter = function()
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], startChar[a[i]]
		end
	end
	return iter
end

local function ModifiedClick(self, id, isFavorite)
	if not IsShiftKeyDown() then
		UseToy(id)
	else
		C_ToyBox_SetIsFavorite(id, not isFavorite)
	end
end

local function UpdateToys()
	local numToys = C_ToyBox_GetNumFilteredToys()
	if numToys > 0 then
		wipe(toys)
		for i = 1, numToys do
			local toyId, name, icon, isFavorite, _, quality = C_ToyBox_GetToyInfo(C_ToyBox_GetToyFromIndex(i))
			if name and name ~= "" then
				local red, green, blue, _ = GetItemQualityColor(quality)
				toys[name] = {
					name = name,
					toyId = toyId,
					index = i,
					isFavorite = isFavorite,
					quality = quality,
					text = ("|T%s:14:14:0:0:64:64:4:60:4:60|t  %s%s|r"):format(icon, isFavorite == true and "|cffE7E716" or ("|cff%02x%02x%02x"):format(red * 255, green * 255, blue * 255), name)
				}
			end
		end
	end
end

local function CreateMenu(self, level)
	local numToys = C_ToyBox_GetNumFilteredToys()	
	wipe(menu)
	if numToys == 0 or not toys then
		menu.hasArrow = false
		menu.notCheckable = true
		menu.text = ("|cffff0000%s|r"):format(L["Failed to load toys."])
		UIDropDownMenu_AddButton(menu)
	elseif numToys <= 20 then
		for name, toy in PairsByKeys(toys) do
			menu.hasArrow = false
			menu.notCheckable = true
			menu.text = toy.text
			menu.func = ModifiedClick
			menu.arg1 = toy.toyId
			menu.arg2 = toy.isFavorite
			UIDropDownMenu_AddButton(menu)
		end
	else
		level = level or 1
		if level == 1 then
			for key, v in PairsByKeys(startChar) do
				menu.text = key
				menu.notCheckable = 1
				menu.hasArrow = true
				menu.value = {
					["Level1_Key"] = key
				}
				UIDropDownMenu_AddButton(menu, level)
			end
		elseif level == 2 then
			local Level1_Key = UIDROPDOWNMENU_MENU_VALUE["Level1_Key"]
			for name, toy in PairsByKeys(toys) do
				local firstChar = toy.name:sub(1, 1):upper()
				menu.hasArrow = false
				menu.notCheckable = true
				menu.text = toy.text
				menu.func = ModifiedClick
				menu.arg1 = toy.toyId
				menu.arg2 = toy.isFavorite

				if firstChar >= "A" and firstChar <= "B" and Level1_Key == "AB" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "C" and firstChar <= "D" and Level1_Key == "CD" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "E" and firstChar <= "F" and Level1_Key == "EF" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "G" and firstChar <= "H" and Level1_Key == "GH" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "I" and firstChar <= "J" and Level1_Key == "IJ" then
					UIDropDownMenu_AddButton(menu, level)
				end
			
				if firstChar >= "K" and firstChar <= "L" and Level1_Key == "KL" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "M" and firstChar <= "N" and Level1_Key == "MN" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "O" and firstChar <= "P" and Level1_Key == "OP" then
					UIDropDownMenu_AddButton(menu, level)
				end
			
				if firstChar >= "Q" and firstChar <= "R" and Level1_Key == "QR" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "S" and firstChar <= "T" and Level1_Key == "ST" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "U" and firstChar <= "V" and Level1_Key == "UV" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "W" and firstChar <= "X" and Level1_Key == "WX" then
					UIDropDownMenu_AddButton(menu, level)
				end
				
				if firstChar >= "Y" and firstChar <= "Z" and Level1_Key == "YZ" then
					UIDropDownMenu_AddButton(menu, level)
				end
			end
		end
	end
end

local function UpdateDisplay(self, ...)
	self.text:SetFormattedText(("|cffffffff%s:|r %s"):format(L["Toys"], displayString:format(C_ToyBox_GetNumFilteredToys())))
end

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self.text:SetFormattedText(("|cffffffff%s:|r %s"):format(L["Toys"], displayString:format(C_ToyBox_GetNumFilteredToys())))
	end
	UpdateToys()
end

local interval = 1
local function OnUpdate(self, elapsed)
	self.lastUpdate = self.lastUpdate and self.lastUpdate + elapsed or 0
	if self.lastUpdate >= interval then
		UpdateDisplay(self)
		UpdateToys()
		self.lastUpdate = 0
	end
end

local function OnClick(self, button)
	if button == "LeftButton" then
		ToggleCollectionsJournal()
		CollectionsJournal_SetTab(CollectionsJournal, 3)
	elseif button == "RightButton" then
		DT.tooltip:Hide()
		ToggleDropDownMenu(1, nil, F, self, 0, 0)
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	DT.tooltip:AddLine((L["%sElvUI|r Companions - Toys Datatext"]):format(hexColor), 1, 1, 1)
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(("<%s>"):format(L["Left Click"]), L["Open Toy Box"])
	DT.tooltip:AddDoubleLine(("<%s>"):format(L["Right Click"]), L["Open Toy Menu"])
	DT.tooltip:AddDoubleLine(("<%s>"):format(L["Click a Toy"]), L["Use Toy"])
	DT.tooltip:AddDoubleLine(("<%s>"):format(L["Shift + Click a Toy"]), L["Set as Favorite"])
	DT.tooltip:AddLine(" ")
	if C_ToyBox_GetNumFilteredToys() == 0 then
		DT.tooltip:AddLine(L["You have no toys or need to adjust your filter."])
	else
		DT.tooltip:AddLine((L["You have %d toys."]):format(C_ToyBox_GetNumFilteredToys()), 0, 1, 0)
	end
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", hex, "%d|r")
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

F:RegisterEvent("PLAYER_ENTERING_WORLD")
F:SetScript("OnEvent", function(self, event, ...)
	self.initialize = CreateMenu
	self.displayMode = "MENU"
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

DT:RegisterDatatext(L["Toys"], nil, {"PLAYER_ENTERING_WORLD", "NEW_TOY_ADDED", "TOYS_UPDATED"}, OnEvent, OnUpdate, OnClick, OnEnter, nil, L["Toys"])