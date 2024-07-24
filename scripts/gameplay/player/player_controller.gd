class_name PlayerController
extends CharacterBody3D

enum States {Idle, Moving, Airborne, Grinding, StoppedGrinding, Attacking, ExternalForce }

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumpFlag : bool

@onready var defaultControls : bool = true
@onready var homing_attack_ref : AttackManager = $attack_manager
@onready var camera_controller : CameraController = $camera_anchor
@onready var state_machine : StateMachine = $state_machine
@onready var collider = $collider
@onready var animation_player = $model_anchor/skater_mc/AnimationPlayer


@export var movementSpeed : float = 5.0

@export_category("Jump Settings")
@export var jumpHeight : float = 1.0
@export var jumpCount : int = 2
@export var canJump : bool = true

@export_category("Boost Settings")
@export var turningSpeed : float = 1.0
@export var sideStepCooldown : float = 0.1
@export var sideStepDistance : float = 10.0
@export var boostSpeed : float = 10.0
@export var canBoost : bool = true

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
@export var modelAnimationTree : AnimationTree


var currentJumpCount : int = 0
var canAirBoost : bool = true
var forwardDirection : Vector3 = Vector3.ZERO
var useCameraForward : bool = true


func _ready() -> void:
	floor_snap_length = 100.0
	floor_max_angle = 180.0
	# camera_controller.position = position + cameraOffset


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



func get_directional_input() -> Vector3:
	var localInputDir : Vector3
	# Get the user's input in all 4 directions.
	localInputDir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	localInputDir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	localInputDir.y = 0
	localInputDir = localInputDir.normalized()

	var right = camera_controller.camera_anchor.transform.basis.x
	var forward : Vector3 = Vector3.ZERO

	if useCameraForward:
		forward = camera_controller.camera_anchor.transform.basis.z
		forward.y = forwardDirection.y

	DebugDraw3D.draw_arrow_ray(position + up_direction * 1.5,-forward, 2.0, Color.MAGENTA, 0.25, true)
	DebugDraw3D.draw_arrow_ray(position, -forwardDirection, 1.0, Color.BLUE, 0.25, true)

	return (right * localInputDir.x + forward * localInputDir.z)









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
	player.velocity = (player.model.global_transform.basis.z - player.forwardDirection).normalized() * speed


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

	#var at = player.modelAnimationTree

	#print(at.tree_root.get_parameter("state_machine/isBoosting"))



