extends CanvasLayer


@onready var main: Control = $Main
@onready var game: Control = $Game
@onready var sound: AudioStreamPlayer = $Sound


func _ready() -> void:
	on_game_exit_pressed()
	SignalManager.on_game_exit_presssed.connect(on_game_exit_pressed)
	SignalManager.on_level_selected.connect(on_level_selected)


func on_game_exit_pressed() -> void:
	SoundManager.play_sound(sound, SoundManager.SOUND_MAIN_MENU)
	show_game(false)


func on_level_selected(level_num: int) -> void:
	SoundManager.play_sound(sound, SoundManager.SOUND_IN_GAME)
	show_game(true)


func show_game(s: bool) -> void:
	game.visible = s
	main.visible = !s
