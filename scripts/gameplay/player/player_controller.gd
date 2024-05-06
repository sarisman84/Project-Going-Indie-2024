class_name PlayerController
extends CharacterBody3D

enum States {Idle, Moving, Airborne, Grinding }

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumpFlag : bool

@onready var defaultControls : bool = true

@onready var camera = $camera_anchor

@export var movementSpeed : float = 5.0
@export var boostSpeed : float = 10.0
@export var jumpHeight : float = 1.0
@export var fallMultiplier : float = 1.0
@export var lowJumpFallMultiplier : float = 1.2
@export var groundAcceleration : float = 1.0
@export var groundDecceleration : float = 1.0
@export var airAcceleration : float = 1.0
@export var airDecceleration : float = 1.0
@export var slideDecceleration : float = 0.8

@export var cameraOffset : Vector3
@export var model : Node3D

var currentState : States

func set_default_controls(newState):
	defaultControls = newState

func _physics_process(delta):
	if not defaultControls:
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jumpFlag = false
		
	# Check if the user is grounded first before jumping
	if Input.is_action_pressed("jump") and !jumpFlag and is_on_floor():
		jumpFlag = true
		# Calculate the jump velocity from the jump height
		velocity.y = get_jump_velocity(jumpHeight)
	
	# Get the user input
	var input_dir : Vector3
	input_dir.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) 
	input_dir.z = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	
	var dir : Vector3
	
	# Transform it to be local to the camera's rotation
	dir = input_dir.rotated(Vector3.UP, camera.rotation.y)  #(camera.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# By default, use ground acceleration & decceleration
	var acceleration = groundAcceleration
	var decceleration = groundDecceleration
	
	# Use air acceleration & decceleration if not on the floor
	if not is_on_floor():
		acceleration = airAcceleration
		decceleration = airDecceleration
		
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
		rotate_model_towards(dir, up_direction)
	
	# Apply calculations
	move_and_slide()
	
func _process(delta):
	camera.position = position + cameraOffset
	update_states()

func get_jump_velocity(inputHeight : float):
	return sqrt(2.0 * gravity * inputHeight)
	
func update_states():
	if is_on_floor():
		if velocity.length() > 2.0:
			currentState = States.Moving
		else:
			currentState = States.Idle
	elif currentState != States.Grinding:
		currentState = States.Airborne

func get_current_speed():
	var speed := movementSpeed
	if Input.is_action_pressed("boost"):
		speed = boostSpeed
	return speed

func rotate_model_towards(forwardDir : Vector3 ,upDir : Vector3 = Vector3.UP):
	model.look_at(transform.origin - forwardDir, upDir)

	
