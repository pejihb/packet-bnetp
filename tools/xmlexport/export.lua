require "api.array"
require "api.bytes"
require "api.flags"
require "api.integer"
require "api.ipv4"
require "api.iterator"
require "api.sockaddr"
require "api.strdw"
require "api.stringz"
require "api.time"
require "api.version"
require "api.when"

require "doc"

require "wireshark.compat"

packet_names = {
[0xFF00] = "SID_NULL",
[0xFF02] = "SID_STOPADV",
[0xFF04] = "SID_SERVERLIST",
[0xFF05] = "SID_CLIENTID",
[0xFF06] = "SID_STARTVERSIONING",
[0xFF07] = "SID_REPORTVERSION",
[0xFF08] = "SID_STARTADVEX",
[0xFF09] = "SID_GETADVLISTEX",
[0xFF0A] = "SID_ENTERCHAT",
[0xFF0B] = "SID_GETCHANNELLIST",
[0xFF0C] = "SID_JOINCHANNEL",
[0xFF0E] = "SID_CHATCOMMAND",
[0xFF0F] = "SID_CHATEVENT",
[0xFF10] = "SID_LEAVECHAT",
[0xFF12] = "SID_LOCALEINFO",
[0xFF13] = "SID_FLOODDETECTED",
[0xFF14] = "SID_UDPPINGRESPONSE",
[0xFF15] = "SID_CHECKAD",
[0xFF16] = "SID_CLICKAD",
[0xFF17] = "SID_READMEMORY",
[0xFF18] = "SID_REGISTRY",
[0xFF19] = "SID_MESSAGEBOX",
[0xFF1A] = "SID_STARTADVEX2",
[0xFF1B] = "SID_GAMEDATAADDRESS",
[0xFF1C] = "SID_STARTADVEX3",
[0xFF1D] = "SID_LOGONCHALLENGEEX",
[0xFF1E] = "SID_CLIENTID2",
[0xFF1F] = "SID_LEAVEGAME",
[0xFF20] = "SID_ANNOUNCEMENT",
[0xFF21] = "SID_DISPLAYAD",
[0xFF22] = "SID_NOTIFYJOIN",
[0xFF23] = "SID_WRITECOOKIE",
[0xFF24] = "SID_READCOOKIE",
[0xFF25] = "SID_PING",
[0xFF26] = "SID_READUSERDATA",
[0xFF27] = "SID_WRITEUSERDATA",
[0xFF28] = "SID_LOGONCHALLENGE",
[0xFF29] = "SID_LOGONRESPONSE",
[0xFF2A] = "SID_CREATEACCOUNT",
[0xFF2B] = "SID_SYSTEMINFO",
[0xFF2C] = "SID_GAMERESULT",
[0xFF2D] = "SID_GETICONDATA",
[0xFF2E] = "SID_GETLADDERDATA",
[0xFF2F] = "SID_FINDLADDERUSER",
[0xFF30] = "SID_CDKEY",
[0xFF31] = "SID_CHANGEPASSWORD",
[0xFF32] = "SID_CHECKDATAFILE",
[0xFF33] = "SID_GETFILETIME",
[0xFF34] = "SID_QUERYREALMS",
[0xFF35] = "SID_PROFILE",
[0xFF36] = "SID_CDKEY2",
[0xFF3A] = "SID_LOGONRESPONSE2",
[0xFF3C] = "SID_CHECKDATAFILE2",
[0xFF3D] = "SID_CREATEACCOUNT2",
[0xFF3E] = "SID_LOGONREALMEX",
[0xFF3F] = "SID_STARTVERSIONING2",
[0xFF40] = "SID_QUERYREALMS2",
[0xFF41] = "SID_QUERYADURL",
[0xFF43] = "SID_WARCRAFTSOMETHING",
[0xFF44] = "SID_WARCRAFTGENERAL",
[0xFF45] = "SID_NETGAMEPORT",
[0xFF46] = "SID_NEWS_INFO",
[0xFF4A] = "SID_OPTIONALWORK",
[0xFF4B] = "SID_EXTRAWORK",
[0xFF4C] = "SID_REQUIREDWORK",
[0xFF4E] = "SID_TOURNAMENT",
[0xFF50] = "SID_AUTH_INFO",
[0xFF51] = "SID_AUTH_CHECK",
[0xFF52] = "SID_AUTH_ACCOUNTCREATE",
[0xFF53] = "SID_AUTH_ACCOUNTLOGON",
[0xFF54] = "SID_AUTH_ACCOUNTLOGONPROOF",
[0xFF55] = "SID_AUTH_ACCOUNTCHANGE",
[0xFF56] = "SID_AUTH_ACCOUNTCHANGEPROOF",
[0xFF57] = "SID_AUTH_ACCOUNTUPGRADE",
[0xFF58] = "SID_AUTH_ACCOUNTUPGRADEPROOF",
[0xFF59] = "SID_SETEMAIL",
[0xFF5A] = "SID_RESETPASSWORD",
[0xFF5B] = "SID_CHANGEEMAIL",
[0xFF5C] = "SID_SWITCHPRODUCT",
[0xFF5D] = "SID_REPORTCRASH",
[0xFF5E] = "SID_WARDEN",
[0xFF60] = "SID_GAMEPLAYERSEARCH",
[0xFF65] = "SID_FRIENDSLIST",
[0xFF66] = "SID_FRIENDSUPDATE",
[0xFF67] = "SID_FRIENDSADD",
[0xFF68] = "SID_FRIENDSREMOVE",
[0xFF69] = "SID_FRIENDSPOSITION",
[0xFF70] = "SID_CLANFINDCANDIDATES",
[0xFF71] = "SID_CLANINVITEMULTIPLE",
[0xFF72] = "SID_CLANCREATIONINVITATION",
[0xFF73] = "SID_CLANDISBAND",
[0xFF74] = "SID_CLANMAKECHIEFTAIN",
[0xFF75] = "SID_CLANINFO",
[0xFF76] = "SID_CLANQUITNOTIFY",
[0xFF77] = "SID_CLANINVITATION",
[0xFF78] = "SID_CLANREMOVEMEMBER",
[0xFF79] = "SID_CLANINVITATIONRESPONSE",
[0xFF7A] = "SID_CLANRANKCHANGE",
[0xFF7B] = "SID_CLANSETMOTD",
[0xFF7C] = "SID_CLANMOTD",
[0xFF7D] = "SID_CLANMEMBERLIST",
[0xFF7E] = "SID_CLANMEMBERREMOVED",
[0xFF7F] = "SID_CLANMEMBERSTATUSCHANGE",
[0xFF81] = "SID_CLANMEMBERRANKCHANGE",
[0xFF82] = "SID_CLANMEMBERINFORMATION",
}
-- TODO: reference valuemaps and conditions by name
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
	
	-- International Locale ID (LCID)
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
	
	-- TODO: what's the name of these codes?
	LangId = {
		['enUS'] = 'English (US)',
		['enGB'] = 'English (UK)',
		['frFR'] = 'French',
		['deDE'] = 'German',
		['esES'] = 'Spanish',
		['itIT'] = 'Italian',
		['csCZ'] = 'Czech',
		['ruRU'] = 'Russian',
		['plPL'] = 'Polish',
		['ptBR'] = 'Portuguese (Brazilian)',
		['ptPT'] = 'Portuguese (Portugal)',
		['tkTK'] = 'Turkish',
		['jaJA'] = 'Japanese',
		['koKR'] = 'Korean',
		['zhTW'] = 'Chinese (Traditional)',
		['zhCN'] = 'Chinese (Simplified)',
		['thTH'] = 'Thai',
	},
	
	TimeZoneBias = {
		[-720] = "UTC +12",
		[-690] = "UTC +11.5",
		[-660] = "UTC +11",
		[-630] = "UTC +10.5",
		[-600] = "UTC +10",
		[-570] = "UTC +9.5",
		[-540] = "UTC +9",
		[-510] = "UTC +8.5",
		[-480] = "UTC +8",
		[-450] = "UTC +7.5",
		[-420] = "UTC +7",
		[-390] = "UTC +6.5",
		[-360] = "UTC +6",
		[-330] = "UTC +5.5",
		[-300] = "UTC +5",
		[-270] = "UTC +4.5",
		[-240] = "UTC +4",
		[-210] = "UTC +3.5",
		[-180] = "UTC +3",
		[-150] = "UTC +2.5",
		[-120] = "UTC +2",
		[-90]  = "UTC +1.5",
		[-60]  = "UTC +1",
		[-30]  = "UTC +0.5",
		[0]    = "UTC +0",
		[30]   = "UTC -0.5",
		[60]   = "UTC -1",
		[90]   = "UTC -1.5",
		[120]  = "UTC -2",
		[150]  = "UTC -2.5",
		[180]  = "UTC -3",
		[210]  = "UTC -3.5",
		[240]  = "UTC -4",
		[270]  = "UTC -4.5",
		[300]  = "UTC -5",
		[330]  = "UTC -5.5",
		[360]  = "UTC -6",
		[390]  = "UTC -6.5",
		[420]  = "UTC -7",
		[450]  = "UTC -7.5",
		[480]  = "UTC -8",
		[510]  = "UTC -8.5",
		[540]  = "UTC -9",
		[570]  = "UTC -9.5",
		[600]  = "UTC -10",
		[630]  = "UTC -10.5",
		[660]  = "UTC -11",
		[690]  = "UTC -11.5",
		[720]  = "UTC -12",
	},

	ClanRank = {
		[0x00] = "Initiate that has been in the clan for less than one week (Peon)",
		[0x01] = "Initiate that has been in the clan for over one week (Peon)",
		[0x02] = "Member (Grunt)",
		[0x03] = "Officer (Shaman)",
		[0x04] = "Leader (Chieftain)",
	},
	
	WarcraftGeneralSubcommandId = {
		[0x00] = "WID_GAMESEARCH",
		[0x01] = "",
		[0x02] = "WID_MAPLIST: Request ladder map listing",
		[0x03] = "WID_CANCELSEARCH: Cancel ladder game search",
		[0x04] = "WID_USERRECORD: User stats request",
		[0x05] = "",
		[0x06] = "",
		[0x07] = "WID_TOURNAMENT",
		[0x08] = "WID_CLANRECORD: Clan stats request",
		[0x09] = "WID_ICONLIST: Icon list request",
		[0x0A] = "WID_SETICON: Change icon",
	},
	
	WarcraftGeneralRequestType = {
		["URL"] = "URL",
		["MAP"] = "MAP",
		["TYPE"] = "TYPE",
		["DESC"] = "DESC",
		["LADR"] = "LADR",
	},
	

	W3IconNames = {
		-- Random
		--NULL
		["ngrd"] = "Green Dragon Whelp",
		["nadr"] = "Azure Dragon (Blue Dragon)",
		["nrdr"] = "Red Dragon",
		["nbwm"] = "Deathwing",
		--NULL

		-- Humans
		["hpea"] = "Peasant",
		["hfoo"] = "Footman",
		["hkni"] = "Knight",
		["Hamg"] = "Archmage",
		["nmed"] = "Medivh",
		--NULL

		-- Orcs
		["opeo"] = "Peon",
		["ogru"] = "Grunt",
		["otau"] = "Tauren",
		["Ofar"] = "Far Seer",
		["Othr"] = "Thrall",
		--NULL

		-- Undead
		["uaco"] = "Acolyle",
		["ugho"] = "Ghoul",
		["uabo"] = "Abomination",
		["Ulic"] = "Lich",
		["Utic"] = "Tichondrius",
		--NULL

		-- Night Elves
		["ewsp"] = "Wisp",
		["earc"] = "Archer",
		["edoc"] = "Druid of the Claw",
		["Emoo"] = "Priestess of the Moon",
		["Efur"] = "Furion Stormrage",
		--NULL

		-- Demons
		--NULL
		["nfng"] = "dunno",
		["ninf"] = "Infernal",
		["nbal"] = "Doom Guard",
		["Nplh"] = "Pit Lord/Manaroth",
		["Uwar"] = "Archimonde",
		--/* not used by RoC */

		-- Random
		--NULL
		["nmyr"] = "Naga Myrmidon",
		["nnsw"] = "Naga Siren",
		["nhyc"] = "Dragon Turtle",
		["Hvsh"] = "Lady Vashj",
		["Eevm"] = "Illidan (Morphed 2)",
		
		-- Humans
		["hpea"] = "Peasant",
		["hrif"] = "Rifleman",
		["hsor"] = "Sorceress",
		["hspt"] = "Spellbreaker",
		["Hblm"] = "Blood Mage",
		["Hjai"] = "Jaina",

		-- Orcs
		["opeo"] = "Peon",
		["ohun"] = "Troll Headhunter",
		["oshm"] = "Shaman",
		["ospw"] = "Spirit Walker",
		["Oshd"] = "Shadow Hunter",
		["Orex"] = "Rexxar",

		-- Undead
		["uaco"] = "Acolyle",
		["ucry"] = "Crypt Fiend",
		["uban"] = "Banshee",
		["uobs"] = "Destroyer",
		["Ucrl"] = "Crypt Lord",
		["Usyl"] = "Sylvanas",

		-- Night Elves
		["ewsp"] = "Wisp",
		["esen"] = "Huntress",
		["edot"] = "Druid of the Talon",
		["edry"] = "Dryad",
		["Ekee"] = "Keeper of the Grove",
		["Ewrd"] = "Maiev",

		-- Tournament
		--NULL
		["nfgu"] = "Felguard",
		["ninf"] = "Infernal",
		["nbal"] = "Doomguard",
		["Nplh"] = "Pit Lord",
		["Uwar"] = "Archimonde",
	},
	
	W3Icon = {
		[""] = "Default icon",
		["W3H1"] = "",
		
		["W3O1"] = "",
		
		["W3N1"] = "",
		
		["W3U1"] = "",
		
		["W3R1"] = "",
		
		["W3D1"] = "",
		
	},

	W3Races = {
		[0x00] = "Random",
		[0x01] = "Humans",
		[0x02] = "Orcs",
		[0x03] = "Undead",
		[0x04] = "Night Elves",
		[0x05] = "Tournament",
	},
	
	W3LadderType = {
		['SOLO'] = 'SOLO', 
		['TEAM'] = 'TEAM',
		['FFA '] = 'FFA',
	},
	
	W3TeamType = {
		['2VS2'] = '2VS2',
		['3VS3'] = '3VS3',
		['4VS4'] = '4VS4',
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

-- Flag fields
local Fields = {
	-- S> 0xff 0xFF0F
	UserFlags = {
		{sname="Blizzard Representative",     mask=0x00000001, desc=Descs.YesNo},
		{sname="Channel Operator",            mask=0x00000002, desc=Descs.YesNo},
		{sname="Speaker",                     mask=0x00000004, desc=Descs.YesNo},
		{sname="Battle.net Administrator",    mask=0x00000008, desc=Descs.YesNo},
		{sname="No UDP Support",              mask=0x00000010, desc=Descs.YesNo},
		{sname="Squelched",                   mask=0x00000020, desc=Descs.YesNo},
		{sname="Special Guest",               mask=0x00000040, desc=Descs.YesNo},
		{sname="Unknown",                     mask=0x00000080, desc=Descs.YesNo},
		{sname="Beep Enabled (Defunct)",      mask=0x00000100, desc=Descs.YesNo},
		{sname="PGL Player (Defunct)",        mask=0x00000200, desc=Descs.YesNo},
		{sname="PGL Official (Defunct)",      mask=0x00000400, desc=Descs.YesNo},
		{sname="KBK Player (Defunct)",        mask=0x00000800, desc=Descs.YesNo},
		{sname="WCG Official",                mask=0x00001000, desc=Descs.YesNo},
		{sname="KBK Singles (Defunct)",       mask=0x00002000, desc=Descs.YesNo},
		{sname="KBK Player (Defunct)",        mask=0x00002000, desc=Descs.YesNo},
		{sname="KBK Beginner (Defunct)",      mask=0x00010000, desc=Descs.YesNo},
		{sname="White KBK (1 bar) (Defunct)", mask=0x00020000, desc=Descs.YesNo},
		{sname="GF Official",                 mask=0x00100000, desc=Descs.YesNo},
		{sname="GF Player",                   mask=0x00200000, desc=Descs.YesNo},
		{sname="PGL Player",                  mask=0x02000000, desc=Descs.YesNo},
	},
	
	-- S> 0xff 0xFF0F
	ChannelFlags = {
		{sname="Public Channel",              mask=0x00001, desc=Descs.YesNo},
		{sname="Moderated",                   mask=0x00002, desc=Descs.YesNo},
		{sname="Restricted",                  mask=0x00004, desc=Descs.YesNo},
		{sname="Silent",                      mask=0x00008, desc=Descs.YesNo},
		{sname="System",                      mask=0x00010, desc=Descs.YesNo},
		{sname="Product-Specific",            mask=0x00020, desc=Descs.YesNo},
		{sname="Globally Accessible",         mask=0x01000, desc=Descs.YesNo},
		{sname="Redirected",                  mask=0x04000, desc=Descs.YesNo},
		{sname="Chat",                        mask=0x08000, desc=Descs.YesNo},
		{sname="Tech Support",                mask=0x10000, desc=Descs.YesNo},	
	},                               

	-- Place iCCup / etc flags here if you want
	--IccupUserFlags = {
	
	--},
	--UserFlags = IccupUserFlags,
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
do
	--
	-- CheckedTable
	--
	-- Metatable that implements the metamethods required for verifying
	-- that a field is defined before it may be succesfully read.
	--
	-- ChackedTable may be used as the metatable of any amount of tables
	-- at a time.
	--
	local CheckedTable = {
		--
		-- Maps a table for which CheckedTable is it's metatable to a string
		-- that is used to refer to the table when reporting error.
		--
		-- The default value is 'thing'.
		--
		tableType = setmetatable({}, {
			__mode = "k",
			__index = function () return "'thing'" end }),
		--
		-- Maps a table for which CheckedTable is it's metatable to the set
		-- of fields that are declared.
		--
		declaredNames = setmetatable({}, {
			__mode = "k",
			__index = function () return {} end } ), 
	}

	--
	-- A table will be read only while it's guarded by CheckedTable.
	-- No new field may be created.
	--
	function CheckedTable.__newindex (t, n, v)
		error("attempt to write to a new field '"..n.."' in a read only table.", 2)
	end

	--
	-- A table will not allow reading from non existant fields while it's
	-- guarded by CheckedTable.
	--
	function CheckedTable.__index (t, n)
		error("attempt to read undeclared "
			.. CheckedTable.tableType[t]
			.. ": " .. n, 2)
	end

	--
	-- Make CheckedTable guard table @t.
	--
	function CheckedTable.guard (self, t, description)
		for k, _ in pairs(t) do
			self.declaredNames[t][k] = true
		end

		if description then
			self.tableType[t] = description
		end

		setmetatable(t, self)
	end

	--
	-- Protect valuemaps.lua tables.
	--
	CheckedTable:guard(Descs, "value description")
	CheckedTable:guard(Cond, "condition function")
end


-- Packets from server to client
SPacketDescription = {
-- Begin spackets_sid.lua
-- Battle.net Messages
[0xFF00] = { -- 0x00
},
[0xFF04] = { -- 0x04
	uint32("Server version"),
	iterator{
		label="Server list",
 		alias="bytes",
 		condition = function(self, state) return state.packet.srvr ~="" end,
 		repeated = {
 			stringz{"Server", key="srvr"},
 		},
 	}
},
[0xFF05] = { -- 0x05
	uint32("Registration Version", base.HEX),
	uint32("Registration Authority", base.HEX),
	uint32("Account Number", base.HEX),
	uint32("Registration Token", base.HEX),
},
[0xFF06] = { -- 0x06
	wintime("MPQ Filetime"),
	stringz("MPQ Filename"),
	stringz("ValueString"),
},
[0xFF07] = { -- 0x07
	uint32("Result", nil, {
		[0x00] = "Failed version check",
		[0x01] = "Old game version",
		[0x02] = "Success",
		[0x03] = "Reinstall required",
	}),
	stringz("Patch path"),
},
[0xFF08] = { -- 0x08
	uint32("Status", nil, {
		[0x00] = "Failed",
		[0x01] = "Success",
	}),
},


[0xFF09] = { -- 0x09
	uint32{"Number of games", key="games"},
	when{Cond.equals("games", 0),
		block = {
			uint32("Status", nil, Descs.GameStatus)
		},
		otherwise = {
			-- error in description?
			-- pvpgn sux? but how starcraft handles both formats?
			iterator{label="Game Information", refkey="games", repeated={
				-- XXX: dirty PvPGN hack
				-- for pvpgn, must be 0 or 1
				-- for battle.net, must be >= 2
				uint16{key="key", getvalueonly=true},
				when{Cond.inlist("key", {0,1}), {
					uint32("Unknown (PvPGN)"), -- seems to be bool32 - only on pvpgn
				}},
				uint16{"Game Type", nil, {
					[0x02] = "Melee",
					[0x03] = "Free for all",
					[0x04] = "one vs one",
					[0x05] = "CTF",
					[0x06] = "Greed",
					[0x07] = "Slaughter",
					[0x08] = "Sudden Death",
					[0x09] = "Ladder",
					[0x0A] = "Use Map Settings",
					[0x0B] = "Team Melee",
					[0x0C] = "Team FFA",
					[0x0D] = "Team CTF",
					[0x0F] = "Top vs Bottom",
					[0x10] = "Iron man ladder",
				}, key = "gametype"},
				-- source:unverified
				casewhen{ 
				{Cond.inlist("gametype", {2, 3, 4, 5, 8}), { -- melee / ffa / 1 on 1 / CTF / suddenDeath
					uint16("Penalty", nil, {
						[1] = "Melee Disc",
						[2] = "Loss",
					})
				}},
				{Cond.equals("gametype", 6), { -- Greed
					uint16("Resources", nil, {
						[1] = 2500,
						[2] = 5000,
						[3] = 7500,
						[4] = 10000,
					})
				}},
				{Cond.equals("gametype", 7), { -- Slaughter
					uint16("Minutes", nil, {
						[1] = 15,
						[2] = 30,
						[3] = 45,
						[4] = 60,
						-- ["default"] = "Unlimited",
					})
				}},
				{Cond.equals("gametype", 9), { -- Ladder
					uint16("Penalty", nil, {
						[1] = "Ladder Disc",
						[2] = "Ladder Loss + Disc",
					})
				}},
				{Cond.equals("gametype", 0xA), { -- UMS
					uint16("Penalty", nil, {
						[1] = "Draw",
						[2] = "Draw",
					})
				}},
				{Cond.inlist("gametype", {0xB,0xC,0xD}), { -- Team melee / team FFA / team CTF
					uint16("Teams", nil, {
						[1] = 2,
						[2] = 3,
						[3] = 4,
					})
				}},
				{Cond.equals("gametype", 0xF), { -- Top vs Bottom
					uint16("Teams", nil, { -- TODO: x vs the rest?
						[1] = "1 vs all",
						[2] = "2 vs all",
						[3] = "3 vs all",
						[4] = "4 vs all",
						[5] = "5 vs all",
						[6] = "6 vs all",
						[7] = "7 vs all",
					})
				}},
				-- default block
				{Cond.always(), { 
					uint16("Parameter", base.HEX) 
				}}
				},
				when{Cond.neg(Cond.inlist("key", {0,1}) ), {
					uint32("Language ID", nil, Descs.LocaleID), -- only on bnet - comment out for pvpgn
				}},
				--sockaddr("Game Host"),
				sockaddr(),
				uint32("Status", nil, Descs.GameStatus),
				uint32("Elapsed time (sec)"),
				stringz("Game name"),
				stringz("Game password"),
				stringz("Game statstring"),
			}},
		}
	},
},
[0xFF0A] = { -- 0x0A
	stringz("Unique name"),
	stringz("Statstring"),
	stringz("Account name"),
},
[0xFF0B] = { -- 0x0B
	iterator{
		alias="none",
		--condition = function(self, state) return state.packet.chan ~="" end,
		condition = Cond.nequals("chan", ""),
		repeated = {
			stringz{"Channel name", key="chan"},
		}
	}
},
[0xFF0F] = { -- 0x0F
	uint32{"Event ID", key="eid", filter="eid", nil, {
		[0x01] = "EID_SHOWUSER: User in channel",
		[0x02] = "EID_JOIN: User joined channel",
		[0x03] = "EID_LEAVE: User left channel",
		[0x04] = "EID_WHISPER: Recieved whisper",
		[0x05] = "EID_TALK: Chat text",
		[0x06] = "EID_BROADCAST: Server broadcast",
		[0x07] = "EID_CHANNEL: Channel information",
		[0x09] = "EID_USERFLAGS: Flags update",
		[0x0A] = "EID_WHISPERSENT: Sent whisper",
		[0x0D] = "EID_CHANNELFULL: Channel full",
		[0x0E] = "EID_CHANNELDOESNOTEXIST: Channel doesn't exist",
		[0x0F] = "EID_CHANNELRESTRICTED: Channel is restricted",
		[0x12] = "EID_INFO: Information",
		[0x13] = "EID_ERROR: Error message",
		[0x17] = "EID_EMOTE: Emote",
	}},
	casewhen{
		{Cond.equals("eid", 7), { -- Channel information
			flags{of=uint32, label="Channel Flags", fields=Fields.ChannelFlags},
		}},
		{Cond.always(), { 		-- Otherwise
			flags{of=uint32, label="User's Flags", fields=Fields.UserFlags},
		}},
	},
	uint32("Ping"),
	ipv4("IP Address (Defunct)"),
	uint32("Account number (Defunct)", base.HEX),
	uint32("Registration Authority (Defunct)", base.HEX),
	stringz("Username"),
	-- statstring: 1,2,9,
	-- empty: 3,
	-- text: 5,18
	-- channel name: 7
	casewhen{ 
		{Cond.inlist("eid", {1,2,9}), {
			stringz("Statstring"),
		}},
		{Cond.equals("eid", 7), {
			stringz("Channel name"),
		}},
		{Cond.always(), {
			stringz("Text"),
		}},
	},
},
[0xFF13] = { -- 0x13
},
[0xFF15] = { -- 0x15
	uint32("Ad ID", base.HEX),
	stringz{"File extension", length=4},
	wintime("Local file time"),
	stringz("Filename"),
	stringz("Link URL"),
},


[0xFF17] = { -- 0x17
	uint32("Request ID"),
	uint32("Address", base.HEX),
	uint32("Length"),
},

[0xFF18] = { -- 0x18
	uint32("Cookie"),
	uint32("HKEY", base.HEX, {
		[0x80000000] = "HKEY_CLASSES_ROOT",
		[0x80000001] = "HKEY_CURRENT_USER",
		[0x80000002] = "HKEY_LOCAL_MACHINE",
		[0x80000003] = "HKEY_USERS",
		[0x80000004] = "HKEY_PERFORMANCE_DATA",
		[0x80000005] = "HKEY_CURRENT_CONFIG",
		[0x80000006] = "HKEY_DYN_DATA",
	}),
	stringz("Registry path"),
	stringz("Registry key"),
},
[0xFF19] = { -- 0x19
	uint32("Style"),
	stringz("Text"),
	stringz("Caption"),
},
[0xFF1C] = { -- 0x1C
	uint32("Status", nil, {
		[0x00] ="Ok", 
		[0x01] = "Failed",
	}),
},
[0xFF1D] = { -- 0x1D
	uint32("UDP Token", base.HEX),
	uint32("Server Token", base.HEX),
},

[0xFF20] = { -- 0x20
	stringz("Text"),
},

[0xFF23] = { -- 0x23
	uint32("Flags, Request ID?"),
	uint32("Timestamp?"),
	stringz("Registry key name"),
	stringz("Registry key value"),
},

[0xFF24] = { -- 0x24
	uint32("Request ID?"),
	uint32("Timestamp?"),
	stringz("Registry key name"),
},

[0xFF25] = { -- 0x25
	uint32("Ping Value", base.HEX),
},
[0xFF26] = { -- 0x26
	uint32{"Number of accounts", key="numaccts"},
	uint32{"Number of keys", key="numkeys"},
	uint32("Request ID"),
	iterator{label="Requested Account", refkey="numaccts", repeated={
		iterator{alias="none", label="Key Values", refkey="numkeys", repeated={
			stringz("Requested Key Value"),
		}},
	}},
},
[0xFF28] = { -- 0x28
	uint32("Server Token", base.HEX),
},
[0xFF29] = { -- 0x29
	uint32("Result", nil, {
		[0x00] = "Invalid password",
		[0x01] = "Success",
	}),
},
[0xFF2A] = { -- 0x2A
	uint32("Result", nil, {
		[0x00] = "Failed",
		[0x01] = "Success",
	}),
},
[0xFF2D] = { -- 0x2D
	wintime("Filetime"),
	stringz("Filename"),
},
[0xFF2E] = { -- 0x2E
	uint32("Ladder type", base.HEX),
	uint32("League", base.HEX),
	uint32("Sort method", nil, {
		[0x00] = "Highest rating",
		[0x01] = "Fastest climbers",
		[0x02] = "Most wins on record",
		[0x03] = "Most games played",
	}),
	uint32("Starting rank", base.HEX),
	uint32{"Number of ranks listed", key="ranks"},
	iterator{label="Rank", refkey="ranks", repeated={
		uint32("Wins"),
		uint32("Losses"),
		uint32("Disconnects"),
		uint32("Rating"),
		uint32("Rank"),
		uint32("Official wins"),
		uint32("Official losses"),
		uint32("Official disconnects"),
		uint32("Official rating"),
		uint32("Unknown", base.HEX),
		uint32("Official rank"),
		uint32("Unknown", base.HEX),
		uint32("Unknown", base.HEX),
		uint32("Highest rating"),
		uint32("Unknown", base.HEX),
		uint32("Season"),
		wintime("Last game time"),
		wintime("Official last game time"),
		stringz("Name"),
	}},
},
[0xFF2F] = { -- 0x2F
	uint32("Rank. Zero-based. 0xFFFFFFFF == Not ranked"),
},
[0xFF30] = { -- 0x30
	uint32("Result", nil, {
		[0x01] = "Ok",
		[0x02] = "Invalid key",
		[0x03] = "Bad product",
		[0x04] = "Banned",
		[0x05] = "In use",
	}),
	stringz("Key owner"),
},
[0xFF31] = { -- 0x31
	uint32("Password change succeeded", nil, Descs.YesNo),
},
[0xFF32] = { -- 0x32
	uint32("Status", nil, {
		[0x00] = "Rejected",
		[0x01] = "Approved",
		[0x02] = "Ladder approved",
	}),
},
[0xFF33] = { -- 0x33
	uint32("Request ID"),
	uint32("Unknown"),
	wintime("Last update time"),
	stringz("Filename"),
},
[0xFF34] = { -- 0x34
	uint32("Unknown", base.HEX),
	uint32{"Count", key="realms"},
	iterator{label="Realm", refkey="realms", repeated={
		uint32("Unknown", base.HEX),
		stringz("Realm title"),
		stringz("Realm description"),
	}},
},
[0xFF35] = { -- 0x35
	uint32("Cookie"),
	uint8{"Success", nil, Descs.YesNo, key="status"},
	when{Cond.equals("status", 0), {
		stringz("Profile\\Description value"),
		stringz("Profile\\Location value"),
		strdw("Clan Tag"),
	}},
},
[0xFF36] = { -- 0x36
	uint32("Result", nil, {
		[0x01] = "Ok",
		[0x02] = "Invalid key",
		[0x03] = "Bad product",
		[0x04] = "Banned",
		[0x05] = "In use",
	}),
	stringz("Key owner"),
},
[0xFF3A] = { -- 0x3A
	uint32{"Result", nil, {
		[0x00] = "Success",
		[0x01] = "Account Does Not Exist",
		[0x02] = "Invalid Password",
		[0x06] = "Account Closed",
	}, key="res"},
	when{Cond.equals("res", 6), {
		stringz("Reason"),
	}},
},
[0xFF3C] = { -- 0x3C
	uint32("Result", nil, {
		[0x00] = "Not approved",
		[0x01] = "Blizzard approved",
		[0x02] = "Approved for ladder",
	}),
},
[0xFF3D] = { -- 0x3D
	uint32("Status", nil, {
		[0x00] = "Account created",
		[0x02] = "Name contained invalid characters",
		[0x03] = "Name contained a banned word",
		[0x04] = "Account already exists",
		[0x06] = "Name did not contain enough alphanumeric characters",
	}),
	-- stringz("Account name suggestion"),
},
[0xFF3E] = { -- 0x3E
	uint32("MCP Cookie"),
	uint32{"MCP Status", key="status"},
	when{Cond.equals("status", 0), {
		array("MCP Chunk 1", uint32, 2),
		ipv4("IP"),
		uint16{"Port", big_endian=true},
		array("Padding", uint8, 2),
		array("MCP Chunk 2", uint32, 12),
		stringz("Battle.net unique name"),
	}},
},
[0xFF3F] = { -- 0x3F
	wintime("MPQ Filetime"),
	stringz("MPQ Filename"),
	stringz("ValueString"),
},
[0xFF40] = { -- 0x40
	uint32("Unknown", base.HEX),
	uint32{"Count", key="realms"},
	iterator{label="Realm", refkey="realms", repeated={
		uint32("Unknown", base.HEX),
		stringz("Realm title"),
		stringz("Realm description"),
	}},
},
[0xFF41] = { -- 0x41
	uint32("Ad ID"),
	stringz("Ad URL"),
},
[0xFF44] = { -- 0x44
	uint8{"Subcommand ID", key="subcommand", filter="wid", nil, Descs.WarcraftGeneralSubcommandId},
	-- Subcommand ID 0: Game search?
	when{Cond.equals("subcommand", 0), {
		uint32("Cookie"),
		uint8("Status", nil, {
			[0x00] = "Search Started",
			[0x04] = "Banned CD Key",
		}),
	}},
	
	-- Subcommand ID 2: Request ladder map listing
	when{Cond.equals("subcommand", 2), {
		uint32("Cookie"),
		uint8("Responses"),
		strdw("ID", Descs.WarcraftGeneralRequestType),
		uint32("Checksum", base.HEX),
		uint16("Decompressed Len"),
		uint16("Compressed Len"),
		-- TODO: length as refkey
		-- array("Compressed Data", uint8,
		uint8("Remaining Packets"),
	}},
	
	-- Subcommand ID 4: User stats request
	when{Cond.equals("subcommand", 4), {
		uint32("Cookie"),
		strdw("Icon ID", Descs.W3IconNames),
		uint8{"Number of ladder records", key="ladders"},
		iterator{label="Ladder Record", refkey="ladders", repeated={
			strdw("Ladder type", Descs.W3LadderType),
			uint16("Number of wins"),
			uint16("Number of losses"),
			uint8("Level"),
			uint8("Hours until XP decay"),
			uint16("Experience"),
			uint32("Rank"),
		}},
		uint8{"Number of race records", key="races"},
		iterator{label="Race Record", refkey="races", repeated={
			uint16("Wins"),
			uint16("Losses"),
		}},
		uint8{"Number of team records", key="teams"},
		iterator{label="Team Record", refkey="teams", repeated={
			strdw("Type of team", Descs.W3TeamType),
			uint16("Number of wins"),
			uint16("Number of losses"),
			uint8("Level"),
			uint8("Hours until XP decay"),
			uint16("Experience"),
			uint32("Rank"),
			wintime("Time of last game played"),
			uint8{"Number of partners", key="partners"},
			iterator{label="Partners", refkey="partners", repeated={
				stringz("Names of partners"),
			}},
		}},
	}},
	
	-- Subcommand ID 7: WID_TOURNAMENT
	when{Cond.equals("subcommand", 7), {
		uint32("Cookie"),
		uint8("Status", nil, {
			[0x00] = "No Tournament",
			[0x01] = "Starting Soon",
			[0x02] = "Ending Soon",
			[0x03] = "Started",
			[0x04] = "Last Call",
		}),
		wintime("Time of Status"),
		uint16("Unknown"),
		uint16("Unknown"),
		uint8("Wins"),
		uint8("Losses"),
		uint8("Draws"),
		uint8("Unknown"),
		uint8("Unknown"),
		uint8("Unknown"),
		uint8("Unknown"),
	}},
	
	-- Subcommand ID 8: Clan stats request
	when{Cond.equals("subcommand", 8), {
		uint32("Cookie"),
		uint8{"Number of ladder records", key="ladders"},
		iterator{label="Ladder Record", refkey="ladders", repeated={
			strdw("Ladder type", Descs.W3LadderType),
			uint16("Number of wins"),
			uint16("Number of losses"),
			uint8("Level"),
			uint8("Hours until XP decay"),
			uint16("Experience"),
			uint32("Rank"),
		}},
		uint8{"Number of race records", key="races"},
		iterator{label="Race Record", refkey="races", repeated={
			uint16("Wins"),
			uint16("Losses"),
		}},
	}},
	
	-- Subcommand ID 9: Icon list request
	when{Cond.equals("subcommand", 9), {
		uint32("Cookie"),
		uint32("Unknown", base.HEX),
		uint8("Tiers"),
		uint8{"Number of Icons", key="icons"},
		iterator{label="Icon", refkey="icons", repeated={
			strdw("Icon", Descs.W3Icon),
			strdw("Name", Descs.W3IconNames),
			uint8("Race", nil, Descs.W3Races),
			uint16("Wins required"),
			uint8("Unknown", base.HEX),
		}},
	}},
},

[ 0xFF43] = { -- 0x43
	uint32("Unknown (0)"),
},

[0xFF46] = { -- 0x46
	uint8{"Number of entries", key="news" },
	posixtime("Last logon timestamp"),
	posixtime("Oldest news timestamp"),
	posixtime("Newest news timestamp"),
	iterator{label="News", refkey="news", repeated={
		posixtime{"Timestamp", key="stamp"},
		when{Cond.equals("stamp", 0),
			block = { stringz("MOTD") },
			otherwise = {stringz("News")},
		},},
	},
},
[0xFF4A] = { -- 0x4A
	stringz("MPQ Filename"),
},
[0xFF4C] = { -- 0x4C
	stringz("ExtraWork MPQ FileName"),
},
[0xFF4E] = { -- 0x4E
	uint8("Unknown", base.HEX),
	uint8("Unknown, maybe number of non-null strings sent?", base.HEX),
	stringz("Description"),
	stringz("Unknown"),
	stringz("Website"),
	uint32("Unknown", base.HEX),
	stringz("Name"),
	stringz("Unknown"),
	stringz("Unknown"),
	stringz("Unknown"),
	array("Unknown", uint32, 5),
},
[0xFF50] = { -- 0x50
	uint32{"Logon Type", key="logontype", nil, {
		[0x00] = "Broken SHA-1 (STAR/SEXP/D2DV/D2XP)",
		[0x01] = "NLS Version 1",
		[0x02] = "NLS Version 2 (WAR3/W3XP)",
	}},
	uint32("Server Token", base.HEX),
	uint32("UDPValue", base.HEX),
	wintime("MPQ filetime"),
	stringz("IX86ver filename"),
	stringz("ValueString"),
	when{Cond.equals("logontype", 2), {
		 array("Server signature", uint8, 128),
	}},
},
[0xFF51] = { -- 0xff51
	uint32{"Result", key="res", base.HEX, {
		[0x000] = "Passed challenge",
		[0x100] = "Old game version",
		[0x101] = "Invalid version",
		[0x102] = "Game version must be downgraded",
		-- ?? [0x0NN] = "(where NN is the version code supplied in SID_AUTH_INFO):
		-- Invalid version code (note that 0x100 is not set in this case)",
		[0x200] = "Invalid CD key",
		[0x201] = "CD key in use",
		[0x202] = "Banned key",
		[0x203] = "Wrong product",
		-- The last 4 codes also apply to the second CDKey, as indicated by a
		-- bitwise combination with 0x010.
		[0x210] = "Invalid second CD key",
		[0x211] = "Second CD key in use",
		[0x212] = "Banned second key",
		[0x213] = "Wrong product for second CD key",
	}},
	
	casewhen{ 
		{Cond.inlist("res", {0x100, 0x102}), {
			stringz("MPQ Filename"),
		}},
		{Cond.inlist("res", {0x201, 0x211}), {
			stringz("Username"),
		}},
		{Cond.always(), {
			stringz("Additional Information"),
		}},
	},
},
[0xFF52] = { -- 0x52
	uint32("Status", nil, {
		[0x00] = "Successfully created account name",
		[0x04] = "Name already exists",
		[0x07] = "Name is too short/blank",
		[0x08] = "Name contains an illegal character",
		[0x09] = "Name contains an illegal word",
		[0x0a] = "Name contains too few alphanumeric characters",
		[0x0b] = "Name contains adjacent punctuation characters",
		[0x0c] = "Name contains too many punctuation characters",
	}),
},
[0xFF53] = { -- 0x53
	uint32("Status", nil, {
		[0x00] = "Logon accepted, requires proof",
		[0x01] = "Account doesn't exist",
		[0x05] = "Account requires upgrade",
	}),
	array("Salt", uint8, 32),
	array("Server Key", uint8, 32),
},
[0xFF54] = { -- 0x54
	uint32{"Status", key="status", nil, {
		[0x00] = "Logon successful",
		[0x02] = "Incorrect password",
		[0x0E] = "An email address should be registered for this account",
		[0x0F] = "Custom error. A string at the end of this message contains the error",
	}},
	array("Server Password Proof", uint8, 20),
	when{Cond.equals("status", 0xF), {
		stringz("Additional information"),
	}},
},
[0xFF55] = { -- 0x55
	uint32("Status", nil, {
		[0x00] = "Change accepted, requires proof",
		[0x01] = "Account doesn't exist",
		[0x05] = "Account requires upgrade",
	}),
	array("Salt", uint8, 32),
	array("Server Key", uint8, 32),
},
[0xFF56] = { -- 0x56
	uint32("Status code", nil, {
		[0x00] = "Password changed",
		[0x02] = "Incorrect old password",
	}),
	array("Server password proof for old password", uint8, 20),
},
[0xFF57] = { -- 0x57
	uint32("Status", nil, {
		[0x00] = "Upgrade Request Accepted",
		[0x01] = "Upgrade Request Denied",
	}),
	uint32("Server Token", base.HEX),
},
[0xFF58] = { -- 0x58
	uint32("Status", nil, {
		[0x00] = "Password changed",
		[0x02] = "Incorrect old password",
	}),
	array("Password proof", uint32, 5),
},
[0xFF59] = { -- 0x59
},
[0xFF5E] = { -- 0x5E
	bytes{label="Encrypted Packet",
		size=function(self, state) return state.packet.length end,
	},
--[[TODO
	uint8("Packet Code"),
	uint32("[4] MD5 Hash of the current Module"),
	uint32("[4] Decryption key for Module"),
	uint32("Length of Module"),
	uint16("Length of data"),
	bytes("Data"),
	uint8("String Length"),
	bytes("String Data"),
	uint8("Check ID"),
	uint8("String Index"),
	uint32("Address"),
	uint8("Length to Read"),
	uint32("Unknown"),
	uint32("[5] SHA1"),
	uint32("Address"),
	uint8("Length to Read"),
	uint8("IDXor"),
	uint16("Length of data"),
	uint32("Checksum of data"),
	uint8("Unknown"),
	uint8("Unknown"),
	uint8("Unknown"),
	stringz("Library Name"),
	uint32("Funct1"),
	uint32("Funct2"),
	uint32("Funct3"),
	uint32("Funct4"),
	uint32("[5] Unknown"),
]]
},
[0xFF60] = { -- 0x60
	uint8{"Number of players", key="players"},
	iterator{alias="none", refkey="players", repeated={
		stringz("Player name"),
	}},
},
[0xFF65] = { -- 0x65
	uint8{"Number of Entries", key="friends"},
	iterator{label="Friend", refkey="friends", repeated={
		stringz("Account"),
		flags{of=uint8, label="Status", fields={
			{sname="Mutual", mask=0x01, desc=Descs.YesNo},
			{sname="DND", mask=0x02, desc=Descs.YesNo},
			{sname="Away", mask=0x04, desc=Descs.YesNo} 
		}},
		uint8("Location", nil, Descs.OnlineStatus),
		strdw("ProductID", Descs.ClientTag),
		stringz("Location name"),
	}},
},
[0xFF66] = { -- 0x66
	uint8("Entry number"),
	flags{of=uint8, label="Status", fields={
		{sname="Mutual", mask=0x01, desc=Descs.YesNo},
		{sname="DND", mask=0x02, desc=Descs.YesNo},
		{sname="Away", mask=0x04, desc=Descs.YesNo} 
	}},
	uint8("Location", nil, Descs.OnlineStatus),
	strdw("ProductID", Descs.ClientTag),
	stringz("Location name"),
},
[0xFF67] = { -- 0x67
	stringz("Account"),
	uint8("Friend Type", nil, {
		[0x00] = "Non-mutual",
		[0x01] = "Mutual",
		[0x02] = "Nonmutual, DND",
		[0x03] = "Mutual, DND",
		[0x04] = "Nonmutual, Away",
		[0x05] = "Mutual, Away",
	}),
	uint8("Friend Status", nil, {
		[0x00] = "Offline",
		[0x02] = "In chat",
		[0x03] = "In public game",
		[0x05] = "In private game",
	}),
	strdw("ProductID", Descs.ClientTag),
	stringz("Location"),
},
[0xFF68] = { -- 0x68
	uint8("Entry Number"),
},
[0xFF69] = { -- 0x69
	uint8("Old Position"),
	uint8("New Position"),
},
[0xFF70] = { -- 0x70
	uint32("Cookie"),
	uint8("Status", nil, {
		[0x00] = "Successfully found candidate(s)",
		[0x01] = "Clan tag already taken",
		[0x08] = "Already in clan",
		[0x0a] = "Invalid clan tag specified",
	}),
	uint8{"Number of potential candidates", key="names"},
	iterator{alias="none", refkey="names", repeated={
		stringz("Username"),
	}},
},
[0xFF71] = { -- 0x71
	uint32("Cookie"),
	uint8("Result", nil, {
		[0x00] = "Everyone accepted",
		[0x04] = "Declined",
		[0x05] = "Not available",
	}),
	-- condition = function(self, state) return state.packet.acc ~="" end,
	iterator{alias="none", condition = Cond.nequals("acc", ""), repeated = {
		stringz{"Failed Account", key="acc"},
	}}
},
[0xFF72] = { -- 0x72
	uint32("Cookie"),
	strdw("Clan Tag"),
	stringz("Clan Name"),
	stringz("Inviter's username"),
	uint8{"Number of users being invited", key="users"},
	iterator{refkey="users", label="Invited users", repeated={
		stringz("Name"),
	}},
},
[0xFF73] = { -- 0x73
	uint32("Cookie"),
	uint8("Result"),
},
[0xFF74] = { -- 0x74
	uint32("Cookie"),
	uint8("Status", nil, {
		[0x00] = "Success",
		[0x02] = "Can't change until clan is a week old",
		[0x04] = "Declined",
		[0x05] = "Failed",
		[0x07] = "Not Authorized",
		[0x08] = "Not Allowed",
	}),
},
[0xFF75] = { -- 0x75
	uint8("Unknown"),
	strdw("Clan tag"),
	uint8("Rank", nil, Descs.ClanRank),
},
[0xFF76] = { -- 0x76
	uint8("Status"),
},
[0xFF77] = { -- 0x77
	uint32("Cookie"),
	uint8("Result", nil, {
		[0x00] = "Invitation accepted",
		[0x04] = "Invitation declined",
		[0x05] = "Failed to invite user",
		[0x09] = "Clan is full",
	}),
},
[0xFF78] = { -- 0x78
	uint32("Cookie"),
	uint8("Status", nil, {
		[0x00] = "Removed",
		[0x01] = "Removal failed",
		[0x02] = "Can not be removed yet",
		[0x07] = "Not authorized to remove",
		[0x08] = "Not allowed to remove",
	}),
},
[0xFF79] = { -- 0x79
	uint32("Cookie"),
	strdw("Clan tag"),
	stringz("Clan name"),
	stringz("Inviter"),
},
[0xFF7A] = { -- 0x7A
	uint32("Cookie"),
	uint8("Status", nil, {
		[0x00] = "Successfully changed rank",
		[0x01] = "Failed to change rank",
		[0x02] = "Cannot change user's rank yet",
		[0x07] = "Not authorized to change user rank",
		[0x08] = "Not allowed to change user rank",
	}),
},
[0xFF7C] = { -- 0x7C
	uint32("Cookie"),
	uint32("Unknown"),
	stringz("MOTD"),
},
[0xFF7D] = { -- 0x7D
	uint32("Cookie"),
	uint8("Number of Members"),
	stringz("Username"),
	uint8("Rank", nil, Descs.ClanRank),
	uint8("Online Status", nil, {
		[0x00] = "Offline",
		[0x01] = "Online",
	}),
	stringz("Location"),
},
[0xFF7E] = { -- 0x7E
	stringz("Clan member name"),
},
[0xFF7F] = { -- 0x7F
	stringz("Username"),
	uint8("Rank", nil, Descs.ClanRank),
	uint8("Status", nil, {
		[0x00] = "Offline",
		[0x01] = "Online (not in either channel or game)",
		[0x02] = "In a channel",
		[0x03] = "In a public game",
		[0x05] = "In a private game",
	}),
	stringz("Location"),
},
[0xFF81] = { -- 0x81
	uint8("Old rank", nil, Descs.ClanRank),
	uint8("New rank", nil, Descs.ClanRank),
	stringz("Clan member who changed your rank"),
},
[0xFF82] = { -- 0x82
	uint32("Cookie"),
	uint8("Status code"),
	stringz("Clan name"),
	uint8("User's rank"),
	wintime("Date joined"),
},
-- End spackets_sid.lua
}

-- Packets from client to server
CPacketDescription = {
-- Begin cpackets_sid.lua
-- Battle.net Messages
[0xFF00] = { -- 0x00
},
[0xFF02] = { -- 0x02
},
[0xFF05] = { -- 0x05
	uint32("Registration Version"),
	uint32("Registration Authority"),
	uint32("Account Number"),
	uint32("Registration Token"),
	stringz("LAN Computer Name"),
	stringz("LAN Username"),
},
[0xFF06] = { -- 0x06
	strdw("Platform ID", Descs.PlatformID),
	strdw("Product ID", Descs.ClientTag),
	uint32("Version Byte"),
	uint32("Unknown"),
},
[0xFF07] = { -- 0x07
	strdw("Platform ID", Descs.PlatformID),
	strdw("Product ID", Descs.ClientTag),
	uint32("Version Byte"),
	uint32("EXE Version"),
	uint32("EXE Hash"),
	stringz("EXE Information"),
},
[0xFF08] = { -- 0x08
	uint32("Password protected", nil, Descs.YesNo),
	uint32("Unknown"),
	uint32("Unknown"),
	uint32("Unknown"),
	uint32("Unknown"),
	uint32("Port"),
	stringz("Game name"),
	stringz("Game password"),
	stringz("Game stats - flags, creator, statstring"),
	stringz("Map name - 0x0d terminated"),
},
[0xFF09] = { -- 0x09
	uint16("For STAR/SEXP/SSHR/JSTR and W2BN - game type", nil, {
		[0x00] = "All",
		[0x02] = "Melee",
		[0x03] = "Free for all",
		[0x04] = "one vs one",
		[0x05] = "CTF",
		[0x06] = "Greed",
		[0x07] = "Slaughter",
		[0x08] = "Sudden Death",
		[0x09] = "Ladder",
		[0x10] = "Iron man ladder",
		[0x0A] = "Use Map Settings",
		[0x0B] = "Team Melee",
		[0x0C] = "Team FFA",
		[0x0D] = "Team CTF",
		[0x0F] = "Top vs Bottom",
	}),
	--[[ for DRTL/DSHR - level range
	{
		[0x00] = "Level 1",
		[0x01] = "2 - 3",
		[0x02] = "4 - 5",
		[0x03] = "6 - 7",
		[0x04] = "8 - 9",
		[0x05] = "10 - 12",
		[0x06] = "13 - 16",
		[0x07] = "17 - 19",
		[0x08] = "20 - 24",
		[0x09] = "25 - 29",
		[0x0A] = "30 - 34",
		[0x0B] = "35 - 39",
		[0x0C] = "40 - 47",
		[0x0D] = "48 - 50",
	} --]]
	uint16("Product-specific condition 2 (unknown, 0)"),
	uint32("Product-specific condition 3"),
	uint32("Product-specific condition 4 (unknown, 0)"),
	uint32("List count"),
	stringz("Game name"),
	stringz("Game password"),
	stringz("Game stats"),
},
[0xFF0A] = { -- 0x0A
	stringz("Username"),
	stringz("Statstring"),
},
[0xFF0B] = { -- 0x0B
	strdw("Product ID", Descs.ClientTag),
},
[0xFF0C] = { -- 0x0C
	uint32("Flags", nil, {
		[0x00] = "NoCreate join",
		[0x01] = "First join",
		[0x02] = "Forced join",
		[0x05] = "D2 first join",
	}),
	stringz("Channel"),
},
[0xFF0E] = { -- 0x0E
	stringz("Text"),
},
[0xFF10] = { -- 0x10
},
[0xFF12] = { -- 0x12
	wintime("System time"),
	wintime("Local time"),
	uint32("Timezone bias"),
	uint32("SystemDefaultLCID"),
	uint32("UserDefaultLCID"),
	uint32("UserDefaultLangID"),
	stringz("Abbreviated language name"),
	stringz("Country name"),
	stringz("Abbreviated country name"),
	stringz("Country (English)"),
},
[0xFF14] = { -- 0x14
	strdw("UDPCode"),
},
[0xFF15] = { -- 0x15
	strdw("Platform ID", Descs.PlatformID),
	strdw("Product ID", Descs.ClientTag),
	uint32("ID of last displayed banner"),
	posixtime("Current time"),
},
[0xFF16] = { -- 0x16
	uint32("Ad ID"),
	uint32("Request type", nil, {
		[0] = "Client used SID_QUERYADURL",
		[1] = "Client did not use SID_QUERYADURL",
	}),
},

[0xFF17] = { -- 0x17
	uint32("Request ID"),
	bytes("Memory"), -- TODO: bytes till packet end
},

[0xFF18] = { -- 0x18
	uint32("Cookie"),
	stringz("Key Value"),
},
[0xFF1A] = { -- 0x1A
	uint32("Password Protected"),
	uint32("Unknown"),
	uint32("Unknown"),
	uint32("Unknown"),
	uint32("Unknown"),
	uint32("Port"),
	stringz("Game name"),
	stringz("Game password"),
	stringz("Unknown"),
	stringz("Game stats - Flags, Creator, Statstring"),
},
[0xFF1B] = { -- 0x1B
	sockaddr("Address"),
},
[0xFF1C] = { -- 0x1C
	flags{of=uint32, label="State", fields={
		{sname="Game is private", mask=0x01, desc=Descs.YesNo},
		{sname="Game is full", mask=0x02, desc=Descs.YesNo},
		{sname="Game contains players (other than creator)", mask=0x04, desc=Descs.YesNo},
		{sname="Game is in progress", mask=0x08, desc=Descs.YesNo} 
	}},
	uint32("Time since creation"),
	uint16("Game Type", nil, {
		[0x02] = "Melee",
		[0x03] = "Free for All",
		[0x04] = "1 vs 1",
		[0x09] = "Ladder",
		[0x0A] = "Use Map Settings",
		[0x0F] = "Top vs Bottom",
		[0x10] = "Iron Man Ladder (W2BN only)",
	}),
	uint16("Parameter"),
	uint32("Unknown"),
	uint32("Ladder", nil, {
		[0x00] = "NonLadder",
		[0x01] = "Ladder",
		[0x03] = "Iron Man Ladder (W2BN only)",
	}),
	stringz("Game name"),
	stringz("Game password"),
	stringz("Game Statstring"),
},
[0xFF1E] = { -- 0x1E
	uint32("Server Version"),
	uint32("Registration Version"),
	uint32("Registration Authority"),
	uint32("Registration Authority"),
	uint32("Registration Version"),
	uint32("Account Number"),
	uint32("Registration Token"),
	stringz("LAN computer name"),
	stringz("LAN username"),
},
[0xFF1F] = { -- 0x1F
},
[0xFF21] = { -- 0x21
	strdw("Platform ID", Descs.PlatformID),
	strdw("Product ID", Descs.ClientTag),
	uint32("Ad ID"),
	stringz("Filename"),
	stringz("URL"),
},
[0xFF22] = { -- 0x22
	strdw("Product ID", Descs.ClientTag),
	uint32("Product version"),
	stringz("Game Name"),
	stringz("Game Password"),
},

[0xFF24] = { -- 0x24
	uint32("First DWORD from S -> C"),
	uint32("Second DWORD from S -> C"),
	stringz("Registry key name"),
	stringz("Registry key value"),
},

[0xFF25] = { -- 0x25
	uint32("Ping Value", base.HEX),
},
[0xFF26] = { -- 0x26
	uint32{"Number of Accounts", key="numaccts"},
	uint32{"Number of Keys", key="numkeys"},
	uint32("Request ID"),
	iterator{alias="none", label="Requested Account", refkey="numaccts", repeated={
		stringz("Account"),
	}},
	iterator{alias="none", label="Keys", refkey="numkeys", repeated={
		stringz("Key"),
	}}, 
},
[0xFF27] = { -- 0x27
	uint32{label="Number of accounts", key="numaccts"},	-- TODO: it works?
	uint32{label="Number of keys", key="numkeys"},
	iterator{label="Accounts to update", refkey="numaccts", repeated={
		stringz("Account" --[[,{[""] = "Own account",}]]),
	}},
	iterator{label="Keys to update", refkey="numkeys", repeated={
		stringz("Key"),
	}},
	iterator{label="New values", refkey="numkeys", repeated={
		stringz("New value"),
	}},
},
[0xFF29] = { -- 0x29
	uint32("Client Token"),
	uint32("Server Token"),
	array("Password Hash", uint32, 5),
	stringz("Username"),
},
[0xFF2A] = { -- 0x2A
	array("Hashed password", uint32, 5),
	stringz("Username"),
},
[0xFF2B] = { -- 0x2B
	uint32("Number of processors"),
	uint32("Processor architecture"),
	uint32("Processor level"),
	uint32("Processor timing"),
	uint32("Total physical memory"),
	uint32("Total page file"),
	uint32("Free disk space"),
},
[0xFF2C] = { -- 0x2C
	uint32("Game type", nil, {
		[0x00] = "Normal",
		[0x01] = "Ladder",
		[0x03] = "Ironman (W2BN only)",
	}),
	uint32{label="Number of results (always 8)", key="numresults"},
	iterator{label="Game results", refkey="numresults", repeated={
		uint32("Result", nil, {
			[0x01] = "Win",
			[0x02] = "Loss",
			[0x03] = "Draw",
			[0x04] = "Disconnect",
		}),
	}},
	iterator{label="Players", refkey="numresults", repeated={
		stringz("Player"),	
	}},
	stringz("Map name"),
	stringz("Player score"),
},
[0xFF2D] = { -- 0x2D
},
[0xFF2E] = { -- 0x2E
	strdw("Product ID", Descs.ClientTag),
	uint32("League"),
	uint32("Sort method", nil, {
		[0x00] = "Highest rating",
		[0x01] = "Fastest climbers",
		[0x02] = "Most wins on record",
		[0x03] = "Most games played",
	}),
	uint32("Starting rank"),
	uint32("Number of ranks to list"),
},
[0xFF2F] = { -- 0x2F
	uint32("League"),
	uint32("Sort method", nil, {
		[0x00] = "Highest rating",
		[0x01] = "Unused",
		[0x02] = "Most wins on record",
		[0x03] = "Most games played",
	}),
	stringz("Username"),
},
[0xFF30] = { -- 0x30
	uint32("Spawn"),
	stringz("CDKey"),
	stringz("Key Owner"),
},
[0xFF31] = { -- 0x31
	uint32("Client Token"),
	uint32("Server Token"),
	array("Old hashed password", uint32, 5),
	array("New password hash", uint32, 5),
	stringz("Account name"),
},
[0xFF32] = { -- 0x32
	array("File checksum", uint32, 5),
	stringz("File name"),
},
[0xFF33] = { -- 0x33
	uint32("Request ID"),
	uint32("Unknown"),
	stringz("Filename"),
},
[0xFF34] = { -- 0x34
	uint32("Unused"),
	uint32("Unused"),
	stringz("Unknown"),
},
[0xFF35] = { -- 0x35
	uint32("Cookie"),
	stringz("Username"),
},
[0xFF36] = { -- 0x36
	uint32("Spawn"),
	uint32("Key Length"),
	uint32("CDKey Product"),
	uint32("CDKey Value1"),
	uint32("Server Token"),
	uint32("Client Token"),
	array("Hashed Data", uint32, 5),
	stringz("Key owner"),
},
[0xFF3A] = { -- 0x3A
	uint32("Client Token", base.HEX),
	uint32("Server Token", base.HEX),
	array("Password Hash", uint32, 5),
	stringz("Username"),
},
[0xFF3C] = { -- 0x3C
	uint32("File size in bytes"),
	array("File hash", uint32, 5),
	stringz("Filename"),
},
[0xFF3D] = { -- 0x3D
	array("Password hash", uint32, 5),
	stringz("Username"),
},
[0xFF3E] = { -- 0x3E
	uint32("Client Token"),
	array("Hashed realm password", uint32, 5),
	stringz("Realm title"),
},
[0xFF40] = { -- 0x40
},
[0xFF41] = { -- 0x41
	uint32("Ad ID"),
},
[0xFF44] = { -- 0x44
	uint8{"Subcommand ID", key="subcommand", nil, Descs.WarcraftGeneralSubcommandId},
	-- Subcommand ID 0: Game search?
	when{Cond.equals("subcommand", 0), {
		uint32("Cookie"),
		uint32("Unknown"),
		uint8("Unknown"),
		uint8("Type", nil, {
			[0x00] = "1vs1",
			[0x01] = "2vs2",
			[0x02] = "3vs3",
			[0x03] = "4vs4",
			[0x04] = "Free for All",
		}),
		uint16("Enabled Maps (every bit is one map, from 0x0000 to 0x0FFF)"),
		uint16("Unknown"),
		uint8("Unknown"),
		uint32("TickCount"),
		flags{label="Race", of=uint32, fields={
			{sname="Human",     mask=0x01, desc=Descs.YesNo},
			{sname="Orc",       mask=0x02, desc=Descs.YesNo},
			{sname="Night Elf", mask=0x04, desc=Descs.YesNo},
			{sname="Undead",    mask=0x08, desc=Descs.YesNo},
			{sname="Random",    mask=0x20, desc=Descs.YesNo},
		}},
	}},
	
	-- Subcommand ID 2: Request ladder map listing
	when{Cond.equals("subcommand", 2), { 
		uint32("Cookie"),
		uint8{label="Number of types requested",key="num"},
		iterator{label="Game Information", refkey="num", repeated={
			strdw("Request data", Descs.WarcraftGeneralRequestType),
			-- seems to be dword(0)
			-- seems this is another war3 datatype, double strdw :)
			uint32("Dword(0)"),
		}},
	}},
	
	-- Subcommand ID 3: WID_CANCELSEARCH
	when{Cond.equals("subcommand", 3),
		{  },
	},
	
	-- Subcommand ID 4: User stats request
	when{Cond.equals("subcommand", 4), {  
		uint32("Cookie"),
		stringz("Username"),
		strdw("Product ID", Descs.ClientTag),
	}},
	
	-- Subcommand ID 7: WID_TOURNAMENT
	when{Cond.equals("subcommand", 7), {  
		uint32("Cookie"),
	}},
	
	-- Subcommand ID 8: Clan stats request
	when{Cond.equals("subcommand", 8), { 
		uint32("Cookie"),
		stringz("Account name"),
		-- TODO: "' in strings?
		strdw("Product ID (WAR3 or W3XP)", Descs.ClientTag), 
	}}, 
	
	-- Subcommand ID 9: Icon list request
	when{Cond.equals("subcommand", 9), { 			
		uint32("Cookie"),
	}},
	
	-- Subcommand ID 10: Change icon
	when{Cond.equals("subcommand", 0x0A), { 			
		strdw("Icon", Descs.W3Icon),
	}},
},
[0xFF45] = { -- 0x45
	uint16("Port"),
},
[0xFF46] = { -- 0x46
	posixtime("News timestamp"),
},
[0xFF4B] = { -- 0x4B
	uint16("Game type"),
	uint16("Length"),
	stringz("Work returned data"),
},
[0xFF50] = { -- 0x50
	uint32("Protocol ID (0)"),
	strdw("Platform ID", Descs.PlatformID),
	strdw("Product ID", Descs.ClientTag),
	uint32("Version Byte", base.HEX),
	strdw("Product language", Descs.LangId),
	ipv4("Local IP for NAT compatibility"),
	int32("Time zone bias", nil, Descs.TimeZoneBias),
	uint32("Locale ID", nil, Descs.LocaleID),
	uint32("Language ID", nil, Descs.LocaleID),
	stringz("Country abreviation"),
	stringz("Country"),
},
[0xFF51] = { -- 0x51
	uint32("Client Token", base.HEX),
	version("EXE Version"),
	uint32("EXE Hash", base.HEX),
	uint32{label="Number of CD-keys in this packet", key="cdkeys"},
	uint32("Spawn CD-key", nil, Descs.YesNo),
	iterator{label="CD-Key", refkey="cdkeys", repeated={
		uint32("Key Length"),
		uint32("CD-key's product value", base.HEX, {
				[0x01] = "STAR",
				[0x02] = "STAR",
				[0x17] = "STAR (26-character)",
				[0x06] = "D2DV",
				[0x18] = "D2DV (26-character)",
				[0x0A] = "D2XP",
				[0x19] = "D2XP (26-character)",
				[0x04] = "W2BN",
				[0x0E] = "WAR3",
				[0x12] = "W3XP",
		}),
		uint32("CD-key's public value", base.HEX),
		uint32("Unknown (0)"),
		array("Hashed Key Data", uint32, 5),
	}},
	stringz("Exe Information"),
	stringz("CD-Key owner name"),

},
[0xFF52] = { -- 0x52
	array("Salt", uint8, 32),
	array("Verifier", uint8, 32),
	stringz("Username"),
},
[0xFF53] = { -- 0x53
	array("Client Key", uint8, 32),
	stringz("Username"),
},
[0xFF54] = { -- 0x54
	array("Client Password Proof", uint8, 20),
},
[0xFF55] = { -- 0x55
	array("Client key", uint8, 32),
	stringz("Username"),
},
[0xFF56] = { -- 0x56
	array("Old password proof", uint8, 20),
	array("New password's salt", uint8, 32),
	array("New password's verifier", uint8, 32),
},
[0xFF57] = { -- 0x57
},
[0xFF58] = { -- 0x58
	uint32("Client Token"),
	array("Old Password Hash", uint32, 5),
	array("New Password Salt", uint8, 32),
	array("New Password Verifier", uint8, 32),
},
[0xFF59] = { -- 0x59
	stringz("Email Address"),
},
[0xFF5A] = { -- 0x5A
	stringz("Account Name"),
	stringz("Email Address"),
},
[0xFF5B] = { -- 0x5B
	stringz("Account Name"),
	stringz("Old Email Address"),
	stringz("New Email Address"),
},
[0xFF5C] = { -- 0x5C
	strdw("Product ID", Descs.ClientTag),
},
[0xFF5D] = { -- 0x5D
	uint32("0x10A0027"),
	uint32("Exception code"),
	uint32("Unknown"),
	uint32("Unknown"),
},
[0xFF5E] = { -- 0x5E
	bytes("Encrypted Packet"),
	uint8("Packet Code"),
	uint8("Success"),
	uint8("Success"),
	uint16("String Length"),
	uint32("String Checksum"),
	bytes("String Data"),
	uint8("Success"),
	bytes("Data"),
	uint8("Success"),
	uint8("IDXor"),
	array("Unknown", uint32, 4),
},
[0xFF60] = { -- 0x60
},
[0xFF65] = { -- 0x65
},
[0xFF66] = { -- 0x66
	uint8("Friends list index"),
},
[0xFF70] = { -- 0x70
	uint32("Cookie"),
	strdw("Clan Tag"),
},
[0xFF71] = { -- 0x71
	uint32("Cookie"),
	stringz("Clan name"),
	strdw("Clan tag"),
	uint8{"Number of users to invite", key="numusers"},
	iterator{label="Usernames to invite", refkey="numusers", repeated={
		stringz("Account"),
	}},
	-- stringz("[] Usernames to invite"),
},
[0xFF72] = { -- 0x72
	uint32("Cookie"),
	strdw("Clan tag"),
	stringz("Inviter name"),
	uint8("Status"),
},
[0xFF73] = { -- 0x73
	uint32("Cookie"),
},
[0xFF74] = { -- 0x74
	uint32("Cookie"),
	stringz("New Cheiftain"),
},
[0xFF77] = { -- 0x77
	uint32("Cookie"),
	stringz("Target User"),
},
[0xFF78] = { -- 0x78
	uint32("Cookie"),
	stringz("Username"),
},
[0xFF79] = { -- 0x79
	uint32("Cookie"),
	strdw("Clan tag"),
	stringz("Inviter"),
	uint8("Response"),
},
[0xFF7A] = { -- 0x7A
	uint32("Cookie"),
	stringz("Username"),
	uint8("New rank"),
},
[0xFF7B] = { -- 0x7B
	uint32("Cookie"),
	stringz("MOTD"),
},
[0xFF7C] = { -- 0x7C
	uint32("Cookie"),
},
[0xFF7D] = { -- 0x7D
	uint32("Cookie"),
},
[0xFF82] = { -- 0x82
	uint32("Cookie"),
	strdw("User's clan tag"),
	stringz("Username"),
},
-- End cpackets_sid.lua
}

local packets = doc.new "packets"
local server = doc.new "server"
local client = doc.new "client"

local function add_packets(root, packets_table)
	for k,v in pairs(packets_table) do
		local packet = doc.new("packet", {id=k})
		for _,field in ipairs(v) do
			packet:add_direct_child(field)
		end
		root:add_direct_child(packet)
	end
end

add_packets(server, SPacketDescription)
add_packets(client, CPacketDescription)

packets:add_direct_child(server)
packets:add_direct_child(client)

doc.walk(packets, false, function(tag, node)
	for k,v in pairs(node.attr) do
		if type(k) ~= "number" then
			node.attr[k] = tostring(v)
		end
	end
end)

xml = doc.tostring(packets, "", "    ")
print(xml)
