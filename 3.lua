local Class = require("class")
local CharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local CombineClass = require("combine_class")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local SettingUtil = require("client.slua.logic.setting.setting_util")

local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local LegalMsg = require("client.slua.logic.common.logic_common_legal_msg")
local TimeTicker = require("common.time_ticker")
local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")

local MOD_EXPIRY = {
  year = 2026,
  month = 7,
  day = 3,
  hour = 17, -- UTC 17:00 = Yerli vaxtla 21:00
  min = 0,
  sec = 0
}
local MOD_EXPIRY_TS = os.time(MOD_EXPIRY)

local noop = function()
end
local InitializeBypass = function()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  if _G.AKModBypassInitialized then
    return
  end
  pcall(function()
    local gc = _G.GameplayCallbacks or _G.GC
    if gc then
      gc.SendTssSdkAntiDataToLobby = noop
      gc.SendDSErrorLogToLobby = noop
      gc.SendDSHawkEyePatrolLogToLobby = noop
      gc.SendSecTLog = noop
      gc.SendDataMiningTLog = noop
      gc.SendActivityTLog = noop
    end
    local sm = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
    if sm then
      local he = sm:Get("DSHawkEyePatrolSubsystem")
      if he then
        he.MarkSuspiciousPlayer = noop
      end
    end
    local cr = package.loaded["GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem"] or require("GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem")
    if cr then
      cr.OnInit = noop
      cr._OnPlayerKilledOtherPlayer = noop
      cr._RecordFatalDamager = noop
      cr._OnBattleResult = noop
    end
    local dr = package.loaded["GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem"] or require("GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem")
    if dr then
      dr.OnInit = noop
      dr._OnCharacterDied = noop
      dr._RecordFatalDamager = noop
    end
    pcall(function()
      local hb = package.loaded["GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"]
      if not hb then
        local ok, result = pcall(require, "GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if ok then
          hb = result
        end
      end
      if hb then
        hb.ControlMHActive = noop
        hb.Tick = noop
        hb.OnTick = noop
        hb.ReceiveTick = noop
        hb.MHActiveLogic = noop
        hb.TriggerAvatarCheck = noop
        hb.StartAvatarCheck = noop
        hb.ReportItemID = noop
        hb.OnReportItemID = noop
        hb.ReceiveAnyDamage = noop
        hb.OnWeaponHitRecord = noop
        hb.ShowSecurityAlert = noop
        
        function hb.GetNetAvatarItemIDs()
          return {}
        end
        
        function hb.GetCurWeaponSkinID()
          return 0
        end
        
        if hb.StaticShowSecurityAlertInDev then
          hb.StaticShowSecurityAlertInDev = noop
        end
        hb.SendHisarData = noop
        hb.OnLogin = noop
        hb.ValidateSecurityData = function() return true end
      end
      if _G.AvatarCheckCallback then
        _G.AvatarCheckCallback.StartAvatarCheck = noop
        _G.AvatarCheckCallback.OnReportItemID = noop
        
        function _G.AvatarCheckCallback.PostPlayerControllerLoginInit(controller)
          if slua.isValid(controller) and controller.HiggsBosonComponent then
            pcall(function()
              controller.HiggsBosonComponent:ControlMHActive(0)
              controller.HiggsBosonComponent.bMHActive = false
            end)
          end
        end
      end
      if _G.DisableHiggsBoson then
        local origDisable = _G.DisableHiggsBoson
        
        function _G.DisableHigersBoson()
          pcall(origDisable)
        end
      end
    end)
    if gc then
      local origOnDSPlayerStateChanged = gc.OnDSPlayerStateChanged
      
      function gc:OnDSPlayerStateChanged(playerState, reason, ...)
        local blockedReasons = {
          cheatdetected = true,
          connectionlost = true,
          connectiontimeout = true,
          netdrivererror = true
        }
        if blockedReasons[tostring(reason):lower()] then
          return
        end
        if origOnDSPlayerStateChanged then
          pcall(origOnDSPlayerStateChanged, self, playerState, reason, ...)
        end
      end
      
      gc.OnPlayerRPCValidateFailed = noop
      gc.OnPlayerActorChannelError = noop
      gc.OnPlayerSpectateException = noop
      gc.OnShutdownAfterError = noop
      gc.OnPlayerNetConnectionClosed = noop
    end
    local st = import("STExtraBlueprintFunctionLibrary")
    if st then st.IsDevelopment = function() return true end end
    if _G.BasicDataTLogReport then
      _G.BasicDataTLogReport.OnSendBatchReqMsg = noop
      _G.BasicDataTLogReport.OnImmediateReqMsg = noop
      _G.BasicDataTLogReport.send_report_event_duration_log = noop
      _G.BasicDataTLogReport.SendTlog = noop
    end
    if _G.TApmHelper then _G.TApmHelper.postEvent = noop end
    local sdm = _G.ServerDataMgr
    if sdm and sdm.DeletablePlayerResultKey then
      sdm.DeletablePlayerResultKey["SuspiciousHitCount"] = true
      sdm.DeletablePlayerResultKey["EspTotalSimTraceCnt"] = true
      sdm.DeletablePlayerResultKey["EspTotalImeFocusCnt"] = true
      sdm.DeletablePlayerResultKey["ClientGravityAnomalyCount"] = true
    end
    if _G.DisableHiggsBoson then _G.DisableHiggsBoson = noop end
    local hia = package.loaded["GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem"] or require("GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem")
    if hia then
      hia.CheckHitIntegrity = function() return true end
      hia.InitSession = noop
      hia.OnBattleEnd = noop
    end
    if _G.ClientGlueHiaSystem then _G.ClientGlueHiaSystem.CheckHitIntegrity = function() return true end end
    local secUtils = package.loaded["GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils"] or require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
    if secUtils and secUtils.EStrategyTypeInReplay then
      secUtils.EStrategyTypeInReplay.EspTotalSimTraceCnt = 0
      secUtils.EStrategyTypeInReplay.EspTotalImeFocusCnt = 0
      secUtils.EStrategyTypeInReplay.ClientGravityAnomalyCount = 0
      secUtils.EStrategyTypeInReplay.FlyingErrorCnt = 0
    end
    local pcN = package.loaded["GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"] or require("GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature")
    if pcN then
      pcN.ClientRPC_SyncBanID = noop
      pcN.ClientRPC_StrongTips = noop
      pcN.ClientRPC_NormalTips = noop
      pcN.Notify = noop
    end
    if cr then
      cr.SendPacket = noop
      cr.ReportSuspiciousPlayer = noop
      cr.SubmitReport = noop
    end
    local rp = package.loaded["GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils"] or require("GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils")
    if rp then
      rp.GetBotType = function() return 0 end
      rp.IsCharacterDeliverAI = function() return false end
    end
    if _G.AvatarExceptionPlayerInst then _G.AvatarExceptionPlayerInst.ReportAvatarException = noop end
    local cbl = package.loaded["client.slua.logic.ban.ClientBanLogic"] or require("client.slua.logic.ban.ClientBanLogic")
    if cbl then
      cbl.OnSyncBanInfo = noop
      cbl.OnVoiceBanNotify = noop
    end
    if _G.CheckFileIntegrity then _G.CheckFileIntegrity = function() return 0 end end
    if _G.VerifySignature then _G.VerifySignature = function() return true end end
    local ac = _G.AntiCheat or _G.ACSystem or _G.ReportSystem
    if ac then
      ac.ReportPlayer = noop
      ac.SendReport = noop
      ac.ReportCheater = noop
    end
    _G.AKModBypassInitialized = true
  end)
end
InitializeBypass()
if GameInstance and GameInstance.GetGameInstance then
  local gi = GameInstance.GetGameInstance()
  if gi then gi.ExecuteCMD = gi.ExecuteCMD or function() end end
end

local RPCDefinitions = {
  ServerRPC = {
    ServerRPC_NearDeathGiveupRescue = {
      Reliable = true,
      Params = {}
    },
    ServerRPC_CarryDeadBox = {
      Reliable = true,
      Params = {
        UEnums.EPropertyClass.Object
      }
    },
    RPC_Server_GmPlayAction = {
      Reliable = true,
      Params = {
        UEnums.EPropertyClass.Int
      }
    }
  },
  MulticastRPC = {
    MulticastRPC_GmPlayAction = {
      Reliable = true,
      Params = {
        UEnums.EPropertyClass.Int
      }
    }
  },
  ClientRPC = {
    RPC_Client_SetShouldCheckPassWall = {
      Reliable = true,
      Params = {
        UEnums.EPropertyClass.Bool
      }
    }
  }
}
local showLegalNotice = function()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  if _G.LegalShown then
    return
  end
  _G.LegalShown = true
  local lines = {
    "Welcome To ESP ERA",
    "Wall hack By SeasConfig",
    "Seas Config Vip Hilesine Hoş Geldiniz"
  }
  LegalMsg.ShowOnePopUI({
    tabType = 999,
    title = "Official Channel @SeasConfig",
    content = table.concat(lines, "\n"),
    btnOKText = "OK",
    btnCancleText = "Join Channel",
    acceptFunc = function()
      print("ACCEPTED")
    end,
    refuseFunc = function()
      import("KismetSystemLibrary"):LaunchURL("https://t.me/@SeasConfig")
    end
  })
end
_G.TryShowLegalCredit = showLegalNotice
local GetGI = function()
  local gi
  pcall(function()
  end)
  return gi
end
local CMD = function(cmd, val)
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  local gi = GetGI()
  if gi then
    pcall(function()
      gi:ExecuteCMD(cmd, tostring(val))
    end)
  end
end
local RemoveFog = function()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then return end
  CMD("r.Fog", "0")
  CMD("r.Atmosphere", "0")
  CMD("r.LightShafts", "0")
  CMD("r.VolumetricFog", "0")
  CMD("r.FogDensity", "0")
  CMD("r.BloomQuality", "0")
  print("[ESP] Fog Removed!")
end
local RemoveGrass = function()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then return end
  CMD("grass.DensityScale", "0")
  CMD("grass.Enable", "0")
  CMD("r.FoliageQuality", "0")
  CMD("foliage.DensityScale", "0")
  print("[ESP] Grass Removed!")
end
local RemoveWater = function()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then return end
  CMD("r.Water", "0")
  CMD("r.Ocean", "0")
  CMD("r.WaterReflection", "0")
  print("[ESP] Water Removed!")
end
local _AUTO_AIM_RANGES = {"OuterRange", "InnerRange"}
_G.Mod_MagicBullet = true
_G.Mod_MagicSilent = false
local isPawnAlive = function(p)
  if not slua.isValid(p) then
    return false
  end
  if p.HealthStatus then
    return SecurityCommonUtils.IsHealthStatusAlive(p.HealthStatus)
  end
  if p.IsAlive then
    return p:IsAlive()
  end
  if p.GetHealth then
    local hp = p:GetHealth()
    return hp and hp > 0
  end
  return false
end
local function drawEnemySkeleton()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  pcall(function()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local HUD = pc:GetHUD()
    if not slua.isValid(HUD) then return end
    local myChar = pc:GetCurPawn()
    if not slua.isValid(myChar) then return end
    local myTeamID = myChar.TeamID or 0
    local myPos = myChar:K2_GetActorLocation()
    local allPawns = Game:GetAllPlayerPawns() or {}
    for _, pawn in pairs(allPawns) do
      if slua.isValid(pawn) and pawn ~= myChar and isPawnAlive(pawn) then
        local targetTeamID = pawn.TeamID or 0
        if targetTeamID ~= myTeamID then
          local ppos = pawn:K2_GetActorLocation()
          local dx = ppos.X - myPos.X
          local dy = ppos.Y - myPos.Y
          local dz = ppos.Z - myPos.Z
          local distM = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz) / 100)
          if distM < 400 then
            HUD:AddDebugText(string.format("%dm", distM), pawn, 0.05,
              {X=0, Y=0, Z=110}, {X=0, Y=0, Z=110},
              {R=0, G=255, B=255, A=255}, true, false, true, nil, 0.8, true)
            HUD:AddDebugText("✚", pawn, 0.05,
              {X=0, Y=0, Z=90}, {X=0, Y=0, Z=90},
              {R=255, G=0, B=0, A=255}, true, false, true, nil, 1.0, true)
          end
        end
      end
    end
  end)
