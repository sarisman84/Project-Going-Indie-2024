@tool
class_name AlignNode3D
extends Node3D
@export var show_debug : bool = true

var camera : Camera3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var p = get_parent_node_3d()
	if show_debug:
		DebugDraw3D.draw_sphere(p.global_position, 0.15, Color.YELLOW)
		DebugDraw3D.draw_line(p.global_position, global_position, Color.GREEN)
		DebugDraw3D.draw_arrow_ray(global_position, -global_basis.z, 1.0, Color.BLUE, 0.15)

		if camera:
			DebugDraw3D.draw_camera_frustum(camera, Color.AQUA)
	pass
