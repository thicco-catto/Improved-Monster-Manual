local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")
local Constants = require("monster_manual_scripts.Constants")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "electricdischarge",
    function (stats)
        stats.ItemDrops = TSIL.Utils.Flags.AddFlags(
            stats.ItemDrops,
            Constants.ItemDrops.BATTERY
        )
    end
)