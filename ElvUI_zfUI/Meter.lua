local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local time, max, strjoin = time, max, strjoin
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local UnitGUID = UnitGUID

local lastSegment, petGUID = 0
--local timeStamp, combatTime, DMGTotal, lastDMGAmount = 0, 0, 0, 0
local displayString = ''


local function Reset()
	
	C_DamageMeter.ResetAllCombatSessions()
end

local function Toggle()

	if DamageMeter then 
	if DamageMeter:IsShown()
	then 
	DamageMeter:Hide() else DamageMeter:Show() 
	end 
	end
end

local function OnEvent(panel)
	panel.text:SetFormattedText(displayString, L["Meter"])
end

local function OnEnter()
	DT.tooltip:ClearLines()
	DT.tooltip:SetText(L["Damage Meter:"])
	DT.tooltip:AddLine(' ')
	DT.tooltip:AddLine(' ')
	DT.tooltip:AddLine(L["|cffFFFFFFLeft Click:|r Toggle Damage Meter"])
	DT.tooltip:AddLine(L["|cffFFFFFFRight Click:|r Reset Damage Meter"])
	DT.tooltip:Show()
end	

local function OnClick(panel, button)
 if button == 'LeftButton' then
    Toggle() 
	else
	Reset()
	end
       
end

local function ApplySettings(_, hex)
	displayString = strjoin('', hex, '%s|r')
end

DT:RegisterDatatext('Meter', nil, nil,  OnEvent, nil, OnClick, OnEnter, nil, L["Meter"], nil, ApplySettings)
