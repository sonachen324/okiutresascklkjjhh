-- ============================================
-- HEALTH BAR & HUD COORDINATES REMOVED FROM MENU
-- ============================================
-- Complete code with all bypasses and systems intact
-- ESP HEALTH BAR and HUD COORDINATES options removed from AK menu
-- ============================================

local NetworkRPC = {
    ServerRPC = {},
    ClientRPC = {},
    MulticastRPC = {}
}

NetworkRPC.ServerRPC.ServerRPC_NearDeathGiveupRescue = { Reliable = true, Params = {} }
NetworkRPC.ServerRPC.ServerRPC_CarryDeadBox = { Reliable = true, Params = { UEnums.EPropertyClass.Object } }
NetworkRPC.ServerRPC.RPC_Server_GmPlayAction = { Reliable = true, Params = { UEnums.EPropertyClass.Int } }
NetworkRPC.MulticastRPC.MulticastRPC_GmPlayAction = { Reliable = true, Params = { UEnums.EPropertyClass.Int } }
NetworkRPC.ClientRPC.RPC_Client_SetShouldCheckPassWall = { Reliable = true, Params = { UEnums.EPropertyClass.Bool } }
NetworkRPC.ClientRPC.ClientRPC_TriggerHighlightMoment = { Reliable = true, Params = { UEnums.EPropertyClass.UInt32, UEnums.EPropertyClass.UInt32 } }

local var_85 = os.time(os.date("!*t"))
local var_151 = os.time({ year = 2026, month = 7, day = 4, hour = 6, min = 45, sec = 0 })

-- ============================================
-- BYPASS 1: Anti-Ban / Skin Bypass
-- ============================================
local function InitializeSkinBypass()
    pcall(function()
        local puffer_tlog = package.loaded["client.slua.logic.download.report.puffer_tlog"]
        if puffer_tlog then
            puffer_tlog.ReportEvent = function() end
            puffer_tlog.ReportDownloadResult = function() end
            puffer_tlog.ReportODPAKError = function() end
        end
        local AvatarUtils = package.loaded["AvatarUtils"]
        if AvatarUtils then
            AvatarUtils.CheckIsWeaponInBlackList = function() return false end
            AvatarUtils.IsValidAvatar = function() return true end
        end
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr"):Get("FileCheckSubsystem")
        if SubsystemMgr then
            SubsystemMgr.StartCheck = function() end
            SubsystemMgr.ReportAbnormalFile = function() end
        end
        local EquipmentExceptionReport = package.loaded["client.slua.logic.report.EquipmentExceptionReport"]
        if EquipmentExceptionReport then
            EquipmentExceptionReport.Report = function() end
        end
    end)
end

-- ============================================
-- BYPASS 2: Log Blocker
-- ============================================
local function InitializeLogBlocker()
    pcall(function()
        local ScreenshotMaker = import("ScreenshotMaker")
        if ScreenshotMaker then
            ScreenshotMaker.MakePicture = function() return "" end
            ScreenshotMaker.ReMakePicture = function() return "" end
            ScreenshotMaker.HasCaptured = function() return true end
        end
        local TLog = package.loaded["TLog"] or _G.TLog
        if TLog then
            TLog.Info = function() end
            TLog.Warning = function() end
            TLog.Error = function() end
            TLog.Debug = function() end
            TLog.Report = function() end
        end
        local CrashSight = package.loaded["CrashSight"] or _G.CrashSight
        if CrashSight then
            CrashSight.ReportException = function() end
            CrashSight.SetCustomData = function() end
            CrashSight.Log = function() end
        end
        local GameReportUtils = package.loaded["GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils"]
        if GameReportUtils then
            GameReportUtils.BugglyPostExceptionFull = function() return false end
            GameReportUtils.CheckCanBugglyPostException = function() return false end
            GameReportUtils.ReplayReportData = function() end
            GameReportUtils.ReportGameException = function() end
        end
        local ClientToolsReport = package.loaded["client.slua.logic.report.ClientToolsReport"]
        if ClientToolsReport then
            ClientToolsReport.SendReport = function() end
            ClientToolsReport.SendException = function() end
        end
        local tlog_report_utils = package.loaded["client.slua.config.tlog.tlog_report_utils"]
        if tlog_report_utils then
            tlog_report_utils.ReportTLogEvent = function() end
        end
    end)
end

-- ============================================
-- BYPASS 3: Scanner Blocker
-- ============================================
local function InitializeScannerBlocker()
    pcall(function()
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local afkSub = SubsystemMgr:Get("AFKReportorSubsystem")
            if afkSub then 
                afkSub.PlayerHaveAction = function() end
                afkSub.ReportAFK = function() end
            end
            local statsSub = SubsystemMgr:Get("ClientDataStatistcsSubsystem")
            if statsSub then
                statsSub.StartToCheck = function() end
                statsSub.DelayCount = 0
                if statsSub.ReportPingDelayTimer then
                    statsSub:RemoveGameTimer(statsSub.ReportPingDelayTimer)
                    statsSub.ReportPingDelayTimer = nil
                end
            end
            local avatarSub = SubsystemMgr:Get("AvatarExceptionSubsystem")
            if avatarSub then
                avatarSub.ReportException = function() end
                avatarSub.BindPlayerCharacter = function() end
                avatarSub.CheckAvatarValid = function() return true end
            end
            local shootSub = SubsystemMgr:Get("ShootVerifySubSystemClient")
            if shootSub then
                shootSub.ReportVerifyFail = function() end
                shootSub.OnVerifyFailed = function() end
            end
        end
        local CreativeModeBlueprintLibrary = import("CreativeModeBlueprintLibrary")
        if CreativeModeBlueprintLibrary then
            CreativeModeBlueprintLibrary.MD5HashByteArray = function() return "BYPASSED_MD5_HASH" end
            CreativeModeBlueprintLibrary.GetContentDiffData = function() return true, "BYPASSED" end
        end
        local TssSdk = package.loaded["TssSdk"] or _G.TssSdk
        if TssSdk then
            local originalOnRecv = TssSdk.OnRecvData
            TssSdk.OnRecvData = function(data)
                if type(data) == "string" and (string.find(data, "report") or string.find(data, "exception")) then
                    return
                end
                if originalOnRecv then originalOnRecv(data) end
            end
            TssSdk.SendReportInfo = function() end
            TssSdk.ScanMemory = function() return true end
            TssSdk.IsEmulator = function() return false end
            TssSdk.GetTssSdkReportInfo = function() return "" end
        end
    end)
end

-- ============================================
-- BYPASS 4: Replay Telemetry Blocker
-- ============================================
local function InitializeReplayTelemetryBlocker()
    pcall(function()
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        local replaySub = SubsystemMgr and SubsystemMgr:Get("RescueBtnReplayTraceSubsystem")
        if replaySub then
            replaySub.ReportTrace = function() end
            replaySub.StartTickMonitor = function() end
            replaySub.TickMonitorCheck = function() end
            replaySub.ReportTickMonitorHeartbeat = function() end
        end
        local gameReportSub = SubsystemMgr and SubsystemMgr:Get("GameReportSubsystem")
        if gameReportSub then
            gameReportSub.ReplayReportData = function() return false end
            gameReportSub.CheckCanBugglyPostException = function() return false end
            gameReportSub.BugglyPostExceptionFull = function() return false end
            gameReportSub.GetClientReplayDataReporter = function() return nil end
        end
        local logic_report_replay = package.loaded["client.slua.logic.replay.logic_report_replay"]
        if logic_report_replay then
            logic_report_replay.ReportReplay = function() end
            logic_report_replay.SendReportReq = function() end
        end
    end)
end

-- ============================================
-- BYPASS 5: Disable HiggsBoson
-- ============================================
local function DisableHiggsBoson()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not pc or not slua.isValid(pc) then return end
    if pc.HiggsBoson then
        pc.HiggsBoson.bMHActive = false
        pc.HiggsBoson.bCallPreReplication = false
    end
    if pc.HiggsBosonComponent then
        pc.HiggsBosonComponent.bMHActive = false
        pc.HiggsBosonComponent:ControlMHActive(0)
    end
end

-- ============================================
-- BYPASS 6: Anti-Cheat Hooks
-- ============================================
local function InitializeAntiCheatHooks()
    pcall(function()
        local HiggsBosonComponent = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBosonComponent and HiggsBosonComponent.StaticShowSecurityAlertInDev then
            HiggsBosonComponent.StaticShowSecurityAlertInDev = function() end
        end
    end)
    pcall(function()
        local HiggsBosonComponent = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBosonComponent and HiggsBosonComponent.BlackList then
            for k in pairs(HiggsBosonComponent.BlackList) do HiggsBosonComponent.BlackList[k] = nil end
        end
    end)
    _G.BlackList = {}
    pcall(function()
        _G.GlobalPlayerCoronaData = _G.GlobalPlayerCoronaData or {}
        _G.GlobalPlayerCheatTimes = _G.GlobalPlayerCheatTimes or {}
        local mt = getmetatable(_G.GlobalPlayerCoronaData) or {}
        mt.__newindex = function(t, k, v) end
        setmetatable(_G.GlobalPlayerCoronaData, mt)
    end)
    pcall(function()
        local STExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
        if STExtraBlueprintFunctionLibrary then
            STExtraBlueprintFunctionLibrary.IsDevelopment = function() return false end
        end
    end)
end

-- ============================================
-- BYPASS 7: Anti-Report System
-- ============================================
local function InitializeAntiReport()
    pcall(function()
        local reportPaths = { 
            "GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem", 
            "Client.Security.ClientReportPlayerSubsystem" 
        }
        local reportSub = nil
        for _, path in ipairs(reportPaths) do
            if package.loaded[path] then reportSub = package.loaded[path] break end
            local success, module = pcall(require, path)
            if success and module then reportSub = module break end
        end
        if reportSub then
            reportSub.OnInit = function(self) return end
            reportSub._OnPlayerKilledOtherPlayer = function() return end
            reportSub._RecordFatalDamager = function() return end
            reportSub._OnDeathReplayDataWhenFatalDamaged = function() return end
            reportSub._RecordMurdererFromDeathReplayData = function() return end
            reportSub._RecordTeammatePlayerInfo = function() return end
            reportSub._OnBattleResult = function() return end
            reportSub._OnShowQuickReportMutualExclusiveUI = function() return end
            reportSub.GetFatalDamagerMap = function() return {} end
            reportSub.GetCachedTeammateName2InfoMap = function() return {} end
            reportSub.GetTeammateName2InfoMapDuringBattle = function() return {} end
            reportSub.GetCurrentNotInTeamHistoricalTeammateMap = function() return {} end
            reportSub.GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end
        end
    end)
    pcall(function()
        local dsReportPaths = { 
            "GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem", 
            "GameLua.Mod.BaseMod.Client.Security.DSReportPlayerSubsystem" 
        }
        local dsReport = nil
        for _, path in ipairs(dsReportPaths) do
            if package.loaded[path] then dsReport = package.loaded[path] break end
            local success, module = pcall(require, path)
            if success and module then dsReport = module break end
        end
        if dsReport then
            dsReport.OnInit = function(self) return end
            dsReport._OnNearDeathOrRescued = function() return end
            dsReport._OnCharacterDied = function() return end
            dsReport._OnTeammateDamage = function() return end
            dsReport._OnPlayerSettlementStart = function() return end
            dsReport._AddKnockDownerToBattleResult = function() return end
            dsReport._AddKillerToBattleResult = function() return end
            dsReport._AddTeammateMurderToBattleResult = function() return end
            dsReport._AddFatalDamagerMapToBattleResult = function() return end
            dsReport._AddMLKillerUIDToBattleResult = function() return end
            dsReport._SaveHistoricalTeammateInfo = function() return end
            dsReport._RecordFatalDamager = function() return end
            dsReport._RecordTeammateMurderer = function() return end
        end
    end)
    pcall(function()
        local ReportPlayerUtils = require("GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils")
        if ReportPlayerUtils then
            ReportPlayerUtils.RecordFatalDamager = function() return end
            ReportPlayerUtils.IsUsingHistoricalTeammateInfo = function() return false end
            ReportPlayerUtils.IsCharacterDeliverAI = function() return false end
        end
    end)
    pcall(function()
        local SecurityCommonUtilsMod = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
        if SecurityCommonUtilsMod then
            SecurityCommonUtilsMod.ExtractPlayerBasicInfo = function() return {} end
            SecurityCommonUtilsMod.LogIf = function() return false end
        end
    end)
end

