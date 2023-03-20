local Familiar = {}
local Constants = require("monster_manual_scripts.Constants")
local ItemDrop = require("monster_manual_scripts.ItemDrop")
local TearEffect = require("monster_manual_scripts.TearEffect")

---@param player EntityPlayer
function Familiar:OnFamiliarCache(player)
    local playersUsedMonsterManual = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_USED_MONSTER_MANUAL
    )
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local hasUsedMonsterManual = playersUsedMonsterManual[tostring(playerIndex)]

    if not hasUsedMonsterManual then return end

    local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
    )

    ---@type MonsterManualStats
    local familiarStats = familiarStatsPerPlayer[tostring(playerIndex)]

    local numFamiliars = 1

    if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.TWINS) then
        numFamiliars = 2
    end

    player:CheckFamiliar(
        Constants.FamiliarVariant.MONSTER_MANUAL_FAMILIAR,
        numFamiliars,
        player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_MONSTER_MANUAL)
    )
end

ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    Familiar.OnFamiliarCache,
    CacheFlag.CACHE_FAMILIARS
)


---@param familiar EntityFamiliar
function Familiar:OnFamiliarInit(familiar)
    local player = familiar.Player
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
    )

    ---@type MonsterManualStats
    local familiarStats = familiarStatsPerPlayer[tostring(playerIndex)]

    local sprite = familiar:GetSprite()
    sprite:ReplaceSpritesheet(0, "gfx/familiars/" .. familiarStats.Sprite .. ".png")
    sprite:LoadGraphics()

    familiar:AddToFollowers()
end

ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_FAMILIAR_INIT,
    Familiar.OnFamiliarInit,
    Constants.FamiliarVariant.MONSTER_MANUAL_FAMILIAR
)


---@param familiar EntityFamiliar
function Familiar:OnFamiliarUpdate(familiar)
    familiar:FollowParent()

    local player = familiar.Player
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
    )

    ---@type MonsterManualStats
    local familiarStats = familiarStatsPerPlayer[tostring(playerIndex)]

    if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.TWINS) then
        familiar.SpriteScale = familiar.SpriteScale * 0.75
    end

    local shootAnimFrames = TSIL.Entities.GetEntityData(
        ImprovedMonsterManualMod,
        familiar,
        "ShootAnimFrames"
    )
    if not shootAnimFrames then shootAnimFrames = 0 end
    local fireDir = player:GetFireDirection()
    local sprite = familiar:GetSprite()

    if familiar.FireCooldown > 0 then
        familiar.FireCooldown = familiar.FireCooldown - 1
    end

    if fireDir ~= Direction.NO_DIRECTION then
        if familiar.FireCooldown > 0 then
            if shootAnimFrames > 0 then
                shootAnimFrames = shootAnimFrames - 1
            else
                sprite:SetAnimation(Constants.FLOAT_ANIM_PER_DIRECTION[fireDir], false)
            end
        else
            --Set tear delay (half if the player has forgotten lullaby)
            familiar.FireCooldown = familiarStats.FireRate
            if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
                familiar.FireCooldown = math.max(1, math.ceil(familiar.FireCooldown / 2))
            end

            --If OnShoot returns true, ignore the default shooting logic
            --If it returns false, player the animation but ignore the shooting
            sprite:SetAnimation(Constants.SHOOT_ANIM_PER_DIRECTION[fireDir], false)
            shootAnimFrames = 16

            local familiarTear = familiar:FireProjectile(TSIL.Direction.DirectionToVector(fireDir))

            if familiarStats.TearVariant ~= TearVariant.BLUE then
                familiarTear:ChangeVariant(familiarStats.TearVariant)
            end

            --Add flags
            familiarTear:AddTearFlags(familiarStats.Flags)

            --Set color (make them purple if they have baby bender)
            if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                familiarTear.Color = Constants.PURPLE_TEAR_COLOR
            end

            --Set damage (double it if bff)
            familiarTear.CollisionDamage = familiarStats.Damage
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                familiarTear.CollisionDamage = familiarTear.CollisionDamage * 2
            end

            --Set tear scale
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                familiarTear.Scale = familiarTear.Scale + 0.3
            end

            --Set shot speed
            familiarTear.Velocity = familiarTear.Velocity * familiarStats.ShotSpeed

            TearEffect.TriggerTearEffect(familiar, familiarTear, familiarStats)
        end
    else
        if shootAnimFrames > 0 then
            shootAnimFrames = shootAnimFrames - 1
        else
            sprite:SetAnimation(Constants.FLOAT_ANIM_PER_DIRECTION[fireDir], false)
        end
    end

    TSIL.Entities.SetEntityData(
        ImprovedMonsterManualMod,
        familiar,
        "ShootAnimFrames",
        shootAnimFrames
    )
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    Familiar.OnFamiliarUpdate,
    Constants.FamiliarVariant.MONSTER_MANUAL_FAMILIAR
)


function Familiar:OnRoomClear()
    local monsterManualFamiliars = TSIL.EntitySpecific.GetFamiliars(
        Constants.FamiliarVariant.MONSTER_MANUAL_FAMILIAR
    )

    TSIL.Utils.Tables.ForEach(monsterManualFamiliars, function(_, familiar)
        local player = familiar.Player
        local playerIndex = TSIL.Players.GetPlayerIndex(player)

        local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
        )

        ---@type MonsterManualStats
        local familiarStats = familiarStatsPerPlayer[tostring(playerIndex)]

        ItemDrop.TriggerDrops(familiar, familiarStats)
    end)
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    Familiar.OnRoomClear
)
