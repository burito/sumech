--[[
Copyright (c) 2021-2022 Daniel Burke

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

   1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

   3. This notice may not be removed or altered from any source
   distribution.
--]]


SuMech = {}
SuMech.name = "SuMech"

function SuMech:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top

  SuMechBox:ClearAnchors()
  SuMechBox:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

function SuMech.OnWorldMapChanged()
  SuMech.zone = GetUnitZone("player")
  SuMechBoxTitle:SetText(SuMech.zone)
  SuMech:OnGroupChanged()
end

function SuMech.OnGroupChanged()
  SuMech.role = GetGroupMemberSelectedRole("player")
  if SuMech.role == 0 then -- Solo
    SuMechBoxJob:SetText("Solo")
  elseif SuMech.role == 1 then -- DPS
    SuMechBoxJob:SetText("DPS")
  elseif SuMech.role == 2 then -- Tank
    SuMechBoxJob:SetText("Tank")
  elseif SuMech.role == 4 then -- Healer
    SuMechBoxJob:SetText("Healer")
  end
end

function SuMech:OnTargetChanged()
  if not DoesUnitExist('reticleover') then return end
  if SuMech.zone == nil then SuMech:OnWorldMapChanged() end
  if SuMech.data[SuMech.zone] == nil then return end
  local mob = GetUnitName('reticleover')
  local zone = SuMech.data[SuMech.zone]
  local role = SuMech.role
  if zone[mob] == nil then return end
  if zone[mob][role] == nil then role = 0 end
  SuMechBoxTitle:SetText(mob)
  SuMechBoxJob:SetText(zone[mob][role])
end


function SuMech:Initialize()
  -- restore addon screen position
  self.savedVariables = ZO_SavedVars:NewAccountWide("SuMechSavedVariables", 1, nil, {})
  self:RestorePosition()

  -- register for relevant events
  CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", SuMech.OnWorldMapChanged)
  EVENT_MANAGER:RegisterForEvent(SuMech.name, EVENT_RETICLE_TARGET_CHANGED, SuMech.OnTargetChanged)
  EVENT_MANAGER:RegisterForEvent(SuMech.name, EVENT_GROUP_UPDATE, SuMech.OnGroupChanged)

  -- hide the addon if in menus/inventory
  local fragment = ZO_FadeSceneFragment:New( SuMechBox )
  SCENE_MANAGER:GetScene('hud'):AddFragment( fragment )
  SCENE_MANAGER:GetScene('hudui'):AddFragment( fragment )

  -- set the title and job
  SuMech:OnWorldMapChanged()
end

-- window movement
function SuMech.OnIndicatorMoveStop()
  SuMech.savedVariables.left = SuMechBox:GetLeft()
  SuMech.savedVariables.top = SuMechBox:GetTop()
end

-- init
function SuMech.onAddOnLoaded(event, addonName)
  if addonName ~= SuMech.name then return end
  SuMech:Initialize()
end

EVENT_MANAGER:RegisterForEvent(SuMech.name, EVENT_ADD_ON_LOADED, SuMech.onAddOnLoaded)