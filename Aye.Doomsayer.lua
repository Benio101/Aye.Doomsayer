local Aye = Aye;
if not Aye.addModule("Aye.Doomsayer") then return end;

Aye.modules.Doomsayer.OnEnable = function()
	-- start profiling (used to get ms precision)
	if debugprofilestop() == nil then
		debugprofilestart();
	end;
end;

Aye.modules.Doomsayer.slash = function()
	Aye.modules.Doomsayer.warn();
end;

Aye.modules.Doomsayer.events.RAID_ROSTER_UPDATE = function()
	Aye.modules.Doomsayer.warn();
end;

-- Check group and eventually warn about failings
--
-- @noparam
-- @noreturn
Aye.modules.Doomsayer.warn = function()
	local members = max(1, GetNumGroupMembers());
	
	-- table of subjects to check
	-- every subject contains:
	-- 	t		-- 				table of players that met criteria, ex. list of Dead Players for Dead subject
	-- 	name	-- 				name of subject to report
	--
	-- Every .t and contains table:
	--	name	--				name of player
	local t = {
		Offline			= {t = {}, name = "Offline"},
		Dead			= {t = {}, name = "Dead"},
		DemonDetection	= {t = {}, name = "No Demon Detection (can be wrong out of range)"},
	};
	
	-- check subjects
	for i = 1, members do
		-- in raid, every player have "raidX" id where id begins from 1 and ends with member number
		-- in party, there is always "player" and every NEXT members are "partyX" where X begins from 1
		-- especially, in full party, there are: "player", "party1", "party2", "party3", "party4" and NO "party5"
		local unitID = UnitInRaid("player") ~= nil and "raid" ..i or (i == 1 and "player" or "party" ..(i -1));
		local name = UnitName(unitID);
		
		if name then
		if
				not	UnitIsConnected(unitID)
		then
			table.insert(t.Offline.t, {["name"] = name});
		end;
		
		if UnitIsConnected(unitID) then
		if
				UnitIsDeadOrGhost(unitID)
		then
			table.insert(t.Dead.t, {["name"] = name});
		end;
		
		if not UnitIsDeadOrGhost(unitID) then
		if UnitIsVisible(unitID) then -- credits for checking function to: Vlad#WoWUIDev and nebula#WoWUIDev
			for k, v in pairs({
				-- ["c"]ondition setting
				-- ["f"]unction to check condition
				-- ["t"]able to insert players
				{
					["c"] = function() return true end,
					["f"] = Aye.utils.Buffs.UnitCanDetectDemons,
					["t"] = t.DemonDetection.t
				},
			}) do
				if v.c then
					-- buff checking function return, table:
					-- 	buff = uint, one of:
					-- 		0 = not able to detect demons
					--		1 = able to detect demons
					local buff, note = v.f(unitID);
					
					-- No buff
					if buff == 0 then
						table.insert(v.t, {["name"] = name});
					end;
				end;
			end;
		end;
		end;
		end;
		end;
	end;
	
	-- remove group subject entries with no issues
	for k0, v0 in pairs(t) do
		for k = #v0.t, 1, -1 do
			if v0.t[k].buff ~= nil and #v0.t[k].t ==0 then
				table.remove(t[k0].t, k);
			end;
		end;
	end;
	
	-- report subjects
	for k, v in pairs(t) do
		if #v.t >0 then Aye.modules.Doomsayer.report(v.t, v.name) end;
	end;
end;

-- Reports given @subject as a warning
--
-- @param {object} t
-- 		{string} t.name player nick
--
-- @param {string} subject subject to report, ex. "Dead"
--
-- @example
--| table.insert(t, {["name"] = NICK});						-- WARNING! subject (X): NICK
--| table.insert(t, {["name"] = NICK, ["note"] = NOTE});	-- WARNING! subject (X): NICK (NOTE)
--
-- @example input
--| local t;
--| table.insert(t, {["name"] = "Foo"});
--| table.insert(t, {["name"] = "Bar"});
--| table.insert(t, {["name"] = "Baz"});
--| Aye.modules.Doomsayer.report(t, "No Demon Detection");
--
-- @example output
--> WARNING! No Demon Detection (3): Foo, Bar, Baz
Aye.modules.Doomsayer.report = function(t, subject)
	local m = "";
	for i, o in pairs(t) do
		if m ~= "" then
			m = m ..", ";
		end;
		
		m = m ..o.name;
		if type(o.note) == "number" or type(o.note) == "string" then
			m = m .." (" ..o.note ..")";
		end;
	end;
	
	m = "[Aye] ".. GetSpellLink(176781) -- "WARNING!" spell
		.." " ..subject .." (" ..#t .."): " ..m;
	
	if
			Aye.db.global.Doomsayer.channel == "Print"
		or	(
					(
							Aye.db.global.Doomsayer.channel == "RW"
						or	Aye.db.global.Doomsayer.channel == "Raid"
					)
				and	not IsInGroup()
			)
		or	(
					(
							Aye.db.global.Doomsayer.channel == "Guild"
						or	Aye.db.global.Doomsayer.channel == "Officer"
					)
				and	not IsInGuild()
			)
		or	(
				InGuildParty()
			)
	then
		print(m);
	elseif Aye.db.global.Doomsayer.channel == "Dynamic" then
		Aye.utils.Chat.SendChatMessage(m);
	elseif Aye.db.global.Doomsayer.channel == "RW" then
		SendChatMessage(m, Aye.utils.Chat.GetGroupChannel(true));
	elseif Aye.db.global.Doomsayer.channel == "Raid" then
		SendChatMessage(m, Aye.utils.Chat.GetGroupChannel(false));
	else
		SendChatMessage(m, Aye.db.global.Doomsayer.channel);
	end;
end;