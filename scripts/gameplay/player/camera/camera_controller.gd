class_name CameraController
extends Node3D

@onready var player_controller = $".."
@onready var camera_anchor = $arm
@onready var physical_camera : Camera3D = $arm/camera
@onready var state_machine_camera : StateMachine = $state_machine_camera

@export_group("Vertical Input Limit")
@export var vertical_input_lower_limit : float = -90
@export var vertical_input_upper_limit : float = 90

@export_group("Other")
@export var camera_smoothing : float = 1.0
@export var camera_sensitivity : float = 1.0
@export var camera_target : Node3D

enum CameraMode {Follow, TrackLook , Look, Manual }

func _ready():
	set_as_top_level(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func set_state(mode : CameraMode, data := {}) -> void:
	DebugDraw2D.set_text("Camera State: ", get_mode_name(mode), 1, Color.GREEN, 3)
	data["camera"] = self
	data["player"] = player_controller
	if mode == CameraMode.Look:
		state_machine_camera.transition_to("camera_look", data)
		return
	if mode == CameraMode.TrackLook:
		state_machine_camera.transition_to("camera_track", data)
		return
	if mode == CameraMode.Manual:
		state_machine_camera.transition_to("camera_manual", data)
		return
	if mode == CameraMode.Follow:
		state_machine_camera.transition_to("camera_follow", data)
		return

func get_mode_name(mode : CameraMode) -> String:
	if mode == CameraMode.Look:
		return "Look"
	if mode == CameraMode.TrackLook:
		return "TrackLook"
	if mode == CameraMode.Manual:
		return "Manual"
	if mode == CameraMode.Follow:
		return "Follow"
	return "NaN"

