-------------------------------------------------------------------------------
-- ElvUI_Companions By Lockslap (US, Bleeding Hollow)
-------------------------------------------------------------------------------
local debug = false
--@debug@
debug = true
--@end-debug@
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI_Companions", "enUS", true, debug)
if not L then return end

L["%sCompanions:|r %s added as favorite one."] = true
L["%sCompanions:|r %s added as favorite three."] = true
L["%sCompanions:|r %s added as favorite two."] = true
L["%sElvUI|r Companions - Companions Datatext"] = true
L["%sElvUI|r Companions - Mounts Datatext"] = true
L["<Alt + Click> a pet to set as favorite 1"] = true
L["<Alt + Click> to reset your favorites."] = true
L["<Click> a mount to summon it."] = true
L["<Click> a pet to summon/dismiss it."] = true
L["<Ctrl + Alt + Click> a pet to set as favorite 3"] = true
L["<Ctrl + Click> a pet to set as favorite 2"] = true
L["<Left Click> to open Pet Journal."] = true
L["<Left Click> to resummon/dismiss pet"] = true
L["<Right Click> to open mount list."] = true
L["<Right Click> to open pet list"] = true
L["<Shift + Click> a mount to toggle as a favorite."] = true
L["<Shift + Left Click> a pet to pick it up"] = true
L["<Shift + Left Click> to open pet journal"] = true
L["<Shift + Left Click> to summon last mount."] = true
L["<Shift + Right Click> to open filter menu"] = true
L["<Shift + Right Click> to summon a random favorite."] = true
L["Companions"] = true
L["Mounts"] = true
L["Random"] = true
