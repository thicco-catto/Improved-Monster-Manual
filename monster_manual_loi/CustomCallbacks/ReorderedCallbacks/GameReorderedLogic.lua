---@diagnostic disable: duplicate-set-field
local currentStage = nil
local currentStageType = nil
local usedGlowingHourGlass = false
local forceNewLevel = false
local forceNewRoom = false


local function RecordCurrentStage()
    local level = Game():GetLevel();
    local stage = level:GetStage();
    local stageType = level:GetStageType();

    currentStage = stage;
    currentStageType = stageType;
end


local function OnGlowingHourGlassUse()
    usedGlowingHourGlass = true
end
TSIL.__AddInternalCallback(
    "GAME_REORDERED_LOGIC_GLOWING_HOURGLASS_USE",
    ModCallbacks.MC_USE_ITEM,
    OnGlowingHourGlassUse,
    CallbackPriority.DEFAULT,
    CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS
)


local function PostGameStarted(isContinued)
    RecordCurrentStage()

    TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_GAME_STARTED_REORDERED, isContinued)
    TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_NEW_LEVEL_REORDERED)
    TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED)
    TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_GAME_STARTED_REORDERED_LAST, isContinued)
end
TSIL.__AddInternalCallback(
    "GAME_REORDERED_LOGIC_POST_GAME_STARTED",
    ModCallbacks.MC_POST_GAME_STARTED,
    PostGameStarted
)


local function PostNewLevel()
    local frameCount = Game():GetFrameCount();

    if frameCount == 0 and not forceNewLevel then
        return
    end

    forceNewLevel = false;

    RecordCurrentStage();
    TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_NEW_LEVEL_REORDERED)
    TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED)
end
TSIL.__AddInternalCallback(
    "GAME_REORDERED_LOGIC_POST_NEW_LEVEL",
    ModCallbacks.MC_POST_NEW_LEVEL,
    PostNewLevel
)


local function PostNewRoom()
    local frameCount = Game():GetFrameCount()
    local level = Game():GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()

    if usedGlowingHourGlass then
        usedGlowingHourGlass = false

        if currentStage ~= stage or currentStageType ~= stageType then
            RecordCurrentStage()
            TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_NEW_LEVEL_REORDERED)
            TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED)
            return
        end
    end

    if (frameCount == 0 or currentStage ~= stage or currentStageType ~= stageType) and
        not forceNewRoom then
        return
    end
    forceNewRoom = false;

    TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED)
end
TSIL.__AddInternalCallback(
    "GAME_REORDERED_LOGIC_POST_NEW_ROOM",
    ModCallbacks.MC_POST_NEW_ROOM,
    PostNewRoom
)










