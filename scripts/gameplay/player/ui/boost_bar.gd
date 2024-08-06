class_name BoostBar
extends ProgressBar


@onready var ghost_bar : ProgressBar = $ghost_bar
@onready var timer : Timer = $timer

@export var smoothing : float

var local_boost_val : float = 0 : set = m_update_bar
var m_update_ghost_bar_flag : bool = false
var m_target_ghost_val : float = 0


func m_update_bar(_new_val : float) -> void:
	var prev_val = local_boost_val
	local_boost_val = min(max_value, _new_val)
	value = local_boost_val

	if local_boost_val <= 0:
		value = 0
		local_boost_val = 0
		return

	if local_boost_val < prev_val:
		timer.start()
	else:
		ghost_bar.value = value


func init_bar(_new_val : float, _max_val : float) -> void:
	local_boost_val = _new_val
	max_value = _max_val
	value = _new_val

	ghost_bar.max_value = _max_val
	ghost_bar.value = _new_val
	pass


func _process(_delta : float) -> void:
	if ghost_bar.value != value and m_update_ghost_bar_flag:
		m_update_ghost_bar(_delta)


func m_update_ghost_bar(delta : float) -> void:
	ghost_bar.value = lerp(m_target_ghost_val, value, smoothing * delta)


func _on_timer_timeout():
	m_update_ghost_bar_flag = true
	m_target_ghost_val = value