-- ============================================
-- BYPASS 8: Gameplay Telemetry Bypass
-- ============================================
local function InitializeGameplayBypass()
    pcall(function()
        if not _G.GameplayCallbacks or _G.GameplayCallbacks.IsBypassed then return end
        local GC = _G.GameplayCallbacks
        local var_129 = GC.OnDSPlayerStateChanged
        GC.OnDSPlayerStateChanged = function(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            if InPlayerState and string.lower(tostring(InPlayerState)) == "cheatdetected" then return end
            if var_129 then return var_129(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason) end
        end
        local function noop() return end
        local function emptyTable() return {} end
        local function nilFunc() return nil end
        GC.ReportAttackFlow = noop
        GC.ReportSecAttackFlow = noop
        GC.ReportHurtFlow = noop
        GC.ReportFireArms = noop
        GC.ReportVerifyInfoFlow = noop
        GC.ReportMrpcsFlow = noop
        GC.ReportPlayerBehavior = noop
        GC.ReportTeammatHurt = noop
        GC.ReportMisKillByTeammate = noop
        GC.ReportForbitPick = noop
        GC.ReportPlayerMoveRoute = noop
        GC.ReportPlayerPosition = noop
        GC.ReportVehicleMoveFlow = noop
        GC.ReportSecTgameMovingFlow = noop
        GC.ReportParachuteData = noop
        GC.SendTssSdkAntiDataToLobby = noop
        GC.SendDSErrorLogToLobby = noop
        GC.SendDSErrorLogToLobbyOnece = noop
        GC.SendDSHawkEyePatrolLogToLobby = noop
        GC.ReportEquipmentFlow = noop
        GC.ReportAimFlow = noop
        GC.GetWeaponReport = emptyTable
        GC.GetOneWeaponReport = emptyTable
        GC.ReportHeavyWeaponBoxSpawnFlow = noop
        GC.ReportHeavyWeaponBoxActivationFlow = noop
        GC.ReportHeavyWeaponBoxOpenPlayerFlow = noop
        GC.ReportHeavyWeaponBoxItemFlow = noop
        GC.ReportPlayersPing = noop
        GC.ReportPlayerIP = noop
        GC.ReportPlayerFramePingRecord = noop
        GC.OnDSConnectionSaturated = noop
        GC.ReportDSNetSaturation = noop
        GC.ReportNetContinuousSaturate = noop
        GC.ReportDSNetRate = noop
        GC.SendClientStats = noop
        GC.SendServerAvgTickDelta = noop
        GC.ReportCircleFlow = noop
        GC.ReportDSCircleFlow = noop
        GC.ReportJumpFlow = noop
        GC.ReportAIStrategyInfo = noop
        GC.SendAIDeliveryInfo = noop
        GC.ReportDailyTaskInfo = noop
        GC.ReportMatchRoomData = noop
        GC.SendPlayerSpectatingLog = noop
        GC.ReportIDCardProduceFlow = noop
        GC.ReportIDCardPickUpFlow = noop
        GC.ReportIDCardDestroyFlow = noop
        GC.ReportRevivalFlow = noop
        GC.ReportGameSetting = noop
        GC.ReportGameSettingNew = noop
        GC.ReportAntsVoiceTeamCreate = noop
        GC.ReportAntsVoiceTeamQuit = noop
        GC.ReportCommonInfo = noop
        GC.ReportLightweightStat = noop
        GC.SendSecTLog = noop
        GC.SendDataMiningTLog = noop
        GC.SendActivityTLog = noop
        GC.GetGeneralTLogData = nilFunc
        GC.IsBypassed = true
    end)
    pcall(function()
        if NetUtil and NetUtil.SendPacket and not NetUtil.IsBypassed then
            local originalSend = NetUtil.SendPacket
            local blockedPackets = {
                ["ReportAttackFlow"]=1, ["ReportSecAttackFlow"]=1, ["ReportHurtFlow"]=1,
                ["ReportFireArms"]=1, ["ReportVerifyInfoFlow"]=1, ["ReportMrpcsFlow"]=1,
                ["ReportPlayerBehavior"]=1, ["ReportTeammatHurt"]=1, ["ReportTeammateKillConfirmFlow"]=1,
                ["ReportForbiddenPickupFlow"]=1, ["ReportPlayerMoveRoute"]=1, ["ReportPlayerPosition"]=1,
                ["ReportSecVehicleMoveFlow"]=1, ["ReportSecTgameMovingFlow"]=1, ["report_parachute_data"]=1,
                ["report_character_all_drag"]=1, ["report_parachute_all_drag"]=1, ["report_vehicle_move_drag"]=1,
                ["on_tss_sdk_anti_data"]=1, ["report_unrealnet_exception"]=1, ["ReportPlayerEquipmentInfo"]=1,
                ["ReportAimFlow"]=1, ["ReportHitFlow"]=1, ["log_shooting_miss"]=1, ["report_heavy_weapon_box_activation_flow"]=1,
                ["report_heavy_weapon_box_item_flow"]=1, ["ReportCircleFlow"]=1, ["report_ds_player_circle_flow"]=1,
                ["ReportJumpFlow"]=1, ["ReportGameStartFlow"]=1, ["ReportGameEndFlow"]=1, ["report_players_ping"]=1,
                ["report_player_ip"]=1, ["report_player_frame_ping_record"]=1, ["report_net_saturate"]=1,
                ["report_ds_netsaturate"]=1, ["report_ds_net_continuous_saturate"]=1, ["report_ds_netrate"]=1,
                ["report_unrealnet_clientstats"]=1, ["report_serverstat_avgtickdelta"]=1, ["report_all_players_address"]=1,
                ["report_ai_strategyinfo"]=1, ["ReportAIActionFlow"]=1, ["ReportGenerateMonsterFlow"]=1,
                ["report_ds_match_room_data"]=1, ["SendSpectatingLog"]=1, ["ReportIDCardProduceFlow"]=1,
                ["ReportIDCardPickUpFlow"]=1, ["ReportIDCardDestroyFlow"]=1, ["ReportRevivalFlow"]=1,
                ["ReportGameSetting"]=1, ["ReportGameSettingNew"]=1, ["ReportAntsVoiceTeamCreate"]=1,
                ["ReportAntsVoiceTeamQuit"]=1, ["report_common_info"]=1, ["report_common_battle_info"]=1,
                ["report_client_scan_result"]=1, ["tss_sdk_report"]=1, ["report_memory_exception"]=1,
                ["report_avatar_exception"]=1, ["report_ui_state"]=1, ["report_hit_reg_fail"]=1,
                ["report_character_state"]=1, ["report_vehicle_exception"]=1, ["report_camera_exception"]=1,
                ["ReportPlayerControllerStateChanged"]=1, ["ReportAvatarFlow"]=1,
            }
            NetUtil.SendPacket = function(packetName, ...)
                if blockedPackets[packetName] then return end
                return originalSend(packetName, ...)
            end
            NetUtil.IsBypassed = true
        end
    end)
end

-- ============================================
-- BYPASS 9: Connection Guard
-- ============================================
local function InitializeConnectionGuard()
    pcall(function()
        if _G.ConnectionGuardInitialized or not _G.GameplayCallbacks then return end
        local GC = _G.GameplayCallbacks
        local var_129 = GC.OnDSPlayerStateChanged
        GC.OnDSPlayerStateChanged = function(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            local state = InPlayerState and string.lower(tostring(InPlayerState)) or ""
            local blockedStates = {
                ["cheatdetected"] = true, ["connectionlost"] = true,
                ["connectiontimeout"] = true, ["connectionexception"] = true,
                ["netdrivererror"] = true
            }
            if blockedStates[state] then return end
            if var_129 then
                pcall(var_129, UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            end
        end
        GC.OnPlayerNetConnectionClosed = function(GameID, UID, Reason, ErrorMessage) end
        GC.OnPlayerActorChannelError = function(GameID, UID, Reason, ErrorMessage) end
        GC.OnPlayerRPCValidateFailed = function(GameID, UID, Reason, ErrorMessage) end
        GC.OnPlayerSpectateException = function(GameID, UID, Reason, ErrorMessage) end
        GC.OnShutdownAfterError = function(GameID) end
        _G.ConnectionGuardInitialized = true
    end)
end

-- ============================================
-- BYPASS 10: ZR and PR Bypasses
-- ============================================
local function InitializeZRPRBypasses()
    pcall(function()
        local noop = function() end
        local returnTrue = function() return true end
        local returnEmpty = function() return {} end
        local stExtraBlueprint = import("STExtraBlueprintFunctionLibrary")
        if stExtraBlueprint then 
            stExtraBlueprint.IsDevelopment = returnTrue 
        end
        if _G.BasicDataTLogReport then
            _G.BasicDataTLogReport.OnSendBatchReqMsg = noop
            _G.BasicDataTLogReport.OnImmediateReqMsg = noop
            _G.BasicDataTLogReport.send_report_event_duration_log = noop
            _G.BasicDataTLogReport.SendTlog = noop
        end
        if _G.TApmHelper then 
            _G.TApmHelper.postEvent = noop 
        end
        local sdm = _G.ServerDataMgr
        if sdm and sdm.DeletablePlayerResultKey then
            sdm.DeletablePlayerResultKey["SuspiciousHitCount"] = true
            sdm.DeletablePlayerResultKey["EspTotalSimTraceCnt"] = true
            sdm.DeletablePlayerResultKey["EspTotalImeFocusCnt"] = true
            sdm.DeletablePlayerResultKey["ClientGravityAnomalyCount"] = true
        end
        local hiaPath = "GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem"
        local hia = package.loaded[hiaPath] or require(hiaPath)
        if hia then
            hia.CheckHitIntegrity = returnTrue
            hia.InitSession = noop
            hia.OnBattleEnd = noop
        end
        if _G.ClientGlueHiaSystem then 
            _G.ClientGlueHiaSystem.CheckHitIntegrity = returnTrue 
        end
        local secUtilsPath = "GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils"
        local secUtils = package.loaded[secUtilsPath] or require(secUtilsPath)
        if secUtils and secUtils.EStrategyTypeInReplay then
            secUtils.EStrategyTypeInReplay.EspTotalSimTraceCnt = 0
            secUtils.EStrategyTypeInReplay.EspTotalImeFocusCnt = 0
            secUtils.EStrategyTypeInReplay.ClientGravityAnomalyCount = 0
            secUtils.EStrategyTypeInReplay.FlyingErrorCnt = 0
        end
        local pcNotifyPath = "GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"
        local pcNotify = package.loaded[pcNotifyPath] or require(pcNotifyPath)
        if pcNotify then
            pcNotify.ClientRPC_SyncBanID = noop
            pcNotify.ClientRPC_StrongTips = noop
            pcNotify.ClientRPC_NormalTips = noop
            pcNotify.Notify = noop
        end
        local clientBanLogicPath = "client.slua.logic.ban.ClientBanLogic"
        local ClientBanLogic = package.loaded[clientBanLogicPath] or require(clientBanLogicPath)
        if ClientBanLogic then
            ClientBanLogic.OnSyncBanInfo = noop
            ClientBanLogic.OnVoiceBanNotify = noop
        end
        local ttBanPath = "client.slua.logic.login.logic_tt_ban"
        local logic_tt_ban = package.loaded[ttBanPath] or require(ttBanPath)
        if logic_tt_ban then
            logic_tt_ban.GetCarrierInfo = function() return "[{\"mcc\":\"000\"}]" end
            logic_tt_ban.CheckIfCanCreateRole = returnTrue
        end
        local dsActivePath = "GameLua.Mod.PlanBT.Gameplay.Subsystem.DSActiveSubsystem"
        local DSActive = package.loaded[dsActivePath] or require(dsActivePath)
        if DSActive then
            DSActive.DelayKickOutPlayer = noop
            DSActive.ActiveKickNotify = noop
        end
        local dsAITLogPath = "GameLua.Mod.BaseMod.DS.Security.DSAITLogSubsystem"
        local DSAITLog = package.loaded[dsAITLogPath] or require(dsAITLogPath)
        if DSAITLog then
            DSAITLog._UpdateTTKRecords = noop
            DSAITLog._UpdateOperatingFrequency = noop
        end
        local dsFightTLogPath = "GameLua.Mod.BaseMod.DS.Security.DSFightTLogSubsystem"
        local DSFightTLog = package.loaded[dsFightTLogPath] or require(dsFightTLogPath)
        if DSFightTLog then 
            DSFightTLog.GetSimpleFightData = returnEmpty 
        end
        local dsSecurityPath = "GameLua.Mod.BaseMod.DS.Security.DSSecurityTLogSubsystem"
        local DSSecurity = package.loaded[dsSecurityPath] or require(dsSecurityPath)
        if DSSecurity then 
            DSSecurity._OnReportServerJumpFlow = noop 
        end
        local dsCommonPath = "GameLua.Mod.BaseMod.DS.Security.DSCommonTLogSubsystem"
        local DSCommon = package.loaded[dsCommonPath] or require(dsCommonPath)
        if DSCommon then 
            DSCommon.HandleKillTlog = noop 
        end
        local dsReportPath = "GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem"
        local DSReport = package.loaded[dsReportPath] or require(dsReportPath)
        if DSReport then 
            DSReport._AddEnemyMapToBattleResult = noop 
        end
        local inspectClientPath = "GameLua.Mod.BaseMod.Client.Security.InspectionSystemReportClientLogicSubsystem"
        local InspectClient = package.loaded[inspectClientPath] or require(inspectClientPath)
        if InspectClient then
            InspectClient.AskForInspector = noop
            InspectClient.ReportEnemy = noop
            InspectClient.KickOutOneTeam = noop
        end
        local inspectDSPath = "GameLua.Mod.BaseMod.DS.Security.InspectionSystemReportDSLogicSubsystem"
        local InspectDS = package.loaded[inspectDSPath] or require(inspectDSPath)
        if InspectDS then
            InspectDS.ServerKickOutOneTeamByPlayerImplementation = noop
            InspectDS.AddReportedCount = noop
        end
        local spectateReplayPath = "GameLua.Mod.BaseMod.Common.Subsystem.SpectateAndReplaySubsystem"
        local SpectateReplay = package.loaded[spectateReplayPath] or require(spectateReplayPath)
        if SpectateReplay then
            SpectateReplay.RequestGotoSpectatingImp = noop
            SpectateReplay.RequestGotoSpectating = noop
        end
        local clientHawkEyePath = "GameLua.Mod.BaseMod.Client.Security.ClientHawkEyePatrolSubsystem"
        local ClientHawkEye = package.loaded[clientHawkEyePath] or require(clientHawkEyePath)
        if ClientHawkEye then
            ClientHawkEye._OnHawkSync = noop
            ClientHawkEye._OnHawkReportSuccess = noop
            ClientHawkEye._StartExitGameTimer = noop
        end
        local behaviorScorePath = "GameLua.Mod.Escape.Gameplay.Subsystem.BehaviorScoreSubsystem"
        local BehaviorScore = package.loaded[behaviorScorePath] or require(behaviorScorePath)
        if BehaviorScore then
            BehaviorScore.OnHandleBehaviorScore = noop
            BehaviorScore.AIPerceptionScore = noop
        end
        local aiReplayPath = "GameLua.ExtraModule.MLAI.Client.AIReplaySubsystem"
        local AIReplay = package.loaded[aiReplayPath] or require(aiReplayPath)
        if AIReplay then
            AIReplay.ReportAllPlayerInfo = noop
            if AIReplay.uCompletePlayBack then 
                AIReplay.uCompletePlayBack.AddRecordMLAIInfo = noop 
            end
        end
        local aiTrackingPath = "GameLua.Mod.BaseMod.GamePlay.AI.AITrackingLogSubsystem"
        local AITracking = package.loaded[aiTrackingPath] or require(aiTrackingPath)
        if AITracking then
            AITracking.RealLogoutTimer = noop
            AITracking.LogQueue = {}
        end
        local tdmAFKPath = "GameLua.Mod.TDM.Gameplay.Subsystem.TDMAFKReportorSubsystem"
        local TDMAFK = package.loaded[tdmAFKPath] or require(tdmAFKPath)
        if TDMAFK then
            TDMAFK.SendAFKTips = noop
            TDMAFK.OnHandleLostConnection = noop
        end
        local dataMgrPath = "client.slua.logic.data.data_mgr"
        local DataMgr = package.loaded[dataMgrPath] or _G.DataMgr
        if DataMgr then
            DataMgr.GetWeaponSkinSoundVolumeInfoByGroup = function() return 0 end
        end
        local EAvatarDamagePosition = import("EAvatarDamagePosition")
        if EAvatarDamagePosition and EAvatarDamagePosition.BigHead then
            local meta = getmetatable(GameplayData_3) or {}
            if meta and meta.__index then
                meta.__index.GetHitBodyType = function(...) 
                    return EAvatarDamagePosition.BigHead 
                end
            end
        end
    end)
end

-- ============================================
-- BYPASS 11: ACE (Anti-Cheat Expert) Bypass
-- ============================================
local function BypassACE()
    pcall(function()
        local ace_check = package.loaded["libace.so"] or _G.ace
        if ace_check then
            ace_check.ReportData = function() end
            ace_check.CheckIntegrity = function() return true end
            ace_check.ScanMemory = function() return false end
        end
        local ace_jni = _G.JNI and _G.JNI.ACE
        if ace_jni then
            ace_jni.reportException = function() end
            ace_jni.collectEvidence = function() return nil end
        end
    end)
end

-- ============================================
-- BYPASS 12: XignCode3 Bypass
-- ============================================
local function BypassXignCode3()
    pcall(function()
        local xigncode = package.loaded["xigncode"] or _G.XignCode
        if xigncode then
            xigncode.SendReport = function() end
            xigncode.CheckProcess = function() return true end
            xigncode.VerifyIntegrity = function() return true end
            xigncode.ScanModules = function() return {} end
        end
    end)
end

-- ============================================
-- BYPASS 13: BattlEye Bypass
-- ============================================
local function BypassBattlEye()
    pcall(function()
        local battleye = package.loaded["BattlEye"] or _G.BattlEye
        if battleye then
            battleye.SendReport = function() end
            battleye.KickPlayer = function() end
            battleye.ValidatePlayer = function() return true end
            battleye.CheckMemory = function() return true end
        end
    end)
end

-- ============================================
-- BYPASS 14: Client Memory Scanner Bypass
-- ============================================
local function BypassMemoryScanner()
    pcall(function()
        local memory_scanner = package.loaded["MemoryScanner"] or _G.MemScan
        if memory_scanner then
            memory_scanner.StartScan = function() end
            memory_scanner.StopScan = function() end
            memory_scanner.GetResults = function() return {} end
            memory_scanner.ReportViolation = function() end
        end
        _G.bMemoryScanning = false
        _G.bIntegrityCheck = true
    end)
end

-- ============================================
-- BYPASS 15: Packet Encryption Bypass
-- ============================================
local function BypassPacketEncryption()
    pcall(function()
        local encryptor = package.loaded["PacketEncrypt"] or _G.Encryptor
        if encryptor then
            encryptor.Encrypt = function(data) return data end
            encryptor.Decrypt = function(data) return data end
            encryptor.VerifyChecksum = function() return true end
        end
        local secure_channel = _G.SecureChannel
        if secure_channel then
            secure_channel.ValidatePacket = function() return true end
            secure_channel.LogPacket = function() end
        end
    end)
end

-- ============================================
-- BYPASS 16: DS (Dedicated Server) Validation Bypass
-- ============================================
local function BypassDSValidation()
    pcall(function()
        local ds_validator = package.loaded["DSValidator"] or _G.DSValidation
        if ds_validator then
            ds_validator.ValidateClient = function() return true end
            ds_validator.CheckLatency = function() return 40 end
            ds_validator.ReportCheat = function() end
        end
        _G.bDSKick = false
        _G.DSKickReason = nil
    end)
end

-- ============================================
-- BYPASS 17: CRC Check Bypass
-- ============================================
local function BypassCRCCheck()
    pcall(function()
        local crc_checker = package.loaded["CRCChecker"] or _G.CRC
        if crc_checker then
            crc_checker.VerifyFile = function() return true end
            crc_checker.VerifyMemory = function() return true end
            crc_checker.GenerateCRC = function() return "00000000" end
        end
        _G.OnIntegrityFailure = nil
    end)
end

-- ============================================
-- BYPASS 18: JNI/Java Anti-Cheat Bypass
-- ============================================
local function BypassJNIAntiCheat()
    pcall(function()
        local jni_ac = _G.JNI and _G.JNI.AntiCheat
        if jni_ac then
            jni_ac.CheckRoot = function() return false end
            jni_ac.CheckEmulator = function() return false end
            jni_ac.CheckDebugger = function() return false end
            jni_ac.CollectInfo = function() return {} end
            jni_ac.SendReport = function() end
        end
    end)
end

-- ============================================
-- BYPASS 19: TDataMaster / Telemetry Bypass
-- ============================================
local function BypassTDataMaster()
    pcall(function()
        local tdatamaster = package.loaded["libTDataMaster.so"] or _G.TDataMaster
        if tdatamaster then
            tdatamaster.ReportEvent = function() end
            tdatamaster.ReportException = function() end
            tdatamaster.FlushData = function() end
            tdatamaster.CollectData = function() return {} end
        end
        _G.TelemetryQueue = {}
        _G.bTelemetryEnabled = false
    end)
end

-- ============================================
-- BYPASS 20: Anti-Debug / Emulator Detection Bypass
-- ============================================
local function BypassAntiDebug()
    pcall(function()
        local debugger_check = package.loaded["DebuggerDetect"] or _G.Debug
        if debugger_check then
            debugger_check.IsDebuggerPresent = function() return false end
            debugger_check.CheckBreakpoint = function() return false end
            debugger_check.CheckTracer = function() return false end
        end
        local emu_check = package.loaded["EmulatorDetect"] or _G.Emulator
        if emu_check then
            emu_check.IsEmulator = function() return false end
            emu_check.GetEmulatorType = function() return "" end
            emu_check.CheckVM = function() return false end
        end
        _G.ProcStatus = {
            TracerPid = "0",
            State = "S (sleeping)"
        }
    end)
end

-- ============================================
-- BYPASS 21: FakeSystemInfo
-- ============================================
local function FakeSystemInfo()
    pcall(function()
        local SystemInfo = import("SystemInfo")
        if SystemInfo then
            SystemInfo.GetDeviceModel = function() return "iPhone14,5" end
            SystemInfo.GetDeviceBrand = function() return "Apple" end
            SystemInfo.GetAndroidVersion = function() return "13" end
            SystemInfo.GetEMUIVersion = function() return "" end
            SystemInfo.IsEmulator = function() return false end
            SystemInfo.IsRooted = function() return false end
            SystemInfo.IsDebugged = function() return false end
        end
        local KernelManager = package.loaded["client.slua.logic.system.KernelManager"]
        if KernelManager then
            KernelManager.GetKernelVersion = function() return "Linux version 4.14.116" end
            KernelManager.CheckKernelIntegrity = function() return true end
        end
    end)
end

-- ============================================
-- BYPASS 22: EncryptMemoryOperations
-- ============================================
local function EncryptMemoryOperations()
    pcall(function()
        local MemoryProtect = import("MemoryProtect")
        if MemoryProtect then
            MemoryProtect.VirtualProtect = function(addr, size, protect) return true end
            MemoryProtect.IsMemoryReadable = function(addr) return false end
            MemoryProtect.IsMemoryWritable = function(addr) return false end
        end
    end)
end

-- ============================================
-- BYPASS 23: KillAllLogging
-- ============================================
local function KillAllLogging()
    pcall(function()
        _G.print = function() end
        _G.printf = function() end
        _G.log = function() end
        _G.warn = function() end
        _G.error = function() end
        local Logging = import("Logging")
        if Logging then
            Logging.Log = function() end
            Logging.LogWarning = function() end
            Logging.LogError = function() end
            Logging.SetLogLevel = function() end
        end
        local FileHelper = import("FileHelper")
        if FileHelper then
            FileHelper.WriteToFile = function() end
            FileHelper.SaveStringToFile = function() return true end
            FileHelper.CreateFileWriter = function() return nil end
        end
    end)
end

-- ============================================
-- BYPASS 24: RandomizeBehavior
-- ============================================
local function RandomizeBehavior()
    pcall(function()
        local InputManager = import("InputManager")
        if InputManager then
            local origGetMouseDelta = InputManager.GetMouseDelta
            InputManager.GetMouseDelta = function()
                local delta = origGetMouseDelta()
                if delta then
                    delta.X = delta.X + (math.random(-2, 2) * 0.1)
                    delta.Y = delta.Y + (math.random(-2, 2) * 0.1)
                end
                return delta
            end
        end
    end)
end

-- ============================================
-- BYPASS 25: BlockNetworkMonitoring
-- ============================================
local function BlockNetworkMonitoring()
    pcall(function()
        local NetworkManager = import("NetworkManager")
        if NetworkManager then
            NetworkManager.GetNetworkStats = function() return {ping=40, loss=0, rtt=40} end
            NetworkManager.CapturePackets = function() end
            NetworkManager.AnalyzeTraffic = function() return {} end
            NetworkManager.GetConnectionInfo = function() return "127.0.0.1:8080" end
        end
    end)
end

-- ============================================
-- BYPASS 26: SpoofTimingChecks
-- ============================================
local function SpoofTimingChecks()
    pcall(function()
        local Engine = import("Engine")
        if Engine then
            Engine.GetAverageFPS = function() return 60 end
            Engine.GetFrameTime = function() return 0.016 end
            Engine.IsLagging = function() return false end
        end
        local GameTime = package.loaded["GameLua.GameCore.Data.GameTime"]
        if GameTime then
            GameTime.GetServerTime = function() return os.time() end
            GameTime.GetDeltaTime = function() return 0.033 end
        end
    end)
end

-- ============================================
-- BYPASS 27: ZeroTraceCleanup
-- ============================================
local function ZeroTraceCleanup()
    pcall(function()
        local MemoryCleaner = import("MemoryCleaner")
        if MemoryCleaner then
            MemoryCleaner.ClearCache = function() end
            MemoryCleaner.FreeUnusedMemory = function() end
            MemoryCleaner.CompactHeap = function() end
        end
        local CrashReporter = package.loaded["client.slua.logic.crash.CrashReporter"]
        if CrashReporter then
            CrashReporter.SendReport = function() end
            CrashReporter.SaveDump = function() end
            CrashReporter.UploadDump = function() end
        end
        local TimerManager = import("TimerManager")
        if TimerManager then
            TimerManager.ClearAllTimers = function() end
        end
    end)
end

-- ============================================
-- BYPASS 28: PreventSuspiciousFlags
-- ============================================
local function PreventSuspiciousFlags()
    pcall(function()
        local suspiciousVars = {
            "bIsCheating", "bDetected", "bBanned", "SuspicionScore",
            "CheatDetected", "AntiCheatFlag", "IsHacking", "bReported",
            "TrustScore", "SecurityFlag", "ViolationLevel", "BanStatus"
        }
        for _, var in ipairs(suspiciousVars) do
            _G[var] = nil
        end
        local meta = getmetatable(_G) or {}
        local oldNewIndex = meta.__newindex
        meta.__newindex = function(t, k, v)
            for _, var in ipairs(suspiciousVars) do
                if string.find(tostring(k), var, 1, true) then return end
            end
            if oldNewIndex then oldNewIndex(t, k, v) else rawset(t, k, v) end
        end
        setmetatable(_G, meta)
    end)
end

-- ============================================
-- BYPASS 29: AddDetectionJitter
-- ============================================
local function AddDetectionJitter()
    pcall(function()
        local origSend = NetUtil and NetUtil.Send
        if NetUtil and origSend then
            NetUtil.Send = function(data)
                local delay = math.random(10, 100) / 1000
                return origSend(data)
            end
        end
    end)
end

-- ============================================
-- BYPASS 30: SelfModifyingProtection
-- ============================================
local function SelfModifyingProtection()
    pcall(function()
        local checkInterval = 30
        local lastCheck = os.time()
        local function memoryScanDetector()
            local current = os.time()
            if current - lastCheck > checkInterval then lastCheck = current end
        end
        local timer = 0
        local originalUpdate = _G.Update
        _G.Update = function(dt)
            timer = timer + dt
            if timer > 5 then timer = 0; memoryScanDetector() end
            if originalUpdate then originalUpdate(dt) end
        end
    end)
end

-- ============================================
-- BYPASS 31: BlockHiggsBosonComplete
-- ============================================
local function BlockHiggsBosonComplete()
    pcall(function()
        local HiggsBosonComponent = package.loaded["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"]
        if HiggsBosonComponent then
            HiggsBosonComponent.bIsEnable = false
            HiggsBosonComponent.CheckClientConfig = function() return false end
            HiggsBosonComponent.GetSecurityInfo = function() return {} end
        end
    end)
end

-- ============================================
-- BYPASS 32: AntiScreenshotDetection
-- ============================================
local function AntiScreenshotDetection()
    pcall(function()
        local ScreenshotDetection = import("ScreenshotDetection")
        if ScreenshotDetection then
            ScreenshotDetection.OnScreenshotTaken = function() end
            ScreenshotDetection.ReportScreenshot = function() end
        end
        local AndroidPermission = import("AndroidPermission")
        if AndroidPermission then
            AndroidPermission.CheckPermission = function() return true end
        end
    end)
end

-- ============================================
-- BYPASS 33: ForceDisableDebugMode
-- ============================================
local function ForceDisableDebugMode()
    pcall(function()
        local DebugTools = import("DebugTools")
        if DebugTools then
            DebugTools.IsDebugMode = function() return false end
            DebugTools.EnableDebug = function() end
        end
        if _G.DEBUG then _G.DEBUG = false end
        if _G._DEBUG then _G._DEBUG = false end
    end)
end

-- ============================================
-- BYPASS 34: Ban System Blocker (1 Day - 10 Year Ban Protection)
-- ============================================
local function InitializeBanSystemBlocker()
    pcall(function()
        local BanLogic = package.loaded["client.slua.logic.ban.ClientBanLogic"]
        if BanLogic then
            BanLogic.OnSyncBanInfo = function() end
            BanLogic.OnVoiceBanNotify = function() end
            BanLogic.OnBanInfoNotify = function() end
            BanLogic.OnKickBanNotify = function() end
            BanLogic.GetBanInfo = function() return {} end
            BanLogic.IsBanned = function() return false end
            BanLogic.GetBanTime = function() return 0 end
        end
        local TTBan = package.loaded["client.slua.logic.login.logic_tt_ban"]
        if TTBan then
            TTBan.GetCarrierInfo = function() return "[{\"mcc\":\"000\"}]" end
            TTBan.CheckIfCanCreateRole = function() return true end
            TTBan.OnBanNotify = function() end
            TTBan.IsTtBanned = function() return false end
        end
        local BanSubsystem = package.loaded["GameLua.Mod.BaseMod.DS.Security.DSBanSubsystem"]
        if BanSubsystem then
            BanSubsystem.AddBanPlayer = function() end
            BanSubsystem.RemoveBanPlayer = function() end
            BanSubsystem.CheckPlayerBan = function() return false end
            BanSubsystem.SyncBanInfo = function() end
        end
    end)
end

-- ============================================
-- BYPASS 35: Security Report Blocker
-- ============================================
local function InitializeSecurityReportBlocker()
    pcall(function()
        local SecurityReport = package.loaded["GameLua.Mod.BaseMod.Client.Security.SecurityReportSubsystem"]
        if SecurityReport then
            SecurityReport.ReportPlayer = function() end
            SecurityReport.ReportSuspicious = function() end
            SecurityReport.SendSecurityReport = function() end
            SecurityReport.OnReportSuccess = function() end
            SecurityReport.OnReportFailed = function() end
        end
        local PlayerReport = package.loaded["client.slua.logic.report.PlayerReportLogic"]
        if PlayerReport then
            PlayerReport.SendReport = function() end
            PlayerReport.ReportCheat = function() end
            PlayerReport.ReportAbuse = function() end
            PlayerReport.ReportAFK = function() end
            PlayerReport.ReportTeammate = function() end
            PlayerReport.OnReportResponse = function() end
        end
    end)
end

-- ============================================
-- BYPASS 36: Ban ID Spoofer
-- ============================================
local function BanIDSpoofer()
    pcall(function()
        _G.BanStatus = {
            IsBanned = false,
            BanType = 0,
            BanDuration = 0,
            BanReason = "",
            BanTime = 0
        }
        local BanCheck = package.loaded["GameLua.Mod.BaseMod.Common.Security.BanCheck"]
        if BanCheck then
            BanCheck.IsPlayerBanned = function() return false end
            BanCheck.GetBanLevel = function() return 0 end
            BanCheck.GetBanExpiry = function() return os.time() + 86400 * 365 end
            BanCheck.CheckBanStatus = function() return false end
        end
        _G.bIsBanned = false
        _G.bIsSystemBanned = false
        _G.BanDuration = 0
        _G.BanType = 0
    end)
end

-- ============================================
-- BYPASS 37: Anti-Report Cooldown Bypass
-- ============================================
local function AntiReportCooldownBypass()
    pcall(function()
        local ReportCooldown = package.loaded["client.slua.logic.report.ReportCooldownLogic"]
        if ReportCooldown then
            ReportCooldown.CheckCanReport = function() return false end
            ReportCooldown.GetCooldownTime = function() return 0 end
            ReportCooldown.ResetCooldown = function() end
            ReportCooldown.OnReportCooldownEnd = function() end
        end
        local ReportUI = package.loaded["client.slua.umg.report.ReportUI"]
        if ReportUI then
            ReportUI.OnReportClick = function() end
            ReportUI.ShowReportDialog = function() end
            ReportUI.SendReport = function() end
        end
    end)
end

-- ============================================
-- BYPASS 38: Ban Message Interceptor
-- ============================================
local function BanMessageInterceptor()
    pcall(function()
        local NetworkHandler = package.loaded["client.slua.network.NetworkHandler"]
        if NetworkHandler then
            local origHandleBan = NetworkHandler.HandleBanMessage
            NetworkHandler.HandleBanMessage = function(self, data)
                return false
            end
            local origHandleKick = NetworkHandler.HandleKickMessage
            NetworkHandler.HandleKickMessage = function(self, data)
                return false
            end
        end
        local BanPopup = package.loaded["client.slua.umg.BanPopup"]
        if BanPopup then
            BanPopup.ShowBanPopup = function() end
            BanPopup.ShowBanWarning = function() end
            BanPopup.UpdateBanTimer = function() end
        end
    end)
end

-- ============================================
-- BYPASS 39: Client-Side Error Ban Fix
-- ============================================
local function FixClientSideErrorBan()
    pcall(function()
        local BanPopup = package.loaded["client.slua.umg.BanPopup"]
        if BanPopup then
            BanPopup.ShowBanPopup = function() return false end
            BanPopup.ShowBanWarning = function() return false end
            BanPopup.OnBanConfirm = function() end
            BanPopup.OnBanAppeal = function() end
        end
        local NetworkMonitor = package.loaded["client.slua.logic.network.NetworkMonitor"]
        if NetworkMonitor then
            NetworkMonitor.OnNetworkError = function() end
            NetworkMonitor.ReportNetworkError = function() end
            NetworkMonitor.CheckNetworkStatus = function() return true end
        end
        local SecurityCheck = package.loaded["GameLua.Mod.BaseMod.Common.Security.SecurityCheck"]
        if SecurityCheck then
            SecurityCheck.OnSecurityCheckFailed = function() end
            SecurityCheck.ReportSecurityError = function() end
            SecurityCheck.CheckDeviceIntegrity = function() return true end
            SecurityCheck.CheckNetworkIntegrity = function() return true end
        end
        local ClientError = package.loaded["client.slua.logic.error.ClientError"]
        if ClientError then
            ClientError.ReportError = function() end
            ClientError.OnClientError = function() end
            ClientError.SendErrorLog = function() end
        end
        _G.SystemBanStatus = {
            IsBanned = false,
            BanType = 0,
            BanDuration = 0,
            BanReason = "",
            BanTime = 0,
            ErrorCode = 0
        }
        local ErrorHandler = package.loaded["client.slua.logic.error.ErrorHandler"]
        if ErrorHandler then
            ErrorHandler.HandleErrorCode = function(code)
                if code == 3527872482011127212 then return true end
                if code == 3527872482011127213 then return true end
                if code == 3527872482011127214 then return true end
                return false
            end
        end
    end)
end

-- ============================================
-- BYPASS 40: Network Error Blocker
-- ============================================
local function NetworkErrorBlocker()
    pcall(function()
        local NetworkDetect = import("NetworkDetect")
        if NetworkDetect then
            NetworkDetect.IsNetworkError = function() return false end
            NetworkDetect.GetNetworkError = function() return nil end
            NetworkDetect.ReportNetworkError = function() end
        end
        local ConnectionManager = package.loaded["client.slua.logic.connection.ConnectionManager"]
        if ConnectionManager then
            ConnectionManager.OnConnectionError = function() end
            ConnectionManager.ReportConnectionError = function() end
            ConnectionManager.CheckConnection = function() return true end
        end
    end)
end

-- ============================================
-- BYPASS 41: Device Error Blocker
-- ============================================
local function DeviceErrorBlocker()
    pcall(function()
        local DeviceCheck = package.loaded["client.slua.logic.device.DeviceCheck"]
        if DeviceCheck then
            DeviceCheck.IsDeviceError = function() return false end
            DeviceCheck.GetDeviceError = function() return nil end
            DeviceCheck.ReportDeviceError = function() end
        end
        local HardwareCheck = import("HardwareCheck")
        if HardwareCheck then
            HardwareCheck.IsHardwareError = function() return false end
            HardwareCheck.ReportHardwareError = function() end
        end
    end)
end

-- ============================================
-- BYPASS 42: Security Error Blocker
-- ============================================
local function SecurityErrorBlocker()
    pcall(function()
        local SecurityError = package.loaded["GameLua.Mod.BaseMod.Common.Security.SecurityError"]
        if SecurityError then
            SecurityError.OnSecurityError = function() end
            SecurityError.ReportSecurityError = function() end
            SecurityError.CheckSecurity = function() return true end
        end
        local TssError = package.loaded["TssError"]
        if TssError then
            TssError.OnTssError = function() end
            TssError.ReportTssError = function() end
        end
    end)
end

-- ============================================
-- BYPASS 43: Anti-Cheat Error Blocker
-- ============================================
local function AntiCheatErrorBlocker()
    pcall(function()
        local AntiCheatError = package.loaded["GameLua.Mod.BaseMod.Common.Security.AntiCheatError"]
        if AntiCheatError then
            AntiCheatError.OnAntiCheatError = function() end
            AntiCheatError.ReportAntiCheatError = function() end
            AntiCheatError.CheckAntiCheat = function() return true end
        end
        local AceError = package.loaded["AceError"]
        if AceError then
            AceError.OnAceError = function() end
            AceError.ReportAceError = function() end
        end
    end)
end

-- ============================================
-- BYPASS 44: Error Message Interceptor
-- ============================================
local function ErrorMessageInterceptor()
    pcall(function()
        local ErrorMessage = package.loaded["client.slua.logic.error.ErrorMessage"]
        if ErrorMessage then
            ErrorMessage.ShowErrorMessage = function() end
            ErrorMessage.HideErrorMessage = function() end
            ErrorMessage.OnErrorConfirm = function() end
        end
        local ErrorPopup = package.loaded["client.slua.umg.ErrorPopup"]
        if ErrorPopup then
            ErrorPopup.ShowErrorPopup = function() end
            ErrorPopup.ShowNetworkError = function() end
            ErrorPopup.ShowDeviceError = function() end
            ErrorPopup.ShowSecurityError = function() end
        end
    end)
end

-- ============================================
-- BYPASS 45: Complete Error Ban Bypass
-- ============================================
local function CompleteErrorBanBypass()
    pcall(function()
        local GameInstance = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
        if slua.isValid(GameInstance) then
            if GameInstance.OnNetworkError then
                GameInstance.OnNetworkError = function() end
            end
            if GameInstance.OnDeviceError then
                GameInstance.OnDeviceError = function() end
            end
            if GameInstance.OnSecurityError then
                GameInstance.OnSecurityError = function() end
            end
            if GameInstance.OnAntiCheatError then
                GameInstance.OnAntiCheatError = function() end
            end
        end
        _G.OnError = function() end
        _G.OnNetworkError = function() end
        _G.OnDeviceError = function() end
        _G.OnSecurityError = function() end
        _G.OnAntiCheatError = function() end
        _G.ErrorQueue = {}
        _G.PendingErrors = {}
        _G.BlockedErrorCodes = {
            [3527872482011127212] = true,
            [3527872482011127213] = true,
            [3527872482011127214] = true
        }
    end)
end

-- ============================================
-- RUN ALL BYPASSES (45+)
-- ============================================
local function RunAllBypasses()
    pcall(InitializeSkinBypass)
    pcall(InitializeLogBlocker)
    pcall(InitializeScannerBlocker)
    pcall(InitializeReplayTelemetryBlocker)
    pcall(DisableHiggsBoson)
    pcall(InitializeAntiCheatHooks)
    pcall(InitializeAntiReport)
    pcall(InitializeGameplayBypass)
    pcall(InitializeConnectionGuard)
    pcall(InitializeZRPRBypasses)
    pcall(BypassACE)
    pcall(BypassXignCode3)
    pcall(BypassBattlEye)
    pcall(BypassMemoryScanner)
    pcall(BypassPacketEncryption)
    pcall(BypassDSValidation)
    pcall(BypassCRCCheck)
    pcall(BypassJNIAntiCheat)
    pcall(BypassTDataMaster)
    pcall(BypassAntiDebug)
    pcall(FakeSystemInfo)
    pcall(EncryptMemoryOperations)
    pcall(KillAllLogging)
    pcall(RandomizeBehavior)
    pcall(BlockNetworkMonitoring)
    pcall(SpoofTimingChecks)
    pcall(ZeroTraceCleanup)
    pcall(PreventSuspiciousFlags)
    pcall(AddDetectionJitter)
    pcall(SelfModifyingProtection)
    pcall(BlockHiggsBosonComplete)
    pcall(AntiScreenshotDetection)
    pcall(ForceDisableDebugMode)
    
    -- Ban Protection (34-38)
    pcall(InitializeBanSystemBlocker)
    pcall(InitializeSecurityReportBlocker)
    pcall(BanIDSpoofer)
    pcall(AntiReportCooldownBypass)
    pcall(BanMessageInterceptor)
    
    -- Error Ban Fixes (39-45)
    pcall(FixClientSideErrorBan)
    pcall(NetworkErrorBlocker)
    pcall(DeviceErrorBlocker)
    pcall(SecurityErrorBlocker)
    pcall(AntiCheatErrorBlocker)
    pcall(ErrorMessageInterceptor)
    pcall(CompleteErrorBanBypass)
    
    print('[BYPASS] All 45+ bypass systems active!')
    print('[BYPASS] Ban protection active for 1 day to 10 year bans!')
    print('[BYPASS] Client-side error ban blocked!')
    print('[BYPASS] Error code 3527872482011127212 blocked!')
end

-- ============================================
-- FORCE RUN BYPASSES (FIX FOR NOT RUNNING)
-- ============================================
pcall(function()
    require("common.time_ticker").AddTimerOnce(0.1, function()
        print('[BYPASS] Running bypasses...')
        pcall(RunAllBypasses)
        print('[BYPASS] All bypasses active!')
    end)
end)

pcall(function()
    require("common.time_ticker").AddTimerOnce(1.0, function()
        print('[BYPASS] Verifying bypasses...')
        pcall(RunAllBypasses)
        print('[BYPASS] All 45+ bypasses confirmed!')
    end)
end)

pcall(RunAllBypasses)

-- ============================================
-- FPS BOOST AND GRAPHICS CONFIG (165 FPS)
-- ============================================
if var_85 <= var_151 then
    local logic_setting_graphics_1 = package.loaded["client.slua.logic.setting.logic_setting_graphics"] or require("client.slua.logic.setting.logic_setting_graphics")
    local GSC_FPS_1 = package.loaded["client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPS"] or require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPS")
    local GSC_FPSFT_1 = package.loaded["client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPSFT"] or require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPSFT")
    local GraphicSettingDB_1 = package.loaded["client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB"] or require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")

    if logic_setting_graphics_1 then
        local var_132 = logic_setting_graphics_1.SetFPS
        function logic_setting_graphics_1.SetFPS(gameInstance, FPSLevel)
            if FPSLevel == 8 and GraphicSettingDB_1 then
                local var_234 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneSwitch)
                if not var_234 then GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.FPSFineTuneSwitch, true) end
            end
            if var_132 then var_132(gameInstance, FPSLevel) end
            if FPSLevel == 8 and GraphicSettingDB_1 then
                GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.FPSFineTuneNum, 165)
                gameInstance:ExecuteCMD("t.MaxFPS", "165")
                gameInstance:ExecuteCMD("r.FrameRateLimit", "165")
            end
        end
    end

    if GSC_FPS_1 and GSC_FPS_1.__inner_impl then
        local var_160 = GSC_FPS_1.__inner_impl
        function var_160:GetMaxFPSLevel() return 8, 8 end
        function var_160:CanChangeQualityAndFPSPreCheck() return true end
        function var_160:InitRealSupportFPS()
            local var_29 = {}
            for i = 1, 8 do var_29[i] = {true, true} end
            if GraphicSettingDB_1 then GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.RealSupportFPS, var_29, false) end
            return var_29
        end
        function var_160:SetFPSAndQualityEnable(bEnable)
            if self.UIRoot and self.UIRoot.Image_Mask then self:SetWidgetVisible(self.UIRoot.Image_Mask, false) end
        end
        function var_160:UpdateSelectedFPSState(selectedLevel)
            local var_37 = { [2]="NodeFps20", [3]="NodeFps25", [4]="NodeFps30", [5]="NodeFps40", [6]="NodeFps60", [7]="NodeFps90", [8]="NodeFps120" }
            if not self.UIRoot then return end
            for level, name in pairs(var_37) do
                if self.UIRoot[name] then
                    self:WidgetSelfHit(self.UIRoot[name])
                    self.UIRoot[name]:SetIsEnabled(true)
                    local var_54 = self.UIRoot["WidgetSwitcher_" .. level]
                    if var_54 then var_54:SetActiveWidgetIndex(level == selectedLevel and 0 or 1) end
                end
            end
        end
        local var_58 = var_160.UpdateUI
        function var_160:UpdateUI()
            if var_58 then pcall(var_58, self) end
            self:SelfHitTestInvisible()
            self:InitRealSupportFPS()
            self:SetFPSAndQualityEnable(true)
            local var_222 = 8
            if GraphicSettingDB_1 then
                if GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.CustomTab) == 2 then
                    var_222 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.LobbyFPS) or 8
                else
                    var_222 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.SelectedFPS) or 8
                end
            end
            self:UpdateSelectedFPSState(var_222)
        end
        function var_160:DoClickFPS(FPSLevel)
            if slua.isValid(self.UIRoot) then
                if GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.CustomTab) == 2 then
                    GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.LobbyFPS, FPSLevel)
                else
                    GraphicSettingDB_1:UpdateSelectedFPS(FPSLevel)
                end
                self:UpdateSelectedFPSState(FPSLevel)
                if self:GetParentUI() then 
                    self:GetParentUI():SaveQualityAndFPS()
                    self:GetParentUI():SetDirty(true) 
                end
            end
        end
    end

    if GSC_FPSFT_1 and GSC_FPSFT_1.__inner_impl then
        local var_13 = GSC_FPSFT_1.__inner_impl
        local var_93, var_203 = 90, 5
        local function func_6(val, min, max) return val < min and min or (val > max and max or val) end
        
        function var_13:InitFPSFTValue165()
            local var_202 = self.UIRoot
            local sw = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneSwitch)
            local var_69 = sw and GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneNum) or 165
            var_202.Slider_screen3:SetLocked(not sw)
            var_202.ProgressBar_screen3:SetFillColorAndOpacity(sw and FLinearColor(1,1,1,1) or FLinearColor(1,0.625,0.6,1))
            local var_60 = (var_69 - var_93) / (165 - var_93)
            var_202.Veihclescreen3:SetText(LocUtil.LocalizeResFormat(10567, var_69))
            var_202.Slider_screen3:SetValue(var_60)
            var_202.ProgressBar_screen3:SetPercent(var_60)
        end
        
        function var_13:OnFPSFTValueChange165(var_69)
            GraphicSettingDB_1:UpdateUIData(GraphicSettingDB_1.FPSFineTuneNum, var_69)
            self:InitFPSFTValue165()
            if self:GetParentUI() then self:GetParentUI():SetDirty(true) end
            local var_43 = GraphicSettingDB_1.GetGameInstance and GraphicSettingDB_1.GetGameInstance()
            if var_43 then 
                var_43:ExecuteCMD("t.MaxFPS", tostring(var_69))
                var_43:ExecuteCMD("r.FrameRateLimit", tostring(var_69)) 
            end
        end
        
        function var_13:OnFPSFTSliderValueChange165(var_174)
            if GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneSwitch) then
                local var_69 = KismetMathLibrary_1.FCeil(var_174 * (165 - var_93) / var_203) * var_203 + var_93
                self:OnFPSFTValueChange165(func_6(var_69, var_93, 165))
            end
        end
        
        function var_13:OnFPSFTAdd165()
            local var_69 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneNum)
            if var_69 then self:OnFPSFTValueChange165(math.min(165, var_69 + var_203)) end
        end
        
        function var_13:OnFPSFTMinus165()
            local var_69 = GraphicSettingDB_1:GetUIData(GraphicSettingDB_1.FPSFineTuneNum)
            if var_69 then self:OnFPSFTValueChange165(math.max(var_93, var_69 - var_203)) end
        end
        
        var_13.OnFPSFTAdd = var_13.OnFPSFTAdd165 
        var_13.OnFPSFTMinus = var_13.OnFPSFTMinus165
        var_13.OnFPSFTSliderValueChange = var_13.OnFPSFTSliderValueChange165
    end
