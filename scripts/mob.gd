class_name Mob extends Node2D

signal mob_state_change(state: MobState)


@export var mob_resource: MobResource

enum MobState {IDLE, SELECTED_COMMAND,SELECTED_ACTION, MOVING, ACTION, HURT, DEAD}
var _mob_state: MobState = MobState.IDLE
var _prior_state: MobState



const MOB_STATE_TO_STRING = {
	MobState.IDLE: "IDLE",
	MobState.SELECTED_COMMAND: "SELECTED_COMMAND",
	MobState.SELECTED_ACTION: "SELECTED_ACTION",
	MobState.MOVING: "MOVING",
	MobState.ACTION: "ACTION",
	MobState.HURT: "HURT",
	MobState.DEAD: "DEAD"
}
@onready var explore_range: ExploreRange = %ExploreRange
@onready var action_range: Area2D = %ActionRange
@onready var actions: Actions = %Actions
@onready var body: MobBody = %Body

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var target_flag: Marker2D = %TargetFlag
@onready var mob_options_button: MobOptionsButton = %MobOptionsButton
@onready var enemy_timer: Timer = %EnemyTimer
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine

var _player_controlled:bool = false

func is_player_controlled() ->bool:
	return _player_controlled

func _ready() -> void:
	body.body_requesting_speed.connect(_on_body_set_up)
	mob_options_button.option_pressed.connect(_on_option_pressed)
	target_flag.target_flag_set.connect(_on_target_flag_set)
	body.stopped_moving.connect(_on_stopped_moving)
	body.action.connect(_on_action)
	body.action_ended.connect(_on_action_ended)
	actions.action_option_pressed.connect(_on_action_option_pressed)
	enemy_state_machine.explore_state_start.connect(_on_explore_state_start)
	body.body_requesting_stat_value.connect(_on_requesting_stat_value)
	body.attack.connect(_on_attack)


func _on_attack()->void:
	_state_change(MobState.ACTION)
	body.sprite.play("Action")
	var dmg_stat = Stats.STAT.ATK
	var dmg_value = mob_resource.get_stat_value(dmg_stat)
	body._target.body_hurt(dmg_stat, dmg_value)
	pass

func _on_requesting_stat_value(stat:Stats.STAT)-> int:
	var requested_stat: int 
	mob_resource.get_stat(stat)
	
	return requested_stat

func _on_body_set_up(stat:Stats.STAT)->void:
	var value = requesting_stat(stat)
	body._speed = value
	print(str(value) + " being sent to body as speed")

func requesting_stat(stat: Stats.STAT)->int:
	var requested_stat_value:  = mob_resource.stats.get_stat_value(stat)
	return requested_stat_value

func player_spawn()->void:
	_player_controlled = true
	body.player_spawn()
	enemy_timer.start(2.0)

func _on_explore_state_start() ->void:
	if _mob_state == MobState.IDLE:
		# TODO
		# trigger action range to detect an objective. 
		var objective: Node2D = explore_range.detect_objective()
		
		if objective == MobBody:
			var target: MobBody = objective
			
			if target.is_player_controlled():
				_state_change(MobState.MOVING)
				body.move_to_target(target.global_position)

	else:
		pass

func get_current_state_as_string(state: MobState )->String:
	return MOB_STATE_TO_STRING[state]

func _on_action_option_pressed(option: Actions.ACTION_OPTION)->void:
	if option == Actions.ACTION_OPTION.STORE_FOOD:
		print("Action Mob")
		_on_action_ended()


func _on_action()->void:
	_state_change(MobState.ACTION)

func _on_action_ended()->void:
	_state_change(MobState.IDLE)

func _on_stopped_moving()->void:
	if _mob_state == MobState.MOVING:
		_state_change(MobState.IDLE)
	else:
		return

func _on_target_flag_set(target: Vector2)->void:
	if _mob_state == MobState.SELECTED_COMMAND:
		_state_change(MobState.MOVING)
		body.move_to_target(target)
	
func _on_option_pressed(option: MobOptionsButton.OPTION)->void:
	print("signal received :", option)
	if _mob_state == MobState.IDLE:
		_state_change(MobState.SELECTED_COMMAND)
		match option:
			
			MobOptionsButton.OPTION.MOVE:
				print("Move Pressed.")
				_move_pressed()
				
			MobOptionsButton.OPTION.ACTION:
				print("Action Pressed.")
				_check_actions()
				_state_change(MobState.SELECTED_ACTION)

	else:
		return

func _check_actions()->void:
	pass

func _state_change(state: MobState)->void:
	if state == _mob_state:
		return 
	_prior_state = _mob_state
	_mob_state = state
	emit_signal("mob_state_change", state)

func _move_pressed()->void:
	if target_flag.is_visible():
		print_debug("Target flag is visible")
		return
	target_flag.move_option_selected()
	pass
