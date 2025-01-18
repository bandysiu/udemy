extends Node

const DEFAULT_SCORE: int = 100
const PINEAPPLES: int = 0
const SCORES_PATH = "user://animals.dat"

var _level_selected: int = 1
var _level_scores: Dictionary = {}

func _ready() -> void:
	load_from_disc() 

func set_level_selected(level: int) -> void:
	_level_selected = level
	
func get_level_selected() -> int:
	return _level_selected

func check_and_add(level: String) -> void:
	if _level_scores.has(level) == false:
		_level_scores[level] = [DEFAULT_SCORE, PINEAPPLES]

func set_score_for_level(score: int, level: String):
	check_and_add(level)
	if _level_scores[level][0] > score:
		_level_scores[level][0] = score
		save_to_disc()

func get_best_for_level(level: String) -> int:
	check_and_add(level)
	return _level_scores[level][0]

func get_best_for_pineapple(level: String) -> int:
	check_and_add(level)
	return _level_scores[level][1]

func set_pineapples_for_level(pineapple: int, level: String):
	check_and_add(level)
	if _level_scores[level][1] < pineapple:
		if _level_scores[level][1] == 3:
			pass
		_level_scores[level][1] = pineapple
		save_to_disc()

func save_to_disc() -> void:
	FileAccess.open(SCORES_PATH, FileAccess.WRITE).store_string(JSON.stringify(_level_scores))

func load_from_disc() -> void:
	if FileAccess.open(SCORES_PATH, FileAccess.READ) == null:
		save_to_disc()
	else:
		_level_scores = JSON.parse_string(FileAccess.open(SCORES_PATH, FileAccess.READ).get_as_text())
