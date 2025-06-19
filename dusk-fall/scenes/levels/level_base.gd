extends Node2D

@export var _PLAYER: PackedScene

@onready var player_spawn_point: Marker2D = $PlayerSpawnPoint

func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)
	var PLAYER = _PLAYER.instantiate()
	PLAYER.position = player_spawn_point.position
	add_child(PLAYER)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func on_game_over() -> void:
	for mv in get_tree().get_nodes_in_group("Moveables"):
		mv.set_physics_process(false)
		mv.set_process(false)
