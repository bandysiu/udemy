extends TextureButton


class_name MemoryTile


@onready var frame_image: TextureRect = $Frame
@onready var item_image: TextureRect = $Item


var _item_name: String
var _can_select: bool = true


func _ready() -> void:
	pass


func reveal(r: bool) -> void:
	frame_image.visible = r
	item_image.visible = r


func setup(image: ItemImage, frame: Texture2D) -> void:
	frame_image.texture = frame
	item_image.texture = image.get_texture()
	_item_name = image.get_item_name()
	reveal(false)


func _on_pressed() -> void:
	if _can_select:
		reveal(true)
