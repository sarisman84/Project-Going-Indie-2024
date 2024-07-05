class_name BaseCameraState
extends State

var controller : CameraController
var player : PlayerController
var target_point : Node3D

func early_enter(msg:={}) -> void:
	controller = msg["camera"] as CameraController
	player = msg["player"] as PlayerController
	target_point = controller

func rotate_camera(rotation : Vector2) -> void:
	# 	#Rotate Up/Down and make sure to clamp said rotation
	controller.camera_anchor.rotation_degrees.x -= rotation.y * controller.camera_sensitivity
	controller.camera_anchor.rotation_degrees.x = clamp(controller.camera_anchor.rotation_degrees.x, controller.vertical_input_lower_limit, controller.vertical_input_upper_limit)

	# 	#Rotate Left/Right and wrap the value to not overflow or underflow the rotation
	controller.camera_anchor.rotation_degrees.y -= rotation.x * controller.camera_sensitivity
	controller.camera_anchor.rotation_degrees.y = wrapf(controller.camera_anchor.rotation_degrees.y, 0.0, 360.0)

func move_camera_focus(position : Vector3) -> void:
	controller.camera_anchor.position = position
	pass

func rotate_camera_towards(targetDir : Vector3) -> void:
	controller.camera_anchor.look_at(controller.camera_anchor.transform.origin - targetDir, Vector3.UP)


func get_target_pos() -> Vector3:
	return player.position + target_point.position


