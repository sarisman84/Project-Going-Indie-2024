class_name PlayerSettings
extends Resource

@export_group("Default")
@export var movement_speed: float = 5.0
@export var visual_turning_speed: float = 5.0

@export_group("Jump Settings")
@export var jump_height: float = 1.0
@export var jump_count: int = 2
@export var can_jump: bool = true

@export_group("Boost Settings")
@export var side_step_cooldown: float = 0.1
@export var side_step_distance: float = 10.0
@export var boost_speed: float = 10.0
@export var can_boost: bool = true
@export var boost_turn_speed : float = 1.0
@export var max_ring_energy : float = 100.0
@export var ring_energy_gain : float = 15.0
@export var ring_energy_use : float = 5.0

@export_group("Fall Settings")
@export var fall_multiplier: float = 1.0
@export var stomp_speed: float = 5.0
@export var fall_threshold: float = 0.0

@export_group("Acceleration Settings")
@export_subgroup("Ground")
@export var acceleration: float = 1.0
@export var decceleration: float = 1.0
@export_subgroup("Air")
@export var air_acceleration: float = 1.0
@export var air_decceleration: float = 1.0
@export_subgroup("Other")
@export var boost_acceleration: float = 1.0
@export var slide_decceleration: float = 0.8

@export_group("Rail Grind Settings")
@export var rail_detection_radius: float = 0.5
@export var rail_grind_cooldown_in_seconds: float = 0.25
