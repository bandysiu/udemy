extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $LifeTimer
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const GRAVITY: float = 200.0
const JUMP: float = -100.0
const POINTS: int = 5

var _start_y: float
var _speed_y: float = JUMP

func _ready() -> void:
	_start_y = position.y
	var animation_names: Array[String] = []
	for animation in animated_sprite_2d.sprite_frames.get_animation_names():
		animation_names.push_back(animation)
	animated_sprite_2d.animation = animation_names.pick_random()

func _process(delta: float) -> void:
	position.y += _speed_y * delta
	_speed_y += GRAVITY * delta
	
	if position.y > _start_y:
		set_process(false)

func pick_up() -> void:
	animation_player.play("pickup")

func _on_life_timer_timeout() -> void:
	pick_up()

func _on_area_entered(area: Area2D) -> void:
		SignalManager.on_pickup_hit.emit(POINTS)
		SoundManager.play_clip(sound, SoundManager.SOUND_PICKUP)
		pick_up()
