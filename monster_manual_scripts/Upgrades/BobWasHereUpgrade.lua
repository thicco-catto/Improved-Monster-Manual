local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "bobwashere",
    function (_, stats)
        ---@diagnostic disable-next-line: param-type-mismatch, assign-type-mismatch
        stats.Flags = TSIL.Utils.Flags.AddFlags(stats.Flags, TearFlags.TEAR_EXPLOSIVE, TearFlags.TEAR_POISON)
        stats.FallingSpeed = stats.FallingSpeed -14
        stats.FallingAccel = stats.FallingAccel + 0.5
        stats.FireRate = stats.FireRate + 7
        stats.TearColor = Color(0.5, 0.9, 0.4)
    end
)