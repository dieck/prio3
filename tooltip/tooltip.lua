local WHITE_TEXT = "|cffffffff%s|r"
local TooltipCache = {}

GameTooltip:HookScript("OnHide", function(self)
end)

GameTooltip:HookScript("OnTooltipSetItem", function(self)
    if self:IsForbidden() then return end

    local _, item = self:GetItem()

    if not item then return end

    if not TooltipCache[item] then
        TooltipCache[item] = tonumber(strmatch(item, "item:(%d+)"))
    end

    item = TooltipCache[item]

    if item then
        if (Prio3.db.profile.debug) then
            self:AddDoubleLine("Item ID (Prio3 Debug)", format(WHITE_TEXT, item))
        end

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

        for index, names in ipairs(cancatenedUserPrios) do
            if (string.len(cancatenedUserPrios[index]) > 0) then
                self:AddDoubleLine("Prio " .. index, format(WHITE_TEXT, names))
            end
        end
    end
end)
