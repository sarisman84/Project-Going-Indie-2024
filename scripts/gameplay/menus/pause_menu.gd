extends Control

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/ResumeButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		Engine.time_scale = 1
	else:
		self.show()
		$VBoxContainer/ResumeButton.grab_focus()
		Engine.time_scale = 0
	
	paused = !paused
