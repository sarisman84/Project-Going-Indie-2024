class_name ModelController
extends Node3D

func rotate_towards(direction : Vector3, _normal : Vector3) -> void:
	self.look_at(global_position - direction, _normal)
	DebugDraw3D.draw_arrow_ray(global_position, direction, 2.0, Color.BLUE, 0.25, true)
	DebugDraw3D.draw_arrow_ray(global_position, _normal, 2.0, Color.RED, 0.25, true)
