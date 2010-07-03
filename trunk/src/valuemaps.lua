-- Begin valuemaps.lua
-- Common value descriptions
local Descs = {
	-- Boolean values
	YesNo = {
		[1] = "Yes",
		[0] = "No",
	},
	
	ClientTag = {
		["DSHR"] = "Diablo 1 Shareware",
		["DRTL"] = "Diablo 1 (Retail)",
		["SSHR"] = "Starcraft Shareware",
		["STAR"] = "Starcraft",
		["SEXP"] = "Starcraft: Broodwar",
		["JSTR"] = "Starcraft Japanese",
		["W2BN"] = "Warcraft II Battle.Net Edition",
		["D2DV"] = "Diablo 2",
		["D2XP"] = "Diablo 2: Lord Of Destruction",
		["WAR3"] = "Warcraft III (Reign Of Chaos)",
		["W3XP"] = "Warcraft III: The Frozen Throne",
	},
	
	PlatformID = {
		["IX86"] = "Windows (Intel x86)",
		["PMAC"] = "Macintosh",
		["XMAC"] = "Macintosh OS X",
	},

	GameStatus = {
		[0x00] = "OK",
		[0x01] = "Game doesn't exist",
		[0x02] = "Incorrect password",
		[0x03] = "Game full",
		[0x04] = "Game already started",
		[0x06] = "Too many server requests",
	},
	
	-- Locale ID (LCID)
	-- http://support.microsoft.com/kb/221435
	LocaleID = {
		[11276] = "French (Cameroon)",
		[1025] = "Arabic (Saudi Arabia)",
		[1026] = "Bulgarian",
		[1027] = "Catalan",
		[1028] = "Chinese (Taiwan)",
		[1029] = "Czech",
		[1030] = "Danish",
		[1031] = "German (Germany)",
		[1032] = "Greek",
		[1033] = "English (United States)",
		[1034] = "Spanish (Traditional Sort)",
		[1035] = "Finnish",
		[1036] = "French (France)",
		[1037] = "Hebrew",
		[1038] = "Hungarian",
		[1039] = "Icelandic",
		[1040] = "Italian (Italy)",
		[1041] = "Japanese",
		[1042] = "Korean",
		[1043] = "Dutch (Netherlands)",
		[1044] = "Norwegian (Bokmal)",
		[1045] = "Polish",
		[1046] = "Portuguese (Brazil)",
		[1047] = "Rhaeto-Romanic",
		[1048] = "Romanian",
		[1049] = "Russian",
		[1050] = "Croatian",
		[1051] = "Slovak",
		[1052] = "Albanian",
		[1053] = "Swedish",
		[1054] = "Thai",
		[1055] = "Turkish",
		[1056] = "Urdu",
		[1057] = "Indonesian",
		[1058] = "Ukrainian",
		[1059] = "Belarusian",
		[1060] = "Slovenian",
		[1061] = "Estonian",
		[1062] = "Latvian",
		[1063] = "Lithuanian",
		[1064] = "Tajik",
		[1065] = "Farsi",
		[1066] = "Vietnamese",
		[1070] = "Sorbian",
		[1067] = "Armenian",
		[1068] = "Azeri (Latin)",
		[1069] = "Basque",
		[1071] = "FYRO Macedonian",
		[1072] = "Sesotho",
		[1072] = "Sutu",
		[1073] = "Tsonga",
		[1074] = "Tswana",
		[1075] = "Venda",
		[1076] = "Xhosa",
		[1077] = "Zulu",
		[1078] = "Afrikaans",
		[1079] = "Georgian",
		[1080] = "Faroese",
		[1081] = "Hindi",
		[1082] = "Maltese",
		[1083] = "Sami Lappish",
		[1084] = "Gaelic Scotland",
		[1085] = "Yiddish",
		[1086] = "Malay (Malaysia)",
		[1087] = "Kazakh",
		[1088] = "Kyrgyz (Cyrillic)",
		[1089] = "Swahili",
		[1090] = "Turkmen",
		[1091] = "Uzbek (Latin)",
		[1092] = "Tatar",
		[1093] = "Bengali (India)",
		[1094] = "Punjabi",
		[1095] = "Gujarati",
		[1096] = "Oriya",
		[1097] = "Tamil",
		[1098] = "Telugu",
		[1099] = "Kannada",
		[1100] = "Malayalam",
		[1101] = "Assamese",
		[1102] = "Marathi",
		[1103] = "Sanskrit",
		[1104] = "Mongolian (Cyrillic)",
		[1105] = "Tibetan",
		[1106] = "Welsh",
		[1107] = "Khmer",
		[1108] = "Lao",
		[1109] = "Burmese",
		[1110] = "Galician",
		[1111] = "Konkani",
		[1112] = "Manipuri",
		[1113] = "Sindhi",
		[1114] = "Syriac",
		[1115] = "Sinhalese (Sri Lanka)",
		[1118] = "Amharic (Ethiopia)",
		[1120] = "Kashmiri",
		[1121] = "Nepali",
		[1122] = "Frisian (Netherlands)",
		[1124] = "Filipino",
		[1125] = "Divehi",
		[1126] = "Edo",
		[1136] = "Igbo (Nigeria)",
		[1140] = "Guarani (Paraguay)",
		[1142] = "Latin",
		[1143] = "Somali",
		[1153] = "Maori (New Zealand)",
		[1279] = "HID (Human Interface Device)",
		[2049] = "Arabic (Iraq)",
		[2052] = "Chinese (PRC)",
		[2055] = "German (Switzerland)",
		[2057] = "English (United Kingdom)",
		[2058] = "Spanish (Mexico)",
		[2060] = "French (Belgium)",
		[2064] = "Italian (Switzerland)",
		[2067] = "Dutch (Belgium)",
		[2068] = "Norwegian (Nynorsk)",
		[2070] = "Portuguese (Portugal)",
		[2072] = "Romanian (Moldova)",
		[2073] = "Russian (Moldova)",
		[2074] = "Serbian (Latin)",
		[2077] = "Swedish (Finland)",
		[2092] = "Azeri (Cyrillic)",
		[2108] = "Gaelic Ireland",
		[2110] = "Malay (Brunei Darussalam)",
		[2115] = "Uzbek (Cyrillic)",
		[2117] = "Bengali (Bangladesh)",
		[2128] = "Mongolian (Mongolia)",
		[3073] = "Arabic (Egypt)",
		[3076] = "Chinese (Hong Kong S.A.R.)",
		[3079] = "German (Austria)",
		[3081] = "English (Australia)",
		[3082] = "Spanish (International Sort)",
		[3084] = "French (Canada)",
		[3098] = "Serbian (Cyrillic)",
		[4097] = "Arabic (Libya)",
		[4100] = "Chinese (Singapore)",
		[4103] = "German (Luxembourg)",
		[4105] = "English (Canada)",
		[4106] = "Spanish (Guatemala)",
		[4108] = "French (Switzerland)",
		[4122] = "Croatian (Bosnia/Herzegovina)",
		[5121] = "Arabic (Algeria)",
		[5124] = "Chinese (Macau S.A.R.)",
		[5127] = "German (Liechtenstein)",
		[5129] = "English (New Zealand)",
		[5130] = "Spanish (Costa Rica)",
		[5132] = "French (Luxembourg)",
		[5146] = "Bosnian (Bosnia/Herzegovina)",
		[6145] = "Arabic (Morocco)",
		[6153] = "English (Ireland)",
		[6154] = "Spanish (Panama)",
		[6156] = "French (Monaco)",
		[7169] = "Arabic (Tunisia)",
		[7177] = "English (South Africa)",
		[7178] = "Spanish (Dominican Republic)",
		[7180] = "French (West Indies)",
		[8193] = "Arabic (Oman)",
		[8201] = "English (Jamaica)",
		[8202] = "Spanish (Venezuela)",
		[9217] = "Arabic (Yemen)",
		[9225] = "English (Caribbean)",
		[9226] = "Spanish (Colombia)",
		[9228] = "French (Congo, DRC)",
		[10241] = "Arabic (Syria)",
		[10249] = "English (Belize)",
		[10250] = "Spanish (Peru)",
		[10252] = "French (Senegal)",
		[11265] = "Arabic (Jordan)",
		[11273] = "English (Trinidad)",
		[11274] = "Spanish (Argentina)",
		[12289] = "Arabic (Lebanon)",
		[12297] = "English (Zimbabwe)",
		[12298] = "Spanish (Ecuador)",
		[12300] = "French (Cote d'Ivoire)",
		[13313] = "Arabic (Kuwait)",
		[13321] = "English (Philippines)",
		[13322] = "Spanish (Chile)",
		[13324] = "French (Mali)",
		[14337] = "Arabic (U.A.E.)",
		[14346] = "Spanish (Uruguay)",
		[14348] = "French (Morocco)",
		[15361] = "Arabic (Bahrain)",
		[15370] = "Spanish (Paraguay)",
		[16385] = "Arabic (Qatar)",
		[16393] = "English (India)",
		[16394] = "Spanish (Bolivia)",
		[17418] = "Spanish (El Salvador)",
		[18442] = "Spanish (Honduras)",
		[19466] = "Spanish (Nicaragua)",
		[20490] = "Spanish (Puerto Rico)",
	},
	
	ClanRank = {
		[0x00] = "Initiate that has been in the clan for less than one week (Peon)",
		[0x01] = "Initiate that has been in the clan for over one week (Peon)",
		[0x02] = "Member (Grunt)",
		[0x03] = "Officer (Shaman)",
		[0x04] = "Leader (Chieftain)",
	},
	
	WarcraftGeneralSubcommandId = {
		[0x01] = "",
		[0x02] = "Request ladder map listing",
		[0x03] = "Cancel ladder game search",
		[0x04] = "User stats request",
		[0x05] = "",
		[0x06] = "",
		[0x07] = "WID_TOURNAMENT",
		[0x08] = "Clan stats request",
		[0x09] = "Icon list request",
		[0x0A] = "Change icon",
	},
	
	WarcraftGeneralRequestType = {
		["URL"] = "URL",
		["MAP"] = "MAP",
		["TYPE"] = "TYPE",
		["DESC"] = "DESC",
		["LADR"] = "LADR",
	},
	
	W3Race = {
		[0x01] = "",
		[0x02] = "Request ladder map listing",
		[0x03] = "Cancel ladder game search",
		[0x04] = "User stats request",
		[0x05] = "",
		[0x06] = "",
		[0x07] = "WID_TOURNAMENT",
		[0x08] = "Clan stats request",
		[0x09] = "Icon list request",
		[0x0A] = "Change icon",
	},
	
	W3Icon = {
		[""] = "Default icon",
		["MAP"] = "MAP",
		["TYPE"] = "TYPE",
		["DESC"] = "DESC",
		["LADR"] = "LADR",
	},

	-- Friend online status
	OnlineStatus = {
		[0x00] = "Offline",
		[0x01] = "Not in chat",
		[0x02] = "In chat",
		[0x03] = "In a public game",
		[0x04] = "In a private game, and you are not that person's friend",
		[0x05] = "In a private game, and you are that person's friend",
	},
	
}

-- Common condition functions
local Cond
Cond = {
	assert_key = function (state, key)
		if state.packet[key] == nil then
			state:error("The key " .. key .. " is used before being defined.")
			return false
		end
		return true
	end,
	
	always = function() 
		return function() 
			return true 
		end 
	end,
	
	equals = function(key, value)
		return function(self, state)
			Cond.assert_key(state, key)
			return state.packet[key] == value
		end
	end,
	
	nequals = function(key, value)
		return function(self, state)
			Cond.assert_key(state, key)
			return state.packet[key] ~= value
		end
	end,
	
	neg = function(fun, ...)
		local func = fun
		if type(fun) == "string" then
			func = Cond[fun](unpack(arg))
		end
		return function(self, state)
			return not func(self, state)
		end
	end,
	
	inlist = function(key, arr)
		return function(self, state)
			Cond.assert_key(state, key)
			local val = state.packet[key]
			for i, v in ipairs(arr) do
				if v == val then
					return true
				end
			end
			return false
		end
	end,
}
-- End valuemaps.lua
