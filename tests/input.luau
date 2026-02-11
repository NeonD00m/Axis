local MockSignal = {}
MockSignal.__index = MockSignal

function MockSignal.new()
	local self = setmetatable({}, MockSignal)
	self._handlers = {}
	return self
end

function MockSignal:Connect(handler)
	table.insert(self._handlers, handler)
	return {
		Disconnect = function()
			for i, h in self._handlers do
				if h == handler then
					table.remove(self._handlers, i)
					break
				end
			end
		end,
	}
end

function MockSignal:Fire(...)
	for _, handler in self._handlers do
		handler(...)
	end
end

local MockUserInputService = {
	InputBegan = MockSignal.new(),
	InputEnded = MockSignal.new(),
	InputChanged = MockSignal.new(),
	TouchSwipe = MockSignal.new(),
	TouchPinch = MockSignal.new(),
}

local function mockEnum(data)
	local result = {}
	for k, v in data do
		if type(v) == "table" then
			result[k] = v
		else
			result[k] = { Name = k, Value = v }
		end
	end
	return result
end

local KeyCode = mockEnum({
	Space = 32,
	E = 69,
	F = 70,
	W = 87,
	A = 65,
	S = 83,
	D = 68,
	ButtonA = 1000,
	ButtonR2 = 1010,
	Thumbstick1 = 1020,
	Thumbstick2 = 1021,
})

local UserInputType = mockEnum({
	Keyboard = 0,
	MouseButton1 = 1,
	MouseButton2 = 2,
	MouseButton3 = 3,
	MouseMovement = 4,
	MouseWheel = 5,
	Touch = 6,
	Gamepad1 = 8,
	Gamepad2 = 9,
	Gamepad3 = 10,
	Gamepad4 = 11,
	Gamepad5 = 12,
	Gamepad6 = 13,
	Gamepad7 = 14,
	Gamepad8 = 15,
})

local UserInputState = mockEnum({
	Begin = 0,
	Change = 1,
	End = 2,
})

_G.Enum = {
	KeyCode = KeyCode,
	UserInputType = UserInputType,
	UserInputState = UserInputState,
}

_G.UserInputService = MockUserInputService

local input = require("../src/input")

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

local function fireInput(keyOrType: any, state: any, inputType: any?)
	local obj = {
		KeyCode = keyOrType,
		UserInputType = inputType or UserInputType.Keyboard,
		UserInputState = state,
	}
	if state == UserInputState.Begin then
		MockUserInputService.InputBegan:Fire(obj, false)
	elseif state == UserInputState.End then
		MockUserInputService.InputEnded:Fire(obj, false)
	else
		MockUserInputService.InputChanged:Fire(obj, false)
	end
end

test("scalar input starts at 0", function()
	local axis = input { KeyCode.E }
	axis:update()
	local value = axis:read()
	assert(value == nil or value == 0, `expected 0 or nil, got {value}`)
end)

test("pressing returns false when no input", function()
	local axis = input { KeyCode.E }
	axis:update()
	assert(axis:pressing() == false, "expected not pressing")
end)

test("pressing returns true after key press", function()
	local axis = input { KeyCode.E }
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	assert(axis:pressing() == true, "expected pressing")
end)

test("pressing returns false after key release", function()
	local axis = input { KeyCode.E }
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	fireInput(KeyCode.E, UserInputState.End)
	axis:update()
	assert(axis:pressing() == false, "expected not pressing")
end)

test("pressed returns true only on first frame", function()
	local axis = input { KeyCode.E }
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	assert(axis:pressed() == true, "expected pressed on first frame")
	axis:update()
	assert(axis:pressed() == false, "expected not pressed on second frame")
end)

test("released returns true only on release frame", function()
	local axis = input { KeyCode.E }
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	assert(axis:released() == false, "should not be released while pressing")
	fireInput(KeyCode.E, UserInputState.End)
	axis:update()
	assert(axis:released() == true, "expected released")
	axis:update()
	assert(axis:released() == false, "should not be released after release frame")
end)

test("changed detects state transitions", function()
	local axis = input { KeyCode.E }
	axis:update()
	assert(axis:changed() == false, "no change initially")
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	assert(axis:changed() == true, "changed when pressed")
	axis:update()
	assert(axis:changed() == false, "no change when held")
end)

test("read returns current and previous values", function()
	local axis = input { KeyCode.E }
	axis:update()
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	local current, previous = axis:read()
	assert(current == 1, `expected current 1, got {current}`)
	assert(previous == nil or previous == 0, `expected previous 0 or nil, got {previous}`)
end)

test("weighted axis uses custom value", function()
	local axis = input { [KeyCode.E] = 5 }
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	local value = axis:read()
	assert(value == 5, `expected 5, got {value}`)
end)

test("negative weight works", function()
	local axis = input { [KeyCode.E] = -1 }
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	local value = axis:read()
	assert(value == -1, `expected -1, got {value}`)
end)

