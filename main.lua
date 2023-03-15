ImprovedMonsterManualMod = RegisterMod("ImprovedMonsterManualMod", 1)

local myFolder = "monster_manual_loi"
local LOCAL_TSIL = require(myFolder .. ".TSIL")
LOCAL_TSIL.Init(myFolder)

local Constants = require("monster_manual_scripts.Constants")

------------------------------------------------
---- DECLARING CLASSES -------------------------
------------------------------------------------

---@class MonsterManualStats
---@field Damage number
---@field FireRate integer
---@field ShotSpeed number
---@field Luck integer
---@field Flags integer

---@class MonsterManualInfo
---@field NumGreenUpgrades integer
---@field NumBlueUpgrades integer
---@field NumYellowUpgrades integer
---@field UpgradesChosen string[]

---@class FamiliarUpgrade
---@field sprite string
---@field onActivate fun(stats: MonsterManualStats)

---@class UsingMonsterManualData
---@field upgrades FamiliarUpgrade[]
---@field sprites Sprite[]
---@field currentlySelected integer
---@field frameUsed integer

------------------------------------------------
---- DECLARING SAVE MANAGER --------------------
------------------------------------------------

TSIL.SaveManager.AddPersistentVariable(
    ImprovedMonsterManualMod,
    Constants.SaveKeys.PLAYERS_USED_MONSTER_MANUAL,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

TSIL.SaveManager.AddPersistentVariable(
    ImprovedMonsterManualMod,
    Constants.SaveKeys.PLAYERS_FAMILIAR_STATS,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

TSIL.SaveManager.AddPersistentVariable(
    ImprovedMonsterManualMod,
    Constants.SaveKeys.PLAYERS_MONSTER_MANUAL_INFO,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

------------------------------------------------
---- MAIN SCRIPTS ------------------------------
------------------------------------------------

require("monster_manual_scripts.Familiar")
require("monster_manual_scripts.ItemOverride")
require("monster_manual_scripts.StatsUI")


------------------------------------------------
---- UPGRADE SCRIPTS ---------------------------
------------------------------------------------
require("monster_manual_scripts.Upgrades.DamageUpgrade")
require("monster_manual_scripts.Upgrades.FireRateUpgrade")
require("monster_manual_scripts.Upgrades.LuckUpgrade")
require("monster_manual_scripts.Upgrades.ShotSpeedUpgrade")