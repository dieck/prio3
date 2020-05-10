local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "deDE", false)

if L then

-- prioOptionsTable
L["Enabled"] = "Aktiv"
L["Enables / disables the addon"] = "Aktiviert / deaktivert das Addon"
L["Announce No Priority"] = "Keine Priorität auch bekanntgeben"
L["Announce to Raid"] = "Raid benachrichtigen"
L["Announces Loot Priority list to raid chat"] = "Gibt die Loot-Priorität an den Raid-Chat aus."
L["Whisper to Char"] = "Spieler anflüstern"
L["Announces Loot Priority list to char by whisper"] = "Gibt die Loot-Priorität an den Spieler geflüstert aus."
L["Mute (sec)"] = "Stummschaltung (Sek)"
L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."] = "Ignoriert Loot der zum zweiten Mal gefunden wird für diese Anzahl Sekunden. 0 um nie zu ignorieren."
L["Loot prio list"] = "Loot Prioritäts-Liste"
L["Please note that current Prio settings WILL BE OVERWRITTEN"] = "Bitte beachten: Aktuelle Liste wird ÜBERSCHRIEBEN"
L["Enter new exported string here to configure Prio3 loot list"] = "Export-String für neue Prios hier eingeben"
L["Debug"] = "Debug"
L["Enters Debug mode. Addon will have advanced output, and work outside of Raid"] = "Debug-Modus anschalten. Mehr Ausgaben, und es funktioniert außerhalb von Raids."
L["Please /roll now!"] = "Bitte jetzt mit /roll würfeln!"
L["itemlink dropped. You have this on priority x."] = function (itemLink, prio) return itemLink .. " ist gedroppt. Du hast das auf Priorät " .. prio .. "." end

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

-- used terms from loot.lua
L["Priority List"] = "Prioritäts-Liste"



end
