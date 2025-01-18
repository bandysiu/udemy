extends Control


@onready var score: Label = $MarginContainer/score


func _ready() -> void:
	on_score_udpated()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fly"):
		GameManager.load_game_scene()


func on_score_udpated() -> void:
	score.set_text(str(ScoreManager.get_hiscore()))
