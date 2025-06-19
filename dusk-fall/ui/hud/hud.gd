extends Control

@onready var hb_hearts: HBoxContainer = $MarginContainer/HBoxContainer/HBoxContainer
@onready var color_rect: ColorRect = $ColorRect
@onready var vb_level_complete: VBoxContainer = $ColorRect/VBLevelComplete
@onready var vb_gameover: VBoxContainer = $ColorRect/VBGameover
@onready var score: Label = $MarginContainer/HBoxContainer/Score

const INITIAL_HEART = preload("res://ui/hud/heart.tscn")
const FULL_HEART = preload("res://assets/player/Hearts_Red_1.png")
const EMPTY_HEART = preload("res://assets/player/Hearts_Red_5.png")

var heart: TextureRect
var _hearts: Array

func _ready() -> void:
	on_score_updated(ScoreManager.get_score())
	SignalManager.on_level_start.connect(on_level_start)
	SignalManager.on_player_hit.connect(on_player_hit)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_respawn.connect(on_respawn)
	SignalManager.on_score_updated.connect(on_score_updated)

func on_level_start(lives: int) -> void:
	for live in lives:
		var new_heart = INITIAL_HEART.instantiate().duplicate()
		hb_hearts.add_child(new_heart)
	_hearts = hb_hearts.get_children()

func on_player_hit(lives: int) -> void:
	for life in range(_hearts.size()):
		if lives <= life:
			_hearts[life].texture = EMPTY_HEART

func show_hud() -> void:
	color_rect.show()

func on_game_over() -> void:
	vb_gameover.show()
	show_hud()

func on_respawn() -> void:
	vb_gameover.hide()
	color_rect.hide()

func on_score_updated(points: int) -> void:
	score.text = "%04d" % points
