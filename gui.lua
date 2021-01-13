local L = LibStub("AceLocale-3.0"):GetLocale("Prio3", true)

Prio3.lootframe = nil

function Prio3:handleChatCommand(cmd)

	if cmd == "config" then
		if not Prio3.lootframe == nil then 
			Prio3.lootframe:Hide() 
		end
		LibStub("AceConfigDialog-3.0"):Open("Prio3")

	elseif (cmd == "help") or (tempty(self.db.profile.priorities)) then
		Prio3:guiHelpFrame()

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
		if Prio3.db.profile.debug then Prio3:Print("DEBUG: requested window to open after GET_ITEM_INFO_RECEIVED") end
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
	
	local f = AceGUI:Create("Window")
	f:SetTitle(L["Priority List"] .. " " .. strsub(Prio3.versionString, 1, 9))
	f:SetStatusText("")
	f:SetLayout("Flow")
	f:SetWidth(700)
	f:SetHeight(500)
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	
	-- close on escape
	_G["Prio3.lootframeFrame"] = f.frame
	tinsert(UISpecialFrames, "Prio3.lootframeFrame")

	local btCfg = AceGUI:Create("Button")
	btCfg:SetText("Config / Import")
	btCfg:SetRelativeWidth(0.5)
	btCfg:SetCallback("OnClick", function()
		Prio3.lootframe:Hide()
		LibStub("AceConfigDialog-3.0"):Open("Prio3")
	end)
	f:AddChild(btCfg)

	local btHelp = AceGUI:Create("Button")
	btHelp:SetText("Help")
	btHelp:SetRelativeWidth(0.5)
	btHelp:SetCallback("OnClick", function()
		Prio3.lootframe:Hide()
		Prio3:guiHelpFrame()
	end)
	f:AddChild(btHelp)
	
	scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true) -- probably?
	scrollcontainer:SetLayout("Fill") -- important!

	f:AddChild(scrollcontainer)

	s = AceGUI:Create("ScrollFrame")
	s:SetLayout("Flow") -- probably?
	scrollcontainer:AddChild(s)
	
	
	for user, prios in pairs(self.db.profile.priorities) do
	
				function processPrio (prioNumber)
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(prios[prioNumber])

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
				if (Prio3.db.profile.debug) then 
					lbPrio:SetText("("..prios[prioNumber]..") " .. itemLink)
				else 
					lbPrio:SetText(itemLink)
				end
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
		end	
		
		function noPrio(prioNumber)
			local lbIcon = AceGUI:Create("Icon")
				lbIcon:SetRelativeWidth(0.04)
				lbIcon:SetImage("Interface\\Icons\\ability_vanish")
				lbIcon:SetImageSize(15,15)
				s:AddChild(lbIcon)

				local lbPrio = AceGUI:Create("InteractiveLabel")
				lbPrio:SetText("-no prio "..prioNumber.." set-")
				lbPrio:SetRelativeWidth(0.20)
				s:AddChild(lbPrio)
		end
	
		local lbPlayerName = AceGUI:Create("Label")
		lbPlayerName:SetText(user)
		lbPlayerName:SetRelativeWidth(0.24)
		s:AddChild(lbPlayerName)	
		
		if tonumber(prios[1]) > 0 then processPrio(1) else noPrio(1) end
		if tonumber(prios[2]) > 0 then processPrio(2) else noPrio(2) end
		if tonumber(prios[3]) > 0 then processPrio(3) else noPrio(3) end
		
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


function Prio3:guiHelpFrame()
	if Prio3.helpframe == nil then
		Prio3.helpframe = Prio3:createHelpFrame()
		Prio3.helpframe:Hide()
	end
	if Prio3.helpframe:IsShown() then
		Prio3.helpframe:Hide()
	else
		Prio3.helpframe:Show()
	end
end


function Prio3:createHelpFrame()
	local AceGUI = LibStub("AceGUI-3.0")

	local f = AceGUI:Create("Window")
	f:SetTitle(L["Prio3 Help"] .. " " .. strsub(Prio3.versionString, 1, 9))
	f:SetStatusText("")
	f:SetLayout("Flow")
	f:SetWidth(700)
	f:SetHeight(500)
	f:EnableResize(true)

