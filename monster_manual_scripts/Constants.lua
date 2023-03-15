local Constants = {}

Constants.FamiliarVariant = {
    MONSTER_MANUAL_FAMILIAR = Isaac.GetEntityVariantByName("Monster Manual Familiar")
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

Constants.PURPLE_TEAR_COLOR = Color(0.4, 0.15, 0.38, 1, 0.27843, 0, 0.4549)

Constants.MAX_GREEN_UPGRADES = 5
Constants.MAX_YELLOW_UPGRADES = 2
Constants.MAX_BLUE_UPGRADES = 3

Constants.UI_ARROW_SPRITE = Sprite()
Constants.UI_ARROW_SPRITE:Load("gfx/ui_element.anm2", true)
Constants.UI_ARROW_SPRITE:ReplaceSpritesheet(0, "gfx/ui/arrow.png")
Constants.UI_ARROW_SPRITE:LoadGraphics()
Constants.UI_ARROW_SPRITE:Play("Idle", true)

---@enum ItemDrops
Constants.ItemDrops = {
	BATTERY = 1 << 0,
	RED_HEART = 1 << 1,
	PILL = 1 << 2,
	RUNE = 1 << 3
}

return Constants