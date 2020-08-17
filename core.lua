local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

local Prio3commPrefix = "Prio3-1.0-"
local Prio3versionString = "v20200817"

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

function Prio3:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("Prio3DB", defaults)

  self.commPrefix = Prio3commPrefix
  self.versionString = Prio3versionString	
	
  self.addon_id = random(1, 999999) -- should be enough
  if #self.versionString > 9 then self.addon_id = 1000000 end
  
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Prio3", prioOptionsTable)
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Prio3", "Prio3")
  self:RegisterChatCommand("prio", "ChatCommand")
 
  -- Blizzard... Why doesn't GetItemInfo return items infos... No, it only starts loading them...
  self.GET_ITEM_INFO_RECEIVED_TodoList = {}
  -- format: { { needed_itemids={}, vars={}, todo=function(itemids,vars) },  ... }
  self.GET_ITEM_INFO_RECEIVED_NotYetReady = {}
  self.GET_ITEM_INFO_RECEIVED_IgnoreIDs = {}
  self.GET_ITEM_INFO_Timer = nil
  
  -- trigger GetItemInfo for all items in database
  -- if you had disconnect / relog, cache needs to be rebuild to avoid having to handle GET_ITEM_INFO_RECEIVED stuff at Boss announcements
  -- so better to load it here. But only once per itemid.
	
  local tblrequest = {}
  if self.db.profile.priorities == nil then self.db.profile.priorities = {} end
  if self.db.profile.receivedPriorities == nil then self.db.profile.receivedPriorities = 0 end
  
  for user, prios in pairs(self.db.profile.priorities) do
	for prio, itemid in pairs(prios) do
	  tblrequest[itemid] = itemid;
	end
  end
  for itemid,id2 in pairs(tblrequest) do
    GetItemInfo(itemid)
  end
  
  self.db.profile.lootlastopened = {}
  self.doReactToRaidWarning = true
  
  self.onetimenotifications = {}

  
  -- /prio3 handler
  self:RegisterChatCommand('prio3', 'handleChatCommand');

  -- communicate between addons
  self:RegisterComm(self.commPrefix, "OnCommReceived")
  
  -- only register events after initializing all other variables
  
  -- main event: do something when the Loot Window is being shown
  self:RegisterEvent("LOOT_OPENED")
  self:RegisterEvent("START_LOOT_ROLL")

  -- Blizzard... Why doesn't GetItemInfo return items infos... No, it only starts loading them...
  self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
  
  -- interaction from raid members
  self:RegisterEvent("CHAT_MSG_WHISPER")
  self:RegisterEvent("CHAT_MSG_RAID_WARNING")
  
  -- entering an instance
  self.previousGroupState = UnitInParty("player")
  self:RegisterEvent("GROUP_ROSTER_UPDATE")
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

function Prio3:Debug(t, lvl) 
    if lvl == nil then
	  lvl = "DEBUG"
	end
	if (Prio3.db.profile.debug) then
		if (type(t) == "table") then
			Prio3:Print(lvl .. ": " .. tprint(t))
		else
			Prio3:Print(lvl .. ": " .. t)
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

