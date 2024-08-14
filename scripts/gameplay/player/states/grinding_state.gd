class_name GrindState
extends PlayerState

@onready var grind_sfx: AudioStreamPlayer3D = $"../../sfx/grind/grind_sfx"
@onready var grind_start_sfx: AudioStreamPlayer3D = $"../../sfx/grind/grind_start_sfx"

@export var exitDelayInSeconds: float = 0.2
var curDelay: float
var stateEnded: bool

var index: int
var playerDirection: float
var rail_group: RailGroup

func enter(_msg := {}) -> void:
	# stateStarted = true
	player.animation_player.play("grind")
	grind_start_sfx.play()
	grind_sfx.play()
	rail_group = _msg["rail_group"]
	index = _msg["index"]
	stateEnded = false
	on_grind_start()

func update(delta: float) -> void:
	if stateEnded:
		curDelay -= delta
		return

	# Rail Jumping
	if Input.is_action_pressed("jump"):
		state_machine.transition_to("airborne", {do_jump = true})

	# Rail Switching
	if rail_group.links.is_empty():
		return
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if x_input < 0:
		index = rail_group.links[index]["left"]
	elif x_input > 0:
		index = rail_group.links[index]["right"]


func physics_update(_delta: float) -> void:
	if stateEnded:
		return
	var rail = rail_group.rails[index]
	var offset = Path3DUtilities.get_closest_offset(player.position, rail)
	var pos = Path3DUtilities.sample_baked_global(offset, true, rail) # rail.curve.sample_baked(offset, true)

	var nextPos = Path3DUtilities.sample_baked_global(offset + playerDirection, true, rail)

	var forward = pos.direction_to(nextPos)

	var up = Path3DUtilities.sample_baked_up_vector_global(offset, true, rail)

	if forward == Vector3.ZERO:
		state_machine.transition_to("airborne")
		return

	player.up_direction = up
	player.velocity = forward * player.get_current_speed()
	#player.rotate_model_towards_adv(forward, up)
	player.model_anchor.rotate_towards_with_interpolation(_delta, forward, 100, up)
	player.global_position = (rail_group.position + pos + (player.up_direction * player.collider.shape.radius)) + (forward * player.get_current_speed() * _delta)

	DebugDraw3D.draw_sphere(pos + rail_group.position, 0.15, Color.YELLOW)
	DebugDraw3D.draw_arrow_ray(pos + rail_group.position, up, 2, Color.GREEN, 0.15)
	DebugDraw3D.draw_arrow_ray(pos + rail_group.position, forward, 0.25 * player.get_current_speed(), Color.BLUE, 0.15)

func on_grind_start() -> void:
	var rail = rail_group.rails[index]
	var offset = Path3DUtilities.get_closest_offset(player.position, rail, true)
	var up = Path3DUtilities.sample_baked_up_vector_global(offset, true, rail)

	set_player_pos_to_curve_offset(offset, up)

	var endingRailPos = Path3DUtilities.get_global_point_position(Path3DUtilities.get_next_closest_point_index(player.position, rail), rail) + rail_group.position
	var dirToEnd = (endingRailPos - player.position).normalized()
	var playerVelDir = player.velocity.normalized()

	DebugDraw3D.draw_sphere(endingRailPos, 0.25, Color.RED, 10)

	DebugDraw3D.draw_arrow_ray(player.position, playerVelDir, 1.0, Color.BLUE, 0.15, false, 10.0)
	DebugDraw3D.draw_arrow_ray(player.position, dirToEnd, 1.0, Color.RED, 0.15, false, 10.0)

	if playerVelDir.dot(dirToEnd) > 0.0:
		playerDirection = 0.1
	else:
		playerDirection = -0.1
	print("Start grinding")

func on_grind_end() -> void:
	player.up_direction = Vector3.UP
	grind_sfx.stop()
	stateEnded = true

func set_player_pos_to_curve_offset(offset: float, upDirection: Vector3 = Vector3.UP):
	var rail = rail_group.rails[index]
	var railPos = Path3DUtilities.sample_baked_global(offset, true, rail) # rail.curve.sample_baked(offset, true)
	var result = railPos + rail_group.position
	player.position = result
	player.up_direction = upDirection

	DebugDraw3D.draw_sphere(result, 0.15, Color.CHARTREUSE, 5.0)

func stop_grinding() -> void:
	stateEnded = true
	curDelay = exitDelayInSeconds
	grind_sfx.stop()
	# stateStarted = false
	# curDelay = exitDelayInSeconds
	player.up_direction = Vector3.UP
	# print("exited")
	state_machine.transition_to("airborne")

func exit() -> bool:
	on_grind_end()
	return true
