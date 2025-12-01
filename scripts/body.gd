class_name MobBody extends CharacterBody2D

signal stopped_moving
signal action
signal action_ended
signal body_requesting_speed(stat:Stats.STAT)
signal attack

@onready var mob_options_button: MenuButton = %MobOptionsButton
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var action_range: Area2D = %ActionRange
@onready var mob_inventory: MobInventory = %MobInventory


var _target: MobBody
var _moving: bool = false
var _target_pos:Vector2 
var _speed:int
var _margin: float = 4.0
var _attack: int 
var _player_controlled: bool = false

func is_player_controlled() ->bool:
	return _player_controlled

func _ready() -> void:
	input_event.connect(_on_input_event)
	var parent: bool = get_parent()._player_controlled
	if parent:
		_player_controlled = true
	
func _on_input_event(_viewport, event, _shape_idx) -> void:
	if _player_controlled:
		if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
	
			if mob_options_button and mob_options_button.visible:
				return
			
			mob_options_button.visible = true
			print("mob_selected")
			if _speed == 0:
				body_requesting_speed.emit(Stats.STAT.SPD)
	else:
		return

func _physics_process(_delta: float) -> void:
	if _moving:
		var to_target: Vector2 = _target_pos - global_position
		var distance := to_target.length()
		
		if distance <= _margin:
			global_position = _target_pos
			_moving = false
			velocity = Vector2.ZERO
			emit_signal("stopped_moving")
			sprite.play("Idle")
			action_check()
			return

		var dir: Vector2 = to_target.normalized()
		var speed = _speed * 10
		velocity = dir * speed
		move_and_slide()


func player_spawn()->void:
	_player_controlled = true




func action_check() -> void:

	action_range.set_visible(true)
	emit_signal("action")

	for body in action_range.get_overlapping_bodies():
		if body.is_in_group("Item"):
			var item_node = body.get_parent() if body.get_parent().has_method("pick_up") else body
			sprite.play("Action")
			var picked_up: ItemResource = item_node.pick_up()
			mob_inventory.add_item(picked_up)
			print("Pick_Up")
		
		if is_player_controlled() == false:
			if body.is_in_group("MobBody"):
				var mob_body: MobBody = body
				if mob_body.is_player_controlled():
					attack.emit()
					_target = mob_body
			pass
	
	emit_signal("action_ended")


func body_hurt(dmg_stat: Stats.STAT, dmg_value: int) ->void:
	
	pass

func move_to_target(target:Vector2)->void:
	if _moving:
		return
	else:
		_target_pos = target
		_moving = true
		sprite.play("Moving")
		
