local function mockEnum(name: string): any
	return { Name = name }
end

_G.Enum = {
	UserInputType = {
		Gamepad1 = mockEnum("Gamepad1"),
		Gamepad2 = mockEnum("Gamepad1"),
		Gamepad3 = mockEnum("Gamepad1"),
		Gamepad4 = mockEnum("Gamepad1"),
		Gamepad5 = mockEnum("Gamepad1"),
		Gamepad6 = mockEnum("Gamepad1"),
		Gamepad7 = mockEnum("Gamepad1"),
		Gamepad8 = mockEnum("Gamepad1"),
		Touch = mockEnum("Touch"),
		MouseButton1 = mockEnum("MouseButton1"),
		MouseButton2 = mockEnum("MouseButton1"),
		MouseButton3 = mockEnum("MouseButton1"),
		MouseMovement = mockEnum("MouseMovement"),
		MouseWheel = mockEnum("MouseWheel"),
		Keyboard = mockEnum("Keyboard"),
	}
}

local getInputDevice = require("../src/getInputDevice")

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

test("MouseButton1 returns Desktop", function()
	assert(getInputDevice(mockEnum("MouseButton1")) == "Desktop")
end)

test("MouseButton2 returns Desktop", function()
	assert(getInputDevice(mockEnum("MouseButton2")) == "Desktop")
end)

test("MouseButton3 returns Desktop", function()
	assert(getInputDevice(mockEnum("MouseButton3")) == "Desktop")
end)

test("MouseMovement returns Desktop", function()
	assert(getInputDevice(mockEnum("MouseMovement")) == "Desktop")
end)

test("MouseWheel returns Desktop", function()
	assert(getInputDevice(mockEnum("MouseWheel")) == "Desktop")
end)

test("Keyboard returns Desktop", function()
	assert(getInputDevice(mockEnum("Keyboard")) == "Desktop")
end)

test("Touch returns Touch", function()
	assert(getInputDevice(mockEnum("Touch")) == "Touch")
end)

test("Gamepad1 returns Controller", function()
	assert(getInputDevice(mockEnum("Gamepad1")) == "Controller")
end)

test("Gamepad2 returns Controller", function()
	assert(getInputDevice(mockEnum("Gamepad2")) == "Controller")
end)

test("Gamepad8 returns Controller", function()
	assert(getInputDevice(mockEnum("Gamepad8")) == "Controller")
end)

test("unknown input preserves previous device", function()
	getInputDevice(mockEnum("Keyboard"))
	local result = getInputDevice(mockEnum("SomethingUnknown"))
	assert(result == "Desktop", `expected "Desktop", got "{result}"`)
end)

test("unknown input preserves Controller", function()
	getInputDevice(mockEnum("Gamepad1"))
	local result = getInputDevice(mockEnum("SomethingElse"))
	assert(result == "Controller", `expected "Controller", got "{result}"`)
end)

print(`\nResults: {passed} passed, {failed} failed`)
if failed > 0 then
	error(`{failed} test(s) failed`)
end