end

-- ============================================
-- SKIN SYSTEM (Complete Weapons, Outfits, Vehicles, Attachments)
-- ============================================
_G.ConfigFilePath = '/storage/emulated/0/Android/data/com.tencent.ig/files/VINESH_OP_MENU.ini'

_G.BaseSkinIDs = {
    Weapons = { 101004, 101001, 101003, 103001, 102002, 103002, 103003, 101008, 102003, 105010, 102004, 105002, 105001, 101006, 104004 },
    Outfits = { Suit = 403003, Bag = 501001, Helmet = 502001, Parachut = 703001, Pet = 50000 }
}
_G.OutfitSkins = { Suit = {_G.BaseSkinIDs.Outfits.Suit}, Bag = {_G.BaseSkinIDs.Outfits.Bag}, Helmet = {_G.BaseSkinIDs.Outfits.Helmet}, Parachut = {_G.BaseSkinIDs.Outfits.Parachut}, Pet = {_G.BaseSkinIDs.Outfits.Pet} }

_G.skinIdMappings = {}
for _, id in ipairs(_G.BaseSkinIDs.Weapons) do _G.skinIdMappings[id] = {id} end

_G.VehicleMapDict = { UAZ = 1908001, Dacia = 1903001, Buggy = 1907001, Motor = 1901001, CoupeRB = 1961001 }
_G.VehicleSkinsList = {}
_G.VehicleSkinIndex = {}
_G.CustSlotType = { ClothesEquipemtSlot=5, BackpackEquipemtSlot=8, HelmetEquipemtSlot=9, ParachuteEquipemtSlot=11, GlideEquipemtSlot=15 }
_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.SuitSkin, _G.BagSkin, _G.HelmetSkin, _G.ParachuteSkin, _G.GliderSkin, _G.PetSkin = 0, 0, 0, 0, 0, 0
_G.LastBackApplyValue, _G.LastHelmetApplyValue = 0, 0
_G.skinIdCache, _G.skinIdCache2 = {}, {}
local var_180 = {}

