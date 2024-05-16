class_name ExtendedUtilities
extends Node


static func get_global_aabb_center(aabb : AABB, owner : Node3D) -> Vector3:
	return aabb.get_center() + owner.position - (aabb.size / 2.0)

static func get_global_aabb_start(aabb : AABB, owner : Node3D) -> Vector3:
	return aabb.position + owner.position - (aabb.size / 2.0)
	
static func get_global_aabb_end(aabb : AABB, owner : Node3D) -> Vector3:
	return aabb.end + owner.position - (aabb.size / 2.0)

static func get_closest_offset(globalPosition : Vector3, owner : Path3D) -> float:
	var localPosition = owner.basis.get_rotation_quaternion().inverse() * (globalPosition - owner.position)
	if not owner.curve:
		return 0
	return owner.curve.get_closest_offset(localPosition)

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
	var closestPoint  = min(ExtendedUtilities.get_closest_point_index(globalPosition, owner) + 1, owner.curve.point_count - 1)
	return closestPoint


static func rotate_towards(a : Vector3, b : Vector3, maxInDegrees : float) -> Vector3:
	# normalise both vectors:
	var va_n = a.normalized()
	var vb_n = b.normalized()

	# take the cross product and dot product
	var cross = va_n.cross(vb_n).normalized()
	var dot = va_n.dot(vb_n)

	var maxR = deg_to_rad(maxInDegrees)
	# acos(dot) gives you the angle (in radians) between the two vectors which you'll want to clamp to your maximum rotation (convert it to radians)
	var angle = clamp(acos(dot), -maxR, maxR)

	# and now you can rotate your original 
	return a.rotated(cross, angle)
