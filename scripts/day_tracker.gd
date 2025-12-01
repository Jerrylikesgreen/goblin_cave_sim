class_name DayTracker extends Label


func _ready() -> void:
	Events.day_increased.connect(_on_day_increase)
	
func _on_day_increase()->void:
	set_text(str(Globals.day))
	