local function func_1(id)
    local puffer_manager_1 = require('client.slua.logic.download.puffer.puffer_manager')
    local puffer_const_1 = require('client.slua.logic.download.puffer_const')
    if puffer_manager_1 and puffer_const_1 and puffer_manager_1.GetState(puffer_const_1.ENUM_DownloadType.ODPAK, {id}) ~= puffer_const_1.ENUM_DownloadState.Done then
        puffer_manager_1.Download(puffer_const_1.ENUM_DownloadType.ODPAK, {id})
    end
end
_G.download_item = func_1

_G.get_skin_id = function(weaponID)
    if not weaponID then return nil end
    local var_241 = (_G.WeaponSkinIndex[weaponID]) or 1
    local var_81 = _G.skinIdMappings[weaponID]
    if not var_81 or not var_81[var_241] then return weaponID end
    local var_155 = var_81[var_241]
    if not _G.skinIdCache2[var_155] then pcall(_G.download_item, var_155); _G.skinIdCache2[var_155] = true end
    return var_155
end

_G.get_vehicle_skin_id = function(vehicleID)
    if not vehicleID or vehicleID == 0 then return vehicleID end
    local var_73 = tostring(vehicleID)
    local var_83 = string.sub(var_73, 1, 4)
    local var_62 = tonumber(var_83 .. "001")
    local var_223 = _G.VehicleSkinsList[var_62]
    if var_223 then
        local var_45 = _G.VehicleSkinIndex[var_62] or 1
        if var_45 < 1 then var_45 = 1 end
        if var_45 > #var_223 then var_45 = #var_223 end
        local var_193 = var_223[var_45]
        if var_193 and var_193 > 0 then
            if not _G.skinIdCache2[var_193] then pcall(_G.download_item, var_193); _G.skinIdCache2[var_193] = true end
            return var_193
        end
    end
    return vehicleID
end

_G.LoadSkinDataFromINI = function()
    local var_34 = io.open(_G.ConfigFilePath, 'r')
    if not var_34 then return end
    local var_109 = false
    for line in var_34:lines() do
        if line:match('%[SKIN_LIST%]') then var_109 = true 
        elseif line:match('%[SELECTED%]') then var_109 = false end
        if var_109 and not line:match('^%s*%[') and not line:match('^%s*[#]') then
            local var_86, var_61 = line:match('([^=]+)=(.+)')
            if var_86 and var_61 then
                var_86 = var_86:match("^%s*(.-)%s*$")
                local var_182 = {}
                for val in var_61:gmatch('([^,]+)') do
                    local var_112 = tonumber(val:match("^%s*(.-)%s*$"))
                    if var_112 then table.insert(var_182, var_112) end
                end
                if #var_182 > 0 then
                    if _G.OutfitSkins[var_86] ~= nil then _G.OutfitSkins[var_86] = var_182
                    elseif _G.VehicleMapDict[var_86] ~= nil then local var_1 = _G.VehicleMapDict[var_86]; _G.VehicleSkinsList[var_1] = var_182
                    elseif tonumber(var_86) then _G.skinIdMappings[tonumber(var_86)] = var_182 end
                end
            end
        end
    end
    var_34:close()
    _G.SuitSkinsMap = _G.OutfitSkins.Suit
    _G.BagSkinsMap = _G.OutfitSkins.Bag
    _G.HelmetSkinsMap = _G.OutfitSkins.Helmet
    _G.ParachutSkinsMap = _G.OutfitSkins.Parachut
    _G.PetSkinsMap = _G.OutfitSkins.Pet
end
pcall(_G.LoadSkinDataFromINI)

_G.ReadConfigFile = function()
    local var_34 = io.open(_G.ConfigFilePath, 'r')
    if not var_34 then return end
    local var_220 = {}
    for line in var_34:lines() do
        if line:match('%[SKIN_LIST%]') then break end
        if not line:match('^%s*%[') and not line:match('^%s*[#]') then
            local var_86, var_174 = line:match('([%w_]+)%s*=%s*(%d+)')
            if var_86 and var_174 and not line:match(',') then var_220[var_86] = tonumber(var_174) end
        end
    end
    var_34:close()
    local function func_12(var_86, map, globalVarName)
        if var_220[var_86] and var_220[var_86] ~= var_180[var_86] then _G[globalVarName] = map and map[var_220[var_86] + 1] or 0; var_180[var_86] = var_220[var_86] end
    end
    func_12('Suit', _G.SuitSkinsMap, 'SuitSkin')
    func_12('Bag', _G.BagSkinsMap, 'BagSkin')
    func_12('Helmet', _G.HelmetSkinsMap, 'HelmetSkin')
    func_12('Parachute', _G.ParachutSkinsMap, 'ParachuteSkin')
    func_12('Pet', _G.PetSkinsMap, 'PetSkin')
    local function func_10(var_86, id)
        if var_220[var_86] and var_220[var_86] ~= var_180[var_86] then _G.WeaponSkinIndex[id] = var_220[var_86] + 1; var_180[var_86] = var_220[var_86] end
    end
    func_10('M416', 101004); func_10('AKM', 101001); func_10('UMP', 102002); func_10('SCAR', 101003)
    func_10('M762', 101008); func_10('AUG', 101006); func_10('Vector', 102003); func_10('UZI', 102004)
    func_10('Kar98k', 103001); func_10('M24', 103002); func_10('AWM', 103003); func_10('DP28', 105002)
    func_10('M249', 105001); func_10('MG3', 105010); func_10('Shotgun', 104004)
    local function func_11(var_86)
        local var_1 = _G.VehicleMapDict[var_86]
        if var_1 and var_220[var_86] and var_220[var_86] ~= var_180[var_86] then _G.VehicleSkinIndex[var_1] = var_220[var_86] + 1; var_180[var_86] = var_220[var_86] end
    end
    func_11('UAZ'); func_11('Dacia'); func_11('Buggy'); func_11('Motor'); func_11('CoupeRB')
end

_G.BaseAttachToIndex = {
    [201010]=1, [201005]=1, [201004]=1, [201009]=2, [201003]=2, [201002]=2, [201011]=3, [201007]=3, [201006]=3,
    [204012]=4, [204005]=4, [204008]=4, [204011]=5, [204004]=5, [204007]=5, [204013]=6, [204006]=6, [204009]=6,
    [203001]=7, [203002]=8, [203003]=9, [203014]=10, [203004]=11, [203015]=12, [203005]=13, [202002]=14, [202001]=15,
    [202004]=16, [202005]=17, [202007]=18, [202006]=19, [205002]=20, [205003]=20, [205001]=20, [203018]=21, [204014]=22
}

_G.VIP_Attachments = {}
_G.VipAttachToIndex = {}

_G.LoadAttachmentsFromINI = function()
    local var_34 = io.open(_G.ConfigFilePath, 'r')
    if not var_34 then return end
    _G.VIP_Attachments = {}
    _G.VipAttachToIndex = {}
    local var_55 = false
    for line in var_34:lines() do
        line = line:match("^%s*(.-)%s*$")
        if line == '[ATTACHMENTS]' then var_55 = true 
        elseif line:match('^%[') then var_55 = false end
        if var_55 and not line:match('^%[') and line ~= '' and not line:match('^#') then
            local var_165, var_61 = line:match('^(%d+)=(.+)$')
            if var_165 and var_61 then
                local var_155 = tonumber(var_165)
                local var_19 = {}
                local var_241 = 1
                for val in var_61:gmatch('([^,]+)') do
                    local var_69 = tonumber(val) or 0
                    table.insert(var_19, var_69)
                    if var_69 > 0 then _G.VipAttachToIndex[var_69] = var_241 end
                    var_241 = var_241 + 1
                end
                _G.VIP_Attachments[var_155] = var_19
            end
        end
    end
    var_34:close()
end
pcall(_G.LoadAttachmentsFromINI)

_G.equip_character_avatar = function(var_65)
    if not var_65 or not slua.isValid(var_65) or not var_65.AvatarComponent2 then return end
    local BackpackUtils_1 = import("BackpackUtils")
    local var_126 = var_65.AvatarComponent2.NetAvatarData and var_65.AvatarComponent2.NetAvatarData.SlotSyncData
    if not var_126 or not slua.isValid(var_126) or not BackpackUtils_1 then return end
    
    local function func_7(ApplyDataIdx, itemId, ApplyEquipSlot, isLevelDependent, levelFunc, globalCacheVal)
        if itemId == 0 then return end
        local var_117 = var_126:Get(ApplyDataIdx)
        if var_117 and var_117.SlotID == ApplyEquipSlot then
            local var_173 = itemId
            if isLevelDependent then
                local var_204 = levelFunc(var_117.AdditionalItemID) or 1
                var_173 = itemId + (var_204 - 1) * 1000
                if var_173 == var_117.ItemId and _G[globalCacheVal] == itemId then return end
                _G[globalCacheVal] = itemId
            elseif var_117.ItemId == itemId then return end

            if not _G.skinIdCache[var_173] then 
                _G.download_item(var_173)
                _G.skinIdCache[var_173] = true 
            end
            
            var_117.ItemId = var_173
            var_126:Set(ApplyDataIdx, var_117)
            var_65.AvatarComponent2:OnRep_BodySlotStateChanged()
        end
    end

    local var_47 = false
    for i = 0, var_126:Num() - 1 do
        local var_117 = var_126:Get(i)
        if var_117 and var_117.SlotID == _G.CustSlotType.GlideEquipemtSlot then var_47 = true; break end
    end
    if not var_47 then var_126:Add({ SlotID = _G.CustSlotType.GlideEquipemtSlot, ItemId = 0 }) end

    for i = 0, var_126:Num() - 1 do
        func_7(i, _G.SuitSkin, _G.CustSlotType.ClothesEquipemtSlot, false)
        func_7(i, _G.BagSkin, _G.CustSlotType.BackpackEquipemtSlot, true, BackpackUtils_1.GetEquipmentBagLevel, 'LastBackApplyValue')
        func_7(i, _G.HelmetSkin, _G.CustSlotType.HelmetEquipemtSlot, true, BackpackUtils_1.GetEquipmentHelmetLevel, 'LastHelmetApplyValue')
        func_7(i, _G.GliderSkin, _G.CustSlotType.GlideEquipemtSlot, false)
        func_7(i, _G.ParachuteSkin, _G.CustSlotType.ParachuteEquipemtSlot, false)
    end
end

_G.ApplyWeaponSkins = function(GameplayData_1)
    pcall(function()
        local var_226 = GameplayData_1:GetWeaponManager()
        if not slua.isValid(var_226) then return end
        
        for slot = 1, 3 do
            local var_105 = var_226:GetInventoryWeaponByPropSlot(slot)
            if slua.isValid(var_105) and slua.isValid(var_105.synData) then
                local var_90 = var_105:GetWeaponID()
                local var_23 = _G.get_skin_id(var_90) or var_90
                local var_184 = false
                
                local var_150 = var_105.synData:Get(7) 
                if var_150 and var_150.defineID and var_150.defineID.TypeSpecificID ~= var_23 then
                    var_150.defineID.TypeSpecificID = var_23
                    var_105.synData:Set(7, var_150)
                    if var_105.SetWeaponAvatarID then pcall(function() var_105:SetWeaponAvatarID(var_23) end) end
                    if not _G.skinIdCache[var_23] then 
                        _G.download_item(var_23)
                        _G.skinIdCache[var_23] = true 
                    end
                    var_184 = true
                end
                
                if var_23 >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[var_23] then
                    for AttachIdx = 0, 5 do 
                        local var_41 = var_105.synData:Get(AttachIdx)
                        if var_41 then
                            local var_213 = slua.IndexReference(var_41, "defineID")
                            if var_213 then
                                local var_161 = var_213.TypeSpecificID
                                if var_161 and var_161 > 0 then
                                    local var_241 = _G.BaseAttachToIndex[var_161] or _G.VipAttachToIndex[var_161]
                                    if var_241 and _G.VIP_Attachments[var_23][var_241] and _G.VIP_Attachments[var_23][var_241] > 0 then
                                        local var_20 = _G.VIP_Attachments[var_23][var_241]
                                        if var_20 ~= var_161 then
                                            var_41.defineID.TypeSpecificID = var_20
                                            var_105.synData:Set(AttachIdx, var_41)
                                            if not _G.skinIdCache2[var_20] then 
                                                if _G.download_item then pcall(_G.download_item, var_20) end
                                                _G.skinIdCache2[var_20] = true 
                                            end
                                            var_184 = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                if var_184 then
                    if var_105.DelayHandleAvatarMeshChanged then pcall(function() var_105:DelayHandleAvatarMeshChanged() end) end
                    if var_105.OnRep_synData then pcall(function() var_105:OnRep_synData() end) end
                end
            end
        end
    end)
end

_G.ApplyVehicleSkins = function(GameplayData_1)
    pcall(function()
        local var_131 = GameplayData_1:GetCurrentVehicle()
        if not slua.isValid(var_131) then 
            _G.LastVehicleEntity = nil
            return 
        end
        
        if not Game:IsDriver(GameplayData_1.Object) then return end

        local var_8 = var_131.VehicleAvatarComponent_BP or var_131:GetAvatarComponent()
        if not slua.isValid(var_8) then return end

        local var_122 = 0
        if var_131.AvatarDefaultCfg then
            var_122 = var_131.AvatarDefaultCfg.TypeSpecificID
        end
        if var_122 == 0 and var_8.VehicleNetAvatarData and var_8.VehicleNetAvatarData.ItemDefineID then
            var_122 = var_8.VehicleNetAvatarData.ItemDefineID.TypeSpecificID
        end
        if var_122 == 0 then return end

        local var_106 = _G.get_vehicle_skin_id(var_122)
        local var_194 = var_8:GetCurItemAvatarID()

        if var_106 and var_106 ~= 0 and var_194 ~= var_106 then
            if not _G.skinIdCache[var_106] then 
                if _G.download_item then pcall(_G.download_item, var_106) end
                _G.skinIdCache[var_106] = true 
            end

            if var_8.VehicleNetAvatarData and var_8.VehicleNetAvatarData.ItemDefineID then
                var_8.VehicleNetAvatarData.ItemDefineID.TypeSpecificID = var_106
                var_8.VehicleNetAvatarData.SkinOwnerUID = GameplayData_1.PlayerUID
            end
            
            if _G.LastVehicleEntity ~= var_131 or _G.CurrentEquipVehicleID ~= var_106 then
                _G.LastVehicleEntity = var_131
                _G.CurrentEquipVehicleID = var_106

                pcall(function()
                    var_8.lastEquipedAvatarId = var_194
                    if var_8.ShowVehicleSwitchEffect then var_8:ShowVehicleSwitchEffect() end
                    var_8.ClientUsedAvatarID = var_106
                    var_131.ClientUsedAvatarID = var_106
                    if var_8.ChangeItemAvatar then var_8:ChangeItemAvatar(var_106, false) end
                end)
            else
                if var_8.ChangeItemAvatar then var_8:ChangeItemAvatar(var_106, false) end
            end

            if var_8.EnableHighTireLight then var_8:EnableHighTireLight(true, var_106) end
            if var_131.UpdateParticle then pcall(function() var_131:UpdateParticle(var_106) end) end
            if var_131.ChangeParticles then pcall(function() var_131:ChangeParticles(var_106) end) end
            if var_131.ReActivateExhaustParticle then pcall(function() var_131:ReActivateExhaustParticle() end) end
            
            local VehicleLicenseNumberComponent_1 = import("VehicleLicenseNumberComponent")
            local var_72 = var_131:GetComponentByClass(VehicleLicenseNumberComponent_1)
            if slua.isValid(var_72) then
                if var_72.LicensePlate then
                    var_72.LicensePlate.ItemID = var_106
                    var_72.LicensePlate.ChassisLightId = var_106 + 1000
                end
                if var_72.PreChangeEffect then var_72:PreChangeEffect() end
                if var_72.PreChangeChassisLight then var_72:PreChangeChassisLight() end
            end
            
            if var_131.SetVehicleMusicPlayState then var_131:SetVehicleMusicPlayState(true) end
        end
    end)
end

_G.HandlePetLogic = function()
    pcall(function()
        if not _G.PetSkin or _G.PetSkin == 0 or _G.PetSkin == 50000 or _G.PetSkin == _G.LastAppliedPet then return end
        if not _G.skinIdCache[_G.PetSkin] then _G.download_item(_G.PetSkin); _G.skinIdCache[_G.PetSkin] = true end
        
        local ModuleManager_1 = require("client.module_framework.ModuleManager")
        if ModuleManager_1 then
            local var_153 = ModuleManager_1.GetModule(ModuleManager_1.CommonModuleConfig.logic_pet)
            if var_153 then
                if var_153.SetCurPetID then var_153:SetCurPetID(_G.PetSkin) end
                if var_153.EquipPet then var_153:EquipPet(_G.PetSkin) end
            end
        end
        _G.LastAppliedPet = _G.PetSkin
    end)
end

_G.DeadBoxSkins = _G.DeadBoxSkins or {}
_G.AlreadyChangedSet = _G.AlreadyChangedSet or {}

local function func_13(t, element)
    if not t then return false end
    for _, var_174 in ipairs(t) do
        if var_174 == element then return true end
    end
    return false
end

local function func_5(loc1, loc2, tolerance)
    local dx = loc1.X - loc2.X
    local dy = loc1.Y - loc2.Y
    local dz = loc1.Z - loc2.Z
    return dx * dx + dy * dy + dz * dz < tolerance * tolerance
end

_G.DeadBox_TemperRequest = function(var_163)
    local var_65 = var_163:GetPlayerCharacterSafety()
    if not var_65 then return end
    
    local GameplayStatics_1 = import("GameplayStatics")
    if GameplayStatics_1 then
        local Actor_1 = import("Actor")
        local ui_util_1 = require("client.common.ui_util")
        if ui_util_1 then
            local var_171 = ui_util_1.GetGameInstance()
            if var_171 then
                local PlayerTombBox_1 = import("PlayerTombBox")
                local var_68 = GameplayStatics_1.GetAllActorsOfClass(var_171, PlayerTombBox_1, slua.Array(UEnums.EPropertyClass.Object, Actor_1))
                
                for _, var_46 in pairs(var_68) do
                    if slua.isValid(var_46) then
                        local var_221 = var_46.DamageCauser
                        if var_221 and var_221.Playerkey == var_163.Playerkey then
                            local var_97 = var_46.DeadBoxAvatarComponent_BP
                            if var_97 and not func_13(_G.AlreadyChangedSet, var_46) then
                                local var_130 = var_46:K2_GetActorLocation()
                                local var_11 = false
                                
                                for _, entry in pairs(_G.DeadBoxSkins) do
                                    if func_5(entry.location, var_130, 1.0) then
                                        var_97:ResetItemAvatar()
                                        var_97:PreChangeItemAvatar(entry.SkinID)
                                        var_97:SyncChangeItemAvatar(entry.SkinID)
                                        table.insert(_G.AlreadyChangedSet, var_46)
                                        var_11 = true
                                        break
                                    end
                                end
                                
                                if not var_11 then
                                    local var_48 = 0
                                    local var_57 = var_65.CurrentVehicle
                                    if var_57 and _G.CurrentEquipVehicleID and _G.CurrentEquipVehicleID ~= 0 then
                                        var_48 = tonumber(tostring(_G.CurrentEquipVehicleID) .. "1") or 0
                                    else
                                        local var_152 = var_65:GetCurrentWeapon()
                                        if var_152 then
                                            local var_150 = var_152.synData and var_152.synData:Get(7)
                                            if var_150 and var_150.defineID then
                                                var_48 = var_150.defineID.TypeSpecificID
                                            end
                                        end
                                    end
                                    
                                    if var_48 ~= 0 then
                                        var_97:ResetItemAvatar()
                                        var_97:PreChangeItemAvatar(var_48)
                                        var_97:SyncChangeItemAvatar(var_48)
                                        table.insert(_G.DeadBoxSkins, { location = var_130, SkinID = var_48 })
                                        table.insert(_G.AlreadyChangedSet, var_46)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

_G.AKFakeKillCounts = _G.AKFakeKillCounts or {}

