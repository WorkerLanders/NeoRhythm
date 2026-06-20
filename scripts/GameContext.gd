extends Node

# ─── Game Setup ───────────────────────────────────────────────────────────────
# Set these before transitioning to GameScene.
var chart_path   : String = "res://Resources/beatmaps/ep1_ch1_stage1_easy.json"
var chart_id     : String = "ep1_ch1_stage1_easy"
var game_mode    : String = "story"   # "story" | "free"
var difficulty   : String = "easy"
var return_scene : String = "res://scenes/StoryStageSelect.tscn"
var episode_id   : int    = 1

# ─── Result Data ──────────────────────────────────────────────────────────────
# Populated by GameScene before transitioning to ResultScreen.
var result_perfect    : int    = 0
var result_great      : int    = 0
var result_good       : int    = 0
var result_miss       : int    = 0
var result_max_combo  : int    = 0
var result_score      : int    = 0
var result_accuracy   : float  = 0.0
var result_grade      : String = "D"
var result_exp_gained : int    = 0
var result_leveled_up : bool   = false
var result_failed     : bool   = false

func setup_game(
		p_chart_path   : String,
		p_chart_id     : String,
		p_mode         : String,
		p_difficulty   : String,
		p_return       : String,
		p_episode_id   : int = 1) -> void:
	chart_path   = p_chart_path
	chart_id     = p_chart_id
	game_mode    = p_mode
	difficulty   = p_difficulty
	return_scene = p_return
	episode_id   = p_episode_id
