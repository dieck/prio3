local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "deDE", false)

if L then

-- prioOptionsTable
L["Output"] = "Ausgaben"
L["Queries"] = "Abfragen"
L["Import"] = "Import"
L["Sync & Handler"] = "Sync & Handler"

L["Enabled"] = "Aktiv"
L["Enables / disables the addon"] = "Aktiviert / deaktivert das Addon"
L["Language"] = "Sprache"
L["Language for outputs"] = "Sprache für Ausgaben"
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
L["React to rolls"] = "bei Würfeln"
L["Reacts when someone trigger a loot roll for an item. Will only work on Epics and BoP."] = "Gibt aus wenn um ein Epic oder BoP gerollt wird. (PM vergessen?)"
L["React to raid warnings"] = "bei Raidwarnung"
L["Reacts when someone sends a raid warning with an item link."] = "Gibt aus wenn jemand ein Item mittels Raidwarnung bekanntgibt"
L["Ignore Ony Cloak"] = "Ignoriere Ony-Umhang"
L["Ignore if someone raid warns about the Onyxia Scale Cloak"] = "Ignoriere wenn jemand den Onyxiaschuppenumhang als Raidwarnung schreibt"
L["Mute (sec)"] = "Stummschaltung (Sek)"
L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."] = "Ignoriert Loot der zum zweiten Mal gefunden wird für diese Anzahl Sekunden. 0 um nie zu ignorieren."
L["Master Looter Hint"] = "PM-Hinweis"
L["Shows hint window on Master Looter distribution"] = "Zeigt Hinweis beim Verteilfenster für Plündermeister an"
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
L["Waited 10sec for itemID id to be resolved. Giving up on this item."] = function(id) return "Habe 10sek gewartet auf itemID " .. id .. ". Gebe es jetzt auf." end

L["Query own priority"] = "Suche eigene Priorität"
L["Allows to query own priority. Whisper prio."] = "Erlaubt die Abfrage eigener Prioritäten. Flüstere prio."
L["Query raid priorities"] = "Suche Raid Prioritäten"
L["Allows to query priorities of all raid members. Whisper prio CHARNAME."] = "Erlaubt die Abfrage der Prioritäten alle Raid-Mitglieder. Flüstere prio CHARNAME."
L["Query item priorities"] = "Suche Item Prioritäten"
L["Allows to query own priority. Whisper prio ITEMLINK."] = "Erlaubt die Abfrage nach Items. Flüstere prio ITEMLINK."
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

L["Accept whispers"] = "Flüstern akzeptieren"
L["Enables receiving participant priorities by whisper."] = "Erlaubt das Einsenden von Prioritäten über Flüstern."
L["Itemlinks, Item ID numbers or Wowhead Links; separated by Space or Comma"] = "Itemlinks, Wowhead-Links oder direkt Item IDs, getrennt mit Leerzeichen oder Komma"
L["Using import later will overwrite/delete received priorities."] = "Spätere Importe überschreiben/löschen geflüsterte Priotitäten."
L["Deleting, importing, resending, receiving and querying of priorities will be disabled while accepting whispers."] = "Löschen, Importieren, neu senden, empfangen und abfragen von Prioritäten sind deaktiviert während Flüstern akzeptiert wird."
L["Will send out priorities to other Prio3 addons when ending."] = "Nach Abschluss werden Prioritäten an andere Prio3 Addons gesendet."
L["Be aware addon user will be able to see incoming priorities before opening it up to the public."] = "Bitte bachten: Der Benutzer wird die Prioritäten der anderen User im Flüstern sehen können."
L["Accept only new"] = "Nur neue akzeptieren"
L["Accept only from new players without priorities yet. If disabled, accepts from all players and allow overwriting"] = "Akzeptiert geflüsterte Prioritäten nur von Benutzern die noch keine Prioritäten gesetzt hatten. Wenn deaktiviert werden Prioritäten von allen Spielern akzeptiert und können auch überschrieben werden."
L["Start accepting"] = "Beginne Flüstern"
L["End accepting"] = "Beende Flüstern"

L["Prio3 addon is currently disabled."] = "Prio3-Addon ist zur Zeit deaktiviert."

