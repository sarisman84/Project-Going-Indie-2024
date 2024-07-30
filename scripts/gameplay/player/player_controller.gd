class_name PlayerController
extends CharacterBody3D

enum States {Idle, Moving, Airborne, Grinding, StoppedGrinding, Attacking, ExternalForce}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumpFlag: bool

enum ForwardMode {Camera, World}

@onready var defaultControls: bool = true
@onready var homing_attack_ref: AttackManager = $attack_manager
@onready var camera_controller: CameraController = $camera_anchor
@onready var state_machine: StateMachine = $state_machine
@onready var collider = $collider
@onready var animation_player = $model_anchor/skater_mc/AnimationPlayer
@onready var model_anchor : ModelController = $model_anchor



@export var player_settings : PlayerSettings

@export_category("Other")
@export var cameraOffset: Vector3
@export var model: Node3D
@export var externalModifierCooldown: float
@export var curvedTerrainSnapDistance: float = 5.0
@export var modelAnimationTree: AnimationTree

var currentJumpCount: int = 0
var canAirBoost: bool = true
var worldForward: Vector3 = Vector3.ZERO


func _ready() -> void:
	floor_snap_length = 100
	floor_max_angle = 180
	pass

func m_get_input() -> Vector3:
	var input_dir = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 0,
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		).normalized()
	return input_dir

# Fetches user input and aligns it with the player depending on the forward mode
func m_calculate_global_movement(_delta : float) -> Vector3:
	var input_dir = m_get_input()

	var cam_basis = camera_controller.camera_anchor.basis
	return (input_dir.x * cam_basis.x + input_dir.z * cam_basis.z).normalized()


func m_calculate_movement(_delta: float, normal : Vector3) -> Vector3:
	var input_dir = m_get_input()

	var cam_basis = camera_controller.camera_anchor.basis
	var forwardDir = cam_basis.x.cross(normal)

	return (input_dir.x * cam_basis.x + input_dir.z * forwardDir).normalized()


# Calculates the gravity based of the current velocity
func m_calculate_dynamic_gravity(delta: float) -> Vector3:
	var finalForce: float
	if velocity.y > player_settings.fallThreshold:
		finalForce = gravity * delta
	else:
		finalForce = gravity * (player_settings.fallMultiplier - 1) * delta
	return - up_direction * finalForce

# Applies acceleration or decceleration depending on the current target velocity.
func m_apply_acceleration(input_vel: Vector3, target_vel: Vector3, m_acceleration: float, m_decceleration: float, delta: float) -> Vector3:
	if target_vel.length() > 0:
		return lerp(input_vel, target_vel, m_acceleration * delta)
	else:
		return lerp(input_vel, Vector3.ZERO, m_decceleration * delta)

# Normal movement
func move(_delta: float) -> void:
	var normal : Vector3 = Vector3.UP
	#Calculate movement with tests
	var dir = m_calculate_global_movement(_delta)

	var col_info = move_and_collide(dir * _delta,true)
	if col_info:
		normal = col_info.get_normal()
		dir = m_calculate_movement(_delta, normal)
		dir = dir.slide(normal)




	#Apply Settings
	var speed : float
	var acceleration : float
	var decceleration : float

	var is_boosting = Input.is_action_pressed("boost")

	if is_boosting:
		speed = player_settings.boost_speed
		acceleration = player_settings.boost_acceleration
		decceleration = 0
	else:
		speed = player_settings.movement_speed
		acceleration = player_settings.acceleration
		decceleration = player_settings.decceleration


	#Apply velocity
	velocity = m_apply_acceleration(velocity, dir * speed, acceleration, decceleration, _delta)
	#Apply model rotation
	model_anchor.rotate_towards(velocity.normalized(), normal)
	move_and_slide()
	apply_floor_snap()

	pass

# # Boost movement
# func boost_move(_delta: float) -> void:
# 	var dir = m_calculate_global_movement(_delta)

# 	var col_info = move_and_collide(dir * _delta)
# 	if col_info:
# 		var normal = col_info.get_normal()
# 		dir = dir.slide(normal)

# 	velocity = m_apply_acceleration(velocity, dir * player_settings.boostSpeed, player_settings.boostAcceleration, 0, _delta)

