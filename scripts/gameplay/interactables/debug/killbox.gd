class_name KillBox3D
extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_player_enter)
	pass # Replace with function body.

func on_player_enter(body) -> void:
	get_tree().reload_current_scene()

