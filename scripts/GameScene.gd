extends Node2D

const JUDGMENT_LINE_X   : float = 192.0
const SPAWN_X           : float = 1380.0
const LANE_Y            : PackedFloat32Array = [200.0, 280.0, 360.0, 440.0]
const LANE_H            : float = 80.0
const JUDGMENT_SHOW_SEC : float = 0.5
const HP_REGEN_INTERVAL : float = 5.0   # seconds per +1 HP
const AUDIO_OFFSET_MS   : float = 0.0

var _chart         : Dictionary      = {}
var _score         : ScoreManager
var _lanes         : LaneManager
var _notes_queue   : Array[Dictionary] = []
var _active_notes  : Array[Note]     = []
var _held_note     : Note            = null
var _spawn_index   : int             = 0
var _audio         : AudioStreamPlayer
var _playing       : bool            = false
var _finished      : bool            = false
var _current_ms    : float           = 0.0
var _judgment_timer: float           = 0.0
var _hp            : int             = 100
var _max_hp        : int             = 100
var _hp_regen_acc  : float           = 0.0
var _all_done_acc  : float           = 0.0  # grace timer after all notes resolve

var _lbl_score    : Label
var _lbl_combo    : Label
var _lbl_judgment : Label
var _lbl_hp       : Label
var _bar_hp_bg    : ColorRect
var _bar_hp_fill  : ColorRect

var _note_scene : PackedScene = preload("res://scenes/Note.tscn")

func _ready() -> void:
	_max_hp = SaveManager.get_max_hp()
	_hp     = _max_hp
	_build_ui()

	_score = ScoreManager.new()
	_lanes = LaneManager.new()

	_chart = ChartLoader.load_chart(GameContext.chart_path)
	if _chart.is_empty():
		push_error("GameScene: failed to load chart at " + GameContext.chart_path)
		return

	for d : Dictionary in _chart.get("notes", []) as Array:
		_notes_queue.append(d)

	_score.setup(_notes_queue.size())

	var audio_path : String = "res://" + str(_chart.get("audio", ""))
	var stream : AudioStream = load(audio_path) as AudioStream
	_audio = AudioStreamPlayer.new()
	_audio.stream = stream
	add_child(_audio)

	await get_tree().create_timer(1.0).timeout
	_audio.play()
	_playing = true

# ─── UI Construction ──────────────────────────────────────────────────────────

func _build_ui() -> void:
	# Background
	var bg := ColorRect.new()
	bg.color    = Color(0.06, 0.04, 0.10)
	bg.size     = Vector2(1280.0, 720.0)
	bg.position = Vector2.ZERO
	add_child(bg)

	# Lane backgrounds
	for i : int in range(4):
		var lane_bg := ColorRect.new()
		lane_bg.color    = Color(0.10 + i * 0.02, 0.09 + i * 0.02, 0.14)
		lane_bg.size     = Vector2(1280.0, LANE_H - 4.0)
		lane_bg.position = Vector2(0.0, LANE_Y[i] - LANE_H * 0.5 + 2.0)
		add_child(lane_bg)

	# Judgment zone (width = note width)
	var zone_x := JUDGMENT_LINE_X - Note.NOTE_W * 0.5
	var zone_y := LANE_Y[0] - LANE_H * 0.5
	var zone_h := LANE_Y[3] - LANE_Y[0] + LANE_H
	var jzone := ColorRect.new()
	jzone.color    = Color(1.0, 1.0, 0.0, 0.12)
	jzone.size     = Vector2(Note.NOTE_W, zone_h)
	jzone.position = Vector2(zone_x, zone_y)
	add_child(jzone)
	var jline_l := ColorRect.new()
	jline_l.color    = Color(1.0, 1.0, 0.0, 0.9)
	jline_l.size     = Vector2(2.0, zone_h)
	jline_l.position = Vector2(zone_x, zone_y)
	add_child(jline_l)
	var jline_r := ColorRect.new()
	jline_r.color    = Color(1.0, 1.0, 0.0, 0.5)
	jline_r.size     = Vector2(2.0, zone_h)
	jline_r.position = Vector2(zone_x + Note.NOTE_W - 2.0, zone_y)
	add_child(jline_r)

	# Score & Combo
	_lbl_score    = _make_label("0",  Vector2(900.0, 20.0), 32)
	_lbl_combo    = _make_label("",   Vector2(20.0, 490.0), 26)
	_lbl_judgment = _make_label("",   Vector2(220.0, 300.0), 40)

	# HP bar background
	_bar_hp_bg           = ColorRect.new()
	_bar_hp_bg.color     = Color(0.15, 0.05, 0.05)
	_bar_hp_bg.size      = Vector2(360.0, 20.0)
	_bar_hp_bg.position  = Vector2(20.0, 680.0)
	add_child(_bar_hp_bg)

	# HP bar fill
	_bar_hp_fill          = ColorRect.new()
	_bar_hp_fill.color    = Color(0.7, 0.2, 0.2)
	_bar_hp_fill.size     = Vector2(360.0, 20.0)
	_bar_hp_fill.position = Vector2(20.0, 680.0)
	add_child(_bar_hp_fill)

	# HP text label
	_lbl_hp = _make_label("HP", Vector2(390.0, 677.0), 16)

