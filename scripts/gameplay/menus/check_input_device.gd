class_name CheckInputDevice
extends Node

static var isMouse = true

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

##Should probably add for a deadzone check on the JoypadMotion,
##do to if you have stick drift, it will always detect this as true
func _input(event: InputEvent):
	## Checks for if the input device is mouse or joypad
	if InputEventMouseMotion && event.as_text().left(5) == "Mouse":
		isMouse = true
		print("mouse")
	elif (InputEventJoypadMotion or InputEventJoypadButton) && event.as_text().left(6) == "Joypad":
		isMouse = false
		print("joypad")

static func get_input_type():
	return isMouse
