extends Node
@onready var camera_controller : CameraController= $"../../camera_anchor"
@onready var indicator : CenterContainer = $indicator


func display_indicator_at(_target : AttackableNode) -> void:
	var cam3D = get_viewport().get_camera_3d()
	indicator.global_position = cam3D.unproject_position(_target.global_position) - indicator.size / 2.0
	indicator.visible = true
	pass

func _process(_delta : float) -> void:
	indicator.visible = false
