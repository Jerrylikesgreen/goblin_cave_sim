class_name TargetFlag extends Marker2D

signal target_flag_set(pos: Vector2)


func move_option_selected()->void:
	set_visible(true)

func _physics_process(_delta: float) -> void:
	if is_visible():
		var mouse_pos: Vector2 = get_global_mouse_position()
		set_global_position(mouse_pos)


func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event is InputEventMouseButton and event.is_double_click():
			set_visible(false)
			emit_signal("target_flag_set", global_position)
			print("click")
	else:
		return
