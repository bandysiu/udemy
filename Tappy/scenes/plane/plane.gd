extends CharacterBody2D


class_name Tappy


const GRAVITY: float = 1500
const JUMP_VELOCITY: float = -500.0


@onready var SPRITE: AnimatedSprite2D = $AnimatedSprite2D
@onready var ANIMATION: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var is_dead: bool = false


func _physics_process(delta) -> void:
	if !is_dead:
		fly()
	if is_on_floor():
		die()
	velocity.y += GRAVITY * delta
	move_and_slide()

 
func die() -> void:
	SPRITE.stop()
	audio_stream_player_2d.stop()
	if !is_dead:
		ANIMATION.play("fall")
		SignalHub.on_plane_died.emit()
	is_dead = true
	if !is_on_floor():
		velocity.y = 500
	else:
		set_physics_process(false)


func fly() -> void:
	if Input.is_action_just_pressed("fly"):
		ANIMATION.play("jump")
		velocity.y = JUMP_VELOCITY
