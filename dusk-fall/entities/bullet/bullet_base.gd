extends Area2D
class_name Bullet

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _direction: Vector2 = Vector2.RIGHT
var _life_span: float = 5.0
var _life_time: float = 0.0

func _ready() -> void:
	if _direction.x < 0:
		animated_sprite_2d.flip_h = true

func _process(delta: float) -> void:
	position += _direction * delta
	check_expired(delta)

func check_expired(delta: float) -> void:
	_life_time += delta
	if _life_time > _life_span:
		queue_free()

func setup(position: Vector2, direction: Vector2, speed: float, life_span: float) -> void:
	_direction = direction.normalized() * speed
	_life_span = life_span
	position.y -= 8
	global_position = position

func _on_area_entered(area: Area2D) -> void:
	queue_free()
