ImprovedMonsterManualMod = RegisterMod("ImprovedMonsterManualMod", 1)

local myFolder = "monster_manual_loi"
local LOCAL_TSIL = require(myFolder .. ".TSIL")
LOCAL_TSIL.Init(myFolder)

local Constants = require("monster_manual_scripts.Constants")

------------------------------------------------
---- DECLARING CLASSES -------------------------
------------------------------------------------

---@class MonsterManualStats
---@field Sprite string
---@field Damage number
---@field FireRate integer
---@field ShotSpeed number
---@field FallingSpeed number
---@field FallingAccel number
---@field Luck integer
---@field Flags BitSet128
---@field ItemDrops integer
---@field TearEffects integer
---@field TearVariant TearVariant
---@field SpecialEffects integer
---@field TearColor Color

---@class MonsterManualInfo
---@field NumGreenUpgrades integer
---@field NumBlueUpgrades integer
---@field NumYellowUpgrades integer
---@field UpgradesChosen string[]

---@class FamiliarUpgrade
---@field sprite string
---@field onActivate fun(familiar: EntityFamiliar, stats: MonsterManualStats)

---@class UsingMonsterManualData
---@field upgrades FamiliarUpgrade[]
---@field currentlySelected integer
---@field frameUsed integer

---@class ItemDropData
---@field itemDrop ItemDrops
---@field roomCount integer
---@field onDrop fun(familiar: EntityFamiliar, stats: MonsterManualStats)

---@class TearEffectData
---@field tearEffect TearEffects
---@field onTear fun(familiar: EntityFamiliar, tear: EntityTear, stats: MonsterManualStats)
---@field onLaser fun(familiar: EntityFamiliar, laser: EntityLaser, stats: MonsterManualStats)


------------------------------------------------
---- DECLARING PERSISTENT VARIABLES ------------
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
---- BASE FAMILIARS ----------------------------
------------------------------------------------
require("monster_manual_scripts.BaseFamiliars.BookwormFamiliar")
require("monster_manual_scripts.BaseFamiliars.CrossFamiliar")
require("monster_manual_scripts.BaseFamiliars.KeeperFamiliar")
require("monster_manual_scripts.BaseFamiliars.PlanetFamiliar")
require("monster_manual_scripts.BaseFamiliars.SkeletonFamiliar")
require("monster_manual_scripts.BaseFamiliars.ThiefFamiliar")
require("monster_manual_scripts.BaseFamiliars.ZombieFamiliar")

------------------------------------------------
---- ITEM DROPS --------------------------------
------------------------------------------------
require("monster_manual_scripts.ItemDrops.BatteriesDrop")
require("monster_manual_scripts.ItemDrops.CurseDrop")
require("monster_manual_scripts.ItemDrops.PillDrop")
require("monster_manual_scripts.ItemDrops.RandomBombDrop")
require("monster_manual_scripts.ItemDrops.RandomBoneHeart")
require("monster_manual_scripts.ItemDrops.RandomCardDrop")
require("monster_manual_scripts.ItemDrops.RandomKeyDrop")
require("monster_manual_scripts.ItemDrops.RedHeartDrop")
require("monster_manual_scripts.ItemDrops.RuneDrop")


------------------------------------------------
---- TEAR EFFECTS ------------------------------
------------------------------------------------
require("monster_manual_scripts.TearEffects.BurningEffect")
require("monster_manual_scripts.TearEffects.CharmingEffect")
require("monster_manual_scripts.TearEffects.CriticalEffect")
require("monster_manual_scripts.TearEffects.FearEffect")
require("monster_manual_scripts.TearEffects.FreezerEffect")
require("monster_manual_scripts.TearEffects.HolyLightEffect")
require("monster_manual_scripts.TearEffects.PoisonEffect")


------------------------------------------------
---- UPGRADE SCRIPTS ---------------------------
------------------------------------------------
require("monster_manual_scripts.Upgrades.AimbotUpgrade")
require("monster_manual_scripts.Upgrades.BobWasHereUpgrade")
require("monster_manual_scripts.Upgrades.BrainWormUpgrade")
require("monster_manual_scripts.Upgrades.BurningTearsUpgrade")
require("monster_manual_scripts.Upgrades.CharmingTearsUpgrade")
require("monster_manual_scripts.Upgrades.CriticalTearUpgrade")
require("monster_manual_scripts.Upgrades.CrystalBallUpgrade")
require("monster_manual_scripts.Upgrades.DamageUpgrade")
require("monster_manual_scripts.Upgrades.DriedUpUpgrade")
require("monster_manual_scripts.Upgrades.EatFiveBatteriesUpgrade")
require("monster_manual_scripts.Upgrades.FearTearsUpgrade")
require("monster_manual_scripts.Upgrades.FireRateUpgrade")
require("monster_manual_scripts.Upgrades.FreezerTearsUpgrade")
require("monster_manual_scripts.Upgrades.HolyLightTearsUpgrade")
require("monster_manual_scripts.Upgrades.HookWormUpgrade")
require("monster_manual_scripts.Upgrades.KetamineBabyUpgrade")
require("monster_manual_scripts.Upgrades.KissesUpgrade")
require("monster_manual_scripts.Upgrades.LazyWormUpgrade")
require("monster_manual_scripts.Upgrades.LuckUpgrade")
require("monster_manual_scripts.Upgrades.MonocularUpgrade")
require("monster_manual_scripts.Upgrades.PoisonTearsUpgrade")
require("monster_manual_scripts.Upgrades.PulseWormUpgrade")
require("monster_manual_scripts.Upgrades.RingWormUpgrade")
require("monster_manual_scripts.Upgrades.ShotSpeedUpgrade")
require("monster_manual_scripts.Upgrades.SoyBeansUpgrade")
require("monster_manual_scripts.Upgrades.TwinsUpgrade")
require("monster_manual_scripts.Upgrades.WiggleWormUpgrade")