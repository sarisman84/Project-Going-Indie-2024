class_name HomingAttack
extends Node3D

@onready var camera = $"../camera_anchor/camera"
@onready var detection_area = $detection_area
@onready var camera_anchor = $"../camera_anchor"
@onready var player  : PlayerController = $".."
@onready var indicator : CenterContainer = $indicator
@onready var bounceOverrideState : bool = false
@onready var player_state_machine : StateMachine = player.state_machine

@export var detectionAngle : float = 0.2
@export var speed : float = 1.0
@export var bounceHeight : float = 1.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var targetCollection : Array
var currentHomingTarget : Node3D



func set_bounce_override(newState: bool) -> void:
	bounceOverrideState = newState

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func detect_homing_targets():
	if Engine.is_editor_hint():
		return
	indicator.visible = false
	if player_state_machine != null and player_state_machine.state is AttackingState:
		return
	
	var copy = detection_area.get_overlapping_bodies() as Array[Node3D]
	copy.append_array(detection_area.get_overlapping_areas() as Array[Node3D])
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
		
		if entry is ForceAffector:
			var fa = entry as ForceAffector
			query.collide_with_areas = fa.canBeAttacked
			
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
		player.state_machine.transition_to("attacking", {
			_target = col, 
			_bounceHeight = bounceHeight, 
			_speed = speed, 
			_bounceOverrideState = bounceOverrideState
			})
		player_state_machine = player.state_machine

func _physics_process(_delta):
	detect_homing_targets()
	
