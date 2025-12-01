extends Label

@onready var goblin: Goblin = $"../.."



func _ready() -> void:
	goblin.mob_state_change.connect(_on_mob_state_change)
	
func _on_mob_state_change(state: Goblin.MobState)->void:
	var t:String = goblin.get_current_state_as_string(state)
	set_text(t)
