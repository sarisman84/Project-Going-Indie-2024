extends PlayerState

func physics_update(delta: float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if not player.is_on_floor():
		state_machine.transition_to("airborne")
		return
		
	move_player(delta)
	
	if Input.is_action_pressed("jump"):
		state_machine.transition_to("airborne", {do_jump = true})
	elif is_equal_approx(player.velocity.length(), 0):
		state_machine.transition_to("idle")
	
	
func move_player(delta : float) -> void:
	# Get the user input
	var input_dir := Vector3.ZERO
	input_dir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) 
	input_dir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	input_dir = input_dir.normalized()
	
	var dir : Vector3
	
	# Transform it to be local to the camera's rotation
	dir = input_dir.rotated(Vector3.UP, player.camera.rotation.y)  #(camera.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# By default, use ground acceleration & decceleration
	var acceleration = player.groundAcceleration
	var decceleration = player.groundDecceleration
	
	## Use air acceleration & decceleration if not on the floor
	#if not is_on_floor():
		#acceleration = airAcceleration
		#decceleration = airDecceleration
		
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
