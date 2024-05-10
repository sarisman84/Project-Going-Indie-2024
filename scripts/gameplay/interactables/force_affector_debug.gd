@tool
extends Node
@onready var force_affector = $".."

func _process(_delta : float) -> void:
	DebugDraw3D.draw_arrow_ray(force_affector.global_position, force_affector.forceDirection.normalized(), 1.0, Color.SKY_BLUE,0.15,true)
	pass