-- do not release!	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)

	-- close on escape
	_G["Prio3.helpframeFrame"] = f.frame
	tinsert(UISpecialFrames, "Prio3.helpframeFrame")

	local btCfg = AceGUI:Create("Button")
	btCfg:SetText("Config / Import")
	btCfg:SetRelativeWidth(0.5)
	btCfg:SetCallback("OnClick", function()
		Prio3.helpframe:Hide()
		LibStub("AceConfigDialog-3.0"):Open("Prio3")
	end)
	f:AddChild(btCfg)

	local btPrio = AceGUI:Create("Button")
	btPrio:SetText(L["Priority List"])
	btPrio:SetRelativeWidth(0.5)
	btPrio:SetCallback("OnClick", function()
		Prio3.helpframe:Hide()
		Prio3:guiPriorityFrame()
	end)
	f:AddChild(btPrio)
	
	
	local tabGroup = AceGUI:Create("TabGroup")
	tabGroup:SetFullWidth(true)
	tabGroup:SetFullHeight(true)
	tabGroup:SetLayout("Fill")
	tabGroup:SetTabs({
		{ value = "tl;dr", text = L["tl;dr"] },
		{ value = "prio3", text = L["Prio3 System"] },
		{ value = "manual", text = L["Manual"] },
	})
	tabGroup:SetCallback("OnGroupSelected", function(widget, event, group) Prio3:HelpFrameTabChange(widget, event, group) end)
	tabGroup:SelectTab("tl;dr")

	f:AddChild(tabGroup)
	
	return f
end

function Prio3:HelpFrameTabChange(container, event, group)
    container:ReleaseChildren()

    if group == "tl;dr" then
		Prio3:HelpFrameTab_tldr(container)
    elseif group == "prio3" then
		Prio3:HelpFrameTab_prio3(container)
    elseif group == "manual" then
		Prio3:HelpFrameTab_manual(container)
    end
end

function Prio3:HelpFrameTab_tldr(container)
	local AceGUI = LibStub("AceGUI-3.0")

	s = AceGUI:Create("ScrollFrame")
	s:SetLayout("Flow") -- probably?
	container:AddChild(s)

	local function heading(c, txt) 
		i = AceGUI:Create("Heading")
		i:SetText(txt)
		i:SetRelativeWidth(1)
		c:AddChild(i)
	end

	local function label(c, txt) 
		i = AceGUI:Create("Label")
		i:SetText(txt)
		i:SetRelativeWidth(1)
		c:AddChild(i)
	end

	heading(s, L["tl;dr"])
	label(s, L["Import Priorities or have people whisper in priorities. Loot corpses and have chosen loot announced in raid chat."])
	
	sgig = AceGUI:Create("InlineGroup")
	sgig:SetRelativeWidth(0.5)
	s:AddChild(sgig)
	
	heading(sgig, L["tl;dr In-Game"])
	label(sgig, L["Go to /prio3 config, Import, Accept whispers"])
	label(sgig, L["For initial round, turn *off* Accept only new"])
	label(sgig, L["Start accepting whispers"])
	label(sgig, L["You can verify who answered by /prio3"])
	label(sgig, L["End accepting whispers if all players entered"])
	label(sgig, L["For late joiners, re-enable Accept only new before allowing whispers"])
	label(sgig, L["Participants will need to have the Prio3 addon to see current list."])
	label(sgig, L["If enabled in config, Participants can use whisper queries to find out who else has their items on prio."])

	sgde = AceGUI:Create("InlineGroup")
	sgde:SetRelativeWidth(0.5)
	s:AddChild(sgde)
	
	heading(sgde, L["tl;dr German users"])
	label(sgde, L["I really encourage you to use sahne-team.de!"])
	label(sgde, L["Top left: Priorun, Priorun Erstellen, chose Server, Char and Class."])
	label(sgde, L["*Note down the Admin Pin to the top right for yourself, if you get disconnected*."])
	label(sgde, L["Go to Raid Ziel, choose instance. Announce Prio PIN from Regeln or Spieler tab to participants (not Admin Pin!)."])
	label(sgde, L["Put in your priorities in Spieler tab."])
	label(sgde, L["When all have entered, go to Regeln - ANZEIGEN,"])
	label(sgde, L["then to Prioliste and download one of the exports on top, e.g. TXT."])
	label(sgde, L["Copy&Paste to /prio3 config, Import field"])
		
	
	label(s, L["You could also gather your raid priorities externally, e.g. using Google Doc."])
	
	label(s, L["Generate loot lists in format Username;Prio1;Prio2;Prio3 per line, using ItemIDs or e.g. wowhead links, and use /prio3 config, Import"])
	label(s, L["You could opt to enable sending in priorities by whispers in the same menu, good option also for strugglers or replacement raiders."])

end


