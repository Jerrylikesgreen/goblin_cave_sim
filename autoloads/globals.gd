extends Node

var total_hoard: int 
var day: int

var _player_hoard: Array[Mob]

var _player_inventory:Array[ItemResource] = [
	
]

func day_increase_check()->bool:
	var _day = day
	day = _day + 1
	return true

func get_inventory()->Array[ItemResource]:
	return _player_inventory

func add_to_hoard(spawn) ->void:
	_player_hoard.append(spawn)
	Events.hoard_gloable_updated()

func get_hoard() -> Array[Mob]:
	return _player_hoard

func store_item(items:Array)->void:
	var items_being_stored:Array[ItemResource] = items
	_player_inventory.append_array(items)
	Events.items_stored_in_player_inventory()
