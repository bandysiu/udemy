#DashState
extends PlayerStateMachine

const DASH_SPEED: float = 300.0
const DASH_DURATION: float = 0.2
var dash_timer = 0.0

func enter_state(player_node: CharacterBody2D, area = null) -> void:
	super(player_node)
	var direction = Input.get_axis("left", "right")
	if direction == 0:
		direction = player.last_facing_direction
	player.velocity.x = direction * DASH_SPEED
	dash_timer = DASH_DURATION

func handle_input(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <= 0:
		if Input.get_axis("left", "right"):
			player.change_state("MovingState")
		else:
			player.change_state("IdleState")
	else:
		player.velocity.y = 0
