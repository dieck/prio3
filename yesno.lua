local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

function Prio3:createTwoDialogFrame(title, text, onetxt, one, twotxt, two)
	local AceGUI = LibStub("AceGUI-3.0")

	local f = AceGUI:Create("Frame")
	f:SetTitle(title)
	f:SetStatusText("")
	f:SetLayout("Flow")
	f:SetWidth(300)
	f:SetHeight(150)
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	
	-- close on escape
	_G["Prio3Prio3.twodialogframe"] = f.frame
	tinsert(UISpecialFrames, "Prio3Prio3.twodialogframe")
	
	local txt = AceGUI:Create("Label")
	txt:SetText(text)
	txt:SetRelativeWidth(1)
	f:AddChild(txt)

	local button1 = AceGUI:Create("Button")
	button1:SetText(onetxt)
	button1:SetRelativeWidth(0.5)
	button1:SetCallback("OnClick", function()
		one()
	end)
	f:AddChild(button1)

	local button2 = AceGUI:Create("Button")
	button2:SetText(twotxt)
	button2:SetRelativeWidth(0.5)
	button2:SetCallback("OnClick", function()
		two()
	end)
	f:AddChild(button2)

	return f
end


function Prio3:createThreeDialogFrame(title, text, onetxt, one, twotxt, two, threetxt, three)
	local AceGUI = LibStub("AceGUI-3.0")

	local f = AceGUI:Create("Frame")
	f:SetTitle(title)
	f:SetStatusText("")
	f:SetLayout("Flow")
	f:SetWidth(400)
	f:SetHeight(150)
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	
	-- close on escape
	_G["Prio3Prio3.threedialogframe"] = f.frame
	tinsert(UISpecialFrames, "Prio3Prio3.threedialogframe")
	
	local txt = AceGUI:Create("Label")
	txt:SetText(text)
	txt:SetRelativeWidth(1)
	f:AddChild(txt)

	local button1 = AceGUI:Create("Button")
	button1:SetText(onetxt)
	button1:SetRelativeWidth(0.33)
	button1:SetCallback("OnClick", function()
		one()
	end)
	f:AddChild(button1)

	local button2 = AceGUI:Create("Button")
	button2:SetText(twotxt)
	button2:SetRelativeWidth(0.33)
	button2:SetCallback("OnClick", function()
		two()
	end)
	f:AddChild(button2)

	local button3 = AceGUI:Create("Button")
	button3:SetText(threetxt)
	button3:SetRelativeWidth(0.33)
	button3:SetCallback("OnClick", function()
		three()
	end)
	f:AddChild(button3)


	return f
end


function Prio3:askToDisable(question) 
	Prio3.askframe = nil

	yes = function() 
		Prio3.askframe:Hide()
		Prio3.db.profile.enabled = false
		Prio3:Print(L["Prio3 addon is currently disabled."]) 
	end

	clear = function()
		Prio3.askframe:Hide()
		Prio3.db.profile.priorities = {}
		Prio3:Print(L["No priorities defined."]) 
	end
	
	no = function()
		Prio3.askframe:Hide()
		-- do nothing
	end

	Prio3.askframe = Prio3:createThreeDialogFrame("Disable Addon?", question, L["Disable"], yes, L["Clear priorities"], clear, L["Keep on"], no)
	Prio3.askframe:Show()
end
