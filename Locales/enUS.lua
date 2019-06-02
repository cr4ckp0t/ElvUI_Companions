-------------------------------------------------------------------------------
-- ElvUI_Companions By Crackpotx
-------------------------------------------------------------------------------
local debug = false
--@debug@
debug = true
--@end-debug@
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI_Companions", "enUS", true, debug)
if not L then return end

L["%sElvUI Companions:|r %s added as favorite one."] = true
L["%sElvUI Companions:|r %s added as favorite three."] = true
L["%sElvUI Companions:|r %s added as favorite two."] = true
L["%sElvUI Companions:|r Reset Favorites"] = true
L["%sElvUI|r Companions - Companions Datatext"] = true
L["%sElvUI|r Companions - Mounts Datatext"] = true
L["%sElvUI|r Companions - Toys Datatext"] = true
L["<Alt + Click> a pet to set as favorite 1"] = true
L["<Click> a mount to summon it."] = true
L["<Click> a pet to summon/dismiss it."] = true
L["<Ctrl + Alt + Click> a pet to set as favorite 3"] = true
L["<Ctrl + Click> a pet to set as favorite 2"] = true
L["<Left Click> to open Pet Journal."] = true
L["<Left Click> to resummon/dismiss pet"] = true
L["<Right Click> to open mount list."] = true
L["<Right Click> to open pet list"] = true
L["<Shift + Click> a mount to toggle as a favorite."] = true
L["<Shift + Click> a pet to pick it up"] = true
L["<Shift + Left Click> to open pet journal"] = true
L["<Shift + Left Click> to summon last mount."] = true
L["<Shift + Right Click> to reset your favorites (addon only)"] = true
L["<Shift + Right Click> to summon a random favorite."] = true
L["Click a Toy"] = true
L["Companions"] = true
L["Failed to load companions."] = true
L["Failed to load mounts."] = true
L["Failed to load toys."] = true
L["Left Click"] = true
L["Mounts"] = true
L["Open Toy Box"] = true
L["Open Toy Menu"] = true
L["Random"] = true
L["Right Click"] = true
L["Set as Favorite"] = true
L["Shift + Click a Toy"] = true
L["Toys"] = true
L["Use Toy"] = true
L["You have %d mounts."] = true
L["You have %d toys."] = true
L["You have %s pets."] = true
L["You have no mounts."] = true
L["You have no pets"] = true
L["You have no toys or need to adjust your filter."] = true
