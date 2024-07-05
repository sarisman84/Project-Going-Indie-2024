extends BaseCameraState

var offset : Vector3
var smoothing : float
var target_dir : Vector3

func enter(msg:={}) -> void:
	offset = msg["anchor_point"]
	smoothing = get_variable("smoothing", 1.0, msg) as float
	target_dir = msg["target_dir"] as Vector3


func update(_delta: float) -> void:
	var newPos = lerp(controller.camera_anchor.position, get_target_pos() + offset, _delta * smoothing)
	move_camera_focus(newPos)

	var newDir = controller.camera_anchor.basis.z.slerp(target_dir.normalized(), 4.0 * _delta)
	rotate_camera_towards(newDir)
