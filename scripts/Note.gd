extends Area2D

signal missed

const JUDGMENT_LINE_X := 192.0
const MISS_PAST_PX    := 60.0  # pixels past judgment line before auto-miss

var time_ms     : int    = 0
var note_type   : String = "tap"
var duration_ms : int    = 0

var _speed      : float  = 0.0
var _done       : bool   = false

func setup(spawn_x: float, travel_time: float, _time_ms: int, _type: String, _duration_ms: int = 0) -> void:
	time_ms     = _time_ms
	note_type   = _type
	duration_ms = _duration_ms
	_speed      = (spawn_x - JUDGMENT_LINE_X) / travel_time
	position.x  = spawn_x

func _process(delta: float) -> void:
	if _done:
		return
	position.x -= _speed * delta
	if position.x < JUDGMENT_LINE_X - MISS_PAST_PX:
		_done = true
		emit_signal("missed")
		queue_free()

func judge() -> void:
	_done = true
	queue_free()
