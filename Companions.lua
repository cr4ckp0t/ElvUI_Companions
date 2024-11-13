-------------------------------------------------------------------------------
-- ElvUI Companions Datatext By Crackpotx
-------------------------------------------------------------------------------
local E, _, V, P, G, _ = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local F = CreateFrame("Frame", "ElvUI_CompanionsPetsDatatext", E.UIParent, "UIDropDownMenuTemplate")
local L = E.Libs.ACL:GetLocale("ElvUI_Companions", false)

-- local api cache
local C_PetJournal_GetNumPets = C_PetJournal.GetNumPets
local C_PetJournal_GetPetInfoByIndex = C_PetJournal.GetPetInfoByIndex
local C_PetJournal_GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local C_PetJournal_GetSummonedPetGUID = C_PetJournal.GetSummonedPetGUID
local C_PetJournal_PickupPet = C_PetJournal.PickupPet
local C_PetJournal_SummonPetByGUID = C_PetJournal.SummonPetByGUID
local IsShiftKeyDown = IsShiftKeyDown
local ToggleCollectionsJournal = ToggleCollectionsJournal
local ToggleDropDownMenu = ToggleDropDownMenu
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton

local wipe = table.wipe
local tinsert = table.insert
local sort = table.sort
local format = string.format
local join = string.join

local menu = {}
local startChar = {
	["A"] = {},
	["B"] = {},
	["C"] = {},
	["D"] = {},
	["E"] = {},
	["F"] = {},
	["G"] = {},
	["H"] = {},
	["I"] = {},
	["J"] = {},
	["K"] = {},
	["L"] = {},
	["M"] = {},
	["N"] = {},
	["O"] = {},
	["P"] = {},
	["Q"] = {},
	["R"] = {},
	["S"] = {},
	["T"] = {},
	["U"] = {},
	["V"] = {},
	["W"] = {},
	["X"] = {},
	["Y"] = {},
	["Z"] = {},
}

local displayString = ""
local hexColor = "|cff00ff96"

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

local function OnEvent(self, ...)
	if E.db.companionsdt.pets.id and E.db.companionsdt.pets.text then
		self.text:SetFormattedText(displayString, E.db.companionsdt.pets.text)
	end
	
	local summonedPetID = C_PetJournal_GetSummonedPetGUID()
	if summonedPetID then
		local _, customName, _, _, _, _, _, petName, _, _, _ = C_PetJournal_GetPetInfoByPetID(summonedPetID)
		local creatureName = petName
		if customName then
			creatureName = customName
		end
		if creatureName then
			self.text:SetFormattedText(displayString, creatureName)
			E.db.companionsdt.pets.id = summonedPetID
			E.db.companionsdt.pets.text = creatureName
		end
	else
		self.text:SetText(("|cffffffff%s|r"):format(L["Companions"]))
	end
end

local function ModifiedClick(button, id)
	local speciesID, customName, petlevel, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal_GetPetInfoByPetID(id)
	local creatureName = customName and customName or petName
	if IsShiftKeyDown() then
		C_PetJournal_PickupPet(id);
	elseif IsAltKeyDown() and not IsControlKeyDown() then
		E.db.companionsdt.pets.favOne = id
		DEFAULT_CHAT_FRAME:AddMessage((L["%sElvUI Companions:|r %s added as favorite one."]):format(hexColor, creatureName), 1, 1, 1)
	elseif IsControlKeyDown() and not IsAltKeyDown() then
		E.db.companionsdt.pets.favTwo = id
		DEFAULT_CHAT_FRAME:AddMessage((L["%sElvUI Companions:|r %s added as favorite two."]):format(hexColor, creatureName), 1, 1, 1)
	elseif IsControlKeyDown() and IsAltKeyDown() then
		E.db.companionsdt.pets.favThree = id
		DEFAULT_CHAT_FRAME:AddMessage((L["%sElvUI Companions:|r %s added as favorite three."]):format(hexColor, creatureName), 1, 1, 1)
	else
		C_PetJournal_SummonPetByGUID(id);
	end	
end

