extends ParallaxBackground





func _ready() -> void:
	SignalHub.on_plane_died.connect(on_plane_died)


func _process(delta: float) -> void:
	scroll_offset.x -= GameManager.BASE_SCROLL_SPEED * delta


func on_plane_died() -> void:
	set_process(false)
	
