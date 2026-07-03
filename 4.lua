-- ============================================
-- KONG MOD + SRC HUB - COMPLETE INTEGRATION
-- STABLE, NO CONFLICT, 100% WORKING
-- ============================================

-- ============================================
-- GLOBALS
-- ============================================
_G.KONG_WARNING = "KONG_ANTI_REVERSE_ENGINEERING_FUCK_YOU"
_G.WeaponSkinMap = _G.WeaponSkinMap or {}
_G.VehicleSkinMap = _G.VehicleSkinMap or {}
_G.OutfitMap = _G.OutfitMap or {}
_G.SkinLoadedCache = _G.SkinLoadedCache or {}
_G.KillData = _G.KillData or { kills = {} }
_G.DeadBoxSkins = _G.DeadBoxSkins or {}
_G.AlreadyChangedSet = _G.AlreadyChangedSet or {}
_G.CurrentEquipVehicleID = _G.CurrentEquipVehicleID or 0
_G.WelcomeShown = false
_G.BypassInstalled = false
_G.AppliedOutfitSlots = {}

local BASE_PATH = "/storage/emulated/0/Android/data/com.pubg.imobile/files/"
local CONFIG_PATH = BASE_PATH .. "config.ini"
local SAVE_KILL_PATH = BASE_PATH .. "kill_counts.txt"

-- ============================================
-- UTILITIES
-- ============================================
if not table.contains then
    function table.contains(t, e)
        for _, v in ipairs(t) do if v == e then return true end end
        return false
    end
end

local function locationsClose(l1, l2, tol)
    local dx = l1.X - l2.X
    local dy = l1.Y - l2.Y
    local dz = l1.Z - l2.Z
    return dx*dx + dy*dy + dz*dz < tol*tol
end

-- ============================================
-- KILL TRACKING (SAVE/LOAD)
-- ============================================
local function SaveKills()
    local file = io.open(SAVE_KILL_PATH, "w")
    if file then
        for id, c in pairs(_G.KillData.kills) do file:write(id..":"..c.."\n") end
        file:close()
    end
end

_G.getKills = function(weaponID)
    local kills = _G.KillData.kills[weaponID] or 0
    return kills
end

_G.AddVenusKill = function(weaponID)
    if weaponID then
        _G.KillData.kills[weaponID] = (_G.KillData.kills[weaponID] or 0) + 1
        pcall(SaveKills)
    end
end

pcall(function()
    local f = io.open(SAVE_KILL_PATH, "r")
    if f then
        for l in f:lines() do
            local id, c = l:match("(%d+):(%d+)")
            if id then _G.KillData.kills[tonumber(id)] = tonumber(c) end
        end
        f:close()
    end
end)

-- ============================================
-- DOWNLOAD HELPER
-- ============================================
local function DownloadODPAKFile(itemID)
    if not itemID then return end
    pcall(function()
        local pufferManager = require("client.slua.logic.download.puffer.puffer_manager")
        local pufferConstants = require("client.slua.logic.download.puffer_const")
        local downloadState = pufferManager.GetState(pufferConstants.ENUM_DownloadType.ODPAK, { itemID })
        if downloadState ~= pufferConstants.ENUM_DownloadState.Done then
            pufferManager.Download(pufferConstants.ENUM_DownloadType.ODPAK, { itemID })
        end
    end)
end

-- ============================================
-- CONFIG READER
-- ============================================
local function ReadConfig()
    local f = io.open(CONFIG_PATH, "r")
    if not f then return end
    for l in f:read("*all"):gmatch("[^\r\n]+") do
        local k, v = l:match("^([^#=]+)=(.+)$")
        if k and v then
            k = k:gsub("^%s+", ""):gsub("%s+$", "")
            local val = tonumber(v)
            if val then
                if k == "Suit" then _G.OutfitMap.Suit = val
                elseif k == "Bag" then _G.OutfitMap.Bag = val
                elseif k == "Helmet" then _G.OutfitMap.Helmet = val
                elseif k == "Pet" then _G.OutfitMap.Pet = val
                elseif k == "M416" then _G.WeaponSkinMap[101004] = val
                elseif k == "AKM" then _G.WeaponSkinMap[101001] = val
                elseif k == "SCAR" then _G.WeaponSkinMap[101003] = val
                elseif k == "M762" then _G.WeaponSkinMap[101008] = val
                elseif k == "AUG" then _G.WeaponSkinMap[101006] = val
                elseif k == "UMP" then _G.WeaponSkinMap[102002] = val
                elseif k == "Kar98" then _G.WeaponSkinMap[103001] = val
                elseif k == "M24" then _G.WeaponSkinMap[103002] = val
                elseif k == "AWM" then _G.WeaponSkinMap[103003] = val
                elseif k:match("^Vehicle_") then
                    local baseId = tonumber(k:match("_(%d+)$")) or 0
                    if baseId > 0 then _G.VehicleSkinMap[baseId] = val end
                end
            end
        end
    end
    f:close()
end

_G.ReadLiveConfig = ReadConfig

-- ============================================
-- TABLE TO OVERRIDE
-- ============================================
local TablesToOverride = {
    Item = true,
    BPMappingTable = true,
    HallThemeItem = true,
    AvatarWeaponHitFXData = true,
    WeaponSkinVoiceCfg = true,
    AvatarSuitsTable = true,
    GoldenSuitUpgradeCfg = true,
    GoldenSuitUpgradeCfgIN = true,
    GoldenSuitUpgradeCfgKJ = true,
    IdleCollect = true,
    IdleCollectNew = true,
    GoldClothBattleEffect = true,
    WeaponAvatarBattleEffect = true,
    NicknameColorCfg = true,
    AliasCfg = true
}

