extends EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooter: Shooter = $Shooter
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var direction_timer: Timer = $DirectionTimer

const FLY_SPEED_X: float = 70
const FLY_SPEED_Y: float = 40
const FLY_SPEED: Vector2 = Vector2(FLY_SPEED_X, FLY_SPEED_Y)

var _fly_direction: Vector2 = Vector2.ZERO
var _chance_to_flyup_above: float = 30.0
var _chance_to_flyup_below: float = 70.0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity = _fly_direction
	move_and_slide()
	shoot()

func shoot() -> void:
	if player_detector.is_colliding():
		shooter.shoot(global_position.direction_to(_player_ref.global_position))

func fly_to_player() -> void:
	var x_direction = sign(_player_ref.global_position.x - global_position.x)
	if x_direction > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	
	if _player_ref.global_position.y > global_position.y:
		_fly_direction = Vector2(x_direction, 1) * calculate_trajectory(_chance_to_flyup_above)
	else:
		_fly_direction = Vector2(x_direction, 1) * calculate_trajectory(_chance_to_flyup_below)

func calculate_trajectory(chance: float) -> Vector2:
	if chance > randf_range(0, 100):
		return Vector2(FLY_SPEED_X, FLY_SPEED_Y * -1)
	return FLY_SPEED

func _on_direction_timer_timeout() -> void:
	fly_to_player()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("chase")
	direction_timer.start()
	fly_to_player()
