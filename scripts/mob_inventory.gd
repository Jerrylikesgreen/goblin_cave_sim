class_name MobInventory extends Node




var _storage:Array[ItemResource]
var _MAX_STORAGE: int = 5


func add_item(new_item)->void:
	var current_count = _storage.size()
	if current_count < _MAX_STORAGE:
		_storage.append(new_item)
	else:
		push_warning( get_parent().name,   "'s Inventory is at high capacity and cant add another item")
		return

func get_food() -> Array[ItemResource]:
	var _food: Array[ItemResource] = []
	
	for item in _storage.duplicate():
		
		if item.item_type == ItemResource.ItemType.FOOD:
			print(_storage)
			_food.append(item)
			_storage.erase(item)
		else:
			return _food
	return _food
	
