extends Node3D

@onready var player_controller : PlayerController = $".."

var rays : Array[RayCast3D]

func recursive_ray_get(root : Node3D) -> void:
	for child in root.get_children():
		if not child is RayCast3D:
			recursive_ray_get(child)
		else:
			rays.append(child)

func _ready() -> void:
	recursive_ray_get(self)





func _physics_process(_delta : float) -> void:
	for ray in rays:
		if not ray.is_colliding():
			continue

		player_controller.up_direction = ray.get_collision_normal()
		player_controller.forwardDirection = -player_controller.model.basis.x.cross(player_controller.up_direction)
		DebugDraw3D.draw_sphere(ray.get_collision_point(),0.25, Color.GREEN)
		return

	#var closest_obj = get_closest_obj(detected_ground_objs)
	#if closest_obj == null:
		#return
#
	#player_controller.up_direction = get_obj_normal(closest_obj)
