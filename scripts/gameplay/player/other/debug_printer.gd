extends Node
@onready var player_controller : PlayerController = $".."
@onready var state_machine : StateMachine = $"../state_machine"


func _process(_delta: float) -> void:
	print_out("FPS: ", Engine.get_frames_per_second())
	print_out("current state: ",  state_machine.state.name)
	print_out("jump count: ", player_controller.currentJumpCount)

func print_out(msg : String, value : Variant = null):
	DebugDraw2D.set_text(msg, value, 0, Color.WHITE, 0)
