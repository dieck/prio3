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
L["React to rolls"] = "React to rolls"
L["Reacts when someone trigger a loot roll for an item. Will only work on Epics and BoP."] = "Reacts when someone trigger a loot roll for an item. Will only work on Epics and BoP. (Forgot PM?)"
L["React to raid warnings"] = "React to raid warnings"
L["Reacts when someone sends a raid warning with an item link."] = "Reacts when someone sends a raid warning with an item link."
L["Ignore Ony Cloak"] = "Ignore Ony Cloak"
L["Ignore if someone raid warns about the Onyxia Scale Cloak"] = "Ignore if someone raid warns about the Onyxia Scale Cloak"
L["Ignore Drakefire"] = "Ignore Drakefire"
L["Ignore if someone raid warns about the Drakefire Amulet"] = "Ignore if someone raid warns about the Drakefire Amulet (Onyxia access)"
L["Mute (sec)"] = "Mute (sec)"
L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."] = "Ignores loot encountered a second time for this amount of seconds. 0 to turn off."
L["Master Looter Hint"] = "Master Looter Hint"
L["Shows hint window on Master Looter distribution"] = "Shows hint window on Master Looter distribution"
L["Enable Prio 0"] = "Enable Prio 0"
L["Activates output for Prio 0. If someone sets Prio 1, 2 and 3 to the same item, this gets precedence."] = "Activates output for Prio 0. If someone sets Prio 1, 2 and 3 to the same item, this gets precedence."
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
L["Sync item announcements"] = "Sync item announcements"
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
L["rejected as Master Looter"] = "rejected as Master Looter"
L["discarded"] = "discarded"
L["Accepted new priorities sent from sender"] = function(sender) return "Accepted new priorities sent from " .. sender end
L["Received new priorities sent from sender, but I am Master Looter"] = function(sender) return "Received new priorities sent from " .. sender .. ", but I am Master Looter" end
L["Received Priorities"] = "Received Priorities"
L["Accept incoming"] = "Accept incoming"
L["Reject and keep mine"] = "Reject and keep mine"

-- used terms from loot.lua
L["Priority List"] = "Priority List"


-- help texts from gui.lua
L["Prio3 Help"] = "Prio3 Help"
L["tl;dr"] = "tl;dr"
L["Prio3 System"] = "Prio3 System"
L["Manual"] = "Manual"

-- help texts tl;dr
L["Import Priorities or have people whisper in priorities. Loot corpses and have chosen loot announced in raid chat."] = "Import Priorities or have people whisper in priorities. Loot corpses and have chosen loot announced in raid chat."
L["tl;dr In-Game"] =  "tl;dr In-Game"
L["Go to /prio3 config, Import, Accept whispers"] = "Go to /prio3 config, Import, Accept whispers"
L["For initial round, turn *off* Accept only new"] = "For initial round, turn *off* Accept only new"
L["Start accepting whispers"] = "Start accepting whispers"
L["You can verify who answered by /prio3"] = "You can verify who answered by /prio3"
L["End accepting whispers if all players entered"] = "End accepting whispers if all players entered"
L["For late joiners, re-enable Accept only new before allowing whispers"] = "For late joiners, re-enable Accept only new before allowing whispers"
L["Participants will need to have the Prio3 addon to see current list."] = "Participants will need to have the Prio3 addon to see current list."
L["If enabled in config, Participants can use whisper queries to find out who else has their items on prio."] = "If enabled in config, Participants can use whisper queries to find out who else has their items on prio."

L["tl;dr German users"] = "tl;dr German users"
L["I really encourage you to use sahne-team.de!"] = "I really encourage you to use sahne-team.de!"
L["Top left: Priorun, Priorun Erstellen, chose Server, Char and Class."] = "Top left: Priorun, Priorun Erstellen, chose Server, Char and Class."
L["*Note down the Admin Pin to the top right for yourself, if you get disconnected*."] = "*Note down the Admin Pin to the top right for yourself, if you get disconnected*."
L["Go to Raid Ziel, choose instance. Announce Prio PIN from Regeln or Spieler tab to participants (not Admin Pin!)."] = "Go to Raid Ziel, choose instance. Announce Prio PIN from Regeln or Spieler tab to participants (not Admin Pin!)."
L["Put in your priorities in Spieler tab."] = "Put in your priorities in Spieler tab."
L["When all have entered, go to Regeln - ANZEIGEN,"] = "When all have entered, go to Regeln - ANZEIGEN,"
L["then to Prioliste and download one of the exports on top, e.g. TXT."] = "then to Prioliste and download one of the exports on top, e.g. TXT."
L["Copy&Paste to /prio3 config, Import field"] = "Copy&Paste to /prio3 config, Import field"