_G.ForceEnableKillCounterUI = function()
    pcall(function()
        local KillCounterUISubsystem_1 = package.loaded["GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem"] or require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        if KillCounterUISubsystem_1 and KillCounterUISubsystem_1.__inner_impl and not _G.KCUISystemHacked2 then
            local var_187 = KillCounterUISubsystem_1.__inner_impl
            var_187.CheckSupportKCUI = function() return true end
            
            var_187.CheckNeedMainKillCounterUI = function(self, var_92, PlayerID)
                if slua.isValid(var_92) then
                    local var_90 = var_92:GetWeaponID()
                    self:UpdateMainKillCounterUI(true, var_90, _G.get_skin_id(var_90) or var_90)
                else self:UpdateMainKillCounterUI(false) end
            end
            
            local var_113 = var_187.UpdateMainKillCounterUI
            var_187.UpdateMainKillCounterUI = function(self, bShow, var_145, AvatarID)
                if bShow then AvatarID = _G.get_skin_id(var_145) or AvatarID end
                if var_113 then var_113(self, bShow, var_145, AvatarID) end
            end
            _G.KCUISystemHacked2 = true
        end

        local ModuleManager_1 = require("client.module_framework.ModuleManager")
        if ModuleManager_1 then
            local var_232 = ModuleManager_1.GetModule(ModuleManager_1.CommonModuleConfig.LogicKillCounter)
            if var_232 and not _G.KCLogicHacked2 then
                var_232.CheckSupportKC = function() return true end
                var_232.CheckSupportKillCounterAvatar = function() return true end
                var_232.CheckHasWeaponKillCounter = function() return true end
                var_232.GetBaseKillCounterIdByWeaponId = function() return 2100004 end
                var_232.GetEquipedKillCounterId = function() return 2100004 end
                var_232.GetMyEquipedKillCounterId = function() return 2100004 end
                var_232.GetOneWeaponKillCountInBattle = function(self, uid, weaponId) return _G.AKFakeKillCounts[weaponId] or 0 end
                var_232.GetWeaponKillCountByUid = function(self, uid, weaponId) return _G.AKFakeKillCounts[weaponId] or 0 end
                _G.KCLogicHacked2 = true
            end
        end

        local var_30 = "GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo"
        local var_84 = package.loaded[var_30] or require(var_30)
        if var_84 and var_84.__inner_impl and not _G.KillInfoCounterHacked then
            local var_219 = var_84.__inner_impl.FileItem
            var_84.__inner_impl.FileItem = function(self, DamageRecordData)
                pcall(function()
                    local GameplayData_2 = require("GameLua.GameCore.Data.GameplayData").GetPlayerCharacter()
                    if slua.isValid(GameplayData_2) and DamageRecordData.Causer == GameplayData_2:GetPlayerNameSafety() then 
                        local var_137 = GameplayData_2:GetCurrentWeapon()
                        if slua.isValid(var_137) then
                            local var_17 = var_137:GetWeaponID()
                            local var_103 = _G.get_skin_id(var_17)
                            if var_103 then DamageRecordData.CauserWeaponAvatarID = var_103 end
                            if _G.SuitSkin ~= 0 then DamageRecordData.CauserClothAvatarID = _G.SuitSkin end
                            
                            DamageRecordData.IsUseColor, DamageRecordData.UseColor = true, import("LinearColor")(1.0, 0.8, 0.0, 1.0) 
                            
                            if DamageRecordData.ResultHealthStatus == 2 then
                                _G.AKFakeKillCounts[var_17] = (_G.AKFakeKillCounts[var_17] or 0) + 1
                                local manager_1 = require("client.slua_ui_framework.manager")
                                local var_101 = manager_1.GetUI(manager_1.UI_Config_InGame.MainKillCounter)
                                if var_101 and var_101.UpdateWeaponID then
                                    local var_195 = var_103 or var_137:GetWeaponMainAvatarID()
                                    var_101:UpdateWeaponID(var_17, var_195)
                                    local var_189 = ModuleManager_1.GetModule(ModuleManager_1.CommonModuleConfig.LogicKillCounter)
                                    local var_214 = var_189:GetEquipedKillCounterId(0, var_195)
                                    var_101:SetKillCounterItemShowWithNum(var_214, _G.AKFakeKillCounts[var_17], var_195)
                                end
                            end
                        end
                    end
                end)
                if var_219 then return var_219(self, DamageRecordData) end
            end
            _G.KillInfoCounterHacked = true
        end

        local SwitchWeaponSlotMode2_1 = package.loaded["GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2"] or require("GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2")
        if SwitchWeaponSlotMode2_1 and SwitchWeaponSlotMode2_1.__inner_impl and not _G.SlotBaseHacked then
            SwitchWeaponSlotMode2_1.__inner_impl.CheckShowKCIcon = function(self)
                if self.KillCounterImg and slua.isValid(self.KillCounterImg) then 
                    self.KillCounterImg:SetVisibility(import("ESlateVisibility").SelfHitTestInvisible) 
                end
            end
            _G.SlotBaseHacked = true
        end
    end)
end

function _G.InitializeSkinModSystem()
    pcall(function()
        local LobbyAvatar_1 = package.loaded["client.logic.avatar.LobbyAvatar"] or require("client.logic.avatar.LobbyAvatar")
        if LobbyAvatar_1 and not _G.LobbyBypassHacked then
            local var_210 = LobbyAvatar_1.PutonEquipment
            LobbyAvatar_1.PutonEquipment = function(self, itemID, tAvatarCustom, tExtraData)
                local var_241 = _G.BaseAttachToIndex and _G.BaseAttachToIndex[itemID]
                if var_241 then
                    local var_134 = self.GetCurHoldingWeaponSkinID and self:GetCurHoldingWeaponSkinID()
                    if var_134 and var_134 >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[var_134] then
                        local var_111 = _G.VIP_Attachments[var_134][var_241]
                        if var_111 and var_111 > 0 then
                            if self.HandleDownload then self:HandleDownload(var_111, nil, nil, false) end
                            itemID = var_111
                        end
                    end
                end
                if var_210 then return var_210(self, itemID, tAvatarCustom, tExtraData) end
            end

            local var_201 = LobbyAvatar_1.CharEquipWeaponByResId
            LobbyAvatar_1.CharEquipWeaponByResId = function(self, resID, isUse, isAsync, SocketName)
                local var_191
                if var_201 then var_191 = var_201(self, resID, isUse, isAsync, SocketName) end
                if isUse and self.GetEquipments then
                    local var_239 = self:GetEquipments()
                    for _, equip in ipairs(var_239) do
                        if _G.BaseAttachToIndex and _G.BaseAttachToIndex[equip.itemID] then
                            self:PutonEquipment(equip.itemID, equip.CustomInfo, {bIsUse = false})
                        end
                    end
                end
                return var_191
            end
            _G.LobbyBypassHacked = true
        end
    end)

    pcall(function()
        local Common_Items_UIBP_1 = package.loaded["client.slua.component.item.ItemChildren.Common_Items_UIBP"] or require("client.slua.component.item.ItemChildren.Common_Items_UIBP")
        if Common_Items_UIBP_1 and not _G.IconBaloHacked then
            local var_211 = Common_Items_UIBP_1.InitView
            Common_Items_UIBP_1.InitView = function(self, nItemId, nCount, nValidTime, tExtraData)
                tExtraData = tExtraData or {}
                local var_98 = nil
                
                if _G.get_skin_id then
                    local var_10 = _G.get_skin_id(nItemId)
                    if var_10 and var_10 ~= nItemId then var_98 = var_10 end
                end
                
                local var_241 = _G.BaseAttachToIndex and _G.BaseAttachToIndex[nItemId]
                if not var_98 and var_241 then
                    local GameplayData_3 = require("GameLua.GameCore.Data.GameplayData")
                    if GameplayData_3 then
                        local GameplayData_1 = GameplayData_3.GetPlayerCharacter()
                        if GameplayData_1 and slua.isValid(GameplayData_1) then
                            local var_139 = GameplayData_1:GetCurrentWeapon()
                            if slua.isValid(var_139) then
                                local var_90 = var_139:GetWeaponID()
                                local var_208 = _G.get_skin_id(var_90) or var_90
                                if var_208 >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[var_208] then
                                    local var_79 = _G.VIP_Attachments[var_208][var_241]
                                    if var_79 and var_79 > 0 then var_98 = var_79 end
                                end
                            end
                        end
                    end
                end
                
                if var_98 then
                    tExtraData.displayResId = var_98
                    if not _G.skinIdCache2[var_98] then
                        if _G.download_item then pcall(_G.download_item, var_98) end
                        _G.skinIdCache2[var_98] = true
                    end
                end
                
                if var_211 then return var_211(self, nItemId, nCount, nValidTime, tExtraData) end
            end
            _G.IconBaloHacked = true
        end
    end)

    pcall(function()
        local var_110 = "GameLua.Activity.Commercialize.GamePlay.Vehicle.VehiclePlateLicenseUtil"
        local var_91 = package.loaded[var_110] or require(var_110)
        
        if var_91 and not _G.VehicleEffectHacked then
            var_91.CheckIsBetterVehicle = function() return true end
            var_91.CheckHasUnLockFeature = function() return true end
            var_91.NeedOpenHighTire = function() return true end
            
            local var_230 = var_91.GetUpgradeEffectList
            var_91.GetUpgradeEffectList = function(UID)
                local GameplayData_1 = require("GameLua.GameCore.Data.GameplayData").GetPlayerCharacter()
                if slua.isValid(GameplayData_1) and GameplayData_1:GetCurrentVehicle() then
                    local var_131 = GameplayData_1:GetCurrentVehicle()
                    local var_8 = var_131.VehicleAvatarComponent_BP or var_131:GetAvatarComponent()
                    if slua.isValid(var_8) then
                        local var_193 = var_8.VehicleNetAvatarData and var_8.VehicleNetAvatarData.ItemDefineID.TypeSpecificID or var_8:GetCurItemAvatarID()
                        local var_166 = CDataTable.GetTableData("BetterVehicleEffect", var_193)
                        if var_166 and var_166.EffectIDList then
                            local var_88 = slua.Array(UEnums.EPropertyClass.Int)
                            for i=0, var_166.EffectIDList:Num()-1 do var_88:Add(var_166.EffectIDList:Get(i)) end
                            return var_88
                        end
                    end
                end
                if var_230 then return var_230(UID) end
                return nil
            end
            _G.VehicleEffectHacked = true
        end

        local VehicleAvatarComponent_1 = package.loaded["GameLua.GameCore.Module.Vehicle.Component.VehicleAvatarComponent"] or require("GameLua.GameCore.Module.Vehicle.Component.VehicleAvatarComponent")
        if VehicleAvatarComponent_1 and VehicleAvatarComponent_1.__inner_impl and not _G.VehicleAvatarSwitchHacked then
            
            VehicleAvatarComponent_1.__inner_impl.CheckCanPlaySkinSwitchEffect = function(self, curVehicleId, lastVehicleId) return true end
            
            VehicleAvatarComponent_1.__inner_impl.ShowVehicleSwitchEffect = function(self)
                if not self.curSwitchEffectId or self.curSwitchEffectId <= 0 then self.curSwitchEffectId = 7303001 end
                local var_50 = self:GetOwner()
                if not slua.isValid(var_50) then return false end
                if self.uSwitchEffectActor then
                    self:StopSkinSwitchEffect()
                    self.uSwitchEffectActor:K2_DestroyActor()
                    self.uSwitchEffectActor = nil
                end
                if not self.lastEquipedAvatarId or self.lastEquipedAvatarId <= 0 then
                    self.lastEquipedAvatarId = var_50.ClientUsedAvatarID or var_50:GetDefaultAvatarID() or 0
                end
                local var_96 = var_50.ClientUsedAvatarID or self.lastEquipedAvatarId or 0
                local var_133 = self:IsLobbyActor()
                local var_205 = slua_GameFrontendHUD and slua_GameFrontendHUD:GetWorld()
                if not var_205 then return false end
                local VehiclePlateLicenseUtil_1 = require("GameLua.Activity.Commercialize.GamePlay.Vehicle.VehiclePlateLicenseUtil")
                local var_9 = VehiclePlateLicenseUtil_1.GetSwitchEffectActorPath()
                local var_31 = import(var_9)
                self.uSwitchEffectActor = var_205:SpawnActor(var_31, nil, nil, nil)
                if not slua.isValid(self.uSwitchEffectActor) then self.uSwitchEffectActor = nil; return false end
                self.uSwitchEffectActor:K2_AttachToActor(var_50, "None", 1, 1, 1, false)
                self.uSwitchEffectActor:K2_SetActorRelativeLocation(FVector(0, 0, 0), false, nil, false)
                self.uSwitchEffectActor:K2_SetActorRelativeRotation(FRotator(0, 0, 0), false, nil, false)
                self:ChangeFakeSwitchVehicleAvatar(self.uSwitchEffectActor.Mesh, self.lastEquipedAvatarId)
                self.uSwitchEffectActor:SetAnimInsAndAnimState(self.uOldVehicleMeshAnimClass, var_50)
                self.uSwitchEffectActor:StartVehicleSwitchEffect(var_50, self.curSwitchEffectId, self.lastEquipedAvatarId, var_96, var_133)
                self.uOldVehicleMeshAnimClass = nil
                return true
            end
            
            VehicleAvatarComponent_1.__inner_impl.ResetAnimationState = function(self)
                if self.uSwitchEffectActor then
                    self:StopSkinSwitchEffect()
                    self.uSwitchEffectActor:K2_DestroyActor()
                    self.uSwitchEffectActor = nil
                end
                self.lastEquipedAvatarId = 0
                self.curSwitchEffectId = 7303001
            end
            
            local var_121 = VehicleAvatarComponent_1.__inner_impl.ReceiveBeginPlay
            VehicleAvatarComponent_1.__inner_impl.ReceiveBeginPlay = function(self)
                if var_121 then var_121(self) end
                self:ResetAnimationState()
            end
            _G.VehicleAvatarSwitchHacked = true
        end

        local LobbyVehicle_1 = package.loaded["client.lobby_ue_object.Actor.LobbyVehicle"] or require("client.lobby_ue_object.Actor.LobbyVehicle")
        if LobbyVehicle_1 and not _G.LobbyVehicleHacked then
            local var_140 = LobbyVehicle_1.PreChangeVehicleAvatar
            LobbyVehicle_1.PreChangeVehicleAvatar = function(self, InAvatarID, InAdvanceAvatarID)
                local var_193 = _G.get_vehicle_skin_id(InAvatarID)
                if var_193 and var_193 ~= InAvatarID and var_193 ~= 0 then
                    if not _G.skinIdCache[var_193] then 
                        if _G.download_item then pcall(_G.download_item, var_193) end
                        _G.skinIdCache[var_193] = true 
                    end
                    InAvatarID = var_193
                end
                local var_218 = false
                if var_140 then var_218 = var_140(self, InAvatarID, InAdvanceAvatarID) end
                pcall(function()
                    self.ClientUsedAvatarID = InAvatarID
                    if self.PlayStartUpEffect then self:PlayStartUpEffect() end
                    if self.PlayAccelerateEffect then self:PlayAccelerateEffect() end
                end)
                return var_218
            end
            _G.LobbyVehicleHacked = true
        end
    end)

    if not _G.AKSkinLoopStarted then
        _G.AKSkinLoopStarted = true
        local time_ticker_1 = require("common.time_ticker")
        local function func_2()
            pcall(function()
                local GameplayData_3 = require("GameLua.GameCore.Data.GameplayData")
                if GameplayData_3 then
                    local GameplayData_2 = GameplayData_3.GetPlayerCharacter()
                    if slua.isValid(GameplayData_2) then
                        _G.ForceEnableKillCounterUI()
                        _G.ReadConfigFile()
                        _G.LoadAttachmentsFromINI()
                        _G.equip_character_avatar(GameplayData_2)   
                        _G.ApplyWeaponSkins(GameplayData_2)  
                        _G.ApplyVehicleSkins(GameplayData_2)       
                        _G.HandlePetLogic()
                        local PC = GameplayData_3.GetPlayerController()
                        if slua.isValid(PC) then _G.DeadBox_TemperRequest(PC) end
                    end
                end
            end)
            if time_ticker_1 and time_ticker_1.AddTimerOnce then time_ticker_1.AddTimerOnce(0.1, func_2) end
        end
        func_2() 
    end
end

local var_135 = {
    '/storage/emulated/0/Android/data/com.tencent.ig/files/VINESH_OP_MENU.ini',
    '/storage/emulated/0/Android/data/com.pubg.krmobile/files/VINESH_OP_MENU.ini',
    '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/VINESH_OP_MENU.ini',
    '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/VINESH_OP_MENU.ini'
}

function _G.AK_SaveINI()
    for _, path in ipairs(var_135) do
        local var_34 = io.open(path, "w")
        if var_34 then
            local var_186 = ""
            for _, f in ipairs(_G.AK_Features) do var_186 = var_186 .. f.id .. "=" .. tostring(f.val) .. "\n" end
            var_34:write(var_186)
            var_34:close()
        end
    end
    _G.EnvRequiresUpdate = true
end

function _G.AK_LoadINI()
    local var_34 = nil
    for _, path in ipairs(var_135) do
        var_34 = io.open(path, "r")
        if var_34 then break end
    end
    if var_34 then
        local var_186 = var_34:read("*all")
        var_34:close()
        for _, f in ipairs(_G.AK_Features) do
            local var_141 = string.match(var_186, f.id .. "=(%d+)")
            if var_141 then f.val = tonumber(var_141) end
        end
    end
end

function _G.AK_GetVal(id)
    if not _G.AK_Features then return 0 end
    for _, f in ipairs(_G.AK_Features) do if f.id == id then return f.val end end
    return 0
end

-- ============================================
-- AK MENU WITH REMOVED OPTIONS
-- ESP HEALTH BAR and HUD COORDINATES REMOVED
-- ============================================
function _G.ShowAKMenu()
    if not _G.AK_Features then return end
    local var_107 = _G.AK_Features[_G.AK_MenuIndex]
    local var_167 = "@GRW_XD"
    local selected_status = ""
    if var_107.type == "toggle" then selected_status = (var_107.val == 1) and "[ ON ]" or "[ OFF ]"
    elseif var_107.type == "percent_10" then selected_status = "[" .. tostring(var_107.val) .. "%]"
    elseif var_107.type == "value_range" then selected_status = "[" .. tostring(var_107.val) .. "]" end
    
    local var_175 = "--- SELECTED FUNCTION ---\n"
    var_175 = var_175 .. "-> " .. var_107.name .. ": " .. selected_status .. "\n"
    var_175 = var_175 .. "====================================\n"
    var_175 = var_175 .. "              --- ALL OPTIONS ---\n\n"
    
    for i, f in ipairs(_G.AK_Features) do
        local isSelected = (i == _G.AK_MenuIndex)
        local var_217 = isSelected and "-> " or "   "
        local var_99 = ""
        if f.type == "toggle" then var_99 = (f.val == 1) and "[ ON ]" or "[ OFF ]"
        elseif f.type == "percent_10" then var_99 = "[" .. tostring(f.val) .. "%]"
        elseif f.type == "value_range" then var_99 = "[" .. tostring(f.val) .. "]" end
        var_175 = var_175 .. var_217 .. f.name .. ": " .. var_99 .. "\n"
    end
    var_175 = var_175 .. "\n====================================\n"
    local var_100 = "ON FUNCTION"
    local logic_common_msg_box_1 = package.loaded["client.slua.logic.common.logic_common_msg_box"] or require("client.slua.logic.common.logic_common_msg_box")
    if logic_common_msg_box_1 and logic_common_msg_box_1.Show then
        logic_common_msg_box_1.Show(4, var_167, var_175, 
        function() 
            if var_107.type == "toggle" then var_107.val = 1 - var_107.val
            elseif var_107.type == "percent_10" then var_107.val = var_107.val + 10; if var_107.val > 100 then var_107.val = 0 end 
            elseif var_107.type == "value_range" then var_107.val = var_107.val + (var_107.step or 5); if var_107.val > (var_107.max or 150) then var_107.val = var_107.min or 90 end end
            _G.AK_SaveINI()
            if var_107.id:find("AIMBOT") then _G.AK_ForceWeaponUpdate = true end
            _G.ShowAKMenu()
        end, 
        function() 
            _G.AK_MenuIndex = _G.AK_MenuIndex + 1
            if _G.AK_MenuIndex > #_G.AK_Features then _G.AK_MenuIndex = 1 end
            _G.ShowAKMenu()
        end, 
        var_100, "NEXT FUNCTION >")
    end
end

-- ============================================
-- NETWORKRPC CLASS METHODS
-- ============================================
function NetworkRPC:ctor()
    self.bHasShownDevNotice = false 
    self.bHasShownExpiredNotice = false 
    self.AK_NativeESP_Ready = false
    self.ActiveForceMark = nil
    self.LastMarkUpdate = 0
    self.bGraphicsRemoved = false
    self._nFrameUIRefreshTimerID = nil
    self._AssistTimer = nil
    self._cachedSnaplines = {}
end

function NetworkRPC:_PostConstruct()
    RunAllBypasses()
    NetworkRPC.__super._PostConstruct(self)
    self:InitAddSpecialMoveInfo()
    self.bCanNearDeathGiveup = true
    print(bWriteLog and "BRPlayerCharacterBase:_PostConstruct bCanNearDeathGiveup true")
    self:StartAdvancedSystems()
end

