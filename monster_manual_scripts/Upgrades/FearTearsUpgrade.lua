local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")
local Constants = require("monster_manual_scripts.Constants")

FamiliarUpgrade.NewYellowFamiliarUpgrade(
    "feartears",
    function (_, stats)
        stats.TearEffects = TSIL.Utils.Flags.AddFlags(
            stats.TearEffects,
            Constants.TearEffects.FEAR
        )
    end
)