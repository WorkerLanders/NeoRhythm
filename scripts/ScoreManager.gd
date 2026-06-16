class_name ScoreManager
extends RefCounted

var total_notes  : int   = 0
var perfect_count: int   = 0
var great_count  : int   = 0
var good_count   : int   = 0
var miss_count   : int   = 0
var combo        : int   = 0
var max_combo    : int   = 0

var _base_per_note: float = 0.0

func setup(note_count: int) -> void:
	total_notes = note_count
	_base_per_note = 800000.0 / max(note_count, 1)

func add_judgment(judgment: String) -> void:
	match judgment:
		"PERFECT":
			perfect_count += 1
			combo += 1
		"GREAT":
			great_count += 1
			combo += 1
		"GOOD":
			good_count += 1
			combo += 1
		"MISS":
			miss_count += 1
			combo = 0
	max_combo = max(max_combo, combo)

func get_base_score() -> float:
	return (perfect_count * 1.0 + great_count * 0.8 + good_count * 0.5) * _base_per_note

func get_combo_bonus() -> float:
	if total_notes == 0:
		return 0.0
	return 200000.0 * pow(float(max_combo) / total_notes, 2.0)

func get_final_score() -> int:
	return int(get_base_score() + get_combo_bonus())

func get_accuracy() -> float:
	if total_notes == 0:
		return 0.0
	return (perfect_count * 1.0 + great_count * 0.8 + good_count * 0.5) / total_notes

func get_grade() -> String:
	var acc := get_accuracy()
	if acc >= 1.0 and miss_count == 0:
		return "S+"
	elif acc >= 0.95:
		return "S"
	elif acc >= 0.85:
		return "A"
	elif acc >= 0.70:
		return "B"
	elif acc >= 0.50:
		return "C"
	else:
		return "D"
