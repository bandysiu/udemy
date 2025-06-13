extends Node

const SOUND_FIREBALL = "fireball"
const SOUND_STINGER = "stinger"
const SOUND_CHECKPOINT = "checkpoint"
const SOUND_DAMAGE = "damage"
const SOUND_KILL = "kill"
const SOUND_GAMEOVER = "gameover1"
const SOUND_IMPACT = "impact"
const SOUND_LAND = "land"
const SOUND_MUSIC1 = "music1"
const SOUND_MUSIC2 = "music2"
const SOUND_PICKUP = "pickup"
const SOUND_BOSS_ARRIVE = "boss_arrive"
const SOUND_JUMP = "jump"
const SOUND_WIN = "win"

var SOUNDS: Dictionary = {
	SOUND_CHECKPOINT: preload("res://assets/sound/checkpoint.wav"),
	SOUND_DAMAGE: preload("res://assets/sound/Hit_4.wav"),
	SOUND_KILL: preload("res://assets/sound/sfx_exp_short_soft11.wav"),
	SOUND_GAMEOVER: preload("res://assets/sound/Loose_3.wav"),
	SOUND_IMPACT: preload("res://assets/sound/impact.wav"),
	SOUND_JUMP: preload("res://assets/sound/30_Jump_03.wav"),
	SOUND_LAND: preload("res://assets/sound/45_Landing_01.wav"),
	SOUND_FIREBALL: preload("res://assets/sound/04_Fire_explosion_04_medium.wav"),
	SOUND_STINGER: preload("res://assets/sound/56_Attack_03.wav"),
	SOUND_MUSIC1: preload("res://assets/sound/Farm Frolics.ogg"),
	SOUND_MUSIC2: preload("res://assets/sound/Flowing Rocks.ogg"),
	SOUND_PICKUP: preload("res://assets/sound/sfx_sounds_button8.wav"),
	SOUND_BOSS_ARRIVE: preload("res://assets/sound/boss_arrive.wav"),
	SOUND_WIN: preload("res://assets/sound/you_win.ogg")
}

func play_clip(player: AudioStreamPlayer2D, clip_key: String) -> void:
	if !SOUNDS.has(clip_key):
		return
	player.stream = SOUNDS[clip_key]
	player.volume_db = -10
	player.play()
