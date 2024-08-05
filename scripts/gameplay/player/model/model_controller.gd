class_name ModelController
extends Node3D

func rotate_towards(delta : float, direction : Vector3, speed : float, _normal : Vector3, ) -> void:
	var target_pos = position - direction
	var new_transform = transform.looking_at(target_pos, _normal).orthonormalized()
	transform = transform.interpolate_with(new_transform, speed * delta)

	DebugDraw3D.draw_arrow_ray(global_position, direction, 2.0, Color.BLUE, 0.25, true)
	DebugDraw3D.draw_arrow_ray(global_position, _normal, 2.0, Color.RED, 0.25, true)
