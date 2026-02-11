--[[match statement that allows for custom equals metatable function
```lua
	local result = match "hello" {
		"world", function()
			return "failed"
		end,
		"hello", function()
			return "success!"
		end,
	}
```]]
return function<T, V...>(value: T, ...: V...)
	local args = { ... }
	return function<R>(cases: {R | (T, V...) -> R}): R?
		assert(type(cases) == 'table', "cases needs to be table")
		for i = 1, #cases, 2 do
			if value == cases[i] then
				local result = cases[i + 1]
				return if type(result) == "function" then
					result(value,unpack(args)) else result
			end
		end
		return nil
	end
end