extends CharacterBody2D
class_name EnemyBase

const OFF_SCREEN_KILL: float = 820.0

@onready var sound: AudioStreamPlayer2D = $Sound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var points: int = 1
@export var _speed: float = 30.0

var _player_ref: Player
var _gravity: float = 800.0
var _dying: bool = false

func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)
	call_deferred("late_ready")

func late_ready() -> void:
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
	set_physics_process(false)
	SignalManager.on_enemy_hit.emit(points)
	SignalManager.on_create_object.emit(
		global_position,
		Constants.ObjectType.EXPLOSION
	)
	SignalManager.on_create_object.emit(
		global_position,
		Constants.ObjectType.PICKUP
	)
	SoundManager.play_clip(sound, SoundManager.SOUND_KILL)
	animation_player.play("death")

func on_game_over() -> void:
	set_process(false)
	set_physics_process(false)
	animated_sprite.stop()

func _on_hit_box_area_entered(area: Area2D) -> void:
	die()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass
