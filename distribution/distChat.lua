function Prio3:startRoll(item)

    if not Prio3.db.profile.enabled then
        return
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
                    itemlink .. ": " .. cancatenedUserPrios[index] .. " (Prio " .. index .. ")", "PARTY",
                    "CHANNEL");
                freeRoll = false
                break
            end
        end

        if (freeRoll) then
            SendChatMessage("Please roll for " .. itemlink .. ": MS > OS", "PARTY",
                "CHANNEL");
        end

    end

end
