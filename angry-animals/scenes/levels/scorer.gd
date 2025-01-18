extends Node

var _attempts: int = 0
var _cups_hit: int = 0
var _total_cups: int = 0
var _level_number: int = 1
var _pineapple: int = 0
var _total_pineapple: int = 0

func _ready() -> void:
	_total_cups = get_tree().get_nodes_in_group("cup").size()
	_level_number = ScoreManager.get_level_selected()
	SignalManager.on_attempt_made.connect(on_attempt_made)
	SignalManager.on_cup_died.connect(on_cup_died)
	SignalManager.pineapple_pickup.connect(pineapple_pickup)

func on_attempt_made() -> void:
	_attempts += 1
	SignalManager.on_score_updated.emit(_attempts)

func on_cup_died() -> void:
	_cups_hit += 1
	if _cups_hit == _total_cups:
		SignalManager.on_level_complete.emit()
		ScoreManager.set_score_for_level(_attempts, str(_level_number))

func pineapple_pickup() -> void:
	_total_pineapple = get_tree().get_nodes_in_group("pineapple").size()
	_pineapple += 1
	ScoreManager.set_pineapples_for_level(_pineapple, str(_level_number))
	
