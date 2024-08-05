class_name CameraModifier
extends Area3D


@export_category("General")
@export var trackMode : CameraController.CameraMode
@export var childNode : Node3D
@export var trackPath : Path3D
@export var newProjection : Camera3D.ProjectionType = Camera3D.PROJECTION_PERSPECTIVE
@export_subgroup("Perspective Settings")
@export var newFieldOfView : float = 75
@export_subgroup("Orthographic Settings")
@export var newSize : float = 1

# @onready var mod = $mod

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_camera_enter)


# Fetches the player to get the camera
func on_camera_enter(body) -> void:
	if not body is PlayerController:
		return
	var player = body as PlayerController
	var cam = player.camera_controller

	cam.set_state(trackMode, {
		anchor_point = childNode.global_position,
		local_anchor_point = childNode.position,
		path = trackPath,
		target_dir = childNode.basis.z
		})
	cam.physical_camera.projection = newProjection
	cam.physical_camera.fov = newFieldOfView
	cam.physical_camera.size = newSize

	pass


