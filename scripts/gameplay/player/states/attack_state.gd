class_name AttackingState
extends PlayerState

var bounceOverrideState : bool
var currentHomingTarget : AttackableNode
var bounceHeight : float
var speed : float

func enter(msg := {}) -> void:
	currentHomingTarget = msg["_target"]
	bounceOverrideState = msg["_bounceOverrideState"]
	speed = msg["_speed"]
	bounceHeight = msg["_bounceHeight"]
	player.animation_player.play("fly")
	var dir = (currentHomingTarget.global_position - player.global_position).normalized()
	# player.rotate_model_towards_adv(, player.up_direction)
	player.model_anchor.rotate_towards(dir, Vector3.UP)
	pass

func physics_update(_delta: float) -> void:
	if bounceOverrideState:
		player.state_machine.transition_to("airborne")
		return

	if currentHomingTarget == null:
		player.state_machine.transition_to("airborne")
		return

	var dir = (currentHomingTarget.global_position - player.global_position).normalized()
	var dist = (currentHomingTarget.global_position - player.global_position).length()

	if dist <= 0.5:
		player.state_machine.transition_to("airborne")
		player.model_anchor.rotate_towards(Vector3.UP, Vector3.UP)
		currentHomingTarget.on_homing_attack.emit()
		#player.velocity = Vector3.UP * PlayerController.get_jump_velocity(bounceHeight, player.gravity)
		#player.move_and_slide()
		#currentHomingTarget = null
		return

	player.velocity = dir * speed
	player.move_and_slide()

func exit() -> bool:
	return true

