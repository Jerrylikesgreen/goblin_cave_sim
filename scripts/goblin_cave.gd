class_name GoblinCave extends Location


func _ready() -> void:
	_set_up()
	progress_complete.connect(_on_progress_complete)
	

func _on_progress_complete()->void:
	pass
