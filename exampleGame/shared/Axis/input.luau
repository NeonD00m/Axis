--!strict
--!optimize 2
--[=[
	@class Input
	The Input class used to define input axes
]=]
local UserInputService = game:GetService("UserInputService")

local types = require(script.Parent.types)
local match = require(script.Parent.match)

local NEXT_HOLD_INDEX = 1

local function deadzone<T>(input: types.Input<T>, value: number): number
	if value < (input.deadzone or 0.3) then
		return 0
	end
	return value
end

local function getGamepad(inputType)
	if inputType == Enum.UserInputType.Gamepad2 then
		return 2
	elseif inputType == Enum.UserInputType.Gamepad3 then
		return 3
	elseif inputType == Enum.UserInputType.Gamepad4 then
		return 4
	elseif inputType == Enum.UserInputType.Gamepad5 then
		return 5
	elseif inputType == Enum.UserInputType.Gamepad6 then
		return 6
	elseif inputType == Enum.UserInputType.Gamepad7 then
		return 7
	elseif inputType == Enum.UserInputType.Gamepad8 then
		return 8
	end
	return 1
end

local function _reset<T>(input: types.Input<T>, controller: number, inputType: any)
	input.resets[inputType] = {controller, false}-- maybe divide by controller too?
end

--[=[
	@within Input
	@method read
	@param controller number?
	@return T, T
	Reads current and previous values for the axis
	```lua
	local current, previous = attack:read()  
	```
]=]
local function read<T>(input: types.Input<T>, controller: number?): (T, T) 
	local default = if input.vector then vector.zero else 0
	return (input.current[controller or 1] or default) :: T, (input.previous[controller or 1] or default) :: T
end

--[=[
	@within Input
	@method pressing
	@param controller number?
	@return boolean
	Gets whether the axis has any active input
]=]
local function pressing<T>(input: types.Input<T>, controller: number?): boolean
	local value = read(input, controller)
	local magnitude = if input.vector then value.Magnitude else value
	return magnitude ~= 0
end

--[=[
	@within Input
	@method changed
	@param controller number?
	@return boolean
	Gets whether an axis has changed since the last update
]=]
local function changed<T>(input: types.Input<T>, controller: number?): boolean
	return input.current[controller or 1] ~= input.previous[controller or 1]
end

--[=[
	@within Input
	@method pressed
	@param controller number?
	@return boolean
	Gets whether the axis was activated this update
]=]
local function pressed<T>(input: types.Input<T>, controller: number?): boolean
	return changed(input, controller) and pressing(input, controller)
end

--[=[
	@within Input
	@method released
	@param controller number?
	@return boolean
	Gets whether the axis was deactivated this update
]=]
local function released<T>(input: types.Input<T>, controller: number?): boolean
	return changed(input, controller) and not pressing(input, controller)
end

--[=[
	@within Input
	@method hold
	@param value T
	@param controller number?
	@return () -> ()
	Adds a temporary manual input to the axis, and provides a function to release it
	```lua
	local release = attack:hold(1) -- adds 1 to the axis
	--release later
	release() -- removes the added value
	```
]=]
local function hold<T>(input: types.Input<T>, value: T, controller: number?): () -> ()
	local id = NEXT_HOLD_INDEX
	NEXT_HOLD_INDEX += 1
	input.active[controller or 1][id] = (value or 1) :: T
	return function()
		input.active[controller or 1][id] = nil
	end
end

--[=[
	@within Input
	@method move
	@param value T
	@param controller number?
	Adds an input to the axis for a single frame
]=]
local function move<T>(input: types.Input<T>, value: T, controller: number?)
	local id = NEXT_HOLD_INDEX
	NEXT_HOLD_INDEX += 1
	input.active[controller or 1][id] = (value or 1) :: T
	_reset(input, controller or 1, id)
end


