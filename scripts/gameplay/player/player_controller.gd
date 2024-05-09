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
@export_category("Fall Settings")
@export var fallMultiplier : float = 1.0
@export var lowJumpFallMultiplier : float = 1.2
@export_category("Acceleration Settings")
@export var groundAcceleration : float = 1.0
@export var groundDecceleration : float = 1.0
@export var airAcceleration : float = 1.0
@export var airDecceleration : float = 1.0
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

func calculate_movement(acceleration : float, decceleration : float) -> void:
	var input_dir := Vector3.ZERO
	input_dir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) 
	input_dir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	input_dir = input_dir.normalized()
	
	var dir : Vector3
	
	# Transform it to be local to the camera's rotation
	dir = input_dir.rotated(Vector3.UP, camera.rotation.y)  #(camera.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	## Use air acceleration & decceleration if not on the floor
	#if not is_on_floor():
		#acceleration = airAcceleration
		#decceleration = airDecceleration
		
	var speed = get_current_speed()
	
	# Apply acceleration & decceleration
	if dir:
		velocity.x = move_toward(velocity.x, dir.x * speed, acceleration)
		velocity.z = move_toward(velocity.z, dir.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, decceleration)
		velocity.z = move_toward(velocity.z, 0, decceleration)
	
	if model and velocity.length() > 0.2:
		#var local_dir = Vector2(velocity.z, velocity.x)
		#model.rotation.y = local_dir.angle()
		var horizontalVel = Vector3(velocity.x, 0, velocity.z)
		rotate_model_towards(horizontalVel, up_direction)
	pass

	
