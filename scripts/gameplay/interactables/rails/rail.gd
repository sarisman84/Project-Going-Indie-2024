class_name RailGroup
extends StaticBody3D

var rails: Array[Path3D]
var links: Dictionary

@export var adjacent_rail_detection_radius = 1.0

func _ready() -> void:
	fetch_rails(self)
	link_rails()
	print_info()

func fetch_rails(root: Node) -> void:
	for child in root.get_children():
		if child is Path3D:
			rails.append(child)
		elif child.get_child_count() > 0:
			fetch_rails(child)

func nearest_x_pos_from_rail(index : int) -> Vector3:
	var offset =  rails[index].curve.get_closest_offset(rails[index].position)
	var pos = rails[index].curve.sample_baked(offset)
	return Vector3(1,0,0) * pos.x


func link_rails() -> void:
	links = Dictionary()
	for i in range(rails.size()):
		var x_root = nearest_x_pos_from_rail(i)
		for z in range(rails.size()):
			if i == z:
				continue
			var x_adjacent = nearest_x_pos_from_rail(z)
			var dist = (x_root - x_adjacent).length()
			if dist > adjacent_rail_detection_radius:
				continue

			var dot = basis.x.dot(x_adjacent)
			if dot > 0:
				links[i] = {"left": z}
			else:
				links[i]= {"right": z}

func print_info() -> void:
	if links.is_empty():
		return
	for i in range(rails.size()):
		if links[i].has("left"):
			var left_indx = links[i]["left"]
			DebugDraw3D.draw_arrow(rails[i].global_position, rails[left_indx].global_position, Color.ORANGE, 0.15, true, 10)
		if links[i].has("right"):
			var right_indx = links[i]["right"]
			DebugDraw3D.draw_arrow(rails[i].global_position, rails[right_indx].global_position, Color.ORANGE, 0.15, true, 10)
