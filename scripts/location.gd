class_name Location extends Node2D

signal progress_complete
@export var spawn_rate: float = 2.0
@export var spawnable: Array[PackedScene]
@onready var location_sprite: Sprite2D = %LocationSprite
@onready var spawn_progress_bar: ProgressBar = %SpawnProgressBar
@onready var spawn_tick: Timer = %SpawnTick


var _player_controlled: bool = false
var _mobs_inside: Array[Mob]
var _spawn_count:int = 0
@export var max_spawn_count:int = 1
var _food_collected:Array[ItemResource]


func player_built()->void:
	_player_controlled = true

func _ready() -> void:
	_set_up()

func _set_up() ->void:
	_spawn()
	spawn_tick.start()
	spawn_tick.timeout.connect(_on_spawn_tick)


func _on_spawn_tick() -> void:
	print(self, " ", spawn_rate)
	var progress_rate:float 
	if _food_collected.size() == 0:
		progress_rate = 1 * spawn_rate
	else:
		progress_rate = _food_collected.size() * spawn_rate + 1
	
	spawn_progress_bar.value = spawn_progress_bar.value + progress_rate

	if spawn_progress_bar.value >= spawn_progress_bar.max_value:
		progress_complete.emit()


func _spawn()->void:
	if max_spawn_count > _spawn_count:
		var spawn: Node2D = spawnable[0].instantiate()
		_spawn_count += 1
		if _player_controlled:
			spawn.player_controlled()
			Events.add_to_hoard(spawn)
			print("Player")
		if spawn.is_in_group("Item"):
			spawn.picked_up.connect(_on_pickup)
		
		add_child(spawn)

func store_food(food:Array[ItemResource])->void:
	if _player_controlled:
		_food_collected.append_array(food)
		print(self, " food collected", _food_collected)
		Globals.store_item(food)

func _on_pickup()->void:
	_spawn_count = _spawn_count - 1
