extends Node2D

@onready var sound: AudioStreamPlayer2D = $Sound

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://entities/bullet/bullet_player.tscn"),
	Constants.ObjectType.BULLET_ENEMY: preload("res://entities/bullet/bullet_enemy.tscn"),
	Constants.ObjectType.EXPLOSION: preload("res://entities/enemy/misc/explosion.tscn"),
	Constants.ObjectType.PICKUP: preload("res://entities/enemy/misc/fruit_pickup.tscn"),
}

func _ready() -> void:
	SignalManager.on_create_bullet.connect(on_create_bullet) 
	SignalManager.on_create_object.connect(on_create_object) 

func on_create_bullet(position: Vector2, direction: Vector2, speed: float, life_span: float, object_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES.has(object_type):
		return
	if Constants.ObjectType.BULLET_PLAYER == object_type:
		SignalManager.on_player_bullet_created.emit()
		SoundManager.play_clip(sound, SoundManager.SOUND_FIREBALL)
	else:
		SoundManager.play_clip(sound, SoundManager.SOUND_STINGER)
	var new_bullet: Bullet = OBJECT_SCENES[object_type].instantiate()
	new_bullet.setup(position, direction, speed, life_span)
	call_deferred("add_child", new_bullet)

func on_create_object(position: Vector2, object_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES.has(object_type):
		return
	var new_object = OBJECT_SCENES[object_type].instantiate()
	new_object.position = position
	call_deferred("add_child", new_object)
