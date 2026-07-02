-- ================================================================
-- MODDED BY TrnDravix
-- ✅ COMPLETE ELITE ULTIMATE VERSION
-- ✅ 150+ FUNCTIONS
-- ✅ ALL BYPASSES
-- ✅ ALL FEATURES
-- ================================================================

-- ==================== BYPASS ENGINE ====================
local noop = function() return true end
local retFalse = function() return false end
local retZero = function() return 0 end
local retEmpty = function() return {} end
local retTrue = function() return true end
local retEmptyString = function() return "" end
local safe_require = function(path) local ok, mod = pcall(require, path); return ok and mod or nil end

-- ==================== MODULE PATCHES ====================
local modulePatches = {
    ["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"] = {
        methods = {
            ControlMHActive = noop, Tick = noop, OnTick = noop, ReceiveTick = noop, MHActiveLogic = noop,
            TriggerAvatarCheck = noop, StartAvatarCheck = noop, ReportItemID = noop, OnReportItemID = noop,
            ReceiveAnyDamage = noop, OnWeaponHitRecord = noop, ShowSecurityAlert = noop, StaticShowSecurityAlertInDev = noop,
            SendHisarData = noop, OnLogin = noop, ValidateSecurityData = noop, CheckMemoryIntegrity = noop,
            ReportAbnormalMemory = noop, OnMemoryScanComplete = noop, SendDetectionResult = noop, TriggerClientScan = noop,
            SendAntiDataFlow = noop, SendHitFireBtnFlow = noop, SkipAlertServer = function() end,
            CheckWeaponIntegrity = retTrue, CheckAvatarIntegrity = retTrue, CheckBulletIntegrity = retTrue,
            OnGameModeType = noop,
        },
        fields = { bMHActive = false, mHActive = 0 },
        retvals = { GetNetAvatarItemIDs = retEmpty, GetCurWeaponSkinID = retZero, GetDetectionResult = retEmpty },
    },
    ["GameLua.Mod.BaseMod.Common.Security.SafetyDetectionSubsystem"] = {
        methods = { DetectAbnormal = noop, ReportAbnormal = noop, OnDetectionResult = noop, TriggerSafetyScan = noop },
        retvals = { GetScanResults = retEmpty, IsAnomalyDetected = retFalse },
    },
    ["GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem"] = {
        methods = {
            OnInit = noop, _OnPlayerKilledOtherPlayer = noop, _RecordFatalDamager = noop,
            _OnDeathReplayDataWhenFatalDamaged = noop, _RecordMurdererFromDeathReplayData = noop,
            _RecordTeammatePlayerInfo = noop, _OnBattleResult = noop, _OnShowQuickReportMutualExclusiveUI = noop,
            GetFatalDamagerMap = retEmpty, GetCachedTeammateName2InfoMap = retEmpty,
            GetTeammateName2InfoMapDuringBattle = retEmpty, GetCurrentNotInTeamHistoricalTeammateMap = retEmpty,
            GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end,
            ReportSuspiciousPlayer = noop, SubmitReport = noop, ProcessReport = noop,
            ClientRPC_SyncFatalDamagerMap = noop,
        },
    },
    ["GameLua.Mod.BaseMod.Client.Security.Gokuba"] = {
        custom = function(m)
            if m.ForwardFeature then m.ForwardFeature = function() return {0,0,0,0,0} end end
            if m.TimerHandle then pcall(function() local tt = require("common.time_ticker"); tt.RemoveTimer(m.TimerHandle) end); m.TimerHandle = nil end
        end
    },
}

local originalRequire = require
local function hookedRequire(name)
    local mod = originalRequire(name)
    if modulePatches[name] then
        local cfg = modulePatches[name]
        if cfg.custom then pcall(cfg.custom, mod)
        elseif not cfg.global then
            if cfg.methods then for k, v in pairs(cfg.methods) do if type(mod[k]) == "function" then mod[k] = v end end end
            if cfg.retvals then for k, v in pairs(cfg.retvals) do if type(mod[k]) == "function" then mod[k] = v end end end
            if cfg.fields then for k, v in pairs(cfg.fields) do if mod[k] ~= nil then mod[k] = v end end end
        end
    end
    return mod
end
require = hookedRequire

local originalImport = import
local function hookedImport(name)
    local mod = originalImport(name)
    if modulePatches[name] then
        local cfg = modulePatches[name]
        if cfg.custom then pcall(cfg.custom, mod)
        elseif not cfg.global then
            if cfg.methods then for k, v in pairs(cfg.methods) do if type(mod[k]) == "function" then mod[k] = v end end end
            if cfg.retvals then for k, v in pairs(cfg.retvals) do if type(mod[k]) == "function" then mod[k] = v end end end
            if cfg.fields then for k, v in pairs(cfg.fields) do if mod[k] ~= nil then mod[k] = v end end end
        end
    end
    return mod
end
import = hookedImport

-- ==================== NETWORK BLOCKER ====================
local BLACKLIST_HOSTS = {
    "tss.tencent","syzsdk","gcloud.qq","reportlog","tdos","logupload","feedback.wh","crash2",
    "privacy.qq","privacy.tencent","oth.eve","mdt.qq","act.tencentyun","analytics","report.qq",
    "anticheatexpert","crashsight","wetest","log.tav","sngd","tracer","intlsdk","igamecj",
    "cdn.club","gpubgm","graph.facebook","calendarpushsubscription","googleads","doubleclick",
    "firebaselogging","firebaseremoteconfig","fonts.googleapis","abs.twimg","dl.listdl",
    "igame.gcloudcs","bugly","beacon","helpshift","tdm","apm","safeguard","weiyun","qzone",
    "tencent-cloud","myapp","idqqimg","gtimg","qqmail","tcdn","cloudctrl","sdkostrace",
    "103.134.189.146","mbgame","csoversea","igame","pubgmobile","down.anticheatexpert.com",
    "asia.csoversea.mbgame.anticheatexpert.com","log.tav.qq","syzsdk.qq","logiservice.qcloud",
    "opensdk.tencent","exp.helpshift","loginsdkapi.zingplay","firebase","googleapis","facebook","gvoice"
}
local BLACKLIST_PORTS = {"10334","11045","12221","13331","8011","8015","9001","20000","20001","20002","20003","20004","20005","19700","1670","19900","14545","10213","8700","25177","10685","10336","10262","27000","27040","27015","27030","10706","10095","12401","11008","10309","11075","10157","24798","10709","6667","10087","31113","20371","10120","10664","13728","10769","10761","5061","5062","18081","15692","9030","8080","8086","8088"}
local FILE_KEYWORDS = {"tlog","crash","bugly","report","beacon","wetest","analytics","telemetry","trace","dump","exception","feedback","aps_log","mtp_detect","network_loss","client_error","ue4crash","tdm","gcloud"}

local function isBlacklisted(str)
    if type(str) ~= "string" then return false end
    local low = str:lower()
    for _, kw in ipairs(BLACKLIST_HOSTS) do if low:find(kw,1,true) then return true end end
    for _, port in ipairs(BLACKLIST_PORTS) do if low:find(":"..port) or low:find("/"..port) then return true end end
    return false
end

local function applyNetworkBlocker()
    pcall(function()
        if _G.HttpRequest then
            local orig = _G.HttpRequest
            _G.HttpRequest = function(url, ...) if isBlacklisted(url) then return nil end return orig(url, ...) end
        end
        if _G.FHttpModule and _G.FHttpModule.CreateRequest then
            local orig = _G.FHttpModule.CreateRequest
            _G.FHttpModule.CreateRequest = function(...)
                local url = select(1,...)
                if isBlacklisted(url) then return nil end
                return orig(...)
            end
        end
        local netMods = {"client.slua.logic.network.logic_network","client.slua.logic.download.report.puffer_tlog","client.slua.data.BasicData.BasicDataClientReport","GameLua.GameCore.Module.Network.NetworkManager","client.network.Protocol.ClientTlogHandler","client.network.Protocol.BattleReportHandler","client.network.Protocol.ClientErrorReportHandler"}
        for _, mp in ipairs(netMods) do
            local mod = package.loaded[mp]
            if mod then
                for k, v in pairs(mod) do
                    if type(v) == "function" and (k:find("Http") or k:find("Request") or k:find("Send") or k:find("Upload") or k:find("Post") or k:find("Get") or k:find("Report")) then
                        local origf = v
                        mod[k] = function(...)
                            local args = {...}
                            for _, arg in ipairs(args) do if type(arg)=="string" and isBlacklisted(arg) then return nil end end
                            return pcall(origf, ...)
                        end
                    end
                end
            end
        end
    end)
    local orig_io_open = io.open
    io.open = function(path, mode)
        if type(path) == "string" then
            local lp = path:lower()
            for _, kw in ipairs(FILE_KEYWORDS) do
                if lp:find(kw) then
                    if mode and (mode == "w" or mode == "a" or mode == "w+" or mode == "a+") then
                        return nil, "Blocked"
                    end
                end
            end
        end
        return orig_io_open(path, mode)
    end
end

-- ==================== CRC FAKER ====================
local function deepHook(obj, depth)
    if depth > 4 then return end
    if type(obj) ~= "table" then return end
    for k, v in pairs(obj) do
        if type(k) == "string" then
            local lk = k:lower()
            if lk:find("crc") or lk:find("verify") or lk:find("integrity") or lk:find("hash") or lk:find("paksign") then
                if type(v) == "function" then
                    obj[k] = function(...) if lk:find("crc") or lk:find("hash") then return 0 end; return true end
                end
            end
        end
        if type(v) == "table" and v ~= obj then deepHook(v, depth + 1) end
    end
end

local function applyFullCRCFaker()
    if _G.__CRCFakerDone then return end
    pcall(function()
        if Client then
            if Client.VerifyPakFile then Client.VerifyPakFile = retTrue end
            if Client.CheckFileCRC then Client.CheckFileCRC = retZero end
            if Client.GetFileHash then Client.GetFileHash = function() return "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" end end
            if Client.VerifySignature then Client.VerifySignature = retTrue end
            if Client.CheckGameLuaIntegrity then Client.CheckGameLuaIntegrity = retTrue end
            if Client.VerifyFileIntegrity then Client.VerifyFileIntegrity = retTrue end
            if Client.VerifyAllPaks then Client.VerifyAllPaks = retTrue end
        end
        for _, mod in pairs(package.loaded) do if type(mod) == "table" then deepHook(mod, 0) end end
        _G.__CRCFakerDone = true
    end)
end

-- ==================== ALL FEATURE TOGGLES ====================
-- Aimbot
if _G.Mod_Aimbot_Enabled == nil then _G.Mod_Aimbot_Enabled = false end
if _G.Mod_AimbotStrength == nil then _G.Mod_AimbotStrength = 50 end
if _G.Mod_AimbotBone == nil then _G.Mod_AimbotBone = "Head" end
if _G.Mod_AimbotFOV == nil then _G.Mod_AimbotFOV = 90 end
if _G.Mod_AimbotSmooth == nil then _G.Mod_AimbotSmooth = true end
if _G.Mod_AimbotPrediction == nil then _G.Mod_AimbotPrediction = false end

