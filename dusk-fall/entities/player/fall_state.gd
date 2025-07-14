#FallState
extends PlayerStateMachine

func enter_state(player_node: CharacterBody2D, area: Area2D = null) -> void:
	super(player_node)

func handle_input(delta: float) -> void:
	player.animation_player.play("fall")