-- ============================================
-- ITEM ID MAPPING (KONG)
-- ============================================
local ItemIdMapping = {
    -- Basic Vehicles Skins Like bus etc
    [1905001] = 1905006,
    [1904008] = 1961043,
    [1904009] = 1961047,
    [1905005] = 1961041,
    [1906005] = 1961045,
    [1906001] = 1906007,
    [1911001] = 1911019,
    [1988001] = 1988005,
    [1961001] = 1961057,
    
    -- Super Vehicle Skins Like Dacia MoterCycles Etc
    [1903001] = 1961152,
    [1903002] = 1903222,
    [1903003] = 1903221,
    [1903004] = 1903220,
    [1902001] = 1902030,
    [1901003] = 1901073,
    
    -- Super Vehicle Skins Like Mirado Hourse Etc
    [1915099] = 1961046,
    [1915001] = 1915009,
    [1915002] = 1915008,
    [1915003] = 1915007,
    [1915004] = 1915006,
    [1953002] = 1953004,
    [1987001] = 1987002,
    [1908001] = 1961042,
    
    -- Super Basic Vehicle Buggy Jet Etc
    [1907011] = 1907059,
    [1907001] = 1907054,
    [1907012] = 1907058,
    [1907032] = 1907072,
    [1912001] = 1912012,
    [1918001] = 1918010,
    [1953001] = 1953012,
    [1904001] = 1904018,
    [1919001] = 1919011,
    
    -- Basic Vehicle Skins Jet Monster Truck etc
    [1953001] = 1953012,
    [1953002] = 1953011,
    [1960001] = 1960003,
    [1963001] = 1963002,
    [1965001] = 1965002,
    [1981001] = 1981002,
    
    -- Cakku Dagger etc Items
    [108001] = 1108001069,
    [1080011] = 1081201,
    [108004] = 1108004027,
    [1080041] = 1108001069,
    [108005] = 1108001098,
    [1080051] = 1081203,
    
    -- Emotes Skins
    [2200101] = 12208801,
    [2200201] = 12207401,
    [2200301] = 12204601,
    [12219639] = 12215701,
    [12219640] = 12205401,
    [12219680] = 12205201,
    [12219681] = 12205601,
    [12219721] = 12206001,
    [12219722] = 12212601,
    [12220012] = 12211401,
    [12220013] = 12207901,
    [12220043] = 12213201,
    [12220044] = 12219053,
    [12220238] = 12219009,
    [12220816] = 12211801,
    [22010010] = 12216101,
    [22010028] = 12215601,
    [22010037] = 12200701,
    [12219682] = 12215530,
    [12219683] = 2200401,
    [12219723] = 12219242,
    [12219724] = 12207001,
    [12220014] = 12204001,
    [12220015] = 12219004,
    [12220500] = 12212401,
    [12220860] = 12212201,
    [2203902] = 2303007,
    [12220920] = 2203201,
    [22010048] = 12220049,
    [22010038] = 12212101,
    [22010029] = 12201301,
    [22010019] = 12203701,
    [22010011] = 12201601,
    [22010001] = 12203501,
    [12220380] = 12201001,
    [12220724] = 12209001,
    [12220631] = 12205801,
    [12220627] = 12209801,
    [12220605] = 12210001,
    [12220557] = 12210801,
    [12220491] = 12212001,
    [12220436] = 12212701,
    [12220353] = 12215512,
    [12220316] = 12219246,
    [12220276] = 12219207,
    [12220275] = 12219022,
    [12220220] = 12203401,
    [12220219] = 12201801,
    [12220173] = 12215601,
    [12220064] = 12215532,
    [12220063] = 12215529,
    [12220021] = 12203801,
    [12220020] = 12203101,
    [12219353] = 12220028,
    [12220001] = 12219465,
    [12220004] = 12219347,
    [12219692] = 2203601,
    [12220158] = 12215513,
    [12220159] = 12219059,
    [12220177] = 12219564,
    [12220178] = 12219330,
    [12220289] = 12219371,
    [12220405] = 12219631,
    [12220859] = 12219805,
    [12220575] = 12219228,
    [12220564] = 12220089,
    [4100000] = 4100005,
    
    -- Helmet Skins items
    [502001] = 1502001023,
    [502002] = 1502002023,
    [502003] = 1502003023,
    [502004] = 1502001027,
    [502005] = 1502002027,
    
    -- BackPack Skins Items
    [1502001006] = 1502001014,
    [1502002006] = 1502002014,
    [1502003006] = 1502003014,
    [1505000006] = 1505000014,
    [1501001008] = 1501001061,
    [1501002008] = 1501002061,
    [1501003008] = 1501003061,
    [1504000008] = 1501000061,
    [1501001703] = 1501001051,
    [1501002703] = 1501002051,
    [1501003703] = 1501003051,
    [1501000703] = 1501000051,
    [1504000025] = 1501000688,
    [1501001025] = 1501001688,
    [1501002025] = 1501002688,
    [1501003025] = 1501003688,
    [1501001017] = 1501001710,
    [1501002017] = 1501002710,
    [1501003017] = 1501003710,
    [1504001017] = 1501000710,
    [1504000009] = 1501000639,
    [1501001009] = 1501001639,
    [1501002009] = 1501002639,
    [1501003009] = 1501003639,
    [1504000005] = 1501000649,
    [1501001005] = 1501001649,
    [1501002005] = 1501002649,
    [1501003005] = 1501003649,
    [1502001017] = 1502001439,
    [1502002017] = 1502002439,
    [1502003017] = 1502003439,
    [1505001017] = 1502000439,
    [1502000022] = 1502000410,
    [1502001022] = 1502001410,
    [1502002022] = 1502002410,
    [1502003022] = 1502003410,
    [1505000021] = 1502000349,
    [1502001021] = 1502001349,
    [1502002021] = 1502002349,
    [1502003021] = 1502003349,
    [1502000482] = 1502000031,
    [1502001482] = 1502001031,
    [1502002482] = 1502002031,
    [1502003482] = 1502003031,
    
    -- Parachute & Outfits Etc
    [1400754] = 1401621,
    [1400753] = 1401549,
    [1400628] = 1401282,
    [1400638] = 1401287,
    [1404508] = 1406971,
    [403003] = 1407895,
    [1405659] = 1407695,
    [1400109] = 1405161,
    [1407893] = 1407459,
    [403044] = 1400569,
    [1405680] = 1407812,
    [1400038] = 1407558,
    [1400001] = 1406573,
    [403224] = 1407523,
    [403211] = 1407856,
    [1407835] = 1407276,
    [403195] = 1406977,
    [403174] = 1404133,
    [403177] = 1407286,
    [403163] = 1407471,
    [403161] = 1407160,
    [403156] = 1406482,
    [403153] = 1404000,
    [403154] = 1406574,
    [403043] = 1407682,
    [403042] = 1405801,
    [1407840] = 1405641,
    [403041] = 1407329,
    [403039] = 1403184,
    [403032] = 1406976,
    [403020] = 1407470,
    [403018] = 1407277,
    [403008] = 1406824,
    [403002] = 1406872,
    [1400357] = 1407275,
    [404006] = 1406657,
    [405020] = 1405030,
    [1405678] = 1407187,
    [1407660] = 1407106,
    [403192] = 1407391,
    [1405233] = 403000,
    [1404437] = 1407869,
    [1404471] = 1407568,
    [1404440] = 1406569,
    [1404454] = 1405229,
    [1400362] = 1405174,
    [1404195] = 1407871,
    [1404180] = 1407425,
    [1404178] = 1407285,
    [1404177] = 1407049,
    [1404156] = 1405121,
    [1404082] = 1405435,
    [1404054] = 1406140,
    [1404030] = 1407141,
    [1404008] = 1406386,
    [1404005] = 1404503,
    [1400455] = 1407224,
    [1400364] = 1407142,
    [1400356] = 1405163,
    [1400132] = 1405242,
    [1400072] = 1405375,
    [1400046] = 1407048,
    [1400043] = 1406823,
    [1404450] = 1405222,
    [1405385] = 1407079,
    [15000101] = 15000104,
    [1400097] = 1400117,
    [1406248] = 1407550,
    [1400007] = 1406891,
    [403198] = 1407103,
    [403196] = 1406638,
    [403193] = 1406656,
    [403160] = 1406759,
    [403124] = 1406439,
    [403071] = 1406244,
    [403060] = 1404049,
    [403059] = 1407667,
    [1404060] = 1406398,
    [403058] = 1405127,
    [403057] = 1407883,
    [403172] = 1407696,
    [403162] = 1407894,
    [1400112] = 1407846,
    [1400111] = 1405069,
    [1400286] = 1407440,
    [1405093] = 1407559,
    [1400549] = 1407512,
    [1400548] = 1406483,
    [1400658] = 1407848,
    [1400565] = 403212,
    [1400564] = 1406898,
    [1400100] = 1407870,
    [1400137] = 1407140,
    [1407723] = 1404207,
    [1407818] = 1400566,
    [403202] = 1407522,
    [1400047] = 1407392,
    [1407877] = 1406469,
    [1407845] = 1405160,
    [1404505] = 1407811,
    [1400003] = 1406389,
    [1400040] = 1407161,
    [403214] = 1407632,
    [1406577] = 1407219,
    [1400107] = 1407757,
    [1400227] = 1407366,
    [403030] = 403183,
    [403017] = 1407330,
    [405053] = 1406387,
    [1400004] = 1407225,
    [1407880] = 1416657,
    [1407821] = 1407726,
    [1407768] = 1407631,
    [1404452] = 1405012,
    [1407788] = 1407895,
    [1407725] = 1406744,
    [1407596] = 1406641,
    [1407549] = 1406291,
    [1407495] = 1407107,
    [1407458] = 1406742,
    [1407423] = 1406555,
    [1407359] = 1407573,
    [503101] = 1406970,
    [1400041] = 1404495,
    [404011] = 1400052,
    [404061] = 404025,
    [404032] = 1404413,
    [404074] = 1404424,
    [1400039] = 1404397,
    [404072] = 1400018,
    [404049] = 1404050,
    [404026] = 1404002,
    [404013] = 1400050,
    [1400044] = 1404449,
    [404056] = 1404134,
    [1400073] = 1400650,
    [404096] = 404024,
    [404071] = 404003,
    [1404096] = 405025,
    [405045] = 1404003,
    [405049] = 1400651,
    [405022] = 1400225,
    [1404506] = 1406437,
    [1400045] = 1404428,
    [1400048] = 1404412,
    [405015] = 1404051,
    [405006] = 1404423,
    [1400224] = 1404293,
    [405038] = 1405085,
    [1400020] = 1404151,
    [402038] = 1403711,
    [402018] = 1403275,
    [402019] = 1403274,
    [1400810] = 1403167,
    [1403763] = 1403326,
    [1403673] = 1403721,
    [1403752] = 1404170,
    [1403696] = 1404198,
    [402042] = 1410646,
    [1400551] = 1400426,
    [1400556] = 1410973,
    [1400583] = 1410299,
    [1400559] = 1410651,
    [401024] = 1402223,
    [401027] = 1402582,
    [401009] = 1410647,
    [401026] = 1410686,
    [401033] = 1400424,
    [401020] = 1402218,
    [401019] = 1410797,
    [1411075] = 1402801,
    [1410941] = 1410923,
    [1400393] = 1410533,
    [1400553] = 1404367,
    [1400554] = 1410508,
    [401023] = 1410934,
    [1410205] = 1410768,
    [401034] = 1411068,
    [402045] = 1403028,
    [402046] = 1403498,
    [402021] = 1403117,
    [402012] = 1400168,
    [1400026] = 474031,
    [1400148] = 1403044,
    [402020] = 1410356,
    [402004] = 1410724,
    [1403605] = 1404297,
    [1400622] = 1410072,
    [1403603] = 1400165,
    [1411051] = 1403182,
    [1402355] = 1410616,
    [1403237] = 1402582,
    [1402448] = 1402433,
    [1403202] = 1410592,
    [1403031] = 1404299,
    [1403033] = 1404298,
    [1403202] = 1410585,
    
    -- Pet buddy
    [50008] = 50023,
    [50009] = 50024,
    
    -- All Hiars Of Character
    [40601001] = 40601012,
    [40602001] = 40602012,
    [40603001] = 40603012,
    [40604001] = 40604012,
    [40605001] = 40605012,
    [40606001] = 40606012,
    [40601002] = 40601011,
    [40602002] = 40602011,
    [40603002] = 40603011,
    [40604002] = 40604011,
    [40605002] = 40605011,
    [40606002] = 40606011,
    [40601004] = 40601016,
    [40602004] = 40602016,
    [40603004] = 40603016,
    [40604004] = 40604016,
    [40605004] = 40605016,
    [40606004] = 40606016,
    [40601003] = 40601017,
    [40602003] = 40602017,
    [40603003] = 40603017,
    [40604003] = 40604017,
    [40605003] = 40605017,
    [40606003] = 40606017,
    [40601006] = 40601014,
    [40602006] = 40602014,
    [40603006] = 40603014,
    [40604006] = 40604014,
    [40605006] = 40605014,
    [40606006] = 40606014,
    [40601005] = 40601010,
    [40602005] = 40602010,
    [40603005] = 40603010,
    [40604005] = 40604010,
    [40605005] = 40605010,
    [40606005] = 40606010,
    
    -- HeadGairrs
    [40601007] = 1410085,
    [40601008] = 1410480,
    [40601009] = 406316,
    [40602007] = 1410567,
    [40602008] = 1410490,
    [40602009] = 1402801,
    [40603007] = 1410583,
    [40603008] = 1410467,
    [40603009] = 1410830,
    [40604007] = 1404367,
    [40604008] = 1402920,
    [40604009] = 1410154,
    [40605007] = 1404394,
    [40605008] = 1410005,
    [40605009] = 1410265,
    [40606007] = 1405623,
    [40606008] = 1407618,
    [40606009] = 1400687,
    
    -- Character Face & Uaz Skins
    [401999] = 1400563,
    [401998] = 402000,
    [401997] = 402372,
    [1910001] = 1961044,
    [1901001] = 1901070,
    
    -- Gloves
    [450001] = 452001,
    [450002] = 452002,
    [450003] = 452003,
    
    -- Other items Plan Skin Grenade Skins Backpack default
    [1801101] = 1801222,
    [612004000] = 612004195,
    [613004000] = 613004061,
    [614004000] = 614004002,
    [615004000] = 615004007,
    [181101000] = 181101030,
    [41020001] = 41020003,
    [41030001] = 41030003,
    [703001] = 703013,
    [501000] = 1501000554,
    [501001] = 1501001554,
    [501002] = 1501002554,
    [501003] = 1501003554,
    
    -- Mission and achievement items
    [2494046] = 2494239,
    [2490325] = 2494116,
    [2493002] = 2493045,
    [2493007] = 2493015,
    [2003014] = 2002952,
    [1601019] = 1601067,
    
    -- player Info cards skins
    [61010001] = 61010027,
    [61100001] = 61100023,
    [61200001] = 61200018,
    [61300001] = 61300047,
    [61400001] = 61400069,
    [61910002] = 61910001,
    [61510000] = 61510004,
    [61510000] = 61510021,
    
    -- Avatar Frame etc
    [2001001] = 2002901,
    [2002906] = 2002001,
    [2002918] = 2002002,
    [2002920] = 2002003,
    [2002914] = 2002004,
    [2010004] = 2002005,
    [30204] = 2002953,
    [202408052] = 202408087,
    [202408112] = 202408114,
    [202408116] = 202408101,
    [40040] = 30065,
    [40041] = 2000000,
    [40042] = 211280,
    [12220311] = 22100003,
    [10001] = 31403,
    [30001] = 30396,
    [30002] = 30397,
    [30003] = 35002,
    [30005] = 35003,
    [30006] = 32008,
    [30203] = 30068,
    [35000] = 31410,
    
    -- Weapon Skins
    [1101007014] = 1101007078,
    [1101006087] = 1101006051,
    [1101009022] = 1101009019,
    [1101009023] = 1101009002,
    [1101100021] = 1101100018,
    [1101004030] = 1101004236,
    [1101004034] = 1101004226,
    [1103001001] = 1103001079,
    [1103001005] = 1103001101,
    [1103001004] = 1103001129,
    [1103001035] = 1103001146,
    [1103001036] = 1103001154,
    [1103001045] = 1103001179,
    [1103001192] = 1103001191,
    [1103006068] = 1103006030,
    [1103006070] = 1103006063,
    [1102002082] = 1102002143,
    [1101001257] = 1101001256,
    [1103007033] = 1103007038,
    [1103002011] = 1103002126,
    [1103002097] = 1103002146,
    [1103008001] = 1103008020,
    [1103004082] = 1103004087,
    [1103012011] = 1103012031,
    [1101003032] = 1101003219,
    [1101003121] = 1101003099,
    [1101001019] = 1101001089,
    [1106002016] = 1106002024,
    [1101004040] = 1101004086,
    [1105010027] = 1105010008,
    [1101006086] = 1101006062,
    [1102001001] = 1102001130,
    [1101005014] = 1101005098,
    [1101006052] = 1101006085,
    [1103002071] = 1103002087,
    [1103002088] = 1103002059,
    [1103002063] = 1103002030,
    [1103002031] = 1103002106,
    [1101006021] = 1101006075,
    [1101001006] = 1101001265,
    [1101003009] = 1101003167,
    [1101003022] = 1101003146,
    [1101003018] = 1101003227,
    [1101003016] = 1101003181,
    [1101003004] = 1101003119,
    [1101004006] = 1101004046,
    [1101004015] = 1101004218,
    [1101005030] = 1101005038,
    [1101005066] = 1101005090,
    [1101006054] = 1101006061,
    [1105010020] = 1105010019,
    [1103007030] = 1103007028,
    [1103007010] = 1103007027,
    [1103003006] = 1103003087,
    [1102105001] = 1102105012,
    [1102105020] = 1102105028,
    [1101008156] = 1101008154,
    [1101003033] = 1101003134,
    [1101007003] = 1101007046,
    [1101007019] = 1101007071,
    [1102002021] = 1102002136,
    [1102002003] = 1102002424,
    [1103004072] = 1103004037,
    [1108001013] = 1108001069,
    [1108004094] = 1108004283,
    [1108004023] = 1108004008,
    [1108004025] = 1108004417,
    
    -- Main Weapons
    [101001] = 1101001276,
    [101002] = 1101002056,
    [101003] = 1101003195,
    [101004] = 1101004062,
    [101005] = 1101005097,
    [101006] = 1101006084,
    [101007] = 1101007070,
    [101008] = 1101008163,
    [101009] = 1101009012,
    [101010] = 1101010023,
    [101012] = 1101012033,
    [101100] = 1101100012,
    [101102] = 1101102049,
    
    -- Secondary Weapons
    [102001] = 1102001120,
    [102002] = 1102002135,
    [102003] = 1102003080,
    [102004] = 1102004018,
    [102005] = 1102005064,
    [102008] = 1102105018,
    [102105] = 1102105027,
    
    -- Armor and Equipment
    [103001] = 1103001202,
    [103002] = 1103002156,
    [103003] = 1103003042,
    [103004] = 1103004036,
    [103005] = 1103005024,
    [103006] = 1103006075,
    [103007] = 1103007026,
    [103008] = 1103008014,
    [103009] = 1103009022,
    [103011] = 1103001200,
    [103012] = 1103012039,
    [103102] = 1103102007,
    [103103] = 1103001201,
    
    -- Packs and Sets
    [104001] = 1104001035,
    [104003] = 1104003037,
    [104004] = 1104004041,
    [104101] = 1104101001,
    [104102] = 1104102004,
    
    -- Firearms
    [105001] = 1105001069,
    [105002] = 1105002018,
    [105010] = 1105010019,
    
    -- Other items
    [103100] = 1103100007,
    [103010] = 1103010008,
    [102007] = 1102007019,
    [104002] = 1104002022,
    [107001] = 1107001018,
    [107098] = 1107098003,
    [107008] = 1107008001,
    [101101] = 1101101007,
    [106001] = 1106001020,
    [106003] = 1106003014,
    [106002] = 1106004002,
    [106004] = 1106004003,
    [106005] = 1106005001,
    [106006] = 1106006001,
    [106008] = 1106008013,
    
    -- More Items
    [202408117] = 202408040,
    [295007] = 1050100137,
    [2040095] = 1030070227,
    [2050035] = 1030070236,
    [2010035] = 1030070234,
    [204009] = 1030070227,
    [205003] = 1030070236,
    [201003] = 1030070234
}

