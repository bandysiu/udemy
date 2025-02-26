extends CharacterBody2D
class_name EnemyBase

const OFF_SCREEN_KILL: float = 200.0

@export var points: int = 1
@export var _speed: float = 30.0

var _player_ref: Player
var _gravity: float = 800.0
var _dying: bool = false

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)

func _physics_process(delta: float) -> void:
	clear_off_screen()

func clear_off_screen() -> void:
	if global_position.y >= OFF_SCREEN_KILL:
		queue_free()

func die() -> void:
	if _dying:
		return
	_dying = true
	
	hide()
	set_physics_process(false)
	queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	die()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass
