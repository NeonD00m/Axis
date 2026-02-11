---
title: Getting Started
description: How to get started with Axis
sidebar_position: 1
---

# Getting Started

## Installation
Currently only available on [pesde](https://pesde.dev/packages/killergg/axis)

## Usage
While this library is agnostic and doesn't require an ECS of any sort, it is definitely ECS-oriented since it's meant to be run in systems. Input axes run on a frame by frame basis, meaning they need to be updated every frame.
```lua
RunService.RenderStepped:Connect(function()
    attack:update() -- update the input axes
    if attack:pressed() then -- fires once, when the input is newly pressed
        print("Attacked!")
    end
end)
```


### Input Axes
To create an input axis, you need to define a keymap. These keymaps can contain keybinds for any devices, as shown here:
```lua
local attack = Axis.input {
    Enum.KeyCode.E, -- for keyboard, though usually redundant with mouse
    Enum.UserInputType.MouseButton1, -- for mouse
    Enum.KeyCode.ButtonR2, -- for xbox/ps4 controllers
}
```

In this example, three axes have been defined in the input, E, left click, and the right trigger on console. These axes for example are all positive (by default), meaning that each can either be equal to 0 or 1.
```lua
-- if any of the above axes are equal to 1, the input is considered pressing
if attack:pressing() then
...
```

But lets use this idea of axes to use the mouse's scroll wheel as input. The scroll wheel is a *special key* where the value can either be 0 (for no scroll), 1 (for scrolling up), or -1 (for scrolling down). This means that the axis could be negative or positive.
```lua
local zoom = Axis.input { Enum.UserInputType.MouseWheel }
```
In this case, pressing == when the user is scrolling in either direction. (Pressing is true when the whole input is not equal to 0, this is called being "activated" in the API).
```lua
local pressing = zoom:pressing()
```
So now, using `read()` is more useful, since it returns the current and previous values of the axis.
```lua
local current, previous = zoom:read()
-- current will equal either, -1, 0, or 1
-- same for previous!
```


### Axis Weights
By default input axes are given a weight of 1. This means that if one axis was positive and another was negative, they would cancel each other out.
```lua
local movementIn2D = Axis.input {
    [Enum.KeyCode.A] = -1,
    Enum.KeyCode.D, -- by default, given a weight of positive 1
    -- [Enum.KeyCode.D] = 1, -- this is explicit, but has same behavior
}
```
If both keys were being pressed at the same time, the value of the input as a whole would be 0, since 1 + (-1) = 0. This is how input is calculated internally. It's just a sum of all the axes. You could weight axes very differently, if you wanted:
```lua
local acceleratePedal = Axis.input {
    [Enum.KeyCode.Q] = 3,
    [Enum.KeyCode.W] = 1,
}
local pedal = acceleratePedal:read()
-- pedal will equal either 4, 3, 1, or 0
```
:::warning
Beware of using variable magnitude weights when reading with `read()` as you may get unexpected results. Remember that the result of `read()` is a sum of all the axes, so the value have a magnitude of more than 1 or less than -1.
:::

### Vector Axes
The cool thing about modelling input as axes is that they can be vectors. For example, the common usecase of character movement with WASD:
```lua
local move = Axis.input {
    [Enum.KeyCode.W] = Vector2.new(0, 1),
    [Enum.KeyCode.S] = Vector2.new(0, -1),
    [Enum.KeyCode.A] = Vector2.new(-1, 0),
    [Enum.KeyCode.D] = Vector2.new(1, 0),
}
```
But then you can also add support for the thumbsticks:
```lua
...
    [Enum.KeyCode.D] = Vector2.new(1, 0),
    Enum.KeyCode.Thumbstick1, -- could be any Vector2 with a magnitude of 1
}
```
These vector axes can also have weights, though the weights can only be values that can be multiplied by a vector. For example, you could set mouse sensitivity like this:
```lua
local mouse = Axis.input {
    [Enum.UserInputType.MouseMovement] = 50,
    -- [Enum.UserInputType.MouseMovement] = Vector2.new(0, 1),
}
local delta = mouse:read() -- mouse movement is a variable-magnitude vector, but we still multiply by 50
```


## More Information
To read about more specific features for mobile and console support, check out the device support guides, or check out the [API](../../api/Axis) to start using Axis.
- [Touch](../Devices/touch): `hold()` and `move()` for UI touch controls
- [Controller](../Devices/controller): controller numbers for handling multiple controllers
- [Desktop](../Devices/desktop): mouse stuff