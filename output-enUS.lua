local L = {}

-- priorities.lua & queries.lua
L["Priorities of username: list"] = function(username,itemlinks)
	-- all translations MUST HAVE "username:" in output
	return "Priorities of " .. username .. ": " .. itemlinks
end

-- queries.lua & loot.lua
L["No priorities found for playerOrItem"] = function(username) return "No priorities found for " .. username end

-- queries.lua
L["itemLink on Prio at userpriolist"] = function(itemlink, userpriolist) return itemlink .. " on Prio at " .. userpriolist end

-- loot.lua
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 0) then
		return "PRIO 0! " .. itemlink .. " is at Priority 1+2+3 for " .. table.concat(userlist, ', ' )
	elseif (prio == 1) then
		return itemlink .. " is at PRIORITY " .. prio .. " for " .. table.concat(userlist, ', ' )
	else
		return itemlink .. " is at priority " .. prio .. " for " .. table.concat(userlist, ', ' )
	end
end
L["itemlink dropped. You have this on priority x."] = function (itemLink, prio) return itemLink .. " dropped. You have this on priority " .. prio .. "." end
L["You will need to /roll when item is up."] = "You will need to /roll when item is up."


-- core.lua
L["Now accepting Prio3 updates by whisper. Send 3 [Itemlinks], wowhead Links or IDs my way, separated by space or comma"] = "Now accepting Prio3 updates by whisper. Send 3 [Itemlinks], wowhead Links or IDs my way, separated by space or comma"
L["Only accepting whispers from players who have not yet set a priority."] = "Only accepting whispers from players who have not yet set a priority."
L["No longer accepting Prio3 updates by whisper."] = "No longer accepting Prio3 updates by whisper."



Prio3.outputLocales["enUS"] = L
