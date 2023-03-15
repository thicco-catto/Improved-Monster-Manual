local ItemDrop = require("monster_manual_scripts.ItemDrop")
local Constants = require("monster_manual_scripts.Constants")

ItemDrop.AddItemDrop(
    Constants.ItemDrops.PILL,
    5,
    function (familiar)
        local room = Game():GetRoom()
        local spawningPos = room:FindFreePickupSpawnPosition(familiar.Position)

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_PILL,
            0,
            spawningPos
        )
    end
)