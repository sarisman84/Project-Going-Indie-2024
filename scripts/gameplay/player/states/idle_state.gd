extends PlayerState

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg:= {}) -> void:
	player.velocity = Vector3.ZERO
	player.canAirBoost = true
	player.currentJumpCount = player.jumpCount
	pass

func update(_delta: float) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	if not player.is_on_floor():
		state_machine.transition_to("airborne")
		return
	
	if Input.is_action_pressed("jump"):
		# As we'll only have one air state for both jump and fall, we use the `msg` dictionary 
		# to tell the next state that we want to jump.
		state_machine.transition_to("airborne", {do_jump = true})
	elif directionalInput.length() > 0:
		if Input.is_action_pressed("boost"):
			state_machine.transition_to("boosting")
		else:
			state_machine.transition_to("moving")
