@tool
extends Node

@onready var rail : Rail = $".."

func get_global_aabb_center():
	return rail.hitboxAABB.get_center() + rail.position - (rail.hitboxAABB.size / 2.0)

func get_global_aabb_start():
	return rail.hitboxAABB.position + rail.position - (rail.hitboxAABB.size / 2.0)
	
func get_global_aabb_end():
	return rail.hitboxAABB.end + rail.position - (rail.hitboxAABB.size / 2.0)

func _process(delta : float) -> void:
	DebugDraw3D.draw_aabb_ab(get_global_aabb_start(), get_global_aabb_end(),Color.CYAN)
	DebugDraw3D.draw_sphere(get_global_aabb_center(),0.15, Color.YELLOW)
