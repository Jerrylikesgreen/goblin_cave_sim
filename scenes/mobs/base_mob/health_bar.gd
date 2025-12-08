class_name HealthBar extends ProgressBar

@onready var mob: Mob = $"../.."


func _ready() -> void:
	mob.mob_hit.connect(_on_mob_hit)


func _on_mob_hit(new_health:int, max_health: int) ->void:
	if max_value == max_health:
		pass
	else:
		max_value = max_health
	set_value(new_health)
	
	print(self, new_health)
