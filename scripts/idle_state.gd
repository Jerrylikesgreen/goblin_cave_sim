class_name IdleState extends Node

var idle_timer: Timer
signal state_ended(state: EnemyStateMachine.EnemyState)


func run_state()->void:
	idle_timer = Timer.new()
	add_child(idle_timer)
	idle_timer.timeout.connect(_on_timeout)
	idle_timer.start(4.0)
	print("Idle State Started")

func _on_timeout()->void:
	_state_ended()


func _state_ended() ->void:
	state_ended.emit(EnemyStateMachine.EnemyState.IDLE)