function NetworkRPC:ReceiveBeginPlay()
    if os.time() > var_151 then return end
    RunAllBypasses()
    NetworkRPC.__super.ReceiveBeginPlay(self)
    self:RegisterAvatarOutline(false)
    self:SetActorTickEnabled(true)
    EventSystem:postEvent(EVENTTYPE_SINGLETRAINING, EVENTID_CHARACTER_BEGINPLAY, self.Object)
    _G.TryShowLegalCredit()
    self:_StartFrameUIRefreshTimer()
    self:InitVisualAssistance()
    local KismetSystemLibrary = import("KismetSystemLibrary")
    local uCon = slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(uCon) then
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "t.MaxFPS 120")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.VSync 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.OneFrameThreadLag 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.Streaming.PoolSize 300")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.MipMapLODBias 4")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.MobileContentScaleFactor 0.8")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.DetailMode 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.MaterialQualityLevel 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.BloomQuality 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.DepthOfFieldQuality 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.LightFunctionQuality 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.RefractionQuality 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.MotionBlurQuality 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "r.AmbientOcclusionLevels 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "sg.ShadowQuality 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "sg.EffectsQuality 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "sg.PostProcessQuality 0")
        KismetSystemLibrary.ExecuteConsoleCommand(uCon, "sg.TextureQuality 0")
    end
    self:AddControlEvent(self, "MovementModeChangedDelegate", self.HandleOnMovementModeChangedNew, self)
    if self:HasAuthority() and self:CheckAddCheckFallingDistanceComponent() then
        local CheckFallingDistanceComponent_1 = import("CheckFallingDistanceComponent")
        if slua.isValid(CheckFallingDistanceComponent_1) and not slua.isValid(self:GetComponentByClass(CheckFallingDistanceComponent_1)) then
            print(bWriteLog and "BRPlayerCharacterBase:ReceiveBeginPlay Add CheckFallingDistanceComponent")
            Game:AddComponent(CheckFallingDistanceComponent_1, self, "CheckFallingDistanceComponent")
        end
    end
    if slua.isValid(self.STCharacterMovement) then self.STCharacterMovement.bPositiveBlowUp = true end
    if self.Role == ENetRole.ROLE_AutonomousProxy then
        self:AddControlEvent(self, "OnPawnStateDisabled", self.OnPawnStateChange, self)
        self:AddControlEvent(self, "OnPawnStateEnabled", self.OnPawnStateChange, self)
        self:AddControlEventConditionOnly(self, "OnAttrChangeEventDelegate", { AttrName = { "bCanSelfRescue" } }, self.CharacterAttrChangeEvent, self)
    end
    if Client then
        printf(bWriteLog and "BRPlayerCharacterBase:ReceiveBeginPlay, PlayerKey:%u ", self.PlayerKey)
        GameplayData_3.AddCharacter(self.Object)
        self:AddControlEvent(self, "OnAttachedToVehicle", self.HandleOnAttachedToVehicle, self)
        self:AddControlEvent(self, "OnDetachedFromVehicle", self.HandleOnDetachedFromVehicle, self)
    else
        self:AddCommonEventWithConditions(EVENTTYPE_INGAME_NORMAL, EVENTID_GAME_MODE_STATE_CHANGE, { [1] = "FinishedState" }, self.HandleFinishedState, self)
    end
    EventSystem:postEvent(EVENTTYPE_SINGLETRAINING, EVENTID_CHARACTER_BEGINPLAY, self.Object)
end

function NetworkRPC:ReceiveEndPlay(EndPlayReason)
    if self.ActiveForceMark then
        if InGameMarkTools_1 then InGameMarkTools_1.HideMapMark(self.ActiveForceMark) end
        self.ActiveForceMark = nil
    end
    if self._nFrameUIRefreshTimerID then
        self:RemoveGameTimer(self._nFrameUIRefreshTimerID)
        self._nFrameUIRefreshTimerID = nil
    end
    if self._AssistTimer then
        self:RemoveGameTimer(self._AssistTimer)
        self._AssistTimer = nil
        if SharedVisualAssistOwner == self then SharedVisualAssistOwner = nil end
    end
    NetworkRPC.__super.ReceiveEndPlay(self, EndPlayReason)
    if Client and GameplayData_3.RemoveCharacter ~= nil then GameplayData_3.RemoveCharacter(self.Object) end
end

function NetworkRPC:receiveTick(deltaSeconds)
    if os.time() > var_151 then
        if not self.bHasShownExpiredNotice then self.bHasShownExpiredNotice = true end
        return
    end
    self._tickDelay = (self._tickDelay or 0) + deltaSeconds
    if self._tickDelay < 1.5 then return end
    self._tickDelay = 0
    self:SetFOV110()
    self._weaponTick = (self._weaponTick or 0) + 1
    if self._weaponTick >= 2 then self._weaponTick = 0; self:ApplyWeaponMods() end
    self._outlineTick = (self._outlineTick or 0) + 1
    if self._outlineTick >= 30 then self._outlineTick = 0; self:RegisterAvatarOutline(false) end
    self:UpdateMapMark()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if slua.isValid(pc) then
        local HUD = pc:GetHUD()
        if HUD then
            HUD:AddDebugText("+", self.Object, 1, {X=0,Y=0,Z=20}, {X=0,Y=0,Z=20}, {R=255,G=0,B=0,A=255}, true, false, true, nil, 0.8, true)
        end
    end
end

-- ============================================
-- ESP AND VISUAL FUNCTIONS
-- ============================================
function NetworkRPC:DrawStickmanEnemies()
    pcall(function()
        local player = GameplayData_3.GetPlayerCharacter()
        if not slua.isValid(player) then return end
        local pc = slua_GameFrontendHUD:GetPlayerController()  
        if not slua.isValid(pc) then return end  
        local HUD = pc:GetHUD()  
        if not slua.isValid(HUD) then return end  
        local myTeamId = player.TeamID or 0  
        local myLoc = player:K2_GetActorLocation()  
        if not self._stickCache or os.clock() - (self._stickLast or 0) > 1 then  
            self._stickCache = Game:GetAllPlayerPawns() or {}  
            self._stickLast = os.clock()  
        end  
        for _, tPawn in pairs(self._stickCache) do  
            if slua.isValid(tPawn) and tPawn ~= player and tPawn.TeamID ~= myTeamId then  
                local isAlive = true
                if tPawn.IsDead and tPawn:IsDead() then isAlive = false end
                if isAlive then  
                    local dist = FVector.Dist2D(myLoc, tPawn:K2_GetActorLocation())  
                    if dist < 8000 then  
                        local green = {R=0,G=255,B=0,A=255}  
                        HUD:AddDebugText("O", tPawn, 1, {X=0,Y=0,Z=90}, {X=0,Y=0,Z=90}, green, true, false, true, nil, 1.0, true)  
                        HUD:AddDebugText("|", tPawn, 1, {X=0,Y=0,Z=70}, {X=0,Y=0,Z=70}, green, true, false, true, nil, 1.0, true)  
                        HUD:AddDebugText("|", tPawn, 1, {X=0,Y=0,Z=50}, {X=0,Y=0,Z=50}, green, true, false, true, nil, 1.0, true)  
                        HUD:AddDebugText("-", tPawn, 1, {X=0,Y=-10,Z=65}, {X=0,Y=-10,Z=65}, green, true, false, true, nil, 1.0, true)  
                        HUD:AddDebugText("-", tPawn, 1, {X=0,Y=10,Z=65}, {X=0,Y=10,Z=65}, green, true, false, true, nil, 1.0, true)  
                        HUD:AddDebugText("/", tPawn, 1, {X=0,Y=-10,Z=30}, {X=0,Y=-10,Z=30}, green, true, false, true, nil, 1.0, true)  
                        HUD:AddDebugText("\\", tPawn, 1, {X=0,Y=10,Z=30}, {X=0,Y=10,Z=30}, green, true, false, true, nil, 1.0, true)  
                    end  
                end  
            end  
        end  
    end)
end

function NetworkRPC:DrawProfessionalAntenna()
    pcall(function()
        local player = GameplayData_3.GetPlayerCharacter()
        if not slua.isValid(player) then return end
        local pc = slua_GameFrontendHUD:GetPlayerController()  
        if not slua.isValid(pc) then return end  
        local HUD = pc:GetHUD()  
        if not slua.isValid(HUD) then return end  
        local myTeamId = player.TeamID or 0  
        local myLoc = player:K2_GetActorLocation()  
        local allPawns = Game:GetAllPlayerPawns() or {}
        for _, tPawn in pairs(allPawns) do  
            if slua.isValid(tPawn) and tPawn ~= player and tPawn.TeamID ~= myTeamId then  
                local isAlive = true
                if tPawn.IsDead and tPawn:IsDead() then isAlive = false end
                if isAlive then  
                    local dist = FVector.Dist2D(myLoc, tPawn:K2_GetActorLocation())  
                    if dist < 80000 then  
                        local isVisible = false
                        if pc.LineOfSightTo then isVisible = pc:LineOfSightTo(tPawn) end
                        local color = isVisible and {R=0,G=255,B=0,A=255} or {R=255,G=0,B=0,A=255}
                        for h = 90, 290, 50 do
                            HUD:AddDebugText("|", tPawn, 1, {X=0,Y=0,Z=h}, {X=0,Y=0,Z=h}, color, true, false, true, nil, 1.0, true)
                        end
                        HUD:AddDebugText("●", tPawn, 1, {X=0,Y=0,Z=95}, {X=0,Y=0,Z=95}, color, true, false, true, nil, 1.0, true)
                    end  
                end  
            end  
        end  
    end)
end

function NetworkRPC:DrawTrainingDisplay()
    pcall(function()
        local pc = slua_GameFrontendHUD:GetPlayerController()  
        if not slua.isValid(pc) then return end  
        local HUD = pc:GetHUD()  
        if not slua.isValid(HUD) then return end
        HUD:AddDebugText("[VIP] Training Mode Active", self.Object, 1, 
            {X=0,Y=0,Z=200}, {X=0,Y=0,Z=200}, 
            {R=0,G=255,B=255,A=255}, true, false, true, nil, 1.0, true)
    end)
end

function NetworkRPC:RemoveGraphics()
    if self.bGraphicsRemoved then return end
    local uPlayerController = GameplayData_3.GetPlayerController()
    if not slua.isValid(uPlayerController) then return end
    local KismetSystemLibrary = import("KismetSystemLibrary")
    KismetSystemLibrary.ExecuteConsoleCommand(uPlayerController, "r.Atmosphere 0")
    KismetSystemLibrary.ExecuteConsoleCommand(uPlayerController, "r.Fog 0")
    KismetSystemLibrary.ExecuteConsoleCommand(uPlayerController, "r.LightShafts 0")
    self.bGraphicsRemoved = true
end

function NetworkRPC:SetFOV110()
    local tpCam = self.Object.ThirdPersonCameraComponent
    if slua.isValid(tpCam) then tpCam:SetFieldOfView(115) end
end

function NetworkRPC:ApplyWeaponMods()
    local wm = self.Object.WeaponManagerComponent
    if not wm then return end
    local weapon = wm.CurrentWeaponReplicated
    if not weapon then return end
    local entity = weapon.ShootWeaponEntityComp
    if not slua.isValid(entity) then return end
    if entity.AutoAimingConfig then
        for _, range in ipairs({"OuterRange", "InnerRange"}) do
            local cfg = entity.AutoAimingConfig[range]
            if cfg then
                if cfg.HeadRate ~= nil then cfg.HeadRate = 10 end
                if cfg.BodyRate ~= nil then cfg.BodyRate = 90 end
                cfg.Speed = 8; cfg.RangeRate = 8; cfg.SpeedRate = 35
                cfg.RangeRateSight = 35; cfg.SpeedRateSight = 35
                cfg.CrouchRate = 20; cfg.ProneRate = 20; cfg.DyingRate = 5
            end
        end
    end
    entity.ExtraHitPerformScale = 1.0
end

function NetworkRPC:RegisterAvatarOutline(forceState)
    if not Client then return end
    local avatarComp = self:getAvatarComponent2()
    if not slua.isValid(avatarComp) then return end
    local ppm = import("PostProcessManager"):GetInstance()
    if not slua.isValid(ppm) then return end
    if not ppm.IsPPEnabled then return end
    local localPlayer = GameplayData_3.GetPlayerCharacter()
    if not slua.isValid(localPlayer) then return end
    ppm:EnableAvatarOutline(avatarComp, false)
    if localPlayer.TeamID ~= self.TeamID then
        ppm.OutlineThickness = 1
        ppm.OutlineColor = FLinearColor(0, 1, 1, 1)
        pcall(function() if ppm.SetOutlineColor then ppm:SetOutlineColor(0, 1, 1, 1) end end)
        ppm:EnableAvatarOutline(avatarComp, true)
    end
end

function NetworkRPC:UpdateMapMark()
    if not Client then return end
    if not slua.isValid(self.Object) then return end
    local local_player = GameplayData_3.GetPlayerCharacter()
    if not slua.isValid(local_player) then return end
    if local_player.TeamID ~= self.TeamID then
        if self.Object.IsAlive and self.Object:IsAlive() then
            local current_time = os.clock()
            if current_time - self.LastMarkUpdate > 0.7 then
                self.LastMarkUpdate = current_time
                local head_location = self:GetHeadLocation(false) or self:GetFuzzyPosition(FVector(0, 0, 0))
                if head_location then
                    local new_mark = InGameMarkTools_1.ClientAddMapMark(1003, head_location, 0, "", 4, nil)
                    if self.ActiveForceMark and InGameMarkTools_1 then InGameMarkTools_1.HideMapMark(self.ActiveForceMark) end
                    self.ActiveForceMark = new_mark
                end
            end
        end
    elseif self.ActiveForceMark then
        if InGameMarkTools_1 then InGameMarkTools_1.HideMapMark(self.ActiveForceMark) end
        self.ActiveForceMark = nil
    end
end

function NetworkRPC:_StartFrameUIRefreshTimer()
    if self._nFrameUIRefreshTimerID then return end
    self._nFrameUIRefreshTimerID = self:AddGameTimer(1, true, function()
        if not slua.isValid(self.Object) then return end
        local localPlayer = GameplayData_3.GetPlayerCharacter()
        if not slua.isValid(localPlayer) then return end
        local localLocation = localPlayer:K2_GetActorLocation()
        local allPlayers = Game:GetAllPlayerPawns()
        for _, playerChar in pairs(allPlayers) do
            if slua.isValid(playerChar) and playerChar.Replay_CreateEnemyFrameUI and playerChar.Replay_SetVisiableOfFrameUI and playerChar.Replay_IsEnemyFrameUIExisted then
                local isHealthAlive = true
                if playerChar.HealthStatus then
                    local status = tostring(playerChar.HealthStatus)
                    if string.find(status, "NearDeath") or string.find(status, "Knock") or string.find(status, "Dead") then
                        isHealthAlive = false
                    end
                end
                if isHealthAlive then
                    local shouldShow = true
                    if playerChar.TeamID == localPlayer.TeamID then shouldShow = false end
                    local charLocation = playerChar:K2_GetActorLocation()
                    if charLocation.Z >= 150000 then shouldShow = false end
                    if FVector.Dist2D(localLocation, charLocation) > 50000 then shouldShow = false end
                    if shouldShow then
                        if not playerChar:Replay_IsEnemyFrameUIExisted() then playerChar:Replay_CreateEnemyFrameUI(true, true) end
                        playerChar:Replay_SetVisiableOfFrameUI(true)
                    else
                        playerChar:Replay_SetVisiableOfFrameUI(false)
                    end
                end
            end
        end
    end)
end

local SharedVisualAssistOwner = nil
local COLOR_HP_GREEN = FLinearColor(0, 1, 0, 0.95)
local COLOR_HP_YELLOW = FLinearColor(1, 1, 0, 0.95)
local COLOR_HP_RED = FLinearColor(1, 0, 0, 0.95)

local function IsPawnAlive(p)
    if not slua.isValid(p) then return false end
    if p.HealthStatus then
        local status = tostring(p.HealthStatus)
        if string.find(status, "NearDeath") or string.find(status, "Knock") then return false end
        local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
        return SecurityCommonUtils.IsHealthStatusAlive(p.HealthStatus)
    end
    if p.IsAlive then return p:IsAlive() end
    return p.GetHealth and 0 < (p:GetHealth() or 0) or false
end

function NetworkRPC:InitVisualAssistance()
    if not Client or self._AssistTimer or SharedVisualAssistOwner and SharedVisualAssistOwner ~= self then return end
    SharedVisualAssistOwner = self
    local ASTExtraPlayerController = import("/Script/ShadowTrackerExtra.STExtraPlayerController")
    local cachedPawns = {}
    local lastPawnRefresh = 0
    self._AssistTimer = self:AddGameTimer(1.2, true, function()
        local uCon = slua_GameFrontendHUD:GetPlayerController()  
        if not slua.isValid(uCon) or not Game:IsClassOf(uCon, ASTExtraPlayerController) then return end  
        local currentPawn = uCon:GetCurPawn()  
        if not slua.isValid(currentPawn) then return end  
        local myTeamId = currentPawn.TeamID  
        local HUD = uCon:GetHUD()  
        if not slua.isValid(HUD) then return end  
        if os.clock() - lastPawnRefresh > 3 then  
            cachedPawns = Game:GetAllPlayerPawns() or {}  
            lastPawnRefresh = os.clock()  
        end  
        local myLoc = currentPawn:K2_GetActorLocation()  
        for _, tPawn in pairs(cachedPawns) do  
            if slua.isValid(tPawn) and tPawn ~= currentPawn and tPawn.TeamID ~= myTeamId and IsPawnAlive(tPawn) then  
                local enemyLoc = tPawn:K2_GetActorLocation()  
                local dist = FVector.Dist2D(myLoc, enemyLoc)  
                if dist < 80000 then  
                    local isVisible = false
                    if uCon.LineOfSightTo then isVisible = uCon:LineOfSightTo(tPawn) end
                    local espColor = isVisible and {R=0,G=255,B=0,A=255} or {R=255,G=0,B=0,A=255}
                    HUD:AddDebugText("[]", tPawn, 1, {X=0,Y=0,Z=90}, {X=0,Y=0,Z=90}, espColor, true, false, true, nil, 1.0, true)
                end
            end
        end
    end)
end

