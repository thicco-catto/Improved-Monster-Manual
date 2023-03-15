local FamiliarUpgrade = {}

local Constants = require("monster_manual_scripts.Constants")


---@type FamiliarUpgrade[]
local RepeatableFamiliarUpgrades = {}

---@type FamiliarUpgrade[]
local YellowFamiliarUpgrades = {}
---@type FamiliarUpgrade[]
local BlueFamiliarUpgrades = {}


---@param upgrades FamiliarUpgrade[]
---@param sprite string
---@param onActivate fun(stats: MonsterManualStats)
local function AddUpgradeToTable(upgrades, sprite, onActivate)
    ---@type FamiliarUpgrade
    local newUpgrade = {
        sprite = "gfx/ui/upgrades/" .. sprite .. ".png",
        onActivate = onActivate
    }
    upgrades[#upgrades+1] = newUpgrade
end


---@param sprite string
---@param onActivate fun(stats: MonsterManualStats)
function FamiliarUpgrade.NewYellowFamiliarUpgrade(sprite, onActivate)
    AddUpgradeToTable(YellowFamiliarUpgrades, sprite, onActivate)
end


---@param sprite string
---@param onActivate fun(stats: MonsterManualStats)
function FamiliarUpgrade.NewBlueFamiliarUpgrade(sprite, onActivate)
    AddUpgradeToTable(BlueFamiliarUpgrades, sprite, onActivate)
end


---@param sprite string
---@param onActivate fun(stats: MonsterManualStats)
function FamiliarUpgrade.NewRepeatableFamiliarUpgrade(sprite, onActivate)
    AddUpgradeToTable(RepeatableFamiliarUpgrades, sprite, onActivate)
end


---@param rng RNG
---@param monsterManualInfo MonsterManualInfo
---@return FamiliarUpgrade[]
function FamiliarUpgrade.GetRandomUpgrades(rng, monsterManualInfo)
    ---@type FamiliarUpgrade[]
    local possibleUpgrades = {}

    if monsterManualInfo.NumGreenUpgrades < Constants.MAX_GREEN_UPGRADES then
        TSIL.Utils.Tables.ForEach(RepeatableFamiliarUpgrades, function (_, upgrade)
            possibleUpgrades[#possibleUpgrades+1] = upgrade
        end)
    end

    if monsterManualInfo.NumBlueUpgrades < Constants.MAX_BLUE_UPGRADES then
        TSIL.Utils.Tables.ForEach(BlueFamiliarUpgrades, function (_, upgrade)
            if TSIL.Utils.Tables.IsIn(monsterManualInfo.UpgradesChosen, upgrade.sprite) then
                return
            end

            possibleUpgrades[#possibleUpgrades+1] = upgrade
        end)
    end

    if monsterManualInfo.NumYellowUpgrades < Constants.MAX_YELLOW_UPGRADES then
        TSIL.Utils.Tables.ForEach(YellowFamiliarUpgrades, function (_, upgrade)
            if TSIL.Utils.Tables.IsIn(monsterManualInfo.UpgradesChosen, upgrade.sprite) then
                return
            end

            possibleUpgrades[#possibleUpgrades+1] = upgrade
        end)
    end

    ---@type FamiliarUpgrade
    local chosenUpgrades = {}

    if monsterManualInfo.NumGreenUpgrades < Constants.MAX_GREEN_UPGRADES then
        local mandatoryUpgrade = TSIL.Random.GetRandomElementsFromTable(
            RepeatableFamiliarUpgrades,
            1,
            rng
        )[1]

        for index, upgrade in ipairs(possibleUpgrades) do
            if upgrade.sprite == mandatoryUpgrade.sprite then
                table.remove(possibleUpgrades, index)
                break
            end
        end

        local randomUpgrades = TSIL.Random.GetRandomElementsFromTable(
            possibleUpgrades,
            2,
            rng
        )

        chosenUpgrades[#chosenUpgrades+1] = mandatoryUpgrade

        TSIL.Utils.Tables.ForEach(randomUpgrades, function (_, upgrade)
            chosenUpgrades[#chosenUpgrades+1] = upgrade
        end)
    else
        chosenUpgrades = TSIL.Random.GetRandomElementsFromTable(
            possibleUpgrades,
            3,
            rng
        )
    end

    return chosenUpgrades
end


---@param upgradeToCheck FamiliarUpgrade
function FamiliarUpgrade.IsUpgradeGreen(upgradeToCheck)
    local found = TSIL.Utils.Tables.FindFirst(RepeatableFamiliarUpgrades, function (_, upgrade)
        return upgrade.sprite == upgradeToCheck.sprite
    end)

    return found ~= nil
end


---@param upgradeToCheck FamiliarUpgrade
function FamiliarUpgrade.IsUpgradeBlue(upgradeToCheck)
    local found = TSIL.Utils.Tables.FindFirst(BlueFamiliarUpgrades, function (_, upgrade)
        return upgrade.sprite == upgradeToCheck.sprite
    end)

    return found ~= nil
end


---@param upgradeToCheck FamiliarUpgrade
function FamiliarUpgrade.IsUpgradeYellow(upgradeToCheck)
    local found = TSIL.Utils.Tables.FindFirst(YellowFamiliarUpgrades, function (_, upgrade)
        return upgrade.sprite == upgradeToCheck.sprite
    end)

    return found ~= nil
end


return FamiliarUpgrade