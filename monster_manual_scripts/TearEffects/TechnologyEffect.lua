local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")
local Helpers = require("monster_manual_scripts.Helpers")


---@param ... EffectVariant
---@return EntityEffect[]
local function GetEffectsOfVariants(...)
    local variants = {...}
    ---@type EntityEffect[]
    local entities = {}

    for _, variant in ipairs(variants) do
        local effects = TSIL.EntitySpecific.GetEffects(variant)
        for _, effect in ipairs(effects) do
            entities[#entities+1] = effect
        end
    end

    return entities
end


---@param tear EntityTear
local function ReplacePoofSprite(tear)
    local tearPoofs = GetEffectsOfVariants(
        EffectVariant.TEAR_POOF_A,
        EffectVariant.TEAR_POOF_B,
        EffectVariant.TEAR_POOF_SMALL,
        EffectVariant.TEAR_POOF_VERYSMALL
    )

    local tearPoofsSpawned = TSIL.Utils.Tables.Filter(tearPoofs, function (_, poof)
        return poof.FrameCount == 0
    end)
    table.sort(tearPoofsSpawned, function (a, b)
        local distanceA = a.Position:DistanceSquared(tear.Position)
        local distanceB = b.Position:DistanceSquared(tear.Position)

        return distanceA < distanceB
    end)
    local tearPoof = tearPoofsSpawned[1]

    if not tearPoof then return end

    local sprite = tearPoof:GetSprite()
    sprite:Load("gfx/1000.126_tech dot.anm2", true)
    sprite:ReplaceSpritesheet(1, "nothing")
    sprite:LoadGraphics()
    sprite:Play("Disappear", true)
end


---@param tear EntityTear
local function ShootTechLaser(tear)
    local spawner = tear.SpawnerEntity
    if not spawner then return end
    local familiar = spawner:ToFamiliar()
    if not familiar then return end

    ---@type MonsterManualStats
    local familiarStats = Helpers.GetFamiliarStats(familiar)

    local rng = TSIL.RNG.NewRNG(tear.InitSeed)
    local shootAngle = TSIL.Random.GetRandomInt(0, 360, rng)

    local laser = EntityLaser.ShootAngle(
        LaserVariant.THIN_RED,
        tear.Position + Vector(0, tear.Height),
        shootAngle,
        5,
        Vector.Zero,
        nil
    )
    laser.CollisionDamage = familiarStats.Damage

    local room = Game():GetRoom()
    if room:HasWater() then
        laser.MaxDistance = TSIL.Random.GetRandomInt(140, 260, rng)
    else
        laser.MaxDistance = TSIL.Random.GetRandomInt(70, 130, rng)
    end

    laser:Update()
    laser.SpriteScale = Vector(0.6, 0.7)
end


---@param entity Entity
local function OnTearRemove(_, entity)
    local tear = entity:ToTear()

    local isTechTear = TSIL.Entities.GetEntityData(
        ImprovedMonsterManualMod,
        tear,
        "IsTechTear"
    )

    if not isTechTear then return end

    ReplacePoofSprite(tear)
    ShootTechLaser(tear)
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    OnTearRemove,
    EntityType.ENTITY_TEAR
)


TearEffect.AddTearEffect(
    Constants.TearEffects.TECHNOLOGY,
    function (_, tear, stats, rng)
        local sprite = tear:GetSprite()
        sprite:Load("gfx/1000.126_tech dot.anm2", true)
        sprite:ReplaceSpritesheet(1, "nothing")
        sprite:LoadGraphics()
        sprite:Play("Idle", true)
        TSIL.Entities.SetEntityData(
            ImprovedMonsterManualMod,
            tear,
            "IsTechTear",
            true
        )
    end,
    function ()
    end
)