extends EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_ray: RayCast2D = $FloorRay

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = -_speed if animated_sprite_2d.flip_h else _speed
	
	move_and_slide()
	
	check_turn_around()

func check_turn_around() -> void:
	if is_on_wall() or !floor_ray.is_colliding():
		floor_ray.position.x = -floor_ray.position.x
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
