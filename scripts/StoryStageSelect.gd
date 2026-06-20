extends Node2D

# Stage data per episode.
# Each stage: {chart_id, title, difficulty, audio}
const STAGE_DATA := {
	1: [
		{
			"chart_id":   "ep1_ch1_stage1_easy",
			"chart_path": "res://Resources/beatmaps/ep1_ch1_stage1_easy.json",
			"title":      "First Dawn Lullaby",
			"difficulty": "easy",
			"chapter":    1,
			"stage":      1,
		},
	],
}

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var ep_id : int = GameContext.episode_id

	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.02, 0.08)
	bg.size  = Vector2(1280.0, 720.0)
	add_child(bg)

	var header := Label.new()
	header.text     = "EP.%d" % ep_id
	header.position = Vector2(40.0, 30.0)
	header.add_theme_font_size_override("font_size", 36)
	header.add_theme_color_override("font_color", Color(0.95, 0.85, 1.0))
	add_child(header)

	var stages : Array = STAGE_DATA.get(ep_id, [])
	for i in range(stages.size()):
		var sd  : Dictionary = stages[i]
		var y   := 140.0 + i * 100.0
		_make_stage_row(sd, y)

	# Back button
	var btn_back := Button.new()
	btn_back.text     = "◀ 뒤로"
	btn_back.size     = Vector2(160.0, 50.0)
	btn_back.position = Vector2(1080.0, 640.0)
	btn_back.add_theme_font_size_override("font_size", 20)
	btn_back.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/StoryEpisodeSelect.tscn"))
	add_child(btn_back)

func _make_stage_row(sd: Dictionary, y: float) -> void:
	var chart_id   : String = sd["chart_id"]
	var unlocked   : bool   = SaveManager.is_stage_unlocked(chart_id)
	var best       : Dictionary = SaveManager.get_best(chart_id)
	var best_grade : String = best.get("grade", "")
	var best_score : int    = int(best.get("score", 0))
	var diff       : String = sd["difficulty"].to_upper()

	var ch_idx := int(sd.get("chapter", 1))
	var st_idx := int(sd.get("stage",   1))

	var btn := Button.new()
	btn.text     = "Ch.%d  Stage %d   %s   %s" % [ch_idx, st_idx, sd["title"], diff]
	btn.size     = Vector2(840.0, 72.0)
	btn.position = Vector2(120.0, y)
	btn.disabled = not unlocked
	btn.add_theme_font_size_override("font_size", 22)
	if unlocked:
		btn.pressed.connect(func() -> void: _on_stage_selected(sd))
	add_child(btn)

	if best_grade != "":
		var lbl_rank := Label.new()
		lbl_rank.text     = best_grade
		lbl_rank.position = Vector2(980.0, y + 10.0)
		lbl_rank.add_theme_font_size_override("font_size", 28)
		lbl_rank.add_theme_color_override("font_color", _grade_color(best_grade))
		add_child(lbl_rank)

		var lbl_score := Label.new()
		lbl_score.text     = "%d" % best_score
		lbl_score.position = Vector2(1050.0, y + 14.0)
		lbl_score.add_theme_font_size_override("font_size", 20)
		lbl_score.add_theme_color_override("font_color", Color(0.85, 0.8, 0.95))
		add_child(lbl_score)

func _on_stage_selected(sd: Dictionary) -> void:
	GameContext.setup_game(
		sd["chart_path"],
		sd["chart_id"],
		"story",
		sd["difficulty"],
		"res://scenes/StoryStageSelect.tscn",
		GameContext.episode_id)
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")

func _grade_color(grade: String) -> Color:
	match grade:
		"S+": return Color(1.0, 0.95, 0.3)
		"S":  return Color(0.9, 0.8,  1.0)
		"A":  return Color(0.4, 0.9,  1.0)
		"B":  return Color(0.4, 1.0,  0.5)
		"C":  return Color(1.0, 0.7,  0.2)
		_:    return Color(0.7, 0.4,  0.4)
