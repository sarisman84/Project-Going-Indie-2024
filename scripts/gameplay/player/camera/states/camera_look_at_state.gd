extends BaseCameraState

var focus_point : Node3D
var smoothing : float

func enter(msg:={}) -> void:
	var pos = msg["anchor_point"] as Vector3
	focus_point = player
	smoothing = get_variable("smoothing", 1.0, msg) as float
	move_camera_focus(pos)



func update(_delta: float) -> void:
	var dir = focus_point.global_position - controller.camera_anchor.global_position
	var newDir = controller.camera_anchor.basis.z.slerp(dir, smoothing * _delta)
	rotate_camera_towards(newDir)

