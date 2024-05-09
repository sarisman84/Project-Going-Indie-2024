# Taken from https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name PlayerState
extends State

# Typed reference to the player node.
var player: PlayerController
var directionalInput : Vector3

func _ready() -> void:
	# The states are children of the PlayerController` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	await("ready")
	# The `as` keyword casts the `owner` variable to the PlayerController` type.
	# If the `owner` is not a PlayerController`, we'll get `null`.
	player = owner as PlayerController
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than PlayerController.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(player != null)
	
func _process(_delta: float) -> void:
	directionalInput.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) 
	directionalInput.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	directionalInput = directionalInput.normalized()
