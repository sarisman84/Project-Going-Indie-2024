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
	var cam = player.camera
	# mod.camera = cam
	apply_cam_settings(cam, player)
	
	pass

func apply_cam_settings(camera : CameraController, player : PlayerController) -> void:
	camera.trackerForwardDirection = childNode.global_basis.z
	camera.target = player
	camera.targetFollowOffset = childNode.position
	camera.trackMode = trackMode
	camera.trackPivot = childNode.global_position
	camera.trackPath = trackPath
	camera.physical_camera.projection = newProjection
	camera.physical_camera.fov = newFieldOfView
	camera.physical_camera.size = newSize
	
	DebugDraw3D.draw_arrow_ray(player.global_position, camera.trackerForwardDirection	, 1.0, Color.BLUE, 0.15, false, 10.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
