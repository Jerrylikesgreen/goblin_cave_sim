class_name SpawnMarker extends Sprite2D

var _spawning_building:bool = false
var _building: Location 

func _ready() -> void:
	Events.spawn_player_building.connect(_on_spawn_player_building)
	
func _process(_delta: float) -> void:
	if _spawning_building:
		# Make this node visible and follow the mouse
		set_visible(true)
		global_position = get_global_mouse_position()
		
		# Detect left click to place the building
		if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			if not _building.is_inside_tree():
				get_parent().add_child(_building)  # Add to the parent node
				_building.global_position = global_position
				_building.player_built()
				_building.is_in_group("Base")

			_spawning_building = false
			set_visible(false)
			print("Building placed!")

func _on_spawn_player_building(building:Location)->void:
	_spawning_building = true
	_building = building
