class_name CameraController
extends Node3D

@onready var player_controller = $".."
@onready var arm = $arm

enum CameraMode {Follow, TrackLook , Look, Manual }

@export var camera_sensitivity := 0.5
@export var camera_smoothing := 0.5

var input : Vector2
var localTarget : Node3D

var trackerForwardDirection : Vector3
var target : Node3D
var targetFollowOffset : Vector3
var trackMode : CameraMode
var trackPivot : Vector3
var trackPath : Path3D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	target = player_controller
	follow_target()
	

func _unhandled_input(event):
	if trackMode != CameraMode.Manual:
		return
	if event is InputEventMouseMotion:
		input = event.relative

func _process(_delta):
	if trackMode == CameraMode.Manual:
		manual_control(_delta)
		return
	
	arm.rotation_degrees.x = 0
	arm.rotation_degrees.y = 0	
	arm.position = Vector3.ZERO

	if trackMode == CameraMode.Follow and target:
		follow_target(_delta)
		transition_to_target_dir(_delta, trackerForwardDirection)
	elif trackMode == CameraMode.Look:
		go_to_target()
		transition_to_target_dir(_delta, (trackPivot - target.global_position).normalized())
	elif trackMode == CameraMode.TrackLook and trackPath != null:
		track_target(_delta)
		

func track_target(_delta : float ) -> void:
	var offset = ExtendedUtilities.get_closest_offset(target.global_position, trackPath)
	DebugDraw2D.set_text("offset ", offset,0, Color.YELLOW)
	DebugDraw2D.set_text("target global pos ", target.global_position,0, Color.YELLOW)
	var pos = (trackPath.basis.get_rotation_quaternion() * trackPath.curve.sample_baked(offset, true)) + trackPath.global_position
	pos += targetFollowOffset
	var dir = (pos - target.global_position)
	global_position = pos
	
	transition_to_target_dir(_delta, dir.normalized())
	
func go_to_target():
	position = trackPivot

func follow_target(_delta : float = 1.0) -> void:
	position = lerp(position, target.position + targetFollowOffset, _delta * camera_smoothing) 

func transition_to_target_dir(_delta : float, direction : Vector3) -> void:
	var newDir = basis.z.slerp(direction, camera_smoothing * _delta)
	self.look_at(transform.origin - newDir, Vector3.UP)
	pass
	
func manual_control(_delta) -> void:
	var cameraInput : Vector2
	var otherInput = Vector2(
		Input.get_action_strength("look_right") - Input.get_action_strength("look_left"), 
		Input.get_action_strength("look_down") - Input.get_action_strength("look_up"))
	
	arm.global_position = player_controller.position + Vector3.UP * 0.5
	
	if not otherInput and not input:
		return
	
	#Get the camera look input.
	#Use the mouse input if detected
	if input:
		cameraInput = input
	else:
		cameraInput = otherInput
	
	#Rotate Up/Down and make sure to clamp said rotation
	arm.rotation_degrees.x -= cameraInput.y * camera_sensitivity
	arm.rotation_degrees.x = clamp(arm.rotation_degrees.x, -90, 30.0)
	
	#Rotate Left/Right and wrap the value to not overflow or underflow the rotation
	arm.rotation_degrees.y -= cameraInput.x * camera_sensitivity
	arm.rotation_degrees.y = wrapf(arm.rotation_degrees.y, 0.0, 360.0)
	
	input = Vector2.ZERO
	

	