-- ============================================
-- ORIGINAL GETTABLEDATA HOOK
-- ============================================
local originalGetTableData = _ENV.CDataTable.GetTableData

local function IsWeaponStartingWith110(itemID)
    if not itemID then return false end
    local idString = tostring(itemID)
    return idString:sub(1, 3) == "110"
end

function _ENV.CDataTable.GetTableData(tableName, itemID)
    local originalData = originalGetTableData(tableName, itemID)
    
    if not TablesToOverride[tableName] or not originalData or not itemID then
        return originalData
    end
    
    local newItemID = ItemIdMapping[itemID]
    
    if newItemID and newItemID ~= itemID then
        local newData = originalGetTableData(tableName, newItemID)
        if newData then
            for key, value in pairs(newData) do
                originalData[key] = value
            end
            if tableName == "Item" then
                originalData.ItemWhiteIcon = originalData.ItemBigIcon
            end
        end
    end
    
    return originalData
end

-- ============================================
-- APPLY LOCAL PLAYER SKINS (Outfit + Weapon + Vehicle)
-- ============================================
_G.ApplyLocalPlayerSkins = function(p)
    if not slua.isValid(p) then return end
    
    -- OUTFIT
    pcall(function()
        local ac = p:getAvatarComponent2()
        if slua.isValid(ac) and ac.NetAvatarData then
            local applyData = ac.NetAvatarData.SlotSyncData
            if slua.isValid(applyData) then
                for i = 0, applyData:Num() - 1 do
                    local eq = applyData:Get(i)
                    if eq then
                        local target = 0
                        if eq.SlotID == 5 and _G.OutfitMap.Suit then target = _G.OutfitMap.Suit
                        elseif eq.SlotID == 8 and _G.OutfitMap.Bag and _G.OutfitMap.Bag ~= 501001 then
                            local level = 1
                            local bu = import("BackpackUtils")
                            if bu then level = bu.GetEquipmentBagLevel(eq.AdditionalItemID) or 1 end
                            target = _G.OutfitMap.Bag + (level - 1) * 1000
                        elseif eq.SlotID == 9 and _G.OutfitMap.Helmet and _G.OutfitMap.Helmet ~= 502001 then
                            local level = 1
                            local bu = import("BackpackUtils")
                            if bu then level = bu.GetEquipmentHelmetLevel(eq.AdditionalItemID) or 1 end
                            target = _G.OutfitMap.Helmet + (level - 1) * 1000
                        end
                        if target and target ~= 0 and eq.ItemId ~= target then
                            if not _G.SkinLoadedCache[target] then
                                pcall(DownloadODPAKFile, target)
                                _G.SkinLoadedCache[target] = true
                            end
                            eq.ItemId = target
                            applyData:Set(i, eq)
                            ac:OnRep_BodySlotStateChanged()
                        end
                    end
                end
            end
        end
    end)
    
    -- WEAPON
    local wm = p.GetWeaponManager and p:GetWeaponManager() or p.WeaponManagerComponent
    if slua.isValid(wm) then
        for i = 1, 3 do
            local wpn = wm:GetInventoryWeaponByPropSlot(i)
            if slua.isValid(wpn) and slua.isValid(wpn.synData) then
                local wID = wpn:GetWeaponID()
                local target = _G.WeaponSkinMap[wID]
                if target and target ~= wID then
                    if not _G.SkinLoadedCache[target] then
                        pcall(DownloadODPAKFile, target)
                        _G.SkinLoadedCache[target] = true
                    end
                    local d = wpn.synData:Get(7)
                    if d and d.defineID then
                        d.defineID.TypeSpecificID = target
                        wpn.synData:Set(7, d)
                        if wpn.OnRep_synData then wpn:OnRep_synData() end
                        local wa = wpn.WeaponAvatarComponent_BP or wpn.WeaponAvatarComponent
                        if slua.isValid(wa) then
                            wa.WeaponSkinId = target
                            if wa.PutOnEquipmentByResID then wa:PutOnEquipmentByResID(target, {}) end
                        end
                    end
                end
            end
        end
    end
    
    -- VEHICLE
    pcall(function()
        local CV = p.CurrentVehicle
        if slua.isValid(CV) then
            local VA = CV.VehicleAvatar
            if slua.isValid(VA) then
                local defId = tostring(VA:GetDefaultAvatarID() or "")
                local vehTarget = 0
                for baseId, ts in pairs(_G.VehicleSkinMap) do
                    if defId:find(tostring(baseId)) then vehTarget = ts; break end
                end
                if vehTarget and vehTarget > 0 then
                    if not _G.SkinLoadedCache[vehTarget] then
                        pcall(DownloadODPAKFile, vehTarget)
                        _G.SkinLoadedCache[vehTarget] = true
                    end
                    VA.curSwitchEffectId = 7303001
                    VA:ChangeItemAvatar(vehTarget, true)
                    _G.CurrentEquipVehicleID = vehTarget
                end
            end
        end
    end)
    
    -- PET
    if _G.OutfitMap.Pet and _G.OutfitMap.Pet ~= 0 then
        pcall(function()
            local pc = slua_GameFrontendHUD:GetPlayerController()
            if pc and pc.PetComponent then
                pc.PetComponent.PetId = _G.OutfitMap.Pet
                pc.PetComponent:OnRep_PetId()
            end
        end)
    end
