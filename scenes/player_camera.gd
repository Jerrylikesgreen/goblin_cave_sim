class_name PlayerCamera
extends Camera2D

@export var zoom_speed := 0.1
@export var min_zoom := 0.5
@export var max_zoom := 3.0
@export var drag_speed := 1.0  # multiplier for mouse drag speed

var tween: Tween
var target_zoom: float = 1.0   # current zoom level stored as a scalar
var dragging: bool = false
var last_mouse_pos: Vector2

func _ready() -> void:
	zoom = Vector2(target_zoom, target_zoom)

func _unhandled_input(event: InputEvent) -> void:
	# Handle zoom
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom += zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom -= zoom_speed

		target_zoom = clamp(target_zoom, min_zoom, max_zoom)
		_zoom_to(target_zoom)

	# Start dragging with right mouse button
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			dragging = event.pressed
			if dragging:
				last_mouse_pos = event.position

	# Handle mouse drag motion
	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position -= delta * drag_speed
		last_mouse_pos = event.position

func _zoom_to(value: float) -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(value, value), 0.15)
