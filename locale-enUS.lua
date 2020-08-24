local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "enUS", true)

if L then

-- prioOptionsTable
L["Output"] = "Output"
L["Queries"] = "Queries"
L["Import"] = "Import"
L["Sync & Handler"] = "Sync & Handler"

L["Enabled"] = "Enabled"
L["Enables / disables the addon"] = "Enables / disables the addon"
L["Announce No Priority"] = "Announce No Priority"
L["also announce without Epic"] = "all w/o Epic"
L["Announce to Raid"] = "Announce to Raid"
L["Enables / disables the addon"] = "Enables / disables the addon"
L["Announces Loot Priority list to raid chat"] = "Announces Loot Priority list to raid chat"
L["Whisper to Char"] = "Whisper to Char"
L["Announces Loot Priority list to char by whisper"] = "Announces Loot Priority list to char by whisper"
L["Announces if there is no priority on an item. Be careful: Will trigger on all mobs, not only bosses..."] = "Announces if there is no priority on an item. Be careful: Will trigger on all mobs, not only bosses..."
L["Announces if there is no priority on an item. Will only trigger if at least one Epic is found."] = "Announces if there is no priority on an item. Will only trigger if at least one Epic is found."
L["Announce rolls"] = "Announce rolls"
L["Announce when someone trigger a loot roll for an item. Will only work on Epics and BoP."] = "Announce when someone trigger a loot roll for an item. Will only work on Epics and BoP. (Forgot PM?)"
L["Announce raid warnings"] = "Announce raid warnings"
L["Announce when someone sends a raid warning with an item link."] = "Announce when someone sends a raid warning with an item link."
L["Mute (sec)"] = "Mute (sec)"
L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."] = "Ignores loot encountered a second time for this amount of seconds. 0 to turn off."
L["Import String"] = "Import String"
L["Resend prios"] = "Resend prios"
L["Please note that current Prio settings WILL BE OVERWRITTEN"] = "Please note that current Prio settings WILL BE OVERWRITTEN"
L["Enter new exported string here to configure Prio3 loot list"] = "Enter new exported string here to configure Prio3 loot list"
L["Whisper imports"] = "Whisper imports"
L["Whisper imported items to player"] = "Whisper imported items to player"
L["Open prio table after import"] = "Open prio table after import"
L["Show prio table"] = "Show prio table"
L["Clear prio table"] = "Clear prio table"
L["Debug"] = "Debug"
L["Enters Debug mode. Addon will have advanced output, and work outside of Raid"] = "Enters Debug mode. Addon will have advanced output, and work outside of Raid"
L["You will need to /roll when item is up."] = "You will need to /roll when item is up."
L["itemlink dropped. You have this on priority x."] = function (itemLink, prio) return itemLink .. " dropped. You have this on priority " .. prio .. "." end
L["Priorities of username: list"] = function(username,itemlinks) return "Priorities of " .. username .. ": " .. itemlinks end
L["Waited 10sec for itemID id to be resolved. Giving up on this item."] = function(id) return "Waited 10sec for itemID " .. id .. " to be resolved. Giving up on this item." end

L["Query own priority"] = "Query own priority"
L["Allows to query own priority. Whisper prio."] = "Allows to query own priority. Whisper prio."
L["Query raid priorities"] = "Query raid priorities"
L["Allows to query priorities of all raid members. Whisper prio CHARNAME."] = "Allows to query priorities of all raid members. Whisper prio CHARNAME."
L["Query item priorities"] = "Query item priorities"
L["Allows to query own priority. Whisper prio ITEMLINK."] = "Allows to query own priority. Whisper prio ITEMLINK."
L["No priorities found for playerOrItem"] = function(username) return "No priorities found for " .. username end
L["itemLink on Prio at userpriolist"] = function(itemlink, userpriolist) return itemlink .. " on Prio at " .. userpriolist end
L["Newer version found at user: version. Please update your addon."] = function(user,version) return "Newer version found at " .. user .. ": " .. version .. ". Please update your addon." end

L["Sync priorities"] = "Sync priorities"
L["Allows to sync priorities between multiple users in the same raid running Prio3"] = "Allows to sync priorities between multiple users in the same raid running Prio3"
L["Sync item accouncements"] = "Sync item accouncements"
L["Prevents other users from posting the same item you already posted."] = "Prevents other users from posting the same item you already posted."
L["/prio handler"] = "/prio handler"
L["/p3 handler"] = "/p3 handler"

L["You joined a new group. I looked for other Prio3 addons, but found none. If this is not a Prio3 group, do you want to disable your addon or at least clear old priorities?"] = "You joined a new group. I looked for other Prio3 addons, but found none. If this is not a Prio3 group, do you want to disable your addon or at least clear old priorities?"
L["Disable"] = "Disable"
L["Keep on"] = "Keep on"
L["Clear priorities"] = "Clear priorities"



L["Prio3 addon is currently disabled."] = "Prio3 addon is currently disabled."

L["Congratulations on finishing the Raid! Thank you for using Prio3. If you like it, Alleister on EU-Transcendence (Alliance) is gladly taking donations."] = "Congratulations on finishing the Raid! Thank you for using Prio3. If you like it, Alleister on EU-Transcendence (Alliance) is gladly taking donations :)"

-- used terms from core.lua
L["No priorities defined."] = "No priorities defined." -- also in loot.lua
L["No priority on itemLink"] = function(itemlink) return "No priority on " .. itemlink end
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 1) then
		return itemlink .. " is at PRIORITY " .. prio .. " for " .. table.concat(userlist, ', ' )
	else
		return itemlink .. " is at priority " .. prio .. " for " .. table.concat(userlist, ', ' )
	end
end

-- communications handling
L["sender handled notification for item"] = function(sender, item) return sender .. " handled notification for " .. item end
L["sender received priorities and answered"] = function(sender, answered) return sender .. " received priorities and " .. answered end
L["accepted"] = "accepted"
L["discarded"] = "discarded"
L["Accepted new priorities sent from sender"] = function(sender) return "Accepted new priorities sent from " .. sender end

-- used terms from loot.lua
L["Priority List"] = "Priority List"

end
