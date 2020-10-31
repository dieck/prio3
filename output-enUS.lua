local L = {}

-- priorities.lua & queries.lua
L["Priorities of username: list"] = function(username,itemlinks) return "Priorities of " .. username .. ": " .. itemlinks end

-- queries.lua & loot.lua
L["No priorities found for playerOrItem"] = function(username) return "No priorities found for " .. username end

-- queries.lua
L["itemLink on Prio at userpriolist"] = function(itemlink, userpriolist) return itemlink .. " on Prio at " .. userpriolist end

-- loot.lua
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 1) then
		return itemlink .. " is at PRIORITY " .. prio .. " for " .. table.concat(userlist, ', ' )
	else
		return itemlink .. " is at priority " .. prio .. " for " .. table.concat(userlist, ', ' )
	end
end
L["itemlink dropped. You have this on priority x."] = function (itemLink, prio) return itemLink .. " dropped. You have this on priority " .. prio .. "." end
L["You will need to /roll when item is up."] = "You will need to /roll when item is up."


Prio3.outputLocales["enUS"] = L
