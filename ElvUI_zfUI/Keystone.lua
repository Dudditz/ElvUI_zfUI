local addonName = ...
local frame = CreateFrame("Frame")

local BUTTON_SIZE = 46
local E

-- Check if ElvUI is loaded and grab engine
local function IsElvUILoaded()
    if C_AddOns.IsAddOnLoaded("ElvUI") then
        E = unpack(ElvUI)
        return E
    end
    return false
end

local function ShouldSkinWithElvUI()
    if not E then return false end
    return E.private 
        and E.private.skins 
        and E.private.skins.blizzard 
        and E.private.skins.blizzard.lfg
end

local function CreateActionButton(name, parent, iconTexture, tooltipText)
    local button = CreateFrame("Button", name, parent, "ActionButtonTemplate")
    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
   
    button.icon:SetTexture(iconTexture)
    button.Count:Hide()
    button.HotKey:Hide()
    button.Name:Hide()
	

    -- Tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    return button
end

local function SkinButtonWithElvUI(button)
    if not ShouldSkinWithElvUI() then return end

    local S = E:GetModule("Skins")

    if S then
        S:HandleButton(button)
        S:HandleIcon(button.icon)
    end
	
end

local function CreateButtons()
    if not ChallengesKeystoneFrame then return end
    if ChallengesKeystoneFrame.MythicPlusToolsCreated then return end

    local readyButton = CreateActionButton(
        "MythicPlusToolsReadyButton",
        ChallengesKeystoneFrame,
        "Interface\\RaidFrame\\ReadyCheck-Ready",
        "Start Ready Check"
    )

    readyButton:SetPoint("TOPLEFT", ChallengesKeystoneFrame.StartButton, "TOPRIGHT", 15, 15)

    readyButton:SetScript("OnClick", function()
        if IsInGroup() then
            DoReadyCheck()
        else
            UIErrorsFrame:AddMessage("You are not in a group.", 1, 0, 0)
        end
    end)

    local pullButton = CreateActionButton(
        "MythicPlusToolsPullButton",
        ChallengesKeystoneFrame,
        "Interface\\Icons\\INV_Misc_PocketWatch_01",
        "Start 5s Pull Timer"
    )

    pullButton:SetPoint("LEFT", readyButton, "RIGHT", 6, 0)

    pullButton:SetScript("OnClick", function()
        if IsInGroup() then
            C_PartyInfo.DoCountdown(5)
        else
            UIErrorsFrame:AddMessage("You are not in a group.", 1, 0, 0)
        end
    end)

    -- Apply ElvUI skin if available and enabled
    if IsElvUILoaded() and ShouldSkinWithElvUI() then
        SkinButtonWithElvUI(readyButton)
		readyButton:SetSize(36, 36)
		readyButton:SetPoint("TOPLEFT", ChallengesKeystoneFrame.StartButton, "TOPRIGHT", 15, 5)
        SkinButtonWithElvUI(pullButton)
		pullButton:SetSize(36, 36)
		pullButton:SetPoint("LEFT", readyButton, "RIGHT", 6, 0)
    end

    ChallengesKeystoneFrame.MythicPlusToolsCreated = true
end

frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, name)
    if name == "Blizzard_ChallengesUI" then
        CreateButtons()
    elseif name == "ElvUI" then
        IsElvUILoaded()
    end
end)

if C_AddOns.IsAddOnLoaded("Blizzard_ChallengesUI") then
    CreateButtons()
end

if C_AddOns.IsAddOnLoaded("ElvUI") then
    IsElvUILoaded()
end




--C_AddOns.IsAddOnLoaded