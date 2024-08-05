extends Node
@export var toggle_debug : bool

func draw_detected_target(target: AttackableNode, player : PlayerController, viewCheck : bool, losCheck : bool) -> void:
	if not toggle_debug:
		return
	var dir : Vector3 = (target.global_position - player.global_position)
	var color = Color.GAINSBORO
	if losCheck:
		color = Color.BLUE
	if viewCheck:
		color = Color.CYAN

	DebugDraw3D.draw_arrow_ray(player.global_position, dir.normalized(), dir.length(), color,0.25, true)

func draw_attackable_target(target: AttackableNode) -> void:
	if not toggle_debug:
		return
	DebugDraw3D.draw_sphere(target.global_position + Vector3.UP * 1.25, 0.5, Color.GREEN)

func display_attack_radius(owner : AttackManager) -> void:
	if not toggle_debug:
		return
	var col = owner.shape
	var data = col.shape as SphereShape3D
	DebugDraw3D.draw_sphere(owner.player.global_position, data.radius, Color.GREEN)

func display_view_angle(owner: AttackManager) -> void:
	if not toggle_debug:
		return
#
	#var forward = -owner.camera_controller.camera_anchor.basis.z.normalized()
	#var position = owner.camera_controller.physical_camera.global_position
	#DebugDraw3D.draw_sphere(position + forward, owner.detectionAngle, Color.CADET_BLUE)


