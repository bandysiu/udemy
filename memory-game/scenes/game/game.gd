extends Control


const MEMORY_TILE = preload("res://scenes/memory tile/memory_tile.tscn")


@onready var tc: GridContainer = $HB/MC1/TC



func _ready() -> void:
	SignalManager.on_level_selected.connect(on_level_selected)


func on_level_selected(level_num: int) -> void:
	var ld: SelectedLevelData = GameManager.get_level_selection(level_num)
	var frame: Texture2D = ImageManager.get_random_frame_image()
	
	tc.columns = ld.get_num_cols()
	
	for im in ld.get_selected_images():
		add_memory_tile(im, frame)


func add_memory_tile(image: ItemImage, frame: Texture2D) -> void:
	var nt: MemoryTile = MEMORY_TILE.instantiate()
	tc.add_child(nt)
	nt.setup(image, frame)


func _on_exit_button_pressed() -> void:
	for t in tc.get_children():
		t.queue_free()
	SignalManager.on_game_exit_presssed.emit()
