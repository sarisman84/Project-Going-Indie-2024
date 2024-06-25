class_name ExtendedUtilities

static func get_global_aabb_center(aabb : AABB, owner : Node3D) -> Vector3:
	return aabb.get_center() + owner.position - (aabb.size / 2.0)

static func get_global_aabb_start(aabb : AABB, owner : Node3D) -> Vector3:
	return aabb.position + owner.position - (aabb.size / 2.0)
	
static func get_global_aabb_end(aabb : AABB, owner : Node3D) -> Vector3:
	return aabb.end + owner.position - (aabb.size / 2.0)


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
