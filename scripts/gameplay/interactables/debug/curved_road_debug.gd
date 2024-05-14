@tool
class_name CurveRoadDebug
extends Node
@onready var curved_road : CurvedRoad = $".."


func _process(delta : float) -> void:
	DebugDraw3D.draw_aabb_ab(ExtendedUtilities.get_global_aabb_start(curved_road.hitboxAABB, curved_road), ExtendedUtilities.get_global_aabb_end(curved_road.hitboxAABB, curved_road),Color.CYAN)
	DebugDraw3D.draw_sphere(ExtendedUtilities.get_global_aabb_center(curved_road.hitboxAABB, curved_road),0.15, Color.YELLOW)



