local ItemDrop = require("monster_manual_scripts.ItemDrop")
local Constants = require("monster_manual_scripts.Constants")

ItemDrop.AddItemDrop(
    Constants.ItemDrops.RED_HEART,
    4,
    function (familiar)
        local room = Game():GetRoom()
        local spawningPos = room:FindFreePickupSpawnPosition(familiar.Position)

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_HEART,
            HeartSubType.HEART_FULL,
            spawningPos
        )
    end
)