@tool
extends Path3D

@export var hitboxAABB : AABB
@onready var model = $model
@onready var hitbox_collider = $hitbox/hitbox_collider
@onready var hitbox = $hitbox

var isPlayerDetected : bool
var playerDirection : float
var player : PlayerController
var hasPlayerStartedGrinding : bool


func get_global_aabb_center():
	return hitboxAABB.get_center() + position - (hitboxAABB.size / 2.0)

func get_global_aabb_start():
	return hitboxAABB.position + position - (hitboxAABB.size / 2.0)
	
func get_global_aabb_end():
	return hitboxAABB.end + position - (hitboxAABB.size / 2.0)

func _ready():
	hitbox_collider.global_position = get_global_aabb_center()
	var box_shape := BoxShape3D.new()
	box_shape.size = hitboxAABB.size
	hitbox_collider.shape = box_shape
	
	hitbox.connect("body_entered", _on_hitbox_body_entered)
	hitbox.connect("body_exited", _on_hitbox_body_exited)

# Starts the grind state
func on_grind_start():
	if player.currentState == PlayerController.States.Grinding:
		return
	player.currentState = PlayerController.States.Grinding
	var offset = get_closest_offset(player.position)
	var up = curve.sample_baked_up_vector(offset, true)
	
	set_player_pos_to_curve_offset(offset, up)
	
	player.set_default_controls(false)
	isPlayerDetected = true
	
	var endingRailPos = position + curve.get_point_position(get_next_closest_point_index(player.position))

	var dirToEnd = (endingRailPos - player.position).normalized()

	var playerVelDir = player.velocity.normalized()
	
	DebugDraw3D.draw_arrow_ray(player.position, playerVelDir,1.0, Color.BLUE,0.15, false, 10.0)
	DebugDraw3D.draw_arrow_ray(player.position, dirToEnd,1.0, Color.RED,0.15, false, 10.0)

	if playerVelDir.dot(dirToEnd) > 0.0:
		playerDirection = 0.1
	else:
		playerDirection = -0.1
	print("Start grinding")

# Ends the grind state
func on_grind_end():
	player.up_direction = Vector3.UP
	player.set_default_controls(true)
	player.move_and_slide()
	print("Stop grinding")
	player.currentState = PlayerController.States.StoppedGrinding
	
func _process(_delta):
	DebugDraw3D.draw_aabb_ab(get_global_aabb_start(), get_global_aabb_end(),Color.CYAN)
	DebugDraw3D.draw_sphere(get_global_aabb_center(),0.15, Color.YELLOW)
	
	if not isPlayerDetected:
		return
	if player.currentState == PlayerController.States.StoppedGrinding:
		return
	if is_player_close_to_curve() and player.currentState != PlayerController.States.Grinding:
		on_grind_start()
	
# Checks if the player is close enough to the rail
func is_player_close_to_curve():
	var offset = get_closest_offset(player.position)
	
	var closestPosition = curve.sample_baked(offset,true) + position
	DebugDraw3D.draw_sphere(closestPosition, 0.15, Color.CHARTREUSE)
	var dist = (closestPosition - player.position).length()
	return dist < player.railDetectionRadius / 2.0
		
func _physics_process(_delta):
	if not isPlayerDetected:
		return
	if not player.currentState == PlayerController.States.Grinding:
		return
	# Get the current curve distance from the player position
	var offset = get_closest_offset(player.position)
	# Sample a position based off the distance
	var pos = curve.sample_baked(offset, true)
	
	var _playerDir = player.velocity.normalized()
	
	# Get the forward direction from a sample with the user's intented direction
	var forward = pos.direction_to(curve.sample_baked(offset + playerDirection, true))
	# Sample the normal of the curve
	var up = curve.sample_baked_up_vector(offset, true)
	
	# If the forward direction is zero, it means that we have reached the end of the curve.
	if forward == Vector3.ZERO:
		on_grind_end()
		return
	
	# Apply some physics velocity and rotation based on the above calculations
	player.velocity = forward * player.get_current_speed()
	player.move_and_slide()
	player.rotate_model_towards(forward, up)

	# Draw the calculated info
	DebugDraw3D.draw_sphere(pos + position, 0.15, Color.YELLOW)
	DebugDraw3D.draw_arrow_ray(pos + position, up, 2, Color.GREEN, 0.15)
	DebugDraw3D.draw_arrow_ray(pos + position, forward, 0.25 * player.get_current_speed(), Color.BLUE, 0.15)
	
	
# Assuming the player is masked to layer 2,
# it should only detect the player
func _on_hitbox_body_entered(body):		
	player = body as PlayerController
	isPlayerDetected = true

# Same as above!
func _on_hitbox_body_exited(body):
	isPlayerDetected = false
	DebugDraw3D.draw_sphere(body.position, 0.15, Color.RED, 10)
	pass

func get_closest_offset(globalPosition : Vector3):
	var localPosition = globalPosition - position
	return curve.get_closest_offset(localPosition)

func get_closest_point_index(globalPosition : Vector3):
	var minDist = 1.79769e308
	var result : int
	for i in range(0, curve.point_count):
		var pointPos = position + curve.get_point_position(i)
		var dist = (pointPos - globalPosition).length()
		if minDist > dist:
			minDist = dist
			result = i
	return result

func get_next_closest_point_index(globalPosition : Vector3):
	var closestPoint  = min(get_closest_point_index(globalPosition) + 1, curve.point_count - 1)
	return closestPoint

func set_player_pos_to_curve_offset(offset : float, upDirection : Vector3 = Vector3.UP):
	var railPos = curve.sample_baked(offset, true)
	var result = railPos + position
	player.position = result
	player.up_direction = upDirection
	
	DebugDraw3D.draw_sphere(result,0.15, Color.CHARTREUSE, 5.0)


	

