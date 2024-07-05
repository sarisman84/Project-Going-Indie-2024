extends BaseCameraState

var path3D : Path3D
var offset : Vector3
var smoothing : float

func enter(msg:={}) -> void:
	path3D = msg["path"] as Path3D

	offset = get_variable("offset", Vector3(0,0,0), msg) as Vector3
	smoothing = get_variable("smoothing", 1.0, msg) as float



func update(_delta : float) -> void:
	# Get the closest point in relation to the focus point's position in global coordinates
	var pathOffset = Path3DUtilities.get_closest_offset(target_point.global_position, path3D)
	var pos = Path3DUtilities.sample_baked_global(pathOffset, true, path3D) + offset

	# Calculate the direction towards the target
	var dir = (pos - target_point.global_position)
	var newDir = controller.camera_anchor.basis.z.slerp(dir, smoothing * _delta)

	# Applied the calculated results
	move_camera_focus(pos)
	rotate_camera_towards(newDir)

	pass