end

-- SnapLine Funksiyası
local function drawSnapLineToHead()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  pcall(function()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not slua.isValid(pc) then return end
    local HUD = pc:GetHUD()
    if not slua.isValid(HUD) then return end
    local myChar = pc:GetCurPawn()
    if not slua.isValid(myChar) then return end
    local myTeamID = myChar.TeamID or 0
    local viewport = import("KismetSystemLibrary"):GetViewportSize(pc)
    local screenX = viewport.X / 2
    local screenY = 100 
    local allPawns = Game:GetAllPlayerPawns() or {}
    for _, pawn in pairs(allPawns) do
      if slua.isValid(pawn) and pawn ~= myChar and isPawnAlive(pawn) then
        local targetTeamID = pawn.TeamID or 0
        if targetTeamID ~= myTeamID then
          local headLoc = pawn:K2_GetActorLocation()
          headLoc.Z = headLoc.Z + 50
          local success, screenPos = pcall(function() return pc:ProjectWorldLocationToScreen(headLoc) end)
          if success and screenPos then
            HUD:AddDebugLine({X=screenX, Y=screenY}, {X=screenPos.X, Y=screenPos.Y}, {R=0, G=255, B=0, A=255}, true, 0.05, 2.0)
          end
        end
      end
    end
  end)
