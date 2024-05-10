@tool
extends MeshInstance3D

@onready var plane = self
@onready var plane_size = mesh.size

func _process(delta):
	var shader_material = mesh.surface_get_material(0) # Assuming the mesh is the first surface
	if shader_material and shader_material is ShaderMaterial:
		shader_material.set_shader_parameter("plane_pos", plane.global_position)
		shader_material.set_shader_parameter("plane_size", plane_size)
