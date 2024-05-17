class_name GrindState
extends PlayerState

@onready var grind_sfx : AudioStreamPlayer3D= $"../../sfx/grind/grind_sfx"
@onready var grind_start_sfx : AudioStreamPlayer3D= $"../../sfx/grind/grind_start_sfx"

@export var exitDelayInSeconds : float = 0.2
var curDelay : float
var stateStarted : bool

signal exitSignal

func enter(_msg := {}) -> void:
	stateStarted = true
	player.animation_player.play("grind")
	grind_start_sfx.play()
	grind_sfx.play()

func update(delta: float) -> void:
	if not stateStarted:
		curDelay -= delta
		if curDelay <= 0:
			exitSignal.emit()
	elif Input.is_action_pressed("jump"):
		state_machine.transition_to("airborne", {do_jump = true, resume_control = true})

func exit() -> void:
	grind_sfx.stop()
	stateStarted = false
	curDelay = exitDelayInSeconds
	player.up_direction = Vector3.UP
	print("exited")
	
