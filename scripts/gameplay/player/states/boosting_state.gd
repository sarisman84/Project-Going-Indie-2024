extends PlayerState

var left_step : bool
var right_step : bool
var countdown : float

func enter(msg := {}) -> void:
	player.rotate_model_towards(player.velocity.normalized(), player.up_direction)
	countdown = 0

func update(_delta : float) -> void:
	left_step = Input.is_action_pressed("left_step")
	right_step = Input.is_action_pressed("right_step")
	countdown -= _delta
	

func physics_update(delta : float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if not Input.is_action_pressed("boost"):
		if is_equal_approx(player.velocity.length(), 0):
			state_machine.transition_to("idle")
		else:
			state_machine.transition_to("moving")
		return 
	if not player.is_on_floor():
		state_machine.transition_to("airborne")
		return
	
	var can_step = (left_step or right_step) and countdown <= 0
	
	if can_step:
		var direction : float
		if left_step:
			direction = -1.0
		else:
			direction = 1.0
		
		var globalRight = Vector3.RIGHT.rotated(Vector3.UP, player.camera.rotation.y)
		var stepDir = globalRight.normalized() * direction * player.sideStepDistance
		player.global_position += stepDir
		countdown = player.sideStepCooldown
		 
	
	move_player(delta)
	
	if Input.is_action_pressed("jump"):
		state_machine.transition_to("airborne", {do_jump = true})
	elif is_equal_approx(player.velocity.length(), 0):
		state_machine.transition_to("idle")

func move_player(delta : float) -> void:
	# Calculate movement
	PlayerController.calculate_boost_movement(player, player.boostSpeed, player.boostAcceleration,player.turningSpeed,player.steeringAmountInDegrees, delta)
	# Apply calculations
	player.move_and_slide()

func exit() -> void:
	pass
