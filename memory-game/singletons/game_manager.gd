extends Node


var _levels: Dictionary = {
	1: LevelData.new(1, 2, 2),
	2: LevelData.new(2, 4, 3),
	3: LevelData.new(3, 4, 4),
	4: LevelData.new(4, 4, 6),
	5: LevelData.new(5, 6, 6),
	6: LevelData.new(6, 6, 7),
}


func get_level(level: int) -> LevelData:
	return _levels[level]


func get_level_count() -> int:
	return _levels.keys().size()


func get_level_selection(level_num: int) -> SelectedLevelData:
	var level_data: LevelData = _levels[level_num]
	var selected_level_images: Array[ItemImage]
	
	ImageManager.shuffle_item_images()
	
	for i in range(level_data.get_target_pairs()):
		selected_level_images.append(ImageManager.get_image_at_index(i))
		selected_level_images.append(ImageManager.get_image_at_index(i))
	
	selected_level_images.shuffle()
	
	return SelectedLevelData.new(
		level_data.get_target_pairs(),
		level_data.get_cols(),
		selected_level_images
	)