end

-- ============================================
-- DEADBOX SKIN
-- ============================================
_G.ApplyDeadBoxSkin = function()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not pc then return end
    local uc = pc:GetPlayerCharacterSafety()
    if not slua.isValid(uc) then return end
    local UGS = import("GameplayStatics")
    local UIU = require("client.common.ui_util")
    if not (UGS and UIU) then return end
    local uGI = UIU.GetGameInstance()
    if not uGI then return end
    local PTB = import("PlayerTombBox")
    if not PTB then return end
    local arr = UGS.GetAllActorsOfClass(uGI, PTB, slua.Array(UEnums.EPropertyClass.Object, import("Actor")))
    if not arr then return end
    for _, a in pairs(arr) do
        if slua.isValid(a) and a.DamageCauser and a.DamageCauser.PlayerKey == pc.PlayerKey then
            local db = a.DeadBoxAvatarComponent_BP
            if db and not table.contains(_G.AlreadyChangedSet, a) then
                local loc = a:K2_GetActorLocation()
                local found = false
                for _, e in pairs(_G.DeadBoxSkins) do
                    if locationsClose(e.location, loc, 1.0) then
                        db:ResetItemAvatar()
                        db:PreChangeItemAvatar(e.SkinID)
                        db:SyncChangeItemAvatar(e.SkinID)
                        table.insert(_G.AlreadyChangedSet, a)
                        found = true
                        break
                    end
                end
                if not found then
                    local sid = 0
                    if uc.CurrentVehicle and _G.CurrentEquipVehicleID ~= 0 then
                        sid = tostring(_G.CurrentEquipVehicleID) .. "1"
                    else
                        local cw = uc:GetCurrentWeapon()
                        if cw and cw.synData then
                            sid = slua.IndexReference(cw.synData:Get(7), "defineID").TypeSpecificID
                        end
                    end
                    db:ResetItemAvatar()
                    db:PreChangeItemAvatar(sid)
                    db:SyncChangeItemAvatar(sid)
                    table.insert(_G.DeadBoxSkins, { location = loc, SkinID = sid })
                    table.insert(_G.AlreadyChangedSet, a)
                end
            end
        end
    end
