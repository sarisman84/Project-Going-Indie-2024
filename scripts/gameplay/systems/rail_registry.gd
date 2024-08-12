extends Node

var m_rail_collection : Array[Path3D]


func register_rail(input : Path3D) -> void:
    m_rail_collection.append(input)


func get_collection() -> Array[Path3D]:
    return m_rail_collection