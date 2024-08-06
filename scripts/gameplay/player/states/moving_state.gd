class_name MoveState
extends PlayerState

@onready var move_sfx : AudioPlayer = $"../../sfx/move_sfx"

func enter(_msg := {}) -> void:
	player.can_air_boost = true
	player.current_jump_count = player.player_settings.jump_count
	player.animation_player.play("run")

func exit() -> bool:
	move_sfx.stop()
	return true

func update(_delta : float ) -> void:
	move_sfx.adv_play()
	DebugDraw2D.set_text("player velocity: ", player.velocity,0, Color.RED)
	DebugDraw2D.set_text("player velocity length: ", player.velocity.length(),0, Color.RED)


func physics_update(delta: float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if Input.is_action_pressed("boost") and player.player_settings.can_boost and player.boost_energy > 0:
		state_machine.transition_to("boosting")
		return
	if not player.is_on_floor():
		state_machine.transition_to("airborne")
		return

	#move_player(delta)
	player.move(delta)

	if Input.is_action_just_pressed("jump") and player.current_jump_count > 0 and player.player_settings.can_jump:
		state_machine.transition_to("airborne", {do_jump = true})
	elif player.velocity.length() <= 1.5 and is_equal_approx(directionalInput.length(), 0):
		state_machine.transition_to("idle")

	# Calculate movement
	# PlayerController.calculate_movement(player, player.movementSpeed,player.groundDelta.y, player.groundDelta.x, _delta)
	# Apply calculations
	# player.move_and_slide()
	# player.apply_floor_snap()
