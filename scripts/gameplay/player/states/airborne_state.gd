extends PlayerState


func enter(msg: = {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = PlayerController.get_jump_velocity(player.jumpHeight, player.gravity)
		
func physics_update(delta: float) -> void:
	# Apply gravity
	player.velocity.y -= player.gravity * delta
	
	if player.is_on_floor():
		if player.velocity.length() > 0:
			state_machine.transition_to("moving")
		else:
			state_machine.transition_to("idle")
	
	# Get the user input
	var input_dir := Vector3.ZERO
	input_dir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) 
	input_dir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	
	var dir : Vector3
	# Transform it to be local to the camera's rotation
	dir = input_dir.rotated(Vector3.UP, player.camera.rotation.y)  #(camera.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# By default, use air acceleration & decceleration
	var acceleration = player.airAcceleration
	var decceleration = player.airDecceleration

	var speed = player.get_current_speed()
	
	# Apply acceleration & decceleration
	if dir:
		player.velocity.x = move_toward(player.velocity.x, dir.x * speed, acceleration)
		player.velocity.z = move_toward(player.velocity.z, dir.z * speed, acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, decceleration)
		player.velocity.z = move_toward(player.velocity.z, 0, decceleration)
	
	if player.model and player.velocity.length() > 0.2:
		#var local_dir = Vector2(velocity.z, velocity.x)
		#model.rotation.y = local_dir.angle()
		var horizontalVel = Vector3(player.velocity.x, 0, player.velocity.z)
		player.rotate_model_towards(horizontalVel, player.up_direction)
	
	# Apply calculations
	player.move_and_slide()
