function Prio3:startRoll(item)

    if not Prio3.db.profile.enabled then
        return
    end

    local isInRaid = IsInRaid()
    local isInGroup = IsInGroup()
    local messageTarget = "say"

    -- Determin the Target where to Announce: RW, Raid or Group in this order
    if (isInRaid) then
        local isAssistent = UnitIsGroupAssistant("player")
        if (isAssistent) then
            messageTarget = "RAID_WARNING"
        else
            messageTarget = "RAID"
        end
    elseif (isInGroup) then
        messageTarget = "PARTY"
    end

    item = tonumber(strmatch(item, "item:(%d+)"))

    local itemname, itemlink = GetItemInfo(item)

    if (itemname) then
        local cancatenedUserPrios = {}

        for user, prios in pairs(Prio3.db.profile.priorities) do
            for index, prio in ipairs(prios) do
                if (prio == item) then
                    if (cancatenedUserPrios[index] == nil or cancatenedUserPrios[index] == "") then
                        cancatenedUserPrios[index] = "";
                    else
                        cancatenedUserPrios[index] = cancatenedUserPrios[index] .. ", ";
                    end
                    cancatenedUserPrios[index] = cancatenedUserPrios[index] .. user
                end
            end
        end

        local freeRoll = true

        for index, names in ipairs(cancatenedUserPrios) do
            if (string.len(cancatenedUserPrios[index]) > 0) then
                SendChatMessage("Please roll for " ..
                    itemlink .. ": " .. cancatenedUserPrios[index] .. " (Prio " .. index .. ")", messageTarget, "CHANNEL");
                freeRoll = false
                break
            end
        end

        if (freeRoll) then
            SendChatMessage("Please roll for " .. itemlink .. ": MS > OS", messageTarget, "CHANNEL");
        end
    end
end
