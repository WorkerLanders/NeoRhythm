extends Node2D

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.02, 0.08)
	bg.size  = Vector2(1280.0, 720.0)
	add_child(bg)

	# Logo
	var logo := Label.new()
	logo.text     = "NeoRhythm"
	logo.position = Vector2(40.0, 30.0)
	logo.add_theme_font_size_override("font_size", 40)
	logo.add_theme_color_override("font_color", Color(0.95, 0.85, 1.0))
	add_child(logo)

	# Menu buttons
	var items := [
		["스토리 모드", "res://scenes/StoryEpisodeSelect.tscn"],
		["프리 플레이", "res://scenes/FreePlaySelect.tscn"],
		["기록",       ""],
		["설정",       "res://scenes/SettingsScreen.tscn"],
	]
	for i in range(items.size()):
		var btn := _make_btn(items[i][0], items[i][1])
		btn.position = Vector2(440.0, 190.0 + i * 95.0)
		add_child(btn)

	# User level bar at the bottom
	_build_level_bar()

func _make_btn(label_text: String, scene_path: String) -> Button:
	var btn := Button.new()
	btn.text = label_text
	btn.size = Vector2(400.0, 72.0)
	btn.add_theme_font_size_override("font_size", 24)
	if scene_path != "":
		btn.pressed.connect(func() -> void:
			get_tree().change_scene_to_file(scene_path))
	else:
		btn.disabled = true
	return btn

func _build_level_bar() -> void:
	var lv  := SaveManager.user_level
	var exp := SaveManager.user_exp
	var need := SaveManager.exp_for_next_level()

	var lbl_lv := Label.new()
	lbl_lv.text     = "Lv.%d" % lv
	lbl_lv.position = Vector2(40.0, 672.0)
	lbl_lv.add_theme_font_size_override("font_size", 20)
	lbl_lv.add_theme_color_override("font_color", Color(0.9, 0.8, 1.0))
	add_child(lbl_lv)

	var bar_bg := ColorRect.new()
	bar_bg.color    = Color(0.18, 0.12, 0.28)
	bar_bg.size     = Vector2(280.0, 18.0)
	bar_bg.position = Vector2(120.0, 677.0)
	add_child(bar_bg)

	var ratio := float(exp) / float(max(need, 1))
	var bar_fill := ColorRect.new()
	bar_fill.color    = Color(0.55, 0.30, 0.85)
	bar_fill.size     = Vector2(280.0 * ratio, 18.0)
	bar_fill.position = Vector2(120.0, 677.0)
	add_child(bar_fill)

	var lbl_exp := Label.new()
	lbl_exp.text     = "%d / %d EXP" % [exp, need]
	lbl_exp.position = Vector2(414.0, 672.0)
	lbl_exp.add_theme_font_size_override("font_size", 16)
	lbl_exp.add_theme_color_override("font_color", Color(0.7, 0.6, 0.85))
	add_child(lbl_exp)
