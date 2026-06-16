extends Node2D

const JUDGMENT_LINE_X  : float = 192.0
const SPAWN_X          : float = 1380.0
const NOTE_TRAVEL_TIME : float = 2.0
const LANE_Y           : PackedFloat32Array = [200.0, 280.0, 360.0, 440.0]
const LANE_H           : float = 80.0
const JUDGMENT_SHOW_SEC: float = 0.5

const CHART_PATH : String = "res://Resources/beatmaps/ep1_ch1_stage1.json"

var _chart         : Dictionary = {}
var _score         : ScoreManager
var _lanes         : LaneManager
var _notes_queue   : Array[Dictionary] = []
var _active_notes  : Array[Note] = []
var _spawn_index   : int   = 0
var _audio         : AudioStreamPlayer
var _playing       : bool  = false
var _current_ms    : float = 0.0
var _judgment_timer: float = 0.0

var _lbl_score    : Label
var _lbl_combo    : Label
var _lbl_judgment : Label

var _note_scene: PackedScene = preload("res://scenes/Note.tscn")

func _ready() -> void:
	_build_ui()
	_score = ScoreManager.new()
	_lanes = LaneManager.new()

	_chart = ChartLoader.load_chart(CHART_PATH)
	if _chart.is_empty():
		push_error("GameScene: failed to load chart")
		return

	for d: Dictionary in _chart.get("notes", []) as Array:
		_notes_queue.append(d)

	_score.setup(_notes_queue.size())

	var audio_path: String = "res://" + str(_chart.get("audio", ""))
	var stream: AudioStream = load(audio_path) as AudioStream
	_audio = AudioStreamPlayer.new()
	_audio.stream = stream
	add_child(_audio)

	await get_tree().create_timer(1.0).timeout
	_audio.play()
	_playing = true

func _build_ui() -> void:
	for i: int in range(4):
		var lane_bg: ColorRect = ColorRect.new()
		lane_bg.color    = Color(0.1 + i * 0.03, 0.1 + i * 0.03, 0.15)
		lane_bg.size     = Vector2(1280.0, LANE_H - 4.0)
		lane_bg.position = Vector2(0.0, LANE_Y[i] - LANE_H * 0.5 + 2.0)
		add_child(lane_bg)

	var jline: ColorRect = ColorRect.new()
	jline.color    = Color(1.0, 1.0, 0.0, 0.9)
	jline.size     = Vector2(4.0, LANE_Y[3] - LANE_Y[0] + LANE_H)
	jline.position = Vector2(JUDGMENT_LINE_X - 2.0, LANE_Y[0] - LANE_H * 0.5)
	add_child(jline)

	_lbl_score    = _make_label("0",  Vector2(20.0, 20.0),  28)
	_lbl_combo    = _make_label("",   Vector2(20.0, 60.0),  22)
	_lbl_judgment = _make_label("",   Vector2(JUDGMENT_LINE_X + 20.0, 120.0), 36)

func _make_label(p_text: String, pos: Vector2, font_size: int) -> Label:
	var lbl: Label = Label.new()
	lbl.text     = p_text
	lbl.position = pos
	lbl.add_theme_font_size_override("font_size", font_size)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	add_child(lbl)
	return lbl

func _process(delta: float) -> void:
	if not _playing:
		return

	_current_ms = _audio.get_playback_position() * 1000.0

	while _spawn_index < _notes_queue.size():
		var nd: Dictionary = _notes_queue[_spawn_index]
		var spawn_at: float = float(nd["time_ms"]) - NOTE_TRAVEL_TIME * 1000.0
		if _current_ms >= spawn_at:
			_spawn_note(nd)
			_spawn_index += 1
		else:
			break

	if _judgment_timer > 0.0:
		_judgment_timer -= delta
		if _judgment_timer <= 0.0:
			_lbl_judgment.text = ""

	_update_hud()

func _spawn_note(nd: Dictionary) -> void:
	var note: Note = _note_scene.instantiate() as Note
	add_child(note)
	var lane: int = _lanes.get_random_lane()
	note.position.y = LANE_Y[lane]
	note.setup(SPAWN_X, NOTE_TRAVEL_TIME,
		int(nd["time_ms"]), str(nd["type"]), nd.get("duration_ms", 0) as int)
	note.missed.connect(_on_note_missed)
	_active_notes.append(note)

func _input(event: InputEvent) -> void:
	if not _playing:
		return
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_handle_click()

func _handle_click() -> void:
	var best_note: Note = null
	var best_delta: int = 999999

	for note: Note in _active_notes:
		if not is_instance_valid(note):
			continue
		var delta: int = int(_current_ms) - note.time_ms
		if abs(delta) < abs(best_delta):
			best_delta = delta
			best_note  = note

	if best_note == null or abs(best_delta) > JudgmentSystem.GOOD_MS:
		return

	var judgment: String = JudgmentSystem.judge(best_delta)
	_apply_judgment(judgment, best_note)

func _on_note_missed(note: Note) -> void:
	_active_notes.erase(note)
	_score.add_judgment("MISS")
	_show_judgment("MISS")

func _apply_judgment(judgment: String, note: Note) -> void:
	_active_notes.erase(note)
	note.judge()
	_score.add_judgment(judgment)
	_show_judgment(judgment)

func _show_judgment(judgment: String) -> void:
	_lbl_judgment.text = judgment
	_judgment_timer    = JUDGMENT_SHOW_SEC
	match judgment:
		"PERFECT": _lbl_judgment.add_theme_color_override("font_color", Color.YELLOW)
		"GREAT":   _lbl_judgment.add_theme_color_override("font_color", Color.CYAN)
		"GOOD":    _lbl_judgment.add_theme_color_override("font_color", Color.GREEN)
		"MISS":    _lbl_judgment.add_theme_color_override("font_color", Color.RED)

func _update_hud() -> void:
	_lbl_score.text = "%d" % _score.get_final_score()
	_lbl_combo.text = "%d COMBO" % _score.combo if _score.combo > 1 else ""
