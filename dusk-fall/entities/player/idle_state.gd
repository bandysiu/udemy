#IdleState
extends PlayerStateMachine

func enter_state(player_node: CharacterBody2D) -> void:
	super(player_node)
	player.velocity.x = 0

func exit_state() -> void:
	pass

func handle_input(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpState")
	elif Input.get_axis("left", "right") != 0:
		player.change_state("MovingState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