--[=[
	@within Input
	@method map
	@param keyMap Map<T>
	Maps input types to an input axis
	```lua
	attack:map {
		Enum.KeyCode.Q,
		Enum.KeyCode.ButtonA,
	}
	-- or to clear all input mappings
	attack:map {}
	```
]=]
local function map<T>(input: types.Input<T>, keyMap: types.Map<T>)
	--disconnect previous connections
	for _, connection in input.connections do
		connection:Disconnect()
	end
	input.vector = false
	input.inputMap = keyMap

	if next(keyMap) == nil then
		return
	end

	--set up connections
	local group =  {}
	for index, value in keyMap :: any do
		local inputType = if type(index) == "number" then value else index
		value = if type(index) == "number" then 1 else value
		keyMap[index] = nil :: nil & T
		keyMap[inputType] = value

		if type(value) ~= "number" then -- assuming vector, else invalid input value
			input.vector = true
		end

		if inputType == Enum.KeyCode.Right or inputType == Enum.KeyCode.Left then
			print("doing keymap for:", inputType, value)
		end

		if inputType == Enum.UserInputType.MouseMovement then
			input.vector = true
			table.insert(input.connections, UserInputService.InputChanged:Connect(function(inputObject)
				if inputObject.UserInputType ~= Enum.UserInputType.MouseMovement then
					return
				end
				input.active[1][Enum.UserInputType.MouseMovement] = vector.create(inputObject.Delta.X, -inputObject.Delta.Y) * value
				_reset(input, 1, Enum.UserInputType.MouseMovement)
			end))
		elseif inputType == Enum.UserInputType.MouseWheel then
			table.insert(input.connections, UserInputService.InputChanged:Connect(function(object)
				if object.UserInputType ~= Enum.UserInputType.MouseWheel then
					return
				end
				local position = object.Position.Z
				input.active[1][Enum.UserInputType.MouseWheel] = position * value
				_reset(input, 1, Enum.UserInputType.MouseWheel)
			end))
		elseif inputType == Enum.KeyCode.Thumbstick1 then
			input.vector = true
			table.insert(input.connections, UserInputService.InputChanged:Connect(function(object)
				if object.KeyCode ~= Enum.KeyCode.Thumbstick1 then
					return
				end
				local position = object.Position
				input.active[getGamepad(object.UserInputType)][Enum.KeyCode.Thumbstick1] =
					vector.create(deadzone(input, position.X), deadzone(input, position.Y)) * value
			end))
		elseif inputType == Enum.KeyCode.Thumbstick2 then
			input.vector = true
			table.insert(input.connections, UserInputService.InputChanged:Connect(function(object)
				if object.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end
				local position = object.Position
				input.active[getGamepad(object.UserInputType)][Enum.KeyCode.Thumbstick1] =
					vector.create(deadzone(input, position.X), deadzone(input, position.Y)) * value
			end))
		elseif inputType == UserInputService.TouchSwipe then
			input.vector = true
			table.insert(input.connections, UserInputService.TouchSwipe:Connect(function(direction: Enum.SwipeDirection)
				input.active[1][UserInputService.TouchSwipe] = value * match(direction) {
					Enum.SwipeDirection.Left, vector.create(-1, 0),
					Enum.SwipeDirection.Right, vector.create(1, 0),
					Enum.SwipeDirection.Up, vector.create(0, 1),
					Enum.SwipeDirection.Down, vector.create(0, -1),
				}
			end))
		elseif inputType == UserInputService.TouchPinch then
			table.insert(input.connections, UserInputService.TouchPinch:Connect(function(_, scale: number, _, state, sunk)
				if state == Enum.UserInputState.End then
					input.active[1][UserInputService.TouchPinch] = nil
					return
				end
				input.active[1][UserInputService.TouchPinch] = value * scale :: number & T
			end))
		else
			if inputType == Enum.KeyCode.Right or inputType == Enum.KeyCode.Left then
				print("added to general group:", inputType, value)
			end
			table.insert(group, inputType)
		end
	end

	local inputBeganOrEnded = function(inputObject, sunk)
		if sunk then
			return
		end

		local controller = getGamepad(inputObject.UserInputType)
		input.active[controller] = input.active[controller] or {}
		local active = input.active[controller]
		for _, enum in group do

			if inputObject.KeyCode ~= enum and inputObject.UserInputType ~= enum then
				continue
			end

			if enum == Enum.KeyCode.Right or enum == Enum.KeyCode.Left then
				print(enum, "detected:", keyMap[enum]) 
			end

			active[enum] = (if inputObject.UserInputState == Enum.UserInputState.Begin or
				inputObject.UserInputState == Enum.UserInputState.Change then keyMap[enum] else nil) :: (nil & T)
		end
	end
	table.insert(input.connections, UserInputService.InputBegan:Connect(inputBeganOrEnded))
	table.insert(input.connections, UserInputService.InputEnded:Connect(inputBeganOrEnded))
end

--[=[
	@within Input
	@method update
	Updates the current and previous values of the input axis
]=]
local function update<T>(input: types.Input<T>)
	-- reset old values
	for inputType, reset in input.resets do
		if not reset[2] then
			reset[2] = true
			continue
		end
		input.active[reset[1]][inputType] = nil
		input.resets[inputType] = nil
	end

	-- iterate through all controllers
	for i, set in input.active do
		-- set last frame
		input.previous[i] = input.current[i]

		local result: T? = nil -- sum current values
		for key, value: T in set do
			if not result then
				result = value
				continue
			end
			result += value
		end

		input.current[i] = result :: T
	end
end

local function new<T>(inputMap: types.Map<T> & { deadzone: number? }): types.Input<T>
	local input: types.Input<T> = {
		vector = false,
		current = {},
		previous = {},
		active = {
			{}, -- separate input axes for each controller
		},
		resets = {}, --resets input on next update
		connections = {},
		inputMap = inputMap,
		deadzone = inputMap.deadzone,

		read = read,
		pressing = pressing,
		pressed = pressed,
		released = released,
		changed = changed,
		hold = hold,
		map = map,
		update = update,
		move = move,
	}
	map(input, inputMap)

	return input
end

return new :: types.InputConstructor