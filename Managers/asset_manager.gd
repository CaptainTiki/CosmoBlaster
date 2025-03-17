extends Node

var hulls_list: Array[String] = []
var keels_list: Array[String] = []
var nacelles_list: Array[String] = []
var wings_list: Array[String] = []

func _ready() -> void:
	scan_parts("res://Player/PlayerShip/ShipParts/Hulls/", hulls_list)
	scan_parts("res://Player/PlayerShip/ShipParts/Keels/", keels_list)
	scan_parts("res://Player/PlayerShip/ShipParts/Nacelles/", nacelles_list)
	scan_parts("res://Player/PlayerShip/ShipParts/Wings/", wings_list)

##Scan location on disk and create a list of the part names
func scan_parts(part_folder: String, parts_list: Array[String]):
	var dir = DirAccess.open(part_folder)
	parts_list.clear()
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var part_name = file_name.trim_suffix(".tscn")
			parts_list.append(part_name) # Store names of the parts, for future loading
		file_name = dir.get_next()
	dir.list_dir_end()
	
func get_part_index(part_name : String, part_list : Array[String]) -> int:
	print("Looking for:", part_name)
	print("Available parts:", part_list)
	for i in part_list.size():
		if part_list[i].to_lower() == part_name.to_lower():
			return i  # Return the index when a match is found
	return -1  # Return -1 if hull is not found in the list
