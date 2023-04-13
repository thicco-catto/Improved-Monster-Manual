local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")
local Constants       = require("monster_manual_scripts.Constants")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "driedup",
    true,
    function(_, stats)
        stats.SpecialEffects = TSIL.Utils.Flags.AddFlags(
            stats.SpecialEffects,
            Constants.SpecialEffects.DRIED
        )
    end
)