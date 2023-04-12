local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")
local Constants = require("monster_manual_scripts.Constants")
local Helpers   = require("monster_manual_scripts.Helpers")


local POINTS_PER_PICKUP = {
    [PickupVariant.PICKUP_COIN] = 1,
    [PickupVariant.PICKUP_BOMB] = 2,
    [PickupVariant.PICKUP_KEY] = 2,
    [PickupVariant.PICKUP_TAROTCARD] = 4,
    [PickupVariant.PICKUP_PILL] = 3,
    [PickupVariant.PICKUP_GRAB_BAG] = 3,
    [PickupVariant.PICKUP_LIL_BATTERY] = 4,
    [PickupVariant.PICKUP_HEART] = 1,
    [PickupVariant.PICKUP_POOP] = 1,
}


---@param familiar EntityFamiliar
local function SpawnBloodEffects(familiar)
    Game():ShakeScreen(30)

    TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.LARGE_BLOOD_EXPLOSION,
        0,
        familiar.Position
    )

    TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.BLOOD_EXPLOSION,
        0,
        familiar.Position
    )

    local rng = TSIL.RNG.NewRNG()
    local numBloodParticles = TSIL.Random.GetRandomInt(15, 30, rng)

    for _ = 1, numBloodParticles, 1 do
        local speed = TSIL.Random.GetRandomFloat(4, 6, rng)
        local angle = TSIL.Random.GetRandomInt(0, 360, rng)

        local velocity = Vector.FromAngle(angle):Resized(speed)

        TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.BLOOD_PARTICLE,
            0,
            familiar.Position,
            velocity
        )
    end
end


---@param player EntityPlayer
local function GetPickupPoints(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local monsterManualInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_MONSTER_MANUAL_INFO
    )
    ---@type MonsterManualInfo
    local monsterManualInfo = monsterManualInfoPerPlayer[playerIndex]

    local points = 5
    TSIL.Utils.Tables.ForEach(monsterManualInfo.UpgradesChosen, function (_, sprite)
        local upgrade = FamiliarUpgrade.GetUpgradeFromSprite(sprite)

        if FamiliarUpgrade.IsUpgradeGreen(upgrade) then
            points = points + 1
        elseif FamiliarUpgrade.IsUpgradeBlue(upgrade) then
            points = points + 2
        else
            points = points + 4
        end
    end)

    return points
end


---@param familiar EntityFamiliar
local function SpawnPickups(familiar)
    local pickupPoints = GetPickupPoints(familiar.Player)

    local rng = familiar:GetDropRNG()

    while pickupPoints > 0 do
        local speed = TSIL.Random.GetRandomFloat(4, 6, rng)
        local angle = TSIL.Random.GetRandomInt(0, 360, rng)

        local velocity = Vector.FromAngle(angle):Resized(speed)

        local pickup = TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_NULL,
            TSIL.Enums.PickupNullSubType.EXCLUDE_COLLECTIBLES_TRINKETS_CHESTS,
            familiar.Position,
            velocity
        )

        local pointsToRemove = POINTS_PER_PICKUP[pickup.Variant]
        pickupPoints = pickupPoints - pointsToRemove
    end
end


---@param player EntityPlayer
local function RemoveFamiliarData(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsedMonsterManual = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_USED_MONSTER_MANUAL
    )
    playersUsedMonsterManual[playerIndex] = false

    local monsterManualInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_MONSTER_MANUAL_INFO
    )
    monsterManualInfoPerPlayer[playerIndex] = nil

    local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
    )
    familiarStatsPerPlayer[playerIndex] = nil
end


---@param player EntityPlayer
local function ExplodeFamiliars(player)
    local familiars = Helpers.GetAllNonPermanentFamiliars(player)

    TSIL.Utils.Tables.ForEach(familiars, function (_, familiar)
        SpawnBloodEffects(familiar)

        SpawnPickups(familiar)

        familiar:Remove()
    end)

    RemoveFamiliarData(player)
end


FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "coathanger",
    function (familiar)
        TSIL.Utils.Functions.RunInFrames(function ()
            SFXManager():Play(Constants.SoundEffect.FAMILIAR_DEATH)
        end, 40)
        TSIL.Utils.Functions.RunInFrames(ExplodeFamiliars, 105, familiar.Player)
    end
)