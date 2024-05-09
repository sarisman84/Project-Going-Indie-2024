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
	if forwardDir == Vector3.ZERO:
		return
	model.look_at(transform.origin - forwardDir, upDir)

func move(acceleration : float, decceleration : float) -> void:
	pass

	
