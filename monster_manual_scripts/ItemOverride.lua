local ItemOverride = {}

local Constants = require("monster_manual_scripts.Constants")
local Helpers = require("monster_manual_scripts.Helpers")
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
    local monsterManualInfo = monsterManualInfoPerPlayer[tostring(playerIndex)]

    local upgrades = FamiliarUpgrade.GetRandomUpgrades(rng, monsterManualInfo)

    local layer = 2
    TSIL.Utils.Tables.ForEach(upgrades, function (_, upgrade)
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
        TSIL.Pause.Pause()

        player:AnimateCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, "LiftItem", "PlayerPickup")

        StartUI(player, rng)
    else
        player:AnimateCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL)

        ---@type MonsterManualStats[]
        local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
        )

        familiarStatsPerPlayer[tostring(playerIndex)] = BaseFamiliar.GetBaseStats()

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