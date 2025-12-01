class_name Item extends Node2D

signal picked_up

@export var item_resource: ItemResource


func pick_up() -> ItemResource:
	print("Picked up")
	picked_up.emit()
	queue_free() # free happens after the function finishes
	return item_resource