L["Congratulations on finishing the Raid! Thank you for using Prio3. If you like it, Alleister on EU-Transcendence (Alliance) is gladly taking donations."] = "Herzlichen Glückwunsch zum Abschluss des Raids! Danke dass ihr Prio3 nutze. Wenn es euch gefällt, Alleister auf EU-Transcendence (Allianz) nimmt gerne Spenden an :)"

 
-- used terms from core.lua
L["No priorities defined."] = "Keine Prioritäten eingestellt." -- also in loot.lua

-- communications handling
L["sender handled notification for item"] = function(sender, item) return sender .. " hat Benachrichtungen für " .. item .. " bearbeitet" end
L["sender received priorities and answered"] = function(sender, answered) return sender .. " hat neue Prioritäten erhalten und " .. L[answered] end
L["accepted"] = "hat akzeptiert"
L["discarded"] = "hat nicht angenommen"
L["Accepted new priorities sent from sender"] = function(sender) return "Neue Prioritäten von " .. sender .." angenommen" end

-- used terms from loot.lua
L["Priority List"] = "Prioritäts-Liste"



-- help texts from gui.lua
L["Prio3 Help"] = "Prio3 Hilfe"
L["tl;dr"] = "tl;dr"
L["Prio3 System"] = "Prio3-System"
L["Manual"] = "Handbuch"

-- help texts tl;dr
L["Import Priorities or have people whisper in priorities. Loot corpses and have chosen loot announced in raid chat."] = "Importiere Prioritäten oder lass Mitspieler diese per Flüstern einreichen. Wenn Gegner Loot droppen der auf Priorität ist wird dieses im Chat angesagt."
L["tl;dr In-Game"] =  "tl;dr In-Game"
L["Go to /prio3 config, Import, Accept whispers"] = "Geh zu /prio3 config, Import, Flüstern akzeptieren"
L["For initial round, turn *off* Accept only new"] = "Für eine neue Runde, schalte 'Nur neue akzeptieren' *aus*"
L["Start accepting whispers"] = "Beginne Flüstern zu akzeptieren"
L["You can verify who answered by /prio3"] = "Du kannst in der Liste /prio3 schauen wer schon geantwortet hat."
L["End accepting whispers if all players entered"] = "Beende Flüstern wenn alle abgegeben haben."
L["For late joiners, re-enable Accept only new before allowing whispers"] = "Für später Hinzugekommene, reaktiviere 'Nur neue akzeptieren' bevor Flüstern begonnen wird"
L["Participants will need to have the Prio3 addon to see current list."] = "Teilnehmer benötigen das Prio3-Addon um die ganze Liste einzusehen."
L["If enabled in config, Participants can use whisper queries to find out who else has their items on prio."] = "Wenn es aktiviert wurde, können Teilnehmer die Abfragen per Flüstern nutzen, um zu schauen wer sonst noch ihre Items auf Prio hat."

L["tl;dr German users"] = "tl;dr Deutschsprachig"
L["I really encourage you to use sahne-team.de!"] = "Ich empfehle sehr sahne-team.de zu nutzen!"
L["Top left: Priorun, Priorun Erstellen, chose Server, Char and Class."] = "Oben links: Priorun, Priorun Erstellen, dann Server, Char und Klasse eingeben"
L["*Note down the Admin Pin to the top right for yourself, if you get disconnected*."] = "*Notiere die Admin Pin oben rechts, falls du rausfliegst zwischendrin*."
L["Go to Raid Ziel, choose instance. Announce Prio PIN from Regeln or Spieler tab to participants (not Admin Pin!)."] = "Bei Raid Ziel die Instanz wählen, dann den Prio PIN aus Tab Regeln oder Spieler an den Raid geben (nicht Admin Pin!)."
L["Put in your priorities in Spieler tab."] = "Gib jetzt deine Prioritäten in den Spieler Tab ein"
L["When all have entered, go to Regeln - ANZEIGEN,"] = "Wenn alle eingetragen haben, im Tab Regeln ANZEIGEN freischalten,"
L["then to Prioliste and download one of the exports on top, e.g. TXT."] = "dann kann man in der Prioliste oben einen Export downloaden, zB. TXT."
L["Copy&Paste to /prio3 config, Import field"] = "Kopieren&Einfügen in /prio3 config, Import"

