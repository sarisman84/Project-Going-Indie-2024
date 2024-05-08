class_name CheckInputDevice
extends Node

static var isMouse = true

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent):
	## Checks for if the input device is mouse or joypad
	if event is InputEventMouseMotion: 
		isMouse = true
	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion && deadzone_check(event)):
		isMouse = false

func deadzone_check(event : InputEvent):
	var deadzone = 0.5
	var joystick_vector = Vector2(Input.get_joy_axis(0, 0), -Input.get_joy_axis(0, 1)).length()
	return deadzone < joystick_vector

static func get_input_type():
	return isMouse