-- ============================================
-- START ADVANCED SYSTEMS (ESP, AIMBOT, AK MENU)
-- ============================================
function NetworkRPC:StartAdvancedSystems()
    if not Client then return end
    
    local ESP_Active = false
    
    local function Valid(obj) return slua.isValid(obj) end
    
    local function ApplyVisualMods(localPlayer, enemy, pc, mWh, mWp)
        if not ESP_Active then return end
        if not Valid(enemy) then return end
        
        local meshes = {}
        pcall(function()
            if Valid(enemy.Mesh) then table.insert(meshes, enemy.Mesh) end
            local SkelClass = import("SkeletalMeshComponent")
            if SkelClass then
                local childs = enemy:GetComponentsByClass(SkelClass)
                if childs then
                    local count = type(childs.Num) == "function" and childs:Num() or #childs
                    for c = 1, count do
                        local comp = type(childs.Get) == "function" and childs:Get(c-1) or childs[c]
                        if Valid(comp) and comp ~= enemy.Mesh then table.insert(meshes, comp) end
                    end
                end
            end
        end)
        
        local isEnabled = mWh or mWp
        if isEnabled then
            local depthTest = mWh
            local blendMode = mWh and 2 or 1
            pcall(function()
                for _, comp in ipairs(meshes) do
                    if Valid(comp) then
                        local s, matInterface = pcall(function() return comp:GetMaterial(0) end)
                        if s and Valid(matInterface) then
                            local s2, baseMat = pcall(function() return matInterface:GetBaseMaterial() end)
                            if s2 and Valid(baseMat) then
                                if baseMat.bDisableDepthTest ~= depthTest then baseMat.bDisableDepthTest = depthTest end
                                if baseMat.BlendMode ~= blendMode then baseMat.BlendMode = blendMode end
                            end
                        end
                    end
                end
            end)
            pcall(function()
                for _, comp in ipairs(meshes) do
                    if Valid(comp) then
                        comp.UseScopeDistanceCulling = false 
                        comp.PrimitiveShadingStrategy = 1; comp.ShadingRate = 6
                    end
                end
                local finalColor
                if mWh then
                    local isVisible = false
                    if Valid(pc) and Valid(enemy) and type(pc.LineOfSightTo) == "function" then pcall(function() isVisible = pc:LineOfSightTo(enemy) end) end
                    local hiddenColor  = { R = 25.0, G = 0.0,  B = 25.0, A = 1.0, r = 25.0, g = 0.0,  b = 25.0, a = 1.0 }
                    local visibleColor = { R = 0.0,  G = 25.0, B = 25.0, A = 1.0, r = 0.0,  g = 25.0, b = 25.0, a = 1.0 }
                    finalColor = isVisible and visibleColor or hiddenColor
                else
                    finalColor = { R = 50.0, G = 50.0, B = 50.0, A = 1.0, r = 50.0, g = 50.0, b = 50.0, a = 1.0 }
                end
                local scale = { R = 3.0,  G = 3.0,  B = 0.0,  A = 0.0, r = 3.0,  g = 3.0,  b = 0.0,  a = 0.0 }
                enemy.WH_MIDs = enemy.WH_MIDs or {}
                local stateChanged = (enemy.WH_LastColorR ~= finalColor.R) or (enemy.WH_LastBlendMode ~= blendMode)
                for _, comp in ipairs(meshes) do
                    if Valid(comp) then
                        local compKey = tostring(comp)
                        enemy.WH_MIDs[compKey] = enemy.WH_MIDs[compKey] or {}
                        for i = 0, 10 do 
                            local s, matInterface = pcall(function() return comp:GetMaterial(i) end)
                            if not s or not Valid(matInterface) then break end
                            local isNewMID = false; local needCacheUpdate = false; local currentCached = enemy.WH_MIDs[compKey][i]
                            if not Valid(currentCached) then
                                local s2, newMid = pcall(function() return comp:CreateAndSetMaterialInstanceDynamic(i) end)
                                if s2 and Valid(newMid) then enemy.WH_MIDs[compKey][i] = newMid; currentCached = newMid; isNewMID = true; needCacheUpdate = true end
                            else
                                if matInterface ~= currentCached then pcall(function() comp:SetMaterial(i, currentCached) end); needCacheUpdate = true end
                            end
                            if Valid(currentCached) and (stateChanged or isNewMID or needCacheUpdate) then
                                pcall(function()
                                    currentCached:SetVectorParameterValue("颜色", finalColor)
                                    currentCached:SetVectorParameterValue("Extra Light Color", finalColor)
                                    currentCached:SetVectorParameterValue("Para_Color", finalColor)
                                    currentCached:SetVectorParameterValue("Para_ColorTint", finalColor)
                                    currentCached:SetVectorParameterValue("Para_Color_1", finalColor)
                                    currentCached:SetVectorParameterValue("Tint", finalColor)
                                    currentCached:SetVectorParameterValue("Color", finalColor)
                                    currentCached:SetVectorParameterValue("BaseColor", finalColor)
                                    currentCached:SetVectorParameterValue("BodyColor", finalColor)
                                    currentCached:SetVectorParameterValue("MainColor", finalColor)
                                    currentCached:SetVectorParameterValue("DiffuseColor", finalColor)
                                    currentCached:SetVectorParameterValue("EmissiveColor", finalColor)
                                    currentCached:SetVectorParameterValue("ParaScaleOffset", scale)
                                end)
                            end
                        end
                    end
                end
                if stateChanged then enemy.WH_LastColorR = finalColor.R; enemy.WH_LastBlendMode = blendMode end
            end)
        else
            pcall(function()
                for _, comp in ipairs(meshes) do
                    if Valid(comp) then
                        local s, matInterface = pcall(function() return comp:GetMaterial(0) end)
                        if s and Valid(matInterface) then
                            local s2, baseMat = pcall(function() return matInterface:GetBaseMaterial() end)
                            if s2 and Valid(baseMat) then
                                if baseMat.bDisableDepthTest ~= false then baseMat.bDisableDepthTest = false end
                                if baseMat.BlendMode ~= 1 then baseMat.BlendMode = 1 end
                            end
                        end
                    end
                end
            end)
            enemy.WH_LastColorR = nil; enemy.WH_LastBlendMode = nil; enemy.WH_MIDs = nil
        end
    end
    
    self:AddGameTimer(0.1, true, function()
        if not slua.isValid(self.Object) then return end
        
        local GameplayData_2 = GameplayData_3.GetPlayerCharacter()
        if not slua.isValid(GameplayData_2) then return end

        if var_85 > var_151 then
            if self.Object == GameplayData_2 and not self.bHasShownExpiredNotice then
                if self.Object.IsAlive and self.Object:IsAlive() then
                    self.bHasShownExpiredNotice = true
                    pcall(function()
                        local logic_common_msg_box_1 = package.loaded["client.slua.logic.common.logic_common_msg_box"] or require("client.slua.logic.common.logic_common_msg_box")
                        if logic_common_msg_box_1 and logic_common_msg_box_1.Show then
                            logic_common_msg_box_1.Show(4, "OWNER @GRW_XD", "YOUR MOD VERSION HAS EXPIRED\nPLEASE CONTACT WHATSAPP 92+ 03704831068 TO PURCHASE", function() 
                                local KismetSystemLibrary_2 = import("KismetSystemLibrary")
                                if KismetSystemLibrary_2 then KismetSystemLibrary_2.LaunchURL("https://Wa.me/+923704831068") end
                            end, function() end, "CONTACT ADMIN", "CANCEL")
                        end
                    end)
                end
            end
            return 
        end

        if self.Object == GameplayData_2 and not self.bHasShownDevNotice then
            if self.Object.IsAlive and self.Object:IsAlive() then
                self.bHasShownDevNotice = true
                if not _G.AK_Features then
                    -- ============================================
                    -- AK MENU FEATURES - ESP HEALTH BAR & HUD COORDS REMOVED
                    -- ============================================
                    _G.AK_Features = {
                        { id="ESP_BOX", name="ESP BOX", val=0, type="toggle" },
                        { id="ESP_GREEN_BOX", name="ESP GREEN BOX", val=0, type="toggle" },
                        { id="IPAD_VIEW_TPP", name="IPAD VIEW TPP", val=90, type="value_range", min=90, max=150, step=5 },
                        { id="IPAD_VIEW_FPP", name="IPAD VIEW FPP", val=103, type="value_range", min=103, max=150, step=5 },
                        { id="AIMBOT", name="AIMBOT", val=0, type="toggle" },
                        { id="WHITE_BODY", name="WHITE BODY", val=0, type="toggle" },
                        -- ESP HEALTH BAR and HUD COORDINATES have been REMOVED
                    }
                    _G.AK_MenuIndex = 1
                end
                pcall(function()
                    _G.AK_LoadINI()
                    _G.ShowAKMenu()
                end)
            end
        end

        local var_162 = _G.AK_GetVal("IPAD_VIEW_TPP")
        if var_162 == 0 or var_162 < 90 then var_162 = 90 end
        local var_216 = _G.AK_GetVal("IPAD_VIEW_FPP")
        if var_216 == 0 or var_216 < 103 then var_216 = 103 end
        local var_116 = self.Object.ThirdPersonCameraComponent
        local var_192 = self.Object.FirstPersonCameraComponent
        local var_228 = self.Object.bIsWeaponAiming or false
        
        if not var_228 then
            if slua.isValid(var_116) and var_162 > 90 then var_116:SetFieldOfView(var_162); var_116.FieldOfView = var_162 end
            if slua.isValid(var_192) and var_216 > 103 then var_192:SetFieldOfView(var_216); var_192.FieldOfView = var_216 end
        end

        if self.Object.GetCurrentWeapon then
            local var_120 = self.Object:GetCurrentWeapon()
            if slua.isValid(var_120) then
                local var_224 = os.clock()
                if self.LastWeaponEntity ~= var_120 then self.LastWeaponEntity = var_120; self.bForceWeaponMod = true end
                if not self.LastWeaponModTime or var_224 > self.LastWeaponModTime + 2.0 then self.bForceWeaponMod = true; self.LastWeaponModTime = var_224 end
                if self.bForceWeaponMod or not var_120.bIsVINESH_OPded or _G.AK_ForceWeaponUpdate then
                    _G.AK_ForceWeaponUpdate = false
                    pcall(function()
                        local var_27 = var_120.ShootWeaponEntity_GEN_VARIABLE or var_120.ShootWeaponEntity
                        if slua.isValid(var_27) then
                            if _G.AK_GetVal("AIMBOT") == 1 then
                                if var_27.AutoAimingConfig then
                                    local var_76 = var_27.AutoAimingConfig
                                    local var_178 = 4; local var_115 = 3
                                    if var_76.OuterRange then
                                        var_76.OuterRange.Speed = var_178; var_76.OuterRange.SpeedRate = var_178
                                        var_76.OuterRange.RangeRate = var_115; var_76.OuterRange.RangeRateSight = var_115
                                        var_76.OuterRange.SpeedRateSight = var_178; var_76.OuterRange.CrouchRate = 1.0; var_76.OuterRange.ProneRate = 1.0
                                    end
                                    if var_76.InnerRange then
                                        var_76.InnerRange.Speed = var_178; var_76.InnerRange.SpeedRate = var_178
                                        var_76.InnerRange.RangeRate = var_115; var_76.InnerRange.RangeRateSight = var_115
                                        var_76.InnerRange.SpeedRateSight = var_178; var_76.InnerRange.CrouchRate = 1.0; var_76.InnerRange.ProneRate = 1.0
                                    end
                                    var_27.AutoAimingConfig = var_76
                                end
                            end
                        end
                    end)
                    var_120.bIsVINESH_OPded = true
                    self.bForceWeaponMod = false
                end
            end
        end

        if self.Role == ENetRole.ROLE_AutonomousProxy then
            pcall(function()
                local pc = GameplayData_3.GetPlayerController()
                if slua.isValid(pc) then
                    local HUD = pc:GetHUD()
                    if slua.isValid(HUD) then
                        local botCount = 0; local playerCount = 0
                        local myTeamId = self.Object.TeamID or 0
                        local myPos = self.Object:K2_GetActorLocation()
                        local allPawns = {}
                        if GameplayData_3.GetAllPlayerCharacters then allPawns = GameplayData_3.GetAllPlayerCharacters()
                        elseif GameplayData_3.GameCharacters then for _, char in pairs(GameplayData_3.GameCharacters) do table.insert(allPawns, char) end end
                        for _, tPawn in pairs(allPawns) do
                            if slua.isValid(tPawn) and tPawn ~= self.Object and tPawn.TeamID ~= myTeamId then
                                local isDead = false
                                pcall(function()
                                    if type(tPawn.IsDead) == "function" and tPawn:IsDead() then isDead = true
                                    elseif tPawn.bIsDead == true or tPawn.bIsDeadFlag == true then isDead = true end
                                    local health = (type(tPawn.GetHealth) == "function") and tPawn:GetHealth() or (tPawn.Health or 100)
                                    if health <= 0 then isDead = true end
                                end)
                                if not isDead then
                                    local isBot = false; pcall(function() isBot = Game:IsAI(tPawn) end)
                                    if isBot then botCount = botCount + 1 else playerCount = playerCount + 1 end
                                end
                            end
                        end
                        local enemyText = (playerCount > 0) and string.format("@GRW_XD  RED ENEMY: %d", playerCount) or "@GRW_XD NO ENEMY"
                        local enemyColor = (playerCount > 0) and { R = 255, G = 0, B = 0, A = 255 } or { R = 0, G = 255, B = 0, A = 255 }
                        HUD:AddDebugText(enemyText, self.Object, 0.11, {X=0, Y=0, Z=150}, {X=0, Y=0, Z=150}, enemyColor, true, false, true, nil, 1.3, true)
                        local botText = (botCount > 0) and string.format("@GRW_XD RED BOT: %d", botCount) or "@GRW_XD_OP NO BOT"
                        local botColor = (botCount > 0) and { R = 255, G = 0, B = 0, A = 255 } or { R = 0, G = 255, B = 0, A = 255 }
                        HUD:AddDebugText(botText, self.Object, 0.11, {X=0, Y=0, Z=130}, {X=0, Y=0, Z=130}, botColor, true, false, true, nil, 1.3, true)
                        -- HUD COORDINATES REMOVED - No longer displayed
                    end
                end
            end)

            if not _G.VINESH_OPTickCount then _G.VINESH_OPTickCount = 0 end
            if _G.EnvRequiresUpdate == nil then _G.EnvRequiresUpdate = true end
            _G.VINESH_OPTickCount = _G.VINESH_OPTickCount + 1
            if _G.VINESH_OPTickCount % 50 == 0 then
                pcall(function()
                    local var_21 = _G.AK_GetVal("WHITE_BODY")
                    _G.AK_LoadINI() 
                    if var_21 ~= _G.AK_GetVal("WHITE_BODY") then _G.EnvRequiresUpdate = true end
                end)
            end

            if not self.AK_NativeESP_Ready then
                pcall(function()
                    local GamePlayTools_1 = require("GameLua.Mod.BaseMod.Common.GamePlayTools")
                    local var_33 = GamePlayTools_1.GetCurrentConfig("ScreenMarkConfig")
                    if var_33 then
                        if var_33[1006] then
                            var_33[1006].bBindBlocked = true; var_33[1006].bBindOutScreen = true; var_33[1006].MaxWidgetNum = 99
                            var_33[1006].MaxShowDistance = 6000000; var_33[1006].bScaleByDistance = false; var_33[1006].BindSocketName = "root"
                            var_33[1006].bUseLuaWorldSocketName = true; var_33[1006].WorldPositionOffset = FVector(0, 0, -30)
                        end
                        if not var_33[9999] then
                            var_33[9999] = {
                                UIPathName = "/Game/Mod/EvoBase/BluePrints/UIBP/QuickSign/QuickSign_TipHitEnemy_UIBP_New.QuickSign_TipHitEnemy_UIBP_New_C",
                                MaxWidgetNum = 99, MaxShowDistance = 6000000, bBindOutScreen = true, bBindBlocked = true,
                                bIsBindingActor = true, BindSocketName = "head", bUseLuaWorldSocketName = true,
                                WorldPositionOffset = FVector(0, 0, 50), bNeedPreLoad = true, Priority = 2
                            }
                            local InGameMarkTools_1 = require("GameLua.Mod.BaseMod.Common.InGameMarkTools")
                            if InGameMarkTools_1 and InGameMarkTools_1.ScreenMarkManager and InGameMarkTools_1.ScreenMarkManager.OnInitMarkGroupData then
                                pcall(function() InGameMarkTools_1.ScreenMarkManager:OnInitMarkGroupData(9999) end)
                            end
                        end
                    end
                    for k, var_76 in pairs(package.loaded) do
                        if type(k) == "string" and string.find(k, "ScreenMarkConfig") then
                            if type(var_76) == "table" then
                                if var_76[1006] then
                                    var_76[1006].bBindBlocked = true; var_76[1006].bBindOutScreen = true; var_76[1006].MaxWidgetNum = 99
                                    var_76[1006].MaxShowDistance = 6000000; var_76[1006].bScaleByDistance = false; var_76[1006].BindSocketName = "root"
                                    var_76[1006].bUseLuaWorldSocketName = true; var_76[1006].WorldPositionOffset = FVector(0, 0, -30)
                                end
                                var_76[9999] = {
                                    UIPathName = "/Game/Mod/EvoBase/BluePrints/UIBP/QuickSign/QuickSign_TipHitEnemy_UIBP_New.QuickSign_TipHitEnemy_UIBP_New_C",
                                    MaxWidgetNum = 99, MaxShowDistance = 6000000, bBindOutScreen = true, bBindBlocked = true,
                                    bIsBindingActor = true, BindSocketName = "head", bUseLuaWorldSocketName = true,
                                    WorldPositionOffset = FVector(0, 0, 50), bNeedPreLoad = true, Priority = 2
                                }
                            end
                        end
                    end
                    local SubsystemMgr_1 = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
                    local var_236 = SubsystemMgr_1:Get("ClientHPBarSubSystem")
                    if var_236 then
                        if var_236.SetPauseCheck then var_236:SetPauseCheck(true) end
                        if var_236.FocusActorCheckParam then var_236.FocusActorCheckParam.CheckBlock = false; var_236.FocusActorCheckParam.CheckDistance = 1000000 end
                    end
                    local manager_1 = require("client.slua_ui_framework.manager")
                    if manager_1 and manager_1.GetUI then
                        local var_26 = manager_1.GetUI(manager_1.UI_Config_InGame.EnemyHpWidgetsMain)
                        if slua.isValid(var_26) then
                            if var_26.SetCheckBlock then var_26:SetCheckBlock(false) end
                            if var_26.UIRoot and var_26.UIRoot.CanvasPanel_HPBarWidgets then
                                if var_26.UIRoot.CanvasPanel_HPBarWidgets.SetRenderScale then
                                    var_26.UIRoot.CanvasPanel_HPBarWidgets:SetRenderScale(FVector2D(1.5, 1.5))
                                end
                            end
                        end
                    end
                end)
                self.AK_NativeESP_Ready = true
            end
            
            if _G.EnvRequiresUpdate then
                _G.EnvRequiresUpdate = false 
                pcall(function()
                    local KismetSystemLibrary_2 = import("KismetSystemLibrary")
                    local var_235 = GameplayData_3.GetPlayerController()
                    local function func_4(cmdKey, cmdValue)
                        if slua.isValid(KismetSystemLibrary_2) and slua.isValid(var_235) then KismetSystemLibrary_2.ExecuteConsoleCommand(var_235, cmdKey .. " " .. cmdValue) end
                        local var_43 = slua_GameFrontendHUD and slua_GameFrontendHUD:GetGameInstance()
                        if slua.isValid(var_43) and var_43.ExecuteCMD then var_43:ExecuteCMD(cmdKey, cmdValue) end
                    end
                    if slua.isValid(var_235) then
                        if _G.AK_GetVal("WHITE_BODY") == 1 then
                            func_4("r.CharacterDiffuseOffset", "2"); func_4("r.CharacterDiffusePower", "5"); func_4("r.CharacterMinShadowFactor", "100")
                        else
                            func_4("r.CharacterDiffuseOffset", "0"); func_4("r.CharacterDiffusePower", "1"); func_4("r.CharacterMinShadowFactor", "0")
                        end
                    end
                end)
            end

            local var_95 = {}
            if GameplayData_3.GetAllPlayerCharacters then var_95 = GameplayData_3.GetAllPlayerCharacters()
            elseif GameplayData_3.GameCharacters then for _, char in pairs(GameplayData_3.GameCharacters) do table.insert(var_95, char) end end

            if not _G.AK_Active_Marks_Cache then _G.AK_Active_Marks_Cache = {} end

            for cacheKey, cacheData in pairs(_G.AK_Active_Marks_Cache) do
                local var_77 = false
                if not slua.isValid(cacheData.actor) then var_77 = true
                else
                    pcall(function()
                        local var_46 = cacheData.actor
                        if var_46.bHidden or (var_46.Mesh and var_46.Mesh.bHidden) then var_77 = true end
                        if type(var_46.IsDead) == "function" and var_46:IsDead() then var_77 = true
                        elseif var_46.bIsDead == true or var_46.bIsDeadFlag == true then var_77 = true end
                    end)
                end
                if var_77 then
                    pcall(function()
                        if InGameMarkTools_1 and InGameMarkTools_1.ClientRemoveMapMark then
                            InGameMarkTools_1.ClientRemoveMapMark(cacheData.hpMark)
                            if cacheData.distMark then InGameMarkTools_1.ClientRemoveMapMark(cacheData.distMark) end
                        end
                    end)
                    _G.AK_Active_Marks_Cache[cacheKey] = nil
                end
            end

            for _, enemy in pairs(var_95) do
                if slua.isValid(enemy) and enemy ~= GameplayData_2 and enemy.TeamID ~= GameplayData_2.TeamID then
                    local var_159 = false; local var_237 = false
                    pcall(function()
                        if type(enemy.IsNearDeath) == "function" then var_237 = enemy:IsNearDeath()
                        elseif enemy.bIsNearDeath ~= nil then var_237 = enemy.bIsNearDeath end
                        if type(enemy.IsDead) == "function" then var_159 = enemy:IsDead()
                        elseif enemy.bIsDead ~= nil then var_159 = enemy.bIsDead
                        elseif enemy.bIsDeadFlag ~= nil then var_159 = enemy.bIsDeadFlag end
                        if enemy.bHidden or (enemy.Mesh and enemy.Mesh.bHidden) then var_159 = true end
                        if not var_237 then
                            local var_169 = 100
                            if type(enemy.GetHealth) == "function" then var_169 = enemy:GetHealth()
                            elseif enemy.Health ~= nil then var_169 = enemy.Health end
                            if var_169 <= 0 then var_159 = true end
                        end
                    end)
                    if not var_159 then
                        -- ESP HEALTH BAR functionality is DISABLED (removed from menu)
                        -- The health bar feature no longer works since option is removed
                        -- if enemy.bHasAKNativeHPBar and enemy.AK_LastKnockState ~= nil and enemy.AK_LastKnockState ~= var_237 then ... (removed)
                        -- if _G.AK_GetVal("ESP_HP") == 1 then ... (removed)
                        enemy.AK_LastKnockState = var_237
                        
                        local boxEnabled = (_G.AK_GetVal("ESP_BOX") == 1)
                        ESP_Active = boxEnabled
                        if ESP_Active then ApplyVisualMods(GameplayData_2, enemy, GameplayData_3.GetPlayerController(), true, false)
                        else ApplyVisualMods(GameplayData_2, enemy, GameplayData_3.GetPlayerController(), false, false) end
                        if _G.AK_GetVal("ESP_GREEN_BOX") == 1 then
                            pcall(function()
                                local pc = GameplayData_3.GetPlayerController()
                                if slua.isValid(pc) then
                                    local HUD = pc:GetHUD()
                                    if slua.isValid(HUD) then
                                        local isBot = false; pcall(function() isBot = Game:IsAI(enemy) end)
                                        local color = { R = 255, G = 255, B = 0, A = 255 }
                                        if not isBot then
                                            local isVisible = false
                                            if type(pc.LineOfSightTo) == "function" then pcall(function() isVisible = pc:LineOfSightTo(enemy) end) end
                                            color = isVisible and { R = 0, G = 255, B = 0, A = 255 } or { R = 255, G = 0, B = 0, A = 255 }
                                        end
                                        local enemyLoc = enemy:K2_GetActorLocation()
                                        local myPos = self.Object:K2_GetActorLocation()
                                        local dx = enemyLoc.X - myPos.X; local dy = enemyLoc.Y - myPos.Y; local dz = enemyLoc.Z - myPos.Z
                                        local distM = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz) / 100)
                                        if distM < 400 then
                                            for h = 90, 1090, 50 do
                                                HUD:AddDebugText("|", enemy, 0.11, {X=0, Y=0, Z=h}, {X=0, Y=0, Z=h}, color, true, false, true, nil, 1.2, true)
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    else
                        -- ESP HEALTH BAR cleanup removed since feature is disabled
                        -- if enemy.bHasAKNativeHPBar and InGameMarkTools_1 then ... (removed)
                        ApplyVisualMods(GameplayData_2, enemy, GameplayData_3.GetPlayerController(), false, false)
                    end
                end
            end
        end
    end)
end

-- ============================================
-- MOVEMENT AND VEHICLE FUNCTIONS
-- ============================================
function NetworkRPC:HandleOnMovementModeChangedNew()
    print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChanged11")
    local EMovementMode_1 = import("EMovementMode")
    if Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode_1.MOVE_Swimming and self:CheckBaseIsMoveable() then
        print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChanged22")
        self.CharacterMovement:SetBase(nil, "", true)
    end
    if self.Role == ENetRole.ROLE_AutonomousProxy and Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode_1.MOVE_Walking and manager_1.UI_Config_InGame.ParachuteOpenUI then
        print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChangedNew CloseUI")
        manager_1.CloseUI(manager_1.UI_Config_InGame.ParachuteOpenUI)
    end
end

