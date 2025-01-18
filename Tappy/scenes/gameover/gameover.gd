extends Control


@onready var gameover: Label = $gameover
@onready var start: Label = $start
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	hide()
	SignalHub.on_plane_died.connect(on_plane_died)


func _process(delta: float) -> void:
	if start.visible and Input.is_action_just_pressed("fly"):
		GameManager.load_game_scene()


func _on_timer_timeout() -> void:
	gameover.hide()
	start.show()


func on_plane_died() -> void:
	show()
	timer.start()
	audio_stream_player.play()
	ScoreManager.save_hiscore()
