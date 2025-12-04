class_name EnemyStateMachine
extends Node

signal explore_state_start

@onready var mob: Mob = $".."                     # ok if the StateMachine is a child of the Mob node
@onready var idle_state: IdleState = %IdleState
@onready var explore_state: ExploreState = %ExploreState

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

func _ready() -> void:
	# connect once
	if idle_state:
		idle_state.state_ended.connect(_on_state_ended)
	if mob:
		mob.mob_state_change.connect(_on_mob_state_change)

func _exit_tree() -> void:
	# cleanup timer if this node is removed
	_stop_timer()
	if idle_state:
		if idle_state.state_ended.is_connected(_on_state_ended):
			idle_state.state_ended.disconnect(_on_state_ended)
	if mob:
		if mob.mob_state_change.is_connected(_on_mob_state_change):
			mob.mob_state_change.disconnect(_on_mob_state_change)

# Called when Mob emits a state change; keep the EnemyStateMachine synced when appropriate
func _on_mob_state_change(state: Mob.MobState) -> void:
	match state:
		Mob.MobState.IDLE:
			run_idle_state()
			print("EnemyStateMachine: running Idle")
		_:
			# other mob-driven transitions can go here if needed
			pass

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

# Public: start the state machine loop
func run() -> void:
	# prevent double-run creating multiple timers
	if _enemy_timer != null:
		return

	_enemy_timer = Timer.new()
	_enemy_timer.wait_time = 2.0
	_enemy_timer.one_shot = false
	add_child(_enemy_timer)
	_enemy_timer.timeout.connect(_on_timeout)
	_enemy_timer.start()

	# connect explore state emitter once
	if explore_state and not explore_state.explore_state_start.is_connected(_on_explore_state_start):
		explore_state.explore_state_start.connect(_on_explore_state_start)

func stop() -> void:
	_stop_timer()
	if explore_state and explore_state.explore_state_start.is_connected(_on_explore_state_start):
		explore_state.explore_state_start.disconnect(_on_explore_state_start)

func _stop_timer() -> void:
	if _enemy_timer:
		if _enemy_timer.is_connected("timeout", _on_timeout):
			_enemy_timer.timeout.disconnect(_on_timeout)
		_enemy_timer.stop()
		_enemy_timer.queue_free()
		_enemy_timer = null

func run_idle_state() -> void:
	if idle_state:
		idle_state.run_state()

func explore_end() -> void:
	explore_state.end_state()
	print("end explore")
	_change_state(EnemyState.IDLE)
	if idle_state:
		idle_state.run_state()

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
