extends Node2D

const GRADE_LINES := {
	"S+": "Marvelous!!",
	"S":  "Brilliant!",
	"A":  "Excellent!",
	"B":  "Good Job!",
	"C":  "Keep Going...",
	"D":  "Terrible...",
}

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.02, 0.08)
	bg.size  = Vector2(1280.0, 720.0)
	add_child(bg)

	var grade    := GameContext.result_grade
	var failed   := GameContext.result_failed

	# ── Left Panel: Rank ───────────────────────────────────────────────────────
	var lbl_line := Label.new()
	lbl_line.text     = GRADE_LINES.get(grade, "")
	lbl_line.position = Vector2(60.0, 120.0)
	lbl_line.add_theme_font_size_override("font_size", 28)
	lbl_line.add_theme_color_override("font_color", Color(0.85, 0.78, 1.0))
	add_child(lbl_line)

	var grade_color := _grade_color(grade)
	var lbl_grade := Label.new()
	lbl_grade.text     = grade
	lbl_grade.position = Vector2(60.0, 160.0)
	lbl_grade.add_theme_font_size_override("font_size", 120)
	lbl_grade.add_theme_color_override("font_color", grade_color)
	add_child(lbl_grade)

	if failed:
		var lbl_fail := Label.new()
		lbl_fail.text     = "FAILED"
		lbl_fail.position = Vector2(60.0, 310.0)
		lbl_fail.add_theme_font_size_override("font_size", 26)
		lbl_fail.add_theme_color_override("font_color", Color.RED)
		add_child(lbl_fail)

	# ── Right Panel: Stats ─────────────────────────────────────────────────────
	var stats_x := 560.0
	var stats : Array = [
		["PERFECT",  str(GameContext.result_perfect)],
		["GREAT",    str(GameContext.result_great)],
		["GOOD",     str(GameContext.result_good)],
		["MISS",     str(GameContext.result_miss)],
		["",         ""],
		["MAX COMBO", str(GameContext.result_max_combo)],
		["ACCURACY",  "%.1f%%" % (GameContext.result_accuracy * 100.0)],
		["",          ""],
		["SCORE",     "%d" % GameContext.result_score],
	]
	var row_colors : Array = [
		Color.YELLOW, Color.CYAN, Color.GREEN, Color.RED,
		Color.WHITE,
		Color(0.9, 0.9, 0.9), Color(0.9, 0.9, 0.9),
		Color.WHITE,
		Color(1.0, 0.9, 0.4),
	]

	for i in range(stats.size()):
		var row := stats[i] as Array
		if row[0] == "":
			continue
		var col : Color = row_colors[i] if i < row_colors.size() else Color.WHITE

		var lbl_k := Label.new()
		lbl_k.text     = row[0]
		lbl_k.position = Vector2(stats_x, 100.0 + i * 48.0)
		lbl_k.add_theme_font_size_override("font_size", 22)
		lbl_k.add_theme_color_override("font_color", col)
		add_child(lbl_k)

		var lbl_v := Label.new()
		lbl_v.text     = row[1]
		lbl_v.position = Vector2(stats_x + 280.0, 100.0 + i * 48.0)
		lbl_v.add_theme_font_size_override("font_size", 22)
		lbl_v.add_theme_color_override("font_color", col)
		add_child(lbl_v)

	# ── Bottom: EXP / Level Bar ────────────────────────────────────────────────
	var lv   := SaveManager.user_level
	var exp  := SaveManager.user_exp
	var need := SaveManager.exp_for_next_level()

	var lbl_exp := Label.new()
	lbl_exp.text     = "EXP  +%d" % GameContext.result_exp_gained
	lbl_exp.position = Vector2(60.0, 590.0)
	lbl_exp.add_theme_font_size_override("font_size", 22)
	lbl_exp.add_theme_color_override("font_color", Color(0.7, 1.0, 0.7))
	add_child(lbl_exp)

	if GameContext.result_leveled_up:
		var lbl_lv_up := Label.new()
		lbl_lv_up.text     = "LEVEL UP!"
		lbl_lv_up.position = Vector2(250.0, 590.0)
		lbl_lv_up.add_theme_font_size_override("font_size", 22)
		lbl_lv_up.add_theme_color_override("font_color", Color.YELLOW)
		add_child(lbl_lv_up)

	var lbl_lv := Label.new()
	lbl_lv.text     = "Lv.%d" % lv
	lbl_lv.position = Vector2(60.0, 628.0)
	lbl_lv.add_theme_font_size_override("font_size", 20)
	lbl_lv.add_theme_color_override("font_color", Color(0.9, 0.8, 1.0))
	add_child(lbl_lv)

	var bar_bg := ColorRect.new()
	bar_bg.color    = Color(0.18, 0.12, 0.28)
	bar_bg.size     = Vector2(400.0, 18.0)
	bar_bg.position = Vector2(140.0, 634.0)
	add_child(bar_bg)

	var ratio := float(exp) / float(max(need, 1))
	var bar_fill := ColorRect.new()
	bar_fill.color    = Color(0.55, 0.30, 0.85)
	bar_fill.size     = Vector2(400.0 * ratio, 18.0)
	bar_fill.position = Vector2(140.0, 634.0)
	add_child(bar_fill)

	var lbl_next := Label.new()
	lbl_next.text     = "Lv.%d" % (lv + 1)
	lbl_next.position = Vector2(556.0, 628.0)
	lbl_next.add_theme_font_size_override("font_size", 20)
	lbl_next.add_theme_color_override("font_color", Color(0.7, 0.6, 0.85))
	add_child(lbl_next)

	# Divider
	var div := ColorRect.new()
	div.color    = Color(0.3, 0.25, 0.45)
	div.size     = Vector2(1200.0, 2.0)
	div.position = Vector2(40.0, 670.0)
	add_child(div)

	# Continue hint
	var lbl_hint := Label.new()
	lbl_hint.text     = "Click anywhere to continue"
	lbl_hint.position = Vector2(0.0, 682.0)
	lbl_hint.size     = Vector2(1280.0, 30.0)
	lbl_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_hint.add_theme_font_size_override("font_size", 18)
	lbl_hint.add_theme_color_override("font_color", Color(0.65, 0.55, 0.80, 0.85))
	add_child(lbl_hint)

func _grade_color(grade: String) -> Color:
	match grade:
		"S+": return Color(1.0, 0.95, 0.3)
		"S":  return Color(0.9, 0.8,  1.0)
		"A":  return Color(0.4, 0.9,  1.0)
		"B":  return Color(0.4, 1.0,  0.5)
		"C":  return Color(1.0, 0.7,  0.2)
		_:    return Color(0.7, 0.4,  0.4)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			get_tree().change_scene_to_file(GameContext.return_scene)
