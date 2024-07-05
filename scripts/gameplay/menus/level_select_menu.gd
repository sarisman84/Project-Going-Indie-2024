extends Control

var paused = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_back_button_pressed():
	if paused == true:
		pause_menu()

func pause_menu():
	if paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		self.hide()
		get_tree().paused = false
	else:
		get_tree().paused = true
		self.show()
		$MarginContainer/VBoxContainer/BackButton.grab_focus()

	paused = !paused

func _input(event: InputEvent):
	## Checks for if the input device is mouse of joypad
	## Changes mouse visibilty accordingly
	if paused:
		if CheckInputDevice.get_input_type():
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
