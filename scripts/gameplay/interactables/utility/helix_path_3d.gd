@tool
class_name HelixPath3D
extends Path3D

@export var loopAmount : int
@export var loopLength : float
@export var helixSize : float

func init_points():
	var length = 0
	var i = 0
	
	curve.clear_points()
	while i < loopAmount:
		length += (loopLength / 8.0) 
		
		var x = cos(length) * helixSize
		var y = sin(length) * helixSize
		var z = length * helixSize
	
		var curve_point = Vector3(x,y,z)
		var center = -Vector3.FORWARD * z
		
		var dir_to_curve_point = (center - curve_point)
		var inPoint = basis.x.cross(dir_to_curve_point.normalized())
		
		# DebugDraw3D.draw_sphere(center, 0.15, Color.YELLOW, 100.0)
		# DebugDraw3D.draw_arrow_ray(curve_point, dir_to_curve_point.normalized(), dir_to_curve_point.length(), Color.BLUE, 0.15, true, 100.0)
		# DebugDraw3D.draw_arrow_ray(curve_point, inPoint, 2.5, Color.RED, 0.15, true, 100.0)
		# DebugDraw3D.draw_arrow_ray(curve_point, -inPoint, 2.5, Color.RED, 0.15, true, 100.0)
		
		curve.add_point(curve_point)
		
		if length >= loopLength * (i + 1):
			i += 1

#func tilt_points():
	#for i in range(0, curve.point_count):
		#var nextI = i + 1
		#var previousI = i - 1
		#if previousI >= 0 and nextI < curve.point_count:
			#curve.set_point_out(i, (curve.get_point_position(previousI) - curve.get_point_position(nextI)) / 4.0) 
			#curve.set_point_in(i, (curve.get_point_position(previousI) - curve.get_point_position(nextI)) / 4.0)
		
		

func generate_helix():
	DebugDraw3D.clear_all()
	init_points()

	# Smooth out the curve manually
	for i in range(1, curve.point_count - 1):
		var length = i * (loopLength / 8.0)
		
		# Calculate derivative of the helix function
		var dx = -sin(length) * helixSize
		var dy = cos(length) * helixSize
		var dz = helixSize
		
		# Use the derivative as the tangent
		var tangent = Vector3(dx, dy, dz).normalized()
		
		# Set in and out tangents based on calculated tangent
		curve.set_point_in(i, tangent * helixSize * 0.5)
		curve.set_point_out(i, tangent * helixSize * 0.5)

	# Calculate normals for each point on the curve
	for i in range(curve.point_count):
		var point = curve.get_point_position(i)
		var tangent = curve.get_point_in(i).normalized()
		
		# Calculate binormal as vector pointing towards the center of the helix
		var binormal = (Vector3.ZERO - point).normalized()
		
		# Calculate normal as cross product of tangent and binormal
		var normal = tangent.cross(binormal).normalized()
		
		curve.set_point_out_tilt(i, normal)
		curve.set_point_in_tilt(i, normal)
