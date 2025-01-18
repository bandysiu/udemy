extends Control


@onready var label: Label = $Label


func _ready() -> void:
	SignalHub.on_score_updated.connect(on_score_updated)


func _process(delta: float) -> void:
	pass


func on_score_updated(score: int) -> void:
	label.set_text(str(score))