L["You could also gather your raid priorities externally, e.g. using Google Doc."] = "You could also gather your raid priorities externally, e.g. using Google Doc."
L["Generate loot lists in format Username;Prio1;Prio2;Prio3 per line, using ItemIDs or e.g. wowhead links, and use /prio3 config, Import"] = "Generate loot lists in format Username;Prio1;Prio2;Prio3 per line, using ItemIDs or e.g. wowhead links, and use /prio3 config, Import"
L["You could opt to enable sending in priorities by whispers in the same menu, good option also for strugglers or replacement raiders."] = "You could opt to enable sending in priorities by whispers in the same menu, good option also for strugglers or replacement raiders."

-- help texts prio3

L["What is Priority 3 Looting?"] = "What is Priority 3 Looting?"
L["This loot distribution scheme is based on participants choosing up to three items they want to gain priority on when they actually drop."] = "This loot distribution scheme is based on participants choosing up to three items they want to gain priority on when they actually drop."
L["It is especially nice for pug raids or raids with a high amount of random fillers, as there is no history, no earning of points, everyone starts the same with every raid. But of course it can also be of value on regular raid groups that do not want the hassle of full DKP tracking or avoid long loot council discussions."] = "It is especially nice for pug raids or raids with a high amount of random fillers, as there is no history, no earning of points, everyone starts the same with every raid. But of course it can also be of value on regular raid groups that do not want the hassle of full DKP tracking or avoid long loot council discussions."
L["Side note: Prio 3 does not distinguish between main/need and offspec/greed priorities. It can thus be a good choice if you want to collect offspec gear for your char. (Hint: In order to avoid grief on main spec characters who are interested in the same items, it could be better to announce this intention beforehand.)"] = "Side note: Prio 3 does not distinguish between main/need and offspec/greed priorities. It can thus be a good choice if you want to collect offspec gear for your char. (Hint: In order to avoid grief on main spec characters who are interested in the same items, it could be better to announce this intention beforehand.)"

L["So, how does this work now?"] = "So, how does this work now?"

L["Before the raid, you will choose (up to) 3 items you want to have priority on."] = "Before the raid, you will choose (up to) 3 items you want to have priority on."
L["Mostly, the raid lead or designated PM is collecting these requests, noting them down. Sometimes a Google Doc is used to post as read only link to users later on."] = "Mostly, the raid lead or designated PM is collecting these requests, noting them down. Sometimes a Google Doc is used to post as read only link to users later on."
L["Prio3 can also be used to collect these requests in-game. See tl;dr tab for a short intro."] = "Prio3 can also be used to collect these requests in-game. See tl;dr tab for a short intro."

L["sahne-team.de usage: If you are a German user, please try this website! It eases up coordinating Prio loot a lot."] = "sahne-team.de usage: If you are a German user, please try this website! It eases up coordinating Prio loot a lot."
L["You setup a run on the Priorun function to the upper left, select a target instance, and give the Run PIN to your participants."] = "You setup a run on the Priorun function to the upper left, select a target instance, and give the Run PIN to your participants."
L["Please remember to note down your admin pin from the upper right corner!"] = "Please remember to note down your admin pin from the upper right corner!"
L["Every user can choose their items, in secret. Even the admin cannot see those."] = "Every user can choose their items, in secret. Even the admin cannot see those."
L["After all participants have chosen their loot, the admin can set the run to be visible for all."] = "After all participants have chosen their loot, the admin can set the run to be visible for all."
L["For use with the Prio3 addon, you can then use the Exports."] = "For use with the Prio3 addon, you can then use the Exports."
L["Prio3 native would be CSV Short, but the addon can actually read sahne-team.de full CSV and TXT export as well."] = "Prio3 native would be CSV Short, but the addon can actually read sahne-team.de full CSV and TXT export as well."

L["If the loot drops, it will be handled along the priority table, starting with all users that have this on Priority 1."] = "If the loot drops, it will be handled along the priority table, starting with all users that have this on Priority 1."
L["If there is only one user: Congrats, you have a new item."] = "If there is only one user: Congrats, you have a new item."
L["If there are more users with the same priority, those are asked to roll for the item, highest roll wins."] = "If there are more users with the same priority, those are asked to roll for the item, highest roll wins."
L["Every user will get only one item per priority. If an items drops a second time, it is handled among the others with the highest remaining priority."] = "Every user will get only one item per priority. If an items drops a second time, it is handled among the others with the highest remaining priority."
L["If no one selected that particular item for Prio 1, then Prio 2 will be handled, and afterwards Prio 3. For all items where no one set a Priority, those are usually handled by FFA. Some raids tend to apply main>offspec here."] = "If no one selected that particular item for Prio 1, then Prio 2 will be handled, and afterwards Prio 3. For all items where no one set a Priority, those are usually handled by FFA. Some raids tend to apply main>offspec here."
L["Of course choosing which items to put where, that is part of the fun, and risk. Do I put this item on Prio 1, because others may want it too? Or it is unlikely, and I can savely put it on Prio 3?"] = "Of course choosing which items to put where, that is part of the fun, and risk. Do I put this item on Prio 1, because others may want it too? Or it is unlikely, and I can savely put it on Prio 3?"

