class_name CollectablesManager
extends Node


signal on_data_increment_entry

var magnet_controller : CollectableMagnetController
var collection_database : Array[int]

func _ready() -> void:
	collection_database.resize(5)
	collection_database.fill(-1)


func set_to_database(id : int, value : int) -> void:
	await(_ready)
	assert(collection_database.size() > id, "Set Data: Invalid ID")
	collection_database[id] = value

func add_to_database(id : int, increment_amm : int) -> void:
	await(_ready)
	assert(collection_database.size() > id, "Increment Data: Invalid ID")
	collection_database[id] += increment_amm
	on_data_increment_entry.emit(id)


func get_data(id : int) -> int:
	await(_ready)
	assert(collection_database.size() > id, "Get Data: Invalid ID")
	return collection_database[id]

