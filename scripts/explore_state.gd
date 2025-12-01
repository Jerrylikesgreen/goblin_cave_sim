class_name ExploreState extends IdleState

signal explore_state_start


func run_state()->void:
	explore_state_start.emit()
	pass
