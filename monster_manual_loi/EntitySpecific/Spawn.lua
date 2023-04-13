---@diagnostic disable: duplicate-set-field

function TSIL.EntitySpecific.SpawnBomb(bombVariant, subType, position, velocity, spawner, seedOrRNG)
    velocity = velocity or Vector.Zero

    local entity = TSIL.Entities.Spawn(EntityType.ENTITY_BOMB, bombVariant, subType, position, velocity, spawner, seedOrRNG):ToBomb()

    if entity == nil then
        error("Failed to spawn a bomb.")
    end

    return entity
end

function TSIL.EntitySpecific.SpawnEffect(effectVariant, subType, position, velocity, spawner, seedOrRNG)
    velocity = velocity or Vector.Zero

    local entity = TSIL.Entities.Spawn(EntityType.ENTITY_EFFECT, effectVariant, subType, position, velocity, spawner, seedOrRNG):ToEffect()

    if entity == nil then
        error("Failed to spawn an effect.")
    end

    return entity
end




function TSIL.EntitySpecific.SpawnPickup(pickupVariant, subType, position, velocity, spawner, seedOrRNG)
    velocity = velocity or Vector.Zero

    local entity = TSIL.Entities.Spawn(EntityType.ENTITY_PICKUP, pickupVariant, subType, position, velocity, spawner, seedOrRNG):ToPickup()

    if entity == nil then
        error("Failed to spawn a pickup.")
    end

    return entity
end



