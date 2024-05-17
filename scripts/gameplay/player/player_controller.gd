class_name PlayerController
extends CharacterBody3D

enum States {Idle, Moving, Airborne, Grinding, StoppedGrinding, Attacking, ExternalForce }

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumpFlag : bool

@onready var defaultControls : bool = true
@onready var homing_attack_ref : HomingAttack = $homing_attack
@onready var camera = $camera_anchor
@onready var state_machine := $state_machine
@onready var collider = $collider
@onready var magnet = $magnet
@onready var animation_player = $model_anchor/skater_mc/AnimationPlayer

@export var movementSpeed : float = 5.0
@export_category("Jump Settings")
@export var jumpHeight : float = 1.0
@export var jumpCount : int = 2
@export_category("Boost Settings")
@export var turningSpeed : float = 1.0
@export var sideStepCooldown : float = 0.1
@export var sideStepDistance : float = 10.0
@export var boostSpeed : float = 10.0
@export_category("Fall Settings")
@export var fallMultiplier : float = 1.0
@export var stompSpeed : float = 5.0
@export var fallThreshold : float = 0.0
@export_category("Acceleration Settings")
@export var groundDelta : Vector2 = Vector2.ONE
@export var airDelta : Vector2 = Vector2.ONE
@export var boostAcceleration : float = 1.0
@export var slideDecceleration : float = 0.8
@export_category("Rail Grind Settings")
@export var railDetectionRadius : float = 0.5
@export var railGrindCooldownInSeconds : float = 0.25
@export_category("Other")
@export var cameraOffset : Vector3
@export var model : Node3D
@export var externalModifierCooldown : float
@export var curvedTerrainSnapDistance : float = 5.0


var currentJumpCount : int = 0
var canAirBoost : bool = true
var forwardDirection : Vector3 = Vector3.ZERO
var useCameraForward : bool = true

func _process(_delta):
	pass
	# camera.position = position + cameraOffset
	

func calculate_dynamic_gravity(delta : float) -> Vector3:
	var finalForce : float
	if velocity.y > fallThreshold:
		finalForce =  gravity * delta
	else:
		finalForce = gravity * (fallMultiplier - 1) * delta
	return -up_direction * finalForce

static func get_jump_velocity(inputHeight : float, _gravity : float):
	return sqrt(2.0 * _gravity * inputHeight)
	

func get_current_speed():
	var speed := movementSpeed
	if Input.is_action_pressed("boost"):
		speed = boostSpeed
	return speed

func rotate_model_towards(forwardDir : Vector3):
	if is_equal_approx(forwardDir.length(), 0):
		return
	model.look_at(model.transform.origin - forwardDir, up_direction)
	collider.look_at(collider.transform.origin - forwardDir, up_direction)

func rotate_model_towards_adv(forwardDir : Vector3, up_dir : Vector3):
	if is_equal_approx(forwardDir.length(), 0) or is_equal_approx(up_dir.length(), 0):
		return
	model.look_at(transform.origin - forwardDir, up_dir)
	collider.look_at(transform.origin - forwardDir, up_dir)

func try_get_ground() -> Dictionary:
	var state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(position,position - up_direction)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.exclude = [self]
	
	return state.intersect_ray(query)

func get_directional_input() -> Vector3:
	var localInputDir : Vector3
	# Get the user's input in all 4 directions.
	localInputDir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) 
	localInputDir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	localInputDir.y = 0
	localInputDir = localInputDir.normalized()
	
	var right = camera.transform.basis.x
	var forward : Vector3 = Vector3.ZERO
	
	if useCameraForward:
		forward = camera.transform.basis.z
		forward.y = 0
	
	if forwardDirection.length() > 0:
		forward += forwardDirection
	forward = forward.normalized()
	
	return right * localInputDir.x + forward * localInputDir.z

func try_rotate_model_towards_forward_direction() -> void:
	pass

static func calculate_auto_movement(player : PlayerController, speed : float, targetDirection : Vector3, _delta : float) -> void:
	if not player.model:
		return
	# Apply the target direction.
	
	player.velocity = targetDirection * speed
	player.rotate_model_towards_adv(targetDirection, player.up_direction)

static func calculate_boost_movement(player : PlayerController, speed : float, turnSpeed : float, delta : float) -> void:
	if not player.model:
		return
		
	var inputDir = player.get_directional_input()
	
	var vy = player.velocity.y
	# Apply the model's forward direction.
	player.velocity = player.model.global_transform.basis.z * speed
	
	
	# If the model exists, rotate it based of the turn input
	if player.velocity.length() > 0.2:
		var newDir = player.model.global_transform.basis.z.slerp(inputDir, turnSpeed * delta)
		player.rotate_model_towards_adv(newDir, Vector3.UP)
	
	player.velocity.y = vy
	

static func calculate_movement(player : PlayerController,speed : float, acceleration : float, decceleration : float, delta : float) -> void:
	var dir = player.get_directional_input()
	
	
	var vy = player.velocity.y
	# Apply acceleration & decceleration
	if dir:
		player.velocity = lerp(player.velocity, dir * speed, acceleration * delta)
	else:
		player.velocity = lerp(player.velocity, Vector3.ZERO, decceleration * delta)
	
	player.velocity.y = vy
	
	
	
	# If the model exists and the velocity is high enough, rotate it towards the velocity
	if player.model and dir.length() > 0.2:
		var newDir = player.model.basis.z.slerp(dir.normalized(), 4.0 * delta)
		player.rotate_model_towards_adv(newDir, Vector3.UP)
		
		
	
