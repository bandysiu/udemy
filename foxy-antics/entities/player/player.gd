extends CharacterBody2D
class_name Player

enum PlayerState {IDLE, RUN, JUMP, FALL, HURT, ATTACK}

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -200.0
const GRAVITY: float = 600.0
const MAX_FALL: float = 400.0

@onready var sprite: Sprite2D = $Sprite
@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Shooter = $Shooter

var _state: PlayerState = PlayerState.IDLE

func update_debug_label() -> void:
	debug_label.text = "floor:%s\n%.0f, %.0f\n%s" % [
		is_on_floor(), velocity.x, velocity.y, PlayerState.find_key(_state)
	]

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	update_player_state()
	update_debug_label()

func get_input() -> void:
	velocity.x = 0
	
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
		sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
		sprite.flip_h = false
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

func update_player_state() -> void:
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

func shoot() -> void:
	var direction: Vector2 = Vector2.RIGHT
	if sprite.flip_h:
		direction = Vector2.LEFT
	shooter.shoot(direction)
