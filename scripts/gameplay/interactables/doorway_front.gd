extends Node3D

@export var highlight_material: StandardMaterial3D

#@onready var door_meshinstance: MeshInstance3D = $MeshInstance3D
#@onready var door_material: StandardMaterial3D = door_meshinstance.mesh.surface_get_material(0)

func add_highlight():
#	door_meshinstance.set_surface_override_material(0, door_material.duplicate())
#	door_meshinstance.get_surface_override_material(0).next_pass = highlight_material
	pass

func remove_highlight():
#	door_meshinstance.set_surface_override_material(0, null)
	pass

func _on_interactable_focused(interactor):
#	add_highlight()
	pass

func _on_interactable_interacted(interactor):
	get_tree().quit()

func _on_interactable_unfocused(interactor):
#	remove_highlight()
	pass