-- ESP
if _G.Mod_ESP_Enabled == nil then _G.Mod_ESP_Enabled = false end
if _G.Mod_Wallhack_Enabled == nil then _G.Mod_Wallhack_Enabled = false end
if _G.Mod_BoxESP_Enabled == nil then _G.Mod_BoxESP_Enabled = true end
if _G.Mod_SkeletonESP_Enabled == nil then _G.Mod_SkeletonESP_Enabled = false end
if _G.Mod_HealthBarESP_Enabled == nil then _G.Mod_HealthBarESP_Enabled = true end
if _G.Mod_DistanceESP_Enabled == nil then _G.Mod_DistanceESP_Enabled = true end
if _G.Mod_NameESP_Enabled == nil then _G.Mod_NameESP_Enabled = true end
if _G.Mod_WeaponESP_Enabled == nil then _G.Mod_WeaponESP_Enabled = false end
if _G.Mod_TeamESP_Enabled == nil then _G.Mod_TeamESP_Enabled = true end
if _G.Mod_VehicleESP_Enabled == nil then _G.Mod_VehicleESP_Enabled = false end
if _G.Mod_LootESP_Enabled == nil then _G.Mod_LootESP_Enabled = false end
if _G.Mod_DropESP_Enabled == nil then _G.Mod_DropESP_Enabled = false end
if _G.Mod_AirdropESP_Enabled == nil then _G.Mod_AirdropESP_Enabled = false end
if _G.Mod_ZoneESP_Enabled == nil then _G.Mod_ZoneESP_Enabled = false end
if _G.Mod_EnemyCountESP_Enabled == nil then _G.Mod_EnemyCountESP_Enabled = true end
if _G.Mod_HeadCircleESP_Enabled == nil then _G.Mod_HeadCircleESP_Enabled = false end
if _G.Mod_TracerESP_Enabled == nil then _G.Mod_TracerESP_Enabled = false end

-- Chams Colors
if _G.Mod_Chams_GreenEnabled == nil then _G.Mod_Chams_GreenEnabled = false end
if _G.Mod_Chams_YellowEnabled == nil then _G.Mod_Chams_YellowEnabled = false end
if _G.Mod_Chams_GreenRGB == nil then _G.Mod_Chams_GreenRGB = {R=0, G=255, B=0, A=255} end
if _G.Mod_Chams_YellowRGB == nil then _G.Mod_Chams_YellowRGB = {R=255, G=255, B=0, A=255} end

-- Wallhack Features
if _G.Mod_Glow_Enabled == nil then _G.Mod_Glow_Enabled = false end
if _G.Mod_XRay_Enabled == nil then _G.Mod_XRay_Enabled = false end
if _G.Mod_FullBright_Enabled == nil then _G.Mod_FullBright_Enabled = false end
if _G.Mod_NoSmoke_Enabled == nil then _G.Mod_NoSmoke_Enabled = false end
if _G.Mod_NoFlash_Enabled == nil then _G.Mod_NoFlash_Enabled = false end
if _G.Mod_NoWater_Enabled == nil then _G.Mod_NoWater_Enabled = false end
if _G.Mod_NoGrass_Enabled == nil then _G.Mod_NoGrass_Enabled = true end
if _G.Mod_NoTrees_Enabled == nil then _G.Mod_NoTrees_Enabled = false end
if _G.Mod_NoFog_Enabled == nil then _G.Mod_NoFog_Enabled = false end

-- Movement Features
if _G.Mod_SpeedBoost_Enabled == nil then _G.Mod_SpeedBoost_Enabled = false end
if _G.Mod_SpeedPercent == nil then _G.Mod_SpeedPercent = 250 end
if _G.Mod_FlyHack_Enabled == nil then _G.Mod_FlyHack_Enabled = false end
if _G.Mod_NoFallDamage_Enabled == nil then _G.Mod_NoFallDamage_Enabled = false end
if _G.Mod_SuperJump_Enabled == nil then _G.Mod_SuperJump_Enabled = false end
if _G.Mod_JumpHeight == nil then _G.Mod_JumpHeight = 5.0 end
if _G.Mod_SwimHack_Enabled == nil then _G.Mod_SwimHack_Enabled = false end
if _G.Mod_ClimbHack_Enabled == nil then _G.Mod_ClimbHack_Enabled = false end
if _G.Mod_NoStumble_Enabled == nil then _G.Mod_NoStumble_Enabled = false end
if _G.Mod_NoSlow_Enabled == nil then _G.Mod_NoSlow_Enabled = false end
if _G.Mod_JumpReset_Enabled == nil then _G.Mod_JumpReset_Enabled = false end

-- Weapon Features
if _G.Mod_NoRecoil_Enabled == nil then _G.Mod_NoRecoil_Enabled = false end
if _G.Mod_NoSpread_Enabled == nil then _G.Mod_NoSpread_Enabled = false end
if _G.Mod_NoSway_Enabled == nil then _G.Mod_NoSway_Enabled = false end
if _G.Mod_InstantReload_Enabled == nil then _G.Mod_InstantReload_Enabled = false end
if _G.Mod_InfiniteAmmo_Enabled == nil then _G.Mod_InfiniteAmmo_Enabled = false end
if _G.Mod_SuperBullet_Enabled == nil then _G.Mod_SuperBullet_Enabled = false end
if _G.Mod_BulletCount == nil then _G.Mod_BulletCount = 5 end
if _G.Mod_SuperFireRate_Enabled == nil then _G.Mod_SuperFireRate_Enabled = false end
if _G.Mod_FireRateValue == nil then _G.Mod_FireRateValue = 0.008 end
if _G.Mod_MagicBullet_Enabled == nil then _G.Mod_MagicBullet_Enabled = false end
if _G.Mod_MegaDamage_Enabled == nil then _G.Mod_MegaDamage_Enabled = false end
if _G.Mod_AutoFire_Enabled == nil then _G.Mod_AutoFire_Enabled = false end

-- Protection Features
if _G.Mod_ReportBlocker_Enabled == nil then _G.Mod_ReportBlocker_Enabled = true end
if _G.Mod_NoBan_Enabled == nil then _G.Mod_NoBan_Enabled = true end
if _G.Mod_AntiScreenshot_Enabled == nil then _G.Mod_AntiScreenshot_Enabled = false end
if _G.Mod_AntiStream_Enabled == nil then _G.Mod_AntiStream_Enabled = false end
if _G.Mod_NoReplay_Enabled == nil then _G.Mod_NoReplay_Enabled = false end
if _G.Mod_NoTelemetry_Enabled == nil then _G.Mod_NoTelemetry_Enabled = true end
if _G.Mod_NoLogs_Enabled == nil then _G.Mod_NoLogs_Enabled = true end
if _G.Mod_NoCrashReport_Enabled == nil then _G.Mod_NoCrashReport_Enabled = true end
if _G.Mod_NoBugReport_Enabled == nil then _G.Mod_NoBugReport_Enabled = true end
if _G.Mod_NoAnalytics_Enabled == nil then _G.Mod_NoAnalytics_Enabled = true end
if _G.Mod_NoMonitoring_Enabled == nil then _G.Mod_NoMonitoring_Enabled = true end

-- Visual Customization
if _G.Mod_FPS165_Enabled == nil then _G.Mod_FPS165_Enabled = true end
if _G.Mod_iPadView_Enabled == nil then _G.Mod_iPadView_Enabled = false end
if _G.Mod_iPadViewDistance == nil then _G.Mod_iPadViewDistance = 90 end
if _G.Mod_CustomCrosshair_Enabled == nil then _G.Mod_CustomCrosshair_Enabled = false end
if _G.Mod_CustomColor == nil then _G.Mod_CustomColor = {R=255,G=0,B=0,A=255} end
if _G.Mod_HUDToggle_Enabled == nil then _G.Mod_HUDToggle_Enabled = false end
if _G.Mod_NoHUD_Enabled == nil then _G.Mod_NoHUD_Enabled = false end
if _G.Mod_NoDeathCam_Enabled == nil then _G.Mod_NoDeathCam_Enabled = false end
if _G.Mod_NoKillCam_Enabled == nil then _G.Mod_NoKillCam_Enabled = false end
if _G.Mod_Rain_Enabled == nil then _G.Mod_Rain_Enabled = false end
if _G.Mod_Snow_Enabled == nil then _G.Mod_Snow_Enabled = false end
if _G.Mod_FOVValue == nil then _G.Mod_FOVValue = 90 end
if _G.Mod_AntiAliasing_Enabled == nil then _G.Mod_AntiAliasing_Enabled = true end
if _G.Mod_FrameLimit == nil then _G.Mod_FrameLimit = 165 end

-- Gameplay Features
if _G.Mod_AutoPickup_Enabled == nil then _G.Mod_AutoPickup_Enabled = false end
if _G.Mod_AutoHeal_Enabled == nil then _G.Mod_AutoHeal_Enabled = false end
if _G.Mod_AutoReload_Enabled == nil then _G.Mod_AutoReload_Enabled = false end
if _G.Mod_AutoPeek_Enabled == nil then _G.Mod_AutoPeek_Enabled = false end
if _G.Mod_AutoProne_Enabled == nil then _G.Mod_AutoProne_Enabled = false end
if _G.Mod_InstantDeath_Enabled == nil then _G.Mod_InstantDeath_Enabled = false end
if _G.Mod_FastRevive_Enabled == nil then _G.Mod_FastRevive_Enabled = false end
if _G.Mod_NoSelfDamage_Enabled == nil then _G.Mod_NoSelfDamage_Enabled = false end
if _G.Mod_InfiniteSprint_Enabled == nil then _G.Mod_InfiniteSprint_Enabled = false end
if _G.Mod_InfiniteOxygen_Enabled == nil then _G.Mod_InfiniteOxygen_Enabled = false end

-- Skin System
if _G.Mod_Skin_Enabled == nil then _G.Mod_Skin_Enabled = false end
_G.WeaponSkinMap = _G.WeaponSkinMap or {}
_G.VehicleSkinMap = _G.VehicleSkinMap or {}
_G.OutfitMap = _G.OutfitMap or {}

-- Vehicle Features
if _G.Mod_VehicleSpeed_Enabled == nil then _G.Mod_VehicleSpeed_Enabled = false end
if _G.Mod_VehicleSpeedMult == nil then _G.Mod_VehicleSpeedMult = 2.0 end
if _G.Mod_VehicleFly_Enabled == nil then _G.Mod_VehicleFly_Enabled = false end
if _G.Mod_NoVehicleDamage_Enabled == nil then _G.Mod_NoVehicleDamage_Enabled = false end
if _G.Mod_InfiniteFuel_Enabled == nil then _G.Mod_InfiniteFuel_Enabled = false end
if _G.Mod_VehicleJump_Enabled == nil then _G.Mod_VehicleJump_Enabled = false end
if _G.Mod_VehicleNoFlip_Enabled == nil then _G.Mod_VehicleNoFlip_Enabled = false end
if _G.Mod_UnderwaterVehicle_Enabled == nil then _G.Mod_UnderwaterVehicle_Enabled = false end

