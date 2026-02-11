type EnumItem = {
	Name: string,
	Value: number
}

type KeyCode = EnumItem
type UserInputType = EnumItem

declare Enum: {
	KeyCode: { [string]: KeyCode },
	UserInputType: { [string]: UserInputType },
	[string]: { [string]: EnumItem }
}

declare game: any
declare vector: any
declare UserInputService: any
declare pcall: any
declare _G: any
declare print: any
declare assert: any
declare type: any
declare typeof: any
declare error: any
declare next: any
declare unpack: any
declare script: any
declare task: any
declare loadfile: any
