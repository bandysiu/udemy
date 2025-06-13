extends EnemyBase

const JUMP_MIN_TIME: float = 2.0
const JUMP_MAX_TIME: float = 4.0
const JUMP_VELOCITY_X: float = 100.0
const JUMP_VELOCITY_Y: float = 210.0
const JUMP_VELOCITY_L: Vector2 = Vector2(-JUMP_VELOCITY_X, -JUMP_VELOCITY_Y)
const JUMP_VELOCITY_R: Vector2 = Vector2(JUMP_VELOCITY_X, -JUMP_VELOCITY_Y)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer
@onready var debug_label: Label = $Label

var _allowed_jump: bool = false
var _seen_player: bool = false

func update_debug_label() -> void:
	debug_label.text = "%.0f, %.0f\n%s" % [
		velocity.x, velocity.y,
		is_on_floor()
	]

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = 0
		flip_me()
		animated_sprite_2d.play("idle")
	
	apply_jump()
	check_for_failed_jump()
	move_and_slide()
	update_debug_label()

func apply_jump() -> void:
	if !is_on_floor():
		return
	if !_seen_player or !_allowed_jump:
		return
	
	if !animated_sprite_2d.flip_h:
		velocity = JUMP_VELOCITY_L
	else:
		velocity = JUMP_VELOCITY_R
	
	_allowed_jump = false
	animated_sprite_2d.play("jump2")
	start_timer()

func check_for_failed_jump() -> void:
	if !_allowed_jump and velocity.y != 0:
		if animated_sprite_2d.flip_h:
			velocity.x = JUMP_VELOCITY_X
		else:
			velocity.x = -JUMP_VELOCITY_X

func start_timer() -> void:
	jump_timer.wait_time = randf_range(JUMP_MIN_TIME, JUMP_MAX_TIME)
	jump_timer.start()

func flip_me() -> void:
	if _player_ref.global_position.x > global_position.x and !animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = true
	elif _player_ref.global_position.x < global_position.x and animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	_seen_player = true
	start_timer()

func _on_jump_timer_timeout() -> void:
	_allowed_jump = true
