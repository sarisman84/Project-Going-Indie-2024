class_name CameraModifier
extends Area3D



@export var trackMode : CameraController.CameraMode
@export var cameraFollowOffset : Vector3
@export var childNode : Node3D

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
	camera.trackTarget = player
	camera.trackPivot = childNode.global_position
	
	DebugDraw3D.draw_arrow_ray(player.global_position, camera.trackerForwardDirection	, 1.0, Color.BLUE, 0.15, false, 10.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