end

-- ============================================
-- KILL COUNTER UI (KONG + SRC)
-- ============================================
_G.RefreshKillCounterUI = function()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not pc then return end
    local lp = pc:GetPlayerCharacterSafety()
    if not slua.isValid(lp) then return end
    local cw = lp:GetCurrentWeapon()
    if not slua.isValid(cw) then return end
    local wID = cw:GetWeaponID()
    if not wID then return end
    local sid = _G.WeaponSkinMap[wID] or wID
    local kills = _G.getKills(wID)
    local UIM = require("client.slua_ui_framework.manager")
    local MKC = UIM.GetUI(UIM.UI_Config_InGame.MainKillCounter)
    if MKC and MKC.KillCounterItem then
        MKC:SetKillCounterItemShowWithNum(1, kills, sid)
    end
end

-- ============================================
-- KILL INFO HOOK
-- ============================================
local lastKillTime = 0
local lastKillWeaponID = nil
local lastKillTarget = nil

local function InitializeKillInfoHook()
    pcall(function()
        local KillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
        local originalFileItemFunction = KillInfo.__inner_impl.FileItem
        
        function KillInfo.__inner_impl.FileItem(self, killInfo)
            originalFileItemFunction(self, killInfo)
            
            local player = GameplayData.GetPlayerCharacter()
            if slua.isValid(player) and killInfo.Causer == player.PlayerName then
                local currentTime = os.clock()
                if currentTime - lastKillTime < 0.5 and lastKillTarget == killInfo.Target then
                    return
                end
                local weapon = player:GetCurrentWeapon()
                if weapon then
                    local weaponID = weapon:GetWeaponID()
                    if not (currentTime - lastKillTime < 0.5 and lastKillWeaponID == weaponID) then
                        _G.AddVenusKill(weaponID)
                        lastKillTime = currentTime
                        lastKillWeaponID = weaponID
                        lastKillTarget = killInfo.Target
                    end
                end
            end
        end
    end)
