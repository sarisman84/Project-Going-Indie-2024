class_name Control3D
extends Control

func _process(_delta):
	var p = get_parent() as Node3D
	if not p:
		return
	var cam3D = get_viewport().get_camera_3d()
	global_position = cam3D.unproject_position(p.global_position) - size / 2.0
	visible = not cam3D.is_position_behind(p.global_position)