# 	move_and_slide()
# 	apply_floor_snap()
# 	pass

func air_move(_delta : float) -> void:
	var dir = m_calculate_global_movement(_delta)

	velocity = m_apply_acceleration(velocity, dir * player_settings.movement_speed, player_settings.air_acceleration, player_settings.air_decceleration, _delta)
	velocity -= -up_direction * m_calculate_dynamic_gravity(_delta)
	move_and_slide()




#func _ready() -> void:
	#floor_snap_length = 100.0
	#floor_max_angle = 180.0
	## camera_controller.position = position + cameraOffset
#
#

#
#func get_current_speed():
	#var speed := movement_speed
	#if Input.is_action_pressed("boost"):
		#speed = boostSpeed
	#return speed
#
#func rotate_model_towards(forwardDir : Vector3):
	#if is_equal_approx(forwardDir.length(), 0):
		#return
	#model.look_at(model.transform.origin - forwardDir, up_direction)
	#collider.look_at(collider.transform.origin - forwardDir, up_direction)
#
#func rotate_model_towards_adv(forwardDir : Vector3, up_dir : Vector3):
	#if is_equal_approx(forwardDir.length(), 0) or is_equal_approx(up_dir.length(), 0):
		#return
	#model.look_at(transform.origin - forwardDir, up_dir)
	#collider.look_at(transform.origin - forwardDir, up_dir)
#
#
#
#func get_directional_input() -> Vector3:
	#var localInputDir : Vector3
	## Get the user's input in all 4 directions.
	#localInputDir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	#localInputDir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	#localInputDir.y = 0
	#localInputDir = localInputDir.normalized()
#
	#var right = camera_controller.camera_anchor.transform.basis.x
	#var forward : Vector3 = Vector3.ZERO
#
	#if forward_mode == ForwardMode.Camera:
		#forward = camera_controller.camera_anchor.transform.basis.z
		#forward.y = 0
	#elif forward_mode == ForwardMode.World:
		#forward = worldForward
#
	#return (right * localInputDir.x + forward * localInputDir.z)
#
#
#
#static func calculate_auto_movement(player : PlayerController, speed : float, targetDirection : Vector3, _delta : float) -> void:
	#if not player.model:
		#return
	## Apply the target direction.
#
	#player.velocity = targetDirection * speed
	#player.rotate_model_towards_adv(targetDirection, player.up_direction)
#
#static func calculate_boost_movement(player : PlayerController, speed : float, turnSpeed : float, delta : float) -> void:
	#if not player.model:
		#return
#
	#var inputDir = player.get_directional_input()
#
	#var vy = player.velocity.y
	## Apply the model's forward direction.
	#player.velocity = (player.model.global_transform.basis.z - player.worldForward).normalized() * speed
#
#
	## If the model exists, rotate it based of the turn input
	#if player.velocity.length() > 0.2:
		#var newDir = player.model.global_transform.basis.z.slerp(inputDir, turnSpeed * delta)
		#player.rotate_model_towards_adv(newDir, Vector3.UP)
#
	#player.velocity.y = vy
#
#
#static func calculate_movement(player : PlayerController,speed : float, acceleration : float, decceleration : float, delta : float) -> void:
	#var dir = player.get_directional_input()
#
	#DebugDraw3D.draw_arrow_ray(player.global_position, dir,1.0, Color.YELLOW, 0.25, true)
#
	#var vy = player.velocity.y
	## Apply acceleration & decceleration
	#if dir:
		#player.velocity = lerp(player.velocity, dir * speed, acceleration * delta)
	#else:
		#player.velocity = lerp(player.velocity, Vector3.ZERO, decceleration * delta)
#
	#player.velocity.y = vy
#
	## If the model exists and the velocity is high enough, rotate it towards the velocity
	#if player.model and dir.length() > 0.2:
		#var newDir = player.model.basis.z.slerp(dir.normalized(), 4.0 * delta)
		#player.rotate_model_towards_adv(newDir, Vector3.UP)
#
	##var at = player.modelAnimationTree
#
	##print(at.tree_root.get_parameter("state_machine/isBoosting"))
