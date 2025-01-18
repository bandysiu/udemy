extends Node2D


@export var pipes_scene: PackedScene 


@onready var pipes_holder = $PipesHolder
@onready var spawn_upper = $SpawnUpper
@onready var spawn_lower = $SpawnLower
@onready var pipe_spawn_timer = $PipeSpawnTimer


func _ready() -> void:
	SignalHub.on_plane_died.connect(_on_plane_died)
	ScoreManager.set_score(0)
	randomize()
	spawn_pipes()


func _process(delta) -> void:
	reduce_timer(delta)
	exit_to_menu()


func _on_pipe_spawn_timer_timeout() -> void:
	spawn_pipes()


func spawn_pipes() -> void:
	var new_pipes = pipes_scene.instantiate()
	new_pipes.position = Vector2(spawn_upper.position.x, randf_range(spawn_upper.position.y, spawn_lower.position.y))
	pipes_holder.add_child(new_pipes)


func _on_plane_died() -> void:
	pipe_spawn_timer.stop()


func reduce_timer(delta) -> void:
	pipe_spawn_timer.wait_time -= 0.01 * delta
	
	
func exit_to_menu() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		GameManager.load_main_scene()
