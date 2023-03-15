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
---@field ItemDrops integer

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

---@class ItemDropData
---@field itemDrop ItemDrops
---@field roomCount integer
---@field onDrop fun(familiar: EntityFamiliar)


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
---- ITEM DROPS --------------------------------
------------------------------------------------
require("monster_manual_scripts.ItemDrops.BatteriesDrop")
require("monster_manual_scripts.ItemDrops.PillDrop")
require("monster_manual_scripts.ItemDrops.RedHeartDrop")
require("monster_manual_scripts.ItemDrops.RuneDrop")


------------------------------------------------
---- UPGRADE SCRIPTS ---------------------------
------------------------------------------------
require("monster_manual_scripts.Upgrades.BrainWormUpgrade")
require("monster_manual_scripts.Upgrades.CrystalBallUpgrade")
require("monster_manual_scripts.Upgrades.DamageUpgrade")
require("monster_manual_scripts.Upgrades.EatFiveBatteriesUpgrade")
require("monster_manual_scripts.Upgrades.FireRateUpgrade")
require("monster_manual_scripts.Upgrades.HookWormUpgrade")
require("monster_manual_scripts.Upgrades.KetamineBabyUpgrade")
require("monster_manual_scripts.Upgrades.KissesUpgrade")
require("monster_manual_scripts.Upgrades.LazyWormUpgrade")
require("monster_manual_scripts.Upgrades.LuckUpgrade")
require("monster_manual_scripts.Upgrades.MonocularUpgrade")
require("monster_manual_scripts.Upgrades.PulseWormUpgrade")
require("monster_manual_scripts.Upgrades.RingWormUpgrade")
require("monster_manual_scripts.Upgrades.ShotSpeedUpgrade")
require("monster_manual_scripts.Upgrades.SoyBeansUpgrade")
require("monster_manual_scripts.Upgrades.WiggleWormUpgrade")