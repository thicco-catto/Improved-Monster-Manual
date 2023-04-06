local BaseFamiliar = require("monster_manual_scripts.BaseFamiliar")
local Constants    = require("monster_manual_scripts.Constants")


BaseFamiliar.AddBaseFamiliar(
    RoomType.ROOM_DEVIL,
    {
        Sprite = "devil_baby",
        Damage = 1,
        FireRate = 40,
        Flags = TearFlags.TEAR_NORMAL,
        ItemDrops = 0,
        Luck = 0,
        ShotSpeed = 1,
        TearEffects = 0,
        TearVariant = TearVariant.BLUE,
        SpecialEffects = Constants.SpecialEffects.BRIMSTONE,
        FallingAccel = 0,
        FallingSpeed = 0,
        TearColor = Color(1, 0, 0)
    }
)