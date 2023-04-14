---@diagnostic disable: duplicate-set-field


function TSIL.EntitySpecific.GetEffects(effectVariant, subType)
	local entities = TSIL.Entities.GetEntities(EntityType.ENTITY_EFFECT, effectVariant, subType)

	local effects = {}

	for _, v in pairs(entities) do
		local effect = v:ToEffect()
		if effect then
			table.insert(effects, effect)
		end
	end

	return effects
end


function TSIL.EntitySpecific.GetFamiliars(familiarVariant, subType)
	local entities = TSIL.Entities.GetEntities(EntityType.ENTITY_FAMILIAR, familiarVariant, subType)
	local familiars = {}

	for _, v in pairs(entities) do
		local familiar = v:ToFamiliar()
		if familiar then
			table.insert(familiars, familiar)
		end
	end

	return familiars
end






function TSIL.EntitySpecific.GetNPCs(entityType, variant, subType, ignoreFriendly)
	local entities = TSIL.Entities.GetEntities(entityType, variant, subType, ignoreFriendly)

	local npcs = {}

	for _, v in pairs(entities) do
		local npc = v:ToNPC()
		if npc then
			table.insert(npcs, npc)
		end
	end

	return npcs
end




function TSIL.EntitySpecific.GetProjectiles(projectileVariant, subType)
	local entities = TSIL.Entities.GetEntities(EntityType.ENTITY_PROJECTILE, projectileVariant, subType)
	local projectiles = {}

	for _, v in pairs(entities) do
		local projectile = v:ToProjectile()
		if projectile then
			table.insert(projectiles, projectile)
		end
	end

	return projectiles
end




function TSIL.EntitySpecific.GetTears(tearVariant, subType)
	local entities = TSIL.Entities.GetEntities(EntityType.ENTITY_TEAR, tearVariant, subType)
	local tears = {}

	for _, v in pairs(entities) do
		local tear = v:ToTear()
		if tear then
			table.insert(tears, tear)
		end
	end

	return tears
end
