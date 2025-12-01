class_name IdleState extends Node


signal state_ended()


func run_state()->void:
	pass

func _state_ended() ->void:
	state_ended.emit()