end

-- ============================================
-- KILL COUNTER SYSTEM UI
-- ============================================
local function InitializeKillCounterSystem()
    pcall(function()
        local MainKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainKillCounter")
        local KillCounterUISubsystem = require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        
        if MainKillCounter and MainKillCounter.__inner_impl then
            local mainKillCounterImpl = MainKillCounter.__inner_impl
            function mainKillCounterImpl.OnRefreshUI(self, ...)
                if self.KillCounterItem then
                    local displayID = _G.WeaponSkinMap[self.WeaponID] or self.WeaponID
                    self.KillCounterItem:SetKillCounterItemShowWithNum(1, _G.getKills(self.WeaponID), displayID)
                end
            end
        end
        
        if KillCounterUISubsystem and KillCounterUISubsystem.__inner_impl then
            local killCounterUIImpl = KillCounterUISubsystem.__inner_impl
            local originalUpdateUI = killCounterUIImpl.UpdateMainKillCounterUI
            
            function killCounterUIImpl.UpdateMainKillCounterUI(self, show, weaponID, displayID)
                local finalDisplayID = _G.WeaponSkinMap[weaponID] or displayID or weaponID
                originalUpdateUI(self, show, weaponID, finalDisplayID)
            end
        end
    end)
end

-- ============================================
-- VEHICLE SWITCH EFFECT
-- ============================================
pcall(function()
    local VehicleAvatarComponent = require("GameLua.GameCore.Module.Vehicle.Component.VehicleAvatarComponent")
    if VehicleAvatarComponent and VehicleAvatarComponent.__inner_impl then
        VehicleAvatarComponent.__inner_impl.CheckCanPlaySkinSwitchEffect = function(self, curVehicleId, lastVehicleId)
            return true
        end
        VehicleAvatarComponent.__inner_impl.ShowVehicleSwitchEffect = function(self)
            if not self.curSwitchEffectId or self.curSwitchEffectId <= 0 then
                self.curSwitchEffectId = 7303001
            end
            local vehicleActor = self:GetOwner()
            if not slua.isValid(vehicleActor) then return false end
            if self.uSwitchEffectActor then
                self:StopSkinSwitchEffect()
                if self.uSwitchEffectActor.K2_DestroyActor then
                    self.uSwitchEffectActor:K2_DestroyActor()
                end
                self.uSwitchEffectActor = nil
            end
            local world = slua_GameFrontendHUD:GetWorld()
            if not world then return false end
            local VehiclePlateLicenseUtil = require("GameLua.Activity.Commercialize.GamePlay.Vehicle.VehiclePlateLicenseUtil")
            local BP_DissolveVehicleClass = import(VehiclePlateLicenseUtil.GetSwitchEffectActorPath())
            if not BP_DissolveVehicleClass then return false end
            self.uSwitchEffectActor = world:SpawnActor(BP_DissolveVehicleClass, nil, nil, nil)
            if not slua.isValid(self.uSwitchEffectActor) then return false end
            self.uSwitchEffectActor:K2_AttachToActor(vehicleActor, "None", 1, 1, 1, false)
            if self.uSwitchEffectActor.StartVehicleSwitchEffect then
                self.uSwitchEffectActor:StartVehicleSwitchEffect(vehicleActor, self.curSwitchEffectId, 0, 0, false)
            end
            return true
        end
    end
end)

