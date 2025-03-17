extends Node

var hull_list: Array = []

func _ready() -> void:
	scan_hulls()

##Scan disk and create a list of all the hull names
func scan_hulls():
	var hull_folder = "res://Player/PlayerShip/ShipParts/Hulls/"
	var dir = DirAccess.open(hull_folder)

	hull_list.clear()
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var hull_name = file_name.trim_suffix(".tscn")
			hull_list.append(hull_name) # Store names of the hulls, for future loading
		file_name = dir.get_next()
	
	dir.list_dir_end()
	print("Hulls found: ", hull_list) #debug output
	print("num hulls: " + str(hull_list.size()))
