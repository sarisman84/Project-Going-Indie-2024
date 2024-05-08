@tool
extends Node3D

@onready var camera = $"../camera_anchor/camera"
@onready var detection_area = $detection_area
@onready var camera_anchor = $"../camera_anchor"

@export var detectionAngle : float = 0.2

var targetCollection : Array
var currentHomingTarget : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Input.is_action_just_pressed("attack"):
		return
		
	var copy = detection_area.get_overlapping_bodies()
	for i in range(0, copy.size()):
		
		var entry = copy[i] as Node3D
		
		var dir = (entry.global_position - global_position).normalized()
		var forwardDir  = -camera_anchor.basis.z.normalized()
		
		var dot = dir.dot(forwardDir)
		
		DebugDraw3D.draw_arrow_ray(global_position, dir,1.0, Color.BLUE,0.15, false, 2.0)
		DebugDraw3D.draw_arrow_ray(global_position,forwardDir,1.0, Color.CYAN,0.15, false, 2.0)
		
		if dot < detectionAngle:
			continue

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(global_position, global_position + dir * 1000)
		var result = space_state.intersect_ray(query)
		if result.is_empty():
			continue
		var col = result["collider"] as Node3D
		
		if col == null or col != entry:
			continue
		currentHomingTarget = col	
		
		DebugDraw3D.draw_sphere(col.global_position, 1.0, Color.RED, 2.0)
		DebugDraw3D.draw_sphere(entry.global_position, 1.15, Color.YELLOW, 2.0)
		
		pass
	