-- ============================================
-- WELCOME POPUP
-- ============================================
function _G.TryShowWelcome()
    if _G.WelcomeShown then return end
    pcall(function()
        local msgBox = require("client.slua.logic.common.logic_common_msg_box")
        msgBox.Show(4, "Subscribe to our channel", "Thank you for using our script. You are now obligated to subscribe to our channel.\nOur channel: TG@SRC_HUB\nWe hope you like it, thank you!", function()
            local webview = require("client.slua.logic.url.logic_webview_sdk")
            if webview then webview.OpenURL("https://t.me/XTHRLEN") end
        end)
        _G.WelcomeShown = true
    end)
end

-- ============================================
-- ANTICHEAT BYPASS (COMPLETE)
-- ============================================
local function InstallAntiCheatBypass()
    if _G.BypassInstalled then return end
    pcall(function()
        local a = require("GameLua.Mod.Library.GamePlay.Avatar.AvatarExceptionReport")
        if a and a.__inner_impl then
            a.__inner_impl.OnRecordAvatarException = function() end
            a.__inner_impl.OnPreBattleResult = function() end
        end
        
        local h = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if h and h.__inner_impl then
            h.__inner_impl.SendAntiDataFlow = function() end
            h.__inner_impl.SendHitFireBtnFlow = function() end
        end
        
        local cr = require("GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem")
        if cr and cr.__inner_impl then
            cr.__inner_impl._OnSyncFatalDamage = function() end
            cr.__inner_impl._OnPlayerKilledOtherPlayer = function() end
        end
        
        if UnrealNet and UnrealNet.FilterNetworkException then
            local of = UnrealNet.FilterNetworkException
            UnrealNet.FilterNetworkException = function(t, m)
                if m and (string.find(m, "CheatDetected") or string.find(m, "IdipBan")) then return false end
                return of(t, m)
            end
        end
        
        if NetUtil and NetUtil.SendPkg and not NetUtil._bp then
            local old = NetUtil.SendPkg
            local blocked = {
                ["on_crow_update_ntf"]=1, ["hisar"]=1, ["ReportAttackFlow"]=1,
                ["ReportHurtFlow"]=1, ["ReportFireArms"]=1, ["ReportPlayerBehavior"]=1,
                ["report_tss_sdk_anti_data"]=1,
            }
            NetUtil.SendPkg = function(n, ...)
                if blocked[n] then return end
                return old(n, ...)
            end
            NetUtil._bp = true
        end
        
        _G.BypassInstalled = true
    end)
