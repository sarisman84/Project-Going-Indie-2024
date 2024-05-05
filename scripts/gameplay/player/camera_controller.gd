extends SpringArm3D

@export var camera_sensitivity := 0.5
var input : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		input = event.relative

func _process(delta):
	var cameraInput : Vector2
	var otherInput = Vector2(
		Input.get_action_strength("look_right") - Input.get_action_strength("look_left"), 
		Input.get_action_strength("look_down") - Input.get_action_strength("look_up"))
	
	if not otherInput and not input:
		return
	
	#Get the camera look input.
	#Use the mouse input if detected
	if input:
		cameraInput = input
	else:
		cameraInput = otherInput
	
	#Rotate Up/Down and make sure to clamp said rotation
	rotation_degrees.x -= cameraInput.y * camera_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -90, 30.0)
	
	#Rotate Left/Right and wrap the value to not overflow or underflow the rotation
	rotation_degrees.y -= cameraInput.x * camera_sensitivity
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
	
	input = Vector2.ZERO
	
