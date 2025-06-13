extends Node2D
class_name Shooter

@onready var shoot_timer: Timer = $ShootTimer
@onready var sound: AudioStreamPlayer2D = $Sound

@export var speed: float = 80.0
@export var life_span: float = 10.0
@export var bullet_key: Constants.ObjectType
@export var shoot_delay: float = 1

var _can_shoot: bool = true

func _ready() -> void:
	shoot_timer.wait_time = shoot_delay

func _process(delta: float) -> void:
	pass

func shoot(direction: Vector2) -> void:
	if !_can_shoot:
		return
	
	_can_shoot = false
	SignalManager.on_create_bullet.emit(global_position, direction, speed, life_span, bullet_key)
	shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