end

-- ============================================
-- UNLOCK ALL ABILITIES
-- ============================================
local function UnlockAll()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local ch = pc:GetPawn()
    if not slua.isValid(ch) then return end
    if ch.SkillManager then
        local skills = {1014005, 1090036, 1090037, 1090040, 1090045, 1090046}
        for _, id in ipairs(skills) do
            if ch.SkillManager.AddSkill then ch.SkillManager:AddSkill(id) end
        end
    end
    local features = {ch.VampireFeature, ch.WerewolfFeature, ch.GhostFeature}
    for _, f in ipairs(features) do
        if f and f.Activate then f:Activate() end
    end
end

-- ============================================
-- WIDE VIEW (FOV)
-- ============================================
local function applyWideView()
    local ui = require("client.common.ui_util")
    local gi = ui and ui.GetGameInstance()
    if not gi then return end
    local pc = import("GameplayStatics").GetPlayerController(gi, 0)
    local lp = pc and pc.Player
    if lp and lp.AspectRatioAxisConstraint ~= 0 then
        lp.AspectRatioAxisConstraint = 0
    end
end

-- ============================================
-- WATERMARK (IngamePhoneStateUI)
-- ============================================
pcall(function()
    local IPS = require("GameLua.Mod.Library.Client.UI.IngamePhoneStateUI")
    if IPS and IPS.__inner_impl then
        local o = IPS.__inner_impl.UpdateArtQualityUI
        IPS.__inner_impl.UpdateArtQualityUI = function(self, _, _)
            if self.UIRoot and self.UIRoot.TextBlock_quality then
                self.UIRoot.TextBlock_quality:SetText("SRC HUB")
                self.UIRoot.TextBlock_quality:SetColorAndOpacity(FSlateColor(FLinearColor(1, 0, 0, 1)))
            end
        end
    end
end)

-- ============================================
-- BRPLAYERCHARACTERBASE CLASS (KONG + SRC)
-- ============================================
local class = require("class")
local CharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local combine_class = require("combine_class")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")

local BRPlayerCharacterBase = {}

function BRPlayerCharacterBase:ctor() end

function BRPlayerCharacterBase:postConstruct()
    CharacterBase._PostConstruct(self)
end

function BRPlayerCharacterBase:receiveBeginPlay()
    CharacterBase.ReceiveBeginPlay(self)
    
    InitializeKillCounterSystem()
    InitializeKillInfoHook()
    
    self:AddGameTimer(5.0, false, function()
        pcall(ReadConfig)
    end)
    
    local function PeriodicApply()
        local player = GameplayData.GetPlayerCharacter()
        if slua.isValid(player) and player.Object == self.Object then
            pcall(_G.ApplyLocalPlayerSkins, player)
            pcall(_G.ApplyDeadBoxSkin)
            pcall(_G.RefreshKillCounterUI)
            pcall(UnlockAll)
            pcall(applyWideView)
        end
    end
    
    self:AddGameTimer(1.0, true, PeriodicApply)
    
    if Client and self:IsLocallyControlled() then
        _G.TryShowWelcome()
    end
end

function BRPlayerCharacterBase:receiveEndPlay(endPlayReason)
    CharacterBase.ReceiveEndPlay(self, endPlayReason)
end

-- ============================================
-- FINAL CLASS DECLARATION
-- ============================================
InstallAntiCheatBypass()
ReadConfig()

local FinalCharacterClass = class(CharacterBase, nil, {
    ctor = BRPlayerCharacterBase.ctor,
    _PostConstruct = BRPlayerCharacterBase.postConstruct,
    ReceiveBeginPlay = BRPlayerCharacterBase.receiveBeginPlay,
    ReceiveEndPlay = BRPlayerCharacterBase.receiveEndPlay,
})

return combine_class.DeclareFeature(FinalCharacterClass, {
    SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature",
    CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature",
    SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature",
    TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature",
    LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature",
    FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature",
}, "BRPlayerCharacterBase")