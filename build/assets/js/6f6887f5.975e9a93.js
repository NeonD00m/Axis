"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[729],{7012:e=>{e.exports=JSON.parse('{"functions":[{"name":"read","desc":"Reads current and previous values for the axis\\n```lua\\nlocal current, previous = attack:read()  \\n```","params":[{"name":"controller","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"T, T"}],"function_type":"method","source":{"line":54,"path":"src/input.luau"}},{"name":"pressing","desc":"Gets whether the axis has any active input","params":[{"name":"controller","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":66,"path":"src/input.luau"}},{"name":"changed","desc":"Gets whether an axis has changed since the last update","params":[{"name":"controller","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":79,"path":"src/input.luau"}},{"name":"pressed","desc":"Gets whether the axis was activated this update","params":[{"name":"controller","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":90,"path":"src/input.luau"}},{"name":"released","desc":"Gets whether the axis was deactivated this update","params":[{"name":"controller","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":101,"path":"src/input.luau"}},{"name":"hold","desc":"Adds a temporary manual input to the axis, and provides a function to release it\\n```lua\\nlocal release = attack:hold(1) -- adds 1 to the axis\\n--release later\\nrelease() -- removes the added value\\n```","params":[{"name":"value","desc":"","lua_type":"T"},{"name":"controller","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"() -> ()"}],"function_type":"method","source":{"line":118,"path":"src/input.luau"}},{"name":"move","desc":"Adds an input to the axis for a single frame","params":[{"name":"value","desc":"","lua_type":"T"},{"name":"controller","desc":"","lua_type":"number?"}],"returns":[],"function_type":"method","source":{"line":134,"path":"src/input.luau"}},{"name":"map","desc":"Maps input types to an input axis\\n```lua\\nattack:map {\\n\\tEnum.KeyCode.Q,\\n\\tEnum.KeyCode.ButtonA,\\n}\\n-- or to clear all input mappings\\nattack:map {}\\n```","params":[{"name":"keyMap","desc":"","lua_type":"Map<T>"}],"returns":[],"function_type":"method","source":{"line":156,"path":"src/input.luau"}},{"name":"update","desc":"Updates the current and previous values of the input axis","params":[],"returns":[],"function_type":"method","source":{"line":267,"path":"src/input.luau"}}],"properties":[],"types":[],"name":"Input","desc":"The Input class used to define input axes","source":{"line":7,"path":"src/input.luau"}}')}}]);