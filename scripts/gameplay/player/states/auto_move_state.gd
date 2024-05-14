class_name AutoMoveState
extends PlayerState

var currentRoad : CurvedRoad
var initMaxAngle : float

func enter(_msg:={}) -> void:
	if _msg.has("curved_road"):
		currentRoad = _msg["curved_road"]
		initMaxAngle = player.floor_max_angle
		player.floor_max_angle = deg_to_rad(360)
		
		

func snap_to_road(currentRoad : Path3D) -> void:
	var curve = currentRoad.curve
	# Figure out the closest position of the curve
	var offset = ExtendedUtilities.get_closest_offset(player.global_position, currentRoad)
	var position = curve.sample_baked(offset, true) + currentRoad.position
	player.position = position
	
	

func exit() -> void:
	currentRoad = null
	player.up_direction = Vector3.UP
	player.floor_max_angle = initMaxAngle
	pass
	
func update(_delta : float) -> void:
	if currentRoad == null:
		return
	var curve = currentRoad.curve
	
	var targetIndx = ExtendedUtilities.get_next_closest_point_index(player.global_position, currentRoad)
	var targetPos = curve.get_point_position(targetIndx) + currentRoad.global_position
	DebugDraw3D.draw_sphere(targetPos, 0.15, Color.RED)

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if currentRoad == null:
		return
	
	var curve = currentRoad.curve
	
	var offset = ExtendedUtilities.get_closest_offset(player.global_position, currentRoad)
	var nextOffset = ExtendedUtilities.get_closest_offset(player.global_position - player.model.basis.z, currentRoad)
	var normal = curve.sample_baked_up_vector(offset, true)
	var pos = curve.sample_baked(offset, true) + currentRoad.position
	var nextPos = curve.sample_baked(nextOffset, true) + currentRoad.position
	var forward = (pos - nextPos).normalized()
	var right = forward.cross(normal)
	
	
	
	DebugDraw3D.draw_sphere(nextPos, 0.15, Color.CRIMSON)
	
	DebugDraw3D.draw_arrow_ray(player.global_position, right, 1.0, Color.RED, 0.15, false, 3.0)
	DebugDraw3D.draw_arrow_ray(player.global_position, normal, 1.0, Color.GREEN, 0.15, false, 3.0)
	DebugDraw3D.draw_arrow_ray(player.global_position, forward, 1.0, Color.BLUE,0.15, false, 3.0)
	DebugDraw3D.draw_arrow_ray(player.global_position, - player.model.basis.z, 1.0, Color.DARK_BLUE,0.15, false, 3.0)
	
	var speed : float = player.movementSpeed
	
	if Input.is_action_pressed("boost"):
		speed = player.boostSpeed
	player.up_direction = normal
	
	PlayerController.calculate_auto_movement(player,  speed, forward, _delta)
	player.move_and_slide()
	player.apply_floor_snap()
