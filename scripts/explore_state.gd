class_name ExploreState
extends Node

signal explore_state_start

@onready var enemy_state_machine: EnemyStateMachine = %EnemyStateMachine

var _is_running: bool = false
var timer: Timer


func run_state() -> void:
	if _is_running:
		print("ExploreState already running — run_state ignored")
		return
	if not timer:
		timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(_end_state)
	timer.start(5.0)
	_is_running = true
	explore_state_start.emit()
	print("ExploreState STARTED")


func _end_state() -> void:
	_is_running = false
	print("ExploreState ENDED")
