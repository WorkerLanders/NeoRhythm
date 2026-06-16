class_name Note
extends Area2D

signal missed(note: Note)

const JUDGMENT_LINE_X : float = 192.0
const MISS_PAST_PX    : float = 60.0

var time_ms     : int    = 0
var note_type   : String = "tap"
var duration_ms : int    = 0

var _speed : float = 0.0
var _done  : bool  = false

func setup(spawn_x: float, travel_time: float, p_time_ms: int, p_type: String, p_duration_ms: int = 0) -> void:
	time_ms     = p_time_ms
	note_type   = p_type
	duration_ms = p_duration_ms
	_speed      = (spawn_x - JUDGMENT_LINE_X) / travel_time
	position.x  = spawn_x

func _process(delta: float) -> void:
	if _done:
		return
	position.x -= _speed * delta
	if position.x < JUDGMENT_LINE_X - MISS_PAST_PX:
		_done = true
		missed.emit(self)
		queue_free()

func judge() -> void:
	_done = true
	queue_free()
