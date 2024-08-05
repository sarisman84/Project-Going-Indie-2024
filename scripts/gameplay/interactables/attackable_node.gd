class_name AttackableNode
extends StaticBody3D

#var cur_index : int = -1
signal on_homing_attack

#func append_self_to_owner(_manager : AttackManager) -> void:
	#cur_index = _manager.aquired_targets.size()
	#_manager.aquired_targets.append({node = self, isInLoS = false, isInView = false, isCloseToCursor = false})
	#DebugDraw2D.set_text("HA: target found: ",cur_index, 0, Color.WHITE,3.0)
#
#func remove_self_from_owner(_manager : AttackManager) -> void:
	#if _manager.aquired_targets.size() > 0 and _manager.aquired_targets.size() > cur_index:
		#_manager.aquired_targets.remove_at(cur_index)
		#cur_index = _manager.aquired_targets.size()
		#DebugDraw2D.set_text("HA: target lost: ",cur_index, 0, Color.WHITE,3.0)


func verify_self(resulting_data) -> bool:
	var col_path = resulting_data.collider.get_path()
	return get_path() == col_path

