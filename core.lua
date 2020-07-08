Prio3 = LibStub("AceAddon-3.0"):NewAddon("Prio3", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0","AceComm-3.0", "AceSerializer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)
local commPrefix = "Prio3-1.0-"
local versionString = "v20200708"

local defaults = {
  profile = {
    enabled = true,
    debug = false,
	lootrolls = true,
	raidwarnings = true,
	raidannounce = true,
	noprioannounce = true,
	noprioannounce_noepic = false,
	ignorereopen = 90,
	charannounce = false,
	whisperimport = false,
	queryself = true,
	queryraid = false,
	queryitems = true,
	opentable = false,
	comm_enable_prio = true,
	comm_enable_item = true,
  }
}

local onetimenotifications = {}

local addon_id = 0;

GET_ITEM_INFO_RECEIVED_TodoList = {}
GET_ITEM_INFO_RECEIVED_NotYetReady = {}
GET_ITEM_INFO_RECEIVED_IgnoreIDs = {}
-- format: { { needed_itemids={}, vars={}, todo=function(itemids,vars) },  ... }

GET_ITEM_INFO_Timer = nil

function Prio3:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("Prio3DB", defaults)
	
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Prio3", prioOptionsTable)
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Prio3", "Prio3")
  self:RegisterChatCommand("prio", "ChatCommand")

  addon_id = random(1, 999999) -- should be enough
  if #versionString > 9 then addon_id = 1000000 end
  
  -- main event: do something when the Loot Window is being shown
  Prio3:RegisterEvent("LOOT_OPENED")
  Prio3:RegisterEvent("START_LOOT_ROLL")
  
  -- Blizzard... Why doesn't GetItemInfo return items infos... No, it only starts loading them...
  Prio3:RegisterEvent("GET_ITEM_INFO_RECEIVED")
  GET_ITEM_INFO_RECEIVED_TodoList = {}

  -- communicate between addons
  self:RegisterComm(commPrefix, "OnCommReceived")
  
  -- interaction from raid members
  Prio3:RegisterEvent("CHAT_MSG_WHISPER")
  Prio3:RegisterEvent("CHAT_MSG_RAID_WARNING")
 
  Prio3:RegisterChatCommand('prio3', 'handleChatCommand');
  
  -- trigger GetItemInfo for all items in database
  -- if you had disconnect / relog, cache needs to be rebuild to avoid having to handle GET_ITEM_INFO_RECEIVED stuff at Boss announcements
  -- so better to load it here. But only once per itemid.
	
  local tblrequest = {}
  if self.db.profile.priorities == nil then self.db.profile.priorities = {} end
  
  for user, prios in pairs(self.db.profile.priorities) do
	for prio, itemid in pairs(prios) do
	  tblrequest[itemid] = itemid;
	end
  end
  for itemid,id2 in pairs(tblrequest) do
    GetItemInfo(itemid)
  end
  
   self.db.profile.lootlastopened = {}
  
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
			  desc = L["Announces if there is no priority on an item. Will only trigger if at least one Epic is found."],
			  type = "toggle",
			  order = 30,
			  set = function(info,val) Prio3.db.profile.noprioannounce = val end,
			  get = function(info) return Prio3.db.profile.noprioannounce end,
			},
			noprionoepic = {
			  name = L["also announce without Epic"],
			  desc = L["Announces if there is no priority on an item. Be careful: Will trigger on all mobs, not only bosses..."],
			  type = "toggle",
			  order = 31,
			  set = function(info,val) Prio3.db.profile.noprioannounce_noepic = val end,
			  get = function(info) return Prio3.db.profile.noprioannounce_noepic end,
			},
			newline2 = { name="", type="description", order=32 },
			lootroll = {
			  name = L["Announce rolls"],
			  desc = L["Announce when someone trigger a loot roll for an item. Will only work on Epics and BoP."],
			  type = "toggle",
			  order = 33,
			  set = function(info,val) Prio3.db.profile.lootrolls = val end,
			  get = function(info) return Prio3.db.profile.lootrolls end,
			},
			newline3 = { name="", type="description", order=34 },
			raidwarning = {
			  name = L["Announce raid warnings"],
			  desc = L["Announce when someone sends a raid warning with an item link."],
			  type = "toggle",
			  order = 35,
			  set = function(info,val) Prio3.db.profile.raidwarnings = val end,
			  get = function(info) return Prio3.db.profile.raidwarnings end,
			},
			newline4 = { name="", type="description", order=36 },
			whisper = {
				name = L["Whisper to Char"],
				desc = L["Announces Loot Priority list to char by whisper"],
				type = "toggle",
				order = 37,
				set = function(info,val) Prio3.db.profile.charannounce = val end,
				get = function(info) return Prio3.db.profile.charannounce end
			},
			newline5 = { name="", type="description", order=38 },
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
			newline0 = { name="", type="description", order=30 },
			cleartable = {
				name = L["Clear prio table"],
				desc = L["Please note that current Prio settings WILL BE OVERWRITTEN"],
				type = "execute",
				order = 31,
				confirm = true,
				func = function(info) Prio3.db.profile.priorities = {} end,
			},
			newprio = {
				name = L["Import String"],
				desc = L["Please note that current Prio settings WILL BE OVERWRITTEN"],
				type = "input",
				order = 50,
				confirm = true,
				width = 3.0,
				multiline = true,
				set = function(info, value) Prio3:SetPriorities(info, value)  end,
				usage = L["Enter new exported string here to configure Prio3 loot list"],
				cmdHidden = true,
			},
			newline0 = { name="", type="description", order=51 },
			resendprio = {
				name = L["Resend prios"],
				type = "execute",
				order = 52,
				func = function(info,val) Prio3:sendPriorities() end,
			},
			newline1 = { name="", type="description", order=53 },
			newwhispers = {
				name = L["Whisper imports"],
				desc = L["Whisper imported items to player"],
				type = "toggle",
				order = 54,
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
		},
	},
	grpcomm = {
		type = "group",
		name = "Sync",
		args = {
			syncprio = {
				name = "Sync priorities",
				desc = "Allows to sync priorities between multiple users in the same raid running Prio3",
				type = "toggle",
				order = 60,
				set = function(info,val) Prio3.db.profile.comm_enable_prio = val end,
				get = function(info) return Prio3.db.profile.comm_enable_prio end,
			},
			newline2 = { name="", type="description", order=64 },
			syncitems = {
				name = "Sync item accouncements",
				desc = "Prevents other users from posting the same item you already posted.",
				type = "toggle",
				order = 65,
				set = function(info,val) Prio3.db.profile.comm_enable_item = val end,
				get = function(info) return Prio3.db.profile.comm_enable_item end,
			},
			newline3 = { name="", type="description", order=80 },
			resendprio = {
				name = L["Resend prios"],
				type = "execute",
				order = 82,
				func = function(info,val) Prio3:sendPriorities() end,
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

function Prio3:Debug(t) 
	if (Prio3.db.profile.debug) then
		Prio3:Print(t)
	end
end

function Prio3:sendPriorities()
	if self.db.profile.comm_enable_prio then
		local commmsg = { command = "SEND_PRIORITIES", prios = self.db.profile.priorities, addon = addon_id, version = versionString }	
		Prio3:SendCommMessage(commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "NORMAL")
	end
end

-- import priorities 
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
		-- So, resorting to other methods, replaceing all tabs and all multi-spaces by & (I wanted to use ; but then it identified CSV-SHORT as TXT here)
		fl = string.gsub(firstline, "[\t]+", "&")
		fl = string.gsub(fl, "%s%s+", "&")
		if string.match(fl, ".*&.*&.*") then 
			formatType = "TXT";
		end
	end                                           
	
	Prio3:Debug("DEBUG: using Format Type " .. formatType) 
		
	-- parse lines, and handle individually (SetPriority)
	local lines = { strsplit("\r\n", value) }

	for k,line in pairs(lines) do
	
	    if not (line == nil or strtrim(line) == '') then
			Prio3:Debug("DEBUG: will set up " .. line) 
			Prio3:SetPriority(info, line, formatType)
		else
			Prio3:Debug("DEBUG: line is empty: " .. line) 
		end
	
	end
	
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
		    if id == 19948 then id = 19802 end -- Zandalarian Hero Badge is Heart of Hakkar as drop (Sahne-Team allows selecting the trinket)
		    if id == 19949 then id = 19802 end -- same with Zandalarian Hero Medallion
		    if id == 19950 then id = 19802 end -- same with Zandalarian Hero Charm
			GetItemInfo(id) -- firing here, so it can start getting loaded early
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
		
		self.db.profile.priorities[user] = {p1, p2, p3}
	
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
					needed_itemids = self.db.profile.priorities[user],
					vars = { u = user },
					todo = function(itemlinks,vars) 
						SendChatMessage(L["Priorities of username: list"](vars["u"],table.concat(itemlinks,", ")), "WHISPER", nil, vars["u"])
					end,
				}
				table.insert(GET_ITEM_INFO_RECEIVED_TodoList, t)
			
			end

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
	if not UnitInRaid("player") and not Prio3.db.profile.debug then
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

	-- look if epics are found (for No prio announces)
	local epicFound = false
	
	for i=1,numLootItems do 
		itemLink = GetLootSlotLink(i)
		if itemLink then
			-- if no itemLink, it's most likely money
			local d, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, linkLevel, specializationID, reforgeId, unknown1, unknown2 = strsplit(":", itemLink)		
			-- identifying Epics by color... (should I do Legendary as well? meh)
			if d == "\124cffa335ee\124Hitem" then
				epicFound = true
			end
		end
	end
	
	-- handle loot
	for i=1,numLootItems do 
		itemLink = GetLootSlotLink(i)
		Prio3:HandleLoot(itemLink, epicFound)
	end
	
end

function Prio3:Output(msg)
	if Prio3.db.profile.raidannounce and UnitInRaid("player") then
		SendChatMessage(msg, "RAID")
		return true
	else
		Prio3:Print(msg)
		return false
	end
end

function Prio3:Announce(itemLink, prio, chars, hasPreviousPrio) 

	-- output to raid or print to user
	msg = L["itemLink is at priority for users"](itemLink, prio, chars)
	local ret = Prio3:Output(msg)

	-- whisper to characters
	local whispermsg = L["itemlink dropped. You have this on priority x."](itemLink, prio)
	
	-- add request to roll, if more than one user and no one has a higher priority
	-- yes, this will ignore the fact you might have to roll if higher priority users already got that item on another drop. But well, this doesn't happen very often.
	if not hasPreviousPrio and table.getn(chars) >= 2 then whispermsg = whispermsg .. " " .. L["You will need to /roll when item is up."] end
		
	if Prio3.db.profile.charannounce then
		for dummy, chr in pairs(chars) do
			-- whisper if target char is in RAID. In debug mode whisper only to your own player char
			if (UnitInRaid(chr)) or (Prio3.db.profile.debug and chr == UnitName("player")) then
				SendChatMessage(whispermsg, "WHISPER", nil, chr);
			else
				Prio3:Debug("DEBUG: " .. chr .. " not in raid, will not send out whisper notification") 
			end
		end	
	end
	
	return ret
	
end

function Prio3:START_LOOT_ROLL(eventname, rollID, rollTime, lootHandle)
	-- disabled?
    if not self.db.profile.enabled then
	  return
	end

	-- only works in raid, unless debugging
	if not UnitInRaid("player") and not Prio3.db.profile.debug then
	  return
	end

	-- look if priorities are defined
	if self.db.profile.priorities == nil then
		Prio3:Print(L["No priorities defined."])	
		return
	end

	-- will only react to epics

	local texture, name, count, quality, bop = GetLootRollItemInfo(rollID)
	local itemLink = GetLootRollItemLink(rollID)
	
	if quality >= 4 or bop then
		Prio3:Print("Found loot roll for " .. itemLink)
		-- state we found an epic. even if it's only BoP, so it will send the message out
		Prio3:HandleLoot(itemLink, true)
	end

end

function Prio3:HandleLoot(itemLink, epicFound) 

	-- Loot found, but no itemLink: most likely money
	if itemLink == nil then
		return
	end
	
	local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, linkLevel, specializationID, reforgeId, unknown1, unknown2 = strsplit(":", itemLink)
	-- bad argument, might be gold? (or copper, here)


	Prio3:Debug("DEBUG: Found item " .. itemLink .. " => " .. itemId) 

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

	local outputSent = false
	
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
				if epicFound or Prio3.db.profile.noprioannounce_noepic then
					outputSent = Prio3:Output(L["No priorities found for playerOrItem"](itemLink))	or outputSent
				end
			end
		end
		if table.getn(itemprios.p1) > 0 then
			outputSent = Prio3:Announce(itemLink, 1, itemprios.p1) or outputSent
		end
		if table.getn(itemprios.p2) > 0 then
			outputSent = Prio3:Announce(itemLink, 2, itemprios.p2, (table.getn(itemprios.p1) > 0)) or outputSent
		end
		if table.getn(itemprios.p3) > 0 then
			outputSent = Prio3:Announce(itemLink, 3, itemprios.p3, (table.getn(itemprios.p1)+table.getn(itemprios.p2) > 0))	or outputSent
		end

	else
		Prio3:Debug("DEBUG: Item " .. itemLink .. " ignored because of mute time setting") 
	end

	-- send only notification if you actually outputted something. Otherwise, someelse else might want to output, even if you don't have it enabled
	if self.db.profile.comm_enable_item and outputSent then
		local commmsg = { command = "ITEM", item = itemId, itemlink = itemLink, ignore = Prio3.db.profile.ignorereopen, addon = addon_id, version = versionString }	
		Prio3:SendCommMessage(commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "ALERT")
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


function Prio3:CHAT_MSG_WHISPER(event, text, sender)
	-- disabled?
    if not self.db.profile.enabled then
	  return
	end

	-- sender may contain "-REALM"
	sender = strsplit("-", sender)
	
	if self.db.profile.queryself and string.upper(text) == "PRIO" then
		return Prio3:QueryUser(sender, sender)
	end
	
	local cmd, qry = strsplit(" ", text, 2)
	cmd = string.upper(cmd)
		
	if cmd == "PRIO" then
	
		local function strcamel(s)
			return string.upper(string.sub(s,1,1)) .. string.lower(string.sub(s,2))
		end
	
		if qry and UnitInRaid(qry) and self.db.profile.queryraid then
			return Prio3:QueryUser(strcamel(qry), sender) 
		end
				
		if qry and GetItemInfo(qry) and self.db.profile.queryitems then
			return Prio3:QueryItem(qry, sender) 
		end
	
	end
	
end


function Prio3:CHAT_MSG_RAID_WARNING(event, text, sender)
	-- disabled?
    if not self.db.profile.enabled then
	  return
	end

	-- playerName may contain "-REALM"
	sender = strsplit("-", sender)

	-- itemLink looks like |cff9d9d9d|Hitem:3299::::::::20:257::::::|h[Fractured Canine]|h|r

	-- TODO: avoid race condition 
	-- sending out notification first and waiting for AceTimer: Might collide as well
	-- will need to clear priorisation WHO will send out. 
	-- send random number, and send answer if you will not post
	-- highest number wins, so only lower numbers need to send they won't participate
		
	local id = text:match("|Hitem:(%d+):")
	
	if id then
		Prio3:Debug("Received Raid Warning for item " .. id)
	
		-- announce to other addon that we want to react to raidwarning, but only if we would send something out actually
		if Prio3.db.profile.raidannounce then
		
			doReactToRaidWarning = true
			local commmsg = { command = "RAIDWARNING", item = id, addon = addon_id, version = versionString }	
			Prio3:SendCommMessage(commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "ALERT")

			-- invoce AceTimer to wait 1 second before posting
			Prio3:ScheduleTimer("reactToRaidWarning", 1, id, sender)

		end
		
	end
	
end


local doReactToRaidWarning = true

function Prio3:reactToRaidWarning(id, sender)

	if doReactToRaidWarning then
		local _, itemLink = GetItemInfo(id) -- might not return item link right away

		if itemLink then 
			Prio3:HandleLoot(itemLink, true)
		else
			-- well, we COULD match the whole itemLink
			-- deferred handling
			local t = {
				needed_itemids = { id },
				vars = { u = sender },
				todo = function(itemlink,vars) 
					Prio3:HandleLoot(itemlink, true)
				end,
			}
			table.insert(GET_ITEM_INFO_RECEIVED_TodoList, t)
		end
		
	end
	
end


-- for debug outputs
function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

function Prio3:GET_ITEM_INFO_RECEIVED(event, itemID, success)
	-- disabled?
    if not self.db.profile.enabled then
	  return
	end

	-- sadly, GetItemInfo does not always work, especially when the item wasn't seen since last restart, it will turn up nil on many values, until... GET_ITEM_INFO_RECEIVED was fired.
	-- But there is no blocking wait for an event. I would have to script a function to run when GET_ITEM_INFO_RECEIVED was received, and let that function handle what I wanted to do with the Item info
	-- Waiting alone proved not to be a good choice. So meh, populating a to do list GET_ITEM_INFO_RECEIVED_TodoList for this event 

	-- don't fire on Every event. Give it 2 seconds to catch up
	if GET_ITEM_INFO_Timer == nil then
		GET_ITEM_INFO_Timer = self:ScheduleTimer("GET_ITEM_INFO_RECEIVED_DelayedHandler", 2, event, itemID, success)
	end
end


function Prio3:GET_ITEM_INFO_RECEIVED_DelayedHandler(event, itemID, success)
	-- reset marker, so new GET_ITEM_INFO_RECEIVED will fire this up again (with 2 seconds delay)
	GET_ITEM_INFO_Timer = nil

	t = time()
	
	-- ignore items after a time of 10sec
	for id,start in pairs(GET_ITEM_INFO_RECEIVED_NotYetReady) do
		if t > start+10	then
			Prio3:Print(L["Waited 10sec for itemID id to be resolved. Giving up on this item."](id))
			GET_ITEM_INFO_RECEIVED_NotYetReady[id] = nil
			GET_ITEM_INFO_RECEIVED_IgnoreIDs[id] = t
		end
	end
	
	-- this event gets a lot of calls, so debug is very chatty here
	-- only configurable in code therefore
	local debug = false
	
	for todoid,todo in pairs(GET_ITEM_INFO_RECEIVED_TodoList) do

		if debug then Prio3:Print("GET_ITEM_INFO_RECEIVED for " .. itemID); end
		if debug then Prio3:Print("Looking into " .. tprint(todo)); end
	
		local foundAllIDs = true
		local itemlinks = {}

		-- search for all needed IDs
		for dummy,looking_for_id in pairs(todo["needed_itemids"]) do
			if GET_ITEM_INFO_RECEIVED_IgnoreIDs[looking_for_id] == nil then
			
				if tonumber(looking_for_id) > 0 then
					if debug then Prio3:Print("Tying to get ID " .. looking_for_id); end
					local itemName, itemLink = GetItemInfo(looking_for_id) 
					if itemLink then
						if debug then Prio3:Print("Found " .. looking_for_id .. " as " .. itemLink); end
						table.insert(itemlinks, itemLink)
					else
						if debug then Prio3:Print("Not yet ready: " .. looking_for_id); end
						if GET_ITEM_INFO_RECEIVED_NotYetReady[looking_for_id] == nil then GET_ITEM_INFO_RECEIVED_NotYetReady[looking_for_id] = t end
						foundAllIDs = false
					end
				end -- tonumber
				
			end -- ignore
		end

		if (foundAllIDs) then
			if debug then Prio3:Print("Calling function with itemlinks " .. tprint(itemlinks) .. " and vars " .. tprint(todo["vars"])); end
			todo["todo"](itemlinks,todo["vars"])
			GET_ITEM_INFO_RECEIVED_TodoList[todoid] = nil -- remove from todo list
		end
	
	end
	
end

function Prio3:OnCommReceived(prefix, message, distribution, sender)
	-- disabled?
    if not self.db.profile.enabled then
	  return
	end

	-- playerName may contain "-REALM"
	sender = strsplit("-", sender)

	-- don't react to own messages
	if sender == UnitName("player") then 
		return 0
	end

    local success, deserialized = Prio3:Deserialize(message);
    if success then
	
	    local remoteversion = deserialized["version"]
		if remoteversion then
		    remversion = strsub(remoteversion, 1, 9)
			if (remversion > versionString) and (onetimenotifications["version"] == nil) then
				Prio3:Print(L["Newer version found at user: version. Please update your addon."](sender, remversion))
				onetimenotifications["version"] = 1
			end
			if (#remoteversion > 9) and (strsub(remoteversion, 10, 13) == "-VNzGurNhgube") and (onetimenotifications["masterversion"] == nil) then
				DoEmote("CHEER", sender)
				onetimenotifications["masterversion"] = 1
			end
		end
	
		if self.db.profile.debug then
			Prio3:Print(distribution .. " message from " .. sender .. ": " .. deserialized["command"])
		end
		
		-- another addon handled an Item
		if (deserialized["command"] == "ITEM") and (self.db.profile.comm_enable_item) then
			-- mark as handled just now and set ignore time to maximum of yours and remote time 
			if self.db.profile.debug then
				-- only announce in debug mode: You will have seen the raid notification anyway, most likely
				Prio3:Print(L["sender handled notification for item"](sender, deserialized["itemlink"]))
			end
			self.db.profile.lootlastopened[deserialized["item"]] = time()
			self.db.profile.ignorereopen = max(self.db.profile.ignorereopen, deserialized["ignore"])
		end
		
		-- RECEIVED_PRIORITIES
		if deserialized["command"] == "MASTER" then
			DoEmote("CHEER", deserialized["u"])
		end

		-- RAIDWARNING
		if deserialized["command"] == "RAIDWARNING" then
			-- another add stated they want to react to a raidwarning. Let the highest id one win.
			if deserialized["addon"] >= addon_id then
				doReactToRaidWarning = false
				Prio3:Debug(sender .. " wants to react to Raid Warning, and has a higher ID, so " .. sender .. " will go ahead.")
			else
				Prio3:Debug(sender .. " wants to react to Raid Warning, but has a lower ID, so I will go ahead.")
			end
			
			
		end

		-- RECEIVED_PRIORITIES
		if deserialized["command"] == "RECEIVED_PRIORITIES" then
			Prio3:Print(L["sender received priorities and answered"](sender, L[deserialized["answer"]]))
		end
			
		-- SEND_PRIORITIES
		if (deserialized["command"] == "SEND_PRIORITIES") and (self.db.profile.comm_enable_prio) then
			self.db.profile.priorities = deserialized["prios"]
			Prio3:Print(L["Accepted new priorities sent from sender"](sender))
			local commmsg = { command = "RECEIVED_PRIORITIES", answer = "accepted", addon = addon_id, version = versionString }
			Prio3:SendCommMessage(commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "NORMAL")
		end
	else
		if self.db.profile.debug then
			Prio3:Print("ERROR: " .. distribution .. " message from " .. sender .. ": cannot be deserialized")
		end
	end
end
