---@diagnostic disable: duplicate-set-field
local DIRECTION_TO_VECTOR = {
    [Direction.NO_DIRECTION] = Vector.Zero,
    [Direction.LEFT] = Vector(-1, 0),
    [Direction.UP] = Vector(0, -1),
    [Direction.RIGHT] = Vector(1, 0),
    [Direction.DOWN] = Vector(0, 1),
}

function TSIL.Direction.DirectionToVector(direction)
    return DIRECTION_TO_VECTOR[direction]
end
