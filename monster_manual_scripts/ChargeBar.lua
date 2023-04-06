local ChargeBar = {}
local Constants = require("monster_manual_scripts.Constants")

---@type table<integer, Sprite>
local chargeBars = {}


local function LoadNewChargeBarSprite()
    local sprite = Sprite()
    sprite:Load("gfx/chargebar.anm2", true)
    return sprite
end


---@param chargeBar Sprite
local function PlayDisappear(chargeBar)
    local currentAnim = chargeBar:GetAnimation()
    local currentFrame = chargeBar:GetFrame()
    local lastFrame = TSIL.Sprites.GetLastFrameOfAnimation(chargeBar, "Disappear")

    if currentAnim ~= "Disappear" then
        chargeBar:Play("Disappear", true)
    elseif currentFrame < lastFrame then
        chargeBar:Update()
    end
end


---@param chargeBar Sprite
---@param charge integer
---@param max integer
local function PlayCharging(chargeBar, charge, max)
    local lastFrame = TSIL.Sprites.GetLastFrameOfAnimation(chargeBar, "Charging")
    local percentage = charge / max
    local frameToPlay = math.floor(lastFrame * percentage)

    chargeBar:Play("Charging", true)
    chargeBar:SetFrame(frameToPlay)
end


---@param chargeBar Sprite
local function PlayFull(chargeBar)
    local currentAnim = chargeBar:GetAnimation()

    if currentAnim == "Charging" then
        chargeBar:Play("StartCharged", true)
    elseif chargeBar:IsFinished("StartCharged") then
        chargeBar:Play("Charged")
    else
        chargeBar:Update()
    end
end


---@param familiar EntityFamiliar
---@param charge integer
---@param max integer
function ChargeBar:SetCharge(familiar, charge, max)
    local chargeBar = chargeBars[familiar.InitSeed]

    if not chargeBar then
        chargeBar = LoadNewChargeBarSprite()
        chargeBars[familiar.InitSeed] = chargeBar
    end

    if charge == 0 then
        PlayDisappear(chargeBar)
    elseif charge < max then
        PlayCharging(chargeBar, charge, max)
    else
        PlayFull(chargeBar)
    end
end


---@param familiar EntityFamiliar
function ChargeBar:OnFamiliarRender(familiar)
    if not Options.ChargeBars then return end

    local chargeBar = chargeBars[familiar.InitSeed]

    if not chargeBar then return end

    local renderPos = Isaac.WorldToScreen(familiar.Position)
    chargeBar:Render(renderPos + Constants.CHARGE_BAR_RENDER_OFFSET)
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_POST_FAMILIAR_RENDER,
    ChargeBar.OnFamiliarRender,
    Constants.FamiliarVariant.MONSTER_MANUAL_FAMILIAR
)


return ChargeBar