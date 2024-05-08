@tool
extends Node3D

@onready var camera = $"../camera_anchor/camera"
@onready var detection_area = $detection_area
@onready var camera_anchor = $"../camera_anchor"
@onready var player  : PlayerController = $".."
@onready var indicator : CenterContainer = $indicator


@export var detectionAngle : float = 0.2
@export var speed : float = 1.0
@export var bounceHeight : float = 1.0

var targetCollection : Array
var currentHomingTarget : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func detect_homing_targets():
	indicator.visible = false
	var copy = detection_area.get_overlapping_bodies()
	for i in range(0, copy.size()):
		
		var entry = copy[i] as Node3D
		
		var dir = (entry.global_position - global_position).normalized()
		var forwardDir  = -camera_anchor.basis.z.normalized()
		
		var dot = dir.dot(forwardDir)
		
		# DebugDraw3D.draw_arrow_ray(global_position, dir,1.0, Color.BLUE,0.15)
		# DebugDraw3D.draw_arrow_ray(global_position,forwardDir,1.0, Color.CYAN,0.15)
		
		if dot < detectionAngle:
			continue
		
		# DebugDraw3D.draw_sphere(entry.global_position, 1.15, Color.YELLOW)

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(global_position, global_position + dir * 1000)
		var result = space_state.intersect_ray(query)
		if result.is_empty():
			continue
		var col = result["collider"] as Node3D
		
		if col == null or col != entry:
			continue
		
		var cam3D = get_viewport().get_camera_3d()
		indicator.global_position = cam3D.unproject_position(entry.global_position) - indicator.size / 2.0
		indicator.visible = true	
		if not Input.is_action_just_pressed("attack") or player.is_on_floor():
			return
			
		currentHomingTarget = col	
		# DebugDraw3D.draw_sphere(col.global_position, 1.0, Color.RED, 2.0)
		player.set_default_controls(false)
		

func try_attack_target():
	if currentHomingTarget == null:
		return
	
	var dir = (currentHomingTarget.global_position - global_position).normalized()
	var dist = (currentHomingTarget.global_position - global_position).length()
	
	if dist <= 0.5:
		player.set_default_controls(true)
		player.velocity = Vector3.UP * player.get_jump_velocity(bounceHeight)
		player.move_and_slide()
		currentHomingTarget = null
		return
		
	player.velocity = dir * speed
	player.move_and_slide()


func _physics_process(_delta):
	detect_homing_targets()
	try_attack_target()
	
