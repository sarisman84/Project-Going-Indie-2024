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

@export_category("General Settings")
@export var movementSpeed : float = 5.0
@export var boostSpeed : float = 10.0
@export var jumpHeight : float = 1.0
@export_category("Boost Settings")
@export var steeringAmountInDegrees : float = 30.0
@export var turningSpeed : float = 1.0
@export var sideStepCooldown : float = 0.1
@export var sideStepDistance : float = 10.0
@export_category("Fall Settings")
@export var fallMultiplier : float = 1.0
@export var lowJumpFallMultiplier : float = 1.2
@export var stompSpeed : float = 5.0
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


func _process(_delta):
	camera.position = position + cameraOffset
	

static func get_jump_velocity(inputHeight : float, _gravity : float):
	return sqrt(2.0 * _gravity * inputHeight)
	

func get_current_speed():
	var speed := movementSpeed
	if Input.is_action_pressed("boost"):
		speed = boostSpeed
	return speed

func rotate_model_towards(forwardDir : Vector3 ,upDir : Vector3 = Vector3.UP):
	if is_equal_approx(forwardDir.length(), 0):
		return
	model.look_at(transform.origin - forwardDir, upDir)

static func calculate_boost_movement(player : PlayerController, speed : float, acceleration : float, turnSpeed : float,  steeringAmountInDegrees : float, delta : float) -> void:
	if not player.model:
		return
		
	var localInputDir := Vector3.ZERO
	# Get the user's input in all 4 directions.
	localInputDir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) 
	localInputDir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	localInputDir = localInputDir.normalized()
	
	var inputDir = localInputDir.rotated(Vector3.UP, player.camera.rotation.y)
	
	
	# Get the user's left/right input as turn input
	# var turn_input = (Input.get_action_strength("move_left") - Input.get_action_strength("move_right")) * deg_to_rad(steeringAmountInDegrees)
	
	# Apply the model's forward direction.
	player.velocity = player.model.global_transform.basis.z * speed
	
	
	# If the model exists, rotate it based of the turn input
	if player.velocity.length() > 0.2:
		var newDir = player.model.global_transform.basis.z.slerp(inputDir, turnSpeed * delta)
		player.rotate_model_towards(newDir, player.up_direction)
	

static func calculate_movement(player : PlayerController,speed : float, acceleration : float, decceleration : float) -> void:
	var input_dir := Vector3.ZERO
	# Get the user's input in all 4 directions.
	input_dir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) 
	input_dir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	input_dir = input_dir.normalized()
	
	var dir : Vector3
	
	# Transform it to be local to the camera's rotation
	dir = input_dir.rotated(Vector3.UP, player.camera.rotation.y)  #(camera.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply acceleration & decceleration
	if dir:
		player.velocity.x = move_toward(player.velocity.x, dir.x * speed, acceleration)
		player.velocity.z = move_toward(player.velocity.z, dir.z * speed, acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, decceleration)
		player.velocity.z = move_toward(player.velocity.z, 0, decceleration)
	
	# If the model exists and the velocity is high enough, rotate it towards the velocity
	if player.model and player.velocity.length() > 0.2:
		var horizontalVel = Vector3(player.velocity.x, 0, player.velocity.z)
		player.rotate_model_towards(horizontalVel, player.up_direction)

	
