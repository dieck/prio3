local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

lootframe = nil

function Prio3:handleChatCommand()
	Prio3:guiPriorityFrame()
end

function Prio3:guiPriorityFrame()

--	if not lootframe == nil then
--	  lootframe:Hide()
--	  lootframe = nil
--	  return
--	end

    -- see if we might already have all data
	local haveAll = true
  
    -- look through all items ids (but only once)
  
	local tblrequest = {}
	for user, prios in pairs(self.db.profile.priorities) do
		for prio, itemid in pairs(prios) do
			tblrequest[itemid] = itemid;
		end
	end
	for itemid,id2 in pairs(tblrequest) do
		if tonumber(itemid) > 0 then
			local itemname, itemlink = GetItemInfo(itemid)
			if itemlink == nil then haveAll = false end
		end
	end

	if haveAll then
		lootframe = Prio3:createPriorityFrame()
		lootframe:Show()
	else
		if self.db.profile.debug then Prio3:Print("DEBUG: requested window to open after GET_ITEM_INFO_RECEIVED") end
		-- queue for handling when GET_ITEM_INFO_RECEIVED event came through
		local t = {
			needed_itemids = tblrequest,
			vars = {},
			todo = function(itemlinks,vars) 
				lootframe = Prio3:createPriorityFrame()
				lootframe:Show()
			end,
		}
		table.insert(GET_ITEM_INFO_RECEIVED_TodoList, t)
	end
  
end

