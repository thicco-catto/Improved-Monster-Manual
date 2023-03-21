local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")
local Constants = require("monster_manual_scripts.Constants")


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_CURSE,
    {
        Sprite = "zombie_baby",
        Damage = 1,
        FireRate = 20,
        Flags = TearFlags.TEAR_NORMAL,
        ItemDrops = Constants.ItemDrops.CURSE,
        Luck = 0,
        ShotSpeed = 1,
        TearEffects = 0,
        TearVariant = TearVariant.EYE,
        SpecialEffects = 0,
        FallingAccel = 0,
        FallingSpeed = 0,
        TearColor = Color(0, 0, 0)
    }
)