function Prio3:HelpFrameTab_prio3(container)
	local AceGUI = LibStub("AceGUI-3.0")

	s = AceGUI:Create("ScrollFrame")
	s:SetLayout("Flow") -- probably?
	container:AddChild(s)

	local function heading(c, txt) 
		i = AceGUI:Create("Heading")
		i:SetText(txt)
		i:SetRelativeWidth(1)
		c:AddChild(i)
	end

	local function label(c, txt) 
		i = AceGUI:Create("Label")
		i:SetText(txt)
		i:SetRelativeWidth(1)
		c:AddChild(i)
	end

	heading(s, L["What is Priority 3 Looting?"])
	label(s, L["This loot distribution scheme is based on participants choosing up to three items they want to gain priority on when they actually drop."])
	label(s, L["It is especially nice for pug raids or raids with a high amount of random fillers, as there is no history, no earning of points, everyone starts the same with every raid. But of course it can also be of value on regular raid groups that do not want the hassle of full DKP tracking or avoid long loot council discussions."])
	label(s, L["Side note: Prio 3 does not distinguish between main/need and offspec/greed priorities. It can thus be a good choice if you want to collect offspec gear for your char. (Hint: In order to avoid grief on main spec characters who are interested in the same items, it could be better to announce this intention beforehand.)"])
	
	heading(s, L["So, how does this work now?"])

	label(s, L["Before the raid, you will choose (up to) 3 items you want to have priority on."])
	label(s, L["Mostly, the raid lead or designated PM is collecting these requests, noting them down. Sometimes a Google Doc is used to post as read only link to users later on."])
	label(s, L["Prio3 can also be used to collect these requests in-game. See tl;dr tab for a short intro."])
	
	sg = AceGUI:Create("InlineGroup")
	sg:SetRelativeWidth(1)
	s:AddChild(sg)
	
	label(sg, L["sahne-team.de usage: If you are a German user, please try this website! It eases up coordinating Prio loot a lot."])
	label(sg, L["You setup a run on the Priorun function to the upper left, select a target instance, and give the Run PIN to your participants."])
	label(sg, L["Please remember to note down your admin pin from the upper right corner!"])
	label(sg, L["Every user can choose their items, in secret. Even the admin cannot see those."])
	label(sg, L["After all participants have chosen their loot, the admin can set the run to be visible for all."])
	label(sg, L["For use with the Prio3 addon, you can then use the Exports."])
	label(sg, L["Prio3 native would be CSV Short, but the addon can actually read sahne-team.de full CSV and TXT export as well."])
	
	
	label(s, L["If the loot drops, it will be handled along the priority table, starting with all users that have this on Priority 1."])
	label(s, L["If there is only one user: Congrats, you have a new item."])
	label(s, L["If there are more users with the same priority, those are asked to roll for the item, highest roll wins."])
	label(s, L["Every user will get only one item per priority. If an items drops a second time, it is handled among the others with the highest remaining priority."])
	label(s, L["If no one selected that particular item for Prio 1, then Prio 2 will be handled, and afterwards Prio 3. For all items where no one set a Priority, those are usually handled by FFA. Some raids tend to apply main>offspec here."])
	label(s, L["Of course choosing which items to put where, that is part of the fun, and risk. Do I put this item on Prio 1, because others may want it too? Or it is unlikely, and I can savely put it on Prio 3?"])
	
	heading(s, L["Where does the Prio3 addon comes into play?"])
	label(s, L["Looking up if someone actually has marked down a priority can be a tedious task, and it's easy to miss someone."])
	label(s, L["The Prio3 addon will notify you on looting if there are any Priorities set up."])
	label(s, L["This way you don't have to switch to your lookup table, e.g. on a website like sahne-team.de or a google doc, or even a handwritten note. It will announce this to the raid (by default), or only to the char using the addon and looting (should normally be the PM)."])

end


