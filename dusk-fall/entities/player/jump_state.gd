#JumpingState
extends PlayerStateMachine

func enter_state(player_node: CharacterBody2D) -> void:
	super(player_node)
	player.velocity.y = player.JUMP_VELOCITY

func handle_input(delta: float) -> void:
	if player.is_on_floor():
		player.change_state("IdleState")
	elif Input.get_axis("left", "right") != 0:
		player.change_state("MovingState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
