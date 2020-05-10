Prio3 = LibStub("AceAddon-3.0"):NewAddon("Prio3", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

local defaults = {
  profile = {
    enabled = true,
    debug = false,
	raidannounce = true,
	noprioannounce = false,
	ignorereopen = 90,
  }
}

function Prio3:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("Prio3DB", defaults)
	
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Prio3", prioOptionsTable)
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Prio3", "Prio3")
  self:RegisterChatCommand("prio", "ChatCommand")
   
  Prio3:RegisterEvent("LOOT_OPENED")

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
    noprio = {
      name = L["Announce No Priority"],
      desc = L["Enables / disables the addon"],
      type = "toggle",
	  order = 20,
      set = function(info,val) Prio3.db.profile.noprioannounce = val end,
      get = function(info) return Prio3.db.profile.noprioannounce end,
    },
	raid = {
		name = L["Announce to Raid"],
		desc = L["Announces Loot Priority list to raid chat"],
		type = "toggle",
		order = 30,
		set = function(info,val) Prio3.db.profile.raidannounce = val end,
		get = function(info) return Prio3.db.profile.raidannounce end
	},
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
	newprio = {
		name = L["Loot prio list"],
		desc = L["Please note that current Prio settings WILL BE OVERWRITTEN"],
		type = "input",
		order = 50,
		confirm = true,
		width = full,
		multiline = true,
		set = function(info, value) 
			Prio3:SetPriorities(info, value) 
		end,
		get = function(info) return L["Enter new exported string here to configure Prio3 loot list"] end,
		cmdHidden = true,
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
	
	-- remove introduction text if it happens to be there (pasted afterwards)
	local intro = prioOptionsTable.args.newprio.get(nil)
	value = string.gsub(value, intro, "")
	
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

function Prio3:Announce(msg) 

	if Prio3.db.profile.raidannounce and UnitInRaid("player") then
		SendChatMessage(msg, "RAID")
	else
		Prio3:Print(msg)
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
				Prio3:Announce(L["No priority on itemlink"](itemLink))	
			end
		end
		if table.getn(itemprios.p1) > 0 then
			Prio3:Announce(L["itemLink is at priority for users"](itemLink, 1, itemprios.p1))	
		end
		if table.getn(itemprios.p2) > 0 then
			Prio3:Announce(L["itemLink is at priority for users"](itemLink, 2, itemprios.p2))	
		end
		if table.getn(itemprios.p3) > 0 then
			Prio3:Announce(L["itemLink is at priority for users"](itemLink, 3, itemprios.p3))	
		end

	else
		if self.db.profile.debug then Prio3:Print("DEBUG: Item " .. itemLink .. " ignored because of mute time setting") end
	end
	
	self.db.profile.lootlastopened[itemId] = time()
	
end

