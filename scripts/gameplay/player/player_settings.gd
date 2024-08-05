class_name PlayerSettings
extends Resource

@export_group("Default")
@export var movement_speed: float = 5.0
@export var turningSpeed: float = 5.0

@export_group("Jump Settings")
@export var jumpHeight: float = 1.0
@export var jumpCount: int = 2
@export var canJump: bool = true

@export_group("Boost Settings")

@export var sideStepCooldown: float = 0.1
@export var sideStepDistance: float = 10.0
@export var boost_speed: float = 10.0
@export var canBoost: bool = true

@export_group("Fall Settings")
@export var fallMultiplier: float = 1.0
@export var stompSpeed: float = 5.0
@export var fallThreshold: float = 0.0

@export_group("Acceleration Settings")
@export_subgroup("Ground")
@export var acceleration: float = 1.0
@export var decceleration: float = 1.0
@export_subgroup("Air")
@export var air_acceleration: float = 1.0
@export var air_decceleration: float = 1.0
@export_subgroup("Other")
@export var boost_acceleration: float = 1.0
@export var slideDecceleration: float = 0.8

@export_group("Rail Grind Settings")
@export var railDetectionRadius: float = 0.5
@export var railGrindCooldownInSeconds: float = 0.25
