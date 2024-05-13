@tool
extends Node

@onready var rail : Rail = $".."


func _process(delta : float) -> void:
	DebugDraw3D.draw_aabb_ab(ExtendedUtilities.get_global_aabb_start(rail.hitboxAABB, rail), ExtendedUtilities.get_global_aabb_end(rail.hitboxAABB, rail),Color.CYAN)
	DebugDraw3D.draw_sphere(ExtendedUtilities.get_global_aabb_center(rail.hitboxAABB, rail),0.15, Color.YELLOW)
