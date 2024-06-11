class_name MoveState
extends PlayerState

@onready var move_sfx : AudioPlayer = $"../../sfx/move_sfx"

func enter(_msg := {}) -> void:
	player.canAirBoost = true
	player.currentJumpCount = player.jumpCount
	player.animation_player.play("run")

func exit() -> bool:
	move_sfx.stop()
	return true

func update(delta : float ) -> void:
	move_sfx.adv_play()
	DebugDraw2D.set_text("player velocity: ", player.velocity,0, Color.RED)
	DebugDraw2D.set_text("player velocity length: ", player.velocity.length(),0, Color.RED)
	

func physics_update(delta: float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if Input.is_action_pressed("boost") and player.canBoost:
		state_machine.transition_to("boosting")
		return
	if not player.is_on_floor():
		state_machine.transition_to("airborne")
		return
		
	move_player(delta)
	
	if Input.is_action_just_pressed("jump") and player.currentJumpCount > 0 and player.canJump:
		state_machine.transition_to("airborne", {do_jump = true})
	elif player.velocity.length() <= 1.5 and is_equal_approx(directionalInput.length(), 0):
		state_machine.transition_to("idle")
	
	
func move_player(_delta : float) -> void:
	# Calculate movement
	PlayerController.calculate_movement(player, player.movementSpeed,player.groundDelta.y, player.groundDelta.x, _delta)
	# Apply calculations
	player.move_and_slide()
