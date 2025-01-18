extends RigidBody2D

enum BIRD_STATE {READY, DRAG, RELEASE}

var _state: BIRD_STATE

const DRAG_LIMIT_MAX: Vector2 = Vector2(70, 70);
const DRAG_LIMIT_MIN: Vector2 = Vector2(-70, -70);
const IMPULSE_MULT: float = 10.0;
const IMPULSE_MAX: float = 1000.0;

var _arrow_scale_x: float = 0.0
var _start: Vector2
var _last_position: Vector2
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_vector: Vector2 = Vector2.ZERO
var _last_collision_count: int = 0

@onready var label: Label = $Label
@onready var arrow: Sprite2D = $Arrow
@onready var arrow_sound: AudioStreamPlayer2D = $ArrowSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound
@onready var landing_sound: AudioStreamPlayer2D = $LandingSound
@onready var timer: Timer = $Timer

func _ready() -> void:
	_start = position
	_last_position = position
	_arrow_scale_x = arrow.scale.x
	arrow.hide()
	set_new_state(BIRD_STATE.READY) 
	
func _physics_process(delta: float) -> void:
	#label.text += "%.1f, %.1f" % [_dragged_vector.x, _dragged_vector.y]
	label.text = "%s" % BIRD_STATE.keys()[_state]
	update(delta)

func die() -> void:
	SignalManager.on_bird_died.emit(_last_position)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_last_position = _start
	die()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if _state == BIRD_STATE.READY and event.is_action_pressed("drag"):
		set_new_state(BIRD_STATE.DRAG)

func update_drag() -> void:
	if detect_release():
		return
	
	var global_mouse_position = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(global_mouse_position)
	play_drag_sound()
	drag_in_limits()
	scale_arrow()

func update(delta: float) -> void:
	match _state:
		BIRD_STATE.DRAG:
			update_drag()
		BIRD_STATE.RELEASE:
			update_flight()
		BIRD_STATE.READY:
			label.text = "Drag to shoot"

func set_new_state(new_state: BIRD_STATE) -> void:
	_state = new_state
	label.text = ""
	if _state == BIRD_STATE.RELEASE:
		set_release()
	elif _state == BIRD_STATE.DRAG:
		set_drag()

func set_release() -> void:
	arrow.hide()
	freeze = false
	apply_central_impulse(get_impulse())
	launch_sound.play()
	SignalManager.on_attempt_made.emit()

func set_drag() -> void:
	arrow.show()
	_drag_start = get_global_mouse_position()

func detect_release() -> bool:
	if _state == BIRD_STATE.DRAG:
		if Input.is_action_just_released("drag"):
			set_new_state(BIRD_STATE.RELEASE)
			return true
	return false

func get_dragged_vector(global_mouse_position: Vector2) -> Vector2:
	return global_mouse_position - _drag_start

func drag_in_limits() -> void:
	_last_dragged_vector = _dragged_vector
	
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIMIT_MIN.x,
		DRAG_LIMIT_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIMIT_MIN.y,
		DRAG_LIMIT_MAX.y
	)
	#position = _start + _dragged_vector

func play_drag_sound() -> void:
	if(_last_dragged_vector - _dragged_vector).length() > 0:
		if arrow_sound.playing == false:
			arrow_sound.play()

func scale_arrow() -> void:
	var impulse_length = get_impulse().length()
	var perc = impulse_length / IMPULSE_MAX
	arrow.scale.x = (_arrow_scale_x * perc) + _arrow_scale_x
	arrow.rotation = (_last_position - get_global_mouse_position()).angle()

func get_impulse() -> Vector2: 
	return _dragged_vector * -1 * IMPULSE_MULT

func _on_sleeping_state_changed() -> void:
	if sleeping:
		var cb = get_colliding_bodies()
		if cb.size() > 0 and cb[0].is_in_group("cup"):
			cb[0].die()
			set_sleeping(false)
		else:
			_last_position = position
			call_deferred("die")

func update_flight() -> void:
	play_landing_sound()

func play_landing_sound() -> void:
	if _last_collision_count == 0 and get_contact_count() > 0 and !landing_sound.playing :
		landing_sound.play()
	_last_collision_count = get_contact_count()

#func check_for_moving_platform() -> void:
	#var cb = get_colliding_bodies()
	#var last_cb
	#if cb.size() > 0 and !sleeping and !is_in_group("cup"):
		#timer.start()
		#last_cb = cb[0]
	#elif last_cb != cb[0]:
		#timer.stop()
	#if timer.is_stopped():
			#_last_position = _start
			#die()
