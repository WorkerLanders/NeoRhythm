class_name Note
extends Area2D

signal missed(note: Note)

const JUDGMENT_LINE_X : float = 192.0
const MISS_PAST_PX    : float = 60.0
const NOTE_W          : float = 30.0
const NOTE_H          : float = 70.0

var time_ms     : int    = 0
var note_type   : String = "tap"
var duration_ms : int    = 0
var tail_ms     : int    = 0

var _speed : float = 0.0
var _done  : bool  = false
var _held  : bool  = false  # True while a hold note's head has been pressed

func setup(spawn_x: float, travel_time: float,
		p_time_ms: int, p_type: String, p_duration_ms: int = 0) -> void:
	time_ms     = p_time_ms
	note_type   = p_type
	duration_ms = p_duration_ms
	tail_ms     = p_time_ms + p_duration_ms
	_speed      = (spawn_x - JUDGMENT_LINE_X) / travel_time
	position.x  = spawn_x
	_build_visual()

func _build_visual() -> void:
	var existing := get_node_or_null("Visual")
	if existing:
		existing.queue_free()

	if note_type == "hold" and duration_ms > 0:
		var body_width := duration_ms / 1000.0 * _speed
		# Body extends to the right (tail hasn't reached judgment line yet)
		var body := ColorRect.new()
		body.name     = "Body"
		body.color    = Color(1.0, 0.55, 0.1, 0.75)
		body.size     = Vector2(body_width, NOTE_H - 20.0)
		body.position = Vector2(0.0, -(NOTE_H - 20.0) * 0.5)
		add_child(body)
		# Head cap rendered on top of body
		var head := ColorRect.new()
		head.name     = "Visual"
		head.color    = Color(1.0, 0.85, 0.1, 1.0)
		head.size     = Vector2(NOTE_W, NOTE_H)
		head.position = Vector2(-NOTE_W * 0.5, -NOTE_H * 0.5)
		add_child(head)
	else:
		var vis := ColorRect.new()
		vis.name     = "Visual"
		vis.color    = Color(1.0, 0.85, 0.1, 1.0)
		vis.size     = Vector2(NOTE_W, NOTE_H)
		vis.position = Vector2(-NOTE_W * 0.5, -NOTE_H * 0.5)
		add_child(vis)

func _process(delta: float) -> void:
	if _done:
		return
	position.x -= _speed * delta
	# Only emit miss when NOT in held state (held note moves past freely)
	if not _held and position.x < JUDGMENT_LINE_X - MISS_PAST_PX:
		_done = true
		missed.emit(self)
		queue_free()

# Called when a tap note is judged (hit or auto-missed via judgment).
func judge() -> void:
	_done = true
	queue_free()

# Called when a hold note head is successfully pressed.
func start_hold() -> void:
	_held = true
	var body := get_node_or_null("Body")
	if body:
		(body as ColorRect).color = Color(1.0, 0.78, 0.2, 1.0)
	var head := get_node_or_null("Visual")
	if head:
		(head as ColorRect).color = Color(1.0, 1.0, 0.4, 1.0)

# Called when the tail time is reached while the key is held (success).
func end_hold() -> void:
	_done = true
	queue_free()

# Called when the key is released before the tail time (early release = MISS).
func release_early() -> void:
	_done = true
	queue_free()
