-------------------------------------------------------------------------------
-- ElvUI Companions Datatext By Lockslap
-------------------------------------------------------------------------------
local E, _, V, P, G, _ = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local F = CreateFrame("frame")
local L = LibStub("AceLocale-3.0"):GetLocale("ElvUI_Companions", false)

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
local hexColor = "|cff00ff96"

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

local function UpdateDisplay(self, ...)
	if db.id and db.text then
		self.text:SetFormattedText(displayString, db.text)
	end
	
	local summonedPetID = C_PetJournal.GetSummonedPetGUID()
	if summonedPetID then
		local _, customName, _, _, _, _, _, petName, _, _, _ = C_PetJournal.GetPetInfoByPetID(summonedPetID)
		local creatureName = petName
		if customName then
			creatureName = customName
		end
		if creatureName then
			self.text:SetFormattedText(displayString, creatureName)
			db.id = summonedPetID
			db.text = creatureName
		end
	else
		self.text:SetText(("|cffffffff%s|r"):format(L["Companions"]))
	end
end

local function ModifiedClick(button, id)
	local speciesID, customName, petlevel, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(id)
	local creatureName = petName
	if customName then
		creatureName = customName
	end
	
	if IsShiftKeyDown() then
		C_PetJournal.PickupPet(Id);
	elseif IsAltKeyDown() and not IsControlKeyDown() then
		db.favOne = id
		DEFAULT_CHAT_FRAME:AddMessage((L["%sCompanions:|r %s added as favorite one."]):format(hexColor, creatureName), 1, 1, 1)
	elseif IsControlKeyDown() and not IsAltKeyDown() then
		db.favTwo = id
		DEFAULT_CHAT_FRAME:AddMessage((L["%sCompanions:|r %s added as favorite two."]):format(hexColor, creatureName), 1, 1, 1)
	elseif IsControlKeyDown() and IsAltKeyDown() then
		db.favThree = id
		DEFAULT_CHAT_FRAME:AddMessage((L["%sCompanions:|r %s added as favorite three."]):format(hexColor, creatureName), 1, 1, 1)
	else
		C_PetJournal.SummonPetByGUID(id);
	end	
end

local function CreateMenu(self, level)
	menu = wipe(menu)
	local numPets, numOwned = C_PetJournal.GetNumPets()
	local firstChar
	
	if numPets <= 20 then
		for i = 1, numPets do
			--local speciesID, customName, level, xp, maxXp, displayID, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(id)
			local petID, speciesID, isOwned, customName, petlevel, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet = C_PetJournal.GetPetInfoByIndex(i)
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
			
				local summonedPetID = C_PetJournal.GetSummonedPetGUID();
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
			
			if db.favOne ~= nil then
				local speciesID, customName, petlevel, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(db.favOne)
				local creatureName = petName
				if customName then
					creatureName = customName
				end
				menu.text = format("1. %s", creatureName)
				menu.icon = petIcon
				menu.colorCode = "|cffffffff"
				menu.func = ModifiedClick
				menu.arg1 = db.favOne
				menu.hasArrow = nil
				menu.notCheckable = true
				
				local summonedPetID = C_PetJournal.GetSummonedPetGUID();
				if summonedPetID == db.favOne then
					menu.colorCode = hexColor
				end
				UIDropDownMenu_AddButton(menu, level)
			end
			
			if db.favTwo ~= nil then
				local speciesID, customName, petlevel, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(db.favTwo)
				local creatureName = petName
				if customName then
					creatureName = customName
				end
				menu.text = format("2. %s", creatureName)
				menu.icon = petIcon
				menu.colorCode = "|cffffffff"
				menu.func = ModifiedClick
				menu.arg1 = db.favTwo
				menu.hasArrow = nil
				menu.notCheckable = true
				
				local summonedPetID = C_PetJournal.GetSummonedPetGUID();
				if summonedPetID == db.favTwo then
					menu.colorCode = hexColor
				end
				UIDropDownMenu_AddButton(menu, level)
			end
			
			if db.favThree ~= nil then
				local speciesID, customName, petlevel, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(db.favThree)
				local creatureName = petName
				if customName then
					creatureName = customName
				end
				menu.text = format("3. %s", creatureName)
				menu.icon = petIcon
				menu.colorCode = "|cffffffff"
				menu.func = ModifiedClick
				menu.arg1 = db.favThree
				menu.hasArrow = nil
				menu.notCheckable = true
				
				local summonedPetID = C_PetJournal.GetSummonedPetGUID();
				if summonedPetID == db.favThree then
					menu.colorCode = hexColor
				end
				UIDropDownMenu_AddButton(menu, level)
			end
		elseif level == 2 then
			local Level1_Key = UIDROPDOWNMENU_MENU_VALUE["Level1_Key"]
			
			for i = 1, numPets do
				local petID, speciesID, isOwned, customName, petlevel, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet = C_PetJournal.GetPetInfoByIndex(i)
				local creatureName = name
				if customName then
					creatureName = customName
				end
				firstChar = strupper(strsub(creatureName, 1, 1))
				if isOwned then
					menu.hasArrow = false; -- Start menu creation
					menu.notCheckable = true;
					menu.text = creatureName
					menu.icon = icon
					menu.colorCode = "|cffffffff"
					menu.func = ModifiedClick
					menu.arg1 = petID
					
					local summonedPetID = C_PetJournal.GetSummonedPetGUID();
					if summonedPetID == petID then
						menu.colorCode = hexColor
					end
					
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
	self.lastUpdate = self.lastUpdate and self.lastUpdate + elapsed or 0
	if self.lastUpdate >= interval then
		UpdateDisplay(self)
		self.lastUpdate = 0
	end