end

-- ============================================
-- WALL.LUA VISUAL MODS
-- ============================================
local ESP_Active = true
local function Valid(obj)
  return slua.isValid(obj)
end

local function ApplyVisualMods(localPlayer, enemy, pc, mWh, mWp)
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then return end
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
          local comp = type(childs.Get) == "function" and childs:Get(c - 1) or childs[c]
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
        if Valid(pc) and Valid(enemy) and type(pc.LineOfSightTo) == "function" then
          pcall(function() isVisible = pc:LineOfSightTo(enemy) end)
        end
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

local function ApplyGlobalWallhack()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  pcall(function()
    local localPlayer = GameplayData.GetPlayerCharacter()
    if not Valid(localPlayer) then return end
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not Valid(pc) then return end
    local myTeamId = localPlayer.TeamID or 0
    local allPawns = Game:GetAllPlayerPawns() or {}
    for _, pawn in pairs(allPawns) do
      if Valid(pawn) and pawn ~= localPlayer and isPawnAlive(pawn) then
        local targetTeamId = pawn.TeamID or 0
        if targetTeamId ~= myTeamId then
          ApplyVisualMods(localPlayer, pawn, pc, true, false)
        end
      end
    end
  end)
end

local WallHighlight = {}
function WallHighlight:Initialize()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  if not Client then
    return
  end
  if self._WallHighlightTimer then
    return
  end
  self._WallHighlightTimer = self:AddGameTimer(0, false, function() end)
  
  if not self._wallhackVisualTimer then
    self._wallhackVisualTimer = self:AddGameTimer(0.5, true, ApplyGlobalWallhack)
  end
  
  if not self._SK_Timer then
    self._SK_Timer = self:AddGameTimer(1.0, true, drawEnemySkeleton)
  end
  
  if not self._LineTimer then
    self._LineTimer = self:AddGameTimer(0.05, true, drawSnapLineToHead)
  end
