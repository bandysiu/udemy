extends Node

const MAIN = preload("res://ui/main/main.tscn")
const TOTAL_LEVELS: int = 7

var _level_scenes: Dictionary = {
	0 : preload("res://scenes/levels/spring.tscn"),
	1 : preload("res://scenes/levels/summer.tscn"),
	2 : preload("res://scenes/levels/autumn.tscn"),
	3 : preload("res://scenes/levels/winter.tscn"),
	4 : preload("res://scenes/levels/dungeon.tscn"),
	5 : preload("res://scenes/levels/desert_dungeon.tscn"),
	6 : preload("res://scenes/levels/mushroom_cave.tscn"),
}

var _current_level: int = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func load_main_scene() -> void:
	_current_level = 0
	ScoreManager.reset_score()
	get_tree().change_scene_to_packed(MAIN)

func load_level_scene(level_number: int) -> void:
	get_tree().change_scene_to_packed(_level_scenes[level_number])

func set_level() -> void:
	pass
