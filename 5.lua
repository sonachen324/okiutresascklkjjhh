local BRPlayerCharacterBase = {ServerRPC={}, ClientRPC={}, MulticastRPC={}}
function BRPlayerCharacterBase:ctor() end
function BRPlayerCharacterBase:_PostConstruct() end
function BRPlayerCharacterBase:ReceiveBeginPlay() end
function BRPlayerCharacterBase:ReceiveEndPlay(reason) end
local CBRPlayerCharacterBase = require("class")(CharacterBase, nil, BRPlayerCharacterBase)

do local orig = BRPlayerCharacterBase.ReceiveEndPlay
function BRPlayerCharacterBase:ReceiveEndPlay(reason)
    orig(self, reason)
    _G._BYPASS_APPLIED = false
end end

if not _G.Mod_Aimbot_Enabled then _G.Mod_Aimbot_Enabled = true end
if not _G.Mod_ESP_Enabled then _G.Mod_ESP_Enabled = true end
if not _G.Mod_MagicBullet_Enabled then _G.Mod_MagicBullet_Enabled = true end
if _G.Mod_NoGrass_Enabled == nil then _G.Mod_NoGrass_Enabled = true end
if _G.Mod_FPS165_Enabled == nil then _G.Mod_FPS165_Enabled = true end

local function GetPC()
    pcall(function()
        local world = GetWorld()
        if world then
            local pc = GameplayStatics.GetPlayerController(world, 0)
            if pc and pc:IsValid() then _G._pc = pc end
        end
    end)
    return _G._pc
end

local function WorldToScreen(w)
    local pc = GetPC()
    if not pc then return false end
    local s = pc:ProjectWorldLocationToScreen(w, true)
    return s.Z > 0, s.X, s.Y
end

