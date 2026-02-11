--!strict
--[=[
    @within Axis
    @type DeviceType "Desktop" | "Touch" | "Controller"
]=]
export type DeviceType = "Desktop" | "Touch" | "Controller"

--[=[
    @within Axis
    @type Map<T> { [Enum | string]: T } & { Enum.KeyCode | Enum.UserInputType }
]=]
export type Map<T> = { [any]: T } | { [number]: any }

export type Input<T> = {
    read: (Input<T>, controller: number?) -> (T, T),
    pressing: (Input<T>, controller: number?) -> boolean,
    pressed: (Input<T>, controller: number?) -> boolean,
    released: (Input<T>, controller: number?) -> boolean,
    changed: (Input<T>, controller: number?) -> boolean,
    hold: (Input<T>, value: T?, controller: number?) -> () -> (),
    move: (Input<T>, value: T, controller: number?) -> (),
    map: (Input<T>, keyMap: Map<T>) -> nil,
    update: (Input<T>) -> nil,

    deadzone: number?,
    vector: boolean?,
    current: { T },
    previous: { T },
    active: { { [any]: T } },
    resets: { [any]: { any } },
    connections: { any },
    keyMap: Map<T>,
    inputMap: { [any]: T },
}

export type InputConstructor = <T>(Map<T> | (Map<T> & { deadzone: number? })) -> Input<T>

export type Axis = {
    device: (any?) -> DeviceType,
    update: (inputs: { [any]: Input<any> } ) -> nil,
    clear: (any) -> nil,
    input: InputConstructor,
}

return {}