extends BaseCameraState

var focus_point : Node3D
var smoothing : float
var anchor_point : Vector3

func enter(msg:={}) -> void:
	anchor_point = msg["anchor_point"] as Vector3
	focus_point = player
	smoothing = get_variable("smoothing", 1.0, msg) as float
	move_camera_focus(anchor_point)



func update(_delta: float) -> void:
	var dir = (anchor_point - focus_point.global_position).normalized()
	var newDir = controller.camera_anchor.basis.z.slerp(dir, smoothing * _delta)
	rotate_camera_towards(dir)

