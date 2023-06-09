local StatsUI = {}

local Constants = require("monster_manual_scripts.Constants")
local Helpers = require("monster_manual_scripts.Helpers")
local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")


---@param player EntityPlayer
---@param data UsingMonsterManualData
local function CheckPlayerChoosing(player, data)
    local controller = player.ControllerIndex

    if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, controller) then
        local playerIndex = TSIL.Players.GetPlayerIndex(player)

        local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
        )

        ---@type MonsterManualStats
        local familiarStats = familiarStatsPerPlayer[playerIndex]

        local playerFamiliars = TSIL.Familiars.GetPlayerFamiliars(player)

        local monsterManualFamiliars = TSIL.Utils.Tables.FindFirst(playerFamiliars, function (_, familiar)
            return familiar.Variant == Constants.FamiliarVariant.MONSTER_MANUAL_FAMILIAR
        end)

        local upgrade = data.upgrades[data.currentlySelected]

        upgrade.onActivate(monsterManualFamiliars, familiarStats)

        ---@type MonsterManualInfo[]
        local monsterManualInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_MONSTER_MANUAL_INFO
        )
        local monsterManualInfo = monsterManualInfoPerPlayer[playerIndex]

        monsterManualInfo.UpgradesChosen[#monsterManualInfo.UpgradesChosen+1] = upgrade.sprite

        if FamiliarUpgrade.IsUpgradeGreen(upgrade) then
            monsterManualInfo.NumGreenUpgrades = monsterManualInfo.NumGreenUpgrades + 1
        end

        if FamiliarUpgrade.IsUpgradeBlue(upgrade) then
            monsterManualInfo.NumBlueUpgrades = monsterManualInfo.NumBlueUpgrades + 1
        end

        if FamiliarUpgrade.IsUpgradeYellow(upgrade) then
            monsterManualInfo.NumYellowUpgrades = monsterManualInfo.NumYellowUpgrades + 1
        end

        return true
    end

    return false
end


---@param player EntityPlayer
---@param data UsingMonsterManualData
local function CheckPlayerMovingArrow(player, data)
    local controller = player.ControllerIndex

    if Input.IsActionTriggered(ButtonAction.ACTION_RIGHT, controller) or
    Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, controller) then
        SFXManager():Play(SoundEffect.SOUND_MENU_SCROLL)
        data.currentlySelected = data.currentlySelected + 1
        if data.currentlySelected > 3 then data.currentlySelected = 1 end
    elseif Input.IsActionTriggered(ButtonAction.ACTION_LEFT, controller) or
    Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, controller) then
        SFXManager():Play(SoundEffect.SOUND_MENU_SCROLL)
        data.currentlySelected = data.currentlySelected - 1
        if data.currentlySelected < 1 then data.currentlySelected = 3 end
    end
end


---@param _ EntityPlayer
---@param data UsingMonsterManualData
local function RenderUpgrades(_, data)
    local yPos = Isaac.GetScreenHeight() / 2
    local xPos = Isaac.GetScreenWidth() / 2
    local renderPos = Vector(xPos, yPos)

    local anim = "Selected" .. data.currentlySelected
    Constants.STATS_UI_SPRITE:Play(anim, true)

    Constants.STATS_UI_SPRITE:Render(renderPos)

    local coatHangerIndex
    TSIL.Utils.Tables.ForEach(data.upgrades, function (index, upgrade)
        if upgrade.sprite == "coathanger" then
            coatHangerIndex = index
        end
    end)

    if not coatHangerIndex then return end

    local coatHangerAnim = "Unselected"
    if coatHangerIndex == data.currentlySelected then
        coatHangerAnim = "Selected"
    end
    coatHangerAnim = coatHangerAnim .. coatHangerIndex

    Constants.COAT_HANGER_STATS_UI_SPRITE:Play(coatHangerAnim, true)
    Constants.COAT_HANGER_STATS_UI_SPRITE:Render(renderPos)
end


---@param player EntityPlayer
local function OnPlayerRender(player)
    ---@type UsingMonsterManualData?
    local data = Helpers.GetTemporaryPlayerData(
        player,
        "UsingMonsterManualData"
    )

    if not data then return end

    if not Game():IsPaused() then
        local currentFrame = Game():GetFrameCount()
        local frameDiff = currentFrame - data.frameUsed

        if frameDiff > 10 and CheckPlayerChoosing(player, data) then
            player:AnimateCollectible(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, "HideItem", "PlayerPickup")

            Helpers.SetTemporaryPlayerData(
                player,
                "UsingMonsterManualData",
                nil
            )

            TSIL.Pause.Unpause()

            return
        end

        CheckPlayerMovingArrow(player, data)
    end

    RenderUpgrades(player, data)
end


function StatsUI:OnRender()
    local players = TSIL.Players.GetPlayers()
    TSIL.Utils.Tables.ForEach(players, function (_, player)
        OnPlayerRender(player)
    end)
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    StatsUI.OnRender
)
