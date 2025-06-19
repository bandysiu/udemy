extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer

const HIGHSCORE_LABEL = preload("res://ui/main/highscore_label.tscn")

func _ready() -> void:
	load_highscores()

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		GameManager.load_level_scene(1)
	if event.is_action_released("ui_cancel"):
		GameManager.load_level_scene(0)

func _process(delta: float) -> void:
	pass

func load_highscores() -> void:
	for score in ScoreManager.get_score_history():
		var label = HIGHSCORE_LABEL.instantiate()
		label.text = "%04d" % score
		grid_container.add_child(label)
