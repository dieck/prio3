Prio3 = LibStub("AceAddon-3.0"):NewAddon("Prio3", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

local defaults = {
  profile = {
    enabled = true,
    debug = false,
	raidannounce = true,
	noprioannounce = false,
	ignorereopen = 90,
	charannounce = false,
	whisperimport = false,
	queryself = true,
	queryraid = false,
	queryitems = true,
	opentable = false,
  }
}

function Prio3:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("Prio3DB", defaults)
	
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Prio3", prioOptionsTable)
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Prio3", "Prio3")
  self:RegisterChatCommand("prio", "ChatCommand")
   
  Prio3:RegisterEvent("LOOT_OPENED")
  Prio3:RegisterEvent("CHAT_MSG_WHISPER")
 
  Prio3:RegisterChatCommand('prio3', 'handleChatCommand');
end

function Prio3:OnEnable()
    -- Called when the addon is enabled
end

function Prio3:OnDisable()
    -- Called when the addon is disabled
end


-- config items

prioOptionsTable = {
  type = "group",
  args = {
    enable = {
      name = L["Enabled"],
      desc = L["Enables / disables the addon"],
      type = "toggle",
	  order = 10,
      set = function(info,val) Prio3.db.profile.enabled = val end,
      get = function(info) return Prio3.db.profile.enabled end,
    },
	grpoutput = {    
		type = "group",
		name = "Output",
		args = {
			raid = {
				name = L["Announce to Raid"],
				desc = L["Announces Loot Priority list to raid chat"],
				type = "toggle",
				order = 20,
				set = function(info,val) Prio3.db.profile.raidannounce = val end,
				get = function(info) return Prio3.db.profile.raidannounce end
			},
			newline1 = { name="", type="description", order=21 },
			noprio = {
			  name = L["Announce No Priority"],
			  desc = L["Announces if there is no priority on an item. Be careful: Will trigger on all mobs, not only bosses..."],
			  type = "toggle",
			  order = 30,
			  set = function(info,val) Prio3.db.profile.noprioannounce = val end,
			  get = function(info) return Prio3.db.profile.noprioannounce end,
			},
			newline2 = { name="", type="description", order=31 },
			whisper = {
				name = L["Whisper to Char"],
				desc = L["Announces Loot Priority list to char by whisper"],
				type = "toggle",
				order = 35,
				set = function(info,val) Prio3.db.profile.charannounce = val end,
				get = function(info) return Prio3.db.profile.charannounce end
			},
			newline3 = { name="", type="description", order=36 },
			reopen = {
				name = L["Mute (sec)"],
				desc = L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."],
				type = "range",
				min = 0, 
				max = 600,
				step = 1,
				bigStep = 15,
				order = 40,
				set = function(info,val) Prio3.db.profile.ignorereopen = val end,
				get = function(info) return Prio3.db.profile.ignorereopen end
			},
		}
	},
	grpquery = {
		type = "group",
		name = "Queries",
		args = {
			queryself = {
				name = L["Query own priority"],
				desc = L["Allows to query own priority. Whisper prio."],
				type = "toggle",
				order = 60,
				set = function(info,val) Prio3.db.profile.queryself = val end,
				get = function(info) return Prio3.db.profile.queryself end,
			},
			newline1 = { name="", type="description", order=61 },
			queryraid = {
				name = L["Query raid priorities"],
				desc = L["Allows to query priorities of all raid members. Whisper prio CHARNAME."],
				type = "toggle",
				order = 63,
				set = function(info,val) Prio3.db.profile.queryraid = val end,
				get = function(info) return Prio3.db.profile.queryraid end,
			},
			newline2 = { name="", type="description", order=64 },
			queryitems = {
				name = L["Query item priorities"],
				desc = L["Allows to query own priority. Whisper prio ITEMLINK."],
				type = "toggle",
				order = 65,
				set = function(info,val) Prio3.db.profile.queryitems = val end,
				get = function(info) return Prio3.db.profile.queryitems end,
			},
			newline3 = { name="", type="description", order=66 },
			showtable = {
				name = L["Show prio table"],
				type = "execute",
				order = 99,
				func = function(info) Prio3:guiPriorityFrame() end,
			},
		}
	},
	grpimport = {
		type = "group",
		name = "Import",
		args = {
			newprio = {
				name = L["Import String"],
				desc = L["Please note that current Prio settings WILL BE OVERWRITTEN"],
				type = "input",
				order = 50,
				confirm = true,
				width = 3.0,
				multiline = true,
				set = function(info, value) 
					Prio3:SetPriorities(info, value) 
				end,
				usage = L["Enter new exported string here to configure Prio3 loot list"],
				cmdHidden = true,
			},
			newline1 = { name="", type="description", order=51 },
			newwhispers = {
				name = L["Whisper imports"],
				desc = L["Whisper imported items to player"],
				type = "toggle",
				order = 55,
				set = function(info,val) Prio3.db.profile.whisperimport = val end,
				get = function(info) return Prio3.db.profile.whisperimport end,
			},
			newline2 = { name="", type="description", order=56 },
			opentable = {
				name = L["Open prio table after import"],
				type = "toggle",
				order = 75,
				set = function(info,val) Prio3.db.profile.opentable = val end,
				get = function(info) return Prio3.db.profile.opentable end,
			},
			newline3 = { name="", type="description", order=76 },
			showtable = {
				name = L["Show prio table"],
				type = "execute",
				order = 99,
				func = function(info) Prio3:guiPriorityFrame() end,
			},
		}
	},
	
    debugging = {
      name = L["Debug"],
      desc = L["Enters Debug mode. Addon will have advanced output, and work outside of Raid"],
      type = "toggle",
      order = 99,
      set = function(info,val) Prio3.db.profile.debug = val end,
      get = function(info) return Prio3.db.profile.debug end
    },
  }
}

function Prio3:IsEmpty(s) 
	return s == nil or strtrim(s) == ''
end

function Prio3:SetPriorities(info, value)

	self.db.profile.priorities = {}
	
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
		-- So, resorting to other methods, replaceing all tabs and all multi-spaces by & (I wanted to use ;, but then it identified CSV-SHORT as TXT here)
		fl = string.gsub(firstline, "[\t]+", "&")
		fl = string.gsub(fl, "%s%s+", "&")
		if string.match(fl, ".*&.*&.*") then 
			formatType = "TXT";
		end
	end                                           
	
	if Prio3.db.profile.debug then Prio3:Print("DEBUG: using Format Type " .. formatType) end
		
	-- parse lines
	local lines = { strsplit("\r\n", value) }

	for k,line in pairs(lines) do
	
	    if not (line == nil or strtrim(line) == '') then
			if Prio3.db.profile.debug then Prio3:Print("DEBUG: will set up " .. line) end
			Prio3:SetPriority(info, line, formatType)
		else
			if Prio3.db.profile.debug then Prio3:Print("DEBUG: line is empty: " .. line) end
		end
	
	end
				
	Prio3.priorities = value
	
	if Prio3.db.profile.opentable then
		Prio3:guiPriorityFrame()
	end
	
end

function Prio3:GetItemlink(itemid) 
	-- it seems the first time I call GetItemInfo after a relog (not reload, that works), I get a NIL value
	-- maybe some weird interaction with another addon. (Auctioneer, TSM, Bagnon? Who knows)
	-- so, I'll just wrap it three times.
	
	local itemName, itemLink = nil
	local cnt = 0
	
	while itemLink == nil and cnt <= 3 do
		itemName, itemLink = GetItemInfo(itemid)
		cnt = cnt + 1
	end

	return itemLink
end

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
		for id in string.gmatch(s, "%d+") do return id end
	end

	-- avoid Priorities being nil, if not all are used up
	p1 = 0
	p2 = 0
	p3 = 0
	
	if user == nil then	
		if Prio3.db.profile.debug then Prio3:Print("DEBUG: No user found in " .. line) end
	else
		user = strtrim(user)
		
		if prio1 == nil then
			if Prio3.db.profile.debug then Prio3:Print("DEBUG: No prio1 found in " .. line) end
		else
			p1 = toId(prio1) 
			if Prio3.db.profile.debug then Prio3:Print("DEBUG: Found PRIORITY 1 ITEM " .. p1 .. " for user " .. user .. " in " .. line) end
		end
		if prio2 == nil then
			if Prio3.db.profile.debug then Prio3:Print("DEBUG: No prio2 found in " .. line) end
		else
			p2 = toId(prio2) 
			if Prio3.db.profile.debug then Prio3:Print("DEBUG: Found PRIORITY 2 ITEM " .. p2 .. " for user " .. user .. " in " .. line) end
		end
		if prio3 == nil then
			if Prio3.db.profile.debug then Prio3:Print("DEBUG: No prio3 found in " .. line) end
		else
			p3 = toId(prio3) 
			if Prio3.db.profile.debug then Prio3:Print("DEBUG: Found PRIORITY 3 ITEM " .. p3 .. " for user " .. user .. " in " .. line) end
		end
		
		self.db.profile.priorities[user] = {p1, p2, p3}
	
		-- whisper if player is in RAID, oder in debug mode to player char
		if Prio3.db.profile.whisperimport and ((Prio3.db.profile.debug and user == UnitName("player")) or UnitInRaid(user)) then
			local itemLink = Prio3:GetItemlink(p1)
			local whisperlinks = itemLink
			local itemLink = Prio3:GetItemlink(p2)
			if (itemLink) then whisperlinks = whisperlinks .. ", " .. itemLink end
			local itemLink = Prio3:GetItemlink(p3)
			if (itemLink) then whisperlinks = whisperlinks .. ", " .. itemLink end
-- currently deactivated due to GetItemLink vs. GET_ITEM_INFO_RECEIVED event issues
--			SendChatMessage(L["Priorities of username: list"](user,whisperlinks), "WHISPER", nil, user)
		end
		
	end
		
end


-- Loot handling functions

function Prio3:LOOT_OPENED()
	-- disabled?
    if not self.db.profile.enabled then
	  return
	end

	-- only works in raid, unless debugging
	if not UnitInRaid("player") and not self.db.profile.debug then
	  return
	end

	-- look if priorities are defined
	if self.db.profile.priorities == nil then
		Prio3:Print(L["No priorities defined."])	
		return
	end

	
	-- process the event
	loot = GetLootInfo()
	numLootItems = GetNumLootItems();

	for i=1,numLootItems do 
		Prio3:HandleLoot(i)
	end
	
end

function Prio3:Output(msg)
	if Prio3.db.profile.raidannounce and UnitInRaid("player") then
		SendChatMessage(msg, "RAID")
	else
		Prio3:Print(msg)
	end
end

function Prio3:Announce(itemLink, prio, chars, hasPreviousPrio) 

	-- output to raid or print to user
	msg = L["itemLink is at priority for users"](itemLink, prio, chars)
	Prio3:Output(msg)

	-- whisper to characters
	local whispermsg = L["itemlink dropped. You have this on priority x."](itemLink, prio)
	
	-- add request to roll, if more than one user and no one has a higher priority
	-- yes, this will ignore the fact you might have to roll if higher priority users already got that item on another drop. But well, this doesn't happen very often.
	if not hasPreviousPrio and table.getn(chars) >= 2 then whispermsg = whispermsg .. " " .. L["Please /roll now!"] end
		
	if Prio3.db.profile.charannounce then
		for dummy, chr in pairs(chars) do
			-- whisper if target char is in RAID. In debug mode whisper only to your own player char
			if (UnitInRaid(chr)) or (Prio3.db.profile.debug and chr == UnitName("player")) then
				SendChatMessage(whispermsg, "WHISPER", nil, chr);
			else
				if Prio3.db.profile.debug then Prio3:Print("DEBUG: " .. chr .. " not in raid, will not send out whisper notification") end
			end
		end	
	end
	
end

function Prio3:HandleLoot(slotid) 

	itemLink = GetLootSlotLink(slotid)

	-- Loot found, but no itemLink: most likely money
	if itemLink == nil then
		return
	end
	
	local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, linkLevel, specializationID, reforgeId, unknown1, unknown2 = strsplit(":", itemLink)
	-- bad argument, might be gold? (or copper, here)
	

	if Prio3.db.profile.debug then Prio3:Print("DEBUG: Found item " .. itemLink .. " => " .. itemId) end

	-- ignore re-opened
	-- re-open is processed by Item
	
	-- initialization of tables
	if self.db.profile.lootlastopened == nil then
		self.db.profile.lootlastopened = {}
	end
	if self.db.profile.lootlastopened[itemId] == nil then
		self.db.profile.lootlastopened[itemId] = 0
	end
	
	if self.db.profile.ignorereopen == nil then
		self.db.profile.ignorereopen = 0
	end

	if self.db.profile.lootlastopened[itemId] + self.db.profile.ignorereopen < time() then
	-- enough time has passed, not ignored.
	
		-- build local prio list
		local itemprios = {
			p1 = {},
			p2 = {},
			p3 = {}
		}
		
		-- iterate over priority table
		for user, prios in pairs(self.db.profile.priorities) do
		
			-- table always has 3 elements
			if (tonumber(prios[1]) == tonumber(itemId)) then
				table.insert(itemprios.p1, user)
			end
			if (tonumber(prios[2]) == tonumber(itemId)) then
				table.insert(itemprios.p2, user)
			end
			if (tonumber(prios[3]) == tonumber(itemId)) then
				table.insert(itemprios.p3, user)
			end
			
		end
				
		if table.getn(itemprios.p1) == 0 and table.getn(itemprios.p2) == 0 and table.getn(itemprios.p3) == 0 then
			if Prio3.db.profile.noprioannounce then
				Prio3:Output(L["No priorities found for playerOrItem"](itemLink))	
			end
		end
		if table.getn(itemprios.p1) > 0 then
			Prio3:Announce(itemLink, 1, itemprios.p1)	
		end
		if table.getn(itemprios.p2) > 0 then
			Prio3:Announce(itemLink, 2, itemprios.p2, (table.getn(itemprios.p1) > 0))	
		end
		if table.getn(itemprios.p3) > 0 then
			Prio3:Announce(itemLink, 3, itemprios.p3, (table.getn(itemprios.p1)+table.getn(itemprios.p2) > 0))	
		end

	else
		if self.db.profile.debug then Prio3:Print("DEBUG: Item " .. itemLink .. " ignored because of mute time setting") end
	end
	
	self.db.profile.lootlastopened[itemId] = time()
	
end

-- query functions

function Prio3:QueryUser(username, whisperto) 
	local priotab = self.db.profile.priorities[username]

	if not priotab then
		SendChatMessage(L["No priorities found for playerOrItem"](username), "WHISPER", nil, whisperto)
		
	else	
		local linktab = {}
		for dummy,prio in pairs(priotab) do
			
			local itemName, itemLink = GetItemInfo(prio)
			table.insert(linktab, itemLink)
		end
		whisperlinks = table.concat(linktab, ", ")
		SendChatMessage(L["Priorities of username: list"](username, whisperlinks), "WHISPER", nil, whisperto)
	end
end

function Prio3:QueryItem(item, whisperto) 
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item)
	local itemID = select(3, strfind(itemLink, "item:(%d+)"))
	
	local prios = {}
	
	for username,userprio in pairs(self.db.profile.priorities) do
		for pr,item in pairs(userprio) do
			if item == itemID then
				table.insert(prios, username .. " (" .. pr .. ")")
			end
		end
	end
	
	if table.getn(prios) > 0 then
		SendChatMessage(L["itemLink on Prio at userpriolist"](itemLink, table.concat(prios, ", ")), "WHISPER", nil, whisperto)
	else
		SendChatMessage(L["No priorities found for playerOrItem"](itemLink), "WHISPER", nil, whisperto)
	
	end
	
end


function Prio3:CHAT_MSG_WHISPER(event, text, playerName)
	-- playerName may contain "-REALM"
	playerName = strsplit("-", playerName)
	
	if self.db.profile.queryself and string.upper(text) == "PRIO" then
		return Prio3:QueryUser(playerName, playerName)
	end
	
	local cmd, qry = strsplit(" ", text, 2)
	cmd = string.upper(cmd)
		
	if cmd == "PRIO" then
	
		local function strcamel(s)
			return string.upper(string.sub(s,1,1)) .. string.lower(string.sub(s,2))
		end
	
		if qry and UnitInRaid(qry) and self.db.profile.queryraid then
			return Prio3:QueryUser(strcamel(qry), playerName) 
		end
				
		if qry and GetItemInfo(qry) and self.db.profile.queryitems then
			return Prio3:QueryItem(qry, playerName) 
		end
	
	end
	
end
