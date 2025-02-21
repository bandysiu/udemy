extends CanvasLayer


@onready var main: Control = $Main
@onready var game: Control = $Game


func _ready() -> void:
	show_game(false)
	SignalManager.on_game_exit_presssed.connect(on_game_exit_pressed)
	SignalManager.on_level_selected.connect(on_level_selected)


func on_game_exit_pressed() -> void:
	show_game(false)


func on_level_selected(level_num: int) -> void:
	show_game(true)


func show_game(s: bool) -> void:
	game.visible = s
	main.visible = !s
