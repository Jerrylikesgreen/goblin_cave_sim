class_name ExploreRange extends Area2D


func detect_objective() -> Node2D:
	var objective:Node2D = null
	if is_visible():
		push_error("Already active")
		return objective
	else:
		set_visible(true)
		var detected_bodies: Array[Node2D] = get_overlapping_bodies()
		for body in detected_bodies:
			if body.is_in_group("MobBody"):
				var mob_body: MobBody = body
				if mob_body.is_player_controlled():
					objective = mob_body
					print("Player Body Detected. ")
		var _detected_areas: Array[Area2D] = get_overlapping_areas()
		## TODO - work out logic for other objective, like locations, ect. 
		return objective
