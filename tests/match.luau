local match = require("../src/match")

local passed = 0
local failed = 0

local function test(name: string, fn: () -> ())
	local ok, err: any = pcall(fn)
	if ok then
		passed += 1
	else
		failed += 1
		print(`FAIL: {name}\n\t{err}`)
	end
end

test("matches first case", function()
	local result = match("hello") {
		"world", "nope",
		"hello", "yes",
	}
	assert(result == "yes", `expected "yes", got "{result}"`)
end)

test("matches second case", function()
	local result = match("world") {
		"world", "first",
		"hello", "second",
	}
	assert(result == "first", `expected "first", got "{result}"`)
end)

test("returns nil for no match", function()
	local result = match("unknown") {
		"hello", "a",
		"world", "b",
	}
	assert(result == nil, `expected nil, got "{result}"`)
end)

test("matches numbers", function()
	local result = match(42) {
		1, "one",
		42, "forty-two",
	}
	assert(result == "forty-two", `expected "forty-two", got "{result}"`)
end)

test("calls function result", function()
	local result = match("x") {
		"x", function()
			return "from function"
		end,
	}
	assert(result == "from function", `expected "from function", got "{result}"`)
end)

test("passes value to function result", function()
	local result = match("input") {
		"input", function(v)
			return `got {v}`
		end,
	}
	assert(result == "got input", `expected "got input", got "{result}"`)
end)

test("passes extra args to function result", function()
	local result = match("key", "extra1", "extra2") {
		"key", function(v, a, b)
			return `{v}-{a}-{b}`
		end,
	}
	assert(result == "key-extra1-extra2", `expected "key-extra1-extra2", got "{result}"`)
end)

test("only matches first matching case", function()
	local result = match("dup") {
		"dup", "first",
		"dup", "second",
	}
	assert(result == "first", `expected "first", got "{result}"`)
end)

test("matches boolean values", function()
	local result = match(true) {
		false, "no",
		true, "yes",
	}
	assert(result == "yes", `expected "yes", got "{result}"`)
end)

test("returns numeric results", function()
	local result = match("a") {
		"a", 100,
		"b", 200,
	}
	assert(result == 100, `expected 100, got {result}`)
end)

print(`\nResults: {passed} passed, {failed} failed`)
if failed > 0 then
	error(`{failed} test(s) failed`)
end
