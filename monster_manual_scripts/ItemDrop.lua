local ItemDrop = {}

---@type ItemDropData[]
local itemDrops = {}


---@param itemDropType ItemDrops
---@param roomCount integer
---@param onDrop fun(familiar: EntityFamiliar, stats: MonsterManualStats)
function ItemDrop.AddItemDrop(itemDropType, roomCount, onDrop)
    itemDrops[#itemDrops+1] = {
        itemDrop = itemDropType,
        roomCount = roomCount,
        onDrop = onDrop
    }
end


---@param familiar EntityFamiliar
---@param familiarStats MonsterManualStats
function ItemDrop.TriggerDrops(familiar, familiarStats)
    local roomClearCount = familiar.RoomClearCount

    local activeItemDrops = TSIL.Utils.Tables.Filter(itemDrops, function (_, itemDropData)
        return TSIL.Utils.Flags.HasFlags(familiarStats.ItemDrops, itemDropData.itemDrop)
    end)

    TSIL.Utils.Tables.ForEach(activeItemDrops, function (_, itemDropData)
        local targetRoomCount = math.max(1, itemDropData.roomCount - familiarStats.Luck)

        if roomClearCount % targetRoomCount == 0 then
            itemDropData.onDrop(familiar, familiarStats)
        end
    end)
end


return ItemDrop