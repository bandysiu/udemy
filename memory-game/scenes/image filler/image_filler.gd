extends Node


const PATH: String = "res://assets/glitch/"


func _ready() -> void:
	var dir: DirAccess = DirAccess.open(PATH)
	
	var image_file_list: ImageFile = ImageFile.new()
	
	if dir:
		var files: PackedStringArray = dir.get_files()
		
		for fn in files:
			image_file_list.add_filename(PATH + fn)
			
	ResourceSaver.save(image_file_list, "res://resources/image_files_lists.tres")