-- Utility Features
if _G.Mod_NoTeamDamage_Enabled == nil then _G.Mod_NoTeamDamage_Enabled = false end
if _G.Mod_NoVoiceChat_Enabled == nil then _G.Mod_NoVoiceChat_Enabled = false end
if _G.Mod_NoBots_Enabled == nil then _G.Mod_NoBots_Enabled = false end
if _G.Mod_AutoRun_Enabled == nil then _G.Mod_AutoRun_Enabled = false end
if _G.Mod_AutoJump_Enabled == nil then _G.Mod_AutoJump_Enabled = false end
if _G.Mod_NoHitboxes_Enabled == nil then _G.Mod_NoHitboxes_Enabled = false end
if _G.Mod_InstantExit_Enabled == nil then _G.Mod_InstantExit_Enabled = false end

-- Risky Features
if _G.Mod_GodMode_Enabled == nil then _G.Mod_GodMode_Enabled = false end
if _G.Mod_InfiniteHealth_Enabled == nil then _G.Mod_InfiniteHealth_Enabled = false end
if _G.Mod_OneHitKill_Enabled == nil then _G.Mod_OneHitKill_Enabled = false end
if _G.Mod_SpinBot_Enabled == nil then _G.Mod_SpinBot_Enabled = false end
if _G.Mod_AntiGravity_Enabled == nil then _G.Mod_AntiGravity_Enabled = false end
if _G.Mod_GravityScale == nil then _G.Mod_GravityScale = 0.5 end
if _G.Mod_TimeScale_Enabled == nil then _G.Mod_TimeScale_Enabled = false end
if _G.Mod_TimeScaleValue == nil then _G.Mod_TimeScaleValue = 0.5 end
if _G.Mod_NoClip_Enabled == nil then _G.Mod_NoClip_Enabled = false end
if _G.Mod_MassKill_Enabled == nil then _G.Mod_MassKill_Enabled = false end

-- Network Features
if _G.Mod_NoLag_Enabled == nil then _G.Mod_NoLag_Enabled = false end
if _G.Mod_PingSpoof_Enabled == nil then _G.Mod_PingSpoof_Enabled = false end
if _G.Mod_PingValue == nil then _G.Mod_PingValue = 50 end
if _G.Mod_RegionBypass_Enabled == nil then _G.Mod_RegionBypass_Enabled = false end

-- Scene Config
if _G.ESPConfig == nil then _G.ESPConfig = {} end
if _G.ESPConfig.BlackSky == nil then _G.ESPConfig.BlackSky = false end
if _G.ESPConfig.RemoveFog == nil then _G.ESPConfig.RemoveFog = false end
if _G.ESPConfig.RemoveGrass == nil then _G.ESPConfig.RemoveGrass = false end
if _G.ESPConfig.RemoveTree == nil then _G.ESPConfig.RemoveTree = false end
if _G.ESPConfig.RemoveWater == nil then _G.ESPConfig.RemoveWater = false end
if _G.ESPConfig.ForceChinese == nil then _G.ESPConfig.ForceChinese = false end

-- ==================== SCENE FUNCTIONS ====================
local function ExecuteConsoleCommand(cmd, value)
    local instance = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
    if instance then pcall(function() instance:ExecuteCMD(cmd, value) end)
    else
        local SettingUtil = require("client.slua.logic.setting.setting_util")
        if SettingUtil and SettingUtil.GetGameInstance then
            local gi = SettingUtil:GetGameInstance()
            if gi then pcall(function() gi:ExecuteCMD(cmd, value) end) end
        end
    end
end

function SetBlackSky(enabled) ExecuteConsoleCommand("r.CylinderMaxDrawHeight", enabled and "9999" or "0") end
function SetFogRemoval(enabled) ExecuteConsoleCommand("r.Fog", enabled and "0" or "1"); ExecuteConsoleCommand("r.VolumetricFog", enabled and "0" or "1") end
function SetGrassRemoval(enabled) ExecuteConsoleCommand("grass.DensityScale", enabled and "0" or "1"); ExecuteConsoleCommand("foliage.DensityScale", enabled and "0" or "1") end
function SetTreeRemoval(enabled) ExecuteConsoleCommand("foliage.TreeDensityScale", enabled and "0" or "1") end
function SetWaterRemoval(enabled) ExecuteConsoleCommand("r.Water", enabled and "0" or "1") end
function SetForceChinese(enabled)
    if enabled then pcall(function() local gi = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance(); if gi and gi.SetCurrentCulture then gi:SetCurrentCulture("zh-CN") end end)
    else pcall(function() local gi = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance(); if gi and gi.SetCurrentCulture then gi:SetCurrentCulture("en") end end) end
end

function SetRainEnabled(enabled)
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) then
            local char = pc:GetPlayerCharacterSafety()
            if slua.isValid(char) then
                local EScreenParticleEffectType = import("EScreenParticleEffectType")
                if EScreenParticleEffectType and char.SetRainyEffectEnable then
                    char:SetRainyEffectEnable(EScreenParticleEffectType.ESPET_Rainy, enabled and true or false, enabled and 500 or 0)
                end
            end
        end
        local SubsystemMgr = safe_require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local weatherSubsystem = SubsystemMgr:Get("CreativeModeWeatherSubsystem")
            if slua.isValid(weatherSubsystem) then
                if enabled and weatherSubsystem.StartRainScreenEffect then weatherSubsystem:StartRainScreenEffect()
                elseif not enabled and weatherSubsystem.StopRainScreenEffect then weatherSubsystem:StopRainScreenEffect() end
            end
        end
    end)
end

function SetSnowEnabled(enabled)
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) then
            local char = pc:GetPlayerCharacterSafety()
            if slua.isValid(char) then
                local EScreenParticleEffectType = import("EScreenParticleEffectType")
                if EScreenParticleEffectType and char.SetRainyEffectEnable then
                    char:SetRainyEffectEnable(EScreenParticleEffectType.ESPET_Snowy, enabled and true or false, enabled and 500 or 0)
                end
            end
        end
        local SubsystemMgr = safe_require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local weatherSubsystem = SubsystemMgr:Get("CreativeModeWeatherSubsystem")
            if slua.isValid(weatherSubsystem) then
                if enabled and weatherSubsystem.StartSnowScreenEffect then weatherSubsystem:StartSnowScreenEffect()
                elseif enabled and weatherSubsystem.StartRainScreenEffect then weatherSubsystem:StartRainScreenEffect()
                elseif not enabled and weatherSubsystem.StopSnowScreenEffect then weatherSubsystem:StopSnowScreenEffect()
                elseif not enabled and weatherSubsystem.StopRainScreenEffect then weatherSubsystem:StopRainScreenEffect() end
            end
        end
    end)
end

function SetFullBright(enabled) ExecuteConsoleCommand("r.Tonemapper", enabled and "1" or "0") end
function SetNoSmoke(enabled) ExecuteConsoleCommand("r.Smoke", enabled and "0" or "1") end
function SetNoFlash(enabled) ExecuteConsoleCommand("r.Flash", enabled and "0" or "1") end
function SetNoWater(enabled) ExecuteConsoleCommand("r.Water", enabled and "0" or "1") end
function SetNoTrees(enabled) ExecuteConsoleCommand("foliage.TreeDensityScale", enabled and "0" or "1") end

-- ==================== AIMBOT SYSTEM ====================
local _AimbotCurrentPC = nil
local _AimbotTarget = nil
local _AimbotTimer = nil

function GetClosestEnemy(pc, maxDist)
    if not slua.isValid(pc) then return nil end
    local char = pc:GetPlayerCharacterSafety()
    if not slua.isValid(char) then return nil end
    local myTeam = char.TeamID or 0
    local myPos = char:K2_GetActorLocation()
    if not myPos then return nil end
    
    local allPawns = Game:GetAllPlayerPawns() or {}
    local closest = nil
    local closestDist = maxDist or 100000
    
    for _, p in pairs(allPawns) do
        if slua.isValid(p) and p ~= char and (p.TeamID or 0) ~= myTeam then
            local health = p.Health or 0
            local maxHealth = p.HealthMax or 100
            if health > 0 and maxHealth > 0 then
                local pos = p:K2_GetActorLocation()
                if pos then
                    local dx = pos.X - myPos.X
                    local dy = pos.Y - myPos.Y
                    local dz = pos.Z - myPos.Z
                    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < closestDist then
                        closestDist = dist
                        closest = p
                    end
                end
            end
        end
    end
    return closest
end

function GetBoneLocation(pawn, boneName)
    if not slua.isValid(pawn) or not slua.isValid(pawn.Mesh) then return nil end
    return pawn.Mesh:GetSocketLocation(boneName)
end

function ApplyAimbot()
    if not _G.Mod_Aimbot_Enabled then return end
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        
        local target = GetClosestEnemy(pc, 100000)
        if not slua.isValid(target) then return end
        
        local boneName = "head"
        if _G.Mod_AimbotBone == "Chest" then boneName = "spine_03"
        elseif _G.Mod_AimbotBone == "Spine" then boneName = "spine_01"
        elseif _G.Mod_AimbotBone == "Legs" then boneName = "calf_l" end
        
        local targetPos = GetBoneLocation(target, boneName)
        if not targetPos then return end
        
        local myPos = char:K2_GetActorLocation()
        if not myPos then return end
        
        -- Calculate rotation to target
        local dx = targetPos.X - myPos.X
        local dy = targetPos.Y - myPos.Y
        local dz = targetPos.Z - myPos.Z
        
        local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
        if dist < 10 then return end
        
        local pitch = math.asin(dz / dist) * (180 / math.pi)
        local yaw = math.atan2(dy, dx) * (180 / math.pi)
        
        -- Apply smoothing
        if _G.Mod_AimbotSmooth then
            local currentRot = char:GetControlRotation()
            local smoothFactor = 0.3
            pitch = currentRot.Pitch + (pitch - currentRot.Pitch) * smoothFactor
            yaw = currentRot.Yaw + (yaw - currentRot.Yaw) * smoothFactor
        end
        
        pc:SetControlRotation(FRotator(pitch, yaw, 0))
    end)
end

function StartAimbotTimer()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        if pc == _AimbotCurrentPC then return end
        _AimbotCurrentPC = pc
        if _AimbotTimer then pc:RemoveGameTimer(_AimbotTimer) end
        _AimbotTimer = pc:AddGameTimer(0.01, true, ApplyAimbot)
    end)
end

StartAimbotTimer()

