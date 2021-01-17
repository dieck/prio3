local L = {}


-- priorities.lua & queries.lua
L["Priorities of username: list"] = function(username,itemlinks) return
	-- all translations MUST HAVE "username:" in output
	"Prioritäten für " .. username .. ": " .. itemlinks
end

-- queries.lua & loot.lua
L["No priorities found for playerOrItem"] = function(username) return "Keine Prioritäten gefunden für " .. username end

-- queries.lua
L["itemLink on Prio at userpriolist"] = function(itemlink, userpriolist) return itemlink .. " auf Prio bei " .. userpriolist end

-- loot.lua
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 0) then
		return "PRIO 0! " .. itemlink .. " ist gesetzt als Priorität 1+2+3 für " .. table.concat(userlist, ', ' )
	elseif (prio == 1) then
		return itemlink .. " ist gesetzt als PRIORITÄT " .. prio .. " für " .. table.concat(userlist, ', ' )
	else
		return itemlink .. " ist gesetzt als Priorität " .. prio .. " für " .. table.concat(userlist, ', ' )
	end
end
L["itemlink dropped. You have this on priority x."] = function (itemlink, prio) return itemlink .. " ist gedroppt. Du hast das auf Priorät " .. prio .. "." end
L["You will need to /roll when item is up."] = "Du wirst darum /würfeln müssen wenn das Item verteilt wird."

-- core.lua
L["Now accepting Prio3 updates by whisper. Send 3 [Itemlinks], wowhead Links or IDs my way, separated by space or comma"] = "Prio3 nimmt jetzt Prioritäten geflüstert an. Sendet 3 [Itemlinks], wowhead Links oder einfache IDs zu mir, mit Leerzeichen oder Komma getrennt."
L["Only accepting whispers from players who have not yet set a priority."] = "Es werden nur Prioritäten angenommen von Spielern die noch keine gesetzt haben."
L["No longer accepting Prio3 updates by whisper."] = "Es werden keine keine geflüsterten Prioritäten mehr angenommen."


Prio3.outputLocales["deDE"] = L