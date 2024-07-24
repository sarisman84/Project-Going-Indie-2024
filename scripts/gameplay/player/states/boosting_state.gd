extends PlayerState

@onready var move_sfx : AudioPlayer = $"../../sfx/move_sfx"
@onready var boost_sfx : AudioStreamPlayer3D = $"../../sfx/boost/boost_sfx"
@onready var wind_sfx : AudioStreamPlayer3D = $"../../sfx/boost/wind_sfx"


var left_step : bool
var right_step : bool
var countdown : float

func enter(_msg := {}) -> void:
	player.rotate_model_towards_adv(player.velocity.normalized(), Vector3.UP)
	countdown = 0
	player.canAirBoost = true
	player.currentJumpCount = player.jumpCount

func update(_delta : float) -> void:
	left_step = Input.is_action_pressed("left_step")
	right_step = Input.is_action_pressed("right_step")
	countdown -= _delta
	move_sfx.adv_play()


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
			direction = 1.0
		else:
			direction = -1.0

		var globalRight = player.model.transform.basis.x
		var stepDir = globalRight.normalized() * direction * player.sideStepDistance
		player.global_position += stepDir
		countdown = player.sideStepCooldown


	move_player(delta)

	if Input.is_action_just_pressed("jump") and player.currentJumpCount > 0:
		state_machine.transition_to("airborne", {do_jump = true})
	elif is_equal_approx(player.velocity.length(), 0):
		state_machine.transition_to("idle")

func move_player(delta : float) -> void:
	# Calculate movement
	PlayerController.calculate_boost_movement(player, player.boostSpeed,player.turningSpeed, delta)
	# Apply calculations
	player.move_and_slide()
	player.apply_floor_snap()

func exit() -> bool:
	move_sfx.stop()
	return true
