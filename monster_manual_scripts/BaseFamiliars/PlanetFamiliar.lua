local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_PLANETARIUM,
    {
        Sprite = "planet_baby",
        Damage = 1,
        FireRate = 20,
        Flags = TearFlags.TEAR_ORBIT | TearFlags.TEAR_ROCK,
        ItemDrops = 0,
        Luck = 0,
        ShotSpeed = 1,
        TearEffects = 0,
        TearVariant = TearVariant.ROCK
    }
)