local function CreateMenu(self, level)
	menu = wipe(menu)
	local numPets, numOwned = C_PetJournal_GetNumPets()
	local firstChar
	
	if numPets == 0 then
		menu.hasArrow = false
		menu.notCheckable = true
		menu.text = ("|cffff0000%s|r"):format(L["Failed to load companions."])
		UIDropDownMenu_AddButton(menu)
	elseif numOwned <= 20 then
		for i = 1, numPets do
			--local speciesID, customName, level, xp, maxXp, displayID, petName, petIcon, petType, creatureID = C_PetJournal_GetPetInfoByPetID(id)
			local petID, speciesID, isOwned, customName, petlevel, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet = C_PetJournal_GetPetInfoByIndex(i)
			local creatureName = name
			if customName then
				creatureName = customName
			end
			--firstChar = strupper(strsub(creatureName, 1, 1))
			if isOwned then
				menu.hasArrow = false -- Start menu creation
				menu.notCheckable = true
				menu.text = creatureName
				menu.icon = icon
				menu.colorCode = "|cffffffff"
				menu.func = ModifiedClick
				menu.arg1 = petID
			
				local summonedPetID = C_PetJournal_GetSummonedPetGUID();
				if summonedPetID == petID then
					menu.colorCode = "|cff00ff00"
				end
				UIDropDownMenu_AddButton(menu)
			end
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
			
			if E.db.companionsdt.pets.favOne ~= nil then
				local speciesID, customName, petlevel, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal_GetPetInfoByPetID(E.db.companionsdt.pets.favOne)
				local creatureName = petName
				if customName then
					creatureName = customName
				end
				menu.text = format("1. %s", creatureName)
				menu.icon = petIcon
				menu.colorCode = "|cffffffff"
				menu.func = ModifiedClick
				menu.arg1 = E.db.companionsdt.pets.favOne
				menu.hasArrow = nil
				menu.notCheckable = true
				
				local summonedPetID = C_PetJournal_GetSummonedPetGUID();
				if summonedPetID == E.db.companionsdt.pets.favOne then
					menu.colorCode = hexColor
				end
				UIDropDownMenu_AddButton(menu, level)
			end
			
			if E.db.companionsdt.pets.favTwo ~= nil then
				local speciesID, customName, petlevel, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal_GetPetInfoByPetID(E.db.companionsdt.pets.favTwo)
				local creatureName = petName
				if customName then
					creatureName = customName
				end
				menu.text = format("2. %s", creatureName)
				menu.icon = petIcon
				menu.colorCode = "|cffffffff"
				menu.func = ModifiedClick
				menu.arg1 = E.db.companionsdt.pets.favTwo
				menu.hasArrow = nil
				menu.notCheckable = true
				
				local summonedPetID = C_PetJournal_GetSummonedPetGUID();
				if summonedPetID == E.db.companionsdt.pets.favTwo then
					menu.colorCode = hexColor
				end
				UIDropDownMenu_AddButton(menu, level)
			end
			
			if E.db.companionsdt.pets.favThree ~= nil then
				local speciesID, customName, petlevel, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal_GetPetInfoByPetID(E.db.companionsdt.pets.favThree)
				local creatureName = petName
				if customName then
					creatureName = customName
				end
				menu.text = format("3. %s", creatureName)
				menu.icon = petIcon
				menu.colorCode = "|cffffffff"
				menu.func = ModifiedClick
				menu.arg1 = E.db.companionsdt.pets.favThree
				menu.hasArrow = nil
				menu.notCheckable = true
				
				local summonedPetID = C_PetJournal_GetSummonedPetGUID();
				if summonedPetID == E.db.companionsdt.pets.favThree then
					menu.colorCode = hexColor
				end
				UIDropDownMenu_AddButton(menu, level)
			end
		elseif level == 2 then
			local Level1_Key = UIDROPDOWNMENU_MENU_VALUE["Level1_Key"]
			
			for i = 1, numPets do
				local petID, speciesID, isOwned, customName, _, _, _, name, icon, _, _, _, _, _ = C_PetJournal_GetPetInfoByIndex(i)
				if isOwned then
					menu.hasArrow = false; -- Start menu creation
					menu.notCheckable = true;
					menu.text = customName and customName or name
					menu.icon = icon
					menu.colorCode = "|cffffffff"
					menu.func = ModifiedClick
					menu.arg1 = petID
					
					local summonedPetID = C_PetJournal_GetSummonedPetGUID();
					if summonedPetID == petID then
						menu.colorCode = hexColor
					end

					firstChar = strupper(strsub(customName and customName or name, 1, 1))

					if firstChar == "A" and Level1_Key == "A" then
						UIDropDownMenu_AddButton(menu, level)
					end

					if firstChar == "B" and Level1_Key == "B" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "C" and Level1_Key == "C" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "D" and Level1_Key == "D" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "E" and Level1_Key == "E" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "F" and Level1_Key == "F" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "G" and Level1_Key == "G" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "H" and Level1_Key == "H" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "I" and Level1_Key == "I" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "J" and Level1_Key == "J" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "K" and Level1_Key == "K" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "L" and Level1_Key == "L" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "M" and Level1_Key == "M" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "N" and Level1_Key == "N" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "O" and Level1_Key == "O" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "P" and Level1_Key == "P" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "Q" and Level1_Key == "Q" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "R" and Level1_Key == "R" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "S" and Level1_Key == "S" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "T" and Level1_Key == "T" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "U" and Level1_Key == "U" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "V" and Level1_Key == "V" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "W" and Level1_Key == "W" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "X" and Level1_Key == "X" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "Y" and Level1_Key == "Y" then
						UIDropDownMenu_AddButton(menu, level)
					end
					
					if firstChar == "Z" and Level1_Key == "Z" then
						UIDropDownMenu_AddButton(menu, level)
					end
				end
			end
		end
	end
