local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

local Prio3commPrefix = "Prio3-1.0-"
local Prio3versionString = "v20220830"

local defaults = {
  profile = {
    enabled = true,
    debug = false,
	lootwindow = true,
	lootrolls = true,
	raidwarnings = true,
	ignoredisenchants = true,
	ignorescalecloak = true,
	ignoredrakefire = true,
	raidannounce = true,
	noprioannounce = true,
	noprioannounce_quality = "e",
	ignorereopen = 90,
	showmasterlooterhint = true,
	charannounce = false,
	acceptwhisperprios = false,
	acceptwhisperprios_new = true,
	whisperimport = false,
	queryself = true,
	queryraid = false,
	queryitems = true,
	opentable = false,
	comm_enable_prio = true,
	comm_enable_item = true,
	handle_enable_prio = false,
	handle_enable_p3 = false,
	prio0 = false,
	outputlanguage = GetLocale(),
  }
}

function Prio3:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("Prio3DB", defaults)

  self.commPrefix = Prio3commPrefix
  self.versionString = Prio3versionString
  self.raidversions = {}

  self.addon_id = random(1, 999999) -- should be enough
  if #self.versionString > 9 then self.addon_id = 1000000 end
  if Prio3:isUserMasterLooter() then self.addon_id = 1000001 end

  LibStub("AceConfig-3.0"):RegisterOptionsTable("Prio3", self.prioOptionsTable)
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Prio3", "Prio3")

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

  if self.db.profile.handle_enable_prio then
	self:RegisterChatCommand('prio', 'handleChatCommand');
  end
  if self.db.profile.handle_enable_p3 then
	self:RegisterChatCommand('p3', 'handleChatCommand');
  end

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
  self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")

  self:RegisterEvent("OPEN_MASTER_LOOT_LIST")

  self:requestPing()

  -- change default output language if configured
  if self.outputLocales[self.db.profile.outputlanguage] ~= nil then
	for k,v in pairs(self.outputLocales[self.db.profile.outputlanguage]) do L[k] = v end
  end
end

function Prio3:OnEnable()
    -- Called when the addon is enabled
end

function Prio3:OnDisable()
    -- Called when the addon is disabled
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

function Prio3:tRemoveValue(t, value)
	local idx = nil
	for i,v in pairs(t) do
		-- do not remove while iterating table
		if value == v then idx = i end
	end
	table.remove(t, idx)
end

local function tablesize(t)
	  local count = 0
	  for _, __ in pairs(t) do
		  count = count + 1
	  end
	  return count
end

function tempty(t)
	  if t == nil then return true end
	  if tablesize(t) > 0 then return false end
	  return true
end


function Prio3:isUserMasterLooter()
	local _, _, masterlooterRaidID = GetLootMethod()
	if masterlooterRaidID then
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(masterlooterRaidID);
		if isML and name == UnitName("player") then
			return true
		end
	end
	return false
end

-- config items

