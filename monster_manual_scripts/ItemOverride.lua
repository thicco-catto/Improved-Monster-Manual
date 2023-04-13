local ItemOverride    = {}

local Constants       = require("monster_manual_scripts.Constants")
local Helpers         = require("monster_manual_scripts.Helpers")
local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")
local BaseFamiliar    = require("monster_manual_scripts.BaseFamiliar")


---@param player EntityPlayer
---@param rng RNG
local function StartUI(player, rng)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    ---@type MonsterManualInfo[]
    local monsterManualInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_MONSTER_MANUAL_INFO
    )
    local monsterManualInfo = monsterManualInfoPerPlayer[playerIndex]

    local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
    )
    local familiarStats = familiarStatsPerPlayer[playerIndex]

    local upgrades = FamiliarUpgrade.GetRandomUpgrades(rng, monsterManualInfo, familiarStats)

    if #upgrades == 0 then
        return false
    end

    local layer = 2
    TSIL.Utils.Tables.ForEach(upgrades, function(_, upgrade)
        Constants.STATS_UI_SPRITE:ReplaceSpritesheet(layer, "gfx/ui/upgrades/" .. upgrade.sprite .. ".png")
        layer = layer + 1
        Constants.STATS_UI_SPRITE:ReplaceSpritesheet(layer, "gfx/ui/upgrades/" .. upgrade.sprite .. "_glow.png")
        layer = layer + 1
    end)

    Constants.STATS_UI_SPRITE:LoadGraphics()

    ---@type UsingMonsterManualData
    local usingMonsterManualData = {
        currentlySelected = 2,
        upgrades = upgrades,
        frameUsed = Game():GetFrameCount()
    }

    Helpers.SetTemporaryPlayerData(
        player,
        "UsingMonsterManualData",
        usingMonsterManualData
    )

    return true
end


---@param player EntityPlayer
---@param activeSlot ActiveSlot
local function ExplodeBook(player, activeSlot)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
    )
    ---@type MonsterManualStats
    local familiarStats = familiarStatsPerPlayer[playerIndex]

    local permanentFamiliars = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PERMANENT_FAMILIAR_STATS
    )

    local familiars = Helpers.GetAllNonPermanentFamiliars(player)

    TSIL.Utils.Tables.ForEach(familiars, function(_, familiar)
        permanentFamiliars[familiar.InitSeed] = TSIL.Utils.DeepCopy.DeepCopy(familiarStats,
        TSIL.Enums.SerializationType.NONE)
    end)

    local numPersistentFamiliarsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.NUM_PERMANENT_FAMILIARS_PER_PLAYER
    )
    local currentNum = numPersistentFamiliarsPerPlayer[playerIndex]
    if currentNum == nil then currentNum = 0 end
    currentNum = currentNum + #familiars
    numPersistentFamiliarsPerPlayer[playerIndex] = currentNum

    familiarStatsPerPlayer[playerIndex] = nil

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

    player:RemoveCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, false, activeSlot, false)

    player:AnimateCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL)

    local rng = TSIL.RNG.NewRNG()

    TSIL.Utils.Functions.RunInFrames(function()
        SFXManager():Play(SoundEffect.SOUND_PAPER_IN)
        local numBloodParticles = TSIL.Random.GetRandomInt(15, 30, rng)

        for _ = 1, numBloodParticles, 1 do
            local speed = TSIL.Random.GetRandomFloat(4, 6, rng)
            local angle = TSIL.Random.GetRandomInt(0, 360, rng)

            local velocity = Vector.FromAngle(angle):Resized(speed)

            local particle = TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.TOOTH_PARTICLE,
                0,
                player.Position + Vector(0, -40),
                velocity
            )

            local sprite = particle:GetSprite()
            sprite:ReplaceSpritesheet(0, "gfx/effects/monster_manual_paper_particle.png")
            sprite:LoadGraphics()
        end
    end, 10)
end


---@param player EntityPlayer
function ItemOverride:PreMonsterManualUse(_, rng, player, _, activeSlot)
    SFXManager():Play(SoundEffect.SOUND_SATAN_GROW)

    local playersUsedMonsterManual = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_USED_MONSTER_MANUAL
    )
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local hasUsedMonsterManual = playersUsedMonsterManual[playerIndex]

    if hasUsedMonsterManual then
        local foundUpgrades = StartUI(player, rng)

        if not foundUpgrades then
            ExplodeBook(player, activeSlot)
        else
            TSIL.Pause.Pause()

            player:AnimateCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, "LiftItem", "PlayerPickup")
        end
    else
        player:AnimateCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL)

        ---@type MonsterManualStats[]
        local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
        )

        familiarStatsPerPlayer[playerIndex] = BaseFamiliar.GetBaseStats()

        ---@type MonsterManualInfo[]
        local monsterManualInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_MONSTER_MANUAL_INFO
        )

        monsterManualInfoPerPlayer[playerIndex] = {
            NumBlueUpgrades = 0,
            NumGreenUpgrades = 0,
            NumYellowUpgrades = 0,
            UpgradesChosen = {},
        }

        playersUsedMonsterManual[playerIndex] = true
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
        player:EvaluateItems()
    end

    return true
end

ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_PRE_USE_ITEM,
    ItemOverride.PreMonsterManualUse,
    CollectibleType.COLLECTIBLE_MONSTER_MANUAL
)
