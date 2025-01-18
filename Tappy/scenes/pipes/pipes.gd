extends Node2D


@onready var SCORE: AudioStreamPlayer = $Score
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


var is_scroll: bool = true


func _ready() -> void:
	SignalHub.on_plane_died.connect(on_plane_died)


func _process(delta) -> void:
	if is_scroll:
		position.x -= GameManager.BASE_SCROLL_SPEED * delta
	check_for_off_screen()


func _on_screen_exited() -> void:
	queue_free()


func check_for_off_screen() -> void:
	if visible_on_screen_notifier_2d.global_position.x < get_viewport_rect().position.x:
		queue_free()


func _on_pipe_body_entered(body: Node2D):
	if body is Tappy:
		if body.has_method("die"):
			body.die()


func _on_lazer_body_entered(body: Node2D) -> void:
	if body is Tappy:
		ScoreManager.increment_score(1)
		SCORE.play()


func on_plane_died() -> void:
	is_scroll = false
