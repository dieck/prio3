local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

function Prio3:GET_ITEM_INFO_RECEIVED(event, itemID, success)
	-- disabled?
    if not Prio3.db.profile.enabled then
	  return
	end

	-- sadly, GetItemInfo does not always work, especially when the item wasn't seen since last restart, it will turn up nil on many values, until... GET_ITEM_INFO_RECEIVED was fired.
	-- But there is no blocking wait for an event. I would have to script a function to run when GET_ITEM_INFO_RECEIVED was received, and let that function handle what I wanted to do with the Item info
	-- Waiting alone proved not to be a good choice. So meh, populating a to do list GET_ITEM_INFO_RECEIVED_TodoList for this event

	-- don't fire on Every event. Give it 2 seconds to catch up
	if Prio3.GET_ITEM_INFO_Timer == nil then
		Prio3.GET_ITEM_INFO_Timer = Prio3:ScheduleTimer("GET_ITEM_INFO_RECEIVED_DelayedHandler", 2, event, itemID, success)
	end
end


function Prio3:GET_ITEM_INFO_RECEIVED_DelayedHandler(event, itemID, success)
	-- reset marker, so new GET_ITEM_INFO_RECEIVED will fire this up again (with 2 seconds delay)
	Prio3.GET_ITEM_INFO_Timer = nil

	local t = time()

	-- ignore items after a time of 10sec
	for id,start in pairs(Prio3.GET_ITEM_INFO_RECEIVED_NotYetReady) do
		if t > start+10	then
			Prio3:Print(L["Waited 10sec for itemID id to be resolved. Giving up on this item."](id))
			Prio3.GET_ITEM_INFO_RECEIVED_NotYetReady[id] = nil
			Prio3.GET_ITEM_INFO_RECEIVED_IgnoreIDs[id] = t
		end
	end

	-- this event gets a lot of calls, so debug is very chatty here
	-- only configurable in code therefore
	local debug = false

	for todoid,todo in pairs(Prio3.GET_ITEM_INFO_RECEIVED_TodoList) do

		if debug then Prio3:Print("GET_ITEM_INFO_RECEIVED for " .. itemID); end
		if debug then Prio3:Print("Looking into " .. tprint(todo)); end

		local foundAllIDs = true
		local itemlinks = {}

		-- search for all needed IDs
		for dummy,looking_for_id in pairs(todo["needed_itemids"]) do
			if Prio3.GET_ITEM_INFO_RECEIVED_IgnoreIDs[looking_for_id] == nil then

				if tonumber(looking_for_id) > 0 then
					if debug then Prio3:Print("Tying to get ID " .. looking_for_id); end
					local itemName, itemLink = GetItemInfo(looking_for_id)
					if itemLink then
						if debug then Prio3:Print("Found " .. looking_for_id .. " as " .. itemLink); end
						table.insert(itemlinks, itemLink)
					else
						if debug then Prio3:Print("Not yet ready: " .. looking_for_id); end
						if Prio3.GET_ITEM_INFO_RECEIVED_NotYetReady[looking_for_id] == nil then Prio3.GET_ITEM_INFO_RECEIVED_NotYetReady[looking_for_id] = t end
						foundAllIDs = false
					end
				end -- tonumber

			end -- ignore
		end

		if (foundAllIDs) then
			if debug then Prio3:Print("Calling function with itemlinks " .. tprint(itemlinks) .. " and vars " .. tprint(todo["vars"])); end
			todo["todo"](itemlinks,todo["vars"])
			Prio3.GET_ITEM_INFO_RECEIVED_TodoList[todoid] = nil -- remove from todo list
		end

	end

end
