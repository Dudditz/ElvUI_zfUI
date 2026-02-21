-- =========================================
-- Helper: Convert UI Map ID → ChallengeModeID
-- =========================================
local function GetChallengeModeIDFromUiMapID(uiMapID)
    local maps = C_ChallengeMode.GetMapTable()
    if not maps then return nil end

    for _, challengeModeID in ipairs(maps) do
        local _, _, _, _, _, mapID = C_ChallengeMode.GetMapUIInfo(challengeModeID)

        if mapID == uiMapID then
            return challengeModeID
        end
    end

    return nil
end


-- =========================================
-- Tooltip Hook
-- =========================================
hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", function(tooltip, resultID)

    if not resultID then return end

    local resultInfo = C_LFGList.GetSearchResultInfo(resultID)
    if not resultInfo then return end

    local activityIDs = resultInfo.activityIDs
    if type(activityIDs) ~= "table" then return end

    local activityID = activityIDs[1]
    if not activityID then return end

    local activityInfo = C_LFGList.GetActivityInfoTable(activityID)
    if not activityInfo then return end

    local uiMapID = activityInfo.mapID
    if not uiMapID then return end

    -- Convert to ChallengeModeID
    local challengeModeID = GetChallengeModeIDFromUiMapID(uiMapID)
    if not challengeModeID then return end

    local best = C_MythicPlus.GetSeasonBestForMap(challengeModeID)
    if not best or not best.level or best.level <= 0 then
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("My Best Timed:", "Not Timed", 1, 0.82, 0, 1, 0, 0)
    tooltip:Show()
    return
    end

    tooltip:AddLine(" ")

    tooltip:AddDoubleLine(
        "My Best Timed:",
        string.format("+%d", best.level),
        1, 0.82, 0,
        0, 1, 0
    )

    tooltip:Show()
end)