func _make_label(p_text: String, pos: Vector2, font_size: int) -> Label:
	var lbl := Label.new()
	lbl.text     = p_text
	lbl.position = pos
	lbl.add_theme_font_size_override("font_size", font_size)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	add_child(lbl)
	return lbl

# ─── Main Loop ────────────────────────────────────────────────────────────────

func _process(delta: float) -> void:
	if not _playing or _finished:
		return

	# Sync clock with audio output latency
	var pos : float = _audio.get_playback_position()
	pos += AudioServer.get_time_since_last_mix()
	pos -= AudioServer.get_output_latency()
	_current_ms = pos * 1000.0 + AUDIO_OFFSET_MS

	# Spawn notes ahead of their hit time
	var travel_ms := GameSettings.get_note_travel_time() * 1000.0
	while _spawn_index < _notes_queue.size():
		var nd   : Dictionary = _notes_queue[_spawn_index]
		var spawn_at : float  = float(nd["time_ms"]) - travel_ms
		if _current_ms >= spawn_at:
			_spawn_note(nd)
			_spawn_index += 1
		else:
			break

	# Judgment display timer
	if _judgment_timer > 0.0:
		_judgment_timer -= delta
		if _judgment_timer <= 0.0:
			_lbl_judgment.text = ""

	# HP auto-recovery (+1 every HP_REGEN_INTERVAL seconds)
	_hp_regen_acc += delta
	if _hp_regen_acc >= HP_REGEN_INTERVAL:
		_hp_regen_acc -= HP_REGEN_INTERVAL
		_hp = mini(_hp + 1, _max_hp)

	# Hold note tail check
	if _held_note != null and is_instance_valid(_held_note):
		if _current_ms >= float(_held_note.tail_ms):
			_score.add_judgment("PERFECT")
			_show_judgment("PERFECT")
			_held_note.end_hold()
			_held_note = null

	# Song completion check (all notes spawned and resolved)
	if _spawn_index >= _notes_queue.size() and _active_notes.is_empty() and _held_note == null:
		_all_done_acc += delta
		if _all_done_acc >= 0.5:
			_finish_song()

	_update_hud()

# ─── Note Spawning ────────────────────────────────────────────────────────────

func _spawn_note(nd: Dictionary) -> void:
	var note : Note = _note_scene.instantiate() as Note
	add_child(note)
	var lane : int = _lanes.get_random_lane()
	note.position.y = LANE_Y[lane]
	var travel_time := GameSettings.get_note_travel_time()
	note.setup(
		SPAWN_X, travel_time,
		int(nd["time_ms"]),
		str(nd["type"]),
		int(nd.get("duration_ms", 0)))
	note.missed.connect(_on_note_missed)
	_active_notes.append(note)

# ─── Input Handling ───────────────────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	if not _playing or _finished:
		return
	if GameSettings.is_action_pressed(event):
		_handle_press()
	elif GameSettings.is_action_released(event):
		_handle_release()

