local UserInputService = _G.UserInputService or game:GetService("UserInputService")
local types = require("@self/types")
local constructor = require("@self/input")
local getInputDevice = require("@self/getInputDevice")

--[=[
	@class Axis
	The Axis library used to define input axes, get devices, and update inputs
]=]
--[=[
	@within Axis
	@function input
	@param keyMap Map<T>
	@return Input<T>
	Creates a new input axis with the provided keymap
	```lua
	local attack = Axis.input {
		Enum.KeyCode.E,
		Enum.KeyCode.ButtonX,
	}
	```
]=]
local Axis = {
   input = constructor,
}

--[=[
	@within Axis
	@function update
	Updates all the provided inputs as a shorthand
	```lua
	Axis.update(inputMap) 
	```
]=]
function Axis.update(inputs: { [any]: types.Input<any> })
   for _, input in inputs do
	  input:update()
   end
end

--[=[
	@within Axis
	@function device
	@param input Enum.UserInputType?
	@return DeviceType
	Gets the device of the provided UserInputType (or the last UserInputType if none is provided)
	```lua
	local device = Axis.device() --gets device of last input
	if device == "Desktop" then
		print("yay")
	end
	```
]=]
function Axis.device(input: any?): types.DeviceType
   return getInputDevice(input or UserInputService:GetLastInputType())
end

export type DeviceType = types.DeviceType
export type Map<T> = types.Map<T>
export type Input<T> = types.Input<T>
export type Axis = types.Axis

return Axis :: types.Axis