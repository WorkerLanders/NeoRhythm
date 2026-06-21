extends Node2D

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.02, 0.08)
	bg.size  = Vector2(1280.0, 720.0)
	add_child(bg)

	var title := Label.new()
	title.text     = "프리 플레이"
	title.position = Vector2(40.0, 30.0)
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Color(0.95, 0.85, 1.0))
	add_child(title)

	# List unlocked songs
	var unlocked_songs := _get_unlocked_songs()

	if unlocked_songs.is_empty():
		var lbl := Label.new()
		lbl.text     = "해금된 악곡이 없습니다.\n스토리 모드를 진행하여 악곡을 해금하세요."
		lbl.position = Vector2(0.0, 300.0)
		lbl.size     = Vector2(1280.0, 80.0)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 22)
		lbl.add_theme_color_override("font_color", Color(0.65, 0.6, 0.75))
		add_child(lbl)
	else:
		for i in range(unlocked_songs.size()):
			var sd : Dictionary = unlocked_songs[i]
			_make_song_row(sd, 140.0 + i * 90.0)

	var btn_back := Button.new()
	btn_back.text     = "◀ 뒤로"
	btn_back.size     = Vector2(160.0, 50.0)
	btn_back.position = Vector2(1080.0, 640.0)
	btn_back.add_theme_font_size_override("font_size", 20)
	btn_back.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	add_child(btn_back)

func _get_unlocked_songs() -> Array:
	var all_songs := [
		{
			"chart_id":   "ep1_ch1_stage1_easy",
			"chart_path": "res://Resources/beatmaps/ep1_ch1_stage1_easy.json",
			"title":      "First Dawn Lullaby",
			"difficulty": "easy",
		},
	]
	var result : Array = []
	for s in all_songs:
		if SaveManager.is_stage_unlocked(s["chart_id"]):
			result.append(s)
	return result

func _make_song_row(sd: Dictionary, y: float) -> void:
	var best       : Dictionary = SaveManager.get_best(sd["chart_id"])
	var best_grade : String     = best.get("grade", "-")
	var best_score : int        = int(best.get("score", 0))

	var btn := Button.new()
	btn.text     = "%s   %s" % [sd["title"], sd["difficulty"].to_upper()]
	btn.size     = Vector2(700.0, 65.0)
	btn.position = Vector2(200.0, y)
	btn.add_theme_font_size_override("font_size", 22)
	btn.pressed.connect(func() -> void: _on_song_selected(sd))
	add_child(btn)

	if best_grade != "-":
		var lbl_r := Label.new()
		lbl_r.text     = "%s  %d" % [best_grade, best_score]
		lbl_r.position = Vector2(920.0, y + 16.0)
		lbl_r.add_theme_font_size_override("font_size", 22)
		lbl_r.add_theme_color_override("font_color", Color(0.9, 0.85, 1.0))
		add_child(lbl_r)

func _on_song_selected(sd: Dictionary) -> void:
	GameContext.setup_game(
		sd["chart_path"],
		sd["chart_id"],
		"free",
		sd["difficulty"],
		"res://scenes/FreePlaySelect.tscn")
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")
