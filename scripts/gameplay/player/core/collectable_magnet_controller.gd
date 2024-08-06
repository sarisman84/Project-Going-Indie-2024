class_name CollectableMagnetController
extends Area3D

func _on_body_entered(_body):
	if _body is Collectable:
		var c = _body as Collectable
		Collectables.add_to_database(c.collectable_type, 1)
		_body.queue_free()
