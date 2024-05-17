extends Node3D
	
func _on_interactable_focused(interactor):
	get_node("UIText").show()

#Pull up level select menu
func _on_interactable_interacted(interactor):
	get_node("LevelSelectMenu").pause_menu()

func _on_interactable_unfocused(interactor):
	get_node("UIText").hide()
