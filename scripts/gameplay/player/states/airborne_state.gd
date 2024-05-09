class_name AttackState
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
			
	# Calculate Movement
	player.calculate_movement(player.airAcceleration, player.airDecceleration)
	
	# Apply calculations
	player.move_and_slide()
