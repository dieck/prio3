local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

-- import priorities
function Prio3:SetPriorities(info, value)

	Prio3.db.profile.priorities = {}

	-- possible formats:

	-- Default:
	-- sahne-team.de "CSV SHORT" export
	-- Rhako;19885;19890;22637

	-- sahne-team.de "CSV" export
	-- Name;Klasse;prio1itemid;prio2itemid;prio3itemid;prio1itemname;prio2itemname;prio3itemname;
	-- Rhako;Druide;19885;19890;22637;Jin´dos Auge des Bösen;Jin´dos Verhexer;Urzeitlicher Hakkarigötze;
	-- WARNING: This format might not work with less than 3 prios.

	-- sahne-team.de TXT export
	-- Rhako\t\tDruide\t\tJin´dos Auge des Bösen-19885\tJin´dos Verhexer-19890\tUrzeitlicher Hakkarigötze-22637


	-- determine format first. Parse first line

	local firstline = strsplit("\r\n", value)
	local formatType = "CSV-SHORT" -- default

	if string.match(firstline, 'Name;Klasse;prio1itemid;prio2itemid;prio3itemid;prio1itemname;prio2itemname;prio3itemname;') then
		formatType = "CSV";
	else
		-- at least three tab separated values: assume TXT. If there will be more supported formats with Tab, will need to reassess
		-- I am not sure why, but "[^\t]\t+[^\t]+\t+[^\t]" did work in LUA interpreters but not in WoW.
		-- So, resorting to other methods, replaceing all tabs and all multi-spaces by & (I wanted to use ; but then it identified CSV-SHORT as TXT here)
		local fl = string.gsub(firstline, "[\t]+", "&")
		fl = string.gsub(fl, "%s%s+", "&")
		if string.match(fl, ".*&.*&.*") then
			formatType = "TXT";
		end
	end

	Prio3:Debug("using Format Type " .. formatType)

	-- parse lines, and handle individually (SetPriority)
	local lines = { strsplit("\r\n", value) }

	for k,line in pairs(lines) do

	    if not (line == nil or strtrim(line) == '') then
			Prio3:Debug("will set up " .. line)
			Prio3:SetPriority(info, line, formatType)
		else
			Prio3:Debug("line is empty: " .. line)
		end

	end

	self.db.profile.prioimporttime = time()
	Prio3:sendPriorities()

	-- open window after import, if configured in options
	if Prio3.db.profile.opentable then
		Prio3:guiPriorityFrame()
	end

end


function Prio3:toPriorityId(s)
	for id in string.gmatch(s, "%d+") do

		-- there are some items that are rewards from quest items
		-- sahne-team e.g. allows for selecting the rewards directly
		-- match to drop item, so it will be listed correctly on drops

		id = tonumber(id)

		-- Heart of Hakkar for Zandalarion Hero trinkets
		if id == 19948 then id = 19802 end
		if id == 19949 then id = 19802 end
		if id == 19950 then id = 19802 end

		-- Head of Onyxia items, depending on faction
		if id == 18403 and UnitFactionGroup("player") == 'Horde' then id = 18422 end
		if id == 18404 and UnitFactionGroup("player") == 'Horde' then id = 18422 end
		if id == 18405 and UnitFactionGroup("player") == 'Horde' then id = 18422 end
		if id == 18403 and UnitFactionGroup("player") == 'Alliance' then id = 18423 end
		if id == 18404 and UnitFactionGroup("player") == 'Alliance' then id = 18423 end
		if id == 18405 and UnitFactionGroup("player") == 'Alliance' then id = 18423 end

		-- Head of Onyxia, wrong faction chosen
		if id == 18423 and UnitFactionGroup("player") == 'Horde' then id = 18422 end
		if id == 18422 and UnitFactionGroup("player") == 'Alliance' then id = 18423 end

		-- Head of Nefarian items, depending on faction
		if id == 19383 and UnitFactionGroup("player") == 'Horde' then id = 19002 end
		if id == 19366 and UnitFactionGroup("player") == 'Horde' then id = 19002 end
		if id == 19384 and UnitFactionGroup("player") == 'Horde' then id = 19002 end
		if id == 19383 and UnitFactionGroup("player") == 'Alliance' then id = 19003 end
		if id == 19366 and UnitFactionGroup("player") == 'Alliance' then id = 19003 end
		if id == 19384 and UnitFactionGroup("player") == 'Alliance' then id = 19003 end

		-- Head of Nefarian, wrong faction chosen
		if id == 19003 and UnitFactionGroup("player") == 'Horde' then id = 19002 end
		if id == 19002 and UnitFactionGroup("player") == 'Alliance' then id = 19003 end

		-- Head of Ossirian the Unscarred
		if id == 21504 then id = 21220 end
		if id == 21505 then id = 21220 end
		if id == 21506 then id = 21220 end
		if id == 21507 then id = 21220 end

		-- there are quite some more... All AQ tokens, ZG tokens and so on
		-- but for now I'll only list the most common mistakes here.

		GetItemInfo(id) -- firing server-side request here, so it can start getting cached early
		return id
	end
