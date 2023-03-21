local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")
local Constants = require("monster_manual_scripts.Constants")


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_LIBRARY,
    {
        Sprite = "bookworm_baby",
        Damage = 1,
        FireRate = 20,
        Flags = TearFlags.TEAR_NORMAL,
        ItemDrops = Constants.ItemDrops.RANDOM_KEY,
        Luck = 0,
        ShotSpeed = 1,
        TearEffects = 0,
        TearVariant = TearVariant.BLUE,
        SpecialEffects = Constants.SpecialEffects.BOOKWORM,
        FallingAccel = 0,
        FallingSpeed = 0,
        TearColor = Color(0, 0, 0)
    }
)