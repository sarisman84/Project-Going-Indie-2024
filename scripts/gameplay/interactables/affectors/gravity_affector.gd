extends Area3D

var player : PlayerController


func _physics_process(delta : float) -> void:
	pass



func _on_body_entered(body) -> void:
	if not body is PlayerController:
		return
	player = body as PlayerController


func _on_body_exited(body) -> void:
	if not body is PlayerController:
		return
	player = null
