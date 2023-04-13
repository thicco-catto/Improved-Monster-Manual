local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "wiggleworm",
    false,
    function (_, stats)
        ---@diagnostic disable-next-line: param-type-mismatch, assign-type-mismatch
        stats.Flags = TSIL.Utils.Flags.AddFlags(stats.Flags, TearFlags.TEAR_WIGGLE)
    end
)