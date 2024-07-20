extends Node

func draw_detected_target(target: AttackableNode, player : PlayerController, viewCheck : bool, losCheck : bool) -> void:
	var dir : Vector3 = (target.global_position - player.global_position)
	var color = Color.GAINSBORO
	if losCheck:
		color = Color.BLUE
	if viewCheck:
		color = Color.CYAN

	DebugDraw3D.draw_arrow_ray(player.global_position, dir.normalized(), dir.length(), color,0.25, true)

func draw_attackable_target(target: AttackableNode) -> void:
	DebugDraw3D.draw_sphere(target.global_position + Vector3.UP * 1.25, 0.5, Color.GREEN)

func display_attack_radius(owner : AttackManager) -> void:
	var col = owner.shape
	var data = col.shape as SphereShape3D
	DebugDraw3D.draw_sphere(owner.player.global_position, data.radius, Color.GREEN)


