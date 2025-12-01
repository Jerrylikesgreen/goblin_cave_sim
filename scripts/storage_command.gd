class_name StorageCommand extends PopupMenu

signal display_inventory

func _ready() -> void:
	id_pressed.connect(_on_id_pressed)
	

func _on_id_pressed(id:int)->void:
	match id:
		1:
			display_inventory.emit()
