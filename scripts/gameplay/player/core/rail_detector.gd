extends Area3D

var player: PlayerController
var found_rail_group: RailGroup


func init_detector(_player: PlayerController) -> void:
	player = _player

# Checks if the player is close enough to the rail
func is_player_close_to_curve(target_rail: Path3D) -> bool:
	if target_rail == null or target_rail.curve == null:
		return false

	#Get rail offset value based of the player's position
	var offset = Path3DUtilities.get_closest_offset(player.position, target_rail)

	#Get the closest global position from the rail offset.
	var closest_pos = Path3DUtilities.sample_baked_global(offset, true, target_rail) + found_rail_group.global_position
	#var closest_up = Path3DUtilities.sample_baked_up_vector_global(offset,true, self)


	var detection_radius = player.player_settings.rail_detection_radius
	var player_pos = player.global_position

	var dist = (closest_pos - player_pos).length()
	var result = dist < detection_radius

	var debug_color := Color.YELLOW
	if result:
		debug_color = Color.GREEN

	DebugDraw3D.draw_sphere(player_pos, detection_radius, Color.CYAN)
	DebugDraw3D.draw_arrow(player.global_position, closest_pos, debug_color, 0.25, true)

	return result


func _process(_delta: float) -> void:
	if found_rail_group == null:
		return

	for i in range(found_rail_group.rails.size()):
		var rail = found_rail_group.rails[i]
		if is_player_close_to_curve(rail):
			player.state_machine.transition_to("grinding", {index = i, rail_group = found_rail_group})
			return

func _on_body_entered(_body: Variant) -> void:
	if not _body is RailGroup:
		return
	found_rail_group = _body as RailGroup


func _on_body_exited(_body: Variant) -> void:
	if not _body is RailGroup:
		return
	found_rail_group = null
