class_name UnitsCommand extends PopupMenu


func _ready() -> void:
	Events.hoard_updated.connect(_on_hoard_updated)
	

func _on_hoard_updated()->void:
	var hoard: Array[Mob] = Globals.get_hoard()
	for mob in hoard:
		var mob_name:String
		var mob_icon: Texture2D = mob.mob_resource.get_icon()
		
		
		add_icon_item(mob_icon, mob_name)
	pass
