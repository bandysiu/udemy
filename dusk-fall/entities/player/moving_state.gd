#MovingState
extends PlayerStateMachine

func handle_input(_delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		player.velocity.x = direction * player.SPEED
	else:
		player.change_state("IdleState")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
