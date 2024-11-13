-------------------------------------------------------------------------------
-- ElvUI Companions Datatext By Crackpotx
-------------------------------------------------------------------------------
local E, _, V, P, G = unpack(ElvUI) --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule("DataTexts")
local L = E.Libs.ACL:GetLocale("ElvUI_Companions", false)
local EP = E.Libs.EP
local ACH = E.Libs.ACH

P["companionsdt"] = {
    mounts = {
        shorten = true,
        id = nil,
        text = nil,
        favOne = nil,
        favTwo = nil,
        favThree = nil,
    },
    pets = {
        shorten = true,
        id = nil,
		text = nil,
		favOne = nil,
		favTwo = nil,
		favThree = nil,
    },
}


-- local function InjectOptions()
-- 	if not E.Options.args.Crackpotx then
-- 		E.Options.args.Crackpotx = ACH:Group(L["Plugins by |cff0070deCrackpotx|r"])
-- 	end
-- 	if not E.Options.args.Crackpotx.args.thanks then
-- 		E.Options.args.Crackpotx.args.thanks = ACH:Description(L["Thanks for using and supporting my work!  -- |cff0070deCrackpotx|r\n\n|cffff0000If you find any bugs, or have any suggestions for any of my addons, please open a ticket at that particular addon's page on CurseForge."], 1)
-- 	end

-- 	E.Options.args.Crackpotx.args.companionsdt.args.mounts = ACH:Group(L["Mounts Datatext"], nil, nil, nil, function(info) return E.db.companionsdt.mounts[info[#info]] end, function(info, value) E.db.companionsdt.mounts[info[#info]] = value; DT:ForceUpdate_DataText(L["Mounts"]) end)
--     E.Options.args.Crackpotx.args.companionsdt.args.mounts.args.shorten = ACH:Toggle(L["Shorten Names"], L["Shorten the mount names in the datatext.\n\nThis does not affect the mount menu."], 1)
-- end

-- EP:RegisterPlugin(..., InjectOptions)