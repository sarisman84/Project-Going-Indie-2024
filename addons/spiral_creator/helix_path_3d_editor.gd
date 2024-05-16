extends EditorInspectorPlugin

func _can_handle(object):
	return object is HelixPath3D

func _parse_category(object, category):
	if category != "helix_path_3d.gd":
		return
	var b = Button.new()
	b.text = "Generate Helix"
	add_custom_control(b)
	var hp = object as HelixPath3D
	
	b.connect("pressed", hp.generate_helix) #.connect(hp.generate_helix())

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if name == "rect_pivot_offset":
		add_property_editor(name,object, true)
