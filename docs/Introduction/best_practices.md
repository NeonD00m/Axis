---
title: Best Practices
description: Recommended practices for using Axis
sidebar_position: 2
---

# Best Practices

You have two main options while using Axis, you can either collect all your input axes in a single module for other systems to require, or you can define them in the systems that need them (may create redundancy).
```lua
local inputDelta = Axis.input {
    Enum.UserInputType.MouseMovement,
    [Enum.KeyCode.Thumbstick1] = 20,
}
local function camera()
...
end
```
OR
```lua
local inputMap = {
    inputDelta = Axis.input {
        Enum.UserInputType.MouseMovement,
        [Enum.KeyCode.Thumbstick1] = 20,
    },
    attack = Axis.input {
        Enum.KeyCode.E,
        Enum.KeyCode.ButtonA,
    },
    block = Axis.input {
        Enum.KeyCode.F,
    },
}
return inputMap
```
Of course you can do something in between but we have found that containing all the input axes in a single module is the best option, since it allows us to easily access all of them in other systems (see mobileInput.luau and camera.luau in the example game).

<br/>
<br/>