extends TextureButton


@export var level_number: int = 1


@onready var label: Label = $Label


func _ready() -> void:
	var level_data: LevelData = GameManager.get_level(level_number)
	label.text = "%dx%d" % [
		level_data.get_cols(),
		level_data.get_rows()
	]



func _on_pressed() -> void:
	SignalManager.on_level_selected.emit(level_number)
