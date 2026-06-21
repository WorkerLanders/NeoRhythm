extends Node

const SAVE_PATH : String = "user://save.json"
const MAX_LEVEL : int    = 50

var user_level      : int        = 1
var user_exp        : int        = 0
var best_scores     : Dictionary = {}
var unlocked_stages : Array      = []

func _ready() -> void:
	load_data()

func get_max_hp() -> int:
	return 100 + (user_level - 1) * 10

func exp_for_next_level() -> int:
	return 100 * user_level

func calc_exp_gain(grade: String, difficulty: String) -> int:
	var base       := 100
	var grade_bonus := 0
	match grade:
		"S+": grade_bonus = 100
		"S":  grade_bonus = 80
		"A":  grade_bonus = 50
		"B":  grade_bonus = 20
	var diff_mult := 1.0
	match difficulty.to_lower():
		"easy":   diff_mult = 1.0
		"normal": diff_mult = 1.2
		"hard":   diff_mult = 1.5
		"expert": diff_mult = 2.0
	return int((base + grade_bonus) * diff_mult)

# Returns true if the player leveled up.
func add_exp(amount: int) -> bool:
	if user_level >= MAX_LEVEL:
		return false
	user_exp += amount
	var leveled_up := false
	while user_exp >= exp_for_next_level() and user_level < MAX_LEVEL:
		user_exp -= exp_for_next_level()
		user_level += 1
		leveled_up = true
	save_data()
	return leveled_up

func update_best_score(chart_id: String, grade: String, score: int) -> void:
	var existing : Dictionary = best_scores.get(chart_id, {})
	var changed  := false
	var grade_order := ["D", "C", "B", "A", "S", "S+"]
	var new_idx  := grade_order.find(grade)
	var old_idx  := grade_order.find(str(existing.get("grade", "D")))
	if new_idx > old_idx:
		existing["grade"] = grade
		changed = true
	if score > int(existing.get("score", 0)):
		existing["score"] = score
		changed = true
	if changed:
		best_scores[chart_id] = existing
		save_data()

func unlock_stage(chart_id: String) -> void:
	if chart_id not in unlocked_stages:
		unlocked_stages.append(chart_id)
		save_data()

func is_stage_unlocked(chart_id: String) -> bool:
	if chart_id == "ep1_ch1_stage1_easy":
		return true
	return chart_id in unlocked_stages

func get_best(chart_id: String) -> Dictionary:
	return best_scores.get(chart_id, {"grade": "", "score": 0})

func save_data() -> void:
	var data := {
		"user_level":      user_level,
		"user_exp":        user_exp,
		"best_scores":     best_scores,
		"unlocked_stages": unlocked_stages,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	file.close()
	var data : Dictionary = json.get_data()
	user_level      = int(data.get("user_level",      1))
	user_exp        = int(data.get("user_exp",         0))
	best_scores     = data.get("best_scores",     {})
	unlocked_stages = data.get("unlocked_stages", [])
