extends Node3D

func _on_interactable_focused(interactor):
	pass # Replace with function body.

#Pull up level select menu
func _on_interactable_interacted(interactor):
	get_node("LevelSelectMenu").pause_menu()

func _on_interactable_unfocused(interactor):
	pass
