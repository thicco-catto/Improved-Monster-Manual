local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_ANGEL,
    {
        Sprite = "cross_baby",
        Damage = 1,
        FireRate = 20,
        Flags = TearFlags.TEAR_LASERSHOT,
        ItemDrops = 0,
        Luck = 0,
        ShotSpeed = 1,
        TearEffects = 0,
        TearVariant = TearVariant.BLUE,
        SpecialEffects = 0,
        FallingAccel = 0,
        FallingSpeed = 0,
        TearColor = Color(0, 0, 0)
    }
)