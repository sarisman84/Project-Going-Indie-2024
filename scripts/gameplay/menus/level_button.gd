extends Button

@export_file var level_path

func _on_pressed():
	if level_path == null:
		return
	else:
		get_tree().paused = false
		get_tree().change_scene_to_file(level_path)
