extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_player_attack)

func on_player_attack(body : Node3D) -> void:
	if not body is PlayerController:
		return
	var p = body as PlayerController
	if p.state_machine.state is AttackState:
		return
	queue_free()