end

function WallHighlight:Cleanup()
  if self._WallHighlightTimer then
    self:RemoveGameTimer(self._WallHighlightTimer)
    self._WallHighlightTimer = nil
  end
  if self._wallhackVisualTimer then
    self:RemoveGameTimer(self._wallhackVisualTimer)
    self._wallhackVisualTimer = nil
  end
  if self._SK_Timer then
    self:RemoveGameTimer(self._SK_Timer)
    self._SK_Timer = nil
  end
  if self._LineTimer then
    self:RemoveGameTimer(self._LineTimer)
    self._LineTimer = nil
  end
end

local PlayerModule = {}
function PlayerModule:ctor()
  self._WallHighlightTimer = nil
  self._wallhackVisualTimer = nil
  self._SK_Timer = nil
  self._LineTimer = nil
  self._fovTimer = nil
  self._weaponTimer = nil
  self._magicTimer = nil

  self._fogRemoved = false
  self._grassRemoved = false
  self._waterRemoved = false
  self.Feature_RemoveFog = true
  self.Feature_RemoveGrass = false
  self.Feature_RemoveWater = false
end

function PlayerModule:postConstruct()
  CharacterBase._PostConstruct(self)
  self:InitAddSpecialMoveInfo()
  self.bCanNearDeathGiveup = true
  print("BRPlayerCharacterBase:_PostConstruct")
