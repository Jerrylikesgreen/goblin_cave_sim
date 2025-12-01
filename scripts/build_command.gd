class_name BuildCommand
extends PopupMenu

@export var build_options: Array[PackedScene]


func _ready() -> void:
	id_pressed.connect(_on_building_selected)
	clear()
	var item_id := 0
	for scene in build_options:
		
		var inst := scene.instantiate()
		var display_name := inst.name

		var icon: Texture2D

		if inst.has_method("get_node"):
			# try common node names first
			if inst.has_node("location_sprite"):
				var node := inst.get_node("location_sprite")
				icon = _extract_texture_from_node(node)
			else:
				# try find any Sprite2D or TextureRect child (shallow search)
				for child in inst.get_children():
					icon = _extract_texture_from_node(child)
					if icon:
						break

		add_item(display_name, item_id)
		if icon:
			set_item_icon(item_id, icon)

		item_id += 1
		inst.queue_free()


# helper function to safely extract a Texture2D from common node types
func _extract_texture_from_node(node) -> Texture2D:
	if node == null:
		return null
	# Sprite2D has `.texture`
	if node is Sprite2D:
		return node.texture
	return null


func _on_building_selected(id:int)->void:
	var building_selected: Location = build_options[id].instantiate()
	building_selected.player_built()
	Events.building_selected(building_selected)
	print("selected bul")
