class_name Stats
extends Resource

@export var spd: int
@export var def: int
@export var atk: int
@export var intel: int
@export var will: int

enum STAT { SPD, DEF, ATK, INTEL, WILL }

const STAT_NAMES = {
	STAT.SPD: "Speed",
	STAT.DEF: "Defense",
	STAT.ATK: "Attack",
	STAT.INTEL: "Intelligence",
	STAT.WILL: "Willpower"
}

func get_stat_value(stat: STAT) -> int:
	match stat:
		STAT.SPD: return spd
		STAT.DEF: return def
		STAT.ATK: return atk
		STAT.INTEL: return intel
		STAT.WILL: return will
	return 0

func set_stat_value(stat: STAT, value: int) -> void:
	match stat:
		STAT.SPD: spd = value
		STAT.DEF: def = value
		STAT.ATK: atk = value
		STAT.INTEL: intel = value
		STAT.WILL: will = value

func get_stat_name(stat: STAT) -> String:
	return STAT_NAMES.get(stat, "Unknown")