L["Where does the Prio3 addon comes into play?"] = "Where does the Prio3 addon comes into play?"
L["Looking up if someone actually has marked down a priority can be a tedious task, and it's easy to miss someone."] = "Looking up if someone actually has marked down a priority can be a tedious task, and it's easy to miss someone."
L["The Prio3 addon will notify you on looting if there are any Priorities set up."] = "The Prio3 addon will notify you on looting if there are any Priorities set up."
L["This way you don't have to switch to your lookup table, e.g. on a website like sahne-team.de or a google doc, or even a handwritten note. It will announce this to the raid (by default), or only to the char using the addon and looting (should normally be the PM)."] = "This way you don't have to switch to your lookup table, e.g. on a website like sahne-team.de or a google doc, or even a handwritten note. It will announce this to the raid (by default), or only to the char using the addon and looting (should normally be the PM)."

L["What is Prio 0?"] = "What is Prio 0?"
L["Some groups extended the Prio 3 system by another priorization that takes precedence before Prio 1."] = "Some groups extended the Prio 3 system by another priorization that takes precedence before Prio 1."
L["If you enable the output setting and choose the same item for Prio 1, 2 and 3, it will be used as Prio 0."] = "If you enable the output setting and choose the same item for Prio 1, 2 and 3, it will be used as Prio 0."


-- help texts manual

L["IMPORT, or How does the addon know about the priorities?"] = "IMPORT, or How does the addon know about the priorities?"

L["You can import simple CSV strings on the Addon config page (Menu Interfaces, Tab Addon, Prio3)"] = "You can import simple CSV strings on the Addon config page (Menu Interfaces, Tab Addon, Prio3)"
L["where Prio1, 2, 3 can be numeric item Ids, or even strings with the IDs somewhere in (will take first number found), e.g. wowhead links. This is basically the CSV-SHORT export format of sahne-team.de."] = "where Prio1, 2, 3 can be numeric item Ids, or even strings with the IDs somewhere in (will take first number found), e.g. wowhead links. This is basically the CSV-SHORT export format of sahne-team.de."
L["Also accepted format: sahne-team.de CSV normal export, with german header line:"] = "Also accepted format: sahne-team.de CSV normal export, with german header line:"
L["Also accepted format: sahne-team.de TXT export (tab » separated)"] = "Also accepted format: sahne-team.de TXT export (tab » separated)"
L["If you need further formats, please let me know."] = "If you need further formats, please let me know."
L["Players can be informed by whispers about imported priorities (configurable in options)"] = "Players can be informed by whispers about imported priorities (configurable in options)"
L["You could opt for accepting priorities by whisper. Go to Menu Interfaces, Tab Addon, Prio3; or type /prio3 config, and to go Import. This is a good option also for late joiners / replacements. See also tl;dr section."] = "You could opt for accepting priorities by whisper. Go to Menu Interfaces, Tab Addon, Prio3; or type /prio3 config, and to go Import. This is a good option also for late joiners / replacements. See also tl;dr section."

L["OUTPUT, or What happens when loot drops"] = "OUTPUT, or What happens when loot drops"

