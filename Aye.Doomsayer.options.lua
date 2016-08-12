local Aye = Aye;
if not Aye.load then return end;

Aye.options.args.Doomsayer = {
	name = "Doomsayer",
	type = "group",
	args = {
		header1 = {
			order = 1,
			type = "header",
			name = "Doomsayer",
		},
		description2 = {
			order = 2,
			type = "description",
			name = "This addon shows players in raid (or group) with |cffe6cc80No Demon Detection|r.\n"
				.. "Warns upon joining the new member to raid or on command: |cffe6cc80/aye doomsayer|r\n\n"
				.. "Addon deticated for raid leaders searching |cff0070dd|Hitem:140363:0:0:0:0:0:0:0:0:0:0|h[Pocket Fel Spreader]|h|r in Doomsayer during Broken Shore Scenario. "
				.. "Addon check if player is either |cffaad372Hunter|r, |cffa330c9Demon Hunter|r, or have active either |cffffd000|Hspell:47524|h[Sense Demons]|h|r "
				.. "or |cffffd000|Hspell:11407|h[Detect Demon]|h|r buff."
			,
		},
		header71 = {
			order = 71,
			type = "header",
			name = "Chat Channel",
		},
		description72 = {
			order = 72,
			type = "description",
			name = "\"|cffe6cc80Raid|r\" means \"|cfff3e6c0Instance|r\" in LFR, or \"|cfff3e6c0Party|r\" if player is not in raid."
				.. "\n\"|cffe6cc80Raid Warning|r\" channel behaves like \"|cffe6cc80Raid|r\" if player cannot Raid Warning."
				.. "\n\"|cffe6cc80Dynamic|r\" is min. channel, where everybody can hear you (\"|cfff3e6c0Say|r\", \"|cfff3e6c0Yell|r\", or \"|cffe6cc80Raid|r\").\n"
			,
		},
		channel = {
			order = 73,
			name = "Chat Channel",
			desc = "The chat channel where message will be sent",
			type = "select",
			values = {
				Print	= "|cff9d9d9dPrint|r",
				Say		= "|cffffffffSay|r",
				Yell	= "|cffffffffYell|r",
				Raid	= "|cffe6cc80Raid|r",
				RW		= "|cffe6cc80Raid Warning|r",
				Dynamic	= "|cffe6cc80Dynamic|r",
				Guild	= "|cffffffffGuild|r",
				Officer	= "|cffffffffOfficer|r",
			},
			get = function() return Aye.db.global.Doomsayer.channel end,
			set = function(_, v) Aye.db.global.Doomsayer.channel = v end,
		},
	},
};