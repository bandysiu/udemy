extends Node
class_name PlayerStateMachine

var player: CharacterBody2D

func enter_state(player_node: CharacterBody2D, area: Area2D = null) -> void:
	player = player_node

func exit_state() -> void:
	pass

func handle_input(delta: float) -> void:
	pass
