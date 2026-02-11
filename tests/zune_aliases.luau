local ROOTS = {
	["@self"] = "src",
}

local function resolve(moduleName: string): string?
	local alias, rest = string.match(moduleName, "^(@[%w_]+)/(.+)$")
	if not alias or not rest then
		return nil
	end

	local root = ROOTS[alias]
	if not root then
		return nil
	end

	return string.format("%s/%s.luau", root, rest)
end

local function install()
	local baseRequire = require

	_G.require = function(moduleName: string)
		local path = resolve(moduleName)
		if path then
			local chunk = loadfile(path)
			if chunk then
				return chunk()
			end
		end

		return baseRequire(moduleName)
	end
end

return {
	install = install,
}
