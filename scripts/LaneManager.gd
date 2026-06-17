class_name LaneManager
extends RefCounted

const LANE_COUNT := 4
var _last_lane := -1

# Returns a random lane index (0-3) that differs from the previous one.
func get_random_lane() -> int:
	var lane := randi() % LANE_COUNT
	while lane == _last_lane:
		lane = randi() % LANE_COUNT
	_last_lane = lane
	return lane
