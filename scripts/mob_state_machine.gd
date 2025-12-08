class_name EnemyStateMachine
extends Node

signal explore_state_start
signal is_chase_state(bool)


@onready var mob: Mob = $".."                 
@onready var idle_state: IdleState = %IdleState
@onready var explore_state: ExploreState = %ExploreState
@onready var chase_state: ChaseState = %ChaseState

var _enemy_timer: Timer = null

enum EnemyState { IDLE, EXPLORE, CHASE, ACTION, REST }
var _enemy_state: EnemyState = EnemyState.IDLE
var _prior_state: EnemyState

const ENEMY_STATE = {
	EnemyState.IDLE: "Idle",
	EnemyState.EXPLORE: "Explore",
	EnemyState.CHASE: "Chase",
	EnemyState.ACTION: "Action",
	EnemyState.REST: "Rest"
}

var _initial_startup: bool = true

## Setup and Break down ---------------------------------------
func _ready() -> void:
	if idle_state:
		idle_state.state_ended.connect(_on_state_ended)

func _exit_tree() -> void:
	_stop_timer()
	if idle_state:
		if idle_state.state_ended.is_connected(_on_state_ended):
			idle_state.state_ended.disconnect(_on_state_ended)


## Public -----------------------------------------

## Starts the State Machine. 
func run() -> void:
	if _enemy_timer != null:
		return

	_enemy_timer = Timer.new()
	_enemy_timer.wait_time = 2.0
	_enemy_timer.one_shot = false
	add_child(_enemy_timer)
	_enemy_timer.timeout.connect(_on_timeout)
	_enemy_timer.start()

	if explore_state and not explore_state.explore_state_start.is_connected(_on_explore_state_start):
		explore_state.explore_state_start.connect(_on_explore_state_start)

func stop() -> void:
	_stop_timer()
	if explore_state and explore_state.explore_state_start.is_connected(_on_explore_state_start):
		explore_state.explore_state_start.disconnect(_on_explore_state_start)


func run_chase_state()->void:
	if chase_state:
		_change_state(EnemyState.CHASE)
		chase_state.run_state()
		is_chase_state.emit(true)


func run_idle_state() -> void:
	if idle_state:
		idle_state.run_state()



## Private ---------------------------------

func _on_explore_state_start() -> void:
	emit_signal("explore_state_start")

func _on_state_ended(state: EnemyState) -> void:
	match state:
		EnemyState.IDLE:
			_change_state(EnemyState.EXPLORE)
			if explore_state:
				
				explore_state.run_state()
			print("Going to Explore")
		EnemyState.EXPLORE:
			_change_state(EnemyState.IDLE)
			explore_state.end_state()
			if idle_state:
				idle_state.run_state()
		# add other state transitions as desired
		_:
			pass


func _stop_timer() -> void:
	if _enemy_timer:
		if _enemy_timer.is_connected("timeout", _on_timeout):
			_enemy_timer.timeout.disconnect(_on_timeout)
		_enemy_timer.stop()
		_enemy_timer.queue_free()
		_enemy_timer = null




func _on_timeout() -> void:
	if _initial_startup:
		_initial_startup = false
		_change_state(EnemyState.EXPLORE)
	if explore_state:
		explore_state.run_state()
	print("Explore State Active")
	# you can add periodic behavior here if needed




func _change_state(state: EnemyState) -> void:
	_prior_state = _enemy_state
	_enemy_state = state
	print("EnemyStateMachine: changed state to %s" % ENEMY_STATE.get(state, str(state)))
