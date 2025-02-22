extends Control


const MEMORY_TILE = preload("res://scenes/memory tile/memory_tile.tscn")


@onready var tc: GridContainer = $HB/MC1/TC
@onready var scorer: Scorer = $Scorer
@onready var label_moves: Label = $HB/MC2/VB/HB1/LabelMoves
@onready var label_pairs: Label = $HB/MC2/VB/HB2/LabelPairs
@onready var sound: AudioStreamPlayer = $Sound


func _ready() -> void:
	SignalManager.on_level_selected.connect(on_level_selected)


func _process(delta: float) -> void:
	label_moves.text = scorer.get_moves_made()
	label_pairs.text = scorer.get_pairs_made()

func on_level_selected(level_num: int) -> void:
	var ld: SelectedLevelData = GameManager.get_level_selection(level_num)
	var frame: Texture2D = ImageManager.get_random_frame_image()
	
	tc.columns = ld.get_num_cols()
	
	for im in ld.get_selected_images():
		add_memory_tile(im, frame)
	
	scorer.clear_new_game(ld.get_target_pairs())


func add_memory_tile(image: ItemImage, frame: Texture2D) -> void:
	var nt: MemoryTile = MEMORY_TILE.instantiate()
	tc.add_child(nt)
	nt.setup(image, frame)


func _on_exit_button_pressed() -> void:
	SoundManager.play_button_click(sound)
	for t in tc.get_children():
		t.queue_free()
	SignalManager.on_game_exit_presssed.emit()
