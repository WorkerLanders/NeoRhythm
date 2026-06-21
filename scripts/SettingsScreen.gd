extends Node2D

var _binding_mode     : bool   = false
var _lbl_key          : Label
var _lbl_speed        : Label
var _lbl_brightness   : Label

const SPEED_VALUES    : PackedFloat32Array = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
const BRIGHTNESS_VALS : PackedFloat32Array = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]

var _speed_idx  : int = 0
var _bright_idx : int = 7  # default 0.7

# Keys that cannot be bound
const BLOCKED_KEYS : PackedInt32Array = [
	KEY_ESCAPE, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5,
	KEY_F6, KEY_F7, KEY_F8, KEY_F9, KEY_F10, KEY_F11, KEY_F12,
]

func _ready() -> void:
	# Sync indices from current settings
	_speed_idx  = _find_closest(SPEED_VALUES,    GameSettings.scroll_speed)
	_bright_idx = _find_closest(BRIGHTNESS_VALS, GameSettings.bg_brightness)
	_build_ui()

func _find_closest(arr: PackedFloat32Array, value: float) -> int:
	var best := 0
	var best_d : float = abs(arr[0] - value)
	for i in range(1, arr.size()):
		var d : float = abs(arr[i] - value)
		if d < best_d:
			best_d = d
			best   = i
	return best

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.02, 0.08)
	bg.size  = Vector2(1280.0, 720.0)
	add_child(bg)

	var title := Label.new()
	title.text     = "설정"
	title.position = Vector2(40.0, 30.0)
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Color(0.95, 0.85, 1.0))
	add_child(title)

	# ── Key Binding ────────────────────────────────────────────────────────────
	_make_row_label("키 바인딩", 180.0)

	_lbl_key = Label.new()
	_lbl_key.text     = GameSettings.get_key_display_name()
	_lbl_key.position = Vector2(360.0, 180.0)
	_lbl_key.size     = Vector2(260.0, 40.0)
	_lbl_key.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lbl_key.add_theme_font_size_override("font_size", 22)
	_lbl_key.add_theme_color_override("font_color", Color.WHITE)
	add_child(_lbl_key)

	var btn_bind := Button.new()
	btn_bind.text     = "변경"
	btn_bind.size     = Vector2(100.0, 40.0)
	btn_bind.position = Vector2(640.0, 180.0)
	btn_bind.add_theme_font_size_override("font_size", 18)
	btn_bind.pressed.connect(_on_bind_pressed)
	add_child(btn_bind)

	# ── Scroll Speed ───────────────────────────────────────────────────────────
	_make_row_label("스크롤 속도", 280.0)

	var btn_speed_l := _make_arrow_btn("◀", Vector2(350.0, 280.0))
	btn_speed_l.pressed.connect(func() -> void: _step_speed(-1))
	add_child(btn_speed_l)

	_lbl_speed = Label.new()
	_lbl_speed.text     = "%.1fx" % GameSettings.scroll_speed
	_lbl_speed.position = Vector2(420.0, 280.0)
	_lbl_speed.size     = Vector2(140.0, 40.0)
	_lbl_speed.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lbl_speed.add_theme_font_size_override("font_size", 22)
	_lbl_speed.add_theme_color_override("font_color", Color.WHITE)
	add_child(_lbl_speed)

	var btn_speed_r := _make_arrow_btn("▶", Vector2(580.0, 280.0))
	btn_speed_r.pressed.connect(func() -> void: _step_speed(1))
	add_child(btn_speed_r)

	# ── Background Brightness ──────────────────────────────────────────────────
	_make_row_label("배경 밝기", 380.0)

	var btn_b_l := _make_arrow_btn("◀", Vector2(350.0, 380.0))
	btn_b_l.pressed.connect(func() -> void: _step_brightness(-1))
	add_child(btn_b_l)

	_lbl_brightness = Label.new()
	_lbl_brightness.text     = "%d%%" % int(GameSettings.bg_brightness * 100.0)
	_lbl_brightness.position = Vector2(420.0, 380.0)
	_lbl_brightness.size     = Vector2(140.0, 40.0)
	_lbl_brightness.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lbl_brightness.add_theme_font_size_override("font_size", 22)
	_lbl_brightness.add_theme_color_override("font_color", Color.WHITE)
	add_child(_lbl_brightness)

	var btn_b_r := _make_arrow_btn("▶", Vector2(580.0, 380.0))
	btn_b_r.pressed.connect(func() -> void: _step_brightness(1))
	add_child(btn_b_r)

	# ── Save button ────────────────────────────────────────────────────────────
	var btn_save := Button.new()
	btn_save.text     = "저장 후 닫기"
	btn_save.size     = Vector2(260.0, 60.0)
	btn_save.position = Vector2(510.0, 520.0)
	btn_save.add_theme_font_size_override("font_size", 22)
	btn_save.pressed.connect(_on_save_pressed)
	add_child(btn_save)

func _make_row_label(text: String, y: float) -> void:
	var lbl := Label.new()
	lbl.text     = text
	lbl.position = Vector2(120.0, y)
	lbl.size     = Vector2(220.0, 40.0)
	lbl.add_theme_font_size_override("font_size", 22)
	lbl.add_theme_color_override("font_color", Color(0.85, 0.78, 0.95))
	add_child(lbl)

func _make_arrow_btn(arrow: String, pos: Vector2) -> Button:
	var btn := Button.new()
	btn.text     = arrow
	btn.size     = Vector2(50.0, 40.0)
	btn.position = pos
	btn.add_theme_font_size_override("font_size", 20)
	return btn

# ─── Interactions ─────────────────────────────────────────────────────────────

func _on_bind_pressed() -> void:
	_binding_mode  = true
	_lbl_key.text  = "[ 키를 입력하세요 ]"
	_lbl_key.add_theme_color_override("font_color", Color.YELLOW)

func _step_speed(dir: int) -> void:
	_speed_idx = clamp(_speed_idx + dir, 0, SPEED_VALUES.size() - 1)
	GameSettings.scroll_speed = SPEED_VALUES[_speed_idx]
	_lbl_speed.text = "%.1fx" % GameSettings.scroll_speed

func _step_brightness(dir: int) -> void:
	_bright_idx = clamp(_bright_idx + dir, 0, BRIGHTNESS_VALS.size() - 1)
	GameSettings.bg_brightness = BRIGHTNESS_VALS[_bright_idx]
	_lbl_brightness.text = "%d%%" % int(GameSettings.bg_brightness * 100.0)

func _on_save_pressed() -> void:
	GameSettings.save_settings()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _input(event: InputEvent) -> void:
	if not _binding_mode:
		return

	var captured := false

	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed:
			GameSettings.action_key_code = mb.button_index
			GameSettings.action_is_mouse = true
			captured = true
	elif event is InputEventKey:
		var kb := event as InputEventKey
		if kb.pressed and not kb.echo:
			if kb.keycode not in BLOCKED_KEYS:
				GameSettings.action_key_code = kb.keycode
				GameSettings.action_is_mouse = false
				captured = true

	if captured:
		_binding_mode = false
		_lbl_key.text = GameSettings.get_key_display_name()
		_lbl_key.add_theme_color_override("font_color", Color.WHITE)
		get_viewport().set_input_as_handled()
