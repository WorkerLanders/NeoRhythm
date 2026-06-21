extends Node2D

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color    = Color(0.04, 0.02, 0.08)
	bg.size     = Vector2(1280.0, 720.0)
	add_child(bg)

	# Decorative horizontal bars
	for i in range(4):
		var bar := ColorRect.new()
		bar.color    = Color(0.12, 0.06, 0.22, 0.4)
		bar.size     = Vector2(1280.0, 3.0)
		bar.position = Vector2(0.0, 160.0 + i * 120.0)
		add_child(bar)

	var title := Label.new()
	title.text      = "N E O R H Y T H M"
	title.position  = Vector2(0.0, 270.0)
	title.size      = Vector2(1280.0, 100.0)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 72)
	title.add_theme_color_override("font_color", Color(0.95, 0.85, 1.0))
	add_child(title)

	var sub := Label.new()
	sub.text      = "Click anywhere to start"
	sub.position  = Vector2(0.0, 530.0)
	sub.size      = Vector2(1280.0, 40.0)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 22)
	sub.add_theme_color_override("font_color", Color(0.65, 0.55, 0.80, 0.85))
	add_child(sub)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
