#IdleState
extends PlayerStateMachine

func enter_state(player_node: CharacterBody2D, area = null) -> void:
	super(player_node)
	player.velocity.x = 0

func handle_input(delta: float) -> void:
	player.animation_player.play("idle")
	handle_jump_buffer()
	handle_state_change()

func handle_jump_buffer() -> void:
	if player._jump_buffer_timer > 0.0:
		player.change_state("JumpState")
		player._jump_buffer_timer = 0.0
		return

func handle_state_change() -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpState")
	elif Input.get_axis("left", "right") != 0:
		player.change_state("MovingState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
