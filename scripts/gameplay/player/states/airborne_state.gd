class_name AttackState
extends PlayerState

var isStomping : bool


func enter(msg: = {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = PlayerController.get_jump_velocity(player.jumpHeight, player.gravity)
	isStomping = false
		
func physics_update(delta: float) -> void:
	# Apply gravity
	player.velocity.y -= player.gravity * delta
	
	if player.is_on_floor():
		if player.velocity.length() > 0:
			if Input.is_action_pressed("boost"):
				state_machine.transition_to("boosting")
			else:
				state_machine.transition_to("moving")
		else:
			state_machine.transition_to("idle")
	
	if Input.is_action_just_pressed("slide"):
		isStomping = true
		player.velocity = Vector3.ZERO
	
	if !isStomping:	
		# Calculate Movement
		PlayerController.calculate_movement(player, player.movementSpeed, player.airDelta.y, player.airDelta.x)
	else:
		player.velocity -= Vector3.UP * player.stompSpeed * delta
	
	# Apply calculations
	player.move_and_slide()
