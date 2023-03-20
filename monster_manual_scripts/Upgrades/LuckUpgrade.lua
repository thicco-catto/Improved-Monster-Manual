local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "luckup",
    function (_, stats)
        stats.Luck = stats.Luck + 1
    end
)