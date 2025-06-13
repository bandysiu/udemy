extends CharacterBody2D
class_name Player

@export var _lives: int = 6

enum PlayerState {IDLE, RUN, JUMP, FALL, HURT, ATTACK, DEATH}

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -200.0
const GRAVITY: float = 600.0
const MAX_FALL: float = 400.0
const HURT_JUMP_VELOCITY: float = -140.0
const FALLEN_OFF: float = 200.0

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

var _state: PlayerState = PlayerState.IDLE
var _invincible: bool = false

func update_debug_label() -> void:
	debug_label.text = "floor:%s inv:%s\n%.0f, %.0f\n%s\nlives:%s" % [
		is_on_floor(),
		_invincible,
		velocity.x, velocity.y,
		PlayerState.find_key(_state),
		_lives
	]

func _ready() -> void:
	call_deferred("late_ready")

func late_ready() -> void:
	SignalManager.on_level_start.emit(_lives)

func _physics_process(delta: float) -> void:
	fallen_off()
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	update_player_state()
	update_debug_label()

func get_input() -> void:
	if _state == PlayerState.HURT:
		return
	
	velocity.x = 0
	
	if _state != PlayerState.DEATH:
		if Input.is_action_pressed("left"):
			velocity.x = -SPEED
			sprite.flip_h = true
		elif Input.is_action_pressed("right"):
			velocity.x = SPEED
			sprite.flip_h = false
		
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			SoundManager.play_clip(sound, SoundManager.SOUND_JUMP)
		
		if Input.is_action_just_pressed("shoot") and is_on_floor():
			shoot()
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

func update_player_state() -> void:
	if _state == PlayerState.ATTACK or _state == PlayerState.HURT:
		return
	
	if _state == PlayerState.DEATH:
		if is_on_floor() or !(global_position.y < FALLEN_OFF):
			set_physics_process(false)
		return
	
	if is_on_floor():
		if velocity.x == 0:
			set_state(PlayerState.IDLE)
		else:
			set_state(PlayerState.RUN)
	else:
		if velocity.y > 0:
			set_state(PlayerState.FALL)
		else:
			set_state(PlayerState.JUMP)

func set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return
	
	if _state == PlayerState.FALL:
		if new_state == PlayerState.IDLE or new_state == PlayerState.RUN:
			SoundManager.play_clip(sound, SoundManager.SOUND_LAND)
	
	_state = new_state
	match _state:
		PlayerState.IDLE:
			animation_player.play("idle")
		PlayerState.RUN:
			animation_player.play("run")
		PlayerState.JUMP:
			animation_player.play("jump")
		PlayerState.FALL:
			animation_player.play("fall")
		PlayerState.HURT:
			apply_hurt_jump()
		PlayerState.DEATH:
			animation_player.play("death")
			velocity = Vector2.ZERO

func shoot() -> void:
	var direction: Vector2 = Vector2.RIGHT
	if sprite.flip_h:
		direction = Vector2.LEFT
	shooter.shoot(direction)
	_state = PlayerState.ATTACK
	animation_player.play("attack")
	attack_timer.start()

func reduce_lives(reduction: int) -> bool:
	_lives -= reduction
	SoundManager.play_clip(sound, SoundManager.SOUND_DAMAGE)
	SignalManager.on_player_hit.emit(_lives)
	if _lives <= 0:
		death_timer.start()
		set_state(PlayerState.DEATH)
		return false
	return true

func apply_hit() -> void:
	if _invincible or _lives <= 0:
		return
	if !reduce_lives(1):
		return
	go_invincible()
	set_state(PlayerState.HURT)

func go_invincible() -> void:
	_invincible = true
	invincible_player.play("invincible")
	invincible_timer.start()

func apply_hurt_jump() -> void:
	animation_player.play("sad")
	velocity = Vector2(velocity.x * -0.8, HURT_JUMP_VELOCITY)
	hurt_timer.start()
	_state = PlayerState.HURT

func fallen_off() -> void:
	if !(global_position.y < FALLEN_OFF):
		reduce_lives(_lives)

func _on_invincible_timer_timeout() -> void:
	_invincible = false
	invincible_player.stop()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pickup"):
		return
	apply_hit()

func _on_hurt_timer_timeout() -> void:
	set_state(PlayerState.IDLE)

func _on_attack_timer_timeout() -> void:
	set_state(PlayerState.IDLE)

func _on_death_timer_timeout() -> void:
	SignalManager.on_game_over.emit()
	SoundManager.play_clip(sound, SoundManager.SOUND_GAMEOVER)
