local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")
local Constants = require("monster_manual_scripts.Constants")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "hematemesis",
    true,
    function (_, stats)
        stats.ItemDrops = TSIL.Utils.Flags.AddFlags(
            stats.ItemDrops,
            Constants.ItemDrops.RED_HEART
        )
    end
)