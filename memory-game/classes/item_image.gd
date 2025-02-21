class_name ItemImage


var _item_name: String
var _item_texure: Texture2D


func _init(item_name: String, item_texure: Texture2D) -> void:
	_item_name = item_name
	_item_texure = item_texure


func get_item_name() -> String:
	return _item_name


func get_texture() -> Texture2D:
	return _item_texure