L["You could also gather your raid priorities externally, e.g. using Google Doc."] = "Man kann auch die Prioritäten extern sammeln, z.B. über ein Google Doc (oder handschriftlich...)"
L["Generate loot lists in format Username;Prio1;Prio2;Prio3 per line, using ItemIDs or e.g. wowhead links, and use /prio3 config, Import"] = "Daraus eine Liste im Format Username;Prio1;Prio2;Prio3 pro Zeile erstellen, mit ItemIDs oder zB. wowhead links. Danach in /prio3 config, Import einfügen."
L["You could opt to enable sending in priorities by whispers in the same menu, good option also for strugglers or replacement raiders."] = "Man kann die Funktion zum Flüstern von Prioritäten auch gut benutzen für Nachzügler oder Ersatzleute."

-- help texts prio3

L["What is Priority 3 Looting?"] = "Was ist das Prio 3 Lootsystem?"
L["This loot distribution scheme is based on participants choosing up to three items they want to gain priority on when they actually drop."] =  "Bei diesem System zur Lootverteilung wählen die Teilnehmer vor dem Raid bis zu drei Gegenstände, auf die sie eine Priorität erhalten wenn er fällt."
L["It is especially nice for pug raids or raids with a high amount of random fillers, as there is no history, no earning of points, everyone starts the same with every raid. But of course it can also be of value on regular raid groups that do not want the hassle of full DKP tracking or avoid long loot council discussions."] = "Es ist besonders gut geeignet für zufällige oder spontane Raids ohne feste Gruppe, oder wenn man als Stammgruppe mal einen Abend auffüllen muss. Es gibt keine Historie, keine Punkte die man verdienen muss, jeder startet mit derselben Ausgangsgrundlage. Aber es kann natürlich auch von Stammgruppen verwendet werden, die einfach nur spielen und sich nicht um DKP kümmern oder lange in Loot Councils diskutieren wollen."
L["Side note: Prio 3 does not distinguish between main/need and offspec/greed priorities. It can thus be a good choice if you want to collect offspec gear for your char. (Hint: In order to avoid grief on main spec characters who are interested in the same items, it could be better to announce this intention beforehand.)"] = "Randnotiz: Prio 3 kennt keinen Unterschied zwischen Rollen und Zweitnutzung, zwischen Bedarf oder Gier. Es kann gut geeignet sein sich Gegenstände für eine zweite Ausrichtung zu besorgen. (Hinweis: Das kann durchaus schlecht ankommen, wenn zB. Heiler für ihre Rolle dasselbe Item auf Prio nehmen wie Krieger die sonst nichts brauchen für ihr Diamantenfläschchen -- sprecht es besser vorher an.)"
	
L["So, how does this work now?"] = "Also, wie läuft das jetzt?"

L["Before the raid, you will choose (up to) 3 items you want to have priority on."] = "Vor dem Raid wählst du (bis zu) 3 Gegenstände, auf die du Priorität haben willst."
L["Mostly, the raid lead or designated PM is collecting these requests, noting them down. Sometimes a Google Doc is used to post as read only link to users later on."] = "Meist sammelt der Raidleiter oder Plündermeister die Liste ein. Manchmal gibt es ein Google Doc dafür, das im 'nur Lesen' Modus den Spielern geöffnet wird."
L["Prio3 can also be used to collect these requests in-game. See tl;dr tab for a short intro."] = "Prio3 kann die Liste der Gegenstände auf in-game per Flüstern einsammeln. Siehe tl;dr Tab für eine Kurzanleitung."

L["sahne-team.de usage: If you are a German user, please try this website! It eases up coordinating Prio loot a lot."] = "sahne-team.de: Wenn du das hier liest sind die Chancen gut, dass dein Raid deutssprachig ist. Ich empfehle diese Webseite dann sehr. Das vereinfacht Prio3 enorm."
L["You setup a run on the Priorun function to the upper left, select a target instance, and give the Run PIN to your participants."] = "Man legt oben links über Priorun einen neuen Run an, wählt die Zielinstanz und gibt die Prio PIN (nicht Admin Pin!) an die Spieler."
L["Please remember to note down your admin pin from the upper right corner!"] = "Bitte notiere die Admin Pin oben rechts für dich - falls du mal die Seite schliesst!"
L["Every user can choose their items, in secret. Even the admin cannot see those."] = "Jeder Teilnehmer kann jetzt geheim seine Auswahl treffen. Selbst der Admin kann diese nicht sehen."
L["After all participants have chosen their loot, the admin can set the run to be visible for all."] = "Wenn alle Teilnehmer ihre Gegenstände gewählt haben, schaltet der Admin die Anzeige für alle frei."
L["For use with the Prio3 addon, you can then use the Exports."] = "Um das Prio3 Addon zu benutzten kann man die Liste jetzt exportieren."
L["Prio3 native would be CSV Short, but the addon can actually read sahne-team.de full CSV and TXT export as well."] = "Nativ für das Addon wäre CSV Short, aber auch die anderen Formate von sahne-team.de können gelesen werden. CSV öffnet eventuell mit Excel, daher die Empfehlung TXT zu exportieren."
	
