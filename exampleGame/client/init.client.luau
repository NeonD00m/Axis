local RunService = game:GetService("RunService")
local Axis = require(game.ReplicatedStorage.Axis)
local mobileInput = require(script.mobileInput)
local inputMap = require(script.inputMap)
local camera = require(script.camera)
local crouch = require(script.crouch)
local jump = require(script.jump)
require(script.touchControls)

RunService.RenderStepped:Connect(function(dt)
    Axis.update(inputMap) -- automatically called update on all the provided input objects!
    -- run systems
    mobileInput(dt)
    camera(dt)
    crouch(dt)
    jump(dt)
end)
