local ItemDrop = require("monster_manual_scripts.ItemDrop")
local Constants = require("monster_manual_scripts.Constants")

ItemDrop.AddItemDrop(
    Constants.ItemDrops.RUNE,
    7,
    function (familiar)
        local itemPool = Game():GetItemPool()
        local rune = itemPool:GetCard(familiar:GetDropRNG():Next(), false, true, true)


        local room = Game():GetRoom()
        local spawningPos = room:FindFreePickupSpawnPosition(familiar.Position)

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_TAROTCARD,
            rune,
            spawningPos
        )
    end
)