end

local interval = 1
local function OnUpdate(self, elapsed)
	self.lastUpdate = self.lastUpdate and self.lastUpdate + elapsed or 0
	if self.lastUpdate >= interval then
		OnEvent(self)
		self.lastUpdate = 0
	end
end

local function OnClick(self, button)
	DT.tooltip:Hide()

	if button == "LeftButton" then
		if not IsShiftKeyDown() then
			if E.db.companionsdt.pets.id ~= nil then
				C_PetJournal_SummonPetByGUID(E.db.companionsdt.pets.id);
			end
		else
			ToggleCollectionsJournal()
			CollectionsJournal_SetTab(CollectionsJournal, 2)
		end
	elseif button == "RightButton" then
		if not IsShiftKeyDown() then
			ToggleDropDownMenu(1, nil, F, self, 0, 0)
		else
			E.db.companionsdt.pets.favOne = nil
			E.db.companionsdt.pets.favTwo = nil
			E.db.companionsdt.pets.favThree = nil
			DEFAULT_CHAT_FRAME:AddMessage((L["%sElvUI Companions:|r Reset Favorites"]):format(hexColor), 1, 1, 1)
		end
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	local numPets, numOwned = C_PetJournal_GetNumPets(false);
	DT.tooltip:AddLine((L["%sElvUI|r Companions - Companions Datatext"]):format(hexColor), 1, 1, 1)
	DT.tooltip:AddLine(L["<Left Click> to resummon/dismiss pet"])
	DT.tooltip:AddLine(L["<Right Click> to open pet list"])
	DT.tooltip:AddLine(L["<Shift + Left Click> to open pet journal"])
	DT.tooltip:AddLine(L["<Shift + Right Click> to reset your favorites (addon only)"])
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["<Click> a pet to summon/dismiss it."])
	DT.tooltip:AddLine(L["<Shift + Click> a pet to pick it up"])
	DT.tooltip:AddLine(L["<Alt + Click> a pet to set as favorite 1"])
	DT.tooltip:AddLine(L["<Ctrl + Click> a pet to set as favorite 2"])
	DT.tooltip:AddLine(L["<Ctrl + Alt + Click> a pet to set as favorite 3"])
	if numOwned == 0 then
		DT.tooltip:AddLine(L["You have no pets"], 0, 1, 0)
	else
		DT.tooltip:AddLine((L["You have %s pets."]):format(numOwned), 0, 1, 0)
	end
	DT.tooltip:Show()
end

local function ValueColorUpdate(self, hex, r, g, b)
	displayString = join("", hex, "%s|r")
	hexColor = hex
	
	OnEvent(self)
end

F:RegisterEvent("PLAYER_ENTERING_WORLD")
F:SetScript("OnEvent", function(self, event, ...)
	self.initialize = CreateMenu
	self.displayMode = "MENU"
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

DT:RegisterDatatext("Companions", nil, {"PLAYER_ENTERING_WORLD", "COMPANION_UPDATE", "PET_JOURNAL_LIST_UPDATE"}, OnEvent, OnUpdate, OnClick, OnEnter, nil, L["Companions"], nil, ValueColorUpdate)