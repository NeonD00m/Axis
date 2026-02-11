local types = require("./types")

local DEVICE_LOOKUP: { [string]: types.DeviceType } = {
	Gamepad1 = "Controller",
	Gamepad2 = "Controller",
	Gamepad3 = "Controller",
	Gamepad4 = "Controller",
	Gamepad5 = "Controller",
	Gamepad6 = "Controller",
	Gamepad7 = "Controller",
	Gamepad8 = "Controller",
	Touch = "Touch",
	MouseButton1 = "Desktop",
	MouseButton2 = "Desktop",
	MouseButton3 = "Desktop",
	MouseMovement = "Desktop",
	MouseWheel = "Desktop",
	Keyboard = "Desktop",
}

local previousInputDevice: types.DeviceType = "Desktop"

local function getInputDevice(input: any): types.DeviceType
	local result = DEVICE_LOOKUP[input.Name] :: types.DeviceType?
	
	if result then
		previousInputDevice = result :: types.DeviceType
	end

	return previousInputDevice
end

return getInputDevice