-- ==================== ESP SYSTEM ====================
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local ASTExtraPlayerController = import("/Script/ShadowTrackerExtra.STExtraPlayerController")
local cachedPawns = {}
local lastPawnRefresh = 0

local function IsPawnAlive(p)
    if not slua.isValid(p) then return false end
    if p.HealthStatus then return SecurityCommonUtils.IsHealthStatusAlive(p.HealthStatus) end
    if p.IsAlive then return p:IsAlive() end
    return p.GetHealth and (p:GetHealth() or 0) > 0 or false
end

local boneList = {"head","neck_01","spine_01","spine_02","spine_03","pelvis","upperarm_l","upperarm_r","lowerarm_l","lowerarm_r","hand_l","hand_r","calf_l","calf_r","foot_l","foot_r"}

local function TextScale(distM)
    local t = math.min(distM / 400, 1)
    return 0.35 - t * 0.2
end

local function HPBar(pct)
    local n = math.floor((pct * 4) + 0.5)
    local s = ""
    for i = 1, 4 do s = s .. (i <= n and "▁" or " ") end
    return s
end

function ApplyWallHack(localPlayer, enemy, pc)
    if not _G.Mod_Wallhack_Enabled then return end
    if not slua.isValid(enemy) then return end
    pcall(function()
        local meshes = {}
        if slua.isValid(enemy.Mesh) then table.insert(meshes, enemy.Mesh) end
        local SkelClass = import("SkeletalMeshComponent")
        if SkelClass then
            local childs = enemy:GetComponentsByClass(SkelClass)
            if childs then
                local count = type(childs.Num) == "function" and childs:Num() or #childs
                for c = 1, count do
                    local comp = type(childs.Get) == "function" and childs:Get(c-1) or childs[c]
                    if slua.isValid(comp) and comp ~= enemy.Mesh then table.insert(meshes, comp) end
                end
            end
        end
        for _, comp in ipairs(meshes) do
            if slua.isValid(comp) then
                comp.UseScopeDistanceCulling = false
                comp.PrimitiveShadingStrategy = 1
                comp.ShadingRate = 6
            end
        end
        local isVisible = false
        if slua.isValid(pc) and slua.isValid(enemy) and type(pc.LineOfSightTo) == "function" then
            pcall(function() isVisible = pc:LineOfSightTo(enemy) end)
        end
        local finalColor = isVisible and _G.Mod_Chams_GreenRGB or _G.Mod_Chams_YellowRGB
        if _G.Mod_Glow_Enabled then finalColor = {R=255,G=255,B=255,A=255} end
        for _, comp in ipairs(meshes) do
            if slua.isValid(comp) then
                for i = 0, 10 do
                    local ok, mi = pcall(function() return comp:GetMaterial(i) end)
                    if not ok or not slua.isValid(mi) then break end
                    pcall(function()
                        local mid = comp:CreateAndSetMaterialInstanceDynamic(i)
                        if slua.isValid(mid) then
                            mid:SetVectorParameterValue("颜色", finalColor)
                            mid:SetVectorParameterValue("Color", finalColor)
                            mid:SetVectorParameterValue("BaseColor", finalColor)
                            mid:SetVectorParameterValue("BodyColor", finalColor)
                            mid:SetVectorParameterValue("DiffuseColor", finalColor)
                        end
                    end)
                end
            end
        end
    end)
end

function ESPTick()
    if not _G.Mod_ESP_Enabled then return end
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local currentPawn = pc:GetCurPawn()
    if not slua.isValid(currentPawn) then return end
    
    local myTeamId = 0
    pcall(function() local char = pc:GetPlayerCharacterSafety(); if slua.isValid(char) and char.TeamID then myTeamId = char.TeamID end end)
    local myPos = currentPawn:K2_GetActorLocation()
    if not myPos then return end
    
    local HUD = pc:GetHUD()
    if not slua.isValid(HUD) then return end
    
    local now = os.clock()
    if now - lastPawnRefresh > 1.0 then
        lastPawnRefresh = now
        cachedPawns = Game:GetAllPlayerPawns() or {}
    end
    
    local botCount = 0
    local playerCount = 0
    
    for _, tPawn in pairs(cachedPawns) do
        if slua.isValid(tPawn) and tPawn ~= currentPawn and (tPawn.TeamID or 0) ~= myTeamId then
            if IsPawnAlive(tPawn) then
                local enemyPos = tPawn:K2_GetActorLocation()
                local dx = enemyPos.X - myPos.X
                local dy = enemyPos.Y - myPos.Y
                local dz = enemyPos.Z - myPos.Z
                local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
                
                if dist < 600000 then
                    local isBot = false
                    pcall(function() isBot = Game:IsAI(tPawn) end)
                    if isBot then botCount = botCount + 1 else playerCount = playerCount + 1 end
                    
                    local name = tPawn.PlayerName or "UNKNOWN"
                    local distM = dist / 100
                    
                    local hp = tPawn.Health or 100
                    local maxHp = tPawn.HealthMax or 100
                    local hpPercent = hp / maxHp
                    
                    -- Health bar
                    if _G.Mod_HealthBarESP_Enabled then
                        local hpColor = {R=0,G=255,B=0,A=255}
                        if hpPercent < 0.3 then hpColor = {R=255,G=0,B=0,A=255}
                        elseif hpPercent < 0.7 then hpColor = {R=255,G=255,B=0,A=255} end
                        local hpOffset = 70 + math.min(distM, 60) * 3
                        HUD:AddDebugText(HPBar(hpPercent), tPawn, TextScale(distM), {X=0,Y=0,Z=hpOffset}, {X=0,Y=0,Z=hpOffset}, hpColor, true, false, true, nil, 1.0, true)
                    end
                    
                    -- Name ESP
                    if _G.Mod_NameESP_Enabled then
                        local nameColor = {R=0,G=255,B=0,A=255}
                        if _G.Mod_TeamESP_Enabled then
                            local isEnemy = (tPawn.TeamID or 0) ~= myTeamId
                            nameColor = isEnemy and {R=255,G=0,B=0,A=255} or {R=0,G=255,B=0,A=255}
                        end
                        local nameOffset = -80 - math.min(distM, 60) * 0.33
                        HUD:AddDebugText(string.format("[%.0fm] %s", distM, name), tPawn, TextScale(distM), {X=0,Y=0,Z=nameOffset}, {X=0,Y=0,Z=nameOffset}, nameColor, true, false, true, nil, 1.0, true)
                    end
                    
                    -- Box ESP
                    if _G.Mod_BoxESP_Enabled then
                        local bones = {}
                        local mesh = tPawn.Mesh
                        if slua.isValid(mesh) then
                            for _, bn in ipairs(boneList) do
                                bones[bn] = mesh:GetSocketLocation(bn)
                            end
                        end
                        local headPos = bones["head"]
                        local footPos = bones["foot_l"] or bones["foot_r"] or enemyPos
                        if headPos and footPos then
                            local topZ = headPos.Z - enemyPos.Z
                            local botZ = footPos.Z - enemyPos.Z
                            local height = topZ - botZ
                            local width = height * 0.4
                            HUD:AddDebugText("▢", tPawn, 1, {X=0,Y=width/2,Z=height/2}, {X=0,Y=width/2,Z=height/2}, {R=255,G=0,B=0,A=255}, true, false, true, nil, 1.0, true)
                        end
                    end
                    
                    -- Weapon ESP
                    if _G.Mod_WeaponESP_Enabled then
                        local weapon = tPawn:GetCurrentWeapon()
                        if slua.isValid(weapon) then
                            local weaponName = weapon:GetWeaponName() or "Unknown"
                            HUD:AddDebugText(weaponName, tPawn, 0.5, {X=0,Y=0,Z=-130}, {X=0,Y=0,Z=-130}, {R=255,G=255,B=255,A=255}, true, false, true, nil, 1.0, true)
                        end
                    end
                    
                    -- Apply wallhack
                    ApplyWallHack(currentPawn, tPawn, pc)
                end
            end
        end
    end
    
    -- Enemy count
    if _G.Mod_EnemyCountESP_Enabled and slua.isValid(HUD) and slua.isValid(currentPawn) then
        HUD:AddDebugText(string.format("[ BOT: %d | PLAYER: %d ]", botCount, playerCount), currentPawn, 1, {X=0,Y=0,Z=155}, {X=0,Y=0,Z=155}, {R=255,G=100,B=0,A=255}, true, false, true, nil, 1.0, true)
        HUD:AddDebugText("TRNDRAVIX ELITE", currentPawn, 1, {X=0,Y=0,Z=145}, {X=0,Y=0,Z=145}, {R=0,G=255,B=255,A=255}, true, false, true, nil, 1.0, true)
    end
end

-- Start ESP timer
pcall(function()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) then
        if _G._ESPTimer then pc:RemoveGameTimer(_G._ESPTimer) end
        _G._ESPTimer = pc:AddGameTimer(0.1, true, ESPTick)
    end
end)

-- ==================== WEAPON FEATURES ====================
function ApplyWeaponMods()
    if not _G.Mod_AutoFire_Enabled and not _G.Mod_NoRecoil_Enabled and not _G.Mod_NoSpread_Enabled and not _G.Mod_NoSway_Enabled and not _G.Mod_InstantReload_Enabled and not _G.Mod_InfiniteAmmo_Enabled and not _G.Mod_SuperBullet_Enabled and not _G.Mod_SuperFireRate_Enabled and not _G.Mod_MagicBullet_Enabled and not _G.Mod_MegaDamage_Enabled then return end
    
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        
        local wm = char.WeaponManagerComponent
        if not slua.isValid(wm) then return end
        local weapon = wm.CurrentWeaponReplicated
        if not slua.isValid(weapon) then return end
        
        local shoot = weapon.ShootWeaponEntityComp
        if not slua.isValid(shoot) then return end
        
        -- No Recoil
        if _G.Mod_NoRecoil_Enabled then
            shoot.RecoilKick = 0
            shoot.RecoilKickADS = 0
            shoot.AnimationKick = 0
            shoot.AccessoriesVRecoilFactor = 0
            shoot.AccessoriesHRecoilFactor = 0
        end
        
        -- No Spread
        if _G.Mod_NoSpread_Enabled then
            shoot.GameDeviationFactor = 0
            shoot.BaseAccuracy = 100
        end
        
        -- No Sway
        if _G.Mod_NoSway_Enabled then
            shoot.SwayFactor = 0
        end
        
        -- Instant Reload
        if _G.Mod_InstantReload_Enabled then
            weapon.ReloadTime = 0.01
        end
        
        -- Infinite Ammo
        if _G.Mod_InfiniteAmmo_Enabled then
            shoot.bClipHasInfiniteBullets = true
            shoot.bHasInfiniteBullets = true
        end
        
        -- Super Bullet
        if _G.Mod_SuperBullet_Enabled then
            shoot.BulletNumSingleShot = _G.Mod_BulletCount or 5
        end
        
        -- Super Fire Rate
        if _G.Mod_SuperFireRate_Enabled then
            shoot.ShootInterval = _G.Mod_FireRateValue or 0.008
        end
        
        -- Auto Fire
        if _G.Mod_AutoFire_Enabled then
            shoot.bIsAutoFire = true
        end
    end)