func _handle_press() -> void:
	if _held_note != null:
		return  # Cannot start a new note while holding

	# Find the closest note to the judgment line within the GOOD window
	var best_note  : Note = null
	var best_delta : int  = 999999

	for note : Note in _active_notes:
		if not is_instance_valid(note):
			continue
		var delta : int = int(_current_ms) - note.time_ms
		if abs(delta) < abs(best_delta):
			best_delta = delta
			best_note  = note

	if best_note == null or abs(best_delta) > JudgmentSystem.GOOD_MS:
		return

	var judgment : String
	var spatial_dist := absf(best_note.position.x - JUDGMENT_LINE_X)
	if spatial_dist <= Note.NOTE_W * 0.5:
		judgment = "PERFECT"
	else:
		var d := absi(best_delta)
		if d <= JudgmentSystem.GREAT_MS:
			judgment = "GREAT"
		else:
			judgment = "GOOD"

	if best_note.note_type == "hold":
		_active_notes.erase(best_note)
		if judgment == "MISS":
			_score.add_judgment("MISS")
			_show_judgment("MISS")
			_apply_hp_miss()
			best_note.judge()
		else:
			_score.add_judgment(judgment)
			_show_judgment(judgment)
			_held_note = best_note
			best_note.start_hold()
	else:
		_apply_judgment(judgment, best_note)

func _handle_release() -> void:
	if _held_note == null:
		return
	# Releasing during hold = MISS (HP penalty)
	_held_note.release_early()
	_held_note = null
	_score.add_judgment("MISS")
	_show_judgment("MISS")
	_apply_hp_miss()

func _on_note_missed(note: Note) -> void:
	_active_notes.erase(note)
	_score.add_judgment("MISS")
	_show_judgment("MISS")
	_apply_hp_miss()

func _apply_judgment(judgment: String, note: Note) -> void:
	_active_notes.erase(note)
	note.judge()
	_score.add_judgment(judgment)
	_show_judgment(judgment)
	if judgment == "MISS":
		_apply_hp_miss()

# ─── HP ───────────────────────────────────────────────────────────────────────

func _apply_hp_miss() -> void:
	if _finished:
		return
	_hp -= 10
	if _hp <= 0:
		_hp = 0
		_update_hud()
		_fail_song()

# ─── Scene Transitions ────────────────────────────────────────────────────────

func _fail_song() -> void:
	_finished = true
	_playing  = false
	_audio.stop()
	GameContext.result_failed = true
	_push_results()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://scenes/ResultScreen.tscn")

func _finish_song() -> void:
	_finished = true
	_playing  = false
	GameContext.result_failed = false
	_push_results()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/ResultScreen.tscn")

func _push_results() -> void:
	var grade  := _score.get_grade()
	var score  := _score.get_final_score()
	var exp    := SaveManager.calc_exp_gain(grade, GameContext.difficulty)
	var leveled := SaveManager.add_exp(exp)
	SaveManager.update_best_score(GameContext.chart_id, grade, score)
	if not GameContext.result_failed:
		SaveManager.unlock_stage(GameContext.chart_id)

	GameContext.result_perfect    = _score.perfect_count
	GameContext.result_great      = _score.great_count
	GameContext.result_good       = _score.good_count
	GameContext.result_miss       = _score.miss_count
	GameContext.result_max_combo  = _score.max_combo
	GameContext.result_score      = score
	GameContext.result_accuracy   = _score.get_accuracy()
	GameContext.result_grade      = grade
	GameContext.result_exp_gained = exp
	GameContext.result_leveled_up = leveled

# ─── HUD Update ───────────────────────────────────────────────────────────────

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
	_lbl_hp.text    = "%d / %d" % [_hp, _max_hp]
	var ratio       := float(_hp) / float(_max_hp)
	_bar_hp_fill.size.x = 360.0 * ratio
	_bar_hp_fill.color  = Color(
		lerpf(0.85, 0.15, ratio),
		lerpf(0.10, 0.75, ratio),
		0.10)
