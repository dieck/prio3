local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "enUS", true)

if L then

-- prioOptionsTable
L["Enabled"] = "Enabled"
L["Enables / disables the addon"] = "Enables / disables the addon"
L["Announce No Priority"] = "Announce No Priority"
L["Announce to Raid"] = "Announce to Raid"
L["Enables / disables the addon"] = "Enables / disables the addon"
L["Announces Loot Priority list to raid chat"] = "Announces Loot Priority list to raid chat"
L["Whisper to Char"] = "Whisper to Char"
L["Announces Loot Priority list to char by whisper"] = "Announces Loot Priority list to char by whisper"
L["Announces if there is no priority on an item. Be careful: Will trigger on all mobs, not only bosses..."] = "Announces if there is no priority on an item. Be careful: Will trigger on all mobs, not only bosses..."
L["Mute (sec)"] = "Mute (sec)"
L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."] = "Ignores loot encountered a second time for this amount of seconds. 0 to turn off."
L["Import String"] = "Import String"
L["Please note that current Prio settings WILL BE OVERWRITTEN"] = "Please note that current Prio settings WILL BE OVERWRITTEN"
L["Enter new exported string here to configure Prio3 loot list"] = "Enter new exported string here to configure Prio3 loot list"
L["Whisper imports"] = "Whisper imports"
L["Whisper imported items to player"] = "Whisper imported items to player"
L["Open prio table after import"] = "Open prio table after import"
L["Show prio table"] = "Show prio table"
L["Debug"] = "Debug"
L["Enters Debug mode. Addon will have advanced output, and work outside of Raid"] = "Enters Debug mode. Addon will have advanced output, and work outside of Raid"
L["Please /roll now!"] = "Please /roll now!"
L["itemlink dropped. You have this on priority x."] = function (itemLink, prio) return itemLink .. " dropped. You have this on priority " .. prio .. "." end
L["Priorities of username: list"] = function(username,itemLinks) return "Priorities of " .. username .. ": " .. itemLinks end

L["Query own priority"] = "Query own priority"
L["Allows to query own priority. Whisper prio."] = "Allows to query own priority. Whisper prio."
L["Query raid priorities"] = "Query raid priorities"
L["Allows to query priorities of all raid members. Whisper prio CHARNAME."] = "Allows to query priorities of all raid members. Whisper prio CHARNAME."
L["Query item priorities"] = "Query item priorities"
L["Allows to query own priority. Whisper prio ITEMLINK."] = "Allows to query own priority. Whisper prio ITEMLINK."
L["No priorities found for playerOrItem"] = function(username) return "No priorities found for " .. username end
L["itemLink on Prio at userpriolist"] = function(itemlink, userpriolist) return itemlink .. " on Prio at " .. userpriolist end

-- used terms from core.lua
L["No priorities defined."] = "No priorities defined." -- also in loot.lua
L["No priority on itemLink"] = function(itemlink) return "No priority on " .. itemLink end
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 1) then
		return itemLink .. " is at PRIORITY " .. prio .. " for " .. table.concat(userlist, ', ' )
	else
		return itemLink .. " is at priority " .. prio .. " for " .. table.concat(userlist, ', ' )
	end
end

-- used terms from loot.lua
L["Priority List"] = "Priority List"



end