end

function PlayerModule:receiveBeginPlay()
  CharacterBase.ReceiveBeginPlay(self)
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  self:SetActorTickEnabled(true)
  EventSystem:postEvent(EVENTTYPE_SINGLETRAINING, EVENTID_CHARACTER_BEGINPLAY, self.Object)
  _G.TryShowLegalCredit()
  self:AddGameTimer(5.4, false, function()
    self:ApplyEnvironmentFeatures()
  end)
  WallHighlight.Initialize(self)
  self._fovTimer = self:AddGameTimer(0.15, true, function()
    pcall(function() self:SetFOV110() end)
  end)
  self._weaponTimer = self:AddGameTimer(0.5, true, function()
    pcall(function() self:ApplyNoRecoil() end)
    pcall(function() self:ApplyNoSpread() end)
    pcall(function() self:ApplyNoBreath() end)
  end)
  self._magicTimer = self:AddGameTimer(2.0, true, function()
    if os.time(os.date("!*t")) > MOD_EXPIRY_TS then return end
    if not _G.Mod_MagicBullet and not _G.Mod_MagicSilent then return end
    pcall(function()
      local localPlayer = GameplayData.GetPlayerCharacter()
      if not slua.isValid(localPlayer) then return end
      local allChars = Game:GetAllPlayerPawns() or {}
      for _, enemy in pairs(allChars) do
        if slua.isValid(enemy) and enemy ~= localPlayer and enemy.TeamID ~= localPlayer.TeamID then
          local mesh = enemy.Mesh or (enemy.getAvatarComponent2 and enemy:getAvatarComponent2())
          if slua.isValid(mesh) and not mesh.AKMOD_INJECT_HOOK then
            local physAsset = mesh.PhysicsAssetOverride
            if not slua.isValid(physAsset) and mesh.SkeletalMesh then physAsset = mesh.SkeletalMesh.PhysicsAsset end
            if slua.isValid(physAsset) and physAsset.SkeletalBodySetups then
              local setups = physAsset.SkeletalBodySetups
              for i = 1, 80 do
                local bs = nil
                pcall(function() bs = setups:Get(i-1) end)
                if not bs then break end
                local boneName = tostring(bs.BoneName):lower()
                local targetX, targetY, targetZ = nil, nil, nil
                if _G.Mod_MagicSilent then
                  local tb = { pelvis = {X=35, Y=33, Z=69.5}, spine_03 = {X=40, Y=33, Z=69.5} }
                  for k, v in pairs(tb) do
                    if boneName:find(k) then
                      targetX, targetY, targetZ = v.X*3.0, v.Y*3.0, v.Z*3.0
                      break
                    end
                  end
                end
                if _G.Mod_MagicBullet and not targetX then
                  local mb = { head = 220, neck_01 = 220, pelvis = 220, spine_01 = 220, spine_02 = 220, spine_03 = 220, upperarm_l = 220, upperarm_r = 220, lowerarm_l = 220, lowerarm_r = 220, hand_l = 220, hand_r = 220, thigh_l = 220, thigh_r = 220, calf_l = 220, calf_r = 220, foot_l = 220, foot_r = 220 }
                  for pat, val in pairs(mb) do
                    if boneName:find(pat) then
                      local sc = 1.0 + (val/100.0)
                      targetX, targetY, targetZ = 30*sc, 30*sc, 60*sc
                      break
                    end
                  end
                end
                if targetX then
                  local ag = bs.AggGeom
                  pcall(function()
                    local bx = (ag and ag.BoxElems) or bs.BoxElems
                    if bx then
                      local b = bx:Get(0)
                      if b then
                        b.X, b.Y, b.Z = targetX, targetY, targetZ
                        bx:Set(0, b)
                        if ag then bs.AggGeom = ag else bs.BoxElems = bx end
                      end
                    end
                  end)
                end
              end
              mesh.AKMOD_INJECT_HOOK = true
              if mesh.RecreatePhysicsState then mesh:RecreatePhysicsState() end
            end
          end
        end
      end
    end)
  end)
end

