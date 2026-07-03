local Class = require("class")
local CharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")

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

local function Valid(obj)
  return slua.isValid(obj)
end

local function ApplyVisualMods(localPlayer, enemy, pc, mWh, mWp)
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
    self._SK_Timer = self:AddGameTimer(0.5, true, drawEnemySkeleton)
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
end

_G.Mod_MagicBullet = true
_G.Mod_MagicSilent = false

local PlayerModule = {}
function PlayerModule:ctor()
  self._wallhackVisualTimer = nil
  self._SK_Timer = nil
  self._weaponTimer = nil
  self._magicTimer = nil
end

function PlayerModule:postConstruct()
  CharacterBase._PostConstruct(self)
end

function PlayerModule:receiveBeginPlay()
  CharacterBase.ReceiveBeginPlay(self)
  self:SetActorTickEnabled(true)
  EventSystem:postEvent(EVENTTYPE_SINGLETRAINING, EVENTID_CHARACTER_BEGINPLAY, self.Object)
  WallHighlight.Initialize(self)
  self._weaponTimer = self:AddGameTimer(0.5, true, function()
    pcall(function() self:ApplyNoRecoil() end)
  end)
  self._magicTimer = self:AddGameTimer(5.0, true, function()
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
                  local mb = { head = 200, neck_01 = 200, pelvis = 200, spine_01 = 200, spine_02 = 200, spine_03 = 200, upperarm_l = 200, upperarm_r = 200, lowerarm_l = 200, lowerarm_r = 200, hand_l = 200, hand_r = 200, thigh_l = 200, thigh_r = 200, calf_l = 200, calf_r = 200, foot_l = 200, foot_r = 200 }
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
  for _, t in ipairs({"_weaponTimer","_magicTimer"}) do
    if self[t] then self:RemoveGameTimer(self[t]); self[t] = nil end
  end
  CharacterBase.ReceiveEndPlay(self, reason)
end

local _AUTO_AIM_RANGES = {"OuterRange", "InnerRange"}

function PlayerModule:applyNoRecoil()
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
  entity.ExtraHitPerformScale = 15
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

function PlayerModule:receiveTick(deltaSeconds)
end

local BRPlayerCharacterBase = Class(CharacterBase, nil, {
  ctor = PlayerModule.ctor,
  _PostConstruct = PlayerModule.postConstruct,
  ReceiveBeginPlay = PlayerModule.receiveBeginPlay,
  ReceiveEndPlay = PlayerModule.receiveEndPlay,
  ReceiveTick = PlayerModule.receiveTick,
  ApplyNoRecoil = PlayerModule.applyNoRecoil
})

return BRPlayerCharacterBase
