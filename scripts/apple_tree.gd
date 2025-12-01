class_name AppleTree extends Location


func _ready() -> void:
	_set_up()
	progress_complete.connect(_on_progress_complete)
	_spawn()
	

func _on_progress_complete()->void:
	_spawn()
