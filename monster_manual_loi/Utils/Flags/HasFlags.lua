---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Flags.HasFlags(flags, ...)
	local flagsToCheck = {...}

	for _, flag in ipairs(flagsToCheck) do
		if flags & flag ~= flag then
			return false
		end
	end

	return true
end
