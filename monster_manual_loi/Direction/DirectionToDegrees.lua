---@diagnostic disable: duplicate-set-field
local DIRECTION_TO_ANGLE = {
    [Direction.NO_DIRECTION] = 0,
    [Direction.LEFT] = 180,
    [Direction.UP] = 270,
    [Direction.RIGHT] = 0,
    [Direction.DOWN] = 90,
}

function TSIL.Direction.DirectionToDegrees(direction)
    return DIRECTION_TO_ANGLE[direction]
end

