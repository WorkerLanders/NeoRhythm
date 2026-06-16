class_name JudgmentSystem
extends RefCounted

const PERFECT_MS := 20
const GREAT_MS   := 50
const GOOD_MS    := 100

static func judge(delta_ms: int) -> String:
	var d := abs(delta_ms)
	if d <= PERFECT_MS:
		return "PERFECT"
	elif d <= GREAT_MS:
		return "GREAT"
	elif d <= GOOD_MS:
		return "GOOD"
	else:
		return "MISS"
