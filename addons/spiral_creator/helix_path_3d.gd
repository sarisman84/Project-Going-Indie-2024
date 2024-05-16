@tool
extends EditorPlugin

var plugin = preload("res://addons/spiral_creator/helix_path_3d_editor.gd")

func _enter_tree():
	plugin = plugin.new()
	add_inspector_plugin(plugin)
	pass


func _exit_tree():
	remove_inspector_plugin(plugin)
