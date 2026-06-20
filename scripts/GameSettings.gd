extends Node

const SETTINGS_PATH := "user://settings.json"

var action_key_code : int   = MOUSE_BUTTON_LEFT
var action_is_mouse : bool  = true
var scroll_speed    : float = 1.0
var bg_brightness   : float = 0.7

func _ready() -> void:
	load_settings()

func get_note_travel_time() -> float:
	return 2.0 / scroll_speed

func is_action_pressed(event: InputEvent) -> bool:
	if action_is_mouse and event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		return mb.button_index == action_key_code and mb.pressed
	elif not action_is_mouse and event is InputEventKey:
		var kb := event as InputEventKey
		return kb.keycode == action_key_code and kb.pressed and not kb.echo
	return false

func is_action_released(event: InputEvent) -> bool:
	if action_is_mouse and event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		return mb.button_index == action_key_code and not mb.pressed
	elif not action_is_mouse and event is InputEventKey:
		var kb := event as InputEventKey
		return kb.keycode == action_key_code and not kb.pressed
	return false

func get_key_display_name() -> String:
	if action_is_mouse:
		match action_key_code:
			MOUSE_BUTTON_LEFT:   return "마우스 좌클릭"
			MOUSE_BUTTON_RIGHT:  return "마우스 우클릭"
			MOUSE_BUTTON_MIDDLE: return "마우스 가운데"
			_: return "마우스 버튼 " + str(action_key_code)
	else:
		return OS.get_keycode_string(action_key_code)

func save_settings() -> void:
	var data := {
		"action_key_code": action_key_code,
		"action_is_mouse": action_is_mouse,
		"scroll_speed":    scroll_speed,
		"bg_brightness":   bg_brightness,
	}
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	file.close()
	var data: Dictionary = json.get_data()
	action_key_code = int(data.get("action_key_code", MOUSE_BUTTON_LEFT))
	action_is_mouse = bool(data.get("action_is_mouse", true))
	scroll_speed    = clampf(float(data.get("scroll_speed",  1.0)), 1.0, 5.0)
	bg_brightness   = clampf(float(data.get("bg_brightness", 0.7)), 0.0, 1.0)
