class_name CurvedRoad
extends Path3D

#@export var hitboxAABB : AABB
#@onready var detection_area = $hitbox
#@onready var detection_collider = $hitbox/collider
#@onready var debug : CurveRoadDebug = $debug
#@onready var model = $model
#
#var player : PlayerController



## Called when the node enters the scene tree for the first time.
#func _ready():
	#detection_collider.global_position = ExtendedUtilities.get_global_aabb_center(hitboxAABB, self)
	#var box_shape := BoxShape3D.new()
	#box_shape.size = hitboxAABB.size
	#detection_collider.shape = box_shape
#
	#detection_area.connect("body_entered", on_body_entered)
	#detection_area.connect("body_exited", on_body_exited)
#
#
#func on_body_entered(body) -> void:
	#player = body as PlayerController
	#pass
#
#func _physics_process(_delta : float) -> void:
	#if player == null:
		#return
#
	#if is_player_on_road():
		#if not player.state_machine.state is AutoMoveState:
			#player.state_machine.transition_to("auto_move", {curved_road = self})
	#else:
		#try_stop_auto_moving()
#
#func try_stop_auto_moving():
	#if player != null and player.state_machine.state is AutoMoveState:
		#player.state_machine.transition_to("moving")
#
#func on_body_exited(body) -> void:
	#try_stop_auto_moving()
	#player = null
#
#
#
#func is_player_on_road() -> bool:
	#var rayLength = 1000
	#var world_state = get_world_3d().direct_space_state
	#var query = PhysicsRayQueryParameters3D.create(player.position, player.position - player.up_direction * rayLength)
	#query.collision_mask = pow(2, 4-1)
	#DebugDraw3D.draw_arrow_ray(player.position, - player.up_direction,rayLength, Color.CORAL, 0.15)
	#var result = world_state.intersect_ray(query)
	#if result.is_empty():
		#return false
#
	#var pos = result["position"]
	#var dist = (pos - player.position).length()
	#var dur = 0.0
	#DebugDraw3D.draw_sphere(pos, 0.15, Color.AQUAMARINE, dur)
	#DebugDraw3D.draw_sphere(player.position, 0.15, Color.AQUAMARINE,dur)
	#DebugDraw3D.draw_lines([pos, player.position],Color.AQUAMARINE,dur)
	#return dist <= 1

