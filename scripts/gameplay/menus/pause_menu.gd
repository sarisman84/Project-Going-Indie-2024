extends Control

var paused = false

func _ready():
	#Can do this under the inspector as well, under "Process"
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_menu()

func _on_resume_button_pressed():
	pause_menu()

## TODO: Add confirmation menu at later date
func _on_restart_button_pressed():
	pause_menu()
	get_tree().reload_current_scene()

## TODO: Implement at later date
func _on_settings_button_pressed():
	$SettingsMenu.show()

## TODO: Add confirmation menu at later date
func _on_quit_button_pressed():
	get_tree().quit()

func pause_menu():
	if paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		self.hide()
		get_tree().paused = false
	else:
		get_tree().paused = true
		self.show()
		$VBoxContainer/ResumeButton.grab_focus()
	
	paused = !paused

func _input(event: InputEvent):
	## Checks for if the input device is mouse of joypad
	## Changes mouse visibilty accordingly
	if paused:
		if CheckInputDevice.get_input_type():
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
