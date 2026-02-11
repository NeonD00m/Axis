---
title: Desktop
description: Desktop support guide
sidebar_position: 1
---

# Desktop
Desktop is probably the most straightforward device to support with Axis, since keyboard and mouse inputs map very naturally to input axes. Most of Axis' features are designed with desktop in mind, so if you've read the [Getting Started](../Introduction/getting_started) guide, you're already familiar with how desktop input works.

### Keyboard
Keyboard inputs are the simplest kind of axis. Each key is either pressed (1) or not pressed (0), and you can use `Enum.KeyCode` to define them:
```lua
local attack = Axis.input {
    Enum.KeyCode.E,
}
```
You can combine multiple keys into a single axis using [weights](../Introduction/getting_started#axis-weights) to create more complex inputs like WASD movement:
```lua
local move = Axis.input {
    [Enum.KeyCode.W] = Vector2.new(0, 1),
    [Enum.KeyCode.S] = Vector2.new(0, -1),
    [Enum.KeyCode.A] = Vector2.new(-1, 0),
    [Enum.KeyCode.D] = Vector2.new(1, 0),
}
```

### Mouse Buttons
Mouse buttons work the same way as keyboard keys. You can use `Enum.UserInputType` to define them:
```lua
local shoot = Axis.input {
    Enum.UserInputType.MouseButton1,
}
```
You can also combine mouse buttons with keyboard keys seamlessly:
```lua
local attack = Axis.input {
    Enum.KeyCode.E,
    Enum.UserInputType.MouseButton1,
    Enum.KeyCode.ButtonR2, -- add controller support too!
}
```

### Mouse Movement
Mouse movement is a *special key* that produces a vector axis. The value is the mouse's delta (change in position) each frame, which makes it ideal for camera controls:
```lua
local look = Axis.input {
    [Enum.UserInputType.MouseMovement] = 1,
}
```
You can adjust the sensitivity by changing the weight:
```lua
local look = Axis.input {
    [Enum.UserInputType.MouseMovement] = 50,
    [Enum.KeyCode.Thumbstick2] = 20, -- add controller support with a different sensitivity
}
```
After calling `update()`, you can read the delta for that frame:
```lua
local delta = look:read() -- a vector with x and y components
```

:::tip
Mouse movement resets every frame automatically, so you don't need to worry about clearing it. The value will only be non-zero on frames where the mouse actually moved.
:::

### Mouse Wheel
The scroll wheel is another *special key* where the value can be 0 (no scroll), 1 (scrolling up), or -1 (scrolling down):
```lua
local zoom = Axis.input {
    Enum.UserInputType.MouseWheel,
}
```
Just like mouse movement, the scroll value resets automatically each frame. You can use `read()` to check the direction:
```lua
local scroll = zoom:read()
-- scroll will be -1, 0, or 1
```

:::tip
You can also give the scroll wheel a vector weight if you want to combine it with other vector inputs, like thumbstick movement for zooming.
:::

### Device Detection
Axis provides a simple way to check what device the player is currently using through `Axis.device()`. On desktop, mouse and keyboard inputs will return `"Desktop"`:
```lua
local device = Axis.device()
if device == "Desktop" then
    -- show keyboard/mouse prompts
end
```
This is useful for switching UI prompts or adjusting behavior depending on the player's current input device.