-------------------------------------------------------------------------------
-- ElvUI Companions (Mounts) Datatext By Crackpotx
-------------------------------------------------------------------------------
local E, _, V, P, G, _ = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local F = CreateFrame("Frame", "ElvUI_CompanionsMountsDatatext", E.UIParent, "UIDropDownMenuTemplate")
local L = LibStub("AceLocale-3.0"):GetLocale("ElvUI_Companions", false)

-- local api cache
local C_MountJournal_GetMountInfoByID = C_MountJournal.GetMountInfoByID
local C_MountJournal_GetNumMounts = C_MountJournal.GetNumMounts
local C_MountJournal_GetIsFavorite = C_MountJournal.GetIsFavorite
local C_MountJournal_SetIsFavorite = C_MountJournal.SetIsFavorite
local C_MountJournal_SummonByID = C_MountJournal.SummonByID
local CreateFrame = _G["CreateFrame"]
local GetNumCompanions = _G["GetNumCompanions"]
local IsShiftKeyDown = _G["IsShiftKeyDown"]
local ToggleCollectionsJournal = _G["ToggleCollectionsJournal"]
local UIDropDownMenu_AddButton = _G["UIDropDownMenu_AddButton"]

local wipe = table.wipe
local tinsert = table.insert
local sort = table.sort
local format = string.format
local join = string.join

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

local displayString = ""
local lastPanel

local db, defaults = {}, {
	char = {
		id = nil,
		text = nil,
		favOne = nil,
		favTwo = nil,
		favThree = nil,
	},
}

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

local function GetCurrentMount()
	local numMounts = C_MountJournal_GetNumMounts()
	if numMounts == 0 then return false, false end
	for i = 1, numMounts do
		local name, _, _, active = C_MountJournal_GetMountInfoByID(i)
		if active == true then
			return i, name
		end
	end
	return false, false
end

local function LoadMounts()
	local numMounts, mounts = C_MountJournal_GetNumMounts(), {}

	if numMounts == 0 then
		return false
	else
		for i = 1, numMounts do
			local name, _, icon, active, isUsable, _, isFavorite, _, _, _, isCollected = C_MountJournal_GetMountInfoByID(i)
			if isUsable and isCollected then
				mounts[name] = {
					name = name,
					id = i,
					icon = icon,
					active = active,
					isUsable = isUsable,
					isFavorite = isFavorite,
					isCollected = isCollected,
				}
			end
		end

		return mounts
	end
end

local function UpdateDisplay(self, ...)
	if db.id and db.text then
		self.text:SetFormattedText(displayString, db.text)
	end
	
	local curMount, name = GetCurrentMount()
	if curMount and name then
		self.text:SetFormattedText(displayString, name)
		db.id = curMount
		db.text = name
	else
		self.text:SetText(("|cffffffff%s|r"):format(L["Mounts"]))
	end
end

local function ModifiedClick(button, id)
	if not IsShiftKeyDown() then
		C_MountJournal_SummonByID(id)
	else
		C_MountJournal_SetIsFavorite(id, not C_MountJournal_GetIsFavorite(id))
	end
end

