extends Node

signal day_increased
signal spawn_player_building(building)
signal player_inventory_updated
signal hoard_updated

func add_to_hoard(spawn:Node2D )->void:
	Globals.add_to_hoard(spawn)

func day_increase()->void:
	if Globals.day_increase_check():
		day_increased.emit()

func building_selected(building:Location)->void:
	spawn_player_building.emit(building)

func items_stored_in_player_inventory()->void:
	player_inventory_updated.emit()

func hoard_gloable_updated()->void:
	hoard_updated.emit()