end

function Prio3:OutputUserPrio(user, channel)
	local itemLinks =  {}

	local p1, p2, p3 = unpack(Prio3.db.profile.priorities[user])

	local itemLink1 = GetItemInfo(p1)

	table.insert(itemLinks, itemLink1)

	local itemLink2 = ""
	local itemLink3 = ""
	if p2 then
		itemLink2 = GetItemInfo(p2)
		table.insert(itemLinks, itemLink2)
	end
	if p3 then
		itemLink3 = GetItemInfo(p3)
		table.insert(itemLinks, itemLink3)
	end

	local existAll = itemLink1 and (itemLink2 or not p2) and (itemLink3 or not p3)
	if existAll then

		SendChatMessage(L["Priorities of username: list"](user,table.concat(itemLinks,", ")), channel, nil, user)

	else

		local t = {
			needed_itemids = Prio3.db.profile.priorities[user],
			vars = { u = user },
			todo = function(itemlinks,vars)
				SendChatMessage(L["Priorities of username: list"](vars["u"],table.concat(itemlinks,", ")), channel, nil, vars["u"])
			end,
		}
		table.insert(Prio3.GET_ITEM_INFO_RECEIVED_TodoList, t)

	end

end

function Prio3:HandleNewPriorities(user, prio1, prio2, prio3, origin)
	-- avoid Priorities being nil, if not all are used up
	local p1 = 0
	local p2 = 0
	local p3 = 0

	if user == nil then
		Prio3:Debug("DEBUG: No user found in " .. origin)
	else
		user = strtrim(user)

		if prio1 == nil then
			Prio3:Debug("DEBUG: No prio1 found in " .. origin)
		else
			p1 = Prio3:toPriorityId(prio1)
			Prio3:Debug("DEBUG: Found PRIORITY 1 ITEM " .. p1 .. " for user " .. user .. " in " .. origin)
		end
		if prio2 == nil then
			Prio3:Debug("DEBUG: No prio2 found in " .. origin)
		else
			p2 = Prio3:toPriorityId(prio2)
			Prio3:Debug("DEBUG: Found PRIORITY 2 ITEM " .. p2 .. " for user " .. user .. " in " .. origin)
		end
		if prio3 == nil then
			Prio3:Debug("DEBUG: No prio3 found in " .. origin)
		else
			p3 = Prio3:toPriorityId(prio3)
			Prio3:Debug("DEBUG: Found PRIORITY 3 ITEM " .. p3 .. " for user " .. user .. " in " .. origin)
		end

		Prio3.db.profile.priorities[user] = {p1, p2, p3}

		-- whisper if player is in RAID, oder in debug mode to player char
		if Prio3.db.profile.whisperimport and ((Prio3.db.profile.debug and user == UnitName("player")) or UnitInRaid(user)) then
			Prio3:OutputUserPrio(user, "WHISPER")
		end

	end