local function CreateMenu(self, level)
	local numMounts = C_MountJournal_GetNumMounts()
	menu = wipe(menu)

	-- we must load them beforehand to sort them
	local mounts = LoadMounts()

	if numMounts == 0 or mounts == false then
		menu.hasArrow = false
		menu.notCheckable = true
		menu.text = ("|cffff0000%s|r"):format(L["Failed to load mounts."])
		UIDropDownMenu_AddButton(menu)
	elseif numMounts <= 20 then
		-- don't need to break them up by first letter when < 20
		for name, mount in PairsByKeys(mounts) do
			menu.hasArrow = false
			menu.notCheckable = true
			menu.text = mount.name .. "     "
			menu.icon = mount.icon
			menu.colorCode = mount.active == true and hexColor or mount.isFavorite == true and "|cffE7E716" or "|cffffffff"
			menu.func = ModifiedClick
			menu.arg1 = mount.id
			UIDropDownMenu_AddButton(menu)
		end
	else
		level = level or 1
		
		if level == 1 then
			for key, value in PairsByKeys(startChar) do
				menu.text = key
				menu.notCheckable = true
				menu.hasArrow = true
				menu.value = {["Level1_Key"] = key}
				UIDropDownMenu_AddButton(menu, level)
			end
			
			menu.text = L["Random"]
			menu.notCheckable = true
			menu.hasArrow = false
			menu.colorCode = hexColor
			menu.func = function() C_MountJournal_SummonByID(0) end
			UIDropDownMenu_AddButton(menu, level)

		elseif level == 2 then
			local Level1_Key = UIDROPDOWNMENU_MENU_VALUE["Level1_Key"]
			for name, mount in PairsByKeys(mounts) do
				if mount.isUsable and mount.isCollected then
					local firstChar = mount.name:sub(1, 1):upper()
					menu.text = mount.name .. "     "
					menu.icon = mount.icon
					menu.colorCode = mount.active == true and hexColor or mount.isFavorite == true and "|cffE7E716" or "|cffffffff"
					menu.func = ModifiedClick
					menu.arg1 = mount.id
					menu.hasArrow = false
					menu.notCheckable = true
					
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
end

local interval = 1
local function OnUpdate(self, elapsed)
	--if not self.lastUpdate then self.lastUpdate = 0 end
	self.lastUpdate = self.lastUpdate and self.lastUpdate + elapsed or 0
	if self.lastUpdate >= interval then
		UpdateDisplay(self)
		self.lastUpdate = 0
	end
end

local function OnClick(self, button)
	DT.tooltip:Hide()
	if button == "RightButton" then
		if IsShiftKeyDown() then
			C_MountJournal_SummonByID(0)
		else
			CreateMenu()
			ToggleDropDownMenu(1, nil, F, self, 0, 0)
		end
	elseif button == "LeftButton" then
		if IsShiftKeyDown() then
			if db.id ~= nil then
				C_MountJournal_SummonByID(db.id)
			end
		else
			ToggleCollectionsJournal()
			CollectionsJournal_SetTab(CollectionsJournal, 1)
		end
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	DT.tooltip:AddLine((L["%sElvUI|r Companions - Mounts Datatext"]):format(hexColor), 1, 1, 1)
	DT.tooltip:AddLine(L["<Left Click> to open Pet Journal."])
	DT.tooltip:AddLine(L["<Right Click> to open mount list."])
	DT.tooltip:AddLine(L["<Shift + Left Click> to summon last mount."])
	DT.tooltip:AddLine(L["<Shift + Right Click> to summon a random favorite."])
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["<Click> a mount to summon it."])
	DT.tooltip:AddLine(L["<Shift + Click> a mount to toggle as a favorite."])
	if GetNumCompanions("MOUNT") == 0 then
		DT.tooltip:AddLine(L["You have no mounts."], 0, 1, 0)
	else
		DT.tooltip:AddLine((L["You have %d mounts."]):format(GetNumCompanions("MOUNT")), 0, 1, 0)
	end
	DT.tooltip:Show()	
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", hex, "%s|r")
	hexColor = hex
	if lastPanel ~= nil then OnEvent(lastPanel) end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

F:RegisterEvent("PLAYER_ENTERING_WORLD")
F:SetScript("OnEvent", function(self, event, ...)
	self.db = LibStub("AceDB-3.0"):New("MountsDB", defaults)
	db = self.db.char
	self.initialize = CreateMenu
	self.displayMode = "MENU"
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

DT:RegisterDatatext(L["Mounts"], {"PLAYER_ENTERING_WORLD", "COMPANION_UPDATE", "PET_JOURNAL_LIST_UPDATE"}, UpdateDisplay, OnUpdate, OnClick, OnEnter)