extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.2, 1.2)
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0)

@export var level_number: int = 1

@onready var level: Label = $MarginContainer/VBoxContainer/Level
@onready var score: Label = $MarginContainer/VBoxContainer/Attempts
@onready var pineapple: Label = $MarginContainer/VBoxContainer/Pineapple

var _level_scene: PackedScene

func _ready() -> void:
	level.text = "Lvl %s" % str(level_number)
	score.text = "Attempts %s" % str(ScoreManager.get_best_for_level(str(level_number)))
	pineapple.text = "Pineapples %s" % str(ScoreManager.get_best_for_pineapple(str(level_number)))
	_level_scene = load("res://scenes/levels/level%s.tscn" % level_number) 

func _on_pressed() -> void:
	ScoreManager.set_level_selected(level_number)
	get_tree().change_scene_to_packed(_level_scene)

func _on_mouse_entered() -> void:
	scale = HOVER_SCALE

func _on_mouse_exited() -> void:
	scale = DEFAULT_SCALE
