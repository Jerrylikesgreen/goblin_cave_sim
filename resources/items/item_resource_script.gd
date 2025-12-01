class_name ItemResource extends Resource


@export var name:StringName

enum ItemType {FOOD, POTION, WEAPON, ARMOR, CURRENCY, SALVAGE}
@export  var item_type: ItemType = ItemType.FOOD


@export var uses:int = 1
@export var tool_tip: String = name + " Tooltip"
@export var item_sprite: Texture2D
