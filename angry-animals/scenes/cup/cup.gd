extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

func die() -> void:
	animation_player.play("vanish")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SignalManager.on_cup_died.emit()
	queue_free()
