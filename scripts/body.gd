class_name MobBody
extends CharacterBody2D

signal stopped_moving
signal action
signal action_ended
signal body_requesting_stat_value(stat: Stats.STAT)
signal attack
signal hit_ended
signal hit_start(dmg_stat: Stats.STAT, dmg_value: int)

@onready var mob_options_button: MenuButton = %MobOptionsButton
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var action_range: Area2D = %ActionRange
@onready var mob_inventory: MobInventory = %MobInventory

# Movement / combat state
var _target: MobBody = null
var _moving: bool = false
var _target_pos: Vector2
var _speed: int = 0
var _margin: float = 4.0
var _attack: int = 0
var _player_controlled: bool = false
var _chasing: bool
var _hit:bool

# Tunables
@export var move_multiplier: float = 10.0   # scale factor for _speed -> pixels/sec

# Helper to avoid requesting stat every frame
var _stat_requested: bool = false

func is_player_controlled() -> bool:
	return _player_controlled

func _ready() -> void:
	connect("input_event", Callable(self, "_on_input_event"))
	var parent = get_parent()
	if parent and parent is Mob:
		if (parent as Mob).is_player_controlled():
			_player_controlled = true

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not is_player_controlled():
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# if the mob options button is shown, ignore the click
		if mob_options_button and mob_options_button.visible:
			return
		if mob_options_button:
			mob_options_button.visible = true
		print("mob_selected")

func _physics_process(delta: float) -> void:
	if not _moving:
		return

	# Request stat value only once per move start
	if _speed <= 0 and not _stat_requested:
		_stat_requested = true
		emit_signal("body_requesting_stat_value", Stats.STAT.SPD)

	# ensure we have a valid target position
	if _target_pos == null:
		_moving = false
		return

	var to_target: Vector2 = _target_pos - global_position
	var distance := to_target.length()

	if distance <= _margin:
		global_position = _target_pos
		_moving = false
		velocity = Vector2.ZERO
		stopped_moving.emit()
		sprite.play("Idle")
		
		# Reset stat request flag so next move will re-request if needed
		_stat_requested = false
		# Run action checks once arrived
		action_check()
		return

	# move toward the target
	var dir: Vector2 = to_target.normalized()
	var speed_pixels = float(_speed) * move_multiplier
	velocity = dir * speed_pixels
	move_and_slide()

# Setter for stats (called by Mob)
func set_stat(stat: Stats.STAT, value: int) -> void:
	match stat:
		Stats.STAT.SPD:
			_speed = value
		Stats.STAT.ATK:
			_attack = value
		_:
			# other stats if needed
			pass

# Action logic: pick up items, detect player mobs, emit attack
func action_check() -> void:
	# show range briefly so designer can see it in-editor; hide afterwards
	if action_range:
		action_range.set_visible(true)

	emit_signal("action")

	# iterate overlapping bodies safely
	for raw in action_range.get_overlapping_bodies():
		if raw == null:
			continue

		# Some overlapping objects might be Areas or PhysicsBodies — only call group checks if available
		if raw is Node and (raw as Node).is_in_group("Item"):
			# If the body is a child of an item wrapper, prefer the parent if it has pick_up
			var item_node: Node = raw
			if raw.get_parent() and raw.get_parent().has_method("pick_up"):
				item_node = raw.get_parent()
			# ensure pick_up exists
			if item_node and item_node.has_method("pick_up"):
				sprite.play("Action")
				var picked_up: ItemResource = item_node.pick_up()
				if mob_inventory:
					mob_inventory.add_item(picked_up)
				print("Pick_Up")

		# Mob combat detection (non-player mobs attack player-controlled mobs)
		if raw is Node:
			var possible_mob := raw as Node
			# If it's a child collider, get its parent which might be the MobBody
			if possible_mob.get_parent() and possible_mob.get_parent() is MobBody:
				possible_mob = possible_mob.get_parent()
			if possible_mob is MobBody:
				var other: MobBody = possible_mob as MobBody
				if other.is_player_controlled() and not is_player_controlled():
					# engage attack
					emit_signal("attack")
					_target = other

	# finished scanning
	emit_signal("action_ended")

	# hide action_range after checks
	if action_range:
		action_range.set_visible(false)

func body_hurt(dmg_stat: Stats.STAT, dmg_value: int) -> void:
	hit_start.emit(dmg_stat, dmg_value)
	_hit = true
	_moving = false
	sprite.play("Hit")
	sprite.animation_finished.connect(_on_animation_finished)
	print(self, " Got hurt by : ", dmg_value, " Amount of dmg")

func move_to_target(target: Vector2) -> void:
	if _moving:
		return
	_target_pos = target
	_moving = true
	# Reset stat request 
	_stat_requested = false
	# play moving animation
	if sprite:
		sprite.play("Moving")


func set_chase(v: bool) ->void:
	_chasing = v
	if _chasing:
		action_range.set_visible(true)
		action_range.body_entered.connect(_on_body_entered_during_chase)
		


func _on_animation_finished()->void:
	sprite.animation_finished.disconnect(_on_animation_finished)
	_hit = false
	hit_ended.emit()
	

func _on_body_entered_during_chase(body: Node2D)->void:
	if body.is_in_group("MobBody") and body.is_player_controlled():
		_target = body
		_moving = false
		velocity = Vector2.ZERO
		stopped_moving.emit()
		action_check()
		