L["If the loot drops, it will be handled along the priority table, starting with all users that have this on Priority 1."] = "Wenn Gegner getötet werden die Gegenstände auf Priorität fallen lassen, werden diese anhand der Prioritäten verteilt, beginnend mit Priorität 1."
L["If there is only one user: Congrats, you have a new item."] = "Wenn es nur einen Teilnehmer gibt der den Gegenstände auf Prio 1 hat: Herzlichen Glückwunsch."
L["If there are more users with the same priority, those are asked to roll for the item, highest roll wins."] = "Bei mehreren Teilnehmern mit derselben Priorität wird das Item zwischen diesen verwürfelt."
L["Every user will get only one item per priority. If an items drops a second time, it is handled among the others with the highest remaining priority."] = "Jeder Teilnehmer bekommt nur ein Item pro Priorität. Wenn ein Gegenstand ein zweites Mal droppt (z.B. ZG Götze), wird es zwischen den anderen Teilnehmern mit höchster Priorität vergeben."
L["If no one selected that particular item for Prio 1, then Prio 2 will be handled, and afterwards Prio 3. For all items where no one set a Priority, those are usually handled by FFA. Some raids tend to apply main>offspec here."] = "Wenn niemand einen Gegenstand auf Prio 1 hat, wird danach Prio 2 abgehandelt, dann Prio 3.  Im Anschluss wird typischerweise FFA verrollt, das kann aber nach Raid variieren. Manchmal gilt hier dann Rolle > Zweitnutzung."
L["Of course choosing which items to put where, that is part of the fun, and risk. Do I put this item on Prio 1, because others may want it too? Or it is unlikely, and I can savely put it on Prio 3?"] = "Auf welche Priorität man was nimmt, ist dabei Teil des Spaßes, und des Risikos. Nehme ich diesen Gegenstand auf Prio 1, weil ihn noch andere wollen? Oder ist das unwahrscheinlich, und Prio 3 ist noch sicher genug?"
	
L["Where does the Prio3 addon comes into play?"] = "Was macht das Prio3 Addon denn jetzt?"
L["Looking up if someone actually has marked down a priority can be a tedious task, and it's easy to miss someone."] = "Nachzuschlagen, wer nun welchen Gegenstand auf welcher Priorität hat, ist durchaus mühsam, und man kann leicht mal was übersehen. Gerade wenn die Mitspieler die Liste nicht kennen und nicht direkt nachfragen können kann schnell Mißtrauen gegenüber einem Plündermeister den sie nicht kennen entstehen."
L["The Prio3 addon will notify you on looting if there are any Priorities set up."] = "Das Prio3 Addon gibt in den Raid aus, wenn jemand einen Gegenstand auf Priorität hat. Andere Prio3 Benutzer können die volle Liste einsehen, Benutzer ohne das Addon die Abfrage-Funktionen in-game nutzen um zu sehen wer 'ihren' Gegenstand sonst noch will."
L["This way you don't have to switch to your lookup table, e.g. on a website like sahne-team.de or a google doc, or even a handwritten note. It will announce this to the raid (by default), or only to the char using the addon and looting (should normally be the PM)."] = "Man muss also nicht irgendwo extern, zB. auf sahne-team.de, in einem Google Doc oder sogar in handschriftlichen Notizen nachschlagen."

-- help texts manual

L["IMPORT, or How does the addon know about the priorities?"] = "IMPORT, oder Woher kennt das Addon die Prioritäten?"
	