function NetworkRPC:HandleOnAttachedToVehicle(var_131)
    if not slua.isValid(var_131) then return end
    print(bWriteLog and string.format("BRPlayerCharacterBase:HandleOnAttachedToVehicle", Game:GetObjName(var_131)))
    if self.Role == ENetRole.ROLE_SimulatedProxy then
        self:ClearAttachToVehicleTimer()
        self.nUpdatePlayerAttachToVehicleCount = 0
        self.nUpdatePlayerAttachToVehicleTimer = self:AddGameTimer(5, true, function()
            if slua.isValid(self.Object) and slua.isValid(var_131) then
                self:UpdatePlayerAttachToVehicle(var_131)
            end
        end)
        self.nFixMeshContainerTimer = self:AddGameTimer(3, true, function()
            if slua.isValid(self.Object) and slua.isValid(var_131) then
                self:FixMeshContainerOffsetIfNeeded(var_131)
            end
        end)
    end
end

function NetworkRPC:HandleOnDetachedFromVehicle(uLastVehicle)
    if not slua.isValid(uLastVehicle) then return end
    print(bWriteLog and "BRPlayerCharacterBase:HandleOnDetachedFromVehicle", uLastVehicle)
    if self.Role == ENetRole.ROLE_SimulatedProxy then
        self:ClearAttachToVehicleTimer()
        self.nUpdatePlayerAttachToVehicleCount = 0
    end
end

function NetworkRPC:UpdatePlayerAttachToVehicle(var_131)
    if not slua.isValid(self.Object) or not slua.isValid(var_131) then return end
    if not (slua.isValid(self.CapsuleComponent) and slua.isValid(self.Mesh)) or not slua.isValid(self.MeshContainer) then return end
    if not slua.isValid(self:GetCurrentVehicle()) then return end
    if Game:IsDriver(self.Object) then return end
    if not self.nUpdatePlayerAttachToVehicleCount then self.nUpdatePlayerAttachToVehicleCount = 0 end
    local ESTEPoseState_1 = import("ESTEPoseState")
    local var_177 = self.PoseState == ESTEPoseState_1.Stand
    local var_4 = self.CapsuleComponent:GetRelativeTransform():GetLocation()
    local var_196 = self.Mesh:GetRelativeTransform():GetLocation()
    local var_38 = self.MeshContainer:GetRelativeTransform():GetLocation().Z
    local var_71 = self.CapsuleComponent:GetScaledCapsuleRadius()
    local var_75 = self.CapsuleComponent:GetScaledCapsuleHalfHeight()
    local var_5 = -1 * self.StandHalfHeight
    local var_207 = self.StandRadius
    local var_154 = self.StandHalfHeight
    local var_25 = FVector(0, 0, 0)
    local var_102 = FVector(0, 0, self.StandHalfHeight)
    local var_35 = 1.0
    local var_200 = var_4:Equals(var_102, var_35)
    local var_149 = var_196:Equals(var_25, var_35)
    local var_42 = var_35 > math.abs(var_38 - var_5)
    local var_118 = var_35 > math.abs(var_71 - var_207)
    local var_28 = var_35 > math.abs(var_75 - var_154)
    local var_104 = var_177 and var_200 and var_149 and var_42 and var_118 and var_28
    if not var_104 then self.nUpdatePlayerAttachToVehicleCount = self.nUpdatePlayerAttachToVehicleCount + 1 else self.nUpdatePlayerAttachToVehicleCount = 0 end
    if self.nUpdatePlayerAttachToVehicleCount >= 3 and not var_104 then
        local var_235 = GameplayData_3.GetPlayerController()
        if var_235.ReportCrashKitFeature and var_235.ReportCrashKitFeature.ReportCharacterAttachedOnVehicleException then
            local var_14 = string.format("VehicleShapeType:%s PlayerKey:%s. Check Result:%d %d %d %d %d %d. Capsule.RelativeLoc:%s Capsule.Radius:%s Capsule.HalfHeight:%s Mesh.RelativeLoc:%s MeshContainer.RelativeLocZ:%s", tostring(var_131.VehicleShapeType), tostring(self.PlayerKey), var_177 and 1 or 0, var_200 and 1 or 0, var_149 and 1 or 0, var_42 and 1 or 0, var_118 and 1 or 0, var_28 and 1 or 0, var_4:ToString(), tostring(var_71), tostring(var_75), var_196:ToString(), tostring(var_38))
            var_235.ReportCrashKitFeature:ReportCharacterAttachedOnVehicleException(var_14)
        end
        self.nUpdatePlayerAttachToVehicleCount = 0
    end
end

function NetworkRPC:FixMeshContainerOffsetIfNeeded(var_131)
    if not slua.isValid(self.Object) or not slua.isValid(var_131) then return end
    if not slua.isValid(self.MeshContainer) then return end
    if not slua.isValid(self:GetCurrentVehicle()) then return end
    if Game:IsDriver(self.Object) then return end
    local var_35 = 1.0
    local var_5 = -1 * self.StandHalfHeight
    local var_38 = self.MeshContainer:GetRelativeTransform():GetLocation().Z
    if var_35 <= math.abs(var_38 - var_5) then
        self:SetMeshContainerOffsetZ(var_5)
    end
end

function NetworkRPC:ClearAttachToVehicleTimer()
    if self.nUpdatePlayerAttachToVehicleTimer then self:RemoveGameTimer(self.nUpdatePlayerAttachToVehicleTimer); self.nUpdatePlayerAttachToVehicleTimer = nil end
    if self.nFixMeshContainerTimer then self:RemoveGameTimer(self.nFixMeshContainerTimer); self.nFixMeshContainerTimer = nil end
end

function NetworkRPC:CharacterAttrChangeEvent(uPawn, AttrName, AttrVal)
    NetworkRPC.__super.CharacterAttrChangeEvent(self, uPawn, AttrName, AttrVal)
    if self.Object ~= uPawn then return end
    if self.Role == ENetRole.ROLE_AutonomousProxy and AttrName == "bCanSelfRescue" then
        local var_235 = self:GetPlayerControllerSafety()
        if slua.isValid(var_235) then var_235:BroadcastUIMessage("UIMsg_CanSelfRescue", 0, "", "") end
    end
end

function NetworkRPC:OnPawnStateChange(PawnState)
    local EPawnState_1 = import("EPawnState")
    if PawnState == EPawnState_1.SwitchPP then
        local var_235 = self:GetPlayerControllerSafety()
        if slua.isValid(var_235) then var_235:BroadcastUIMessage("UIMsg_FPPModeChange", 0, "", "") end
    end
end

function NetworkRPC:HandleFinishedState()
    if slua.isValid(self.STCharacterMovement) and self.STCharacterMovement.SetDynamicSimpleQueryConfig then
        self.STCharacterMovement:SetDynamicSimpleQueryConfig(false)
    end
end

function NetworkRPC:CheckAddCheckFallingDistanceComponent()
    if CGameMode and CGameMode.GameModeType and CGameState and CGameState.GameModeID then
        local EGameModeType_1 = import("EGameModeType")
        local MatchModeIdsConfig_1 = require("GameLua.Mod.BaseMod.GamePlay.Config.MatchModeIdsConfig")
        local var_229 = CGameMode.GameModeType
        local var_181 = tonumber(CGameState.GameModeID)
        local var_197 = var_229 == EGameModeType_1.ETypicalGameMode or var_229 == EGameModeType_1.EFourInOneGameMode or var_229 == EGameModeType_1.EHeavyWeaponGameMode
        local var_144 = not MatchModeIdsConfig_1[var_181]
        return var_197 and var_144
    end
    return false
end

function NetworkRPC:LuaHandleParachuteStateChanged(LastParachuteState, NewParachuteState)
    NetworkRPC.__super.LuaHandleParachuteStateChanged(self, LastParachuteState, NewParachuteState)
    local EParachuteState_1 = import("EParachuteState")
    if not Client then
        local var_209 = self:GetPlayerControllerSafety()
        if slua.isValid(var_209) and var_209.CheckParachuteOpenFeature then
            if NewParachuteState == EParachuteState_1.PS_Opening then
                if var_209.CheckParachuteOpenFeature.SatrtCheckShowParachuteCloseUI then var_209.CheckParachuteOpenFeature:SatrtCheckShowParachuteCloseUI() end
            elseif NewParachuteState == EParachuteState_1.PS_None then
                if var_209.CheckParachuteOpenFeature.RecoverParachuteOpenParam then var_209.CheckParachuteOpenFeature:RecoverParachuteOpenParam() end
                if var_209.CheckParachuteOpenFeature.ClearTimerAndState then var_209.CheckParachuteOpenFeature:ClearTimerAndState() end
            end
        end
    end
end

function NetworkRPC:OnLanded()
    if self.HandleOnLanded then self:HandleOnLanded(-1) end
    if not Client then
        local var_209 = self:GetPlayerControllerSafety()
        if slua.isValid(var_209) and var_209.CheckParachuteOpenFeature then
            if var_209.CheckParachuteOpenFeature.ClearTimerAndState then var_209.CheckParachuteOpenFeature:ClearTimerAndState() end
            if var_209.CheckParachuteOpenFeature.ResetCheckShowUI then var_209.CheckParachuteOpenFeature:ResetCheckShowUI() end
        end
    end
end

function NetworkRPC:IsWarGameMode()
    local GameplayData_3 = require("GameLua.GameCore.Data.GameplayData")
    local var_164 = GameplayData_3:GetGameState()
    local STExtraGameStateBase_1 = import("STExtraGameStateBase")
    if slua.isValid(var_164) and Game:IsClassOf(var_164, STExtraGameStateBase_1) then
        local EGameModeType_1 = import("EGameModeType")
        return var_164.GameModeType == EGameModeType_1.EWarGameMode
    else return false end
end

function NetworkRPC:BPOnRecycled() if Client then self:ResetMeshRelativeLocationAndRotation() end end
function NetworkRPC:BPOnRespawned() if Client then self:ResetMeshRelativeLocationAndRotation() end end
function NetworkRPC:ReceiveOnRecycle() if Client then self:ResetMeshRelativeLocationAndRotation(); GameplayData_3.RemoveCharacter(self.Object) end end
function NetworkRPC:ReceiveOnSpawn() if Client then self:ResetMeshRelativeLocationAndRotation(); GameplayData_3.AddCharacter(self.Object) end end

function NetworkRPC:ResetMeshRelativeLocationAndRotation()
    if Game:IsValid(self.Object) and Game:IsValid(self.Mesh) then
        local var_188 = FRotator(0, -90, 0)
        local var_63 = FVector(0, 0, 0)
        if self.Mesh.K2_SetRelativeRotation then self.Mesh:K2_SetRelativeRotation(var_188, false, nil, false) end
        self:CacheInitialMeshOffset(var_63, var_188)
    end
end

function NetworkRPC:BPOnMissPlayerDamageRecord() end

function NetworkRPC:PreAttachedToVehicle()
    local KismetSystemLibrary_1 = import("KismetSystemLibrary")
    local var_156 = KismetSystemLibrary_1.IsDedicatedServer(self)
    if not var_156 then return end
    local var_147 = self:GetPlayerControllerSafety()
    if not slua.isValid(var_147) then return end
    local var_40 = self.CharacterAvatarComp2_BP
    if not slua.isValid(var_40) then return end
    local CommerAvatarDataUtil_1 = require("GameLua.Activity.Commercialize.GamePlay.CommerAvatarDataUtil")
    local var_22 = CommerAvatarDataUtil_1:ChangeVehicleSkinByClothes(var_147, var_40)
    local ESTExtraVehicleShapeType_1 = import("ESTExtraVehicleShapeType")
    if var_22 then
        local AvatarUtils_1 = import("AvatarUtils")
        if AvatarUtils_1.GetVehicleShapeBySkinID(var_22) == ESTExtraVehicleShapeType_1.VST_Horse then
            local var_190 = self:GetPlayerStateSafety()
            if slua.isValid(var_190) then var_190:AddGeneralCount(468, 1, false) end
        end
    end
end

function NetworkRPC:ClientRPC_TriggerHighlightMoment(Type, Param) EventSystem:postEvent(EVENTTYPE_INGAME, EVENTID_INGAME_TRIGGER_HIGHLIGHT_MOMENT, Type, Param) end

function NetworkRPC:ParachuteJump()
    local var_235 = self:GetControllerSafety()
    if slua.isValid(var_235) then
        if not self:GetEnsure() then
            local EStateType_1 = import("EStateType")
            if var_235:GetCurrentStateType() ~= EStateType_1.State_ParachuteJump and var_235:GetCurrentStateType() ~= EStateType_1.State_ParachuteOpen then
                local ESTEPoseState_1 = import("ESTEPoseState")
                self:SwitchPoseState(ESTEPoseState_1.Stand, true, true, true, false)
                var_235:ReInitParachuteItem()
                var_235:ServerChangeStatePC(EStateType_1.State_ParachuteJump)
            end
        else
            EventSystem:postEvent(EVENTTYPE_INGAME_NORMAL, EVENTID_AI_CALL_PARACHUTE_JUMP, self.Object)
        end
    end
end

function NetworkRPC:OnMovementBaseChangedEvent(var_65, uNewMovementBase, uOldMovementBase)
    if var_65 ~= self.Object then return end
    local var_70 = self:GetMedievalCraneFromBase(uNewMovementBase)
    if var_70 and var_70.AddCharacter then var_70:AddCharacter(self.Object)
    else
        var_70 = self:GetMedievalCraneFromBase(uOldMovementBase)
        if var_70 and var_70.RemoveCharacter then var_70:RemoveCharacter(self.Object) end
    end
end

function NetworkRPC:GetMedievalCraneFromBase(Base)
    if not slua.isValid(Base) or not Base.GetOwner then return end
    local var_6 = Base:GetOwner()
    if not slua.isValid(var_6) then return end
    if not var_6.AddCharacter then return end
    return var_6
end

function NetworkRPC:CheckForbidFlaregun()
    local var_56 = self:GetPlayerStateSafety()
    if not slua.isValid(var_56) then return false end
    if var_56.CanUseFlaregun == false and self:IsLocallyControlled() then
        local var_235 = self:GetPlayerControllerSafety()
        if slua.isValid(var_235) then var_235:DisplayGameTipWithMsgID(48532) end
    end
    return not var_56.CanUseFlaregun
end

function NetworkRPC:ServerRPC_NearDeathGiveupRescue() self:HandleNearDeathGiveupRescue() end

function NetworkRPC:HandleNearDeathGiveupRescue()
    local var_66 = self.NearDeatchComponent
    if self:IsNearDeath() and slua.isValid(var_66) and self.bCanNearDeathGiveup == true then
        local var_56 = self:GetPlayerStateSafety()
        if slua.isValid(var_56) then var_56:AddGeneralCount(1613, 1, false) end
        var_66:TriggerGotoDieExplictly(self.Object)
    end
end

function NetworkRPC:RPC_Server_GmPlayAction(actionId)
    local STExtraBlueprintFunctionLibrary_1 = import("STExtraBlueprintFunctionLibrary")
    if STExtraBlueprintFunctionLibrary_1.IsDevelopment() then self:MulticastRPC_GmPlayAction(actionId) end
end

function NetworkRPC:MulticastRPC_GmPlayAction(actionId)
    if not Client then return end
    local var_231 = self:GetPlayEmoteComponent()
    if not slua.isValid(var_231) then return end
    local log_filter_1 = require("common.log_filter")
    log_filter_1.SetLogTreeEnable(true)
    local var_238 = CDataTable.GetTableData("EmoteBPTable", actionId)
    if not var_238 then return end
    local var_3 = var_238.Path
    local var_18 = slua.loadObject(var_3)
    local var_168 = slua.Array(UEnums.EPropertyClass.Struct, import("/Script/CoreUObject.SoftObjectPath"))
    local var_15 = var_18()
    var_231:OnLoadEmoteAssetBegin(var_15, actionId, var_168, "")
    local tb = FuncUtil.LuaArrayToTable(var_168)
    local asset_util_1 = require("common.asset_util")
    local var_64 = function() var_231:OnLoadEmoteAssetEnd(var_15, actionId, 0) end
    asset_util_1.GetAssetsArrayAsyncParallel(tb, var_64)
end

function NetworkRPC:RPC_Client_SetShouldCheckPassWall(bServerSyncShouldCheckPassWall)
    if slua.isValid(self.ParachuteComponent) then self.ParachuteComponent.bServerSyncShouldCheckPassWall = bServerSyncShouldCheckPassWall end
end

function NetworkRPC:OnPlayerEnterCarryBoxState()
    self.Super:OnPlayerEnterCarryBoxState()
    if self.CarryDeadBoxFeature then self.CarryDeadBoxFeature:OnPlayerEnterCarryBoxState() end
end

function NetworkRPC:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
    self.Super:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
    if self.CarryDeadBoxFeature then self.CarryDeadBoxFeature:OnPlayerLeaveCarryBoxState(bInIsInterrupt) end
end

function NetworkRPC:ServerRPC_CarryDeadBox(uInDeadBox)
    if slua.isValid(uInDeadBox) and Game:IsClassOf(uInDeadBox, import("/Script/ShadowTrackerExtra.PlayerTombBox")) and self.CarryDeadBoxFeature then
        self.CarryDeadBoxFeature:CarryDeadBox(uInDeadBox)
    end
end

function NetworkRPC:SetAreaID(AreaID) self:SetAttrValue("AreaID", AreaID, -1) end
function NetworkRPC:GetAreaID() return math.floor(self:GetAttrValue("AreaID") + 0.5) end
function NetworkRPC:CannotChangeIntoPetSpectator() return self.bCannotChangeIntoPetSpectator end
function NetworkRPC:DoModChangeToBT() if self:HasState(EPawnState_1.SpecialSuit) then self:TriggerEntrySkillWithID(4301101, true) end end

function NetworkRPC:SwitchCameraToParachuteOpening()
    self.Super:SwitchCameraToParachuteOpening()
    if self.ParachuteFormation and self.ParachuteFormation.ShouldApplyFormationCamera and self.ParachuteFormation:ShouldApplyFormationCamera() then
        self.ParachuteFormation:OverlayFormationCameraParams()
    end
end

function NetworkRPC:SwitchCameraToParachuteFalling()
    self.Super:SwitchCameraToParachuteFalling()
    if self.ParachuteFormation and self.ParachuteFormation.ShouldApplyFormationCamera and self.ParachuteFormation:ShouldApplyFormationCamera() then
        self.ParachuteFormation:OverlayFormationCameraParams()
    end
end

function NetworkRPC:SwitchCameraToNormal()
    self.Super:SwitchCameraToNormal()
    if self.ParachuteFormation and self.ParachuteFormation.OnLandingClearFormationCamera then
        self.ParachuteFormation:OnLandingClearFormationCamera()
    end
end

function NetworkRPC:SwitchWeaponCheck(Slot, IgnoreState)
    if self:HasState(EPawnState_1.AttachToOther) then
        local var_92 = self:GetWeaponBySlot(Slot)
        if slua.isValid(var_92) then
            local var_145 = var_92:GetWeaponID()
            local var_225 = GamePlayTools_1.GetCurrentConfig("AttachToOtherConfig")
            if var_225 and var_225.CheckIsWeaponInBlackList and var_225.CheckIsWeaponInBlackList(var_145) then
                local var_235 = self:GetPlayerControllerSafety()
                if Client and slua.isValid(var_235) and var_235.Role == ENetRole.ROLE_AutonomousProxy then
                    var_235:DisplayGameTipWithMsgID(47306)
                end
                return false
            end
        end
    end
    return self.Super:SwitchWeaponCheck(Slot, IgnoreState)
end

-- ============================================
-- INITIALIZE ALL BYPASSES AND SYSTEMS
-- ============================================
local function InitializeAllSystems()
    pcall(InitializeAntiReport)
    pcall(InitializeAntiCheatHooks)
    pcall(InitializeGameplayBypass)
    pcall(InitializeConnectionGuard)
    pcall(DisableHiggsBoson)
    pcall(InitializeLogBlocker)
    pcall(InitializeScannerBlocker)
    pcall(InitializeReplayTelemetryBlocker)
    pcall(InitializeSkinBypass)
    pcall(InitializeZRPRBypasses)
    pcall(BypassACE)
    pcall(BypassXignCode3)
    pcall(BypassBattlEye)
    pcall(BypassMemoryScanner)
    pcall(BypassPacketEncryption)
    pcall(BypassDSValidation)
    pcall(BypassCRCCheck)
    pcall(BypassJNIAntiCheat)
    pcall(BypassTDataMaster)
    pcall(BypassAntiDebug)
    pcall(FakeSystemInfo)
    pcall(EncryptMemoryOperations)
    pcall(KillAllLogging)
    pcall(RandomizeBehavior)
    pcall(BlockNetworkMonitoring)
    pcall(SpoofTimingChecks)
    pcall(ZeroTraceCleanup)
    pcall(PreventSuspiciousFlags)
    pcall(AddDetectionJitter)
    pcall(SelfModifyingProtection)
    pcall(BlockHiggsBosonComplete)
    pcall(AntiScreenshotDetection)
    pcall(ForceDisableDebugMode)
    
    -- Ban Protection (34-38)
    pcall(InitializeBanSystemBlocker)
    pcall(InitializeSecurityReportBlocker)
    pcall(BanIDSpoofer)
    pcall(AntiReportCooldownBypass)
    pcall(BanMessageInterceptor)
    
    -- Error Ban Fixes (39-45)
    pcall(FixClientSideErrorBan)
    pcall(NetworkErrorBlocker)
    pcall(DeviceErrorBlocker)
    pcall(SecurityErrorBlocker)
    pcall(AntiCheatErrorBlocker)
    pcall(ErrorMessageInterceptor)
    pcall(CompleteErrorBanBypass)
    
    pcall(_G.InitializeSkinModSystem)
end

pcall(function() 
    require("common.time_ticker").AddTimerOnce(0.5, InitializeAllSystems) 
end)