end

-- ==================== MOVEMENT FEATURES ====================
local _SpeedBoostTimer = nil
local _SpinBotTimer = nil
local _FlyTimer = nil

function ApplyMovementMods()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        
        local move = char.CharacterMovement or char.CharMoveComp
        if not move then return end
        
        -- Speed Boost
        if _G.Mod_SpeedBoost_Enabled then
            local speed = _G.Mod_SpeedPercent / 100
            move.MaxWalkSpeed = 600 * speed
            move.MaxSprintSpeed = 1000 * speed
        else
            move.MaxWalkSpeed = 600
            move.MaxSprintSpeed = 1000
        end
        
        -- Super Jump
        if _G.Mod_SuperJump_Enabled then
            move.JumpZVelocity = 600 * (_G.Mod_JumpHeight or 5.0)
        else
            move.JumpZVelocity = 600
        end
        
        -- No Fall Damage
        if _G.Mod_NoFallDamage_Enabled then
            move.FallingDamage = 0
        end
        
        -- No Stumble
        if _G.Mod_NoStumble_Enabled then
            move.StumbleFactor = 0
        end
        
        -- Climb Hack
        if _G.Mod_ClimbHack_Enabled then
            move.WalkableFloorAngle = 199
            move.MaxStepHeight = 999
        else
            move.WalkableFloorAngle = 45
            move.MaxStepHeight = 45
        end
        
        -- Anti-Gravity
        if _G.Mod_AntiGravity_Enabled then
            move.GravityScale = _G.Mod_GravityScale or 0.5
        else
            move.GravityScale = 1.0
        end
        
        -- No Slow
        if _G.Mod_NoSlow_Enabled then
            move.BrakingDecelerationWalking = 0
        end
        
        -- Infinite Sprint
        if _G.Mod_InfiniteSprint_Enabled then
            char.Stamina = 1000000
        end
    end)
end

-- Speed Boost Timer
pcall(function()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) then
        if _SpeedBoostTimer then pc:RemoveGameTimer(_SpeedBoostTimer) end
        _SpeedBoostTimer = pc:AddGameTimer(0.1, true, ApplyMovementMods)
    end
end)

-- Spin Bot
pcall(function()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) then
        if _SpinBotTimer then pc:RemoveGameTimer(_SpinBotTimer) end
        _SpinBotTimer = pc:AddGameTimer(0.016, true, function()
            if _G.Mod_SpinBot_Enabled then
                pcall(function()
                    local pc2 = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                    if slua.isValid(pc2) then
                        local rot = pc2:GetControlRotation()
                        rot.Yaw = rot.Yaw + 360
                        pc2:SetControlRotation(rot)
                    end
                end)
            end
        end)
    end
end)

-- Fly Hack
pcall(function()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) then
        if _FlyTimer then pc:RemoveGameTimer(_FlyTimer) end
        _FlyTimer = pc:AddGameTimer(0.016, true, function()
            if _G.Mod_FlyHack_Enabled then
                pcall(function()
                    local pc2 = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                    if slua.isValid(pc2) then
                        local char = pc2:GetPlayerCharacterSafety()
                        if slua.isValid(char) and char.CharacterMovement then
                            char.CharacterMovement:SetMovementMode(1) -- Flying mode
                        end
                    end
                end)
            end
        end)
    end
end)

-- ==================== VEHICLE FEATURES ====================
function ApplyVehicleMods()
    if not _G.Mod_VehicleSpeed_Enabled and not _G.Mod_VehicleFly_Enabled and not _G.Mod_NoVehicleDamage_Enabled and not _G.Mod_InfiniteFuel_Enabled and not _G.Mod_VehicleJump_Enabled and not _G.Mod_VehicleNoFlip_Enabled then return end
    
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        
        local vehicle = char.CurrentVehicle
        if not slua.isValid(vehicle) then return end
        
        -- Vehicle Speed
        if _G.Mod_VehicleSpeed_Enabled then
            local mult = _G.Mod_VehicleSpeedMult or 2.0
            vehicle.MaxForwardSpeed = 2000 * mult
            vehicle.MaxBackwardSpeed = 1000 * mult
        end
        
        -- No Vehicle Damage
        if _G.Mod_NoVehicleDamage_Enabled then
            vehicle.Health = 9999
        end
        
        -- Infinite Fuel
        if _G.Mod_InfiniteFuel_Enabled then
            vehicle.Fuel = 9999
        end
        
        -- Vehicle Jump
        if _G.Mod_VehicleJump_Enabled then
            vehicle.BoostForce = 50000
        end
        
        -- Vehicle No Flip
        if _G.Mod_VehicleNoFlip_Enabled then
            vehicle.bEnablePhysicsOnVehicle = false
        end
    end)
end

-- ==================== VISUAL FEATURES ====================
function ApplyVisualMods()
    -- No Smoke
    if _G.Mod_NoSmoke_Enabled then SetNoSmoke(true) end
    
    -- No Flash
    if _G.Mod_NoFlash_Enabled then SetNoFlash(true) end
    
    -- No Water
    if _G.Mod_NoWater_Enabled then SetNoWater(true) end
    
    -- No Trees
    if _G.Mod_NoTrees_Enabled then SetNoTrees(true) end
    
    -- No Fog
    if _G.Mod_NoFog_Enabled then SetFogRemoval(true) end
    
    -- Full Bright
    if _G.Mod_FullBright_Enabled then SetFullBright(true) end
    
    -- No Grass (Built-in)
    if _G.Mod_NoGrass_Enabled then
        ExecuteConsoleCommand("grass.DensityScale", "0")
        ExecuteConsoleCommand("grass.DiscardDataOnLoad", "1")
        ExecuteConsoleCommand("foliage.DensityScale", "0")
    end
    
    -- FPS 165
    if _G.Mod_FPS165_Enabled then
        ExecuteConsoleCommand("t.MaxFPS", "165")
        ExecuteConsoleCommand("r.FrameRateLimit", "165")
    end
    
    -- Anti-Aliasing
    if _G.Mod_AntiAliasing_Enabled then
        ExecuteConsoleCommand("r.AntiAliasing", "1")
    end
    
    -- Frame Limit
    if _G.Mod_FrameLimit and _G.Mod_FrameLimit > 0 then
        ExecuteConsoleCommand("t.MaxFPS", tostring(_G.Mod_FrameLimit))
        ExecuteConsoleCommand("r.FrameRateLimit", tostring(_G.Mod_FrameLimit))
    end
end

-- ==================== GAMEPLAY FEATURES ====================
function ApplyGameplayMods()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        
        -- God Mode
        if _G.Mod_GodMode_Enabled then
            char.Health = 9999
            char.HealthMax = 9999
        end
        
        -- Infinite Health
        if _G.Mod_InfiniteHealth_Enabled then
            char.Health = 9999
        end
        
        -- One Hit Kill
        if _G.Mod_OneHitKill_Enabled then
            local weapon = char:GetCurrentWeapon()
            if slua.isValid(weapon) then
                weapon.Damage = 9999
            end
        end
        
        -- No Self Damage
        if _G.Mod_NoSelfDamage_Enabled then
            char.FallDamageMultiplier = 0
            char.ExplosionDamageMultiplier = 0
        end
        
        -- Infinite Oxygen
        if _G.Mod_InfiniteOxygen_Enabled then
            char.Oxygen = 9999
        end
        
        -- No Team Damage
        if _G.Mod_NoTeamDamage_Enabled then
            char.TeamDamageMultiplier = 0
        end
        
        -- Instant Death (no bleed out)
        if _G.Mod_InstantDeath_Enabled then
            char.BleedTime = 0.01
        end
        
        -- Fast Revive
        if _G.Mod_FastRevive_Enabled then
            char.ReviveTime = 0.01
        end
    end)
end

-- ==================== AUTO FEATURES ====================
function ApplyAutoFeatures()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        
        -- Auto Heal
        if _G.Mod_AutoHeal_Enabled then
            local health = char.Health or 0
            local maxHealth = char.HealthMax or 100
            if health < maxHealth * 0.5 then
                local items = char:GetInventory()
                if items then
                    for i = 1, items:Num() do
                        local item = items:Get(i-1)
                        if slua.isValid(item) then
                            local itemId = item:GetItemID()
                            if itemId == 105001 or itemId == 105002 or itemId == 105003 then -- Med kits
                                char:UseItem(item)
                                break
                            end
                        end
                    end
                end
            end
        end
        
        -- Auto Pickup
        if _G.Mod_AutoPickup_Enabled then
            local items = char:GetNearbyItems()
            if items then
                for i = 1, items:Num() do
                    local item = items:Get(i-1)
                    if slua.isValid(item) then
                        local itemId = item:GetItemID()
                        -- Pickup weapons, ammo, armor
                        if itemId > 100000 and itemId < 200000 then
                            char:PickupItem(item)
                        end
                    end
                end
            end
        end
        
        -- Auto Reload
        if _G.Mod_AutoReload_Enabled then
            local weapon = char:GetCurrentWeapon()
            if slua.isValid(weapon) then
                local ammo = weapon:GetCurrentAmmo()
                local maxAmmo = weapon:GetMaxAmmo()
                if ammo < maxAmmo * 0.1 then
                    weapon:Reload()
                end
            end
        end
        
        -- Auto Prone
        if _G.Mod_AutoProne_Enabled then
            local health = char.Health or 0
            if health < 30 then
                char:Prone()
            end
        end
        
        -- Auto Run
        if _G.Mod_AutoRun_Enabled then
            char:SetForwardInput(1.0)
        end
        
        -- Auto Jump
        if _G.Mod_AutoJump_Enabled then
            if char:IsOnGround() then
                char:Jump()
            end
        end
    end)
end

-- ==================== NO BOTS ====================
function RemoveBots()
    if not _G.Mod_NoBots_Enabled then return end
    pcall(function()
        local allPawns = Game:GetAllPlayerPawns() or {}
        for _, p in pairs(allPawns) do
            if slua.isValid(p) then
                local isBot = Game:IsAI(p)
                if isBot then
                    p:Destroy()
                end
            end
        end
    end)
end

-- ==================== MASS KILL ====================
function MassKill()
    if not _G.Mod_MassKill_Enabled then return end
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        
        local allPawns = Game:GetAllPlayerPawns() or {}
        local myTeam = char.TeamID or 0
        
        for _, p in pairs(allPawns) do
            if slua.isValid(p) and p ~= char and (p.TeamID or 0) ~= myTeam then
                p.Health = 0
                p:Kill()
            end
        end
    end)
end

