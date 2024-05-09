class_name AttackState
extends PlayerState

var bounceOverrideState : bool
var currentHomingTarget : Node3D
var bounceHeight : float
var speed : float

func enter(msg := {}) -> void:
#_target
#_bounceHeight
#_speed
#_bounceOverrideState
	currentHomingTarget = msg["_target"]
	bounceOverrideState = msg["_bounceOverrideState"]
	speed = msg["_speed"]
	bounceHeight = msg["_bounceHeight"]
	pass
	
func physics_update(delta: float) -> void:
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
		player.velocity = Vector3.UP * PlayerController.get_jump_velocity(bounceHeight, player.gravity)
		player.move_and_slide()
		currentHomingTarget = null
		return
		
	player.velocity = dir * speed
	player.move_and_slide()
	
func exit() -> void:
	pass

