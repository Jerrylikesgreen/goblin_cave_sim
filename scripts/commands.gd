class_name Commands extends MenuBar



@onready var build: BuildCommand = $Build
@onready var units: PopupMenu = $Units
@onready var storage: StorageCommand = $Storage
@onready var inventory_container: PanelContainer = %InventoryContainer


func _ready() -> void:
	storage.display_inventory.connect(_on_toogle_inventory)


func _on_toogle_inventory()->void:
	if inventory_container.is_visible():
		inventory_container.set_visible(false)
	else:
		inventory_container.set_visible(true)
