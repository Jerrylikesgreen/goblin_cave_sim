## Autoload: TimeTracker Tracks time spent in game. 
extends Node

var time: Timer
var _wait_time: float = 10.0

func _ready() -> void:
	time = Timer.new()
	time.set_wait_time(_wait_time)
	time.timeout.connect(_on_timeout)
	add_child(time)
	time.start()

func _on_timeout()->void:
	Events.day_increase()
