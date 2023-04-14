---@diagnostic disable: duplicate-set-field
function TSIL.Direction.AngleToDirection(angleDegrees)
    local positiveDegrees = angleDegrees;
    while positiveDegrees < 0 do
        positiveDegrees = positiveDegrees + 360
    end
    local normalizedDegrees = positiveDegrees % 360;

    if normalizedDegrees < 45 then
        return Direction.RIGHT
    end

    if normalizedDegrees < 135 then
        return Direction.DOWN
    end

    if normalizedDegrees < 225 then
        return Direction.LEFT
    end

    if normalizedDegrees < 315 then
        return Direction.UP
    end

    return Direction.RIGHT
end

