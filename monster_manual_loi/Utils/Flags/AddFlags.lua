---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Flags.AddFlags(flags, ...)
	local flagsToAdd = {...}

	for _, flag in ipairs(flagsToAdd) do
		flags = flags | flag
	end

	return flags
end