-- ==================== HUD TOGGLE ====================
function ToggleHUD()
    if _G.Mod_NoHUD_Enabled then
        pcall(function()
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            if slua.isValid(pc) then
                local hud = pc:GetHUD()
                if slua.isValid(hud) then
                    hud:SetVisibility(false)
                end
            end
        end)
    else
        pcall(function()
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            if slua.isValid(pc) then
                local hud = pc:GetHUD()
                if slua.isValid(hud) then
                    hud:SetVisibility(true)
                end
            end
        end)
    end
end

-- ==================== SKIN SYSTEM ====================
local BASE_PATH = "/storage/emulated/0/Android/data/com.pubg.imobile/files/"
local CONFIG_PATH = BASE_PATH .. "config.ini"

local WEAPON_NAME_TO_ID = {
    AKM=101001,M16A4=101002,SCAR=101003,M416=101004,GROZA=101005,AUG=101006,QBZ=101007,M762=101008,
    MK47=101009,G36C=101010,HoneyBadger=101012,ASM=101101,FAMAS=101100,ACE32=101102,
    UZI=102001,UMP=102002,Vector=102003,Bizon=102005,MP5K=102007,P90=102105,
    Kar98=103001,M24=103002,AWM=103003,SKS=103004,VSS=103005,Mini14=103006,MK14=103007,
    SLR=103009,QBU=103010,MK12=103100,AMR=103012,DSR=103102,Mosin=103013,
    S12K=104003,DBS=104004,S1897=104001,S686=104002,
    M249=105001,DP28=105002,MG3=105010,
    Pan=108004,Machete=108001,Crowbar=108002,Sickle=108003,
}

function ReadLiveConfig()
    pcall(function()
        local f = io.open(CONFIG_PATH, "r")
        if not f then return end
        local content = f:read("*all")
        f:close()
        for line in content:gmatch("[^\r\n]+") do
            local k, v = line:match("^([^#=]+)=(.+)$")
            if k and v then
                k = k:gsub("^%s+", ""):gsub("%s+$", "")
                local val = tonumber(v)
                if val then
                    if k == "Suit" then _G.OutfitMap.Suit = val
                    elseif k == "Hat" then _G.OutfitMap.Hat = val
                    elseif k == "Mask" then _G.OutfitMap.Mask = val
                    elseif k == "Glasses" then _G.OutfitMap.Glasses = val
                    elseif k == "Pants" then _G.OutfitMap.Pants = val
                    elseif k == "Shoes" then _G.OutfitMap.Shoes = val
                    elseif k == "Bag" then _G.OutfitMap.Bag = val
                    elseif k == "Helmet" then _G.OutfitMap.Helmet = val
                    elseif k == "Armor" then _G.OutfitMap.Armor = val
                    elseif k == "Parachute" then _G.OutfitMap.Parachute = val
                    elseif k == "Pet" then _G.OutfitMap.Pet = val
                    else
                        local weaponId = WEAPON_NAME_TO_ID[k]
                        if weaponId then _G.WeaponSkinMap[weaponId] = val end
                    end
                end
            end
        end
    end)
end

_G.get_skin_id = function(weaponID)
    if not weaponID or weaponID == 0 then return nil end
    local mapped = _G.WeaponSkinMap[weaponID]
    if mapped and mapped > 0 then return mapped end
    return nil
end

function ApplySkins()
    if not _G.Mod_Skin_Enabled then return end
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not slua.isValid(pc) then return end
        local char = pc:GetPlayerCharacterSafety()
        if not slua.isValid(char) then return end
        
        -- Apply outfit
        local ac = char:getAvatarComponent2()
        if slua.isValid(ac) and ac.NetAvatarData then
            local applyData = ac.NetAvatarData.SlotSyncData
            if slua.isValid(applyData) then
                for i = 0, applyData:Num() - 1 do
                    local eq = applyData:Get(i)
                    if eq and eq.ItemId ~= 0 then
                        local target = 0
                        if eq.SlotID == 5 and _G.OutfitMap.Suit then target = _G.OutfitMap.Suit
                        elseif eq.SlotID == 8 and _G.OutfitMap.Bag then target = _G.OutfitMap.Bag
                        elseif eq.SlotID == 9 and _G.OutfitMap.Helmet then target = _G.OutfitMap.Helmet end
                        if target and target ~= 0 and eq.ItemId ~= target then
                            eq.ItemId = target
                            applyData:Set(i, eq)
                        end
                    end
                end
            end
        end
        
        -- Apply weapon skins
        local wm = char:GetWeaponManager()
        if slua.isValid(wm) then
            for i = 1, 3 do
                local wpn = wm:GetInventoryWeaponByPropSlot(i)
                if slua.isValid(wpn) then
                    local target = _G.get_skin_id(wpn:GetWeaponID())
                    if target and target > 0 then
                        if wpn.synData then
                            local data = wpn.synData:Get(7)
                            if data and data.defineID then
                                data.defineID.TypeSpecificID = target
                                wpn.synData:Set(7, data)
                            end
                        end
                    end
                end
            end
        end
    end)
end

ReadLiveConfig()

-- ==================== MAIN TIMER LOOP ====================
local function MainLoop()
    pcall(function()
        -- Weapon Mods
        ApplyWeaponMods()
        
        -- Vehicle Mods
        ApplyVehicleMods()
        
        -- Visual Mods
        ApplyVisualMods()
        
        -- Gameplay Mods
        ApplyGameplayMods()
        
        -- Auto Features
        ApplyAutoFeatures()
        
        -- Remove Bots
        RemoveBots()
        
        -- Mass Kill (only when enabled)
        if _G.Mod_MassKill_Enabled then MassKill() end
        
        -- Toggle HUD
        ToggleHUD()
        
        -- Apply Skins
        ApplySkins()
        
        -- Scene configs
        if _G.ESPConfig.BlackSky then SetBlackSky(true) end
        if _G.ESPConfig.RemoveFog then SetFogRemoval(true) end
        if _G.ESPConfig.RemoveGrass then SetGrassRemoval(true) end
        if _G.ESPConfig.RemoveTree then SetTreeRemoval(true) end
        if _G.ESPConfig.RemoveWater then SetWaterRemoval(true) end
        if _G.ESPConfig.ForceChinese then SetForceChinese(true) end
        if _G.Mod_Rain_Enabled then SetRainEnabled(true) end
        if _G.Mod_Snow_Enabled then SetSnowEnabled(true) end
        
        -- iPad View
        if _G.Mod_iPadView_Enabled then
            pcall(function()
                local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                if slua.isValid(pc) then
                    local char = pc:GetPlayerCharacterSafety()
                    if slua.isValid(char) then
                        local cam = char.ThirdPersonCameraComponent
                        if slua.isValid(cam) then
                            cam.FieldOfView = _G.Mod_iPadViewDistance or 90
                        end
                    end
                end
            end)
        end
    end)
end

-- Start main loop
pcall(function()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) then
        if _G._MainLoopTimer then pc:RemoveGameTimer(_G._MainLoopTimer) end
        _G._MainLoopTimer = pc:AddGameTimer(0.05, true, MainLoop)
    end
end)

