class_name Goblin extends Mob





func _on_action_option_pressed(option: Actions.ACTION_OPTION)->void:
	if option == Actions.ACTION_OPTION.STORE_FOOD and _mob_state == MobState.SELECTED_ACTION:
		print("triger action_range")
		action_range.set_visible(true)
		var bodies = action_range.get_overlapping_areas()
		if bodies.is_empty():
			_on_action_ended()
		for _area in bodies:
			if _area.get_parent().is_in_group("Base"):
				var base:Location = _area.get_parent()
				var _food: Array[ItemResource] = body.mob_inventory.get_food()
				print("Base")
				if _food.is_empty():
					print("No food")
					return
				else:
					base.store_food(_food)
