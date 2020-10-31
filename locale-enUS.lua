local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "enUS", true)

if L then

-- prioOptionsTable
L["Output"] = "Output"
L["Queries"] = "Queries"
L["Import"] = "Import"
L["Sync & Handler"] = "Sync & Handler"

L["Enabled"] = "Enabled"
L["Enables / disables the addon"] = "Enables / disables the addon"
L["Language"] = "Language"
L["Language for outputs"] = "Language for outputs"
L["Announce No Priority"] = "Announce No Priority"
L["min Quality"] = "min Quality"
L["Announce only if there is an item of at least this quality in Loot"] = "Announce only if there is an item of at least this quality in Loot. Be aware: Might trigger on all mobs, not only bosses."
L["Poor (Grey)"] = "Poor (Grey)"
L["Common (White)"] = "Common (White)"
L["Uncommon (Green)"] = "Uncommon (Green)"
L["Rare (Blue)"] = "Rare (Blue)"
L["Epic (Purple)"] = "Epic (Purple)"
L["Legendary (Orange)"] = "Legendary (Orange)"
L["Announce to Raid"] = "Announce to Raid"
L["Announces Loot Priority list to raid chat"] = "Announces Loot Priority list to raid chat"
L["Whisper to Char"] = "Whisper to Char"
L["Announces Loot Priority list to char by whisper"] = "Announces Loot Priority list to char by whisper"
L["Announces if there is no priority on an item"] = "Announces if there is no priority on an item"
L["Announce rolls"] = "Announce rolls"
L["Announce when someone trigger a loot roll for an item. Will only work on Epics and BoP."] = "Announce when someone trigger a loot roll for an item. Will only work on Epics and BoP. (Forgot PM?)"
L["Announce raid warnings"] = "Announce raid warnings"
L["Announce when someone sends a raid warning with an item link."] = "Announce when someone sends a raid warning with an item link."
L["Ignore Ony Cloak"] = "Ignore Ony Cloak"
L["Ignore if someone raid warns about the Onyxia Scale Cloak"] = "Ignore if someone raid warns about the Onyxia Scale Cloak"
L["Mute (sec)"] = "Mute (sec)"
L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."] = "Ignores loot encountered a second time for this amount of seconds. 0 to turn off."
L["Master Looter Hint"] = "Master Looter Hint"
L["Shows hint window on Master Looter distribution"] = "Shows hint window on Master Looter distribution"
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
L["Waited 10sec for itemID id to be resolved. Giving up on this item."] = function(id) return "Waited 10sec for itemID " .. id .. " to be resolved. Giving up on this item." end

L["Query own priority"] = "Query own priority"
L["Allows to query own priority. Whisper prio."] = "Allows to query own priority. Whisper prio."
L["Query raid priorities"] = "Query raid priorities"
L["Allows to query priorities of all raid members. Whisper prio CHARNAME."] = "Allows to query priorities of all raid members. Whisper prio CHARNAME."
L["Query item priorities"] = "Query item priorities"
L["Allows to query own priority. Whisper prio ITEMLINK."] = "Allows to query own priority. Whisper prio ITEMLINK."
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


L["Accept whispers"] = "Accept whispers"
L["Enables receiving participant priorities by whisper."] = "Enables receiving participant priorities by whisper."
L["Itemlinks, Item ID numbers or Wowhead Links; separated by Space or Comma"] = "Itemlinks, Item ID numbers or Wowhead Links; separated by Space or Comma"
L["Using import later will overwrite/delete received priorities."] = "Using import later will overwrite/delete received priorities."
L["Deleting, importing, resending, receiving and querying of priorities will be disabled while accepting whispers."] = "Deleting, importing, resending, receiving and querying of priorities will be disabled while accepting whispers."
L["Will send out priorities to other Prio3 addons when ending."] = "Will send out priorities to other Prio3 addons when ending."
L["Be aware addon user will be able to see incoming priorities before opening it up to the public."] = "Be aware addon user will be able to see incoming priorities before opening it up to the public."
L["Accept only new"] = "Accept only new"
L["Accept only from new players without priorities yet. If disabled, accepts from all players and allow overwriting"] = "Accept only from new players without priorities yet. If disabled, accepts from all players and allow overwriting"
L["Start accepting"] = "Start accepting"
L["End accepting"] = "End accepting"

L["Prio3 addon is currently disabled."] = "Prio3 addon is currently disabled."

L["Congratulations on finishing the Raid! Thank you for using Prio3. If you like it, Alleister on EU-Transcendence (Alliance) is gladly taking donations."] = "Congratulations on finishing the Raid! Thank you for using Prio3. If you like it, Alleister on EU-Transcendence (Alliance) is gladly taking donations :)"

-- used terms from core.lua
L["No priorities defined."] = "No priorities defined." -- also in loot.lua

-- communications handling
L["sender handled notification for item"] = function(sender, item) return sender .. " handled notification for " .. item end
L["sender received priorities and answered"] = function(sender, answered) return sender .. " received priorities and " .. answered end
L["accepted"] = "accepted"
L["discarded"] = "discarded"
L["Accepted new priorities sent from sender"] = function(sender) return "Accepted new priorities sent from " .. sender end

-- used terms from loot.lua
L["Priority List"] = "Priority List"

-- load default outputs 
for k,v in pairs(Prio3.outputLocales["enUS"]) do L[k] = v end


end