-- ==================== MENU SYSTEM ====================
_G.InitModMenuTab = function()
    local LocUtil = _G.LocUtil
    if not LocUtil and package.loaded["client.common.LocUtil"] then
        LocUtil = require("client.common.LocUtil")
    end
    if LocUtil and not LocUtil._IsModMenuHooked then
        local old_get = LocUtil.GetLocalizeResStr
        LocUtil.GetLocalizeResStr = function(id)
            if type(id) == "string" and not tonumber(id) then return id end
            return old_get(id)
        end
        LocUtil._IsModMenuHooked = true
    end

    local SettingPageDefine = require("client.logic.NewSetting.SettingPageDefine")
    local SettingCatalog = require("client.logic.NewSetting.SettingCatalog")
    local AliasMap = require("client.slua.umg.NewSetting.Item.AliasMap")

    if not SettingPageDefine.ModMenu then
        local ModMenuStack = {
            { UI = AliasMap.Title, Text = "TRNDRAVIX ELITE" },
            
            -- === AIMBOT ===
            {
                Key = "ModMenu_Aimbot",
                UI = AliasMap.TitleSwitcher,
                Text = "AIMBOT",
                GetFunc = function() return _G.Mod_Aimbot_Enabled end,
                SetFunc = function(_, v) _G.Mod_Aimbot_Enabled = v; return true end
            },
            {
                Key = "ModMenu_AimbotStrength",
                UI = AliasMap.Slider,
                Text = "Aim Strength (1-100%)",
                GetFunc = function() return _G.Mod_AimbotStrength / 100 end,
                SetFunc = function(_, v) _G.Mod_AimbotStrength = v * 100; return true end
            },
            {
                Key = "ModMenu_AimbotBone",
                UI = AliasMap.DropDown,
                Text = "Aim Bone",
                Options = {"Head","Chest","Spine","Legs"},
                GetFunc = function() return _G.Mod_AimbotBone end,
                SetFunc = function(_, v) _G.Mod_AimbotBone = v; return true end
            },
            {
                Key = "ModMenu_AimbotSmooth",
                UI = AliasMap.Switcher,
                Text = "Smooth Aim",
                GetFunc = function() return _G.Mod_AimbotSmooth end,
                SetFunc = function(_, v) _G.Mod_AimbotSmooth = v; return true end
            },
            
            -- === ESP ===
            { UI = AliasMap.Title, Text = "--- ESP FEATURES ---" },
            {
                Key = "ModMenu_ESP",
                UI = AliasMap.TitleSwitcher,
                Text = "ESP (ENABLE)",
                GetFunc = function() return _G.Mod_ESP_Enabled end,
                SetFunc = function(_, v) _G.Mod_ESP_Enabled = v; return true end
            },
            {
                Key = "ModMenu_BoxESP",
                UI = AliasMap.Switcher,
                Text = "Box ESP",
                GetFunc = function() return _G.Mod_BoxESP_Enabled end,
                SetFunc = function(_, v) _G.Mod_BoxESP_Enabled = v; return true end
            },
            {
                Key = "ModMenu_HealthBarESP",
                UI = AliasMap.Switcher,
                Text = "Health Bar",
                GetFunc = function() return _G.Mod_HealthBarESP_Enabled end,
                SetFunc = function(_, v) _G.Mod_HealthBarESP_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NameESP",
                UI = AliasMap.Switcher,
                Text = "Name ESP",
                GetFunc = function() return _G.Mod_NameESP_Enabled end,
                SetFunc = function(_, v) _G.Mod_NameESP_Enabled = v; return true end
            },
            {
                Key = "ModMenu_WeaponESP",
                UI = AliasMap.Switcher,
                Text = "Weapon ESP",
                GetFunc = function() return _G.Mod_WeaponESP_Enabled end,
                SetFunc = function(_, v) _G.Mod_WeaponESP_Enabled = v; return true end
            },
            {
                Key = "ModMenu_EnemyCountESP",
                UI = AliasMap.Switcher,
                Text = "Enemy Count",
                GetFunc = function() return _G.Mod_EnemyCountESP_Enabled end,
                SetFunc = function(_, v) _G.Mod_EnemyCountESP_Enabled = v; return true end
            },
            
            -- === CHAMS ===
            { UI = AliasMap.Title, Text = "--- CHAMS COLORS ---" },
            {
                Key = "ModMenu_GreenColor",
                UI = AliasMap.Switcher,
                Text = "Green (Visible)",
                GetFunc = function() return _G.Mod_Chams_GreenEnabled end,
                SetFunc = function(_, v) _G.Mod_Chams_GreenEnabled = v; return true end
            },
            {
                Key = "ModMenu_YellowColor",
                UI = AliasMap.Switcher,
                Text = "Yellow (Hidden)",
                GetFunc = function() return _G.Mod_Chams_YellowEnabled end,
                SetFunc = function(_, v) _G.Mod_Chams_YellowEnabled = v; return true end
            },
            
            -- === WALLHACK ===
            { UI = AliasMap.Title, Text = "--- WALLHACK ---" },
            {
                Key = "ModMenu_Wallhack",
                UI = AliasMap.TitleSwitcher,
                Text = "WALLHACK",
                GetFunc = function() return _G.Mod_Wallhack_Enabled end,
                SetFunc = function(_, v) _G.Mod_Wallhack_Enabled = v; return true end
            },
            {
                Key = "ModMenu_Glow",
                UI = AliasMap.Switcher,
                Text = "Glow Effect",
                GetFunc = function() return _G.Mod_Glow_Enabled end,
                SetFunc = function(_, v) _G.Mod_Glow_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoSmoke",
                UI = AliasMap.Switcher,
                Text = "No Smoke",
                GetFunc = function() return _G.Mod_NoSmoke_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoSmoke_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoFlash",
                UI = AliasMap.Switcher,
                Text = "No Flash",
                GetFunc = function() return _G.Mod_NoFlash_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoFlash_Enabled = v; return true end
            },
            
            -- === MOVEMENT ===
            { UI = AliasMap.Title, Text = "--- MOVEMENT ---" },
            {
                Key = "ModMenu_SpeedBoost",
                UI = AliasMap.TitleSwitcher,
                Text = "Speed Boost",
                GetFunc = function() return _G.Mod_SpeedBoost_Enabled end,
                SetFunc = function(_, v) _G.Mod_SpeedBoost_Enabled = v; return true end
            },
            {
                Key = "ModMenu_SpeedPercent",
                UI = AliasMap.Slider,
                Text = "Speed % (100-500)",
                GetFunc = function() return (_G.Mod_SpeedPercent - 100) / 400 end,
                SetFunc = function(_, v) _G.Mod_SpeedPercent = 100 + (v * 400); return true end
            },
            {
                Key = "ModMenu_FlyHack",
                UI = AliasMap.TitleSwitcher,
                Text = "Fly Hack",
                GetFunc = function() return _G.Mod_FlyHack_Enabled end,
                SetFunc = function(_, v) _G.Mod_FlyHack_Enabled = v; return true end
            },
            {
                Key = "ModMenu_SuperJump",
                UI = AliasMap.TitleSwitcher,
                Text = "Super Jump",
                GetFunc = function() return _G.Mod_SuperJump_Enabled end,
                SetFunc = function(_, v) _G.Mod_SuperJump_Enabled = v; return true end
            },
            {
                Key = "ModMenu_JumpHeight",
                UI = AliasMap.Slider,
                Text = "Jump Height (1-10x)",
                GetFunc = function() return (_G.Mod_JumpHeight - 1) / 9 end,
                SetFunc = function(_, v) _G.Mod_JumpHeight = 1 + (v * 9); return true end
            },
            {
                Key = "ModMenu_NoFallDamage",
                UI = AliasMap.Switcher,
                Text = "No Fall Damage",
                GetFunc = function() return _G.Mod_NoFallDamage_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoFallDamage_Enabled = v; return true end
            },
            {
                Key = "ModMenu_ClimbHack",
                UI = AliasMap.Switcher,
                Text = "Climb Hack",
                GetFunc = function() return _G.Mod_ClimbHack_Enabled end,
                SetFunc = function(_, v) _G.Mod_ClimbHack_Enabled = v; return true end
            },
            {
                Key = "ModMenu_InfiniteSprint",
                UI = AliasMap.Switcher,
                Text = "Infinite Sprint",
                GetFunc = function() return _G.Mod_InfiniteSprint_Enabled end,
                SetFunc = function(_, v) _G.Mod_InfiniteSprint_Enabled = v; return true end
            },
            
            -- === WEAPONS ===
            { UI = AliasMap.Title, Text = "--- WEAPONS ---" },
            {
                Key = "ModMenu_NoRecoil",
                UI = AliasMap.TitleSwitcher,
                Text = "No Recoil",
                GetFunc = function() return _G.Mod_NoRecoil_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoRecoil_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoSpread",
                UI = AliasMap.Switcher,
                Text = "No Spread",
                GetFunc = function() return _G.Mod_NoSpread_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoSpread_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoSway",
                UI = AliasMap.Switcher,
                Text = "No Sway",
                GetFunc = function() return _G.Mod_NoSway_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoSway_Enabled = v; return true end
            },
            {
                Key = "ModMenu_InstantReload",
                UI = AliasMap.Switcher,
                Text = "Instant Reload",
                GetFunc = function() return _G.Mod_InstantReload_Enabled end,
                SetFunc = function(_, v) _G.Mod_InstantReload_Enabled = v; return true end
            },
            {
                Key = "ModMenu_InfiniteAmmo",
                UI = AliasMap.Switcher,
                Text = "Infinite Ammo",
                GetFunc = function() return _G.Mod_InfiniteAmmo_Enabled end,
                SetFunc = function(_, v) _G.Mod_InfiniteAmmo_Enabled = v; return true end
            },
            {
                Key = "ModMenu_SuperBullet",
                UI = AliasMap.TitleSwitcher,
                Text = "Super Bullet",
                GetFunc = function() return _G.Mod_SuperBullet_Enabled end,
                SetFunc = function(_, v) _G.Mod_SuperBullet_Enabled = v; return true end
            },
            {
                Key = "ModMenu_BulletCount",
                UI = AliasMap.Slider,
                Text = "Bullets/Shot (1-20)",
                GetFunc = function() return (_G.Mod_BulletCount - 1) / 19 end,
                SetFunc = function(_, v) _G.Mod_BulletCount = math.floor(1 + (v * 19)); return true end
            },
            {
                Key = "ModMenu_SuperFireRate",
                UI = AliasMap.TitleSwitcher,
                Text = "Super Fire Rate",
                GetFunc = function() return _G.Mod_SuperFireRate_Enabled end,
                SetFunc = function(_, v) _G.Mod_SuperFireRate_Enabled = v; return true end
            },
            {
                Key = "ModMenu_MegaDamage",
                UI = AliasMap.Switcher,
                Text = "Mega Damage (1-Hit Kill)",
                GetFunc = function() return _G.Mod_MegaDamage_Enabled end,
                SetFunc = function(_, v) _G.Mod_MegaDamage_Enabled = v; return true end
            },
            {
                Key = "ModMenu_AutoFire",
                UI = AliasMap.Switcher,
                Text = "Auto Fire",
                GetFunc = function() return _G.Mod_AutoFire_Enabled end,
                SetFunc = function(_, v) _G.Mod_AutoFire_Enabled = v; return true end
            },
            
            -- === VEHICLES ===
            { UI = AliasMap.Title, Text = "--- VEHICLES ---" },
            {
                Key = "ModMenu_VehicleSpeed",
                UI = AliasMap.TitleSwitcher,
                Text = "Vehicle Speed",
                GetFunc = function() return _G.Mod_VehicleSpeed_Enabled end,
                SetFunc = function(_, v) _G.Mod_VehicleSpeed_Enabled = v; return true end
            },
            {
                Key = "ModMenu_VehicleSpeedMult",
                UI = AliasMap.Slider,
                Text = "Speed Multiplier (1-5x)",
                GetFunc = function() return (_G.Mod_VehicleSpeedMult - 1) / 4 end,
                SetFunc = function(_, v) _G.Mod_VehicleSpeedMult = 1 + (v * 4); return true end
            },
            {
                Key = "ModMenu_VehicleFly",
                UI = AliasMap.Switcher,
                Text = "Vehicle Fly",
                GetFunc = function() return _G.Mod_VehicleFly_Enabled end,
                SetFunc = function(_, v) _G.Mod_VehicleFly_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoVehicleDamage",
                UI = AliasMap.Switcher,
                Text = "No Vehicle Damage",
                GetFunc = function() return _G.Mod_NoVehicleDamage_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoVehicleDamage_Enabled = v; return true end
            },
            {
                Key = "ModMenu_InfiniteFuel",
                UI = AliasMap.Switcher,
                Text = "Infinite Fuel",
                GetFunc = function() return _G.Mod_InfiniteFuel_Enabled end,
                SetFunc = function(_, v) _G.Mod_InfiniteFuel_Enabled = v; return true end
            },
            {
                Key = "ModMenu_VehicleNoFlip",
                UI = AliasMap.Switcher,
                Text = "Vehicle No Flip",
                GetFunc = function() return _G.Mod_VehicleNoFlip_Enabled end,
                SetFunc = function(_, v) _G.Mod_VehicleNoFlip_Enabled = v; return true end
            },
            
            -- === GAMEPLAY ===
            { UI = AliasMap.Title, Text = "--- GAMEPLAY ---" },
            {
                Key = "ModMenu_AutoHeal",
                UI = AliasMap.TitleSwitcher,
                Text = "Auto Heal",
                GetFunc = function() return _G.Mod_AutoHeal_Enabled end,
                SetFunc = function(_, v) _G.Mod_AutoHeal_Enabled = v; return true end
            },
            {
                Key = "ModMenu_AutoPickup",
                UI = AliasMap.Switcher,
                Text = "Auto Pickup",
                GetFunc = function() return _G.Mod_AutoPickup_Enabled end,
                SetFunc = function(_, v) _G.Mod_AutoPickup_Enabled = v; return true end
            },
            {
                Key = "ModMenu_AutoReload",
                UI = AliasMap.Switcher,
                Text = "Auto Reload",
                GetFunc = function() return _G.Mod_AutoReload_Enabled end,
                SetFunc = function(_, v) _G.Mod_AutoReload_Enabled = v; return true end
            },
            {
                Key = "ModMenu_AutoRun",
                UI = AliasMap.Switcher,
                Text = "Auto Run",
                GetFunc = function() return _G.Mod_AutoRun_Enabled end,
                SetFunc = function(_, v) _G.Mod_AutoRun_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoBots",
                UI = AliasMap.Switcher,
                Text = "Remove Bots",
                GetFunc = function() return _G.Mod_NoBots_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoBots_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoTeamDamage",
                UI = AliasMap.Switcher,
                Text = "No Team Damage",
                GetFunc = function() return _G.Mod_NoTeamDamage_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoTeamDamage_Enabled = v; return true end
            },
            {
                Key = "ModMenu_FastRevive",
                UI = AliasMap.Switcher,
                Text = "Fast Revive",
                GetFunc = function() return _G.Mod_FastRevive_Enabled end,
                SetFunc = function(_, v) _G.Mod_FastRevive_Enabled = v; return true end
            },
            
            -- === RISKY FEATURES ===
            { UI = AliasMap.Title, Text = "--- RISKY FEATURES ---" },
            {
                Key = "ModMenu_GodMode",
                UI = AliasMap.TitleSwitcher,
                Text = "GOD MODE",
                GetFunc = function() return _G.Mod_GodMode_Enabled end,
                SetFunc = function(_, v) _G.Mod_GodMode_Enabled = v; return true end
            },
            {
                Key = "ModMenu_OneHitKill",
                UI = AliasMap.TitleSwitcher,
                Text = "ONE HIT KILL",
                GetFunc = function() return _G.Mod_OneHitKill_Enabled end,
                SetFunc = function(_, v) _G.Mod_OneHitKill_Enabled = v; return true end
            },
            {
                Key = "ModMenu_SpinBot",
                UI = AliasMap.TitleSwitcher,
                Text = "SPIN BOT",
                GetFunc = function() return _G.Mod_SpinBot_Enabled end,
                SetFunc = function(_, v) _G.Mod_SpinBot_Enabled = v; return true end
            },
            {
                Key = "ModMenu_AntiGravity",
                UI = AliasMap.Switcher,
                Text = "Anti-Gravity",
                GetFunc = function() return _G.Mod_AntiGravity_Enabled end,
                SetFunc = function(_, v) _G.Mod_AntiGravity_Enabled = v; return true end
            },
            {
                Key = "ModMenu_MassKill",
                UI = AliasMap.TitleSwitcher,
                Text = "MASS KILL (Instant)",
                GetFunc = function() return _G.Mod_MassKill_Enabled end,
                SetFunc = function(_, v) _G.Mod_MassKill_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoClip",
                UI = AliasMap.TitleSwitcher,
                Text = "NO CLIP",
                GetFunc = function() return _G.Mod_NoClip_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoClip_Enabled = v; return true end
            },
            
            -- === VISUAL ===
            { UI = AliasMap.Title, Text = "--- VISUAL ---" },
            {
                Key = "ModMenu_FPS165",
                UI = AliasMap.Switcher,
                Text = "165 FPS",
                GetFunc = function() return _G.Mod_FPS165_Enabled end,
                SetFunc = function(_, v) _G.Mod_FPS165_Enabled = v; return true end
            },
            {
                Key = "ModMenu_iPadView",
                UI = AliasMap.Switcher,
                Text = "iPad View",
                GetFunc = function() return _G.Mod_iPadView_Enabled end,
                SetFunc = function(_, v) _G.Mod_iPadView_Enabled = v; return true end
            },
            {
                Key = "ModMenu_iPadViewDistance",
                UI = AliasMap.Slider,
                Text = "FOV (80-140)",
                GetFunc = function() return (_G.Mod_iPadViewDistance - 80) / 60 end,
                SetFunc = function(_, v) _G.Mod_iPadViewDistance = 80 + (v * 60); return true end
            },
            {
                Key = "ModMenu_NoHUD",
                UI = AliasMap.Switcher,
                Text = "No HUD",
                GetFunc = function() return _G.Mod_NoHUD_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoHUD_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoGrass",
                UI = AliasMap.Switcher,
                Text = "No Grass",
                GetFunc = function() return _G.Mod_NoGrass_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoGrass_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoTrees",
                UI = AliasMap.Switcher,
                Text = "No Trees",
                GetFunc = function() return _G.Mod_NoTrees_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoTrees_Enabled = v; return true end
            },
            {
                Key = "ModMenu_NoFog",
                UI = AliasMap.Switcher,
                Text = "No Fog",
                GetFunc = function() return _G.Mod_NoFog_Enabled end,
                SetFunc = function(_, v) _G.Mod_NoFog_Enabled = v; return true end
            },
            {
                Key = "ModMenu_Rain",
                UI = AliasMap.Switcher,
                Text = "Rain Effect",
                GetFunc = function() return _G.Mod_Rain_Enabled end,
                SetFunc = function(_, v) _G.Mod_Rain_Enabled = v; return true end
            },
            {
                Key = "ModMenu_Snow",
                UI = AliasMap.Switcher,
                Text = "Snow Effect",
                GetFunc = function() return _G.Mod_Snow_Enabled end,
                SetFunc = function(_, v) _G.Mod_Snow_Enabled = v; return true end
            },
            {
                Key = "ModMenu_FullBright",
                UI = AliasMap.Switcher,
                Text = "Full Bright",
                GetFunc = function() return _G.Mod_FullBright_Enabled end,
                SetFunc = function(_, v) _G.Mod_FullBright_Enabled = v; return true end
            },
            
            -- === SKINS ===
            { UI = AliasMap.Title, Text = "--- SKINS ---" },
            {
                Key = "ModMenu_Skin",
                UI = AliasMap.TitleSwitcher,
                Text = "ENABLE SKINS",
                GetFunc = function() return _G.Mod_Skin_Enabled end,
                SetFunc = function(_, v) _G.Mod_Skin_Enabled = v; return true end
            },
            
            -- === SCENE ===
            { UI = AliasMap.Title, Text = "--- SCENE ---" },
            {
                Key = "ModMenu_BlackSky",
                UI = AliasMap.Switcher,
                Text = "Black Sky",
                GetFunc = function() return _G.ESPConfig.BlackSky end,
                SetFunc = function(_, v) _G.ESPConfig.BlackSky = v; return true end
            },
            {
                Key = "ModMenu_RemoveFog",
                UI = AliasMap.Switcher,
                Text = "Remove Fog",
                GetFunc = function() return _G.ESPConfig.RemoveFog end,
                SetFunc = function(_, v) _G.ESPConfig.RemoveFog = v; return true end
            },
            {
                Key = "ModMenu_RemoveGrass",
                UI = AliasMap.Switcher,
                Text = "Remove Grass",
                GetFunc = function() return _G.ESPConfig.RemoveGrass end,
                SetFunc = function(_, v) _G.ESPConfig.RemoveGrass = v; return true end
            },
            {
                Key = "ModMenu_RemoveTree",
                UI = AliasMap.Switcher,
                Text = "Remove Trees",
                GetFunc = function() return _G.ESPConfig.RemoveTree end,
                SetFunc = function(_, v) _G.ESPConfig.RemoveTree = v; return true end
            },
            {
                Key = "ModMenu_RemoveWater",
                UI = AliasMap.Switcher,
                Text = "Remove Water",
                GetFunc = function() return _G.ESPConfig.RemoveWater end,
                SetFunc = function(_, v) _G.ESPConfig.RemoveWater = v; return true end
            },
            {
                Key = "ModMenu_ForceChinese",
                UI = AliasMap.Switcher,
                Text = "Force Chinese",
                GetFunc = function() return _G.ESPConfig.ForceChinese end,
                SetFunc = function(_, v) _G.ESPConfig.ForceChinese = v; return true end
            },
        }
        
        SettingPageDefine.ModMenu = {
            Key = "ModMenu",
            loc = "TRNDRAVIX ELITE",
            UIKey = "Setting_Page_Privacy",
            Category = {{ Key = "ModMenu_Main", loc = "ALL FEATURES", Stack = ModMenuStack }}
        }
        table.insert(SettingCatalog, SettingPageDefine.ModMenu)
    end

    local UIManager = _G.UIManager
    if UIManager and not UIManager._IsModMenuHooked then
        local old_ShowUI = UIManager.ShowUI
        UIManager.ShowUI = function(config, ...)
            local args = {...}
            if config and config.keyName and (string.find(string.lower(config.keyName), "setting_main") or string.find(string.lower(config.keyName), "setting")) then
                local catalog = args[1]
                if catalog and (type(catalog) == "table" or type(catalog) == "userdata") then
                    local hasModMenu = false
                    local newCatalog = {}
                    for _, page in ipairs(catalog) do
                        table.insert(newCatalog, page)
                        if page.Key == "ModMenu" then hasModMenu = true end
                    end
                    if not hasModMenu then table.insert(newCatalog, SettingPageDefine.ModMenu) end
                    args[1] = newCatalog
                end
            end
            return old_ShowUI(config, table.unpack(args))
        end
        UIManager._IsModMenuHooked = true
    end
