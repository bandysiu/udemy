extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $Sprite
@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Shooter = $Shooter
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var hurt_timer: Timer = $HurtTimer
@onready var invincible_player: AnimationPlayer = $InvinciblePlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var death_timer: Timer = $DeathTimer
@onready var respawn_timer: Timer = $RespawnTimer

@export var starting_lives: int = 6

@export var SPEED: float = 150.0
@export var MOVE_ACCELERATION: float = 600
@export var MOVE_DECELERATION: float = 900

@export var GRAVITY: float = 500.0
@export var JUMP_VELOCITY: float = -250.0
@export var JUMP_ACCELERATION: float = 1000
@export var APEX_THRESHOLD: float = 200.0
@export var GRAVITY_FALL_MODIFIER: float = 0.005
@export var JUMP_HORIZONTAL_MODIFIER: float = 0.7
@export var MAX_FALL_SPEED: float = 400.0
@export var JUMP_BUFFER_TIME: float = 0.15
@export var COYOTE_TIME: float = 0.15

@export var KNOCKBACK_TIMER: float = 0.3
@export var KNOCKBACK_FORCE: float = 100.0
@export var KNOCKBACK_ACCELERATION: float = 50.0
@export var KNOCKBACK_DECELARATION: float = 2.0

const FALLEN_OFF: float = 820.0

var _current_state: PlayerStateMachine
var last_facing_direction: int
var _invincible: bool = false
var _respawn: Vector2
var _lives: int
var _jump_buffer_timer: float = 0.0
var _coyote_timer: float = 0.0

func update_debug_label() -> void:
	debug_label.text = "floor:%s inv:%s\n%.0f, %.0f\n%s\nlives:%s" % [
		is_on_floor(),
		_invincible,
		velocity.x, velocity.y,
		_current_state,
		_lives
	]

func _ready() -> void:
	SignalManager.on_checkpoint_entered.connect(on_checkpoint_entered)
	_respawn = global_position
	_lives = starting_lives
	change_state("IdleState")
	call_deferred("late_ready")

func late_ready() -> void:
	SignalManager.on_level_start.emit(_lives)

func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		_jump_buffer_timer = JUMP_BUFFER_TIME

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	
	handle_player_input(delta)
	update_debug_label()
	
	if _jump_buffer_timer > 0.0:
		_jump_buffer_timer -= delta
	
	if not is_on_floor():
		_coyote_timer -= delta
	else:
		_coyote_timer = COYOTE_TIME

func change_state(new_state: String, area: Area2D = null) -> void:
	if _current_state:
		_current_state.exit_state()
	_current_state = get_node(new_state)
	if _current_state:
		_current_state.enter_state(self, area)

func handle_player_input(delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		last_facing_direction = sign(direction)
	if _current_state:
		_current_state.handle_input(delta)
	
	move_and_slide()
	
	if direction >= 1:
		sprite.flip_h = false
	elif direction <= -1:
		sprite.flip_h = true

func handle_gravity(delta: float) -> void:
	fallen_off_screen()
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = clamp(velocity.y, -INF, MAX_FALL_SPEED)

func shoot() -> void:
	var direction: Vector2 = Vector2.RIGHT
	if sprite.flip_h:
		direction = Vector2.LEFT
	shooter.shoot(direction)
	attack_timer.start()

func reduce_lives(reduction: int) -> bool:
	if _lives > 0: 
		SoundManager.play_clip(sound, SoundManager.SOUND_DAMAGE)
		SignalManager.on_player_hit.emit(_lives)
	_lives -= reduction
	if _lives <= 0:
		death_timer.start()
		return false
	return true

func apply_hit(area: Area2D) -> void:
	if _invincible or _lives <= 0:
		return
	if !reduce_lives(1):
		return
	go_invincible()
	change_state("HurtState", area)

func go_invincible() -> void:
	_invincible = true
	invincible_player.play("invincible")
	invincible_timer.start()

func fallen_off_screen() -> void:
	if !(global_position.y < FALLEN_OFF):
		reduce_lives(_lives)

func _on_invincible_timer_timeout() -> void:
	_invincible = false
	invincible_player.stop()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pickup"):
		return
	apply_hit(area)

func _on_hurt_timer_timeout() -> void:
	pass

func _on_attack_timer_timeout() -> void:
	pass

func _on_death_timer_timeout() -> void:
	SignalManager.on_game_over.emit()
	SoundManager.play_clip(sound, SoundManager.SOUND_GAMEOVER)
	respawn_timer.start()

func on_checkpoint_entered(position: Vector2) -> void:
	_respawn = position

func _on_respawn_timer_timeout() -> void:
	set_process(true)
	set_physics_process(true)
	SignalManager.on_respawn.emit()
	SignalManager.reduce_points.emit(-100)
	global_position = _respawn
	_lives = starting_lives
	late_ready()
