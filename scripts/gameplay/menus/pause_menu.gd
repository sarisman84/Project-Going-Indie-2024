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
		self.hide()
		get_tree().paused = false
		#Engine.time_scale = 1
	else:
		get_tree().paused = true
		self.show()
		$VBoxContainer/ResumeButton.grab_focus()
		#Engine.time_scale = 0
	
	paused = !paused

##This function will disable all the inputs for in-game actions
func disable_game_input():
	pass
