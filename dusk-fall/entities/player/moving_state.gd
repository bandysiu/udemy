#MovingState
extends PlayerStateMachine

var moving_acceleration = 500
var moving_deceleration = 800

func handle_input(delta: float) -> void:
	handle_jump_buffer_and_coyote()
	
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		player.velocity.x = move_toward(player.velocity.x, direction * player.SPEED, moving_acceleration * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, moving_deceleration * delta)
		if abs(player.velocity.x) < 10:
			player.velocity.x = 0
			player.change_state("IdleState")
	
	if player.is_on_floor():
		player.animation_player.play("run")
	
	handle_change_state()

func handle_jump_buffer_and_coyote() -> void:
	if player._jump_buffer_timer > 0.0 and player._coyote_timer > 0.0:
		player.change_state("JumpState")
		player._jump_buffer_timer = 0.0
		player._coyote_timer = 0.0
		return

func handle_change_state() -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
