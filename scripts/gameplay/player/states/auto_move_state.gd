class_name AutoMoveState
extends PlayerState

@onready var move_sfx : AudioPlayer = $"../../sfx/move_sfx"

var currentRoad : CurvedRoad
var initMaxAngle : float
var playerPositionOffset : Vector3

func enter(_msg:={}) -> void:
	if _msg.has("curved_road"):
		currentRoad = _msg["curved_road"]
		initMaxAngle = player.floor_max_angle
		player.floor_max_angle = deg_to_rad(360)
		
		var offset = ExtendedUtilities.get_closest_offset(player.global_position, currentRoad)
		var pos = (currentRoad.basis.get_rotation_quaternion() * currentRoad.curve.sample_baked(offset, true)) + currentRoad.position
		
		playerPositionOffset = player.position - pos
		player.animation_player.play("run")
		
		

func snap_to_road(currentRoad : Path3D) -> void:
	var curve = currentRoad.curve
	# Figure out the closest position of the curve
	var offset = ExtendedUtilities.get_closest_offset(player.global_position, currentRoad)
	var position = (currentRoad.basis * curve.sample_baked(offset, true)) + currentRoad.position
	player.position = position
	
	

func exit() -> void:
	currentRoad = null
	player.up_direction = Vector3.UP
	player.floor_max_angle = initMaxAngle
	move_sfx.stop()
	pass
	
func update(_delta : float) -> void:
	if currentRoad == null:
		return
	var curve = currentRoad.curve
	
	var targetIndx = ExtendedUtilities.get_next_closest_point_index(player.global_position, currentRoad)
	var targetPos = (currentRoad.basis.get_rotation_quaternion() * curve.get_point_position(targetIndx)) + currentRoad.global_position
	DebugDraw3D.draw_sphere(targetPos, 0.15, Color.RED)
	move_sfx.adv_play()

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if currentRoad == null:
		return
	
	var curve = currentRoad.curve
	
	var offset = ExtendedUtilities.get_closest_offset(player.global_position, currentRoad)
	var nextOffset = ExtendedUtilities.get_closest_offset(player.global_position + player.model.basis.z, currentRoad)
	
	var pos = (currentRoad.basis.get_rotation_quaternion() * curve.sample_baked(offset, true)) + currentRoad.global_position
	var nextPos = (currentRoad.basis.get_rotation_quaternion() * curve.sample_baked(nextOffset, true)) + currentRoad.global_position
	
	var normal = currentRoad.basis.get_rotation_quaternion() *  curve.sample_baked_up_vector(offset, true)
	
	var alignedNextPos = nextPos + normal * player.collider.shape.radius
	var dir = (alignedNextPos - player.position).normalized()
	
	var forward = dir #(nextPos - pos).normalized()
	var right = forward.cross(normal).normalized()
	
	
	
	DebugDraw3D.draw_sphere(nextPos, 0.15, Color.CRIMSON, 10.0)
	
	DebugDraw3D.draw_arrow_ray(player.global_position, right, 1.0, Color.RED, 0.15, false, 3.0)
	DebugDraw3D.draw_arrow_ray(player.global_position, normal, 1.0, Color.GREEN, 0.15, false, 3.0)
	DebugDraw3D.draw_arrow_ray(player.global_position, forward, 1.0, Color.BLUE,0.15, false, 3.0)
	DebugDraw3D.draw_arrow_ray(player.global_position, player.model.basis.z, 1.0, Color.DARK_BLUE,0.15, false, 3.0)
	
	var speed  = player.get_current_speed()
	player.up_direction = normal
	
	PlayerController.calculate_auto_movement(player,  speed, forward, _delta)
	player.velocity -= player.up_direction * player.gravity
	# player.rotate_model_towards_adv(forward, player.up_direction)
	# player.velocity = forward * speed
	
	# player.global_position = (position + pos + (player.up_direction * player.collider.shape.radius)) + (forward * player.get_current_speed() * _delta)
	player.move_and_slide()
	player.apply_floor_snap()
