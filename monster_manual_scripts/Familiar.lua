local Familiar = {}
local Constants = require("monster_manual_scripts.Constants")
local ItemDrop = require("monster_manual_scripts.ItemDrop")
local TearEffect = require("monster_manual_scripts.TearEffect")
local ChargeBar = require("monster_manual_scripts.ChargeBar")
local Helpers   = require("monster_manual_scripts.Helpers")

---@param player EntityPlayer
function Familiar:OnFamiliarCache(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local numPersistentFamiliarsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.NUM_PERMANENT_FAMILIARS_PER_PLAYER
    )
    local permanentFamiliars = numPersistentFamiliarsPerPlayer[playerIndex]
    if permanentFamiliars == nil then permanentFamiliars = 0 end

    local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
    )

    ---@type MonsterManualStats
    local familiarStats = familiarStatsPerPlayer[playerIndex]
    local numFamiliars = 0

    if familiarStats then
        numFamiliars = 1

        if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.TWINS) then
            numFamiliars = 2
        end
    end

    if not player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL) then
        numFamiliars = 0
    end

    TSIL.Familiars.CheckFamiliar(
        player,
        CollectibleType.COLLECTIBLE_MONSTER_MANUAL,
        permanentFamiliars + numFamiliars,
        0
    )
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    Familiar.OnFamiliarCache,
    CacheFlag.CACHE_FAMILIARS
)


---@param player EntityPlayer
function Familiar:OnPlayerPeffectUpdate(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local hadMonsterManualLastFramePerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_HAD_MONSTER_MANUAL
    )

    local hadMonsterManualLastFrame = hadMonsterManualLastFramePerPlayer[playerIndex]
    local hasMonsterManualCurrent = player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL)

    if hadMonsterManualLastFrame == nil then
        hadMonsterManualLastFrame = hasMonsterManualCurrent
    end

    if hadMonsterManualLastFrame ~= hasMonsterManualCurrent then
        if hasMonsterManualCurrent == false then
            local familiars = Helpers.GetAllNonPermanentFamiliars(player)

            TSIL.Utils.Tables.ForEach(familiars, function (_, familiar)
                TSIL.EntitySpecific.SpawnEffect(
                    EffectVariant.POOF01,
                    0,
                    familiar.Position
                )
                familiar:Remove()
            end)
        end

        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
        player:EvaluateItems()
    end

    hadMonsterManualLastFramePerPlayer[playerIndex] = hasMonsterManualCurrent
end
ImprovedMonsterManualMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_PEFFECT_UPDATE_REORDERED,
    Familiar.OnPlayerPeffectUpdate
)


---@param familiar EntityFamiliar
function Familiar:OnFamiliarInit(familiar)
    ---@type MonsterManualStats
    local familiarStats = Helpers.GetFamiliarStats(familiar)

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
---@param familiarStats MonsterManualStats
---@param direction Vector
---@param positionOffset Vector?
local function ShootFamiliarTear(familiar, familiarStats, direction, positionOffset)
    local player = familiar.Player
    local familiarTear = familiar:FireProjectile(direction)

    if positionOffset then
        familiarTear.Position = familiarTear.Position + positionOffset
    end

    if familiarStats.TearVariant ~= TearVariant.BLUE then
        familiarTear:ChangeVariant(familiarStats.TearVariant)
    end

    --Add flags
    familiarTear:AddTearFlags(familiarStats.Flags)

    --Set color (make them purple if they have baby bender)
    if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
        familiarTear.Color = Constants.PURPLE_TEAR_COLOR
    end

    if familiarStats.TearColor.R ~= 0 and
    familiarStats.TearColor.G ~= 0 and
    familiarStats.TearColor.B ~= 0 then
        familiarTear.Color = familiarStats.TearColor
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

    --Set range
    familiarTear.FallingSpeed = familiarTear.FallingSpeed + familiarStats.FallingSpeed
    familiarTear.FallingAcceleration = familiarTear.FallingAcceleration + familiarStats.FallingAccel

    local rng = TSIL.RNG.NewRNG(familiarTear.InitSeed)
    TearEffect.TriggerTearEffect(familiar, familiarTear, familiarStats, rng)

    familiarTear:Update()
end


---@param player EntityPlayer
---@param familiar EntityFamiliar
---@param familiarStats MonsterManualStats
local function OnInfestedFamiliarUpdate(player, familiar, familiarStats)
    local currentFrame = Game():GetFrameCount()
    local room = Game():GetRoom()

    if currentFrame % 4 == 0 then
        TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.PLAYER_CREEP_WHITE,
            0,
            familiar.Position,
            Vector.Zero,
            familiar
        )
    end

    if currentFrame % 10 == 0 and not room:IsClear() then
        local rng = familiar:GetDropRNG()

        local baseChance = 10 + familiarStats.Luck * 5
        if rng:RandomInt(100) < baseChance then
            local angle = rng:RandomInt(360)
            local length = TSIL.Random.GetRandomFloat(20, 70, rng)

            local target = familiar.Position + Vector.FromAngle(angle):Resized(length)

            player:ThrowBlueSpider(familiar.Position, target)
        end
    end
