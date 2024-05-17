class_name Goal3D
extends Area3D

@export var target_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_player_enter)
	pass # Replace with function body.

func on_player_enter(body) -> void:
	if not body is PlayerController:
		return
	get_tree().change_scene_to_packed(target_scene)
