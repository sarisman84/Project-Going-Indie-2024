extends PlayerState

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg:= {}) -> void:
	player.velocity = Vector3.ZERO
	pass

func update(delta: float) -> void:
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
		state_machine.transition_to("moving")
