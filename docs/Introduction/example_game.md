---
title: Example Game
description: Official example game
sidebar_position: 3
---

# Example Game
Play the example game [here](http://rblx.games/119823868761655).
This article features abridged samples of the actual code in the example game, but you can view the full code [here](https://github.com/NeonD00m/Axis/tree/main/exampleGame/client).

### Behind The Scenes
The concept for this game was to implement three simple mechanics with Axis:
1. Toggleable crouch button for mobile
2. A hold-to-jump mechanic for all platforms
3. Custom camera (to show how to use mouse input, `hold()`, and throw console support in there)

The above order is also the order in which the features will be explained in to roughly go from least to most complex.

### Toggleable Crouch
Alright so here is the actual keymap for the crouching feature. We include all the possible keyboard keys that people might use, as well as the right thumbstick for console. Mobile will be implemented separately.
```lua
--inputMap.luau
crouch = input {
    Enum.KeyCode.C,
    Enum.KeyCode.LeftControl,
    Enum.KeyCode.RightControl,
    Enum.KeyCode.ButtonR3, -- pressing on the right thumbstick will crouch!
}
```
Now we're going to write our crouch system in a way that it will work for all devices without needing to handle any input logic specific to any device:
```lua
--crouch.luau
local crouching = false

local function crouch(dt)
    -- other if statements

    if not inputMap.crouch:pressed() then
        return
    end

    crouching = not crouching
    -- humanoid effects
end
```
All we have to do is wait for the `pressed()` method to signal that the input was just toggled. You could also use `released()` to toggle on release but it might feel delayed from a player's perspective. 
```lua
--touchControls.luau
local crouching = false

crouchButton.MouseButton1Down:Connect(function()
    inputMap.crouch:move(1)
    crouching = not crouching
    if not crouching then
        -- UI effects
        return
    end
    -- UI effects
end)
```
Since we know that we just want the crouch to be toggleable, we will implement it with `move()` to fire the `pressed()` method, but you might not always want to make this assumption. If you wanted to make it hold-to-crouch, or add a setting for whether it is toggleable, you would want to implement the button using `hold()` as seen in the [next section](./example_game#hold-to-jump).

### Hold-to-Jump
Since we just saw the basic implementation of the crouch button, let's jump into the implementation of the hold-to-jump button. Here we are using a different method of handling input on the touch button to allow for mobile users to drag and move the camera around while holding the button.
```lua
local releaseJump, touch = nil, nil

jumpButton.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
        input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    if input.UserInputState ~= Enum.UserInputState.Begin then
        return
    end

    touch = input
    releaseJump = inputMap.jump:hold(1) -- imitates pressing an input axis like the `Space` key
    -- UI effects
end)

UserInputService.InputEnded:Connect(function(input)
    if not releaseJump or input ~= touch or input.UserInputState ~= Enum.UserInputState.End then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
        input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    releaseJump() -- releases the hold, imitating letting go of the `Space` key
    releaseJump = nil
    -- UI effects
end)
```
This method of input only successfully allows for dragging when the button's `Active` property is set to false and `Interactable` is set to true. If `Active` is on, touching the button will be considered a 'processed' input and ignored by most input systems. If `Interactable` is off, events like `InputBegan` will not be fired. Anyway, for reference, here is what the actual input axis looks like for other devices:
```lua
jump = Axis.input {
    Enum.KeyCode.Space,
    Enum.KeyCode.ButtonA
}
```
Now for the system to handle the jumping feature. This will be a bit more complicated than the crouch button, since the goal is to let the user hold the jump button for longer to jump higher. We will start by creating a variable called `jumpHoldTime` that will keep track of how long the player has held the jump input axis for.
```lua
local jumpHoldTime = 0
```
Then in our jump system the first thing we want to do is check if the player should even be able to jump.
```lua
-- if the player is swimming or falling or climbing, reset jump power
if humanoid:GetState() ~= Enum.HumanoidStateType.Running then
    jumpHoldTime = 0
    return -- end system early
end
```
Now since we know that the player is in a valid state to jump (they are standing on the ground), we can check if the jump button was released.
```lua
if inputMap.jump:released() then -- when the jump axis changed and is not held any more
    humanoid.JumpPower = getJumpPower() -- our custom equation using jumpHoldTime
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    jumpHoldTime = 0
    return -- end early again
end
```
Then we will finish the system off with the following code for incrementing our timer `jumpHoldTime` (and setting the jump power to 0 to stop the player from jumping).
```lua
humanoid.JumpPower = 0
jumpHoldTime = inputMap.jump:pressing() and (jumpHoldTime or 0) + deltaTime
```

### Camera Movement
Note: This camera system uses the [Nevermore Spring](https://quenty.github.io/NevermoreEngine/api/Spring/) to smooth out the camera movement.

In your game, there is a good chance that your systems that handle camera movement or unique camera modes might not want to all handle input manually, this is where Axis can help by using only two input axes.
```lua
local inputMap = {
    -- ...
    drag = input {
        Enum.UserInputType.MouseMovement,
        Enum.KeyCode.Thumbstick2,
		[Enum.KeyCode.Left] = vector.create(-2, 0),
		[Enum.KeyCode.Right] = vector.create(2, 0),
    },
	dragHold = input {
        Enum.UserInputType.MouseButton2
    },
}
```
Above you'll see we have the main `drag` input and a secondary `dragHold` input. The `drag` input will be used for general camera movement, while the `dragHold` input will be used to hold the mouse in place and allow the mouse to be "unlocked" the rest of the time.




### Camera Zoom
Here is where the weighting of input axes comes in handy. Using another unnamed input library, we were handling sensitivities for the zoom something like this: 
```lua
--camera.luau
local ZOOM_SPEED = {
	Touch = 5,
	Gamepad = 2,
	Desktop = 10,
}

local function clampZoom(zoom: number): number
	return math.clamp(offsetVector.Position.Z - zoom 
		* ZOOM_SPEED[axis.device(UserInputService:GetLastInputType())],
		MIN_ZOOM, MAX_ZOOM
	)
end
```
We can start to reduce this code by putting gamepad and desktop sensitivities in the same input axis:
```lua
--inputMap.luau
zoom = input {
    [Enum.KeyCode.DPadDown] = -2,
    [Enum.KeyCode.DPadUp] = 2,
    [Enum.KeyCode.I] = 2,
    [Enum.KeyCode.O] = -2,
    [Enum.UserInputType.MouseWheel] = 10,  
}
```
Now we can use a constant in the mobile input system to add that extra sensitivity:
```lua
--mobileInput.luau
local PINCH_MULTI = 50

UserInputService.TouchPinch:Connect(function(_, scale, _, _, _) 
	-- other logic
    inputMap.zoom:move((scale - previousScale) * PINCH_MULTI)
	-- other logic
end)
```
Then we can just completely forget about handling different devices in the camera system!
```lua
local function clampZoom(zoom: number): number
	return math.clamp(offsetVector.Position.Z - zoom, MIN_ZOOM, MAX_ZOOM)
end
```
