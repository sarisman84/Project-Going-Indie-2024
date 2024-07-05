extends BaseCameraState

var mouseInput: Vector2
var controllerInput: Vector2


func update(_delta: float) -> void:
	var input: Vector2
	# Calculate controller input
	controllerInput = Vector2(
		Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
		Input.get_action_strength("look_down") - Input.get_action_strength("look_up"))

	# Get the camera look input.
	# Use the mouse input if detected
	if mouseInput:
		input = mouseInput
	else:
		input = controllerInput

	# Apply rotation to camera
	rotate_camera(input)
	move_camera_focus(player.position + target_point.position)
	mouseInput = Vector2.ZERO
	controllerInput = Vector2.ZERO

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseInput = event.relative