end

-- parse incoming priorities
function Prio3:SetPriority(info, line, formatType)
	local user, prio1, prio2, prio3, dummy

	if formatType == "CSV-SHORT" then
		user, prio1, prio2, prio3 = strsplit(";", line)
	end
	if formatType == "CSV" then
		user, dummy, prio1, prio2, prio3 = strsplit(";", line)
		-- do not parse header line
		if dummy == "Klasse" then
			return
		end
	end
	if formatType == "TXT" then
		-- replace tabs and multi-spaces by &
		local linecsv = string.gsub(line, "[\t]+", "&")
		linecsv = string.gsub(linecsv, "%s%s+", "&")
		-- will be enough: toPriorityId below will parse number from string
		user, dummy, prio1, prio2, prio3 = strsplit("&", linecsv)
	end

	Prio3:HandleNewPriorities(user, prio1, prio2, prio3, line)

end


function Prio3:ParseWhisperLine(sender, line)
	-- check if we would accept from this user anyway
	if Prio3.db.profile.acceptwhisperprios_new then
		if Prio3.db.profile.priorities[sender] ~= nil then
			-- prios already set for this user, and not accepting overwrites
			return nil
		end
	end

	-- to avoid loops, filter out L["Priorities of username: list"] outputs. Well, part of it.
	if line:match(UnitName("player") .. ":") then return nil end

	-- look for item links:
	-- should look like |cff9d9d9d|Hitem:3299::::::::20:257::::::|h[Fractured Canine]|h|rno
	-- so, look for 1, 2 or 3 itemLinks (Might be Prio2 or Prio1 run, or user does not want to set all prios)
	-- nesting matches for 2 and 3 doesn't seem to work properly, so taking the long road

	local p1, p2, p3 = line:match("|Hitem:(%d+):.-|Hitem:(%d+):.-|Hitem:(%d+):")
	if (p3 ~= nil) then return Prio3:HandleNewPriorities(sender, p1, p2, p3, line) end

	p1, p2 = line:match("|Hitem:(%d+):.-|Hitem:(%d+):")
	if (p2 ~= nil) then	return Prio3:HandleNewPriorities(sender, p1, p2, nil, line) end

	p1 = line:match("|Hitem:(%d+):")
	if (p1 ~= nil) then return Prio3:HandleNewPriorities(sender, p1, nil, nil, line) end

	-- ok, no itemlink. Let's look for wowhead links
	-- should look like https://classic.wowhead.com/item=19351/maladath-runed-blade-of-the-black-flight or https://de.classic.wowhead.com/item=2482/minderwertiger-tomahawk
	-- same as above, nested matching seems not to work properly

	p1, p2, p3 = line:match("item=(%d+).-item=(%d+).-item=(%d+)")
	if (p3 ~= nil) then return Prio3:HandleNewPriorities(sender, p1, p2, p3, line) end

	p1, p2 = line:match("item=(%d+).-item=(%d+)")
	if (p2 ~= nil) then return Prio3:HandleNewPriorities(sender, p1, p2, nil, line) end

	p1 = line:match("item=(%d+)")
	if (p1 ~= nil) then return Prio3:HandleNewPriorities(sender, p1, nil, nil, line) end

	-- finally, look if we find 3 numbers that look feasible

	p1, p2, p3 = line:match("(%d+).-(%d+).-(%d+)")
	if (p3 ~= nil) then return Prio3:HandleNewPriorities(sender, p1, p2, p3, line) end

	p1, p2 = line:match("(%d+).-(%d+)")
	if (p2 ~= nil) then return Prio3:HandleNewPriorities(sender, p1, p2, nil, line) end

	p1 = line:match("(%d+)")
	if (p1 ~= nil) then return Prio3:HandleNewPriorities(sender, p1, nil, nil, line) end

end

