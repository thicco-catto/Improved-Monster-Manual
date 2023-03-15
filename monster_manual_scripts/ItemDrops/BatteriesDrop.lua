local ItemDrop = require("monster_manual_scripts.ItemDrop")
local Constants = require("monster_manual_scripts.Constants")

ItemDrop.AddItemDrop(
    Constants.ItemDrops.BATTERY,
    6,
    function (familiar)
        local room = Game():GetRoom()
        local spawningPos = room:FindFreePickupSpawnPosition(familiar.Position)

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_LIL_BATTERY,
            BatterySubType.BATTERY_MICRO,
            spawningPos
        )
    end
)