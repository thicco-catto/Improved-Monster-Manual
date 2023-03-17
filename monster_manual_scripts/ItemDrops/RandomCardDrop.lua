local ItemDrop = require("monster_manual_scripts.ItemDrop")
local Constants = require("monster_manual_scripts.Constants")

ItemDrop.AddItemDrop(
    Constants.ItemDrops.RANDOM_CARD,
    1,
    function (familiar, stats)
        local rng = familiar:GetDropRNG()

        local chance = 3 + stats.Luck * 3

        if rng:RandomInt(100) >= chance then return end

        local itemPool = Game():GetItemPool()
        local card = itemPool:GetCard(rng:Next(), true, false, false)

        local room = Game():GetRoom()
        local spawningPos = room:FindFreePickupSpawnPosition(familiar.Position)

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_TAROTCARD,
            card,
            spawningPos
        )
    end
)