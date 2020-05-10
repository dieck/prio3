local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "enUS", true)

if L then

-- prioOptionsTable
L["Enabled"] = "Enabled"
L["Enables / disables the addon"] = "Enables / disables the addon"
L["Announce No Priority"] = "Announce No Priority"
L["Announce to Raid"] = "Announce to Raid"
L["Enables / disables the addon"] = "Enables / disables the addon"
L["Announces Loot Priority list to raid chat"] = "Announces Loot Priority list to raid chat"
L["Mute (sec)"] = "Mute (sec)"
L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."] = "Ignores loot encountered a second time for this amount of seconds. 0 to turn off."
L["Loot prio list"] = "Loot prio list"
L["Please note that current Prio settings WILL BE OVERWRITTEN"] = "Please note that current Prio settings WILL BE OVERWRITTEN"
L["Enter new exported string here to configure Prio3 loot list"] = "Enter new exported string here to configure Prio3 loot list"
L["Debug"] = "Debug"
L["Enters Debug mode. Addon will have advanced output, and work outside of Raid"] = "Enters Debug mode. Addon will have advanced output, and work outside of Raid"

-- used terms from core.lua
L["No priorities defined."] = "No priorities defined." -- also in loot.lua
L["No priority on itemLink"] = function(itemlink) return "No priority on " .. itemLink end
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 1) then
		return itemLink .. " is at PRIORITY " .. prio .. " for " .. table.concat(userlist, ',' )
	else
		return itemLink .. " is at priority " .. prio .. " for " .. table.concat(userlist, ',' )
	end
end

-- used terms from loot.lua
L["Priority List"] = "Priority List"



end
