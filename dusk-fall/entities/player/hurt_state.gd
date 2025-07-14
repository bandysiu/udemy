#HurtState
extends PlayerStateMachine

var _knockback: Vector2 = Vector2.ZERO

func enter_state(player_node: CharacterBody2D, area: Area2D = null) -> void:
	super(player_node)
	player.KNOCKBACK_TIMER = 0.2
	_knockback = (player.global_position - area.global_position).normalized() * player.KNOCKBACK_FORCE

func handle_input(delta: float) -> void:
	if player.KNOCKBACK_TIMER > 0.0:
		_knockback.y += player.GRAVITY / 1.5 * delta
		player.velocity = _knockback
		player.KNOCKBACK_TIMER -= delta
		return
	else:
		_knockback.y += player.GRAVITY * delta
		_knockback.x = lerp(_knockback.x, 0.0, player.KNOCKBACK_DECELARATION * delta)
		player.velocity = _knockback
	
		handle_state_chande()

func exit_state() -> void:
	player.KNOCKBACK_TIMER = 0.2
	_knockback = Vector2.ZERO

func handle_state_chande() -> void:
	if player.is_on_floor():
			player.change_state("IdleState")
	elif Input.get_axis("left", "right") != 0:
			player.change_state("MovingState")
