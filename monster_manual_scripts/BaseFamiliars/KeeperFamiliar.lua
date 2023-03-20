local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")
local Constants    = require("monster_manual_scripts.Constants")


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_SHOP,
    {
        Sprite = "keeper_baby",
        Damage = 1,
        FireRate = 30,
        Flags = TearFlags.TEAR_COIN_DROP_DEATH,
        ItemDrops = 0,
        Luck = 0,
        ShotSpeed = 1,
        TearEffects = 0,
        TearVariant = TearVariant.BLUE,
        SpecialEffects = Constants.SpecialEffects.TRIPLE_SHOT,
        FallingAccel = 0,
        FallingSpeed = 0
    }
)