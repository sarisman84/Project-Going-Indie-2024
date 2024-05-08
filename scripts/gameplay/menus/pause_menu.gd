extends Control

var paused = false

func _ready():
	#Can do this under the inspector as well, under "Process"
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_menu()

func _on_resume_button_pressed():
	pass # Replace with function body.

func _on_restart_button_pressed():
	pass # Replace with function body.

func _on_settings_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	pass # Replace with function body.

func pause_menu():
	if paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		self.hide()
		get_tree().paused = false
	else:
		get_tree().paused = true
		self.show()
		$VBoxContainer/ResumeButton.grab_focus()
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	paused = !paused

func _input(event: InputEvent):
	## Checks for if the input device is mouse of joypad
	## Changes mouse visibilty accordingly
	if paused:
		if CheckInputDevice.get_input_type():
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
