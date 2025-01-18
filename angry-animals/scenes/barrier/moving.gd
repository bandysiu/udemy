extends Path2D

enum STATE {VERTICAL, HORIZONTAL}
@export var state: STATE
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	match state:
		STATE.VERTICAL:
			animation_player.play("vertical")
		STATE.HORIZONTAL:
			animation_player.play("horizontal")