end


---@param familiar EntityFamiliar
---@return EntityNPC?
local function GetClosestEnemy(familiar)
    local npcs = TSIL.EntitySpecific.GetNPCs()

    ---@type EntityNPC?
    local closestEnemy
    ---@type number
    local closestEnemyDistance = math.maxinteger

    TSIL.Utils.Tables.ForEach(npcs, function (_, npc)
        if npc:IsVulnerableEnemy() and npc:IsActiveEnemy(false) and not
        npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_FRIENDLY_BALL) then
            local distance = npc.Position:DistanceSquared(familiar.Position)

            if distance <= closestEnemyDistance then
                closestEnemyDistance = distance
                closestEnemy = npc
            end
        end
    end)

    return closestEnemy
end


---@param familiar EntityFamiliar
---@param player EntityPlayer
---@param familiarStats MonsterManualStats
local function UpdateShootingFamiliar(familiar, player, familiarStats)
    local shootAnimFrames = TSIL.Entities.GetEntityData(
        ImprovedMonsterManualMod,
        familiar,
        "ShootAnimFrames"
    )
    if not shootAnimFrames then shootAnimFrames = 0 end
    local fireDir = player:GetFireDirection()
    if TSIL.Pause.IsPaused() then
        fireDir = Direction.NO_DIRECTION
    end
    local fireVector = TSIL.Direction.DirectionToVector(fireDir)
    local sprite = familiar:GetSprite()

    if familiar.FireCooldown > 0 then
        familiar.FireCooldown = familiar.FireCooldown - 1
    end

    if fireDir ~= Direction.NO_DIRECTION then
        if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.AIMBOT) then
            local closestEnemy = GetClosestEnemy(familiar)

            if closestEnemy then
                fireVector = (closestEnemy.Position - familiar.Position):Normalized()
                fireDir = TSIL.Direction.AngleToDirection(fireVector:GetAngleDegrees())
            end
        end

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

            sprite:SetAnimation(Constants.SHOOT_ANIM_PER_DIRECTION[fireDir], false)
            shootAnimFrames = 16

            if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.TRIPLE_SHOT) then
                fireVector = fireVector:Rotated(-15)
                for _ = 1, 3, 1 do
                    ShootFamiliarTear(familiar, familiarStats, fireVector)
                    fireVector = fireVector:Rotated(15)
                end
            elseif TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.BOOKWORM) then
                local rng = familiar:GetDropRNG()

                local baseChance = 25 + familiarStats.Luck * 5
                if rng:RandomInt(100) < baseChance then
                    local offset1 = fireVector:Rotated(90):Resized(10)
                    local offset2 = fireVector:Rotated(-90):Resized(10)

                    ShootFamiliarTear(familiar, familiarStats, fireVector, offset1)
                    ShootFamiliarTear(familiar, familiarStats, fireVector, offset2)
                else
                    ShootFamiliarTear(familiar, familiarStats, fireVector)
                end
            else
                ShootFamiliarTear(familiar, familiarStats, fireVector)
            end
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


