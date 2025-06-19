extends Node

const SCORE_FILE: String = "user://duskfall.json"
const MAX_SCORES: int = 10

var _score: int = 0
var _coins: int = 0
var _fruits: int = 0
var _enemies: int = 0
var _hits: int = 0
var _scores_history: Array = []

func _ready() -> void:
	SignalManager.on_enemy_hit.connect(on_enemy_hit)
	SignalManager.on_pickup_hit.connect(on_pickup_hit)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_boss_killed.connect(on_boss_killed)
	load_scores_history()

func update_score(point: int) -> void:
	_score += point
	SignalManager.on_score_updated.emit(_score)

func on_enemy_hit(points: int) -> void:
	update_score(points)

func on_pickup_hit(points: int) -> void:
	update_score(points)

func on_game_over() -> void:
	_scores_history.append({
		"score": _score,
		"coins": _coins,
		"fruits": _fruits,
		"enemies": _enemies,
		"hits": _hits
	})
	save_scores()

func on_boss_killed(points: int) -> void:
	update_score(points)

func reset_score() -> void:
	_score = 0

func get_score() -> int:
	return _score

func save_scores() -> void:
	_scores_history.sort_custom(compare_scores)
	var file = FileAccess.open(SCORE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_scores_history.slice(0, MAX_SCORES)))
		file.close()

func load_scores_history() -> void:
	_scores_history.clear()
	var file = FileAccess.open(SCORE_FILE, FileAccess.READ)
	if file:
		var text: String = file.get_as_text()
		if text and text.length() > 0:
			_scores_history = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		save_scores()
	_scores_history.sort_custom(compare_scores)
	print(_scores_history)

func compare_scores(a, b):
	return b.score < a.score

func get_score_history() -> Array[int]:
	var highscores: Array[int] = []
	for score in _scores_history:
		if score.score != 0:
			highscores.push_back(int(score.score))
	return highscores
