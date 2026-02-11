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
return function<T>(value: T, ...: any)
	local args = { ... }
	return function(cases: { [any]: any }): any
		assert(type(cases) == 'table', "cases needs to be table")
		for i = 1, #cases, 2 do
			if value == (cases :: any)[i] then
				local result = (cases :: any)[i + 1]
				return if type(result) == "function" then
					result(value, unpack(args)) else result
			end
		end
		return nil
	end
end