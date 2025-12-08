class_name Mob extends Node2D

signal mob_state_change(state: Goblin.MobState)
signal mob_hit

@onready var explore_range: ExploreRange = %ExploreRange
@onready var action_range: Area2D = %ActionRange
@onready var actions: Actions = %Actions
@onready var body: MobBody = %Body

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var target_flag: Marker2D = %TargetFlag
@onready var mob_options_button: MobOptionsButton = %MobOptionsButton
@onready var enemy_state_machine: EnemyStateMachine = %EnemyStateMachine



@export var mob_resource: MobResource

enum MobState {IDLE, SELECTED_COMMAND,SELECTED_ACTION, MOVING, ACTION, HURT, DEAD}
var _mob_state: MobState = MobState.IDLE
var _prior_state: MobState
var _player_controlled:bool = false
var _chasing: bool 

const MOB_STATE_TO_STRING = {
	MobState.IDLE: "IDLE",
	MobState.SELECTED_COMMAND: "SELECTED_COMMAND",
	MobState.SELECTED_ACTION: "SELECTED_ACTION",
	MobState.MOVING: "MOVING",
	MobState.ACTION: "ACTION",
	MobState.HURT: "HURT",
	MobState.DEAD: "DEAD"
}

func _ready() -> void:
	mob_options_button.option_pressed.connect(_on_option_pressed)
	target_flag.target_flag_set.connect(_on_target_flag_set)
	body.stopped_moving.connect(_on_stopped_moving)
	body.action.connect(_on_action)
	body.action_ended.connect(_on_action_ended)
	body.body_requesting_stat_value.connect(_on_requesting_stat_value)
	body.attack.connect(_on_attack)
	body.hit_start.connect(_on_hit)
	actions.action_option_pressed.connect(_on_action_option_pressed)
	enemy_state_machine.explore_state_start.connect(_on_explore_state_start)
	enemy_state_machine.is_chase_state.connect(_on_is_chase_state)
	if !is_player_controlled():
		enemy_state_machine.run()


func is_player_controlled() ->bool:
	return _player_controlled


func get_current_state_as_string(state: MobState )->String:
	return MOB_STATE_TO_STRING[state]


func requesting_stat_value(stat: Stats.STAT)->int:
	var requested_stat_value:int  = mob_resource.stats.get_stat_value(stat)
	return requested_stat_value

func player_controlled()->void:
	_player_controlled = true


func get_random_point_in_area(area: Area2D) -> Vector2:
	var shape := area.get_node("CollisionShape2D").shape as CircleShape2D
	var r = shape.radius
	var angle = randf() * TAU
	var dist = sqrt(randf()) * r  # uniform distribution
	var local_point = Vector2(dist, 0).rotated(angle)
	return area.to_global(local_point)





func _on_attack()->void:
	_state_change(MobState.ACTION)
	body.sprite.play("Action")
	var dmg_stat = Stats.STAT.ATK
	var dmg_value = mob_resource.get_stat_value(dmg_stat)
	body._target.body_hurt(dmg_stat, dmg_value)

func _on_requesting_stat_value(stat:Stats.STAT)-> void:
	var value:int = mob_resource.get_stat_value(stat)
	body.set_stat(stat, value)
	print("Setting speed")


func _on_explore_state_start() ->void:
	if _mob_state == MobState.IDLE:
		var objective: Node2D = explore_range.detect_objective()
		
		if objective:
			
			var target: MobBody = objective
			
			if target.is_player_controlled():
				_state_change(MobState.MOVING)
				body.move_to_target(target.global_position)
				enemy_state_machine.run_chase_state()

		else:
			if explore_range.is_visible() == false:
				explore_range.set_visible(true)
			var target_pos = get_random_point_in_area(explore_range)
			body.move_to_target(target_pos)
			explore_range.set_visible(false)

func _on_action_option_pressed(option: Actions.ACTION_OPTION)->void:
	if option == Actions.ACTION_OPTION.STORE_FOOD:
		print("Action Mob")
		_on_action_ended()


func _on_action()->void:
	_state_change(MobState.ACTION)

func _on_action_ended()->void:
	_state_change(MobState.IDLE)
	print("Action Ended - Going to Idle")
	

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
		enemy_state_machine.run_idle_state()
		mob_state_change.emit(state)
	else:
		_prior_state = _mob_state
		_mob_state = state
	
	mob_state_change.emit(state)

func _move_pressed()->void:
	if target_flag.is_visible():
		print_debug("Target flag is visible")
		return
	target_flag.move_option_selected()

func _on_hit(dmg_stat: Stats.STAT, dmg_value: int)->void:
	mob_hit.emit()

func _on_is_chase_state(is_chase_state: bool)->void:
	_chasing = is_chase_state
	body.set_chase(is_chase_state)