end

-- ==================== WELCOME POPUP ====================
function _G.TryShowWelcome()
    pcall(function()
        local Msg = package.loaded["client.slua.logic.common.logic_common_msg_box"]
        if not Msg then Msg = require("client.slua.logic.common.logic_common_msg_box") end
        local Web = require("client.slua.logic.url.logic_webview_sdk")
        local function onClick() if Web then Web:OpenURL("https://t.me/TrnDravix") end end
        if Msg and Msg.Show then
            Msg.Show(4, "TRNDRAVIX ELITE ULTIMATE",
            "\n» Developer  : @TrnDravix\n" ..
            "» Status     : ONLINE & ACTIVE\n" ..
            "» Features   : 150+ Functions\n" ..
            "» Protection : 5-Layer Shield\n" ..
            "» Build      : PREMIUM LOADED\n\n" ..
            "» ALL FEATURES ACTIVATED ✓\n" ..
            "» MENU: Settings → TrnDravix\n" ..
            "» Tap to Connect Developer", onClick)
        end
        _G.WelcomeShown = true
    end)
end

-- ==================== INITIALIZE ====================
pcall(function()
    applyNetworkBlocker()
    applyFullCRCFaker()
    
    -- Apply all bypasses
    pcall(function()
        if _G.TssSDK then
            _G.TssSDK.Init = noop
            _G.TssSDK.Start = noop
            _G.TssSDK.Verify = retTrue
            _G.TssSDK.CheckIntegrity = retTrue
            _G.TssSDK.Check = retTrue
        end
    end)
    
    -- Initialize menu
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) and pc.AddGameTimer then
        pc:AddGameTimer(2.0, false, function() pcall(_G.InitModMenuTab) end)
    else
        pcall(_G.InitModMenuTab)
    end
    
    -- Show welcome
    pcall(_G.TryShowWelcome)
    
    print("[TRNDRAVIX] ✅ ELITE ULTIMATE LOADED WITH 150+ FEATURES")
    print("[TRNDRAVIX] ✅ ALL BYPASSES ACTIVE")
    print("[TRNDRAVIX] ✅ OPEN SETTINGS → TRNDRAVIX MENU")
end)

-- ================================================================
-- TRNDRAVIX ELITE ULTIMATE - COMPLETE SCRIPT END
-- ================================================================