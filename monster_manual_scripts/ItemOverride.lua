local ItemOverride = {}

local Constants = require("monster_manual_scripts.Constants")
local Helpers = require("monster_manual_scripts.Helpers")
local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")


---@param player EntityPlayer
---@param rng RNG
local function StartUI(player, rng)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    ---@type MonsterManualInfo[]
    local monsterManualInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_MONSTER_MANUAL_INFO
    )
    local monsterManualInfo = monsterManualInfoPerPlayer[tostring(playerIndex)]

    local upgrades = FamiliarUpgrade.GetRandomUpgrades(rng, monsterManualInfo)

    local upgradeSprites = TSIL.Utils.Tables.Map(upgrades, function (_, upgrade)
        local sprite = Sprite()
        sprite:Load("gfx/ui_element.anm2", false)
        sprite:ReplaceSpritesheet(0, upgrade.sprite)
        sprite:LoadGraphics()
        sprite:Play("Idle", true)
        return sprite
    end)

    ---@type UsingMonsterManualData
    local usingMonsterManualData = {
        currentlySelected = 2,
        sprites = upgradeSprites,
        upgrades = upgrades,
        frameUsed = Game():GetFrameCount()
    }

    Helpers.SetTemporaryPlayerData(
        player,
        "UsingMonsterManualData",
        usingMonsterManualData
    )

    player.ControlsEnabled = false
end


---@param player EntityPlayer
function ItemOverride:PreMonsterManualUse(_, rng, player)
    local playersUsedMonsterManual = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_USED_MONSTER_MANUAL
    )
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local hasUsedMonsterManual = playersUsedMonsterManual[tostring(playerIndex)]

    if hasUsedMonsterManual then
        player:AnimateCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, "LiftItem", "PlayerPickup")

        StartUI(player, rng)
    else
        player:AnimateCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL)

        ---@type MonsterManualStats[]
        local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
        )

        familiarStatsPerPlayer[tostring(playerIndex)] = {
            Damage = 2,
            FireRate = 20,
            Flags = 0,
            ShotSpeed = 1,
            Luck = 0,
            ItemDrops = 0
        }

        ---@type MonsterManualInfo[]
        local monsterManualInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_MONSTER_MANUAL_INFO
        )

        monsterManualInfoPerPlayer[tostring(playerIndex)] = {
            NumBlueUpgrades = 0,
            NumGreenUpgrades = 0,
            NumYellowUpgrades = 0,
            UpgradesChosen = {},
        }

        playersUsedMonsterManual[tostring(playerIndex)] = true
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