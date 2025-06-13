extends Node2D

@onready var sound: AudioStreamPlayer2D = $Sound
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var sprite_2d: Sprite2D = $Visual/Sprite2D
@onready var trigger_1: CollisionShape2D = $Trigger1/Trigger1
@onready var trigger_2: CollisionShape2D = $Trigger2/Trigger2
@onready var wander_timer: Timer = $WanderTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var ground_attack_timer: Timer = $GroundAttackTimer
@onready var shoot_attack_timer: Timer = $ShootAttackTimer
@onready var random_wander: Timer = $RandomWander
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var label: Label = $Label
@onready var left: Marker2D = $Left
@onready var right: Marker2D = $Right

enum BOSS_STATE { IDLE, WANDER, GROUND_ATTACK, SHOOT_ATTACK }

const CONDITION_ON_TRIGGER: String = "parameters/conditions/on_trigger"
const CONDITION_CAN_ATTACK: String = "parameters/conditions/can_attack"
const CONDITION_GROUND_ATTACK: String = "parameters/conditions/ground_attack"
const CONDITION_SHOOT_ATTACK: String = "parameters/conditions/shoot_attack"

const WANDER_CHANCE: float = 10
const GROUND_ATTACK_CHANCE: float = 10
const SPEED: float = 150

var START_POSITION: Vector2
var _direction: int = -1
var _state: String
var _player_ref: Player
var _trigger_one: bool = false
var _trigger_two: bool = false
var _idling: bool = false
var _wandering: bool = false
var _can_idle: bool = true

func _ready() -> void:
	START_POSITION = position
	_state = "start"
	sprite_2d.frame = 83
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	

func _process(delta: float) -> void:
	set_state(state_machine.get_current_node())
	do_state(delta)
	#update_label()

func update_label() -> void:
	label.text = "%s\nx:%s\ncan idle:%s" % [_state, position.x, _can_idle]

func do_state(delta: float) -> void:
	if _idling:
		return
	if _wandering:
		wandering(delta)

func set_state(state: String) -> void:
	if state == _state:
		return
	
	_state = state
	
	match state:
		"idle":
			if _can_idle:
				decide_on_idle()
		"pulse":
			animation_tree[CONDITION_GROUND_ATTACK] = false
		"attack":
			pass
		"shoot":
			animation_tree[CONDITION_SHOOT_ATTACK] = false

func decide_on_idle() -> void:
	_can_idle = false
	if randf_range(0, 100) < WANDER_CHANCE:
		wander()
		print("wander")
	else:
		idle()
		print("idle")

func wander() -> void:
	_wandering = true
	wander_timer.wait_time = randi_range(5,10)
	wander_timer.start()

func wandering(delta: float) -> void:
	_state = "wander"
	if not wander_timer.is_stopped():
		if random_wander.is_stopped():
			random_wander.start()
			if randi() % 10 < 5:
				flip_me()
		position.x += _direction * SPEED * delta
		check_for_bounds()
	elif position != START_POSITION:
		if position.x > START_POSITION.x:
			if _direction > 0:
				flip_me()
		else:
			if _direction < 0:
				flip_me()
		position += position.direction_to(START_POSITION) * SPEED * delta
	
	if wander_timer.is_stopped():
		if position.x < START_POSITION.x + 2 and position.x > START_POSITION.x - 2:
			decide_on_attack()
			_wandering = false

func check_for_bounds() -> void:
	if position.x >= START_POSITION.x + 200 or position.x <= START_POSITION.x - 200:
		flip_me()

func idle() -> void:
	_idling = true
	idle_timer.wait_time = randf_range(0,0)
	idle_timer.start()

func boss_ground_attack() -> void:
	animation_tree[CONDITION_GROUND_ATTACK] = true
	ground_attack_timer.start()

func boss_shoot_attack() -> void:
	animation_tree[CONDITION_SHOOT_ATTACK] = true
	shoot_attack_timer.start()

func decide_on_attack() -> void:
	if randi_range(0, 100) < GROUND_ATTACK_CHANCE:
		boss_ground_attack()
	else:
		boss_shoot_attack()

func flip_me() -> void:
	scale.x *= -1
	_direction *= -1

func _on_trigger_1_area_entered(area: Area2D) -> void:
	_trigger_one = true
	trigger_1.disabled = true
	trigger_2.disabled = false

func _on_trigger_2_area_entered(area: Area2D) -> void:
	if _trigger_one:
		trigger_2.disabled = true
		animation_tree[CONDITION_ON_TRIGGER] = true

func _on_idle_timer_timeout() -> void:
	_idling = false
	decide_on_attack()

func _on_wander_timer_timeout() -> void:
	pass

func _on_ground_attack_timer_timeout() -> void:
	_can_idle = true

func _on_shoot_attack_timer_timeout() -> void:
	_can_idle = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	hit_flash.play("hit")
