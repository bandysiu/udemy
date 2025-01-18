extends Node2D

@onready var marker_2d: Marker2D = $Marker2D

const BIRD: PackedScene = preload("res://scenes/bird/bird.tscn")
const MAIN: PackedScene = preload("res://scenes/Main/main.tscn")

func _ready() -> void:
	instantiate_bird(marker_2d.position)
	SignalManager.on_bird_died.connect(instantiate_bird)

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene_to_packed(load("res://scenes/levels/level%s.tscn" % ScoreManager.get_level_selected()))

func instantiate_bird(last_pos: Vector2) -> void:
	var bird = BIRD.instantiate()
	bird.position = last_pos
	add_child(bird)
