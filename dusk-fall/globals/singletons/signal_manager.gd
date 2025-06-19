extends Node

signal on_create_bullet(position: Vector2, direction: Vector2, speed: float, life_span: float, object_type: Constants.ObjectType)
signal on_create_object(position: Vector2, object_type: Constants.ObjectType)
signal on_player_bullet_created
signal on_pickup_hit(points: int)
signal on_enemy_hit(points: int)
signal on_player_hit(lives: int)
signal on_game_over
signal on_respawn
signal on_level_start(lives: int)
signal on_score_updated(score: int)
signal on_boss_killed(points: int)
signal on_checkpoint_entered(position: Vector2)
signal reduce_points(points: int)
