extends StaticBody2D

enum STATE {STATIC, FAST_SPIN, SLOW_SPIN}
@export var state: STATE
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	match state:
		STATE.STATIC:
			animation_player.play("static")
			sprite_2d.modulate = Color(1.0, 1.0, 1.0, 1.0)
		STATE.FAST_SPIN:
			animation_player.play("fast_spin")
			sprite_2d.modulate = Color(0, 1.0, 0, 1.0)
		STATE.SLOW_SPIN:
			animation_player.play("slow_spin")
			sprite_2d.modulate = Color(0, 1.0, 0, 1.0)
