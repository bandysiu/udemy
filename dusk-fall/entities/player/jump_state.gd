#JumpingState
extends PlayerStateMachine

var _jump_cut: bool
var _max_horizontal_speed: float
var _apex_modifier: float
var _direction: float
var _gravity_scale: float

func enter_state(player_node: CharacterBody2D, area = null) -> void:
	super(player_node)
	player.velocity.y = player.JUMP_VELOCITY
	_jump_cut = false

func handle_input(delta: float) -> void:
	_apex_modifier = clamp(1.0 - abs(player.velocity.y) / player.APEX_THRESHOLD, 0.0, 1.0)
	_direction = Input.get_axis("left", "right")
	
	handle_variable_jump()
	apply_gravity(delta)
	handle_horizontal_movement(delta)
	handle_state_change()

func exit_state() -> void:
	_jump_cut = false

func handle_variable_jump() -> void:
	if player.velocity.y < 0 and not Input.is_action_pressed("jump") and not _jump_cut:
		player.velocity.y = max(player.velocity.y, -player.JUMP_VELOCITY / 4)
		_jump_cut = true

func apply_gravity(delta: float) -> void:
	if player.velocity.y < 0:
		player.animation_player.play("jump")
		_gravity_scale = lerp(1.0, player.GRAVITY_FALL_MODIFIER, _apex_modifier)
		player.velocity.y += player.GRAVITY * _gravity_scale * delta
	else:
		player.animation_player.play("fall")
		player.velocity.y += player.GRAVITY * delta

func handle_horizontal_movement(delta: float) -> void:
	_max_horizontal_speed = lerp(player.SPEED * player.JUMP_HORIZONTAL_MODIFIER, player.SPEED, _apex_modifier)
	player.velocity.x = move_toward(player.velocity.x, _direction * _max_horizontal_speed, player.JUMP_ACCELERATION * delta)

func handle_state_change() -> void:
	if player.is_on_floor():
		if _direction != 0:
			player.change_state("MovingState")
		else:
			player.change_state("IdleState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
