local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "deDE", false)

if L then

-- prioOptionsTable
L["Output"] = "Ausgaben"
L["Queries"] = "Abfragen"
L["Import"] = "Import"
L["Sync & Handler"] = "Sync & Handler"

L["Enabled"] = "Aktiv"
L["Enables / disables the addon"] = "Aktiviert / deaktivert das Addon"
L["Announce No Priority"] = "Keine Priorität auch bekanntgeben"
L["min Quality"] = "min Qualität"
L["Announce only if there is an item of at least this quality in Loot"] = "Nur ausgeben wenn mindestens ein Items dieser Qualität gefunden wurde. Bitte beachten: Kann bei allen Mobs aufkommen, nicht nur bei Bossen."
L["Poor (Grey)"] = "Schlecht (Grau)"
L["Common (White)"] = "Gewöhnlich (Weiß)"
L["Uncommon (Green)"] = "Außergewöhnlich (Grün)"
L["Rare (Blue)"] = "Selten (Blau)"
L["Epic (Purple)"] = "Episch (Lila)"
L["Legendary (Orange)"] = "Legendär (Orange)"
L["Announce to Raid"] = "Raid benachrichtigen"
L["Announces Loot Priority list to raid chat"] = "Gibt die Loot-Priorität an den Raid-Chat aus."
L["Whisper to Char"] = "Spieler anflüstern"
L["Announces Loot Priority list to char by whisper"] = "Gibt die Loot-Priorität an den Spieler geflüstert aus."
L["Announces if there is no priority on an item"] = "Gibt aus wenn es keine Priorität auf einem Item gibt"
L["Announce rolls"] = "Würfeln bekanntgeben"
L["Announce when someone trigger a loot roll for an item. Will only work on Epics and BoP."] = "Gibt aus wenn um ein Epic oder BoP gerollt wird. (PM vergessen?)"
L["Announce raid warnings"] = "Raidwarnung bekanntgeben"
L["Announce when someone sends a raid warning with an item link."] = "Gibt aus wenn jemand ein Item mittels Raidwarnung bekanntgibt"
L["Mute (sec)"] = "Stummschaltung (Sek)"
L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."] = "Ignoriert Loot der zum zweiten Mal gefunden wird für diese Anzahl Sekunden. 0 um nie zu ignorieren."
L["Import String"] = "Import String"
L["Resend prios"] = "Neu senden"
L["Please note that current Prio settings WILL BE OVERWRITTEN"] = "Bitte beachten: Aktuelle Liste wird ÜBERSCHRIEBEN"
L["Enter new exported string here to configure Prio3 loot list"] = "Export-String für neue Prios hier eingeben"
L["Whisper imports"] = "Bei Import zuflüstern"
L["Whisper imported items to player"] = "Den Spieler nach dem Import über seine Prioritäten informieren."
L["Open prio table after import"] = "Öffne Prio Tabelle nach dem Import"
L["Show prio table"] = "Zeige Prio Tabelle"
L["Clear prio table"] = "Leere Prio Tabelle"
L["Debug"] = "Debug"
L["Enters Debug mode. Addon will have advanced output, and work outside of Raid"] = "Debug-Modus anschalten. Mehr Ausgaben, und es funktioniert außerhalb von Raids."
L["You will need to /roll when item is up."] = "Du wirst darum /würfeln müssen wenn das Item verteilt wird."
L["itemlink dropped. You have this on priority x."] = function (itemlink, prio) return itemlink .. " ist gedroppt. Du hast das auf Priorät " .. prio .. "." end
L["Priorities of username: list"] = function(username,itemlinks) return "Prioritäten für " .. username .. ": " .. itemlinks end
L["Waited 10sec for itemID id to be resolved. Giving up on this item."] = function(id) return "Habe 10sek gewartet auf itemID " .. id .. ". Gebe es jetzt auf." end

L["Query own priority"] = "Suche eigene Priorität"
L["Allows to query own priority. Whisper prio."] = "Erlaubt die Abfrage eigener Prioritäten. Flüstere prio."
L["Query raid priorities"] = "Suche Raid Prioritäten"
L["Allows to query priorities of all raid members. Whisper prio CHARNAME."] = "Erlaubt die Abfrage der Prioritäten alle Raid-Mitglieder. Flüstere prio CHARNAME."
L["Query item priorities"] = "Suche Item Prioritäten"
L["Allows to query own priority. Whisper prio ITEMLINK."] = "Erlaubt die Abfrage nach Items. Flüstere prio ITEMLINK."
L["No priorities found for playerOrItem"] = function(username) return "Keine Prioritäten gefunden für " .. username end
L["itemLink on Prio at userpriolist"] = function(itemlink, userpriolist) return itemlink .. " auf Prio bei " .. userpriolist end
L["Newer version found at user: version. Please update your addon."] = function(user,version) return "Neuere Version bei " .. user .. " gefunden: " .. version .. ". Bitte das Addon updaten." end

L["Sync priorities"] = "Prioritäten synchronisieren"
L["Allows to sync priorities between multiple users in the same raid running Prio3"] = "Erlaubt der syncen von Prioritäten mit anderen Prio3-Addons im Raid"
L["Sync item accouncements"] = "Ausgaben synchronisieren"
L["Prevents other users from posting the same item you already posted."] = "Synct Ausgaben, so dass andere Raidteilnehmer den gleichen Loot nicht erneut posten."
L["/prio handler"] = "/prio benutzen"
L["/p3 handler"] = "/p3 benutzen"

L["You joined a new group. I looked for other Prio3 addons, but found none. If this is not a Prio3 group, do you want to disable your addon or at least clear old priorities?"] = "Du hast eine neue Gruppe betreten. Ich habe nach anderen Prio3 Addons gesucht, aber keine gefunden. Falls dies keine Prio3 Gruppe ist, möchtest du das Addon deaktivieren oder zumindest die Prioritäten löschen?" 
L["Disable"] = "Deaktivieren"
L["Keep on"] = "Aktiv lassen"
L["Clear priorities"] = "Prios löschen"

L["Prio3 addon is currently disabled."] = "Prio3-Addon ist zur Zeit deaktiviert."

L["Congratulations on finishing the Raid! Thank you for using Prio3. If you like it, Alleister on EU-Transcendence (Alliance) is gladly taking donations."] = "Herzlichen Glückwunsch zum Abschluss des Raids! Danke dass ihr Prio3 nutze. Wenn es euch gefällt, Alleister auf EU-Transcendence (Allianz) nimmt gerne Spenden an :)"

 
-- used terms from core.lua
L["No priorities defined."] = "Keine Prioritäten eingestellt." -- also in loot.lua
L["No priority on itemLink"] = function(itemlink) return "Keine Priorität für " .. itemlink end
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 1) then
		return itemlink .. " ist gesetzt als PRIORITÄT " .. prio .. " für " .. table.concat(userlist, ', ' )
	else
		return itemlink .. " ist gesetzt als Priorität " .. prio .. " für " .. table.concat(userlist, ', ' )
	end
end

-- communications handling
L["sender handled notification for item"] = function(sender, item) return sender .. " hat Benachrichtungen für " .. item .. " bearbeitet" end
L["sender received priorities and answered"] = function(sender, answered) return sender .. " hat neue Prioritäten erhalten und " .. L[answered] end
L["accepted"] = "hat akzeptiert"
L["discarded"] = "hat nicht angenommen"
L["Accepted new priorities sent from sender"] = function(sender) return "Neue Prioritäten von " .. sender .." angenommen" end

-- used terms from loot.lua
L["Priority List"] = "Prioritäts-Liste"



end
