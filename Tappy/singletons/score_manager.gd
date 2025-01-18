extends Node


const SCORES_PATH = "user://tappy.dat"


var _score: int = 0
var _hiscore: int = 0


func _ready() -> void:
	load_hiscore()


func get_score() -> int:
	return _score


func get_hiscore() -> int:
	return _hiscore


func set_score(amount: int) -> void:
	_score = amount
	if _score > _hiscore:
		_hiscore = _score
		save_hiscore()
	SignalHub.on_score_updated.emit(_score)


func increment_score(amount: int) -> void:
	set_score(_score + amount)


func load_hiscore() -> void:
	var file: FileAccess = FileAccess.open(SCORES_PATH, FileAccess.READ)
	if file:
		if file.get_length() > 0:
			_hiscore = file.get_32()
		file.close()
	else:
		print("FAILED TO LOAD FILE")


func save_hiscore() -> void:
	var file: FileAccess = FileAccess.open(SCORES_PATH, FileAccess.WRITE)
	if file:
		file.store_32(get_hiscore())
		file.close()
