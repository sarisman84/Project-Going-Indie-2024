extends Control

@export_file var start_scene : String
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file(start_scene)

##You'll need to program a seperate options menu before implemnting this function
func _on_settings_button_pressed():
	## Example code on how to call Settings Menu
	# var options = load("file path").instance()
	# get_tree().current_scene.add_child(options)
	pass # Delete when function is implemented

func _on_quit_button_pressed():
	get_tree().quit()