end

local function OnClick(self, button)
	DT.tooltip:Hide()

	if (button == 'RightButton' and not IsShiftKeyDown()) then
		ToggleDropDownMenu(1, nil, F, self, 0, 0)
	end
	if (IsShiftKeyDown() and button == 'LeftButton') then	
		ToggleCollectionsJournal()
		CollectionsJournal_SetTab(CollectionsJournal, 2)
	end
	if (button == 'LeftButton' and not IsShiftKeyDown()) then	
		if db.id ~= nil then
			C_PetJournal.SummonPetByGUID(db.id);
		end
	end	
	if (IsShiftKeyDown() and button == 'RightButton') then
		if IsAddOnLoaded("Blizzard_PetJournal") then
			ToggleDropDownMenu(1, nil, PetJournalFilterDropDown, self, 0, 0)
		else
			local loaded, reason = LoadAddOn("Blizzard_PetJournal")
			ToggleDropDownMenu(1, nil, PetJournalFilterDropDown, self, 0, 0)
		end
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	local numPets, numOwned = C_PetJournal.GetNumPets(false);
	DT.tooltip:AddLine((L["%sElvUI|r Companions - Companions Datatext"]):format(hexColor), 1, 1, 1)
	DT.tooltip:AddLine(L["<Left Click> to resummon/dismiss pet"])
	DT.tooltip:AddLine(L["<Right Click> to open pet list"])
	DT.tooltip:AddLine(L["<Shift + Left Click> to open pet journal"])
	DT.tooltip:AddLine(L["<Shift + Right Click> to open filter menu"])
	DT.tooltip:AddLine(L["<Alt + Click> to reset your favorites."])
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["<Click> a pet to summon/dismiss it."])
	DT.tooltip:AddLine(L["<Shift + Left Click> a pet to pick it up"])
	DT.tooltip:AddLine(L["<Alt + Click> a pet to set as favorite 1"])
	DT.tooltip:AddLine(L["<Ctrl + Click> a pet to set as favorite 2"])
	DT.tooltip:AddLine(L["<Ctrl + Alt + Click> a pet to set as favorite 3"])
	if numOwned == 0 then
		DT.tooltip:AddLine("|cffff0000You have no pets|r")
	else
		DT.tooltip:AddLine(format("|cff00ff00You have %s pets|r", numOwned))
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
	self.db = LibStub("AceDB-3.0"):New("CompanionsDB", defaults)
	db = self.db.char
	self.initialize = CreateMenu
	self.displayMode = "MENU"
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

DT:RegisterDatatext(L["Companions"], {"PLAYER_ENTERING_WORLD", "COMPANION_UPDATE", "PET_JOURNAL_LIST_UPDATE"}, UpdateDisplay, OnUpdate, OnClick, OnEnter)