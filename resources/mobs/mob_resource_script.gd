class_name MobResource
extends Resource

@export var sprite_frames: SpriteFrames

@export var stats: Stats = Stats.new()

# Convenience function to get the icon
func get_icon() -> Texture2D:
	return sprite_frames.get_frame_texture("Idle", 0)

# Optional: helper to get a stat value
func get_stat_value(stat: Stats.STAT) -> int:
	return stats.get_stat(stat)

# Optional: helper to get stat display name
func get_stat_name(stat: Stats.STAT) -> String:
	return stats.get_stat_name(stat)
