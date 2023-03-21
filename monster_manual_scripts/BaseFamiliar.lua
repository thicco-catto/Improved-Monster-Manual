local Constants = require "monster_manual_scripts.Constants"
local BaseFamiliar = {}


---@type MonsterManualStats[]
local baseFamiliars = {}


---@param roomType RoomType
---@param baseStats MonsterManualStats
function BaseFamiliar.AddBaseFamiliar(roomType, baseStats)
    baseFamiliars[roomType] = baseStats
end


---@return MonsterManualStats
function BaseFamiliar.GetBaseStats()
    local room = Game():GetRoom()
    local roomType = room:GetType()

    local baseStats = baseFamiliars[roomType]

    if baseStats then
        return TSIL.Utils.Tables.Copy(baseStats)
    else
        ---@type MonsterManualStats
        local stats = {
            Sprite = "wizard_baby",
            Damage = 2,
            FireRate = 20,
            Flags = TearFlags.TEAR_NORMAL,
            ItemDrops = Constants.ItemDrops.RANDOM_CARD,
            Luck = 0,
            ShotSpeed = 1,
            TearEffects = Constants.TearEffects.FRUITCAKE,
            TearVariant = TearVariant.BLUE,
            SpecialEffects = 0,
            FallingAccel = 0,
            FallingSpeed = 0,
            TearColor = Color(0, 0, 0)
        }
        return stats
    end
end


return BaseFamiliar