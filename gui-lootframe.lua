local L = LibStub("AceLocale-3.0"):GetLocale("CheeseSLS");
local debug = false;

-- todo config options whether to show loot poll gui frame

function CheeseSLS:guiLFShowLootframe(charname, lootitem, loottype)
	if (self.lootframes == nil) then
		self.lootframes = {};
	end
	local i = 0;
	while (self.lootframes[i] ~= nil) do
		i = i + 1;	 
	end

	local AceGUI = LibStub("AceGUI-3.0");
	
	local f = AceGUI:Create("Frame");
	self.lootframes[i] = f;
	f:SetTitle("CheeseSLS Loot")
	f:SetStatusText("")
	f:SetLayout("Flow")
	f:SetWidth(450)
	f:SetHeight(225)
	f.width = "fill"
	
	local hdPlayer = AceGUI:Create("Heading");
	hdPlayer:SetText(L["Player X got loot"](charname));
	hdPlayer.width = "fill";
	f:AddChild(hdPlayer);
	
	local lbLoot = AceGUI:Create("Label");
	lbLoot:SetText(lootitem);
	lbLoot.width = "fill";
	f:AddChild(lbLoot);
	
	local playername = "not in list";
	local costs = 0;
	local playernameset = charname;
	
	if (CheeseSLS:fncExistsChar(charname)) then
		playername = CheeseSLS:fncGetPlayer(charname);
			
		if (loottype == 'Loot') then
			costs = CheeseSLS:fncDebitPlayerCalcLoot(charname);
		elseif (loottype == 'Offspec') then
			costs = CheeseSLS:fncDebitPlayerCalcOffspec(charname);
		end
	
		local pt = self.db.global.varDKP["players"];


		playernameset = playername;
		if (charname == playername) then
			playernameset = playername .. " " .. pt[playername]["dkp_current"] .. 
				" [" .. pt[playername]["rank"] .. "]: " .. L['costs'] .. " " .. costs;
    	else
        	playernameset = charname .. " (" .. playername .. ") " ..  pt[playername]["dkp_current"] .. 
        		" [" .. pt[playername]["rank"] .. "]: " .. L['costs'] .. " " .. costs;
    	end

	else
		playername = charname;
		playernameset = charname .. " [-]";
	end

	local lbPlayerNameSet = AceGUI:Create("Label");
	lbPlayerNameSet:SetText(playernameset);
	lbPlayerNameSet.width = "fill";
	f:AddChild(lbPlayerNameSet);
	
	if (loottype == 'Loot') then
		local hdLoottype = AceGUI:Create("Heading");
		hdLoottype:SetText(L["Player X requested LOOT."](charname));
		hdLoottype.width = "fill";
		f:AddChild(hdLoottype);
		
		local btnLoot = AceGUI:Create("Button");
		btnLoot:SetText(L["debit X for LOOT"](charname));
		btnLoot:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnLoot(f, charname, lootitem, loottype) end);
		btnLoot.frame:SetWidth("400");
		f:AddChild(btnLoot);

		local hdAlternatives = AceGUI:Create("Heading");
		hdAlternatives:SetText(L["Alternatives"]);
		hdAlternatives.width = "fill";
		f:AddChild(hdAlternatives);
		
		local btnOffspec = AceGUI:Create("Button");
		btnOffspec:SetText(L["debit for offspec"]);
		btnOffspec:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnOffspec(f, charname, lootitem, loottype) end);
		f:AddChild(btnOffspec);

		local btnNone = AceGUI:Create("Button");
		btnNone:SetText(L["no debit"]);
		btnNone:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnNone(f, charname, lootitem, loottype) end);
		f:AddChild(btnNone);
	
	elseif (loottype == 'Offspec') then
		local hdLoottype = AceGUI:Create("Heading");
		hdLoottype:SetText(L["Player X requested OFFSPEC."](charname));
		hdLoottype.width = "fill";
		f:AddChild(hdLoottype);
	
		local btnOffspec = AceGUI:Create("Button");
		btnOffspec:SetText(L["debit X for OFFSPEC"](charname));
		btnOffspec:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnOffspec(f, charname, lootitem, loottype) end);
		btnOffspec.frame:SetWidth("400");
		f:AddChild(btnOffspec);

		local hdAlternatives = AceGUI:Create("Heading");
		hdAlternatives:SetText(L["Alternatives"]);
		hdAlternatives.width = "fill";
		f:AddChild(hdAlternatives);
		
		local btnLoot = AceGUI:Create("Button");
		btnLoot:SetText(L["debit for loot"]);
		btnLoot:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnLoot(f, charname, lootitem, loottype) end);
		f:AddChild(btnLoot);

		local btnNone = AceGUI:Create("Button");
		btnNone:SetText(L["no debit"]);
		btnNone:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnNone(f, charname, lootitem, loottype) end);
		f:AddChild(btnNone);
	
	else 
		local hdLoottype = AceGUI:Create("Heading");
		hdLoottype:SetText(L["Player X did not request this item."](charname));
		hdLoottype.width = "fill";
		f:AddChild(hdLoottype);
	
		local btnNone = AceGUI:Create("Button");
		btnNone:SetText(L["no debit"]);
		btnNone:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnNone(f, charname, lootitem, loottype) end);
		btnNone.frame:SetWidth(400);
		f:AddChild(btnNone);
		
		local hdAlternatives = AceGUI:Create("Heading");
		hdAlternatives:SetText(L["Alternatives"]);
		hdAlternatives.width = "fill";
		f:AddChild(hdAlternatives);
		
		local btnLoot = AceGUI:Create("Button");
		btnLoot:SetText(L["debit for loot"]);
		btnLoot:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnLoot(f, charname, lootitem, loottype) end);
		f:AddChild(btnLoot);

		local btnOffspec = AceGUI:Create("Button");
		if (self.db.global.config.usedualspec) then
			btnOffspec:SetText(L["debit for dual/offspec"]); 
		else
			btnOffspec:SetText(L["debit for offspec"]);
		end
		btnOffspec:SetCallback("OnClick", function() CheeseSLS:guiLFEventBtnOffspec(f, charname, lootitem, loottype) end);
		f:AddChild(btnOffspec);

	end
	
	f:Show();
end

function CheeseSLS:guiLFEventBtnLoot(f, charname, lootitem, loottype)
	-- self:Print('pressed loot');
	CheeseSLS:fncDebitPlayerLoot(charname);
	f:Hide();
end

function CheeseSLS:guiLFEventBtnOffspec(f, charname, lootitem, loottype)
	CheeseSLS:fncDebitPlayerOffspec(charname);
	f:Hide();
end

function CheeseSLS:guiLFEventBtnNone(f, charname, lootitem, loottype)
	-- self:Print('pressed none');
	f:Hide();
end