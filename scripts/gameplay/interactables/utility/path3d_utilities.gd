class_name Path3DUtilities

static func get_closest_offset(globalPosition : Vector3, owner : Path3D, useMatrix : bool = false) -> float:
	var localPosition : Vector3
	if useMatrix:
		localPosition = owner.basis.inverse() * (globalPosition - owner.global_position)
	else:
		localPosition = owner.basis.get_rotation_quaternion().inverse() * (globalPosition - owner.global_position)
	if not owner.curve:
		return 0
	return owner.curve.get_closest_offset(localPosition)

static func sample_baked_up_vector_global(offset : float, apply_tilt : bool, owner : Path3D) -> Vector3:
	return owner.basis * owner.curve.sample_baked_up_vector(offset, apply_tilt)

static func sample_baked_global(offset : float, cubic : bool, owner : Path3D) -> Vector3:
	return (owner.basis * owner.curve.sample_baked(offset, cubic)) + owner.position

static func get_closest_point_index(globalPosition : Vector3, owner : Path3D):
	var minDist = 1.79769e308
	var result : int
	for i in range(0, owner.curve.point_count):
		var pointPos = owner.position + owner.curve.get_point_position(i)
		var dist = (pointPos - globalPosition).length()
		if minDist > dist:
			minDist = dist
			result = i
	return result

static func get_next_closest_point_index(globalPosition : Vector3, owner : Path3D):
	var closestPoint  = min(Path3DUtilities.get_closest_point_index(globalPosition, owner) + 1, owner.curve.point_count - 1)
	return closestPoint
