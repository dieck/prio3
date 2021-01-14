local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

function Prio3:sendPriorities()
	if Prio3.db.profile.comm_enable_prio then
		local commmsg = { command = "SEND_PRIORITIES", prios = Prio3.db.profile.priorities, importtime = self.db.profile.prioimporttime, addon = Prio3.addon_id, version = Prio3.versionString }	
		Prio3:SendCommMessage(Prio3.commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "NORMAL")
	end
end

function Prio3:requestPing()
	local commmsg = { command = "PING", addon = Prio3.addon_id, version = Prio3.versionString }
	Prio3:SendCommMessage(Prio3.commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "NORMAL")
end

function Prio3:sendPong()
	local commmsg = { command = "PONG", addon = Prio3.addon_id, version = Prio3.versionString }
	Prio3:SendCommMessage(Prio3.commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "NORMAL")
end

function Prio3:GROUP_ROSTER_UPDATE()
	-- request priorities if entering a new raid

	if UnitInParty("player") and not Prio3.previousGroupState then
		Prio3:requestPing()

		-- joined group: request Prio data
		if Prio3.db.profile.enabled then
			local commmsg = { command = "REQUEST_PRIORITIES", addon = Prio3.addon_id, version = Prio3.versionString }
			Prio3:SendCommMessage(Prio3.commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "NORMAL")

			-- if no prio data received after 10sec, ask to disable Addon
			current = time()
			Prio3:ScheduleTimer("reactToRequestPriorities", 10, current)
		else 
			Prio3:Print(L["Prio3 addon is currently disabled."])
		end

	end

	Prio3.previousGroupState = UnitInParty("player")


end

function Prio3:reactToRequestPriorities(requested) 
	if Prio3.db.profile.receivedPriorities < requested then
		-- didn't receive priorities after requesting them
		Prio3:askToDisable(L["You joined a new group. I looked for other Prio3 addons, but found none. If this is not a Prio3 group, do you want to disable your addon or at least clear old priorities?"])
	end
end

function Prio3:reactToVersionMatch(usr)
	DoEmote("CHEER", usr)
end

function Prio3:OnCommReceived(prefix, message, distribution, sender)
	-- playerName may contain "-REALM"
	sender = strsplit("-", sender)

	-- don't react to own messages
	if sender == UnitName("player") then
		return 0
	end

    local success, deserialized = Prio3:Deserialize(message);

	-- first thing we'll do: Note down the version
	if success then
		local remoteversion = deserialized["version"]
		if remoteversion then
			remversion = strsub(remoteversion, 1, 9)
			Prio3.raidversions[sender] = remversion
		end
	end

	-- disabled? get out here. Only thing that happened was recording the version in raid
    if not Prio3.db.profile.enabled then
	  return
	end

	-- every thing else get handled if (if not disabled)
    if success then

	    local remoteversion = deserialized["version"]
		if remoteversion then
		    remversion = strsub(remoteversion, 1, 9)
			if (remversion > Prio3.versionString) and (Prio3.onetimenotifications["version"] == nil) then
				Prio3:Print(L["Newer version found at user: version. Please update your addon."](sender, remversion))
				Prio3.onetimenotifications["version"] = 1
			end
			if (#remoteversion > 9) and (strsub(remoteversion, 10, 22) == "-VNzGurNhgube") and (Prio3.onetimenotifications["masterversion"] == nil) then
				Prio3:ScheduleTimer("reactToVersionMatch", 3, sender)
				Prio3.onetimenotifications["masterversion"] = 1
			end
		end

		if Prio3.db.profile.debug then
			Prio3:Print(distribution .. " message from " .. sender .. ": " .. deserialized["command"])
		end

		-- another addon handled an Item
		if (deserialized["command"] == "ITEM") and (Prio3.db.profile.comm_enable_item) then
			-- mark as handled just now and set ignore time to maximum of yours and remote time 
			if Prio3.db.profile.debug then
				-- only announce in debug mode: You will have seen the raid notification anyway, most likely
				Prio3:Print(L["sender handled notification for item"](sender, deserialized["itemlink"]))
			end
			Prio3.db.profile.lootlastopened[deserialized["item"]] = time()
			Prio3.db.profile.ignorereopen = max(Prio3.db.profile.ignorereopen, deserialized["ignore"])
		end

		-- RAIDWARNING
		if deserialized["command"] == "RAIDWARNING" then
			-- another add stated they want to react to a raidwarning. Let the highest id one win.
			if deserialized["addon"] >= Prio3.addon_id then
				Prio3.doReactToRaidWarning = false
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
		if (deserialized["command"] == "SEND_PRIORITIES") and (Prio3.db.profile.comm_enable_prio) then

			local playerIsMasterLooter = false

			local _, _, masterlooterRaidID = GetLootMethod()
			if masterlooterRaidID then
				local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(masterlooterRaidID);
				if isML and name == UnitName("player") then
					playerIsMasterLooter = true
				end
			end

			if playerIsMasterLooter then
				local newPriorities = deserialized["prios"]
				local newReceived = time()
				Prio3:Print(L["Received new priorities sent from sender, but I am Master Looter"](sender))
				Prio3:askToAcceptIncomingPriorities(sender, newPriorities, newReceived)

			else
				-- no master looting is used, or player is not master looter
				Prio3.db.profile.priorities = deserialized["prios"]
				Prio3.db.profile.receivedPriorities = time()
				Prio3:Print(L["Accepted new priorities sent from sender"](sender))
				local commmsg = { command = "RECEIVED_PRIORITIES", answer = "accepted", addon = Prio3.addon_id, version = Prio3.versionString }
				Prio3:SendCommMessage(Prio3.commPrefix, Prio3:Serialize(commmsg), "RAID", nil, "NORMAL")
			end
		end

		-- REQUEST_PRIORITIES
		if (deserialized["command"] == "REQUEST_PRIORITIES") and (Prio3.db.profile.comm_enable_prio) then
			Prio3:sendPriorities()
		end

		if (deserialized["command"] == "PING") then
			Prio3:Debug("Got PING request from " .. sender)
			Prio3:sendPong()
		end

		if (deserialized["command"] == "PONG") then
			Prio3:Debug("Seen PONG answer from " .. sender)
		end

	else
		if Prio3.db.profile.debug then
			Prio3:Print("ERROR: " .. distribution .. " message from " .. sender .. ": cannot be deserialized")
		end
	end
end

