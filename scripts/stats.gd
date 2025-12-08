class_name Stats
extends Resource

@export var spd: int
@export var def: int
@export var atk: int
@export var intel: int
@export var will: int
@export var health: int
@export var max_health: int
enum STAT { SPD, DEF, ATK, INTEL, WILL, HEALTH }

const STAT_NAMES = {
	STAT.SPD: "Speed",
	STAT.DEF: "Defense",
	STAT.ATK: "Attack",
	STAT.INTEL: "Intelligence",
	STAT.WILL: "Willpower",
	STAT.HEALTH: "Health"
}

func get_stat_value(stat: STAT) -> int:
	match stat:
		STAT.SPD: return spd
		STAT.DEF: return def
		STAT.ATK: return atk
		STAT.INTEL: return intel
		STAT.WILL: return will
		STAT.HEALTH: return health
	return 0

func set_stat_value(stat: STAT, value: int) -> void:
	match stat:
		STAT.SPD: spd = value
		STAT.DEF: def = value
		STAT.ATK: atk = value
		STAT.INTEL: intel = value
		STAT.WILL: will = value
		STAT.HEALTH: health = value

func get_stat_name(stat: STAT) -> String:
	return STAT_NAMES.get(stat, "Unknown")
