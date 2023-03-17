local ItemDrop = require("monster_manual_scripts.ItemDrop")
local Constants = require("monster_manual_scripts.Constants")

ItemDrop.AddItemDrop(
    Constants.ItemDrops.RANDOM_BOMB,
    1,
    function (familiar, stats)
        local rng = familiar:GetDropRNG()

        local chance = 10 + stats.Luck * 5

        if rng:RandomInt(100) >= chance then return end

        local room = Game():GetRoom()
        local spawningPos = room:FindFreePickupSpawnPosition(familiar.Position)

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_BOMB,
            0,
            spawningPos
        )
    end
)