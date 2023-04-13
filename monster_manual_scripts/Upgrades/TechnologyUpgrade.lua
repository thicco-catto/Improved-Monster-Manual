local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")
local Constants       = require("monster_manual_scripts.Constants")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "tech",
    true,
    function (_, stats)
        stats.TearEffects = stats.TearEffects | Constants.TearEffects.TECHNOLOGY
    end
)