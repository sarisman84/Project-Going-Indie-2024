extends Area3D

var player : PlayerController

func init_detector(_player : PlayerController) -> void:
	player = _player

# Checks if the player is close enough to the rail
func is_player_close_to_curve(target_rail : Path3D) -> bool:
	if target_rail == null or target_rail.curve == null:
		return false

	#Get rail offset value based of the player's position
	var offset = Path3DUtilities.get_closest_offset(player.position, target_rail)

	#Get the closest global position from the rail offset.
	var closest_pos = Path3DUtilities.sample_baked_global(offset,true, target_rail)
	#var closest_up = Path3DUtilities.sample_baked_up_vector_global(offset,true, self)


	var detection_radius = player.player_settings.rail_detection_radius
	var player_pos = player.global_position

	var dist = (closest_pos - player_pos).length()
	var result = dist < detection_radius

	var debug_color := Color.YELLOW
	if result:
		debug_color = Color.GREEN

	DebugDraw3D.draw_sphere(player_pos, detection_radius, Color.CYAN)
	DebugDraw3D.draw_position(Transform3D(basis, closest_pos), debug_color)

	return result



func _ready() -> void:
	var rails = RailRegistry.get_collection()
	for i in range(rails.size()):
		var r = rails[i]
		if is_player_close_to_curve(r)and not player.state_machine.state is GrindState:
			player.state_machine.transition_to("grinding", {rail = r})
