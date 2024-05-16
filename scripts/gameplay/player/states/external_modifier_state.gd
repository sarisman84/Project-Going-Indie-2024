class_name ExternalModifierState
extends PlayerState

@export var exitDelayInSeconds : float = 0.2
var curDelay : float

var externalVelocity : Vector3

func enter(msg := {}) -> void:
	if not msg.has("external_velocity"):
		return
	curDelay = exitDelayInSeconds
	externalVelocity = msg["external_velocity"]
	if msg.has("canSnap"):
		if msg.has("snapPos") and msg["canSnap"]:
			var col = player.collider as Node3D
			player.global_position = msg["snapPos"]
	if msg.has("duration"):
		exitDelayInSeconds = msg["duration"]
	player.rotate_model_towards_adv(externalVelocity, Vector3.UP)
	
	
		

func physics_update(_delta: float) -> void:
	player.velocity = externalVelocity
	player.move_and_slide()

func update(delta: float) -> void:
	curDelay -= delta
	if curDelay <= 0:
		state_machine.transition_to("airborne")

func exit() -> void:
	pass
