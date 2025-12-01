class_name MobOptionsButton
extends MenuButton

# I Defined the enum BEFORE the signal so the type name exists
enum OPTION { MOVE, ACTION }

signal option_pressed(option: OPTION)
var option: OPTION = OPTION.MOVE

# ID mapping: map OPTION -> id 
const OPTION_ID = {
	OPTION.MOVE: 1,
	OPTION.ACTION: 2
}

# Reverse map: map popup id -> OPTION 
const OPTION_FROM_ID = {
	1: OPTION.MOVE,
	2: OPTION.ACTION
}

func _ready() -> void:
	var popup = get_popup()
	popup.clear()
	popup.add_item("Move", OPTION_ID[OPTION.MOVE])
	popup.add_item("Action", OPTION_ID[OPTION.ACTION])
	
	popup.id_pressed.connect(_on_option_selected)

func _on_option_selected(option_id: int) -> void:
	var selected: OPTION = OPTION_FROM_ID.get(option_id)
	option = selected
	emit_signal("option_pressed", selected)
	set_visible(false)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
		if is_visible():
			set_visible(false)
