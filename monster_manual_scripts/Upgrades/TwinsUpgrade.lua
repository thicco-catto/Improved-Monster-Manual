local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")
local Constants       = require("monster_manual_scripts.Constants")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "twins",
    function(familiar, stats)
        stats.Damage = stats.Damage * 0.75
        stats.FireRate = math.floor(stats.FireRate * 1.25)

        stats.SpecialEffects = TSIL.Utils.Flags.AddFlags(
            stats.SpecialEffects,
            Constants.SpecialEffects.TWINS
        )

        local player = familiar.Player
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
        player:EvaluateItems()
    end
)
