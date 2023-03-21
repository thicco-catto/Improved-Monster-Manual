local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")
local Constants = require("monster_manual_scripts.Constants")


---@type MonsterManualStats
local skeletonStats = {
    Sprite = "skeleton_baby",
    Damage = 1,
    FireRate = 20,
    Flags = TearFlags.TEAR_BONE,
    ItemDrops = Constants.ItemDrops.RANDOM_BONE_HEART,
    Luck = 0,
    ShotSpeed = 1,
    TearEffects = 0,
    TearVariant = TearVariant.BONE,
    SpecialEffects = 0,
    FallingAccel = 0,
    FallingSpeed = 0,
    TearColor = Color(0, 0, 0)
}


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_SECRET,
    skeletonStats
)


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_SUPERSECRET,
    skeletonStats
)


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_ULTRASECRET,
    skeletonStats
)