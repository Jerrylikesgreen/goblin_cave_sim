class_name EnemyStateMachine extends Node

signal explore_state_start

@onready var enemy_timer: Timer = %EnemyTimer
@onready var idle_state: IdleState = %IdleState
@onready var explore_state: ExploreState = %ExploreState

enum EnemyState { IDLE, EXPLORE, CHASE, ACTION, REST }
var _enemy_state: EnemyState = EnemyState.IDLE
var _prior_state: EnemyState

var _initial_startup: bool = true

func _ready() -> void:
	enemy_timer.timeout.connect(_on_timeout)
	explore_state.explore_state_start.connect(_on_explore_state_start)

func _on_explore_state_start()->void:
	explore_state_start.emit()


# TODO
# On start up mob will go into 
# Explore: runs all logic/functions to detect arround.
# CHASE: once it detects an objective (find resource, detects enemy player)
# it moves to pos of target. 
# ACTION: performes logic/function depending on objective when at pos. 
# REST: If needed can rest to restore stats / resources if needed. 
# IDLE: if rest is not needed will go to Idle then Back to Explore. 


func _on_timeout()->void:
	if _initial_startup:
		_initial_startup = false
		_change_state(EnemyState.EXPLORE)
		explore_state.run_state()
		

func _change_state(state: EnemyState)->void:
	_prior_state = _enemy_state
	_enemy_state = state
