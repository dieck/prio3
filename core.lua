Prio3 = LibStub("AceAddon-3.0"):NewAddon("Prio3", "AceConsole-3.0", "AceEvent-3.0")

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
  -- self.db = LibStub("AceDB-3.0"):New("AceDBExampleDB")
	
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
      name = "Enable",
      desc = "Enables / disables the addon",
      type = "toggle",
	  order = 10,
      set = function(info,val) Prio3.db.profile.enabled = val end,
      get = function(info) return Prio3.db.profile.enabled end,
    },
    noprio = {
      name = "Announce No Priority",
      desc = "Enables / disables the addon",
      type = "toggle",
	  order = 20,
      set = function(info,val) Prio3.db.profile.noprioannounce = val end,
      get = function(info) return Prio3.db.profile.noprioannounce end,
    },
	raid = {
		name = "Announce to Raid",
		desc = "Announces Loot Priority list to raid chat",
		type = "toggle",
		order = 30,
		set = function(info,val) Prio3.db.profile.raidannounce = val end,
		get = function(info) return Prio3.db.profile.raidannounce end
	},
	reopen = {
		name = "Ignore Re-Open (sec)",
		desc = "Ignores re-opened loot window for this amount of seconds. 0 to turn off. Classic does not have looted corpse ids. May not work properly if you looted something before a boss.",
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
		name = "Loot prio list",
		desc = "Please note that current Prio settings WILL BE OVERWRITTEN",
		type = "input",
		order = 50,
		confirm = true,
		width = full,
		multiline = true,
		set = function(info, value) 
			Prio3:SetPriorities(info, value) 
		end,
		get = function(info) return "Enter new exported string here to configure Prio3 loot list" end,
		cmdHidden = true,
	},
    debugging = {
      name = "Debug",
      desc = "Enters Debug mode. Addon will have advanced output, and work outside of Raid",
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

	local lines = { strsplit("\r\n", value) }

	for k,line in pairs(lines) do
		if not (line == nil or strtrim(line) == '') then
			if Prio3.db.profile.debug then Prio3:Print("will set up " .. line) end
			Prio3:SetPriority(info, line)
		else
			if Prio3.db.profile.debug then Prio3:Print("line is empty: " .. line) end
		end
	
	end
			
	
	Prio3.priorities = value
end


function Prio3:SetPriority(info, line)
	local user, prio1, prio2, prio3 = strsplit(";", line)

	local function toId(s) 
		for id in string.gmatch(s, "%d+") do print("item " .. id) return id end
	end

	-- avoid Priorities being nil, if not all are used up
	p1 = 0
	p2 = 0
	p3 = 0
	
	if user == nil then	
		if Prio3.db.profile.debug then Prio3:Print("No user found in " .. line) end
	else
		if prio1 == nil then
			if Prio3.db.profile.debug then Prio3:Print("No prio1 found in " .. line) end
		else
			p1 = toId(prio1) 
			if Prio3.db.profile.debug then Prio3:Print("Found PRIORITY 1 ITEM " .. p1 .. " for user " .. user .. " in " .. line) end
		end
		if prio2 == nil then
			if Prio3.db.profile.debug then Prio3:Print("No prio2 found in " .. line) end
		else
			p2 = toId(prio2) 
			if Prio3.db.profile.debug then Prio3:Print("Found PRIORITY 2 ITEM " .. p2 .. " for user " .. user .. " in " .. line) end
		end
		if prio3 == nil then
			if Prio3.db.profile.debug then Prio3:Print("No prio3 found in " .. line) end
		else
			p3 = toId(prio3) 
			if Prio3.db.profile.debug then Prio3:Print("Found PRIORITY 3 ITEM " .. p3 .. " for user " .. user .. " in " .. line) end
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
		Prio3:Print("No priorities defined.")	
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
	

	if Prio3.db.profile.debug then Prio3:Print("Found item " .. itemLink .. " => " .. itemId) end

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
				Prio3:Announce("No priority on " .. itemLink)	
			end
		end
		if table.getn(itemprios.p1) > 0 then
			Prio3:Announce(itemLink .. " is at PRIORITY 1 for " .. table.concat(itemprios.p1, ',' ))	
		end
		if table.getn(itemprios.p2) > 0 then
			Prio3:Announce(itemLink .. " is at Priority 2 for " .. table.concat(itemprios.p2, ',' ))	
		end
		if table.getn(itemprios.p3) > 0 then
			Prio3:Announce(itemLink .. " is at Priority 3 for " .. table.concat(itemprios.p3, ',' ))	
		end

	else
		if self.db.profile.debug then Prio3:Print("Item " .. itemLink .. " ignored because of re-open time setting") end
	end
	
	self.db.profile.lootlastopened[itemId] = time()
	
end

