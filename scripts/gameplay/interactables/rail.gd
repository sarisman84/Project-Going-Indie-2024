class_name Rail
extends Path3D

@export var hitbox : Area3D
@onready var model = $model

var detected_player : PlayerController

func _ready() -> void:
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	hitbox.body_exited.connect(_on_hitbox_body_exited)

func _on_hitbox_body_entered(body) -> void:
	if not body is PlayerController:
		return

	detected_player = body as PlayerController

func _on_hitbox_body_exited(_body) -> void:
	detected_player.state_machine.transition_to("airborne")
	detected_player = null


# Checks if the player is close enough to the rail
func is_player_close_to_curve() -> bool:
	if curve == null:
		return false

	#Get rail offset value based of the player's position
	var offset = Path3DUtilities.get_closest_offset(detected_player.position, self)

	#Get the closest global position from the rail offset.
	var closest_pos = Path3DUtilities.sample_baked_global(offset,true, self)
	#var closest_up = Path3DUtilities.sample_baked_up_vector_global(offset,true, self)


	var detection_radius = detected_player.player_settings.rail_detection_radius
	var player_pos = detected_player.global_position

	var dist = (closest_pos - player_pos).length()
	var result = dist < detection_radius

	var debug_color := Color.YELLOW
	if result:
		debug_color = Color.GREEN

	DebugDraw3D.draw_sphere(player_pos, detection_radius, Color.CYAN)
	DebugDraw3D.draw_position(Transform3D(basis, closest_pos), debug_color)

	return result

	# var offset = Path3DUtilities.get_closest_offset(detected_player.position, self)

	# var closestUp = curve.sample_baked_up_vector(offset, true)
	# var closestPosition = curve.sample_baked(offset,true) + position
	# DebugDraw3D.draw_sphere(closestPosition, 0.15, Color.CHARTREUSE)
	# var playerPosition = detected_player.position + closestUp * detected_player.collider.shape.radius

	# var dist = (closestPosition - playerPosition).length()
	# DebugDraw3D.draw_sphere(playerPosition , detected_player.player_settings.rail_detection_radius, Color.MAGENTA)
	# return dist < detected_player.player_settings.rail_detection_radius

func _process(_delta):
	if detected_player == null:
		return

	if is_player_close_to_curve() and not detected_player.state_machine.state is GrindState:
		detected_player.state_machine.transition_to("grinding", {rail = self})

#@onready var hitbox_collider = $hitbox/hitbox_collider
#@onready var hitbox = $hitbox

#var isPlayerDetected : bool
#var playerDirection : float
#var player : PlayerController
#var hasPlayerStartedGrinding : bool
#var railInCooldown : bool
#var grindPlayerState : GrindState


#func reset_cooldown():
	#railInCooldown = false
	#grindPlayerState.exitSignal.disconnect(reset_cooldown)
	#grindPlayerState = null
#
## Starts the grind state
#func on_grind_start():
	#player.state_machine.transition_to("grinding")
	## Get the GrindState and connect the exit signal to railCooldown reset logic
	#grindPlayerState = player.state_machine.state as GrindState
	#railInCooldown = true
	#grindPlayerState.exitSignal.connect(reset_cooldown)
	#
	#var offset = ExtendedUtilities.get_closest_offset(player.position, self)
	#var up = curve.sample_baked_up_vector(offset, true)
	#
	#set_player_pos_to_curve_offset(offset, up)
	#
	#isPlayerDetected = true
	#
	#var endingRailPos = position + curve.get_point_position(get_next_closest_point_index(player.position))
#
	#var dirToEnd = (endingRailPos - player.position).normalized()
#
	#var playerVelDir = player.velocity.normalized()
	#
	#DebugDraw3D.draw_arrow_ray(player.position, playerVelDir,1.0, Color.BLUE,0.15, false, 10.0)
	#DebugDraw3D.draw_arrow_ray(player.position, dirToEnd,1.0, Color.RED,0.15, false, 10.0)
#
	#if playerVelDir.dot(dirToEnd) > 0.0:
		#playerDirection = 0.1
	#else:
		#playerDirection = -0.1
	#print("Start grinding")
#
## Ends the grind state
#func on_grind_end():
	#player.up_direction = Vector3.UP
	#player.state_machine.transition_to("airborne")
	#print("Stop grinding")
	#
	#

	#

		#
#func _physics_process(_delta):
	#if not isPlayerDetected:
		#return
	#if grindPlayerState != null and not grindPlayerState.stateStarted:
		#return
	#if not player.state_machine.state is GrindState:
		#return
	## Get the current curve distance from the player position
	#var offset = ExtendedUtilities.get_closest_offset(player.position, self)
	## Sample a position based off the distance
	#var pos = curve.sample_baked(offset, true)
	#
	#var _playerDir = player.velocity.normalized()
	#var nextPos = curve.sample_baked(offset + playerDirection, true)
	## Get the forward direction from a sample with the user's intented direction
	#var forward = pos.direction_to(nextPos)
	## Sample the normal of the curve
	#var up = curve.sample_baked_up_vector(offset, true)
	#
	## If the forward direction is zero, it means that we have reached the end of the curve.
	#if forward == Vector3.ZERO:
		#on_grind_end()
		#return
	#
	## Apply some physics velocity, position and rotation based on the above calculations
	#player.up_direction = up
	#player.velocity = forward * player.get_current_speed()
	#player.rotate_model_towards_adv(forward, up)
	#player.global_position = (position + pos + (player.up_direction * player.collider.shape.radius)) + (forward * player.get_current_speed() * _delta)
#
	## Draw the calculated info
	#DebugDraw3D.draw_sphere(pos + position, 0.15, Color.YELLOW)
	#DebugDraw3D.draw_arrow_ray(pos + position, up, 2, Color.GREEN, 0.15)
	#DebugDraw3D.draw_arrow_ray(pos + position, forward, 0.25 * player.get_current_speed(), Color.BLUE, 0.15)
	#
	#
## Assuming the player is masked to layer 2,
## it should only detect the player
#func _on_hitbox_body_entered(body):
	#player = body as PlayerController
	#isPlayerDetected = true
#
## Same as above!
#func _on_hitbox_body_exited(body):
	#isPlayerDetected = false
	#DebugDraw3D.draw_sphere(body.position, 0.15, Color.RED, 10)
	#on_grind_end()
	#pass
#
#func get_closest_point_index(globalPosition : Vector3):
	#var minDist = 1.79769e308
	#var result : int
	#for i in range(0, curve.point_count):
		#var pointPos = position + curve.get_point_position(i)
		#var dist = (pointPos - globalPosition).length()
		#if minDist > dist:
			#minDist = dist
			#result = i
	#return result
#
#func get_next_closest_point_index(globalPosition : Vector3):
	#var closestPoint  = min(get_closest_point_index(globalPosition) + 1, curve.point_count - 1)
	#return closestPoint
#
#func set_player_pos_to_curve_offset(offset : float, upDirection : Vector3 = Vector3.UP):
	#var railPos = curve.sample_baked(offset, true)
	#var result = railPos + position
	#player.position = result
	#player.up_direction = upDirection
	#
	#DebugDraw3D.draw_sphere(result,0.15, Color.CHARTREUSE, 5.0)