function Prio3:HelpFrameTab_manual(container)
	local AceGUI = LibStub("AceGUI-3.0")

	s = AceGUI:Create("ScrollFrame")
	s:SetLayout("Flow") -- probably?
	container:AddChild(s)

	local function heading(c, txt) 
		i = AceGUI:Create("Heading")
		i:SetText(txt)
		i:SetRelativeWidth(1)
		c:AddChild(i)
	end

	local function label(c, txt) 
		i = AceGUI:Create("Label")
		i:SetText(txt)
		i:SetRelativeWidth(1)
		c:AddChild(i)
	end
	
	local function code(c, txt)
		cg = AceGUI:Create("InlineGroup")
		cg:SetRelativeWidth(1)

		if type(txt) ~= "table" then
			txt = {txt}
		end
		
		for _,t in pairs(txt) do 
			local i = AceGUI:Create("Label")
			i:SetText(t)
			i:SetFont(GameFontGreenSmall:GetFont())
			i:SetColor(33,200,0)
			i:SetRelativeWidth(1)
			cg:AddChild(i)
		end
		
		c:AddChild(cg)

	end

	heading(s, L["IMPORT, or How does the addon know about the priorities?"])
	
	label(s, L["You can import simple CSV strings on the Addon config page (Menu Interfaces, Tab Addon, Prio3)"])
	code(s, {"Username;Prio1;Prio2;Prio3", "..."})
	
	label(s, L["where Prio1, 2, 3 can be numeric item Ids, or even strings with the IDs somewhere in (will take first number found), e.g. wowhead links. This is basically the CSV-SHORT export format of sahne-team.de."])
	
	label(s, L["Also accepted format: sahne-team.de CSV normal export, with german header line:"])
	code(s, {"Name;Klasse;prio1itemid;prio2itemid;prio3itemid;prio1itemname;prio2itemname;prio3itemname;", "Username;Class;ID1;ID2;ID3;Name1;Name2;Name3;", "..."})
	
	label(s, L["Also accepted format: sahne-team.de TXT export (tab » separated)"])
	code(s, {"Username»»Class»»Name1-ID1»Name2-ID2»Name3-ID3", "..."})
 
	label(s, L["If you need further formats, please let me know."])
		
	label(s, L["Players can be informed by whispers about imported priorities (configurable in options)"])
	
	label(s, L["You could opt for accepting priorities by whisper. Go to Menu Interfaces, Tab Addon, Prio3; or type /prio3 config, and to go Import. This is a good option also for late joiners / replacements. See also tl;dr section."])

	heading(s, L["OUTPUT, or What happens when loot drops"])

	label(s, L["You can choose the output language independent of your client languague. Currently only English and German are supported. If you are interested in helping out with another translation, please let me know on http://github.com/dieck/prio3"])

	label(s, L["Announcing to Raid is the main functionality. It will post to raid when it encounters loot where someone has a priority on. It will post one line per Priority (1,2,3), with the chars who have listed it."])
	label(s, L["You can also announce if there is No Priority set up for an item."])
	label(s, L["Announces will react to the minimum quality setting. Recommendation: Epic for most raids, Rare for AQ20"])
	
	label(s, L["You can also whisper to players if there is loot that they have chosen."])
		
	label(s, L["Prio3 will react to loot events (if you open a loot window)"])
	label(s, L["You can configure it to also react to rolls (if e.g. there is no PM and the roll window starts) and to raid warnings (if e.g. someone else does Master Looter). You can also configure to ignore Onyxia Cloaks posted as raid warnings. Special service for BWL Prio3 runs :)"])
		
	label(s, L["In order to avoid multiple posts, e.g. if you loot a corpse twice, there is a mute setting pausing outputs for a defined time."])

	label(s, L["For Master Looter, a hint window can be added to the distribution window, showing all priorities for an item"])
	
	heading(s, L["QUERIES, or How to look up and validate priorities"])

	label(s, L["For addon users, /prio3 will open up a priority list"])
	
	label(s, L["There are three options for your raid participants to query for Prio3 entries (can be turned on and off in options):"])
	label(s, L["* Whisper 'prio' to get your own priorities. (default: on)"])
	label(s, L["* Whisper 'prio USERNAME' to look up another raid member. (default: off)"])
	label(s, L["* Whisper 'prio ITEMLINK' to look up priorities on an item. (default: on)"])
	label(s, L["(If you don't get an answer at all, ask your Prio3 master if they turned on the options)"])
	
	heading(s, L["SYNC & HANDLER, or How does this work with multiple people"])

	label(s, L["Here are two options to handle how the addon talks to other users in the same raid. It is HIGHLY recommended to leave both turned on."])
	label(s, L["Sync priorities will sync the list of items between multiple users, on import / end of accepting whispers. Without this option, multiple users could have different priorities, and depending on the next option it might not be clear whose are posted."])
	label(s, L["The Resend prios button will send out Prios if needed - normally when someone new with the addon joins the raid, it will be synced automatically. But if the disabled the addon and turns it on later, you can send out your priorities with this."])
	
	label(s, L["Sync item announcements will coordinate between multiple users' addons which user will actually post to raid (depending on output options). This is to avoid multiple posts of the same information. (May still happen though if addon communication is lagging slightly)."])

	label(s, L["Also, you can opt to use /prio or /p3 in addition to /prio3 as command line trigger."])
	
	
	heading(s, L["and more"])
	
	label(s, L["There is a 'Versions' tab in the options, which is basically only there for debugging purposes."])
	label(s, L["Users are notified if they have an older version of the application."])
	label(s, L["Until now, all addon synchronisation features were backwards compatible. If this changes at some point in time, a comprehensive error message will be put in place"])
	
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
