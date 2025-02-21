extends Node


const FRAME_IMAGES: Array[Texture2D] = [
	preload("res://assets/frames/blue_frame.png"),
	preload("res://assets/frames/green_frame.png"),
	preload("res://assets/frames/red_frame.png"),
	preload("res://assets/frames/yellow_frame.png"),
]


var _item_images: Array[ItemImage]


func _ready() -> void:
	var image_resource: ImageFileList = load("res://resources/image_files_lists.tres")
	for file_path in image_resource.get_file_names():
		add_file_to_list(file_path)
	pass


func add_file_to_list(file_path: String) -> void:
	_item_images.append(ItemImage.new(
		file_path.get_file(),
		load(file_path)
	))


func get_random_item_image() -> ItemImage:
	return _item_images.pick_random()


func get_image_at_index(index: int) -> ItemImage:
	return _item_images[index]


func shuffle_item_images() -> void:
	_item_images.shuffle()


func get_random_frame_image() -> Texture2D:
	return FRAME_IMAGES.pick_random()
