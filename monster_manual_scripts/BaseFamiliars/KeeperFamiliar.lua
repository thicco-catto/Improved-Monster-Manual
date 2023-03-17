local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_SHOP,
    {
        Sprite = "keeper_baby",
        Damage = 1,
        FireRate = 20,
        Flags = TearFlags.TEAR_COIN_DROP_DEATH,
        ItemDrops = 0,
        Luck = 0,
        ShotSpeed = 1,
        TearEffects = 0,
        TearVariant = TearVariant.BLUE
    }
)