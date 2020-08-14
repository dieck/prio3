local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

Prio3.yesnoframe = nil

function Prio3:createYesNoFrame(title, text, yes, no)
	return Prio3:createTwoDialogFrame(title, text, L["Disable"], yes, L["Keep on"], no)
end

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
	_G["Prio3Prio3.yesnoframe"] = f.frame
	tinsert(UISpecialFrames, "Prio3Prio3.yesnoframe")
	
	local txt = AceGUI:Create("Label")
	txt:SetText(text)
	txt:SetRelativeWidth(1)
	f:AddChild(txt)

	local button1 = AceGUI:Create("Button")
	button1:SetText(onetxt)
	button1:SetRelativeWidth(0.5)
	button1:SetCallback("OnClick", function()
		Prio3.yesnoframe:Hide()
		one()
	end)
	f:AddChild(button1)

	local button2 = AceGUI:Create("Button")
	button2:SetText(twotxt)
	button2:SetRelativeWidth(0.5)
	button2:SetCallback("OnClick", function()
		Prio3.yesnoframe:Hide()
		two()
	end)
	f:AddChild(button2)

	return f
end


function Prio3:askToDisable(question) 

	yes = function() 
		Prio3.db.profile.enabled = false
	end
	
	no = function()
		-- do nothing
	end

	Prio3.yesnoframe = Prio3:createYesNoFrame("Disable Addon?", question, yes, no)
	Prio3.yesnoframe:Show()
		
end

-- /script Prio3:askToDisable() 
-- /script Prio3:Print(Prio3.db.profile.enabled)