L["You can choose the output language independent of your client languague. Currently only English and German are supported. If you are interested in helping out with another translation, please let me know on http://github.com/dieck/prio3"] = "You can choose the output language independent of your client languague. Currently only English and German are supported. If you are interested in helping out with another translation, please let me know on http://github.com/dieck/prio3"
L["Announcing to Raid is the main functionality. It will post to raid when it encounters loot where someone has a priority on. It will post one line per Priority (1,2,3), with the chars who have listed it."] = "Announcing to Raid is the main functionality. It will post to raid when it encounters loot where someone has a priority on. It will post one line per Priority (1,2,3), with the chars who have listed it."
L["You can also announce if there is No Priority set up for an item."] = "You can also announce if there is No Priority set up for an item."
L["Announces will react to the minimum quality setting. Recommendation: Epic for most raids, Rare for AQ20"] = "Announces will react to the minimum quality setting. Recommendation: Epic for most raids, Rare for AQ20"
L["You can also whisper to players if there is loot that they have chosen."] = "You can also whisper to players if there is loot that they have chosen."
L["Prio3 will react to loot events (if you open a loot window)"] = "Prio3 will react to loot events (if you open a loot window)"
L["You can configure it to also react to rolls (if e.g. there is no PM and the roll window starts) and to raid warnings (if e.g. someone else does Master Looter). You can also configure to ignore Onyxia Cloaks posted as raid warnings. Special service for BWL Prio3 runs :)"] = "You can configure it to also react to rolls (if e.g. there is no PM and the roll window starts) and to raid warnings (if e.g. someone else does Master Looter). You can also configure to ignore Onyxia Cloaks posted as raid warnings. Special service for BWL Prio3 runs :)"
L["In order to avoid multiple posts, e.g. if you loot a corpse twice, there is a mute setting pausing outputs for a defined time."] = "In order to avoid multiple posts, e.g. if you loot a corpse twice, there is a mute setting pausing outputs for a defined time."
L["For Master Looter, a hint window can be added to the distribution window, showing all priorities for an item"] = "For Master Looter, a hint window can be added to the distribution window, showing all priorities for an item"
L["Prio 0 enables a 4th priority that is ranked highest, if all 3 priorizations are set to the same item."] = "Prio 0 enables a 4th priority that is ranked highest, if all 3 priorizations are set to the same item."

L["QUERIES, or How to look up and validate priorities"] = "QUERIES, or How to look up and validate priorities"

L["For addon users, /prio3 will open up a priority list"] = "For addon users, /prio3 will open up a priority list"
L["There are three options for your raid participants to query for Prio3 entries (can be turned on and off in options):"] = "There are three options for your raid participants to query for Prio3 entries (can be turned on and off in options):"
L["* Whisper 'prio' to get your own priorities. (default: on)"] = "* Whisper 'prio' to get your own priorities. (default: on)"
L["* Whisper 'prio USERNAME' to look up another raid member. (default: off)"] = "* Whisper 'prio USERNAME' to look up another raid member. (default: off)"
L["* Whisper 'prio ITEMLINK' to look up priorities on an item. (default: on)"] = "* Whisper 'prio ITEMLINK' to look up priorities on an item. (default: on)"
L["(If you don't get an answer at all, ask your Prio3 master if they turned on the options)"] = "(If you don't get an answer at all, ask your Prio3 master if they turned on the options)"

L["SYNC & HANDLER, or How does this work with multiple people"] = "SYNC & HANDLER, or How does this work with multiple people"

L["Here are two options to handle how the addon talks to other users in the same raid. It is HIGHLY recommended to leave both turned on."] = "Here are two options to handle how the addon talks to other users in the same raid. It is HIGHLY recommended to leave both turned on."
L["Sync priorities will sync the list of items between multiple users, on import / end of accepting whispers. Without this option, multiple users could have different priorities, and depending on the next option it might not be clear whose are posted."] = "Sync priorities will sync the list of items between multiple users, on import / end of accepting whispers. Without this option, multiple users could have different priorities, and depending on the next option it might not be clear whose are posted."
L["The Resend prios button will send out Prios if needed - normally when someone new with the addon joins the raid, it will be synced automatically. But if the disabled the addon and turns it on later, you can send out your priorities with this."] = "The Resend prios button will send out Prios if needed - normally when someone new with the addon joins the raid, it will be synced automatically. But if the disabled the addon and turns it on later, you can send out your priorities with this."
L["Sync item announcements will coordinate between multiple users' addons which user will actually post to raid (depending on output options). This is to avoid multiple posts of the same information. (May still happen though if addon communication is lagging slightly)."] = "Sync item announcements will coordinate between multiple users' addons which user will actually post to raid (depending on output options). This is to avoid multiple posts of the same information. (May still happen though if addon communication is lagging slightly)."
L["Also, you can opt to use /prio or /p3 in addition to /prio3 as command line trigger."] = "Also, you can opt to use /prio or /p3 in addition to /prio3 as command line trigger."

L["and more"] = "and more"

L["There is a 'Versions' tab in the options, which is basically only there for debugging purposes."] = "There is a 'Versions' tab in the options, which is basically only there for debugging purposes."
L["Users are notified if they have an older version of the application."] = "Users are notified if they have an older version of the application."
L["Until now, all addon synchronisation features were backwards compatible. If this changes at some point in time, a comprehensive error message will be put in place"] = "Until now, all addon synchronisation features were backwards compatible. If this changes at some point in time, a comprehensive error message will be put in place"

-- load default outputs
for k,v in pairs(Prio3.outputLocales["enUS"]) do L[k] = v end


end
