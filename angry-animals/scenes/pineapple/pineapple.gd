extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("bird"):
		SignalManager.pineapple_pickup.emit()
		animation_player.play("pickup")
