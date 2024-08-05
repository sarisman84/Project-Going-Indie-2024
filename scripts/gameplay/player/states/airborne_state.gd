class_name AttackState
extends PlayerState

@onready var jump_sfx : AudioStreamPlayer3D = $"../../sfx/jump_sfx"
@onready var wind_sfx : AudioStreamPlayer3D = $"../../sfx/boost/wind_sfx"

var isStomping : bool
var onJumpTransitionDelay : float = 0.1
var countdown : float


func enter(msg: = {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = ExtendedUtilities.convert_height_to_velocity(player.player_settings.jumpHeight, player.gravity)
		player.currentJumpCount -= 1
		countdown = onJumpTransitionDelay
		jump_sfx.play()
	isStomping = false
	wind_sfx.play()

func exit() -> bool:
	wind_sfx.stop()
	return true

func update(delta : float) -> void:
	countdown -= delta

func physics_update(delta: float) -> void:
	if countdown <= 0:
		if player.is_on_floor():
			if player.velocity.length() > 0:
				# if Input.is_action_pressed("boost"):
				# 	state_machine.transition_to("boosting")
				# else:
				state_machine.transition_to("moving")
			else:
				state_machine.transition_to("idle")
		elif !isStomping:
			# if Input.is_action_just_pressed("boost") and player.canAirBoost:
			# 	player.velocity = player.model.transform.basis.z * player.boostSpeed
			# 	player.canAirBoost = false
			if Input.is_action_just_pressed("jump") and player.currentJumpCount > 0:
				state_machine.transition_to("airborne", {do_jump = true})

		if Input.is_action_just_pressed("slide"):
			isStomping = true
			player.velocity = Vector3.ZERO

	if !isStomping:
		# Calculate Movement
		# PlayerController.calculate_movement(player, player.movement_speed, player.airDelta.y, player.airDelta.x, delta)
		player.air_move(delta)
	else:
		player.velocity -= Vector3.UP * player.stompSpeed * delta
