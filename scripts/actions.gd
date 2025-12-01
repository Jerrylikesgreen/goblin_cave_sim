class_name Actions extends MenuButton

signal action_cancled

signal action_option_pressed(option: ACTION_OPTION)

@onready var mob_options_button: MobOptionsButton = %MobOptionsButton



enum ACTION_OPTION { STORE_FOOD, RAID }


var action_option: ACTION_OPTION 

# ID mapping: map OPTION -> id 
const ACTION_OPTION_ID = {
	ACTION_OPTION.STORE_FOOD: 1,
	ACTION_OPTION.RAID: 2
}

# Reverse map: map popup id -> OPTION 
const OPTION_FROM_ID = {
	1: ACTION_OPTION.STORE_FOOD,
	2: ACTION_OPTION.RAID
}

func _ready() -> void:
	mob_options_button.option_pressed.connect(_on_action_selected)
	var popup = get_popup()
	popup.clear()
	popup.add_item("Store Food", ACTION_OPTION_ID[ACTION_OPTION.STORE_FOOD])
	popup.add_item("Raid", ACTION_OPTION_ID[ACTION_OPTION.RAID])
	
	popup.id_pressed.connect(_on_option_selected)

func _on_action_selected(option: MobOptionsButton.OPTION)->void:
		if option == MobOptionsButton.OPTION.ACTION:
			set_visible(true)

func _on_option_selected(option_id: int) -> void:
	print(option_id)
	var selected: ACTION_OPTION = OPTION_FROM_ID.get(option_id)
	action_option = selected
	emit_signal("action_option_pressed", selected)
	set_visible(false)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
		if is_visible():
			action_cancled.emit()
			set_visible(false)
