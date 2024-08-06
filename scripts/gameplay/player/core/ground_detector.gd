class_name GroundDetector
extends Node3D

var raycasts : Array[RayCast3D]

var collided_ray : RayCast3D

func _ready() -> void:
    m_fetch_raycasts(self)
    pass


func m_fetch_raycasts(root : Node3D) -> void:
     for child in root.get_children():
        if child is RayCast3D:
            raycasts.append(child)
        else:
            m_fetch_raycasts(child)


func _physics_process(_delta : float) -> void:
    for ray in raycasts:
        if ray.is_colliding():
            collided_ray = ray
            DebugDraw3D.draw_position(Transform3D(Vector3.LEFT, Vector3.UP, Vector3.FORWARD, ray.get_collision_point()),Color.MAGENTA)
            return


func get_collided_ray() -> RayCast3D:
    return collided_ray