---@param familiar EntityFamiliar
---@param player EntityPlayer
---@param familiarStats MonsterManualStats
local function UpdateBrimstoneFamiliar(familiar, player, familiarStats)
    ---@type integer
    local chargeFrames = TSIL.Entities.GetEntityData(
        ImprovedMonsterManualMod,
        familiar,
        "ChargeFrames"
    )
    ---@type integer
    local shootAnimFrames = TSIL.Entities.GetEntityData(
        ImprovedMonsterManualMod,
        familiar,
        "ShootAnimFrames"
    )
    if not chargeFrames then chargeFrames = 0 end
    if not shootAnimFrames then shootAnimFrames = 0 end

    local maxChargeFrame = familiarStats.FireRate
    if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
        maxChargeFrame = maxChargeFrame / 2
    end

    if shootAnimFrames > 0 then
        ChargeBar:SetCharge(familiar, 0, maxChargeFrame)
        shootAnimFrames = shootAnimFrames - 1

        TSIL.Entities.SetEntityData(
            ImprovedMonsterManualMod,
            familiar,
            "ShootAnimFrames",
            shootAnimFrames
        )
        return
    end

    local fireDir = player:GetFireDirection()
    if TSIL.Pause.IsPaused() then
        fireDir = Direction.NO_DIRECTION
    end
    local sprite = familiar:GetSprite()

    if fireDir == Direction.NO_DIRECTION then
        --If fully charged, shoot in the direction, if not just play float anim
        if chargeFrames == maxChargeFrame then
            --We need to get the direction from the last animation, since in this frame
            --we're no longer pressing anything

            ---@type number
            local fireAngle

            if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.AIMBOT) then
                local closestEnemy = GetClosestEnemy(familiar)

                if closestEnemy then
                    fireAngle = (familiar.Position - closestEnemy.Position):GetAngleDegrees()
                    fireDir = TSIL.Direction.AngleToDirection(fireAngle)
                end
            end

            if fireAngle == nil then
                local currentAnim = sprite:GetAnimation()
                for direction, anim in pairs(Constants.CHARGE_ANIM_PER_DIRECTION) do
                    if anim == currentAnim then
                        fireDir = direction
                    end
                end
                fireAngle = TSIL.Direction.DirectionToDegrees(fireDir)
            end

            familiar.Color = Color(1, 1, 1, 1)

            local shootAnim = Constants.SHOOT_ANIM_PER_DIRECTION[fireDir]
            sprite:Play(shootAnim)

            TSIL.Entities.SetEntityData(
                ImprovedMonsterManualMod,
                familiar,
                "ShootAnimFrames",
                Constants.FAMILIAR_BRIMSTONE_DURATION + 10
            )

            local laserOffset = Constants.LASER_OFFSET_PER_DIRECTION[fireDir]
            local laserVariant = LaserVariant.THICK_RED
            if TSIL.Utils.Flags.HasFlags(familiarStats.TearEffects, Constants.TearEffects.TECHNOLOGY) then
                laserVariant = LaserVariant.BRIM_TECH
            end

            local laser = EntityLaser.ShootAngle(
                laserVariant,
                familiar.Position,
                fireAngle,
                Constants.FAMILIAR_BRIMSTONE_DURATION,
                Vector(laserOffset.X * familiar.SpriteScale.X, laserOffset.Y * familiar.SpriteScale.Y),
                familiar
            )
            if fireDir ~= Direction.UP then
                laser.DepthOffset = 10
            end

            laser.Color = familiarStats.TearColor

            laser.CollisionDamage = familiarStats.Damage
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                laser.CollisionDamage = laser.CollisionDamage * 2
            end

            laser:AddTearFlags(familiarStats.Flags)

            local rng = TSIL.RNG.NewRNG(laser.InitSeed)
            TearEffect.TriggerLaserEffects(familiar, laser, familiarStats, rng)

            laser:Update()
            laser.SpriteScale = Vector(0.4, 0.5)
        else
            local floatAnim = Constants.FLOAT_ANIM_PER_DIRECTION[fireDir]
            if not sprite:IsPlaying(floatAnim) then
                sprite:Play(floatAnim, true)
            end
        end
        chargeFrames = 0
    else
        if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.AIMBOT) then
            local closestEnemy = GetClosestEnemy(familiar)

            if closestEnemy then
                local fireAngle = (familiar.Position - closestEnemy.Position):GetAngleDegrees()
                fireDir = TSIL.Direction.AngleToDirection(fireAngle)
            end
        end

        local chargeAnim = Constants.CHARGE_ANIM_PER_DIRECTION[fireDir]
        sprite:Play(chargeAnim, true)

        if chargeFrames == maxChargeFrame then
            sprite:SetLastFrame()
            if familiar.FrameCount % 6 == 0 then
                familiar.Color = Color(1, 1, 1, 1, 0.2)
            elseif familiar.FrameCount % 3 == 0 then
                familiar.Color = Color(1, 1, 1, 1)
            end
        else
            local currentFrame = math.floor(chargeFrames / maxChargeFrame * Constants.MAX_CHARGE_ANIM_FRAME)
            sprite:SetFrame(currentFrame)

            chargeFrames = chargeFrames + 1
        end
    end

    ChargeBar:SetCharge(familiar, chargeFrames, maxChargeFrame)

    TSIL.Entities.SetEntityData(
        ImprovedMonsterManualMod,
        familiar,
        "ChargeFrames",
        chargeFrames
    )
end


---@param familiar EntityFamiliar
function Familiar:OnFamiliarUpdate(familiar)
    familiar:FollowParent()

    local player = familiar.Player

    ---@type MonsterManualStats
    local familiarStats = Helpers.GetFamiliarStats(familiar)

    if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.TWINS) then
        familiar.SpriteScale = familiar.SpriteScale * 0.75
    end

    if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.INFESTED) then
        OnInfestedFamiliarUpdate(player, familiar, familiarStats)
    end

    if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.BRIMSTONE) then
        UpdateBrimstoneFamiliar(familiar, player, familiarStats)
    else
        UpdateShootingFamiliar(familiar, player, familiarStats)
    end
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
        local familiarStats = Helpers.GetFamiliarStats(familiar)

        ItemDrop.TriggerDrops(familiar, familiarStats)
    end)
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    Familiar.OnRoomClear
)


---@param familiar EntityFamiliar
---@param entity Entity
function Familiar:OnFamiliarCollision(familiar, entity)
    local projectile = entity:ToProjectile()
    if not projectile then return end
    if projectile:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then return end

    local familiarStats = Helpers.GetFamiliarStats(familiar)

    if TSIL.Utils.Flags.HasFlags(familiarStats.SpecialEffects, Constants.SpecialEffects.DRIED) then
        local rng = familiar:GetDropRNG()

        local baseChance = 10 + familiarStats.Luck * 5
        if rng:RandomInt(100) < baseChance then
            projectile.Velocity = projectile.Velocity:Rotated(180)
            projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
        else
            projectile:Kill()
        end
    end
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
    Familiar.OnFamiliarCollision,
    Constants.FamiliarVariant.MONSTER_MANUAL_FAMILIAR
)
