local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")
local Constants = require("monster_manual_scripts.Constants")


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_TREASURE,
    {
        Sprite = "thief_baby",
        Damage = 1,
        FireRate = 20,
        Flags = TearFlags.TEAR_COIN_DROP,
        ItemDrops = Constants.ItemDrops.RANDOM_BOMB,
        Luck = 0,
        ShotSpeed = 1,
        TearEffects = 0,
        TearVariant = TearVariant.COIN
    }
)