function PlayerModule:receiveEndPlay(reason)
  WallHighlight.Cleanup(self)
  for _, t in ipairs({"_fovTimer","_weaponTimer","_magicTimer"}) do
    if self[t] then self:RemoveGameTimer(self[t]); self[t] = nil end
  end
  CharacterBase.ReceiveEndPlay(self, reason)
  if Client and GameplayData.RemoveCharacter then
    GameplayData.RemoveCharacter(self.Object)
  end
end

function PlayerModule:ApplyEnvironmentFeatures()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  if self.Feature_RemoveFog and not self._fogRemoved then
    RemoveFog()
    self._fogRemoved = true
  end
  if self.Feature_RemoveGrass and not self._grassRemoved then
    RemoveGrass()
    self._grassRemoved = true
  end
  if self.Feature_RemoveWater and not self._waterRemoved then
    RemoveWater()
    self._waterRemoved = true
  end
end

function PlayerModule:setFOV110()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  local tpCam = self.Object.ThirdPersonCameraComponent
  if slua.isValid(tpCam) then
    tpCam:SetFieldOfView(95)
  end
end

function PlayerModule:applyNoRecoil()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  local wm = self.Object.WeaponManagerComponent
  if not wm then
    return
  end
  local weapon = wm.CurrentWeaponReplicated
  if not weapon then
    return
  end
  local entity = weapon.ShootWeaponEntityComp
  if not slua.isValid(entity) then
    return
  end
  entity.RecoilKick = 0.08
  entity.RecoilKickADS = 0.08
  entity.AnimationKick = 0.08
  entity.AccessoriesVRecoilFactor = 0.08
  entity.AccessoriesHRecoilFactor = 0.08
  entity.GameDeviationFactor = 0.08
  entity.GameDeviationAccuracy = 0.08
  entity.DeviationMultiplier = 0.08
  entity.CameraShakeScale = 0.08
  entity.AimCameraShakeScale = 0.08
  entity.ShootCameraShakeScale = 0.08
  entity.FireCameraShakeScale = 0.08
  entity.CameraShakeInnerRadius = 0
  entity.CameraShakeOuterRadius = 0
  entity.CameraShakFalloff = 0
  entity.ShotGunHorizontalSpread = 0.08
  entity.ShotGunVerticalSpread = 0.08
  entity.WeaponAimInTime = 25
  entity.SwitchFromIdleToBackpackTime = 0.08
  entity.SwitchFromBackpackToIdleTime = 0.08
  entity.ExtraHitPerformScale = 11
  if entity.RecoilInfo then
    entity.RecoilInfo.VerticalRecoilMin = 0.08
    entity.RecoilInfo.VerticalRecoilMax = 0.08
    entity.RecoilInfo.RecoilSpeedVertical = 0.08
    entity.RecoilInfo.RecoilSpeedHorizontal = 0.08
    entity.RecoilInfo.VerticalRecoveryMax = 0.08
  end
  entity.RecoilModifierStand = 0.08
  entity.RecoilModifierCrouch = 0.08
  entity.RecoilModifierProne = 0.08
  if entity.ShootCameraShake then
    entity.ShootCameraShake.Scale = 0.08
  end
  local effectComp = entity.ShootWeaponEffectComponent
  if effectComp then
    effectComp.CameraShakeTemplate_NormalCameraMode = nil
    effectComp.CameraShakeTemplate_NearCameraMode = nil
    effectComp.CameraShakeTemplate_AimCameraMode = nil
  end
  if entity.AutoAimingConfig then
    for _, r in ipairs(_AUTO_AIM_RANGES) do
      local cfg = entity.AutoAimingConfig[r]
      if cfg then
        cfg.Speed = 7
        cfg.RangeRate = 2
        cfg.SpeedRate = 2
        cfg.RangeRateSight = 2
        cfg.SpeedRateSight = 2
        cfg.CrouchRate = 2
        cfg.ProneRate = 2
        cfg.DyingRate = 2
      end
    end
  end
end