L["You can import simple CSV strings on the Addon config page (Menu Interfaces, Tab Addon, Prio3)"] = "Man kann einfach CSV-Einträge in das Addon importieren, zB. in /prio3 config"
L["where Prio1, 2, 3 can be numeric item Ids, or even strings with the IDs somewhere in (will take first number found), e.g. wowhead links. This is basically the CSV-SHORT export format of sahne-team.de."] = "wobei Prio1, 2, und 3 entweder die ItemID (Kennzahl) ist, oder Texte oder auch Links mit dieser Zahl (es wird die erste gefundene genommen), zB. Links zu Wowhead. Dies ist im Prinzip das CSV-SHORT Format von sahne-team.de."
L["Also accepted format: sahne-team.de CSV normal export, with german header line:"] = "Ebenfalls möglich: sahne-team.de CSV-Normal Export, mit deutschen Kopfzeilen:"
L["Also accepted format: sahne-team.de TXT export (tab » separated)"] = "Und weiterhin möglich: sahne-team.de TXT Export (Getrennt durch Tab » Zeichen)"
L["If you need further formats, please let me know."] = "Wenn ihr weitere Formate wollt, lasst es mich wissen!"
L["Players can be informed by whispers about imported priorities (configurable in options)"] = "Spieler können durch Flüstern informiert werden über importierte Prioritäten (konfigurierbar)"
L["You could opt for accepting priorities by whisper. Go to Menu Interfaces, Tab Addon, Prio3; or type /prio3 config, and to go Import. This is a good option also for late joiners / replacements. See also tl;dr section."] = "Man kann auch Prioritäten geflüstert annehmen. Im /prio3, Import gibt es die Option dazu. Dies ist auch praktisch für Nachzügler oder Ersatzleute. Siehe tl;dr Tab für eine Kurzanleitung."

L["OUTPUT, or What happens when loot drops"] = "AUSGABEN, oder Was passiert wenn Gegenstände gefunden werden?"

L["You can choose the output language independent of your client languague. Currently only English and German are supported. If you are interested in helping out with another translation, please let me know on http://github.com/dieck/prio3"] = "Man kann die Ausgabesprache unabhängig von der Sprache von WoW festlegen. Aktuell gibt es nur Englisch und Deutsch. Falls du Prio3 in eine andere Sprache übersetzen willst, kontaktiere mich einfach über http://github.com/dieck/prio3"
L["Announcing to Raid is the main functionality. It will post to raid when it encounters loot where someone has a priority on. It will post one line per Priority (1,2,3), with the chars who have listed it."] = "Raid benachrichtigen ist die Haupt-Funktionalität von Prio3. Gefallenene Gegenstände werden an den Raid geschrieben wenn jemand eine Priorität darauf hat. Es wird eine Zeile pro Priorität (1,2,3) ausgegeben, mit allen Spielern die entsprechend gewählt haben."
L["You can also announce if there is No Priority set up for an item."] = "Man kann auch über Gegenstände benachrichtigt werden, für die es keine Priorität gibt."
L["Announces will react to the minimum quality setting. Recommendation: Epic for most raids, Rare for AQ20"] = "Benachrichtigungen können auf eine Mindestqualität gesetzt werden. Empfehlung: Episch für die meisten Raids, Rar für AQ20"
L["You can also whisper to players if there is loot that they have chosen."] = "Man kann den Spielern auch zuflüstern lassen, wenn Gegenstände gefallen sind, die sie gewählt haben."
L["Prio3 will react to loot events (if you open a loot window)"] = "Prio3 reagiert wenn man Gegner plündert, die Gegenstände dabei haben."
L["You can configure it to also react to rolls (if e.g. there is no PM and the roll window starts) and to raid warnings (if e.g. someone else does Master Looter). You can also configure to ignore Onyxia Cloaks posted as raid warnings. Special service for BWL Prio3 runs :)"] = "Man kann einstellen, dass auch auf Würfel-Aufforderungen reagiert wird (z.B. wenn es keinen Plündermeister gibt), sowie auf Raidwarnungen (wenn jemand anders Plündermeister macht und den Gegenstand ankündigt). Man kann auch einstellen, dass der Onyxia-Umhang ignoriert wird, da er häufig in BWL als Raidwarnung angesagt wird :)"
L["In order to avoid multiple posts, e.g. if you loot a corpse twice, there is a mute setting pausing outputs for a defined time."] = "Um mehrfache Benachrichtigungen zu vermeiden, z.B. wenn man einen Gegner zweimal anklickt, kann man eine Stummschaltung einstellen, während der nicht erneut geschrieben wird."
L["For Master Looter, a hint window can be added to the distribution window, showing all priorities for an item"] = "Für Plündermeister gibt es die Option, ein Fenster einzublenden wenn man Gegner plündert, mit allen Prioritäten."
	
L["QUERIES, or How to look up and validate priorities"] = "ABFRAGEN, oder Wie kann ich die Liste einsehen?"

