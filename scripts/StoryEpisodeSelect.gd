extends Node2D

# Episode definitions — expand as story content is added.
const EPISODES := [
	{"id": 1, "title": "그의 이야기",     "unlocked": true},
	{"id": 2, "title": "그녀의 이야기",   "unlocked": false},
	{"id": 3, "title": "고양이의 이야기", "unlocked": false},
	{"id": 4, "title": "가족의 이야기",   "unlocked": false},
]

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.02, 0.08)
	bg.size  = Vector2(1280.0, 720.0)
	add_child(bg)

	var title := Label.new()
	title.text     = "스토리 모드"
	title.position = Vector2(40.0, 30.0)
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Color(0.95, 0.85, 1.0))
	add_child(title)

	for i in range(EPISODES.size()):
		var ep : Dictionary = EPISODES[i]
		var y := 160.0 + i * 100.0
		_make_episode_row(ep, y)

	var btn_back := Button.new()
	btn_back.text     = "◀ 뒤로"
	btn_back.size     = Vector2(160.0, 50.0)
	btn_back.position = Vector2(1080.0, 640.0)
	btn_back.add_theme_font_size_override("font_size", 20)
	btn_back.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	add_child(btn_back)

func _make_episode_row(ep: Dictionary, y: float) -> void:
	var unlocked : bool = ep["unlocked"]
	var ep_id    : int  = ep["id"]

	var btn := Button.new()
	btn.text     = "EP.%d  %s" % [ep_id, ep["title"]]
	btn.size     = Vector2(700.0, 70.0)
	btn.position = Vector2(290.0, y)
	btn.disabled = not unlocked
	btn.add_theme_font_size_override("font_size", 24)
	if unlocked:
		btn.pressed.connect(func() -> void: _on_episode_selected(ep_id))
	add_child(btn)

	if not unlocked:
		var lbl_lock := Label.new()
		lbl_lock.text     = "잠금"
		lbl_lock.position = Vector2(1010.0, y + 20.0)
		lbl_lock.add_theme_font_size_override("font_size", 18)
		lbl_lock.add_theme_color_override("font_color", Color(0.5, 0.45, 0.55))
		add_child(lbl_lock)

func _on_episode_selected(ep_id: int) -> void:
	GameContext.episode_id = ep_id
	get_tree().change_scene_to_file("res://scenes/StoryStageSelect.tscn")
