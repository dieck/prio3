local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

Prio3.lootframe = nil

function Prio3:handleChatCommand(cmd)
	if cmd == "config" then
		if not Prio3.lootframe == nil then 
			Prio3.lootframe:Hide() 
		end
		LibStub("AceConfigDialog-3.0"):Open("Prio3")
	else
		Prio3:guiPriorityFrame()
	end
end

function Prio3:guiPriorityFrame()

--	if not Prio3.lootframe == nil then
--	  Prio3.lootframe:Hide()
--	  Prio3.lootframe = nil
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
		Prio3.lootframe = Prio3:createPriorityFrame()
		Prio3.lootframe:Show()
	else
		if self.db.profile.debug then Prio3:Print("DEBUG: requested window to open after GET_ITEM_INFO_RECEIVED") end
		-- queue for handling when GET_ITEM_INFO_RECEIVED event came through
		local t = {
			needed_itemids = tblrequest,
			vars = {},
			todo = function(itemlinks,vars) 
				Prio3.lootframe = Prio3:createPriorityFrame()
				Prio3.lootframe:Show()
			end,
		}
		table.insert(Prio3.GET_ITEM_INFO_RECEIVED_TodoList, t)
	end
  
end

function Prio3:createPriorityFrame()
	local AceGUI = LibStub("AceGUI-3.0")

	if self.db.profile.priorities == nil then 
		Prio3:Print(L["No priorities defined."])
		return;
	end
	
	local f = AceGUI:Create("Frame")
	f:SetTitle(L["Priority List"] .. " " .. strsub(Prio3.versionString, 1, 9))
	f:SetStatusText("")
	f:SetLayout("Flow")
	f:SetWidth(700)
	f:SetHeight(500)
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	
	-- close on escape
	_G["Prio3Prio3.lootframe"] = f.frame
	tinsert(UISpecialFrames, "Prio3Prio3.lootframe")
	
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

	local bt = AceGUI:Create("Button")
	bt:SetText("Config / Import")
	bt:SetCallback("OnClick", function()
		Prio3.lootframe:Hide()
		LibStub("AceConfigDialog-3.0"):Open("Prio3")
	end)
	s:AddChild(bt)
	
	return f
end


function Prio3:CreateMasterLootInfoFrame(itemId)
	local frame = CreateFrame("Frame", "Prio3MasterLooterHint", UIParent)
	frame:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
		edgeSize = 14,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
    })
	
	frame:EnableMouse(false)
	frame:SetPoint("CENTER")

	l = {}
		
	-- build local prio list
	local itemprios = {
		p1 = {},
		p2 = {},
		p3 = {}
	}
	
	-- iterate over priority table
	for user, prios in pairs(Prio3.db.profile.priorities) do
	
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
		
	if getn(itemprios.p1) > 0 then
		tinsert(l, "Prio 1")
		tinsert(l, "===============")
		for k,v in pairs(itemprios.p1) do tinsert(l, v) end
		tinsert(l, "===============")
	end
	if getn(itemprios.p2) > 0 then
		tinsert(l, "Prio 2")
		tinsert(l, "===============")
		for k,v in pairs(itemprios.p2) do tinsert(l, v) end
		tinsert(l, "===============")
	end
	if getn(itemprios.p3) > 0 then
		tinsert(l, "Prio 3")
		tinsert(l, "===============")
		for k,v in pairs(itemprios.p3) do tinsert(l, v) end
	end

	if getn(l) == 0 then return nil end

	frame:SetSize(140, 5+17*getn(l))
	
	frame.text = frame:CreateFontString(nil,"ARTWORK") 
	frame.text:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	frame.text:SetPoint("TOPLEFT",5,-5)
	
    frame.text:SetText(table.concat(l, "\n"))

	frame:Hide()
	
	function frame:ShowParent(parent)
		self:SetParent(parent)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT",parent,"TOPRIGHT")
		self:Show()
	end
	
	function frame:HideParent()
		self:SetParent(UIParent)
		self:Hide()
	end
	return frame
end

function Prio3:OPEN_MASTER_LOOT_LIST()
	if Prio3.MLF ~= nil then 
		-- hide old frame. Will still be in memory and attached to Master Looter Frame, so needs to be hidden here
		Prio3.MLF:Hide()
		Prio3.MLF:SetParent(nil) 
	end
	-- garbage collection will take this up later on
	Prio3.MLF = nil
	
	
	if Prio3.db.profile.showmasterlooterhint then
		itemLink = GetLootSlotLink(LootFrame.selectedSlot);
		local itemID = select(3, strfind(itemLink, "item:(%d+)"))

		Prio3.MLF = self:CreateMasterLootInfoFrame(itemID)
		if Prio3.MLF ~= nil then Prio3.MLF:ShowParent(MasterLooterFrame) end
	end
end