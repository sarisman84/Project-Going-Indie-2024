extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://nodes/scenes/test_level.tscn")

##You'll need to program a seperate options menu before implemnting this function
func _on_settings_button_pressed():
	## Example code on how to call Settings Menu
	# var options = load("file path").instance()
	# get_tree().current_scene.add_child(options)
	pass # Delete when function is implemented

func _on_quit_button_pressed():
	get_tree().quit()
