class_name PlayerInventory
extends ItemList

func _ready() -> void:
	Events.player_inventory_updated.connect(_on_player_inventory_updated)

func _on_player_inventory_updated() -> void:
	clear()
	var current_inventory: Array = Globals.get_inventory()
	for item in current_inventory:
		var item_name := str(item.name) if item != null else "Unnamed"

		var icon: Texture2D = null
		if item != null and "item_sprite" in item:
			var s:Texture2D = item.item_sprite
			if s is Texture2D:
				icon = s

		var idx := add_item(item_name, icon)  # add text + icon in one step
		if item != null and "tool_tip" in item:
			set_item_tooltip(idx, str(item.tool_tip))

		# verify what was actually added
		print("ItemList index:", idx, " text:", get_item_text(idx), " icon:", get_item_icon(idx))




func _extract_icon_from_item(item) -> Texture2D:
	var sprite_candidate = item.item_sprite
	if sprite_candidate is Texture2D:
		return sprite_candidate

	# If it's a TextureRect node
	if sprite_candidate is TextureRect:
		return sprite_candidate.texture
	return null
