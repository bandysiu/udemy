extends Control

const MAIN = preload("res://scenes/Main/main.tscn")
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var attempts_label: Label = $MarginContainer/VBoxContainer/AttemptsLabel
@onready var game_sound: AudioStreamPlayer2D = $GameSound
@onready var v_box_container_2: VBoxContainer = $MarginContainer/VBoxContainer2


func _ready() -> void:
	level_label.text = "LEVEL %s" % ScoreManager.get_level_selected()
	update_attempts(0)
	SignalManager.on_score_updated.connect(update_attempts)
	SignalManager.on_level_complete.connect(on_level_complete)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(MAIN)

func update_attempts(attempts: int) -> void:
	attempts_label.text = "Attempts %s" % attempts

func on_level_complete() -> void:
	v_box_container_2.show()
	game_sound.play()