Prio3.prioOptionsTable = {
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
		name = L["Output"],
		args = {
			header1 = { name=L["What to output"], type="header", order=1 },

			outputlanguage = {
				name = L["Language"],
				desc = L["Language for outputs"],
				type = "select",
				order = 15,
				values = function()
					local r = {}
					for k,v in pairs(Prio3.outputLocales) do r[k] = k end
					return r
				end,
				set = function(info,val)
					Prio3.db.profile.outputlanguage = val
					for k,v in pairs(Prio3.outputLocales[val]) do L[k] = v end
				end,
				get = function(info) return Prio3.db.profile.outputlanguage end,
			},
			newline16 = { name="", type="description", order=16 },
			raid = {
				name = L["Announce to Raid"],
				desc = L["Announces Loot Priority list to raid chat"],
				type = "toggle",
				order = 20,
				set = function(info,val) Prio3.db.profile.raidannounce = val end,
				get = function(info) return Prio3.db.profile.raidannounce end
			},
			newline21 = { name="", type="description", order=21 },
			noprio = {
			  name = L["Announce No Priority"],
			  desc = L["Announces if there is no priority on an item"],
			  type = "toggle",
			  order = 30,
			  set = function(info,val) Prio3.db.profile.noprioannounce = val end,
			  get = function(info) return Prio3.db.profile.noprioannounce end,
			},
			nopriofilter = {
			  name = L["min Quality"],
			  desc = L["Announce only if there is an item of at least this quality in Loot"],
			  type = "select",
			  style = "dropdown",
			  order = 31,
			  values = {a = L["Poor (Grey)"], b = L["Common (White)"], c = L["Uncommon (Green)"], d = L["Rare (Blue)"], e = L["Epic (Purple)"], f = L["Legendary (Orange)"]},
			  set = function(info,val) Prio3.db.profile.noprioannounce_quality = val end,
			  get = function(info) return Prio3.db.profile.noprioannounce_quality end,
			},
			newline32 = { name="", type="description", order=32 },
			whisper = {
				name = L["Whisper to Char"],
				desc = L["Announces Loot Priority list to char by whisper"],
				type = "toggle",
				order = 33,
				set = function(info,val) Prio3.db.profile.charannounce = val end,
				get = function(info) return Prio3.db.profile.charannounce end
			},

			newline34 = { name="", type="description", order=34 },
			showmasterlooterhint = {
				name = L["Master Looter Hint"],
				desc = L["Shows hint window on Master Looter distribution"],
				type = "toggle",
				order = 35,
				set = function(info,val) Prio3.db.profile.showmasterlooterhint = val end,
				get = function(info) return Prio3.db.profile.showmasterlooterhint end
			},
			newline36 = { name="", type="description", order=36 },
			priozero = {
			  name = L["Enable Prio 0"],
			  desc = L["Activates output for Prio 0. If someone sets Prio 1, 2 and 3 to the same item, this gets precedence."],
			  type = "toggle",
			  order = 37,
			  set = function(info,val) Prio3.db.profile.prio0 = val end,
			  get = function(info) return Prio3.db.profile.prio0 end,
			},

			newline50 = { name="", type="description", order=50 },
			header51 = { name=L["When to output"], type="header", order=51 },

			lootwindow = {
			  name = L["React to loot window"],
			  desc = L["Reacts when you open a loot window."],
			  type = "toggle",
			  order = 55,
			  set = function(info,val) Prio3.db.profile.lootwindow = val end,
			  get = function(info) return Prio3.db.profile.lootwindow end,
			},
			newline59 = { name="", type="description", order=59 },

			lootroll = {
			  name = L["React to rolls"],
			  desc = L["Reacts when someone trigger a loot roll for an item. Will only work on Epics and BoP."],
			  type = "toggle",
			  order = 60,
			  set = function(info,val) Prio3.db.profile.lootrolls = val end,
			  get = function(info) return Prio3.db.profile.lootrolls end,
			},
			newline69 = { name="", type="description", order=69 },

			raidwarning = {
			  name = L["React to raid warnings"],
			  desc = L["Reacts when someone sends a raid warning with an item link."],
			  type = "toggle",
			  order = 70,
			  set = function(info,val) Prio3.db.profile.raidwarnings = val end,
			  get = function(info) return Prio3.db.profile.raidwarnings end,
			},
			newline79 = { name="", type="description", order=79 },

			ignoredisenchants = {
			  name = L["Ignore Disenchants"],
			  desc = L["Ignore if you open a loot window containing crystals or large shards."],
			  type = "toggle",
			  order = 80,
			  set = function(info,val) Prio3.db.profile.ignoredisenchants = val end,
			  get = function(info) return Prio3.db.profile.ignoredisenchants end,
			},
			newline89 = { name="", type="description", order=89 },

			ignorescalecloak = {
			  name = L["Ignore Ony Cloak"],
			  desc = L["Ignore if someone raid warns about the Onyxia Scale Cloak"],
			  type = "toggle",
			  order = 90,
			  set = function(info,val) Prio3.db.profile.ignorescalecloak = val end,
			  get = function(info) return Prio3.db.profile.ignorescalecloak end,
			},
			ignoredrakefire = {
			  name = L["Ignore Drakefire"],
			  desc = L["Ignore if someone raid warns about the Drakefire Amulet"],
			  type = "toggle",
			  order = 91,
			  set = function(info,val) Prio3.db.profile.ignoredrakefire = val end,
			  get = function(info) return Prio3.db.profile.ignoredrakefire end,
			},
			newline99 = { name="", type="description", order=99 },

			reopen = {
				name = L["Mute (sec)"],
				desc = L["Ignores loot encountered a second time for this amount of seconds. 0 to turn off."],
				type = "range",
				min = 0,
				max = 600,
				step = 1,
				bigStep = 15,
				order = 100,
				set = function(info,val) Prio3.db.profile.ignorereopen = val end,
				get = function(info) return Prio3.db.profile.ignorereopen end
			},

		}
	},
	grpquery = {
		type = "group",
		name = L["Queries"],
		args = {
			queryself = {
				name = L["Query own priority"],
				desc = L["Allows to query own priority. Whisper prio."],
				type = "toggle",
				order = 60,
				set = function(info,val) Prio3.db.profile.queryself = val end,
				get = function(info) return Prio3.db.profile.queryself end,
			},
			newline61 = { name="", type="description", order=61 },
			queryraid = {
				name = L["Query raid priorities"],
				desc = L["Allows to query priorities of all raid members. Whisper prio CHARNAME."],
				type = "toggle",
				disabled = function() return Prio3.db.profile.acceptwhisperprios end,
				order = 63,
				set = function(info,val) Prio3.db.profile.queryraid = val end,
				get = function(info) return Prio3.db.profile.queryraid end,
			},
			newline64 = { name="", type="description", order=64 },
			queryitems = {
				name = L["Query item priorities"],
				desc = L["Allows to query own priority. Whisper prio ITEMLINK."],
				type = "toggle",
				disabled = function() return Prio3.db.profile.acceptwhisperprios end,
				order = 65,
				set = function(info,val) Prio3.db.profile.queryitems = val end,
				get = function(info) return Prio3.db.profile.queryitems end,
			},
			newline66 = { name="", type="description", order=66 },
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
		name = L["Import"],
		args = {
			newline0 = { name="", type="description", order=30 },
			cleartable = {
				name = L["Clear prio table"],
				desc = L["Please note that current Prio settings WILL BE OVERWRITTEN"],
				type = "execute",
				disabled = function() return Prio3.db.profile.acceptwhisperprios end,
				order = 31,
				confirm = true,
				func = function(info) Prio3.db.profile.priorities = {} end,
			},
			newprio = {
				name = L["Import String"],
				desc = L["Please note that current Prio settings WILL BE OVERWRITTEN"],
				type = "input",
				disabled = function() return Prio3.db.profile.acceptwhisperprios end,
				order = 50,
				confirm = true,
				width = 3.0,
				multiline = true,
				set = function(info, value) Prio3:SetPriorities(info, value)  end,
				usage = L["Enter new exported string here to configure Prio3 loot list"],
				cmdHidden = true,
			},
			newline51 = { name="", type="description", order=51 },
			resendprio = {
				name = L["Resend prios"],
				type = "execute",
				disabled = function() return Prio3.db.profile.acceptwhisperprios end,
				order = 52,
				func = function(info,val) Prio3:sendPriorities() end,
			},
			newline53 = { name="", type="description", order=53 },
			newwhispers = {
				name = L["Whisper imports"],
				desc = L["Whisper imported items to player"],
				type = "toggle",
				order = 54,
				set = function(info,val) Prio3.db.profile.whisperimport = val end,
				get = function(info) return Prio3.db.profile.whisperimport end,
			},
			newline56 = { name="", type="description", order=56 },
			opentable = {
				name = L["Open prio table after import"],
				type = "toggle",
				order = 75,
				set = function(info,val) Prio3.db.profile.opentable = val end,
				get = function(info) return Prio3.db.profile.opentable end,
			},
			newline76 = { name="", type="description", order=76 },
			showtable = {
				name = L["Show prio table"],
				type = "execute",
				order = 99,
				func = function(info) Prio3:guiPriorityFrame() end,
			},

			newline100 = { name="", type="description", order=100 },
			header1 = { name=L["Accept whispers"], type="header", order=100 },

			txt1 = { name=L["Enables receiving participant priorities by whisper."], type="description", order=101 },
			txt2 = { name=L["Itemlinks, Item ID numbers or Wowhead Links; separated by Space or Comma"], type="description", order=102 },
			txt3 = { name=L["Using import later will overwrite/delete received priorities."], type="description", order=103 },
			txt4 = { name=L["Deleting, importing, resending, receiving and querying of priorities will be disabled while accepting whispers."], type="description", order=104 },
			txt5 = { name=L["Will send out priorities to other Prio3 addons when ending."], type="description", order=105 },
			txt6 = { name=L["Be aware addon user will be able to see incoming priorities before opening it up to the public."], type="description", order=105 },

			acceptwhisperprios_new = {
				name = L["Accept only new"],
				desc = L["Accept only from new players without priorities yet. If disabled, accepts from all players and allow overwriting"],
				type = "toggle",
				order = 120,
				set = function(info,val) Prio3.db.profile.acceptwhisperprios_new = val end,
				get = function(info) return Prio3.db.profile.acceptwhisperprios_new end,
			},
			newline125 = { name="", type="description", order=125 },

			acceptwhisperprios_start = {
				name = L["Start accepting"],
				desc = "",
				disabled = function() return Prio3.db.profile.acceptwhisperprios end,
				type = "execute",
				order = 140,
				func = function()
					Prio3.db.profile.acceptwhispers_storedsettings = {
						comm_enable_prio = Prio3.db.profile.comm_enable_prio,
						queryraid = Prio3.db.profile.queryraid,
						queryitems = Prio3.db.profile.queryitems,
						whisperimport = Prio3.db.profile.whisperimport
					}
					Prio3.db.profile.comm_enable_prio = false
					Prio3.db.profile.queryraid = false
					Prio3.db.profile.queryitems = false
					Prio3.db.profile.whisperimport = true
					Prio3.db.profile.acceptwhisperprios = true

					Prio3:Output(L["Now accepting Prio3 updates by whisper. Send 3 [Itemlinks], wowhead Links or IDs my way, separated by space or comma"])
					if Prio3.db.profile.acceptwhisperprios_new then
						Prio3:Output(L["Only accepting whispers from players who have not yet set a priority."])
					end
				end
			},
			acceptwhisperprios_end = {
				name = L["End accepting"],
				desc = "",
				disabled = function() return not Prio3.db.profile.acceptwhisperprios end,
				type = "execute",
				order = 145,
				func = function()
					if Prio3.db.profile.acceptwhispers_storedsettings then
						Prio3.db.profile.comm_enable_prio = Prio3.db.profile.acceptwhispers_storedsettings.comm_enable_prio
						Prio3.db.profile.queryraid = Prio3.db.profile.acceptwhispers_storedsettings.queryraid
						Prio3.db.profile.whisperimport = Prio3.db.profile.acceptwhispers_storedsettings.whisperimport
						Prio3.db.profile.queryitems = Prio3.db.profile.acceptwhispers_storedsettings.queryitems
					end

					Prio3.db.profile.acceptwhisperprios = false

					Prio3:sendPriorities()

					Prio3:Output(L["No longer accepting Prio3 updates by whisper."])
					for user,prios in pairs(Prio3.db.profile.priorities) do
						Prio3:OutputUserPrio(user, "RAID")
					end

				end,
			},
			newline149 = { name="", type="description", order=149 },

		},
	},
	grpcomm = {
		type = "group",
		name = L["Sync & Handler"],
		args = {
			syncprio = {
				name = "Sync priorities",
				desc = "Allows to sync priorities between multiple users in the same raid running Prio3",
				type = "toggle",
				disabled = function() return Prio3.db.profile.acceptwhisperprios end,
				order = 10,
				set = function(info,val) Prio3.db.profile.comm_enable_prio = val end,
				get = function(info) return Prio3.db.profile.comm_enable_prio end,
			},
			newline2 = { name="", type="description", order=19 },
			syncitems = {
				name = "Sync item announcements",
				desc = "Prevents other users from posting the same item you already posted.",
				type = "toggle",
				order = 20,
				set = function(info,val) Prio3.db.profile.comm_enable_item = val end,
				get = function(info) return Prio3.db.profile.comm_enable_item end,
			},
			newline3 = { name="", type="description", order=29 },
			resendprio = {
				name = L["Resend prios"],
				type = "execute",
				order = 30,
				func = function(info,val) Prio3:sendPriorities() end,
			},
			newline4 = { name="", type="description", order=39 },
			priohandler = {
				name = L["/prio handler"],
				type = "toggle",
				order = 40,
				set = function(info,val)
					Prio3.db.profile.handle_enable_prio = val
					if Prio3.db.profile.handle_enable_prio then
						Prio3:RegisterChatCommand('prio', 'handleChatCommand');
					else
						Prio3:UnregisterChatCommand('prio', 'handleChatCommand');
					end
				end,
				get = function(info) return Prio3.db.profile.handle_enable_prio end,
			},
			newline5 = { name="", type="description", order=49 },
			p3handler = {
				name = L["/p3 handler"],
				type = "toggle",
				order = 50,
				set = function(info,val)
					Prio3.db.profile.handle_enable_p3 = val
					if Prio3.db.profile.handle_enable_p3 then
						Prio3:RegisterChatCommand('p3', 'handleChatCommand');
					else
						Prio3:UnregisterChatCommand('p3', 'handleChatCommand');
					end
				end,
				get = function(info) return Prio3.db.profile.handle_enable_p3 end,
			},

		}
	},
	grpversion = {
		type = "group",
		name = "Versions",
		args = {
			myversion = {
			  name = "My Version",
			  type = "input",
			  order = 10,
			  get = function(info) return strsub(Prio3.versionString, 1, 9) end,
			  disabled = true,
			},
			newline1 = { name="", type="description", order=10 },
			otherversions = {
				name = "Other users",
				type = "input",
				order = 20,
				width = 3.0,
				multiline = 15,
				get = function(info) return tprint(Prio3.raidversions) end,
				disabled = true,
			},

		},
	},

    debugging = {
      name = L["Debug"],
      desc = L["Enters Debug mode. Addon will have advanced output, and work outside of Raid"],
      type = "toggle",
      order = 98,
      set = function(info,val) Prio3.db.profile.debug = val end,
      get = function(info) return Prio3.db.profile.debug end
    },

	showhelp = {
		name = "Help",
		type = "execute",
		order = 99,
		func = function(info) Prio3:guiHelpFrame() end,
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