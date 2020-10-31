local L = {}


-- priorities.lua & queries.lua
L["Priorities of username: list"] = function(username,itemlinks) return "Prioritäten für " .. username .. ": " .. itemlinks end

-- queries.lua & loot.lua
L["No priorities found for playerOrItem"] = function(username) return "Keine Prioritäten gefunden für " .. username end

-- queries.lua
L["itemLink on Prio at userpriolist"] = function(itemlink, userpriolist) return itemlink .. " auf Prio bei " .. userpriolist end

-- loot.lua
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 1) then
		return itemlink .. " ist gesetzt als PRIORITÄT " .. prio .. " für " .. table.concat(userlist, ', ' )
	else
		return itemlink .. " ist gesetzt als Priorität " .. prio .. " für " .. table.concat(userlist, ', ' )
	end
end
L["itemlink dropped. You have this on priority x."] = function (itemlink, prio) return itemlink .. " ist gedroppt. Du hast das auf Priorät " .. prio .. "." end
L["You will need to /roll when item is up."] = "Du wirst darum /würfeln müssen wenn das Item verteilt wird."



Prio3.outputLocales["deDE"] = L