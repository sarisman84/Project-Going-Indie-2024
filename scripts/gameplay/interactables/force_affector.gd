class_name ForceAffector
extends Area3D

@export var forceDirection : Vector3
@export var forceAmount : float
@export var canBeAttacked : bool
@export var snapToMiddle: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Assumes that the incoming body is the Player
func _on_body_entered(body):
	var p = body as PlayerController
	prep_player(p)
	push_player(p)
	

func prep_player(player : PlayerController):
	var ha = player.homing_attack_ref as HomingAttack
	ha.set_bounce_override(true)

func reset_player(player: PlayerController):
	var ha = player.homing_attack_ref as HomingAttack
	ha.set_bounce_override(false)

func push_player(player : PlayerController):
	player.state_machine.transition_to("moved_by_external_force", {external_velocity = forceDirection.normalized() * forceAmount, snapPos = global_position + forceDirection.normalized(), canSnap = snapToMiddle})

func _on_body_exited(body):
	reset_player(body as PlayerController)
