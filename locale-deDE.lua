local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "deDE", false)

if L then

-- prioOptionsTable
L["Enabled"] = "Aktiv"
L["Enables / disables the addon"] = "Aktiviert / deaktivert das Addon"
L["Announce No Priority"] = "Keine Priorität auch bekanntgeben"
L["also announce without Epic"] = "auch ohne Epic"
L["Announce to Raid"] = "Raid benachrichtigen"
L["Announces Loot Priority list to raid chat"] = "Gibt die Loot-Priorität an den Raid-Chat aus."
L["Whisper to Char"] = "Spieler anflüstern"
L["Announces Loot Priority list to char by whisper"] = "Gibt die Loot-Priorität an den Spieler geflüstert aus."
L["Announces if there is no priority on an item. Be careful: Will trigger on all mobs, not only bosses..."] = "Gibt aus wenn es keine Priorität auf einem Item gibt. Vorsicht, greift bei allen Mobs, nicht nur Bosse..."
L["Announces if there is no priority on an item. Will only trigger if at least one Epic is found."] = "Gibt aus wenn es keine Priorität auf einem Item gibt. Greift nur wenn mindestens ein Epic gefunden wurde"
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
L["itemlink dropped. You have this on priority x."] = function (itemLink, prio) return itemLink .. " ist gedroppt. Du hast das auf Priorät " .. prio .. "." end
L["Priorities of username: list"] = function(username,itemLinks) return "Prioritäten für " .. username .. ": " .. itemLinks end

L["Query own priority"] = "Suche eigene Priorität"
L["Allows to query own priority. Whisper prio."] = "Erlaubt die Abfrage eigener Prioritäten. Flüstere prio."
L["Query raid priorities"] = "Suche Raid Prioritäten"
L["Allows to query priorities of all raid members. Whisper prio CHARNAME."] = "Erlaubt die Abfrage der Prioritäten alle Raid-Mitglieder. Flüstere prio CHARNAME."
L["Query item priorities"] = "Suche Item Prioritäten"
L["Allows to query own priority. Whisper prio ITEMLINK."] = "Erlaubt die Abfrage nach Items. Flüstere prio ITEMLINK."
L["No priorities found for playerOrItem"] = function(username) return "Keine Prioritäten gefunden für " .. username end
L["itemLink on Prio at userpriolist"] = function(itemlink, userpriolist) return itemlink .. " auf Prio bei " .. userpriolist end
L["Newer version found at user: version. Please update your addon."] = function(user,version) return "Neuere Version bei " .. user .. " gefunden: " .. version .. ". Bitte das Addon updaten." end

-- used terms from core.lua
L["No priorities defined."] = "Keine Prioritäten eingestellt." -- also in loot.lua
L["No priority on itemLink"] = function(itemlink) return "Keine Priorität für " .. itemLink end
L["itemLink is at priority for users"] = function(itemlink,prio,userlist)
	if (prio == 1) then
		return itemLink .. " ist gesetzt als PRIORITÄT " .. prio .. " für " .. table.concat(userlist, ', ' )
	else
		return itemLink .. " ist gesetzt als Priorität " .. prio .. " für " .. table.concat(userlist, ', ' )
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
