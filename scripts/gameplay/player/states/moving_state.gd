extends PlayerState

func physics_update(delta: float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if Input.is_action_pressed("boost"):
		state_machine.transition_to("boosting")
		return
	if not player.is_on_floor():
		state_machine.transition_to("airborne")
		return
		
	move_player(delta)
	
	if Input.is_action_pressed("jump"):
		state_machine.transition_to("airborne", {do_jump = true})
	elif is_equal_approx(player.velocity.length(), 0):
		state_machine.transition_to("idle")
	
	
func move_player(delta : float) -> void:
	# Calculate movement
	PlayerController.calculate_movement(player, player.movementSpeed,player.groundDelta.y, player.groundDelta.x)
	# Apply calculations
	player.move_and_slide()
