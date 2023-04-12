local Constants = {}

Constants.FamiliarVariant = {
    MONSTER_MANUAL_FAMILIAR = Isaac.GetEntityVariantByName("Monster Manual Familiar")
}

Constants.SoundEffect = {
	FAMILIAR_DEATH = Isaac.GetSoundIdByName("monster manual familiar death")
}

Constants.SaveKeys = {
    PLAYERS_USED_MONSTER_MANUAL = "PLAYERS_USED_MONSTER_MANUAL",
    PLAYERS_FAMILIAR_STATS = "PLAYERS_FAMILIAR_STATS",
	PLAYERS_MONSTER_MANUAL_INFO = "PLAYERS_MONSTER_MANUAL_INFO"
}

Constants.FLOAT_ANIM_PER_DIRECTION = {
	[Direction.NO_DIRECTION] = "FloatDown",
	[Direction.LEFT] = "FloatLeft",
	[Direction.UP] = "FloatUp",
	[Direction.RIGHT] = "FloatRight",
	[Direction.DOWN] = "FloatDown"
}

Constants.SHOOT_ANIM_PER_DIRECTION = {
	[Direction.NO_DIRECTION] = "FloatDown",
	[Direction.LEFT] = "FloatShootLeft",
	[Direction.UP] = "FloatShootUp",
	[Direction.RIGHT] = "FloatShootRight",
	[Direction.DOWN] = "FloatShootDown"
}

Constants.CHARGE_ANIM_PER_DIRECTION = {
	[Direction.NO_DIRECTION] = "FloatDown",
	[Direction.LEFT] = "ChargeLeft",
	[Direction.UP] = "ChargeUp",
	[Direction.RIGHT] = "ChargeRight",
	[Direction.DOWN] = "ChargeDown"
}

Constants.LASER_OFFSET_PER_DIRECTION = {
	[Direction.DOWN] = Vector(0, -23),
	[Direction.LEFT] = Vector(-10, -23),
	[Direction.RIGHT] = Vector(10, -23),
	[Direction.UP] = Vector(0, -25),
}
Constants.MAX_CHARGE_ANIM_FRAME = 30
Constants.FAMILIAR_BRIMSTONE_DURATION = 10
Constants.CHARGE_BAR_RENDER_OFFSET = Vector(15, -30)

Constants.PURPLE_TEAR_COLOR = Color(0.4, 0.15, 0.38, 1, 0.27843, 0, 0.4549)

Constants.MAX_GREEN_UPGRADES = 5
Constants.MAX_YELLOW_UPGRADES = 2
Constants.MAX_BLUE_UPGRADES = 3

local function LoadStatsUISprite()
	local spr = Sprite()
	spr:Load("gfx/stat_choosing_ui.anm2", true)
	return spr
end
Constants.STATS_UI_SPRITE = LoadStatsUISprite()

local function LoadCoatHangerUISprite()
	local spr = Sprite()
	spr:Load("gfx/coat_hanger_ui.anm2", true)
	return spr
end
Constants.COAT_HANGER_STATS_UI_SPRITE = LoadCoatHangerUISprite()

---@enum ItemDrops
Constants.ItemDrops = {
	BATTERY = 1 << 0,
	RED_HEART = 1 << 1,
	PILL = 1 << 2,
	RUNE = 1 << 3,
	RANDOM_BOMB = 1 << 4,
	RANDOM_BONE_HEART = 1 << 5,
	RANDOM_KEY = 1 << 6,
	RANDOM_CARD = 1 << 7,
	CURSE = 1 << 8
}

---@enum TearEffects
Constants.TearEffects = {
	CHARM = 1 << 0,
	POISON = 1 << 1,
	BURNING = 1 << 2,
	FREEZING = 1 << 3,
	FEAR = 1 << 4,
	HOLY_LIGHT = 1 << 5,
	CRITICAL = 1 << 6,
	FRUITCAKE = 1 << 7,
	TECHNOLOGY = 1 << 8
}

---@enum SpecialEffects
Constants.SpecialEffects = {
	TWINS = 1 << 0,
	BOOKWORM = 1 << 1,
	TRIPLE_SHOT = 1 << 2,
	BRIMSTONE = 1 << 3,
	INFESTED = 1 << 4,
	DRIED = 1 << 5,
	AIMBOT = 1 << 6
}

return Constants