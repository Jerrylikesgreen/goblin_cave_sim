class_name FoodCount extends VBoxContainer



var count: Label 


func _ready() -> void:
	call_deferred("_after_ready")

func _after_ready() -> void:
	count = find_child("Count")