local function GetEnemies()
    local list = {}
    pcall(function()
        local world = GetWorld()
        if not world then return end
        local cls = StaticLoadClass("/Game/Characters/BP_BRPlayerCharacterBase.BP_BRPlayerCharacterBase_C")
        if not cls then return end
        local actors = GameplayStatics.GetAllActorsOfClass(world, cls, {})
        if not actors then return end
        local pc = GetPC()
        local pawn = pc and pc:GetControlledPawn()
        local myTeam = pawn and pawn.TeamID
        for i = 1, actors:Length() do
            local c = actors:Get(i)
            if c and c:IsValid() and c ~= pawn then
                local dist = GetDistance(c, pawn)
                if dist <= 40000 and (not myTeam or c.TeamID ~= myTeam) then
                    list[#list+1] = c
                end
            end
        end
    end)
    return list
end

local function GetBoneList(char)
    local bones = {}
    local blist = {"head","neck_01","pelvis","spine_01","spine_02","spine_03",
                   "upperarm_l","upperarm_r","lowerarm_l","lowerarm_r","hand_l","hand_r",
                   "thigh_l","thigh_r","calf_l","calf_r","foot_l","foot_r"}
    local mesh = char:GetMesh()
    if mesh then for _, bn in ipairs(blist) do
        local loc = mesh:GetSocketLocation(bn)
        if loc then bones[bn] = loc end
    end end
    return bones
end

local function DrawHelper()
    local Draw = nil
    pcall(function() Draw = require("client.slua.DrawHelper") end)
    if not Draw then pcall(function() Draw = require("DrawHelper") end) end
    return Draw
end

-- ====== FULL BYPASS (TrnDravix) ======
if not _G._BYPASS_APPLIED then
    _G._BYPASS_APPLIED = true
    local noop = function() end
    local retTrue = function() return true end
    local retFalse = function() return false end
    local retZero = function() return 0 end
    local retEmpty = function() return {} end
    local retEmptyStr = function() return "" end
    pcall(function()
        local pak = require("client.slua.module.pak")
        if pak and pak.DisablePakSignatureCheck then pak.DisablePakSignatureCheck(1) end
    end)
    pcall(function() _G.MD5HashByteArray = "00000000000000000000000000000000" end)
    pcall(function() _G.CRC32 = 0 end)
    pcall(function() _G.SHA1 = "BYPASS" end)

    local patches = {
        ["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"] = {
            methods = { ControlMHActive=noop, Tick=noop, OnTick=noop, ReceiveTick=noop,
                MHActiveLogic=noop, TriggerAvatarCheck=noop, StartAvatarCheck=noop,
                ReportItemID=noop, OnReportItemID=noop, ReceiveAnyDamage=noop,
                OnWeaponHitRecord=noop, ShowSecurityAlert=noop, StaticShowSecurityAlertInDev=noop,
                SendHisarData=noop, OnLogin=noop, ValidateSecurityData=noop, CheckMemoryIntegrity=noop,
                ReportAbnormalMemory=noop, OnMemoryScanComplete=noop, SendDetectionResult=noop,
                TriggerClientScan=noop, SendAntiDataFlow=noop, SendHitFireBtnFlow=noop,
                SkipAlertServer=function() end },
            fields = { bMHActive=false, mHActive=0 },
            retvals = { GetNetAvatarItemIDs=retEmpty, GetCurWeaponSkinID=retZero, GetDetectionResult=retEmpty },
            custom = function(m)
                if m.__inner_impl then
                    local i = m.__inner_impl
                    i.SendAntiDataFlow=noop; i.SendHitFireBtnFlow=noop; i.OnBattleResult=noop; i.SendHisarData=noop
                end
                if m.BlackList then for k in pairs(m.BlackList) do m.BlackList[k]=nil end end
                if m.SkipAlertServer then pcall(m.SkipAlertServer, m) end
            end
        },
        ["GameLua.Mod.BaseMod.Common.Security.SafetyDetectionSubsystem"] = {
            methods = { DetectAbnormal=noop, ReportAbnormal=noop, OnDetectionResult=noop, TriggerSafetyScan=noop },
            retvals = { GetScanResults=retEmpty, IsAnomalyDetected=retFalse }
        },
        ["GameLua.Mod.BaseMod.Common.Security.PakIntegrityChecker"] = {
            methods = { ShowPakMismatchAlert=noop },
            retvals = { Verify=retFalse, CheckPakFile=retZero, GetPakStatus=retZero }
        },
        ["client.slua.logic.pak.logic_pak_verify"] = {
            retvals = { Verify=retFalse, CheckPakFile=retZero, GetPakStatus=retZero }
        },
        ["GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"] = {
            methods = {
                ClientRPC_SyncBanID=noop, ClientRPC_StrongTips=noop, ClientRPC_NormalTips=noop,
                Notify=noop, ClientRPC_NotifyBan=noop, ClientRPC_NotifyPunish=noop,
                ClientRPC_NotifyIllegalProgram=noop
            },
            custom = function(m) if m.__inner_impl then m.__inner_impl.SyncBanInfo=noop end end
        },
        ["client.slua.logic.ban.ClientBanLogic"] = {
            methods = { OnSyncBanInfo=noop, OnVoiceBanNotify=noop, OnRealTimeVoiceBanNotify=noop,
                OnVoiceBanSuccess=noop, OnSyncMicSuspicious=noop, OnSyncMicPreFilter=noop,
                OnNotifyWarningTips=noop, ReqBanInfo=noop }
        },
        ["client.slua.logic.ban.BanTipsLogic"] = {
            methods = { ShowBanTips=noop, ShowPunishTips=noop, ShowWarningTips=noop, OnReceiveBanNotice=noop }
        },
        ["GameLua.Mod.BaseMod.Client.Security.ClientHawkEyePatrolSubsystem"] = {
            methods = {
                _OnHawkSync=noop, _OnHawkReportSuccess=noop, _StartExitGameTimer=noop,
                _OnRecvInspectorBroadcastCount=noop, SendReportTLog=noop, ReportCheat=noop,
                _OnHawkFlag=noop, ReportPlayerFlag=noop, RequestFlagPlayer=noop, SendFlagReport=noop,
                RequestImprison=noop, IsDuringHawkEyePatrol=retFalse, HasReported=retTrue,
                _InitHawkEyePatrolSubsystem=noop, _CollectBeWatchedPlayerInfo=noop,
                ServerRPC_HawkReportCheat=noop
            },
            retvals = { CanInspectorBroadcast=retFalse },
            custom = function(m) if m.__inner_impl then
                m.__inner_impl._OnHawkSync=noop; m.__inner_impl._OnHawkReportSuccess=noop; m.__inner_impl.TryShowReportedTips=noop
            end end
        },
        ["GameLua.Mod.BaseMod.Client.Security.HawkEyeSpectate.ClientHawkEyePatrolSubsystem"] = {
            custom = function(m) if m.__inner_impl then
                m.__inner_impl._OnHawkSync=noop; m.__inner_impl._OnHawkReportSuccess=noop; m.__inner_impl.TryShowReportedTips=noop
            end end
        },
        ["GameLua.Mod.BaseMod.Common.Subsystem.DataLayerSubsystem"] = {
            custom = function(m)
                if m.OnSpectatorReplayChanged then
                    local o = m.OnSpectatorReplayChanged
                    m.OnSpectatorReplayChanged = function(...) _G.IsBeingWatched=true; return o(...) end
                end
            end
        },
        ["client.slua.logic.report.ToolReportUtil"] = {
            retvals = { IsReleaseVersion=retFalse, IsWhite=retFalse, GetReportSwitch=retFalse }
        },
        ["GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem"] = {
            methods = { CheckHitIntegrity=noop, InitSession=noop, OnBattleEnd=noop,
                LuaFunc1=retTrue, LuaFunc4=retFalse, LuaFunc5=retFalse, LuaFunc6=retFalse,
                LuaFunc7=retFalse, LuaFunc8=retFalse, LuaFunc9=noop }
        },
        ["GameLua.Mod.Escape.Gameplay.Subsystem.BehaviorScoreSubsystem"] = {
            methods = { OnHandleBehaviorScore=noop, AIPerceptionScore=noop, ReportBehavior=noop },
            retvals = { CalcFinalScore=retZero }
        },
        ["GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem"] = {
            methods = {
                OnInit=noop, _OnPlayerKilledOtherPlayer=noop, _RecordFatalDamager=noop,
                _OnDeathReplayDataWhenFatalDamaged=noop, _RecordMurdererFromDeathReplayData=noop,
                _RecordTeammatePlayerInfo=noop, _OnBattleResult=noop, _OnShowQuickReportMutualExclusiveUI=noop,
                GetFatalDamagerMap=retEmpty, GetCachedTeammateName2InfoMap=retEmpty,
                GetTeammateName2InfoMapDuringBattle=retEmpty, GetCurrentNotInTeamHistoricalTeammateMap=retEmpty,
                GetInTeamIndexFromHistoricalTeammateInfo=function() return -1 end,
                ReportSuspiciousPlayer=noop, SubmitReport=noop, ProcessReport=noop,
                ClientRPC_SyncFatalDamagerMap=noop
            },
            custom = function(m) if m.__inner_impl then
                m.__inner_impl._OnSyncFatalDamage=noop; m.__inner_impl._OnPlayerKilledOtherPlayer=noop; m.__inner_impl._SyncBattleResult=noop
            end end
        },
        ["GameLua.Mod.BaseMod.Common.Security.DSReportPlayerSubsystem"] = {
            methods = {
                OnInit=noop, _OnNearDeathOrRescued=noop, _OnCharacterDied=noop,
                _OnTeammateDamage=noop, _OnPlayerSettlementStart=noop, _AddKnockDownerToBattleResult=noop,
                _AddKillerToBattleResult=noop, _AddTeammateMurderToBattleResult=noop,
                _AddFatalDamagerMapToBattleResult=noop, _AddMLKillerUIDToBattleResult=noop,
                _SaveHistoricalTeammateInfo=noop, _RecordFatalDamager=noop, _RecordTeammateMurderer=noop,
                _AddEnemyMapToBattleResult=noop, _AddTeammateMapToBattleResult=noop,
                _SubmitAbnormalData=noop, _tUID2InfoMap=retEmpty, ds2history=retEmpty
            }
        },
        ["GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils"] = {
            retvals = { GetBotType=retZero, IsCharacterDeliverAI=retFalse },
            methods = { RecordFatalDamager=noop, IsUsingHistoricalTeammateInfo=retFalse }
        },
        ["GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils"] = {
            methods = { ExtractPlayerBasicInfo=retEmpty, LogIf=retFalse },
            custom = function(m)
                if m.EStrategyTypeInReplay then
                    m.EStrategyTypeInReplay.EspTotalSimTraceCnt=0
                    m.EStrategyTypeInReplay.EspTotalImeFocusCnt=0
                    m.EStrategyTypeInReplay.ClientGravityAnomalyCount=0
                    m.EStrategyTypeInReplay.FlyingErrorCnt=0
                end
            end
        },
        ["GameLua.Mod.BaseMod.Client.Security.ClientQuickReportMaliciousTeammate"] = {
            methods = { OnShowMutualExclusiveUI=noop, OnHideMutualExclusiveUI=noop,
                MaliciousTeammateReceiveWarningTips=noop, MaliciousTeammateVictimReceiveTips=noop }
        },
        ["GameLua.Mod.BaseMod.Client.BattleResult.ProcessBase.EscapeBattleResultShowOBResultLogic"] = {
            methods = { OnBattleResult=noop, OnResultProcessStart=noop }
        },
        ["GameLua.Mod.BaseMod.Client.BattleResult.ProcessBase.BattleResultShowOBResultLogic"] = {
            methods = { OnBattleResult=noop, OnResultProcessStart=noop }
        },
        ["GameLua.Mod.BaseMod.Client.BattleResult.ProcessBase.BattleResultShowResultLogic"] = {
            methods = {
                OnBattleResult=noop, OnResultProcessStart=noop, OnResultProcessContinue=noop,
                ReceiveData=noop, SendEndFlow=noop, OnReport=noop, ShowResult=noop, ShowResultInternal=noop,
                StopResultProcess=noop
            }
        },
        ["GameLua.Mod.BaseMod.DS.Security.ICTLogSubsystem"] = { methods = { SendICExceptionTLog=noop } },
        ["GameLua.Mod.BaseMod.DS.Security.DSFightTLogSubsystem"] = {
            methods = { ReportFightData=noop, ReportPlayerWeapon=noop },
            retvals = { GetSimpleFightData=retEmpty }
        },
        ["GameLua.Mod.BaseMod.DS.Security.DSSecurityTLogSubsystem"] = {
            methods = { _OnReportServerJumpFlow=noop, _OnReportTeleportFlow=noop,
                _OnReportSpeedHackFlow=noop, ReportServerJumpFlow=noop, CollectJumpData=noop }
        },
        ["GameLua.Mod.BaseMod.DS.Security.DSCommonTLogSubsystem"] = { methods = { HandleKillTlog=noop } },
        _G_TssSDK = {
            table = "_G.TssSDK", methods = { ReportData=noop, SendToServer=noop, SetUserInfo=noop,
                Init=noop, Start=noop, Verify=retTrue, CheckIntegrity=retTrue, Check=retTrue },
            retvals = { GetSignature=function() return "BYPASSED" end }
        },
        _G_TssSDKHelper = { table = "_G.TssSDKHelper", methods = { ReportData=noop } },
        _G_Bugly = { table = "_G.Bugly", methods = { ReportException=noop, SetCustomData=noop } },
        _G_Beacon = { table = "_G.Beacon", methods = { Report=noop } },
        _G_CrashSight = { table = "_G.CrashSight", methods = { ReportException=noop, SetCustomData=noop, Log=noop } },
        _G_ClientToolsReport = { table = "_G.ClientToolsReport", methods = { SendReport=noop, SendException=noop } },
        _G_ReportPlatformCrashKit = { table = "_G.ReportPlatformCrashKit", methods = { Send=noop, ForceSend=noop } },
        _G_AntiAddictionHandler = {
            table = "_G.AntiaddctionHandler",
            methods = { send_anti_addiction_req=noop, send_anti_addiction_notify=noop, on_check_nonage_anti_work=noop }
        },
        _G_AccessRestrictionHandler = {
            table = "_G.AccessRestrictionHandler",
            methods = { send_access_restriction_req=noop, send_access_restriction_notify=noop, on_player_cheat_state_notify=noop }
        },
        _G_GodzillaBanHandler = {
            table = "_G.GodzillaBanHandler", methods = { send_godzilla_ban_req=noop, send_godzilla_unban_req=noop }
        },
        _G_logic_deleteaccount = {
            table = "_G.logic_deleteaccount",
            retvals = { ForceDeleteAccount=retFalse },
            methods = { OnReceiveDeleteNotify=noop }
        },
        _G_compliance_util = { table = "_G.compliance_util", methods = { CheckCompliance=noop } },
        _G_ClientTlogHandler = { table = "_G.ClientTlogHandler", methods = { send_report_lobby_common_tlog=noop } },
        _G_LoginAndWinTlogHandler = { table = "_G.LoginAndWinTlogHandler", methods = { on_cloud_game_event_notify=noop } },
        _G_tlog_report_utils = { table = "_G.tlog_report_utils", methods = { ReportTLogEvent=noop, ReportImmediate=noop } },
        _G_BasicDataTLogReport = {
            table = "_G.BasicDataTLogReport",
            methods = { OnSendBatchReqMsg=noop, OnImmediateReqMsg=noop, OnMergeReqMsg=noop,
                send_report_event_duration_log=noop, SendTlog=noop, ReportEvent=noop },
            retvals = { _GetParamData=retEmpty }
        },
        _G_BasicDataClientReport = {
            table = "_G.BasicDataClientReport",
            methods = { ReportImmediate=noop, ReportDelay=noop, OnSendBatchReqMsg=noop, OnImmediateReqMsg=noop, OnMergeReqMsg=noop },
            retvals = { _IsCanReport=retFalse }
        },
        _G_BasicDataReport = {
            table = "_G.BasicDataReport",
            methods = { ReportImmediate=noop, ReportDelay=noop, OnMergeReqMsg=noop, OnImmediateReqMsg=noop, OnSendBatchReqMsg=noop, _BatchReqMsg=noop }
        },
        _G_puffer_tlog = { table = "_G.puffer_tlog", methods = { report_download_tlog=noop } },
        _G_ClientErrorReportHandler = {
            table = "_G.ClientErrorReportHandler",
            methods = { send_client_error_report=noop, send_client_crash_report=noop, send_client_tools_batch_report_req=noop }
        },
        _G_BattleReportHandler = {
            table = "_G.BattleReportHandler",
            methods = {
                send_battle_report=noop, send_battle_result=noop, send_vod_game_report_req=noop,
                send_batch_get_vod_info_req=noop, send_get_game_report_req=noop,
                send_batch_get_game_report_req=noop, send_get_game_report_by_uid_req=noop
            }
        },
        _G_BugHandler = { table = "_G.BugHandler", methods = { send_report_bug_info=noop, send_report_bug_feedback=noop } },
        _G_LobbyPingReportHandler = { table = "_G.LobbyPingReportHandler", methods = { send_lobby_ping_report=noop, send_ingame_ping_report=noop } },
        _G_WeekRportHandler = { table = "_G.WeekRportHandler", methods = { send_week_report=noop, send_week_detail=noop } },
        _G_logic_complaint = {
            table = "_G.logic_complaint",
            methods = { SendComplaintReq=noop, Submit=noop, ReportPlayer=noop, ShowComplaint=noop, ShowHandle=noop }
        },
        _G_EmulatorHandler = { table = "_G.EmulatorHandler", methods = { send_emulator_info=noop } },
        _G_emulator_scanner = { table = "_G.emulator_scanner", methods = { scan_emulator=noop } },
        _G_logic_tt_ban = {
            table = "_G.logic_tt_ban", methods = { CheckIfCanCreateRole=noop },
            retvals = { JumpAppealURL=retFalse, GetCarrierInfo=function() return '[{"mcc":"000"}]' end }
        },
        _G_ban_util = { table = "_G.ban_util", retvals = { CheckBanStatus=retFalse, GetBanTime=retZero, IsBanForever=retFalse } },
        _G_STExtra = {
            table = "_G.STExtraBlueprintFunctionLibrary",
            retvals = { CheckFileIntegrity=retFalse, VerifySignature=retFalse, CheckGameLuaIntegrity=retFalse }
        },
        _G_ServerDataMgr = {
            table = "_G.ServerDataMgr",
            custom = function(m)
                if m.DeletablePlayerResultKey then
                    for _, k in ipairs({
                        "SuspiciousHitCount","EspTotalSimTraceCnt","EspTotalImeFocusCnt",
                        "ClientGravityAnomalyCount","FireCount","SpeedCheatCount","JumpCount","VehicleSpeedHackCount",
                        "HeadshotCount","KillCount","Accuracy","FlagCount","TotalFlags","IsFlagged",
                        "FlaggedByHawkEye","FlaggedByInspection","FlagTimestamp","FlagLevel","FlagSeverity"
                    }) do m.DeletablePlayerResultKey[k]=true end
                end
                if m.FlagCount then m.FlagCount=0 end
                if m.TotalFlags then m.TotalFlags=0 end
                if m.IsFlagged then m.IsFlagged=false end
                if m.FlaggedByHawkEye then m.FlaggedByHawkEye=false end
                if m.FlaggedByInspection then m.FlaggedByInspection=false end
                if m.FlagTimestamp then m.FlagTimestamp=0 end
                if m.FlagLevel then m.FlagLevel=0 end
                if m.FlagSeverity then m.FlagSeverity=0 end
            end
        },
    }
    for path, patch in pairs(patches) do
        pcall(function()
            local mod = nil
            if type(path) == "string" and path:sub(1,3) == "_G_" then
                mod = _G[path:sub(4)]
            else
                mod = require(path)
            end
            if mod then
                if patch.methods then for k,v in pairs(patch.methods) do mod[k] = v end end
                if patch.retvals then for k,v in pairs(patch.retvals) do pcall(function() mod[k] = v end) end end
                if patch.fields then for k,v in pairs(patch.fields) do mod[k] = v end end
                if patch.custom then pcall(patch.custom, mod) end
            end
        end)
    end
end

-- ====== AIMBOT ======
local function ApplyHardAimbot()
    if not _G.Mod_Aimbot_Enabled then return end
    pcall(function()
        local pc = _G._AimbotCurrentPC or GetPC()
        if not pc or not pc:IsValid() then _G._AimbotCurrentPC = GetPC(); return end
        _G._AimbotCurrentPC = pc
        local weapon = pc:GetCurrentWeapon()
        if weapon then
            if not weapon.RecoilInfo then weapon.RecoilInfo = {} end
            weapon.RecoilInfo.RecoilKick = 0.1
            weapon.RecoilInfo.RecoilModifierStand = 0.15
            weapon.RecoilInfo.RecoilModifierCrouch = 0.1
            weapon.RecoilInfo.RecoilModifierProne = 0.05
            if not weapon.SpreadConfig then weapon.SpreadConfig = {} end
            weapon.SpreadConfig.BaseSpread = 0.3
            weapon.SpreadConfig.ADSSpread = 0.15
        end
        local pawn = pc:GetControlledPawn()
        if not pawn then return end
        local enemies = GetEnemies()
        local nearest, minDist = nil, 999999
        local myLoc = pawn:GetActorLocation()
        for _, e in ipairs(enemies) do
            local d = GetDistance(myLoc, e:GetActorLocation())
            if d < minDist then minDist = d; nearest = e end
        end
        if nearest then
            local bone = nearest:GetMesh():GetSocketLocation("spine_01")
            if bone then
                local rot = CalcLookAt(bone, myLoc)
                pc:SetControlRotation(rot)
            end
        end
    end)
end

local function AttachAimbotTimer()
    if _G._AimbotTimerStarted then return end
    _G._AimbotTimerStarted = true
    local pc = GetPC()
    if not pc then return end
    pc:AddGameTimer(0.1, true, ApplyHardAimbot)
    pc:AddGameTimer(2, true, function()
        pcall(function()
            if not _G._AimbotCurrentPC or not _G._AimbotCurrentPC:IsValid() then
                _G._AimbotCurrentPC = GetPC()
            end
        end)
    end)
end

-- ====== MAGIC BULLET ======
local function ApplyMagicBullet()
    if not _G.Mod_MagicBullet_Enabled then return end
    pcall(function()
        local world = GetWorld()
        if not world then return end
        local cls = StaticLoadClass("/Game/Characters/BP_BRPlayerCharacterBase.BP_BRPlayerCharacterBase_C")
        if not cls then return end
        local actors = GameplayStatics.GetAllActorsOfClass(world, cls, {})
        if not actors then return end
        local mb = { head=200,neck_01=200,pelvis=200,spine_01=200,spine_02=200,spine_03=200,
                     upperarm_l=200,upperarm_r=200,lowerarm_l=130,lowerarm_r=130,
                     hand_l=100,hand_r=100,thigh_l=200,thigh_r=200,calf_l=130,calf_r=130,
                     foot_l=100,foot_r=100 }
        for i = 1, actors:Length() do
            local c = actors:Get(i)
            if c and c:IsValid() then
                local mesh = c:GetMesh()
                if mesh then
                    for bone, scale in pairs(mb) do
                        pcall(function() mesh:SetBoneScale(bone, scale, 0, 0, 0) end)
                    end
                end
            end
        end
    end)
end

-- ====== ESP ======
local _enemyCount, _botCount = 0, 0
local function UpdateEnemyCounter()
    pcall(function()
        local enemies = GetEnemies()
        local ec, bc = 0, 0
        for _, e in ipairs(enemies) do
            local name = e:GetName() or ""
            if name:find("Cobra") or name:find("Bot") then bc = bc + 1 else ec = ec + 1 end
        end
        _enemyCount, _botCount = ec, bc
    end)
end

local function DrawEverything()
    if not _G.Mod_ESP_Enabled then return end
    pcall(function()
        local Draw = DrawHelper()
        if not Draw then return end
        local pc = GetPC()
        if not pc then return end
        local hud = pc:GetHUD()
        if not hud then return end
        local canvas = hud.Canvas
        if not canvas then return end
        local enemies = GetEnemies()
        for _, e in ipairs(enemies) do
            local root = e:GetActorLocation()
            local ok, sx, sy = WorldToScreen(root)
            if ok then
                local dist = GetDistance(pc, e) / 100
                local hp = (e:GetHealthPercent and e:GetHealthPercent() or 1) * 100
                local col
                if hp > 70 then col = {r=0,g=1,b=0,a=1}
                elseif hp > 30 then col = {r=1,g=1,b=0,a=1}
                else col = {r=1,g=0,b=0,a=1} end
                if e:GetHealthState and e:GetHealthState() == 2 then col = {r=0,g=0,b=1,a=1} end
                Draw:DrawText(canvas, sx, sy-16, string.format("%.0fm", dist), col)
                Draw:DrawText(canvas, sx, sy, string.format("HP:%.0f", hp), col)
            end
        end
        for _, e in ipairs(enemies) do
            local bones = GetBoneList(e)
            if bones then
                for name, loc in pairs(bones) do
                    local ok, sx, sy = WorldToScreen(loc)
                    if ok then
                        local col, size
                        if name == "head" then col = {r=1,g=0,b=0,a=1}; size = 2
                        else col = {r=0,g=1,b=1,a=1}; size = 1.5 end
                        local d = GetDistance(pc, e) / 40000
                        size = size * (1 - d * 0.5)
                        if size < 0.5 then size = 0.5 end
                        Draw:DrawCircle(canvas, sx, sy, size, col)
                    end
                end
            end
        end
        Draw:DrawText(canvas, 10, 10, string.format("👥 %d  🤖 %d", _enemyCount, _botCount), {r=1,g=1,b=1,a=1})
    end)
end

-- ====== START ALL ======
pcall(function()
    local pc = GetPC()
    if not pc then return end
    AttachAimbotTimer()
    pc:AddGameTimer(0.5, true, ApplyMagicBullet)
    pc:AddGameTimer(0.15, true, DrawEverything)
    pc:AddGameTimer(1, true, UpdateEnemyCounter)
    if _G.Mod_NoGrass_Enabled then
        pc:AddGameTimer(0.1, true, function()
            pcall(function()
                local world = GetWorld()
                if world then
                    KismetSystemLibrary.ExecuteConsoleCommand(world, "grass.DensityScale 0")
                    KismetSystemLibrary.ExecuteConsoleCommand(world, "grass.DiscardDataOnLoad 1")
                end
            end)
        end)
    end
    if _G.Mod_FPS165_Enabled then
        pc:AddGameTimer(0.1, true, function()
            pcall(function()
                local world = GetWorld()
                if world then
                    KismetSystemLibrary.ExecuteConsoleCommand(world, "t.MaxFPS 165")
                    KismetSystemLibrary.ExecuteConsoleCommand(world, "r.FrameRateLimit 165")
                end
            end)
        end)
    end
    pc:AddGameTimer(0.1, true, function() collectgarbage("collect") collectgarbage("collect") end)
end)

return CombineClass.DeclareFeature(CBRPlayerCharacterBase, {
    {SkyTransition="..."}, {CarryDeadBoxFeature="..."}, {SpecialSuitFeature="..."},
    {TeleportPawnFeature="..."}, {LifterControl="..."}, {FinalKillEffect="..."},
    {CampFeature="..."}, {BuildSkateFeature="..."}, {CommonBornlandTransformFeature="..."},
    {ParachuteFormation="..."}
}, "BRPlayerCharacterBase")