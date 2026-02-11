---
title: Touch
description: Touch support guide
sidebar_position: 3
---

# Touch
Touch controls can often be one of the most difficult parts to implement well, since you need to consider much more factors in how players will interact with your game. Axis tries to give you a lot of power to adjust inputs however you want through `hold()` and `move()`.

### Hold
Holding is the easiest method of using UI touch controls with Axis. When you write your keymap, you won't be able to use any sort of special keys for mobile in most cases, so you implement it as usual for other devices.
```lua
local aim = Axis.input {
    Enum.UserInputType.MouseButton2,
    Enum.KeyCode.ButtonL2
}
```
In this example, we're going to be writing support for aiming down sights (ADS) in an FPS game. Imagine we have the following ADS system to handle the visuals:
```lua
local function aimDownSights()
    aim:update()

    local isAiming: number = if aim:pressed() then 1 else 0
    local gunOffset = hipOffset:Lerp(aimOffset, isAiming)
    ...
end
```
After designing a UI button (`aimButton`) for mobile players, we can use `hold()` to add the input value to the axis:
```lua
local release, touch = nil, nil

aimButton.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
        input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    if input.UserInputState ~= Enum.UserInputState.Begin then
        return
    end
    touch = input
    release = aim:hold() -- this sets the value of the aim input to 1, as if there was a right click
end)

UserInputService.InputEnded:Connect(function(input)
    if not release or input ~= touch or input.UserInputState ~= Enum.UserInputState.End then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
        input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    release() -- this releases the hold, as if the right click was released
    release = nil
end)
```
This code would make sure that your game can properly support mobile players with intuitive controls, while keeping input handling outside of your game logic (in this case, the `aimDownSights()` function).

:::tip
You may be wondering why we're using this complicated method instead of `aimButton.Activated`. Well this strategy is to allow mobile players to continue to drag their camera around while pressing the button (and holding the input axis). This is ideal in a scenario where the gun might shoot automatically when aiming over a player on a mobile device. But this is more common with 'shoot' buttons.
:::

### Move
If you are using a UI framework like Roact or Vide, or maybe you just have state in a different library, you may want to have a system run every frame that uses `move()` to connect that state to an input axis.
```lua
local isShootButtonPressed -- state that comes from somewhere else
local shoot = Axis.input {
    Enum.KeyCode.ButtonR2,
    Enum.KeyCode.MouseButton1
}
local function handleInput()
    if isShootButtonPressed() then
        shoot:move(1)
    end
    -- maybe do the same for other input axes
end
```
`move()` works just like a hold(), except that it is optimized to only add that value to the axis for a single update. This works in this situation since you can only check whether the button is pressed every frame, so it makes sense to just move the axis for that frame and then have it reset automatically the next frame.