test("multiple keys sum their values", function()
	local axis = input {
		[KeyCode.D] = 1,
		[KeyCode.A] = -1,
	}
	fireInput(KeyCode.D, UserInputState.Begin)
	fireInput(KeyCode.A, UserInputState.Begin)
	axis:update()
	local value = axis:read()
	assert(value == 0, `expected 0 (cancel out), got {value}`)
end)

test("single key of two active gives its weight", function()
	local axis = input {
		[KeyCode.D] = 1,
		[KeyCode.A] = -1,
	}
	fireInput(KeyCode.D, UserInputState.Begin)
	axis:update()
	local value = axis:read()
	assert(value == 1, `expected 1, got {value}`)
end)

test("hold adds value to axis", function()
	local axis = input { KeyCode.E }
	local release = axis:hold(1)
	axis:update()
	assert(axis:pressing() == true, "expected pressing after hold")
	release()
	axis:update()
	assert(axis:pressing() == false, "expected not pressing after release")
end)

test("hold with custom value", function()
	local axis = input { KeyCode.E }
	local release = axis:hold(3)
	axis:update()
	local value = axis:read()
	assert(value == 3, `expected 3, got {value}`)
	release()
end)

test("multiple holds stack", function()
	local axis = input { KeyCode.E }
	local release1 = axis:hold(1)
	local release2 = axis:hold(2)
	axis:update()
	local value = axis:read()
	assert(value == 3, `expected 3, got {value}`)
	release1()
	axis:update()
	value = axis:read()
	assert(value == 2, `expected 2 after releasing first hold, got {value}`)
	release2()
end)

test("move adds value for a single update cycle", function()
	local axis = input { KeyCode.E }
	axis:move(1)
	axis:update()
	assert(axis:pressing() == true, "expected pressing on move frame")
	axis:update()
	assert(axis:pressing() == false, "expected not pressing after move expires")
end)

test("map clears and remaps inputs", function()
	local axis = input { KeyCode.Space }
	fireInput(KeyCode.Space, UserInputState.Begin)
	axis:update()
	assert(axis:pressing() == true, "pressing Space")

	fireInput(KeyCode.Space, UserInputState.End)
	axis:update()
	axis:map { KeyCode.F }

	fireInput(KeyCode.Space, UserInputState.Begin)
	axis:update()
	assert(axis:pressing() == false, "Space should no longer be mapped")
	fireInput(KeyCode.Space, UserInputState.End)

	fireInput(KeyCode.F, UserInputState.Begin)
	axis:update()
	assert(axis:pressing() == true, "F should now be mapped")
	fireInput(KeyCode.F, UserInputState.End)
	axis:update()
end)

test("map with empty table clears all mappings", function()
	local axis = input { KeyCode.E }
	axis:map {}
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	assert(axis:pressing() == false, "expected no input after clearing map")
end)

test("sunk inputs are ignored on InputBegan", function()
	local axis = input { KeyCode.E }
	MockUserInputService.InputBegan:Fire({
		KeyCode = KeyCode.E,
		UserInputType = UserInputType.Keyboard,
		UserInputState = UserInputState.Begin,
	}, true)
	axis:update()
	assert(axis:pressing() == false, "sunk input should be ignored")
end)

test("mouse button input type works", function()
	local axis = input { UserInputType.MouseButton1 }
	MockUserInputService.InputBegan:Fire({
		KeyCode = { Name = "", Value = 0 },
		UserInputType = UserInputType.MouseButton1,
		UserInputState = UserInputState.Begin,
	}, false)
	axis:update()
	assert(axis:pressing() == true, "expected pressing mouse button")
end)

test("hold and real input stack together", function()
	local axis = input { KeyCode.E }
	fireInput(KeyCode.E, UserInputState.Begin)
	local release = axis:hold(1)
	axis:update()
	local value = axis:read()
	assert(value == 2, `expected 2 (real + hold), got {value}`)
	release()
	axis:update()
	value = axis:read()
	assert(value == 1, `expected 1 (real only), got {value}`)
	fireInput(KeyCode.E, UserInputState.End)
	axis:update()
end)

test("multiple inputs with different weights", function()
	local axis = input {
		[KeyCode.W] = 3,
		[KeyCode.E] = 1,
	}
	fireInput(KeyCode.W, UserInputState.Begin)
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	local value = axis:read()
	assert(value == 4, `expected 4, got {value}`)
end)

test("previous value tracks correctly across frames", function()
	local axis = input { [KeyCode.E] = 3 }
	fireInput(KeyCode.E, UserInputState.Begin)
	axis:update()
	fireInput(KeyCode.E, UserInputState.End)
	axis:update()
	local current, previous = axis:read()
	assert(current == nil or current == 0, `expected current nil or 0, got {current}`)
	assert(previous == 3, `expected previous 3, got {previous}`)
end)

print(`\nResults: {passed} passed, {failed} failed`)
if failed > 0 then
	error(`{failed} test(s) failed`)
end
