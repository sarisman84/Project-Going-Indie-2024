class_name AttackManager
extends Area3D

@onready var debug_indicator = $debug_indicator
@onready var attack_indicator = $attack_indicator
@onready var camera_controller  : CameraController = $"../camera_anchor"
@onready var player  : PlayerController = $".."
@onready var shape : CollisionShape3D = $shape

@onready var bounceOverrideState : bool = false
@onready var player_state_machine : StateMachine = player.state_machine

@export var detectionAngle : float = 0.2
@export var speed : float = 1.0
@export var bounceHeight : float = 1.0


var aquired_targets : Array

func _on_body_entered(body):
	if not body is AttackableNode:
		return

	aquired_targets.append(body as AttackableNode)
	DebugDraw2D.set_text("HA: target found: ",body.name, 0, Color.GREEN,3.0)



func _on_body_exited(body):
	if not body is AttackableNode:
		return
	aquired_targets.erase(body as AttackableNode)
	#cur_index = _manager.aquired_targets.size()
	DebugDraw2D.set_text("HA: target lost! ",body.name, 0, Color.GREEN,3.0)

func _process(_delta : float) -> void:
	debug_indicator.display_attack_radius(self)

func _physics_process(_delta : float) -> void:
	#if player.is_on_floor():
		#return

	for i in range(aquired_targets.size()):
		var target = aquired_targets[i]
		var viewCheck = is_in_camera_view(target)
		var losCheck = is_in_line_of_sight(target)

		debug_indicator.draw_detected_target(target,player, viewCheck, losCheck)

		if not (viewCheck and losCheck):
			continue
		#var target = aquired_targets[i]
		#if not (is_in_camera_view(target) and is_in_line_of_sight(target)):
			#return
		attack_indicator.display_indicator_at(target)

		debug_indicator.draw_attackable_target(target)

		if not Input.is_action_just_pressed("attack"):
			return
		player.state_machine.transition_to("attacking", {
 			_target = target,
 			_bounceHeight = bounceHeight,
 			_speed = speed,
 			_bounceOverrideState = bounceOverrideState
 			})
		#aquired_targets.erase(target)
		return

func is_in_camera_view(target : AttackableNode) -> bool:
	var dir = (target.global_position - player.global_position).normalized()
	var forwardDir = -camera_controller.camera_anchor.basis.z.normalized()

	var dot = dir.dot(forwardDir)
	return dot >= detectionAngle

func is_in_line_of_sight(target : AttackableNode) -> bool:
	var dir = (target.global_position - player.global_position).normalized()

	var space_state = player.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.global_position, player.global_position + dir * 1000)

	query.collide_with_areas = true
	query.exclude = [self]
	query.collision_mask = pow(2, 3-1)

	var result = space_state.intersect_ray(query)
	if result.is_empty():
		return false

	return target.verify_self(result)













