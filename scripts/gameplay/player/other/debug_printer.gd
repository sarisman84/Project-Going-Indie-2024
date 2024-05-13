@tool
extends Node
@onready var player_controller : PlayerController = $".."
@onready var state_machine : StateMachine = $"../state_machine"
@onready var collider = $"../collider"

var cachedYPos : float

func _process(_delta: float) -> void:
	print_messages()
	draw_debug()

func draw_debug() -> void:
	if not player_controller.is_on_floor():
		DebugDraw3D.draw_sphere(player_controller.global_position,0.15, Color.AQUA,0.5)
	
	if not Engine.is_editor_hint():
		DebugDraw3D.draw_sphere(player_controller.position, collider.shape.radius, Color.AQUA)
	
	if player_controller.is_on_floor():
		cachedYPos = player_controller.global_position.y
	
	var pos = Vector3(player_controller.global_position.x,cachedYPos, player_controller.global_position.z)
	DebugDraw3D.draw_arrow_ray(pos, player_controller.up_direction, player_controller.jumpHeight, Color.CYAN, 0.15, false)
		
		
	

func print_messages() -> void:
	if Engine.is_editor_hint():
		return
	print_out("FPS: ", Engine.get_frames_per_second())
	print_out("current state: ",  state_machine.state.name)
	print_out("jump count: ", player_controller.currentJumpCount)

func print_out(msg : String, value : Variant = null):
	DebugDraw2D.set_text(msg, value, 0, Color.WHITE, 0)
