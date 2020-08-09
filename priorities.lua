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
		fl = string.gsub(firstline, "[\t]+", "&")
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
		linecsv = string.gsub(line, "[\t]+", "&")
		linecsv = string.gsub(linecsv, "%s%s+", "&")
		-- will be enough: toId below will parse number from string
		user, dummy, prio1, prio2, prio3 = strsplit("&", linecsv)		
	end
	
	local function toId(s) 
		for id in string.gmatch(s, "%d+") do 
		
			-- there are some items that are rewards from quest items
			-- sahne-team e.g. allows for selecting the rewards directly
			-- match to dop item, so it will be listed correctly on drops
		
			-- Heart of Hakkar for Zandalarion Hero trinkets
		    if id == 19948 then id = 19802 end
		    if id == 19949 then id = 19802 end
		    if id == 19950 then id = 19802 end

			-- Head of Onyxia, depending on faction
			if id == 18403 and UnitFactionGroup(player) == 'Horde' then id = 18422 end
			if id == 18404 and UnitFactionGroup(player) == 'Horde' then id = 18422 end
			if id == 18405 and UnitFactionGroup(player) == 'Horde' then id = 18422 end
			if id == 18403 and UnitFactionGroup(player) == 'Alliance' then id = 18423 end
			if id == 18404 and UnitFactionGroup(player) == 'Alliance' then id = 18423 end
			if id == 18405 and UnitFactionGroup(player) == 'Alliance' then id = 18423 end

			-- Head of Nefarian, depending on faction
			if id == 19383 and UnitFactionGroup(player) == 'Horde' then id = 19002 end
			if id == 19366 and UnitFactionGroup(player) == 'Horde' then id = 19002 end
			if id == 19384 and UnitFactionGroup(player) == 'Horde' then id = 19002 end
			if id == 19383 and UnitFactionGroup(player) == 'Alliance' then id = 19003 end
			if id == 19366 and UnitFactionGroup(player) == 'Alliance' then id = 19003 end
			if id == 19384 and UnitFactionGroup(player) == 'Alliance' then id = 19003 end

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

	-- avoid Priorities being nil, if not all are used up
	p1 = 0
	p2 = 0
	p3 = 0
	
	if user == nil then	
		Prio3:Debug("DEBUG: No user found in " .. line) 
	else
		user = strtrim(user)
		
		if prio1 == nil then
			Prio3:Debug("DEBUG: No prio1 found in " .. line) 
		else
			p1 = toId(prio1) 
			Prio3:Debug("DEBUG: Found PRIORITY 1 ITEM " .. p1 .. " for user " .. user .. " in " .. line) 
		end
		if prio2 == nil then
			Prio3:Debug("DEBUG: No prio2 found in " .. line) 
		else
			p2 = toId(prio2) 
			Prio3:Debug("DEBUG: Found PRIORITY 2 ITEM " .. p2 .. " for user " .. user .. " in " .. line) 
		end
		if prio3 == nil then
			Prio3:Debug("DEBUG: No prio3 found in " .. line) 
		else
			p3 = toId(prio3) 
			Prio3:Debug("DEBUG: Found PRIORITY 3 ITEM " .. p3 .. " for user " .. user .. " in " .. line) 
		end
		
		Prio3.db.profile.priorities[user] = {p1, p2, p3}
	
		-- whisper if player is in RAID, oder in debug mode to player char
		if Prio3.db.profile.whisperimport and ((Prio3.db.profile.debug and user == UnitName("player")) or UnitInRaid(user)) then
			local itemLinks =  {}
			local itemName1, itemLink1 = GetItemInfo(p1)
			
			table.insert(itemLinks, itemLink1)
			
			local itemName2, itemLink2 = ""
			local itemName3, itemLink3 = ""
			if p2 then
				itemName2, itemLink2 = GetItemInfo(p2)
				table.insert(itemLinks, itemLink2)
			end
			if p3 then
				itemName3, itemLink3 = GetItemInfo(p3)
				table.insert(itemLinks, itemLink3)
			end

			local existAll = itemLink1 and (itemLink2 or not p2) and (itemLink3 or not p3)
			if existAll then
				
				SendChatMessage(L["Priorities of username: list"](user,table.concat(itemLinks,", ")), "WHISPER", nil, user)
	
			else

				local t = {
					needed_itemids = Prio3.db.profile.priorities[user],
					vars = { u = user },
					todo = function(itemlinks,vars) 
						SendChatMessage(L["Priorities of username: list"](vars["u"],table.concat(itemlinks,", ")), "WHISPER", nil, vars["u"])
					end,
				}
				table.insert(Prio3.GET_ITEM_INFO_RECEIVED_TodoList, t)
			
			end

		end
		
	end
		
end