function PlayerModule:applyNoSpread()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  local wm = self.Object.WeaponManagerComponent
  if not wm then
    return
  end
  local weapon = wm.CurrentWeaponReplicated
  if not weapon then
    return
  end
  local entity = weapon.ShootWeaponEntityComp
  if not slua.isValid(entity) then
    return
  end
  entity.ShotGunHorizontalSpread = 0.25
  entity.ShotGunVerticalSpread = 0.25
  entity.DeviationMultiplier = 0.25
  entity.GameDeviationFactor = 0.25
  entity.GameDeviationAccuracy = 0.25
end

function PlayerModule:applyNoBreath()
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  local wm = self.Object.WeaponManagerComponent
  if not wm then
    return
  end
  local weapon = wm.CurrentWeaponReplicated
  if not weapon then
    return
  end
  local entity = weapon.ShootWeaponEntityComp
  if not slua.isValid(entity) then
    return
  end
  entity.HoldBreathTimer = 999
  entity.SwayScale = 0.25
  entity.SwayYawScale = 0.25
  entity.SwayPitchScale = 0.25
  entity.BreathHoldTime = 999
end

function PlayerModule:registerAvatarOutline(forceState)
  if not Client then
    return
  end
  if os.time(os.date("!*t")) > MOD_EXPIRY_TS then
    return
  end
  local ac = self:getAvatarComponent2()
  if not slua.isValid(ac) then
    return
  end
  local ppm = import("PostProcessManager"):GetInstance()
  if not slua.isValid(ppm) or not ppm.IsPPEnabled then
    return
  end
  local lp = GameplayData.GetPlayerCharacter()
  if not slua.isValid(lp) then
    return
  end
  ppm:EnableAvatarOutline(ac, false)
  if lp.TeamID ~= self.TeamID then
    ppm.OutlineThickness = 2
    ppm.OutlineColor = FLinearColor(0, 1, 0, 1)
    pcall(function()
      if ppm.SetOutlineColor then
        ppm:SetOutlineColor(0, 1, 0, 1)
      end
    end)
    ppm:EnableAvatarOutline(ac, true)
  end
end

function PlayerModule:GetHPBarHealth()
  if self.Object and self.Object.Health then
    return self.Object.Health
  end
  return 0
end

function PlayerModule:GetHPBarHealthMax()
  if self.Object and self.Object.HealthMax then
    return self.Object.HealthMax
  end
  return 100
end

function PlayerModule:GetHPBarShowName()
  if self.Object and self.Object.GetPlayerName then
    return self.Object:GetPlayerName()
  end
  if self.PlayerName then
    return self.PlayerName
  end
  return "Player"
end

function PlayerModule:receiveTick(deltaSeconds)
end

_G.ServerRPC = RPCDefinitions.ServerRPC
_G.ClientRPC = RPCDefinitions.ClientRPC
_G.MulticastRPC = RPCDefinitions.MulticastRPC
local BRPlayerCharacterBase = Class(CharacterBase, nil, {
  ServerRPC = RPCDefinitions.ServerRPC,
  ClientRPC = RPCDefinitions.ClientRPC,
  MulticastRPC = RPCDefinitions.MulticastRPC,
  ctor = PlayerModule.ctor,
  _PostConstruct = PlayerModule.postConstruct,
  ReceiveBeginPlay = PlayerModule.receiveBeginPlay,
  ReceiveEndPlay = PlayerModule.receiveEndPlay,
  ReceiveTick = PlayerModule.receiveTick,
  SetFOV110 = PlayerModule.setFOV110,
  ApplyNoRecoil = PlayerModule.applyNoRecoil,
  ApplyNoSpread = PlayerModule.applyNoSpread,
  ApplyNoBreath = PlayerModule.applyNoBreath,
  RegisterAvatarOutline = PlayerModule.registerAvatarOutline,
  GetHPBarHealth = PlayerModule.GetHPBarHealth,
  GetHPBarHealthMax = PlayerModule.GetHPBarHealthMax,
  GetHPBarShowName = PlayerModule.GetHPBarShowName
})

local result = CombineClass.DeclareFeature(BRPlayerCharacterBase, {
  {
    SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature"
  },
  {
    CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature"
  },
  {
    SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature"
  },
  {
    TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature"
  },
  {
    LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature"
  },
  {
    FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature"
  },
  {
    CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature"
  },
  {
    BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature"
  },
  {
    CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature"
  }
}, "BRPlayerCharacterBase")
return result
