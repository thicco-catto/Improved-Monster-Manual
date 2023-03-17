local ItemDrop = require("monster_manual_scripts.ItemDrop")
local Constants = require("monster_manual_scripts.Constants")

---@type fun(familiar: EntityFamiliar)[]
local curseSpawnings = {
    function (familiar)
        local room = Game():GetRoom()
        local spawningPos = room:FindFreePickupSpawnPosition(familiar.Position)

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_REDCHEST,
            ChestSubType.CHEST_CLOSED,
            spawningPos
        )
    end,
    function (familiar)
        TSIL.EntitySpecific.SpawnBomb(
            BombVariant.BOMB_TROLL,
            0,
            ---@diagnostic disable-next-line: param-type-mismatch
            familiar.Position + Vector(15, 0)
        )

        TSIL.EntitySpecific.SpawnBomb(
            BombVariant.BOMB_TROLL,
            0,
            ---@diagnostic disable-next-line: param-type-mismatch
            familiar.Position - Vector(15, 0)
        )
    end,
    ---@param familiar EntityFamiliar
    function (familiar)
        local rng = familiar:GetDropRNG()
        local numFlies = TSIL.Random.GetRandomInt(1, 3, rng)

        local player = familiar.Player

        player:AddBlueFlies(numFlies, familiar.Position, player)
    end
}

ItemDrop.AddItemDrop(
    Constants.ItemDrops.CURSE,
    1,
    function (familiar, stats)
        local rng = familiar:GetDropRNG()

        local chance = 10 + stats.Luck * 5

        if rng:RandomInt(100) >= chance then return end

        local toSpawn = TSIL.Random.GetRandomElementsFromTable(
            curseSpawnings,
            1,
            rng
        )[1]

        toSpawn(familiar)
    end
)