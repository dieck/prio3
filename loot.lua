local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

function Prio3:handleChatCommand()
	Prio3:guiPriorityFrame()
end

function Prio3:guiPriorityFrame()
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
		
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(prios[1])

		local lbIcon = AceGUI:Create("Icon")
		lbIcon:SetRelativeWidth(0.04)
		lbIcon:SetImage(itemTexture)
		lbIcon:SetImageSize(15,15)
		lbIcon:SetCallback("OnEnter", function(widget)
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
		
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(prios[2])

		local lbIcon = AceGUI:Create("Icon")
		lbIcon:SetRelativeWidth(0.04)
		lbIcon:SetImage(itemTexture)
		lbIcon:SetImageSize(15,15)
		lbIcon:SetCallback("OnEnter", function(widget)
--			GameTooltip_SetDefaultAnchor( GameTooltip, UIParent )
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
		
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(prios[3])

		local lbIcon = AceGUI:Create("Icon")
		lbIcon:SetRelativeWidth(0.04)
		lbIcon:SetImage(itemTexture)
		lbIcon:SetImageSize(15,15)
		lbIcon:SetCallback("OnEnter", function(widget)
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

	f:Show()
end
