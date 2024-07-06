
if UnitFactionGroup("player") ~= "Alliance" then return end


local _, SummerFestival = ...
local points = SummerFestival.points
-- points[<mapfile>] = { [<coordinates>] = "<questID>:<type>" }

if (SummerFestival.isClassic) then
	----------------------
	-- Eastern Kingdoms --
	----------------------
	points[1417] = { -- "Arathi"
		[50204499] = "11804:H",	-- Refuge Pointe
		[74174159] = "11764:D",	-- Hammerfall
	}
	points[1418] = { -- "Badlands"
		[4814890] = "11766:D",	-- New Kargath
	}
	points[1419] = { -- "BlastedLands"
		[59051703] = "11808:H",	-- Nethergarde Keep
	}
	points[1428] = { -- "BurningSteppes"
		[61932909] = "11768:D",	-- Flame Crest
		[80656253] = "11810:H",	-- Morgan's Vigil
	}
	points[1426] = { -- "DunMorogh"
		[46594666] = "11813:H",	-- Kharanos
	}
	points[1431] = { -- "Duskwood"
		[73215502] = "11814:H",	-- Darkshire
	}
	points[1429] = { -- "Elwynn"
		[43086285] = "11816:H",	-- Goldshire
	}
	points[1941] = { -- "EversongWoods"
		[55823765] = "11935:C",	-- Stealing Silvermoon's Flame
		[46415060] = "11772:D",	-- Falconwing Square
	}
	points[1942] = { -- "Ghostlands"
		[46892633] = "11774:D",	-- Tranquillien
	}
	points[1424] = { -- "HillsbradFoothills"
		[58562488] = "11776:D",	-- Tarren Mill
		[50414724] = "11819:H",	-- South Shore
	}
	points[1425] = { -- "Hinterlands"
		[14514987] = "11826:H",	-- Aerie Peak
		[76627497] = "11784:D",	-- Revantusk Village
	}
	points[1432] = { -- "LochModan"
		[32314009] = "11820:H",	-- Thelsamar
	}
	points[1433] = { -- "Redridge"
		[24775914] = "11822:H",	-- Lakeshire
	}
	points[1954] = { -- "SilvermoonCity"
		[68984318] = "11935:C",	-- Stealing Silvermoon's Flame
	}
	points[1421] = { -- "Silverpine"
		[49633820] = "11580:D",	-- The Sepulcher
	}
	points[1435] = { -- "SwampOfSorrows" --Doesn't exist in pre-cataclysm.
		[46954749] = "11781:D",	-- Bogpaddle (west)
	}
	points[1434] = { -- "TheCapeOfStranglethorn"
		[32907528] = "11801:D",	-- Wild Shore (south)
		[33867344] = "11832:H",	-- Wild Shore (north)
	}
	points[1420] = { -- "Tirisfal"
		[57235177] = "11786:D",	-- Brill
		[62336682] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[1458] = { -- "Undercity"
		[68420836] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[1422] = { -- "WesternPlaguelands"
		[43568258] = "11827:H",	-- Chillwind Camp
	}
	points[1436] = { -- "Westfall"
		[55945412] = "11583:H",	-- Moonbrook
	}
	points[1437] = { -- "Wetlands"
		[13284724] = "11828:H",	-- Menethil Harbour
	}
	
	--------------
	-- Kalimdor --
	--------------
	points[1440] = { -- "Ashenvale"
		[70106920] = "11765:D",	-- Silverwind Refuge
		[37835486] = "11805:H",	-- Astranaar
	}
	points[1943] = { -- "AzuremystIsle"
		[44485251] = "11806:H",	-- Azure Watch
	}
	points[1413] = { -- "Barrens"
		[52182798] = "11783:D",	-- The Crossroads
	}
	points[1950] = { -- "BloodmystIsle"
		[55826789] = "11809:H",	-- Blood Watch
	}
	points[1439] = { -- "Darkshore"
		[37104604] = "11811:H",	-- Lor'danel
	}
	points[1443] = { -- "Desolace"
		[26137690] = "11769:D",	-- Silverprey Village
		[65861688] = "11812:H",	-- Nijel's Point
	}
	points[1411] = { -- "Durotar"
		[52254739] = "11770:D",	-- Razor Hill
	}
	points[1445] = { -- "Dustwallow"
		[33433092] = "11771:D",	-- Brackenwall Village
		[62064047] = "11815:H",	-- Theramore Isle
	}
	points[1444] = { -- "Feralas"
		[28244390] = "11817:H",	-- Feathermoon Stronghold
		[72384780] = "11773:D",	-- Camp Mojache
	}
	points[1412] = { -- "Mulgore"
		[35042393] = "9325:C",	-- Stealing Thunder Bluff's Flame
		[51825924] = "11777:D",	-- Bloodhoof Village
	}
	points[1454] = { -- "Orgrimmar"
		[42603366] = "9324:C",	-- Stealing Orgrimmar's Flame
	}
	points[1451] = { -- "Silithus"
		[46444465] = "11800:D",	-- Cenarion Hold (south)
		[57613506] = "11831:H",	-- Cenarion Hold (east)
	}
	points[1442] = { -- "StonetalonMountains"
		[50516041] = "11780:D",	-- Sun Rock Retreat
	}
	points[1446] = { -- "Tanaris"
		[49852702] = "11802:D",	-- Gadgetzan (west)
		[52752927] = "11833:H",	-- Gadgetzan (east)
	}
	points[1438] = { -- "Teldrassil"
		[54976042] = "11824:H",	-- Dolanaar
	}
	points[1456] = { -- "ThunderBluff"
		[21282706] = "9325:C",	-- Stealing Thunder Bluff's Flame
	}
	points[1441] = { -- "Thousand Needles"
		[42375295] = "11785:D", -- Freewind post
	}
	points[1452] = { -- "Winterspring"
		[59853554] = "11803:D",	-- Everlook (west)
		[62623541] = "11834:H",	-- Everlook (east)
	}
	
	-------------
	-- Outland --
	-------------
	points[1949] = { -- "BladesEdgeMountains"
		[41576590] = "11807:H",	-- Sylvanaar
		[50045902] = "11767:D",	-- Thunderlord Stronghold
	}
	points[1944] = { -- "Hellfire"
		[57194175] = "11775:D",	-- Thrallmar
		[62175829] = "11818:H",	-- Honour Hold
	}
	points[1951] = { -- "Nagrand"
		[49616946] = "11821:H",	-- Telaar
		[51103396] = "11778:D",	-- Garadar
	}
	points[1953] = {
		[31216266] = "11830:H",	-- Area 52 (north-west)
		[32306833] = "11799:D",	-- Area 52 (south)
	}
	points[1948] = { -- "ShadowmoonValley"
		[33533028] = "11779:D",	-- Shadowmoon Village
		[39625464] = "11823:H",	-- Wildhammer Stronghold
	}
	points[1952] = {
		[51934324] = "11782:D",	-- Stonebreaker Hold
		[54065552] = "11825:H",	-- Allerian Stronghold
	}
	points[1946] = { -- "Zangarmarsh"
		[35585182] = "11787:D",	-- Zabra'jin
		[68795195] = "11829:H",	-- Telredor
	}
elseif (SummerFestival.isTBC) then
	----------------------
	-- Eastern Kingdoms --
	----------------------
	points[1417] = { -- "Arathi"
		[50204499] = "11804:H",	-- Refuge Pointe
		[74174159] = "11764:D",	-- Hammerfall
	}
	points[1418] = { -- "Badlands"
		[4814890] = "11766:D",	-- New Kargath
	}
	points[1419] = { -- "BlastedLands"
		[59051703] = "11808:H",	-- Nethergarde Keep
	}
	points[1428] = { -- "BurningSteppes"
		[61932909] = "11768:D",	-- Flame Crest
		[80656253] = "11810:H",	-- Morgan's Vigil
	}
	points[1426] = { -- "DunMorogh"
		[46594666] = "11813:H",	-- Kharanos
	}
	points[1431] = { -- "Duskwood"
		[73215502] = "11814:H",	-- Darkshire
	}
	points[1429] = { -- "Elwynn"
		[43086285] = "11816:H",	-- Goldshire
	}
	points[1941] = { -- "EversongWoods"
		[55823765] = "11935:C",	-- Stealing Silvermoon's Flame
		[46415060] = "11772:D",	-- Falconwing Square
	}
	points[1942] = { -- "Ghostlands"
		[46892633] = "11774:D",	-- Tranquillien
	}
	points[1424] = { -- "HillsbradFoothills"
		[58562488] = "11776:D",	-- Tarren Mill
		[50414724] = "11819:H",	-- South Shore
	}
	points[1425] = { -- "Hinterlands"
		[14514987] = "11826:H",	-- Aerie Peak
		[76627497] = "11784:D",	-- Revantusk Village
	}
	points[1432] = { -- "LochModan"
		[32314009] = "11820:H",	-- Thelsamar
	}
	points[1433] = { -- "Redridge"
		[24775914] = "11822:H",	-- Lakeshire
	}
	points[1954] = { -- "SilvermoonCity"
		[68984318] = "11935:C",	-- Stealing Silvermoon's Flame
	}
	points[1421] = { -- "Silverpine"
		[49633820] = "11580:D",	-- The Sepulcher
	}
	points[1435] = { -- "SwampOfSorrows" --Doesn't exist in pre-cataclysm.
		[46954749] = "11781:D",	-- Bogpaddle (west)
	}
	points[1434] = { -- "TheCapeOfStranglethorn"
		[32907528] = "11801:D",	-- Wild Shore (south)
		[33867344] = "11832:H",	-- Wild Shore (north)
	}
	points[1420] = { -- "Tirisfal"
		[57235177] = "11786:D",	-- Brill
		[62336682] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[1458] = { -- "Undercity"
		[68420836] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[1422] = { -- "WesternPlaguelands"
		[43568258] = "11827:H",	-- Chillwind Camp
	}
	points[1436] = { -- "Westfall"
		[55945412] = "11583:H",	-- Moonbrook
	}
	points[1437] = { -- "Wetlands"
		[13284724] = "11828:H",	-- Menethil Harbour
	}
	
	--------------
	-- Kalimdor --
	--------------
	points[1440] = { -- "Ashenvale"
		[70106920] = "11765:D",	-- Silverwind Refuge
		[37835486] = "11805:H",	-- Astranaar
	}
	points[1943] = { -- "AzuremystIsle"
		[44485251] = "11806:H",	-- Azure Watch
	}
	points[1413] = { -- "Barrens"
		[52182798] = "11783:D",	-- The Crossroads
	}
	points[1950] = { -- "BloodmystIsle"
		[55826789] = "11809:H",	-- Blood Watch
	}
	points[1439] = { -- "Darkshore"
		[37104604] = "11811:H",	-- Lor'danel
	}
	points[1443] = { -- "Desolace"
		[26137690] = "11769:D",	-- Silverprey Village
		[65861688] = "11812:H",	-- Nijel's Point
	}
	points[1411] = { -- "Durotar"
		[52254739] = "11770:D",	-- Razor Hill
	}
	points[1445] = { -- "Dustwallow"
		[33433092] = "11771:D",	-- Brackenwall Village
		[62064047] = "11815:H",	-- Theramore Isle
	}
	points[1444] = { -- "Feralas"
		[28244390] = "11817:H",	-- Feathermoon Stronghold
		[72384780] = "11773:D",	-- Camp Mojache
	}
	points[1412] = { -- "Mulgore"
		[35042393] = "9325:C",	-- Stealing Thunder Bluff's Flame
		[51825924] = "11777:D",	-- Bloodhoof Village
	}
	points[1454] = { -- "Orgrimmar"
		[46113733] = "9324:C",	-- Stealing Orgrimmar's Flame
	}
	points[1451] = { -- "Silithus"
		[46444465] = "11800:D",	-- Cenarion Hold (south)
		[57613506] = "11831:H",	-- Cenarion Hold (east)
	}
	points[1442] = { -- "StonetalonMountains"
		[50516041] = "11780:D",	-- Sun Rock Retreat
	}
	points[1446] = { -- "Tanaris"
		[49852702] = "11802:D",	-- Gadgetzan (west)
		[52752927] = "11833:H",	-- Gadgetzan (east)
	}
	points[1438] = { -- "Teldrassil"
		[54976042] = "11824:H",	-- Dolanaar
	}
	points[1456] = { -- "ThunderBluff"
		[21282706] = "9325:C",	-- Stealing Thunder Bluff's Flame
	}
	points[1441] = { -- "Thousand Needles"
		[42375295] = "11785:D", -- Freewind post
	}
	points[1452] = { -- "Winterspring"
		[59853554] = "11803:D",	-- Everlook (west)
		[62623541] = "11834:H",	-- Everlook (east)
	}
	
	-------------
	-- Outland --
	-------------
	points[1949] = { -- "BladesEdgeMountains"
		[41576590] = "11807:H",	-- Sylvanaar
		[50045902] = "11767:D",	-- Thunderlord Stronghold
	}
	points[1944] = { -- "Hellfire"
		[57194175] = "11775:D",	-- Thrallmar
		[62175829] = "11818:H",	-- Honour Hold
	}
	points[1951] = { -- "Nagrand"
		[49616946] = "11821:H",	-- Telaar
		[51103396] = "11778:D",	-- Garadar
	}
	points[1953] = {
		[31216266] = "11830:H",	-- Area 52 (north-west)
		[32306833] = "11799:D",	-- Area 52 (south)
	}
	points[1948] = { -- "ShadowmoonValley"
		[33533028] = "11779:D",	-- Shadowmoon Village
		[39625464] = "11823:H",	-- Wildhammer Stronghold
	}
	points[1952] = {
		[51934324] = "11782:D",	-- Stonebreaker Hold
		[54065552] = "11825:H",	-- Allerian Stronghold
	}
	points[1946] = { -- "Zangarmarsh"
		[35585182] = "11787:D",	-- Zabra'jin
		[68795195] = "11829:H",	-- Telredor
	}
elseif (SummerFestival.isWrath) then
	----------------------
	-- Eastern Kingdoms --
	----------------------
	points[1417] = { -- "Arathi"
		[50204499] = "11804:H",	-- Refuge Pointe
		[74174159] = "11764:D",	-- Hammerfall
	}
	points[1418] = { -- "Badlands"
		[4814890] = "11766:D",	-- New Kargath
	}
	points[1419] = { -- "BlastedLands"
		[59051703] = "11808:H",	-- Nethergarde Keep
	}
	points[1428] = { -- "BurningSteppes"
		[61932909] = "11768:D",	-- Flame Crest
		[80656253] = "11810:H",	-- Morgan's Vigil
	}
	points[1426] = { -- "DunMorogh"
		[46594666] = "11813:H",	-- Kharanos
	}
	points[1431] = { -- "Duskwood"
		[73215502] = "11814:H",	-- Darkshire
	}
	points[1429] = { -- "Elwynn"
		[43086285] = "11816:H",	-- Goldshire
	}
	points[1941] = { -- "EversongWoods"
		[55823765] = "11935:C",	-- Stealing Silvermoon's Flame
		[46415060] = "11772:D",	-- Falconwing Square
	}
	points[1942] = { -- "Ghostlands"
		[46892633] = "11774:D",	-- Tranquillien
	}
	points[1424] = { -- "HillsbradFoothills"
		[58562488] = "11776:D",	-- Tarren Mill
		[50414724] = "11819:H",	-- South Shore
	}
	points[1425] = { -- "Hinterlands"
		[14514987] = "11826:H",	-- Aerie Peak
		[76627497] = "11784:D",	-- Revantusk Village
	}
	points[1432] = { -- "LochModan"
		[32314009] = "11820:H",	-- Thelsamar
	}
	points[1433] = { -- "Redridge"
		[24775914] = "11822:H",	-- Lakeshire
	}
	points[1954] = { -- "SilvermoonCity"
		[68984318] = "11935:C",	-- Stealing Silvermoon's Flame
	}
	points[1421] = { -- "Silverpine"
		[49633820] = "11580:D",	-- The Sepulcher
	}
	points[1435] = { -- "SwampOfSorrows" --Doesn't exist in pre-cataclysm.
		[46954749] = "11781:D",	-- Bogpaddle (west)
	}
	points[1434] = { -- "TheCapeOfStranglethorn"
		[32907528] = "11801:D",	-- Wild Shore (south)
		[33867344] = "11832:H",	-- Wild Shore (north)
	}
	points[1420] = { -- "Tirisfal"
		[57235177] = "11786:D",	-- Brill
		[62336682] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[1458] = { -- "Undercity"
		[68420836] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[1422] = { -- "WesternPlaguelands"
		[43568258] = "11827:H",	-- Chillwind Camp
	}
	points[1436] = { -- "Westfall"
		[55945412] = "11583:H",	-- Moonbrook
	}
	points[1437] = { -- "Wetlands"
		[13284724] = "11828:H",	-- Menethil Harbour
	}
	
	--------------
	-- Kalimdor --
	--------------
	points[1440] = { -- "Ashenvale"
		[70106920] = "11765:D",	-- Silverwind Refuge
		[37835486] = "11805:H",	-- Astranaar
	}
	points[1943] = { -- "AzuremystIsle"
		[44485251] = "11806:H",	-- Azure Watch
	}
	points[1413] = { -- "Barrens"
		[52182798] = "11783:D",	-- The Crossroads
	}
	points[1950] = { -- "BloodmystIsle"
		[55826789] = "11809:H",	-- Blood Watch
	}
	points[1439] = { -- "Darkshore"
		[37104604] = "11811:H",	-- Lor'danel
	}
	points[1443] = { -- "Desolace"
		[26137690] = "11769:D",	-- Silverprey Village
		[65861688] = "11812:H",	-- Nijel's Point
	}
	points[1411] = { -- "Durotar"
		[52254739] = "11770:D",	-- Razor Hill
	}
	points[1445] = { -- "Dustwallow"
		[33433092] = "11771:D",	-- Brackenwall Village
		[62064047] = "11815:H",	-- Theramore Isle
	}
	points[1444] = { -- "Feralas"
		[28244390] = "11817:H",	-- Feathermoon Stronghold
		[72384780] = "11773:D",	-- Camp Mojache
	}
	points[1412] = { -- "Mulgore"
		[35042393] = "9325:C",	-- Stealing Thunder Bluff's Flame
		[51825924] = "11777:D",	-- Bloodhoof Village
	}
	points[1454] = { -- "Orgrimmar"
		[46113733] = "9324:C",	-- Stealing Orgrimmar's Flame
	}
	points[1451] = { -- "Silithus"
		[46444465] = "11800:D",	-- Cenarion Hold (south)
		[57613506] = "11831:H",	-- Cenarion Hold (east)
	}
	points[1442] = { -- "StonetalonMountains"
		[50516041] = "11780:D",	-- Sun Rock Retreat
	}
	points[1446] = { -- "Tanaris"
		[49852702] = "11802:D",	-- Gadgetzan (west)
		[52752927] = "11833:H",	-- Gadgetzan (east)
	}
	points[1438] = { -- "Teldrassil"
		[54976042] = "11824:H",	-- Dolanaar
	}
	points[1456] = { -- "ThunderBluff"
		[21282706] = "9325:C",	-- Stealing Thunder Bluff's Flame
	}
	points[1441] = { -- "Thousand Needles"
		[42375295] = "11785:D", -- Freewind post
	}
	points[1452] = { -- "Winterspring"
		[59853554] = "11803:D",	-- Everlook (west)
		[62623541] = "11834:H",	-- Everlook (east)
	}
	
	-------------
	-- Outland --
	-------------
	points[1949] = { -- "BladesEdgeMountains"
		[41576590] = "11807:H",	-- Sylvanaar
		[50045902] = "11767:D",	-- Thunderlord Stronghold
	}
	points[1944] = { -- "Hellfire"
		[57194175] = "11775:D",	-- Thrallmar
		[62175829] = "11818:H",	-- Honour Hold
	}
	points[1951] = { -- "Nagrand"
		[49616946] = "11821:H",	-- Telaar
		[51103396] = "11778:D",	-- Garadar
	}
	points[1953] = {
		[31216266] = "11830:H",	-- Area 52 (north-west)
		[32306833] = "11799:D",	-- Area 52 (south)
	}
	points[1948] = { -- "ShadowmoonValley"
		[33533028] = "11779:D",	-- Shadowmoon Village
		[39625464] = "11823:H",	-- Wildhammer Stronghold
	}
	points[1952] = {
		[51934324] = "11782:D",	-- Stonebreaker Hold
		[54065552] = "11825:H",	-- Allerian Stronghold
	}
	points[1946] = { -- "Zangarmarsh"
		[35585182] = "11787:D",	-- Zabra'jin
		[68795195] = "11829:H",	-- Telredor
	}
	
	---------------
	-- Northrend --
	---------------
	points[114] = { -- "BoreanTundra"
		[51031186] = "13441:D",	-- Bor'gorok Outpost
		[55101995] = "13485:H",	-- Fizzcrank Airstrip
	}
	points[127] = { -- "CrystalsongForest"
		[78197495] = "13491:H",	-- Windrunner's Overlook
		[80435263] = "13457:D",	-- Sunreaver's Command
	}
	points[115] = { -- "Dragonblight"
		[38524824] = "13451:D",	-- Agmar's Hammer
		[75294380] = "13487:H",	-- Wintergarde Keep
	}
	points[116] = { -- "GrizzlyHills"
		[19086149] = "13454:D",	-- Conquest Hold
		[33906045] = "13489:H",	-- Amberpine Lodge
	}
	points[117] = { -- "HowlingFjord"
		[48371337] = "13453:D",	-- Camp Winterhoof
		[57811611] = "13488:H",	-- Fort Wildervar
	}
	points[119] = { -- "SholazarBasin"
		[47366158] = "13450:D",	-- River's Heart (north)
		[48096636] = "13486:H",	-- River's Heart (south)
	}
	points[120] = { -- "TheStormPeaks"
		[40338558] = "13455:D",	-- K3 (west)
		[41448669] = "13490:H",	-- K3 (east)
	}
	points[121] = {
		[43307127] = "13458:D",	-- The Argent Stand (south-east)
		[40386130] = "13492:H",	-- The Argent Stand (north)
	}
elseif (SummerFestival.isCata) then --This needs updating with cata data.
	----------------------
	-- Eastern Kingdoms --
	----------------------
	points[1417] = { -- "Arathi"
		[44304603] = "11804:H",	-- Refuge Pointe
		[69084286] = "11764:D",	-- Hammerfall
	}
	points[1418] = { -- "Badlands"
		[19005618] = "28925:H",	-- Dragon's Mouth
		[24113722] = "11766:D",	-- New Kargath
	}
	points[1419] = { -- "BlastedLands"
		[46361426] = "28917:D",	-- Dreadmaul Hold
		[55531488] = "11808:H",	-- Nethergarde Keep
	}
	points[1428] = { -- "BurningSteppes"
		[51532918] = "11768:D",	-- Flame Crest
		[68346064] = "11810:H",	-- Morgan's Vigil
	}
	points[1426] = { -- "DunMorogh"
		[46594666] = "11813:H",	-- Kharanos
	}
	points[1431] = { -- "Duskwood"
		[73215502] = "11814:H",	-- Darkshire
	}
	points[1429] = { -- "Elwynn"
		[43086285] = "11816:H",	-- Goldshire
	}
	points[1941] = { -- "EversongWoods"
		[55823765] = "11935:C",	-- Stealing Silvermoon's Flame
		[46415060] = "11772:D",	-- Falconwing Square
	}
	points[1942] = { -- "Ghostlands"
		[46892633] = "11774:D",	-- Tranquillien
	}
	points[1424] = { -- "HillsbradFoothills"
		[54655009] = "11776:D",	-- Tarren Mill
	}
	points[1425] = { -- "Hinterlands"
		[14514987] = "11826:H",	-- Aerie Peak
		[76627497] = "11784:D",	-- Revantusk Village
	}
	points[1432] = { -- "LochModan"
		[32314009] = "11820:H",	-- Thelsamar
	}
	points[1433] = { -- "Redridge"
		[24485388] = "11822:H",	-- Lakeshire
	}
	points[1954] = { -- "SilvermoonCity"
		[68984318] = "11935:C",	-- Stealing Silvermoon's Flame
	}
	points[1421] = { -- "Silverpine"
		[49633820] = "11580:D",	-- The Sepulcher
	}
	points[1434] = { -- "StranglethornJungle"
		[40725184] = "28911:D",	-- Grom'gol Base Camp
		[52056356] = "28922:H",	-- Fort Livingston
	}
	points[1435] = { -- "SwampOfSorrows" --Doesn't exist in pre-cataclysm.
		[76771417] = "11781:D",	-- Bogpaddle (west)
		[70241573] = "28929:H",	-- Bogpaddle (east)
	}
	points[210] = { -- "TheCapeOfStranglethorn"
		[50417037] = "11801:D",	-- Wild Shore (south)
		[51796726] = "11832:H",	-- Wild Shore (north)
	}
	points[1420] = { -- "Tirisfal"
		[57235177] = "11786:D",	-- Brill
		[62336682] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[1458] = { -- "Undercity"
		[68420836] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[1422] = { -- "WesternPlaguelands"
		[29085647] = "28918:D",	-- The Bulwark
		[43568258] = "11827:H",	-- Chillwind Camp
	}
	points[1436] = { -- "Westfall"
		[44776206] = "11583:H",	-- Moonbrook
	}
	points[1437] = { -- "Wetlands"
		[13284724] = "11828:H",	-- Menethil Harbour
	}
	
	--------------
	-- Kalimdor --
	--------------
	points[1440] = { -- "Ashenvale"
		[51346615] = "11765:D",	-- Silverwind Refuge
		[86744146] = "11805:H",	-- Forest Song
	}
	points[1447] = { -- "Aszhara"
		[60415349] = "28919:D",	-- Bilgewater Harbour
	}
	points[1943] = { -- "AzuremystIsle"
		[44485251] = "11806:H",	-- Azure Watch
	}
	points[1413] = { -- "Barrens"
		[50015461] = "11783:D",	-- The Crossroads
	}
	points[1950] = { -- "BloodmystIsle"
		[55826789] = "11809:H",	-- Blood Watch
	}
	points[1439] = { -- "Darkshore"
		[48962257] = "11811:H",	-- Lor'danel
	}
	points[1443] = { -- "Desolace"
		[26137690] = "11769:D",	-- Silverprey Village
		[65861688] = "11812:H",	-- Nijel's Point
	}
	points[1411] = { -- "Durotar"
		[52254739] = "11770:D",	-- Razor Hill
	}
	points[1445] = { -- "Dustwallow"
		[33433092] = "11771:D",	-- Brackenwall Village
		[62064047] = "11815:H",	-- Theramore Isle
	}
	points[1444] = { -- "Feralas"
		[46674366] = "11817:H",	-- Feathermoon Stronghold
		[72384780] = "11773:D",	-- Camp Mojache
	}
	points[1412] = { -- "Mulgore"
		[35042393] = "9325:C",	-- Stealing Thunder Bluff's Flame
		[51825924] = "11777:D",	-- Bloodhoof Village
	}
	points[1454] = { -- "Orgrimmar"
		[46113733] = "9324:C"	-- Stealing Orgrimmar's Flame
	}
	points[1451] = { -- "Silithus"
		[50794124] = "11800:D",	-- Cenarion Hold (south)
		[60413303] = "11831:H",	-- Cenarion Hold (east)
	}
	points[199] = { -- "SouthernBarrens"
		[48337223] = "28926:H",	-- Fort Triumph
		[40676730] = "28914:D",	-- Desolation Point
	}
	points[1442] = { -- "StonetalonMountains"
		[49545110] = "28928:H",	-- Mirkfallon Lake
		[52926246] = "11780:D",	-- Sun Rock Retreat
	}
	points[1446] = { -- "Tanaris"
		[49792790] = "11802:D",	-- Gadgetzan (west)
		[52693017] = "11833:H",	-- Gadgetzan (east)
	}
	points[1438] = { -- "Teldrassil"
		[54765269] = "11824:H",	-- Dolanaar
	}
	points[1456] = { -- "ThunderBluff"
		[21282706] = "9325:C",	-- Stealing Thunder Bluff's Flame
	}
	points[1449] = { -- "UngoroCrater"
		[56326636] = "28920:D",	-- Marshal's Stand (west)
		[59866284] = "28932:H",	-- Marshal's Stand (east)
	}
	points[1452] = { -- "Winterspring"
		[58154751] = "11803:D",	-- Everlook (west)
		[61384710] = "11834:H",	-- Everlook (east)
	}
	
	-------------
	-- Outland --
	-------------
	points[1949] = { -- "BladesEdgeMountains"
		[41576590] = "11807:H",	-- Sylvanaar
		[50045902] = "11767:D",	-- Thunderlord Stronghold
	}
	points[1944] = { -- "Hellfire"
		[57194175] = "11775:D",	-- Thrallmar
		[62175829] = "11818:H",	-- Honour Hold
	}
	points[1951] = { -- "Nagrand"
		[49616946] = "11821:H",	-- Telaar
		[51103396] = "11778:D",	-- Garadar
	}
	points[1953] = {
		[31216266] = "11830:H",	-- Area 52 (north-west)
		[32306833] = "11799:D",	-- Area 52 (south)
	}
	points[1948] = { -- "ShadowmoonValley"
		[33533028] = "11779:D",	-- Shadowmoon Village
		[39625464] = "11823:H",	-- Wildhammer Stronghold
	}
	points[1952] = {
		[51934324] = "11782:D",	-- Stonebreaker Hold
		[54065552] = "11825:H",	-- Allerian Stronghold
	}
	points[1946] = { -- "Zangarmarsh"
		[35585182] = "11787:D",	-- Zabra'jin
		[68795195] = "11829:H",	-- Telredor
	}
	
	---------------
	-- Northrend --
	---------------
	points[114] = { -- "BoreanTundra"
		[51031186] = "13441:D",	-- Bor'gorok Outpost
		[55101995] = "13485:H",	-- Fizzcrank Airstrip
	}
	points[127] = { -- "CrystalsongForest"
		[78197495] = "13491:H",	-- Windrunner's Overlook
		[80435263] = "13457:D",	-- Sunreaver's Command
	}
	points[115] = { -- "Dragonblight"
		[38524824] = "13451:D",	-- Agmar's Hammer
		[75294380] = "13487:H",	-- Wintergarde Keep
	}
	points[116] = { -- "GrizzlyHills"
		[19086149] = "13454:D",	-- Conquest Hold
		[33906045] = "13489:H",	-- Amberpine Lodge
	}
	points[117] = { -- "HowlingFjord"
		[48371337] = "13453:D",	-- Camp Winterhoof
		[57811611] = "13488:H",	-- Fort Wildervar
	}
	points[119] = { -- "SholazarBasin"
		[47366158] = "13450:D",	-- River's Heart (north)
		[48096636] = "13486:H",	-- River's Heart (south)
	}
	points[120] = { -- "TheStormPeaks"
		[40338558] = "13455:D",	-- K3 (west)
		[41448669] = "13490:H",	-- K3 (east)
	}
	points[121] = {
		[43307127] = "13458:D",	-- The Argent Stand (south-east)
		[40386130] = "13492:H",	-- The Argent Stand (north)
	}
	
	---------------
	-- Cataclysm --
	---------------
	points[207] = { -- "Deepholm"
		[49405132] = "29036:H",	-- Temple of Earth
	}
	points[198] = { -- "Hyjal"
		[62832271] = "29030:H",	-- Nordrassil
	}
	points[241] = { -- "TwilightHighlands"
		[47262896] = "28945:H",	-- Thundermar
		[53284644] = "28944:D",	-- Bloodgulch
	}
	points[249] = { -- "Uldum"
		[53603184] = "28950:H",	-- Ramkahen (north)
		[52953461] = "28948:D",	-- Ramkahen (south)
	}
	points[205] = { -- "VashjirRuins"
		[49354199] = "29031:H",	-- Silver Tide Hollow
	}
	points[205] = { -- "VashjirZoneMap"
		[63805150] = "29031:H",	-- Silver Tide Hollow
	}
else
	----------------------
	-- Eastern Kingdoms --
	----------------------
	points[14] = { -- "Arathi"
		[44304603] = "11804:H",	-- Refuge Pointe
		[69084286] = "11764:D",	-- Hammerfall
	}
	points[15] = { -- "Badlands"
		[19005618] = "28925:H",	-- Dragon's Mouth
		[24113722] = "11766:D",	-- New Kargath
	}
	points[17] = { -- "BlastedLands"
		[46361426] = "28917:D",	-- Dreadmaul Hold
		[55531488] = "11808:H",	-- Nethergarde Keep
	}
	points[36] = { -- "BurningSteppes"
		[51532918] = "11768:D",	-- Flame Crest
		[68346064] = "11810:H",	-- Morgan's Vigil
	}
	points[27] = { -- "DunMorogh"
		[53744477] = "11813:H",	-- Kharanos
	}
	points[47] = { -- "Duskwood"
		[73695462] = "11814:H",	-- Darkshire
	}
	points[37] = { -- "Elwynn"
		[43476263] = "11816:H",	-- Goldshire
	}
	points[94] = { -- "EversongWoods"
		[55823765] = "11935:C",	-- Stealing Silvermoon's Flame
		[46355039] = "11772:D",	-- Falconwing Square
	}
	points[95] = { -- "Ghostlands"
		[47052593] = "11774:D",	-- Tranquillien
	}
	points[25] = { -- "HillsbradFoothills"
		[54504989] = "11776:D",	-- Tarren Mill
	}
	points[26] = { -- "Hinterlands"
		[14345007] = "11826:H",	-- Aerie Peak
		[76637455] = "11784:D",	-- Revantusk Village
	}
	points[48] = { -- "LochModan"
		[32554095] = "11820:H",	-- Thelsamar
	}
	points[49] = { -- "Redridge"
		[24905338] = "11822:H",	-- Lakeshire
	}
	points[110] = { -- "SilvermoonCity"
		[68984318] = "11935:C",	-- Stealing Silvermoon's Flame
	}
	points[21] = { -- "Silverpine"
		[49623866] = "11580:D",	-- The Sepulcher
	}
	points[50] = { -- "StranglethornJungle"
		[40725184] = "28911:D",	-- Grom'gol Base Camp
		[52056356] = "28922:H",	-- Fort Livingston
	}
	points[51] = { -- "SwampOfSorrows"
		[76771417] = "11781:D",	-- Bogpaddle (west)
		[70241573] = "28929:H",	-- Bogpaddle (east)
	}
	points[210] = { -- "TheCapeOfStranglethorn"
		[50547069] = "11801:D",	-- Wild Shore (south)
		[51976764] = "11832:H",	-- Wild Shore (north)
	}
	points[18] = { -- "Tirisfal"
		[56985176] = "11786:D",	-- Brill
		[62336682] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[90] = { -- "Undercity"
		[68420836] = "9326:C",	-- Stealing the Undercity's Flame
	}
	points[22] = { -- "WesternPlaguelands"
		[29085647] = "28918:D",	-- The Bulwark
		[43478233] = "11827:H",	-- Chillwind Camp
	}
	points[52] = { -- "Westfall"
		[44776206] = "11583:H",	-- Moonbrook
	}
	points[56] = { -- "Wetlands"
		[13464706] = "11828:H",	-- Menethil Harbour
	}
	
	--------------
	-- Kalimdor --
	--------------
	points[63] = { -- "Ashenvale"
		[51606675] = "11765:D",	-- Silverwind Refuge
		[86944186] = "11805:H",	-- Forest Song
	}
	points[76] = { -- "Aszhara"
		[60415349] = "28919:D",	-- Bilgewater Harbour
	}
	points[97] = { -- "AzuremystIsle"
		[44485251] = "11806:H",	-- Azure Watch
	}
	points[10] = { -- "Barrens"
		[49835434] = "11783:D",	-- The Crossroads
	}
	points[106] = { -- "BloodmystIsle"
		[55826789] = "11809:H",	-- Blood Watch
	}
	points[62] = { -- "Darkshore"
		[48732265] = "11811:H",	-- Lor'danel
	}
	points[66] = { -- "Desolace"
		[26217729] = "11769:D",	-- Silverprey Village
		[66121709] = "11812:H",	-- Nijel's Point
	}
	points[1] = { -- "Durotar"
		[51984719] = "11770:D",	-- Razor Hill
	}
	points[70] = { -- "Dustwallow"
		[33233077] = "11771:D",	-- Brackenwall Village
		[61824046] = "11815:H",	-- Theramore Isle
	}
	points[69] = { -- "Feralas"
		[46824370] = "11817:H",	-- Feathermoon Stronghold
		[72424757] = "11773:D",	-- Camp Mojache
	}
	points[7] = { -- "Mulgore"
		[35042393] = "9325:C",	-- Stealing Thunder Bluff's Flame
		[51985943] = "11777:D",	-- Bloodhoof Village
	}
	points[85] = { -- "Orgrimmar"
		[46113733] = "9324:C",	-- Stealing Orgrimmar's Flame
	}
	points[81] = { -- "Silithus"
		[50844177] = "11800:D",	-- Cenarion Hold (south)
		[60313351] = "11831:H",	-- Cenarion Hold (east)
	}
	points[199] = { -- "SouthernBarrens"
		[48337223] = "28926:H",	-- Fort Triumph
		[40676730] = "28914:D",	-- Desolation Point
	}
	points[65] = { -- "StonetalonMountains"
		[49305133] = "28928:H",	-- Mirkfallon Lake
		[52976227] = "11780:D",	-- Sun Rock Retreat
	}
	points[71] = { -- "Tanaris"
		[49842817] = "11802:D",	-- Gadgetzan (west)
		[52643026] = "11833:H",	-- Gadgetzan (east)
	}
	points[57] = { -- "Teldrassil"
		[54885277] = "11824:H",	-- Dolanaar
	}
	points[88] = { -- "ThunderBluff"
		[21282706] = "9325:C",	-- Stealing Thunder Bluff's Flame
	}
	points[78] = { -- "UngoroCrater"
		[56446581] = "28920:D",	-- Marshal's Stand (west)
		[59856324] = "28932:H",	-- Marshal's Stand (east)
	}
	points[83] = { -- "Winterspring"
		[58124719] = "11803:D",	-- Everlook (west)
		[61244725] = "11834:H",	-- Everlook (east)
	}
	
	-------------
	-- Outland --
	-------------
	points[105] = { -- "BladesEdgeMountains"
		[41576590] = "11807:H",	-- Sylvanaar
		[50045902] = "11767:D",	-- Thunderlord Stronghold
	}
	points[100] = { -- "Hellfire"
		[57194175] = "11775:D",	-- Thrallmar
		[62175829] = "11818:H",	-- Honour Hold
	}
	points[107] = { -- "Nagrand"
		[49616946] = "11821:H",	-- Telaar
		[51103396] = "11778:D",	-- Garadar
	}
	
	points[109] = {
		[31216266] = "11830:H",	-- Area 52 (north-west)
		[32306833] = "11799:D",	-- Area 52 (south)
	}
	points[104] = { -- "ShadowmoonValley"
		[33533028] = "11779:D",	-- Shadowmoon Village
		[39625464] = "11823:H",	-- Wildhammer Stronghold
	}
	points[108] = {
		[51934324] = "11782:D",	-- Stonebreaker Hold
		[54065552] = "11825:H",	-- Allerian Stronghold
	}
	points[102] = { -- "Zangarmarsh"
		[35585182] = "11787:D",	-- Zabra'jin
		[68795195] = "11829:H",	-- Telredor
	}
	
	---------------
	-- Northrend --
	---------------
	points[114] = { -- "BoreanTundra"
		[51031186] = "13441:D",	-- Bor'gorok Outpost
		[55101995] = "13485:H",	-- Fizzcrank Airstrip
	}
	points[127] = { -- "CrystalsongForest"
		[78197495] = "13491:H",	-- Windrunner's Overlook
		[80435263] = "13457:D",	-- Sunreaver's Command
	}
	points[115] = { -- "Dragonblight"
		[38524824] = "13451:D",	-- Agmar's Hammer
		[75294380] = "13487:H",	-- Wintergarde Keep
	}
	points[116] = { -- "GrizzlyHills"
		[19086149] = "13454:D",	-- Conquest Hold
		[33906045] = "13489:H",	-- Amberpine Lodge
	}
	points[117] = { -- "HowlingFjord"
		[48371337] = "13453:D",	-- Camp Winterhoof
		[57811611] = "13488:H",	-- Fort Wildervar
	}
	points[119] = { -- "SholazarBasin"
		[47366158] = "13450:D",	-- River's Heart (north)
		[48096636] = "13486:H",	-- River's Heart (south)
	}
	points[120] = { -- "TheStormPeaks"
		[40338558] = "13455:D",	-- K3 (west)
		[41448669] = "13490:H",	-- K3 (east)
	}
	points[121] = {
		[43307127] = "13458:D",	-- The Argent Stand (south-east)
		[40386130] = "13492:H",	-- The Argent Stand (north)
	}
	
	---------------
	-- Cataclysm --
	---------------
	points[207] = { -- "Deepholm"
		[49405132] = "29036:H",	-- Temple of Earth
	}
	points[198] = { -- "Hyjal"
		[62832271] = "29030:H",	-- Nordrassil
	}
	points[241] = { -- "TwilightHighlands"
		[47262896] = "28945:H",	-- Thundermar
		[53284644] = "28944:D",	-- Bloodgulch
	}
	points[249] = { -- "Uldum"
		[53603184] = "28950:H",	-- Ramkahen (north)
		[52953461] = "28948:D",	-- Ramkahen (south)
	}
	points[205] = { -- "VashjirRuins"
		[49354199] = "29031:H",	-- Silver Tide Hollow
	}
	points[205] = { -- "VashjirZoneMap"
		[63805150] = "29031:H",	-- Silver Tide Hollow
	}
	
	--------------
	-- Pandaria --
	--------------
	points[422] = { -- "DreadWastes"
		[56076958] = "32497:H",	-- Soggy's Gamble
	}
	points[418] = { -- "Krasarang"
		[77750354] = "32499:H",	-- Zhu's Watch
	}
	points[379] = { -- "KunLaiSummit"
		[71159087] = "32500:H",	-- Binan Village
	}
	points[371] = { -- "TheJadeForest
		[47184719] = "32498:H",	-- Dawn's Blossom
	}
	points[388] = { -- "TownlongWastes"
		[71525629] = "32501:H",	-- Longying Outpost
	}
	points[390] = { -- "ValeofEternalBlossoms"
		[77763400] = "32496:D",	-- Shrine of Two Moons
		[79673727] = "32510:H",	-- Shrine of Seven Stars
	}
	points[376] = { -- "ValleyoftheFourWinds"
		[51825133] = "32502:H",	-- Halfhill
	}
	
	-------------
	-- Draenor --
	-------------
	points[539] = { -- "ShadowmoonValleyDR"
		[42623595] = "44579:H", -- Embaari Village
	}
	points[525] = { -- "FrostfireRidge"
		[72566501] = "44583:D", -- Grom'gar
	}
	points[543] = { -- "Gorgrond"
		[43939374] = "44573:H", -- Iron Pass
	}
	points[535] = { -- "Talador"
		[43507173] = "44571:H", -- Auchindoun
	}
	points[542] = { -- "SpiresOfArak"
		[47984466] = "44570:H", -- Veil Terokk
	}
	points[550] = { -- "NagrandDraenor"
		[80504770] = "44572:H", -- The Ring of Trials
	}
	
	------------------
	-- Broken Isles --
	------------------
	points[630] = { -- "Azsuna"
		[48282966] = "44574:H", -- Llothien Highlands
	}
	points[650] = { -- "Highmountain"
		[55538447] = "44576:H", -- Ironhorn Bluffs
	}
	points[634] = { -- "Stormheim"
		[32514214] = "44577:H", -- Weeping Bluffs
	}
	points[641] = { -- "Valsharah"
		[44875789] = "44575:H", -- Howling Dale
	}
	points[680] = { -- "Suramar"
		[30404540] = "44627:D", -- Ambervale
		[22855830] = "44613:H", -- Felsoul Hold
	}
	
	--------------
	-- Zandalar --
	--------------
	points[862] = { -- "Zuldazar"
		[53314811] = "54744:D", -- Village in the Vines
	}
	points[863] = { -- "Nazmir"
		[40047429] = "54746:D", -- Zul'jan Ruins
	}
	points[864] = { -- "Vol'dun"
		[56004775] = "54749:D", -- Vulpera Hideaway
	}
	
	---------------
	-- Kul Tiras --
	---------------
	points[895] = { -- "Tiragarde Sound"
		[76344987] = "54737:H", -- Bridgeport
	}
	points[896] = { -- "Drustvar"
		[40214758] = "54743:H", -- Arom's Stand
	}
	points[942] = { -- "Stormsong Valley"
		[35865134] = "54741:H", -- Fort Daelin
	}
	
	-----------------
	-- Shadowlands --
	-----------------
	
	--None added during shadowlands?
	
	------------------
	-- Dragonflight --
	------------------
	points[2022] = { --The Waking Shores
		[45948285] = "75398:H",
	}
	points[2023] = { --Ohn'ahran Plains
		[63903497] = "75617:H",
	}
	points[2024] = { --The Azure Span
		[12194752] = "75640:H",
	}
	points[2133] = { --Zaralek Cavern
		[55185543] = "75650:H",
	}
	points[2151] = { --The Forbidden Reach
		[34916096] = "75647:H",
	}
	points[2112] = {
		[53546214] = "75645:H",
	}
end