L["For addon users, /prio3 will open up a priority list"] = "Addon-Benutzer können mit /prio3 die aktuelle Liste einsehen"
L["There are three options for your raid participants to query for Prio3 entries (can be turned on and off in options):"] = "Raid-Teilnehmer ohne das Addon können Abfragen an die Addon-Benutzer flüstern (können einzeln konfiguriert):"
L["* Whisper 'prio' to get your own priorities. (default: on)"] = "* Flüstere 'prio' um deine eigenen Prioritäten einzusehen. (Standard: an)"
L["* Whisper 'prio USERNAME' to look up another raid member. (default: off)"] = "* Flüstere 'prio USERNAME' um andere Raidmitglieder abzufragen. (Standard: aus)"
L["* Whisper 'prio ITEMLINK' to look up priorities on an item. (default: on)"] = "* Flüstere 'prio ITEMLINK' um zu erfahren wer Prioritäten auf einem Gegenstand hat. (Standard: an)"
L["(If you don't get an answer at all, ask your Prio3 master if they turned on the options)"] = "(Wenn man überhaupt keine Antwort bekommt, fragt den Prio3 Benutzer ob er die Einstellungen deaktiviert hat.)"
	
L["SYNC & HANDLER, or How does this work with multiple people"] = "SYNC & HANDLER, oder Wie funktioniert das wenn mehrere Leute das Addon haben?"

L["Here are two options to handle how the addon talks to other users in the same raid. It is HIGHLY recommended to leave both turned on."]  = "Hier findet man zwei Optionen die festlegen, wie mehrere Addons im Raid miteinander umgehen. Es wird UNBEDINGT empfohlen, diese Einstellungen aktiviert zu lassen."
L["Sync priorities will sync the list of items between multiple users, on import / end of accepting whispers. Without this option, multiple users could have different priorities, and depending on the next option it might not be clear whose are posted."] = "Prioritäten synchronisieren überträgt die Liste der Prioritäten an andere Addon-Benutzer, beim Import bzw. bei Beenden von akzeptiertem Flüstern. Ohne diese Einstellung könnten unterschiedliche Benutzer verschiedene Listen an Prioritäten haben und verwirrende unterschiedliche Benachrichtigungen ausgeben."
L["The Resend prios button will send out Prios if needed - normally when someone new with the addon joins the raid, it will be synced automatically. But if the disabled the addon and turns it on later, you can send out your priorities with this."] = "Neu senden schickt die Liste erneut an andere Raidmitglieder. Normalerweise synchronisiert sich ein neu hinzukommendes Addon wenn man einen Raid betritt, aber falls das Addon zb. deaktiviert war und später zugeschaltet wird, kann man die Prioritäten erneut aussenden."
L["Sync item announcements will coordinate between multiple users' addons which user will actually post to raid (depending on output options). This is to avoid multiple posts of the same information. (May still happen though if addon communication is lagging slightly)."] = "Ausgaben synchronisieren koordiniert zwischen den Addons mehrere User, wer eine Benachrichtigung sendet. Dies verhindert mehrere gleichzeitige Nachrichten über dieselben Prioritäten. (Kann immer noch selten vorkommen, wenn etwas Lag in der Kommunikation der Addons ist)"
L["Also, you can opt to use /prio or /p3 in addition to /prio3 as command line trigger."] = "Ebenfalls hier kann man festlegen, dass das Addon, zusätzlich zu /prio3, auch auf /prio oder /p3 hört."
	
L["and more"] = "und sonst?"
	
L["There is a 'Versions' tab in the options, which is basically only there for debugging purposes."] = "Es gibt einen Tab mit einer Versionsübesicht für andere Addons im Raid. Dies dient in erster Linie für Debug."
L["Users are notified if they have an older version of the application."] = "Benutzer werden informiert, wenn sie ein älteres Addon benutzen als andere Mitspieler."
L["Until now, all addon synchronisation features were backwards compatible. If this changes at some point in time, a comprehensive error message will be put in place"] = "Bis jetzt sind alle Synchronisations-Features des Addons immer abwärtskompatibel. Wenn sich das einmal ändern sollte, wird das Addon mit einer aussagekräftigen Fehlermeldung darauf aufmerksam machen."


-- load default outputs 
for k,v in pairs(Prio3.outputLocales["deDE"]) do L[k] = v end


end
