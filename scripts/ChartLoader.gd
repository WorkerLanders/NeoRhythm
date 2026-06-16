class_name ChartLoader
extends RefCounted

# Loads chart JSON and normalizes to internal format:
# - time converted to ms (supports both seconds and ms source)
# - lane field ignored (assigned at runtime)
static func load_chart(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("ChartLoader: cannot open " + path)
		return {}

	var json = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		push_error("ChartLoader: JSON parse error: " + json.get_error_message())
		return {}
	file.close()

	var data: Dictionary = json.get_data()
	var normalized: Array = []

	for note in data.get("notes", []):
		var t = float(note.get("time", 0.0))
		# Heuristic: if time < 1000 it's in seconds, otherwise already ms
		var time_ms: int = int(t * 1000.0) if t < 1000.0 else int(t)

		var entry: Dictionary = {
			"id": normalized.size(),
			"type": note.get("type", "tap"),
			"time_ms": time_ms,
		}

		if note.has("duration"):
			var d = float(note["duration"])
			entry["duration_ms"] = int(d * 1000.0) if d < 1000.0 else int(d)

		normalized.append(entry)

	data["notes"] = normalized
	return data
