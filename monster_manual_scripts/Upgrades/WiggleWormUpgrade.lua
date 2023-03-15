local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "wiggleworm",
    function (stats)
        ---@diagnostic disable-next-line: param-type-mismatch
        stats.Flags = TSIL.Utils.Flags.AddFlags(stats.Flags, TearFlags.TEAR_WIGGLE)
    end
)