function Prio3:createPriorityFrame()
	local AceGUI = LibStub("AceGUI-3.0")

	if self.db.profile.priorities == nil then 
		Prio3:Print(L["No priorities defined."])
		return;
	end
	
	local f = AceGUI:Create("Frame")
	f:SetTitle(L["Priority List"])
	f:SetStatusText("")
	f:SetLayout("Flow")
	f:SetWidth(700)
	f:SetHeight(500)
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	
	-- close on escape
	_G["Prio3Lootframe"] = f.frame
	tinsert(UISpecialFrames, "Prio3Lootframe")
	
	scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true) -- probably?
	scrollcontainer:SetLayout("Fill") -- important!

	f:AddChild(scrollcontainer)

	s = AceGUI:Create("ScrollFrame")
	s:SetLayout("Flow") -- probably?
	scrollcontainer:AddChild(s)
	
	
	for user, prios in pairs(self.db.profile.priorities) do
	
		local lbPlayerName = AceGUI:Create("Label")
		lbPlayerName:SetText(user)
		lbPlayerName:SetRelativeWidth(0.24)
		s:AddChild(lbPlayerName)
		
		
		if tonumber(prios[1]) > 0 then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(prios[1])

			if itemLink then
				local lbIcon = AceGUI:Create("Icon")
				lbIcon:SetRelativeWidth(0.04)
				lbIcon:SetImage(itemTexture)
				lbIcon:SetImageSize(15,15)
				lbIcon:SetCallback("OnEnter", function(widget)
					GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
					GameTooltip:SetHyperlink(itemLink)
					GameTooltip:Show()
				end)
				lbIcon:SetCallback("OnLeave", function(widget)
					GameTooltip:Hide()
				end)
				s:AddChild(lbIcon)

				local lbPrio = AceGUI:Create("InteractiveLabel")
				lbPrio:SetText(itemLink)
				lbPrio:SetRelativeWidth(0.20)
				s:AddChild(lbPrio)
			else
			
				local lbIcon = AceGUI:Create("Icon")
				lbIcon:SetRelativeWidth(0.04)
				lbIcon:SetImage("Interface\\Icons\\ability_vanish")
				lbIcon:SetImageSize(15,15)
				s:AddChild(lbIcon)

				local lbPrio = AceGUI:Create("InteractiveLabel")
				lbPrio:SetText("-ERROR: ID-")
				lbPrio:SetRelativeWidth(0.20)
				s:AddChild(lbPrio)
			
			end
		else
			local lbIcon = AceGUI:Create("Icon")
			lbIcon:SetRelativeWidth(0.04)
			lbIcon:SetImage("Interface\\Icons\\ability_vanish")
			lbIcon:SetImageSize(15,15)
			s:AddChild(lbIcon)

			local lbPrio = AceGUI:Create("InteractiveLabel")
			lbPrio:SetText("-no prio 1 set-")
			lbPrio:SetRelativeWidth(0.20)
			s:AddChild(lbPrio)
		end
		
		if tonumber(prios[2]) > 0 then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(prios[2])

			if itemLink then
				local lbIcon = AceGUI:Create("Icon")
				lbIcon:SetRelativeWidth(0.04)
				lbIcon:SetImage(itemTexture)
				lbIcon:SetImageSize(15,15)
				lbIcon:SetCallback("OnEnter", function(widget)
					GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
					GameTooltip:SetHyperlink(itemLink)
					GameTooltip:Show()
				end)
				lbIcon:SetCallback("OnLeave", function(widget)
					GameTooltip:Hide()
				end)
				s:AddChild(lbIcon)

				local lbPrio = AceGUI:Create("InteractiveLabel")
				lbPrio:SetText(itemLink)
				lbPrio:SetRelativeWidth(0.20)
				s:AddChild(lbPrio)
			else
			
				local lbIcon = AceGUI:Create("Icon")
				lbIcon:SetRelativeWidth(0.04)
				lbIcon:SetImage("Interface\\Icons\\ability_vanish")
				lbIcon:SetImageSize(15,15)
				s:AddChild(lbIcon)

				local lbPrio = AceGUI:Create("InteractiveLabel")
				lbPrio:SetText("-ERROR: ID-")
				lbPrio:SetRelativeWidth(0.20)
				s:AddChild(lbPrio)
			
			end

		else
			local lbIcon = AceGUI:Create("Icon")
			lbIcon:SetRelativeWidth(0.04)
			lbIcon:SetImage("Interface\\Icons\\ability_vanish")
			lbIcon:SetImageSize(15,15)
			s:AddChild(lbIcon)

			local lbPrio = AceGUI:Create("InteractiveLabel")
			lbPrio:SetText("-no prio 2 set-")
			lbPrio:SetRelativeWidth(0.20)
			s:AddChild(lbPrio)
		end

		if tonumber(prios[3]) > 0 then
		
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(prios[3])

			if itemLink then
				local lbIcon = AceGUI:Create("Icon")
				lbIcon:SetRelativeWidth(0.04)
				lbIcon:SetImage(itemTexture)
				lbIcon:SetImageSize(15,15)
				lbIcon:SetCallback("OnEnter", function(widget)
					GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
					GameTooltip:SetHyperlink(itemLink)
					GameTooltip:Show()
				end)
				lbIcon:SetCallback("OnLeave", function(widget)
					GameTooltip:Hide()
				end)
				s:AddChild(lbIcon)

				local lbPrio = AceGUI:Create("InteractiveLabel")
				lbPrio:SetText(itemLink)
				lbPrio:SetRelativeWidth(0.20)
				s:AddChild(lbPrio)
			else
			
				local lbIcon = AceGUI:Create("Icon")
				lbIcon:SetRelativeWidth(0.04)
				lbIcon:SetImage("Interface\\Icons\\ability_vanish")
				lbIcon:SetImageSize(15,15)
				s:AddChild(lbIcon)

				local lbPrio = AceGUI:Create("InteractiveLabel")
				lbPrio:SetText("-ERROR: ID-")
				lbPrio:SetRelativeWidth(0.20)
				s:AddChild(lbPrio)
			
			end

		else
			local lbIcon = AceGUI:Create("Icon")
			lbIcon:SetRelativeWidth(0.04)
			lbIcon:SetImage("Interface\\Icons\\ability_vanish")
			lbIcon:SetImageSize(15,15)
			s:AddChild(lbIcon)

			local lbPrio = AceGUI:Create("InteractiveLabel")
			lbPrio:SetText("-no prio 3 set-")
			lbPrio:SetRelativeWidth(0.20)
			s:AddChild(lbPrio)
		end

		
		
		local lbHR = AceGUI:Create("Label")
		lbHR:SetText("-----------------------------")
		lbHR:SetRelativeWidth(0.24)
		s:AddChild(lbHR)

		local lbHR = AceGUI:Create("Label")
		lbHR:SetText("-----------------------------")
		lbHR:SetRelativeWidth(0.24)
		s:AddChild(lbHR)

		local lbHR = AceGUI:Create("Label")
		lbHR:SetText("-----------------------------")
		lbHR:SetRelativeWidth(0.24)
		s:AddChild(lbHR)

		local lbHR = AceGUI:Create("Label")
		lbHR:SetText("-----------------------------")
		lbHR:SetRelativeWidth(0.24)
		s:AddChild(lbHR)
		
	end

	return f
end
