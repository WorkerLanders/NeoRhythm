class_name ChartLoader
extends RefCounted

static func load_chart(path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("ChartLoader: cannot open " + path)
		return {}

	var json: JSON = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		push_error("ChartLoader: JSON parse error: " + json.get_error_message())
		return {}
	file.close()

	var data: Dictionary = json.get_data() as Dictionary
	var normalized: Array[Dictionary] = []

	for raw in data.get("notes", []) as Array:
		var note: Dictionary = raw as Dictionary
		var t: float = float(note.get("time", 0.0))
		var time_ms: int = int(t * 1000.0) if t < 1000.0 else int(t)

		var entry: Dictionary = {
			"id":      normalized.size(),
			"type":    str(note.get("type", "tap")),
			"time_ms": time_ms,
		}

		if note.has("duration"):
			var d: float = float(note["duration"])
			entry["duration_ms"] = int(d * 1000.0) if d < 1000.0 else int(d)

		normalized.append(entry)

	data["notes"] = normalized
	return data
