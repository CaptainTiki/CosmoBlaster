extends Control

@onready var player_ship: PlayerShip = %PlayerShip
@onready var hull_select_label: Label = %Hull_Select_Label
@onready var keel_select_label: Label = %Keel_Select_Label
@onready var nacelle_select_label: Label = %Nacelle_Select_Label
@onready var wing_select_label: Label = %Wing_Select_Label

func _ready() -> void:
	hull_select_label.text = AssetManager.hulls_list[0]
	keel_select_label.text = AssetManager.keels_list[0]
	nacelle_select_label.text = AssetManager.nacelles_list[0]
	wing_select_label.text = AssetManager.wings_list[0]

func _on_hull_next_bn_pressed() -> void:
	await get_tree().process_frame
	var part_name: String = player_ship.get_part_name("hull")
	
	if part_name == "unknown_part":
		printerr("ERROR: Cannot switch hulls because current hull is invalid.")
		return
	
	var index: int = AssetManager.get_part_index(part_name, AssetManager.hulls_list)
	if index == -1:
		printerr("ERROR: Could not find current hull in hulls_list!")
		return
	index = (index + 1 + AssetManager.hulls_list.size()) % AssetManager.hulls_list.size()  # Loop backwards safely
	hull_select_label.text = AssetManager.hulls_list[index]
	player_ship.set_hull(index)


func _on_hull_prev_bn_pressed() -> void:
	await get_tree().process_frame
	var part_name: String = player_ship.get_part_name("hull")
	if part_name == "unknown_part":
		printerr("ERROR: Cannot switch hulls because current hull is invalid.")
		return
	
	var index: int = AssetManager.get_part_index(part_name, AssetManager.hulls_list)
	if index == -1:
		printerr("ERROR: Could not find current hull in hulls_list!")
		return

	index = (index - 1 + AssetManager.hulls_list.size()) % AssetManager.hulls_list.size()  # Loop backwards safely
	player_ship.set_hull(index)


func _on_keel_next_bn_pressed() -> void:
	await get_tree().process_frame
	var part_name: String = player_ship.get_part_name("keel")
	if part_name == "unknown_part":
		printerr("ERROR: Cannot switch keels because current keel is invalid.")
		return
	
	var index: int = AssetManager.get_part_index(part_name, AssetManager.keels_list)
	if index == -1:
		printerr("ERROR: Could not find current keel in keels_list!")
		return
	index = (index + 1 + AssetManager.keels_list.size()) % AssetManager.keels_list.size()  # Loop backwards safely
	keel_select_label.text = AssetManager.keels_list[index]
	player_ship.set_keel(index)


func _on_keel_prev_bn_pressed() -> void:
	await get_tree().process_frame
	var part_name: String = player_ship.get_part_name("keel")
	if part_name == "unknown_part":
		printerr("ERROR: Cannot switch keels because current keel is invalid.")
		return
	
	var index: int = AssetManager.get_part_index(part_name, AssetManager.keels_list)
	if index == -1:
		printerr("ERROR: Could not find current keel in keels_list!")
		return

	index = (index - 1 + AssetManager.keels_list.size()) % AssetManager.keels_list.size()  # Loop backwards safely
	player_ship.set_keel(index)


func _on_nacelle_next_bn_pressed() -> void:
	await get_tree().process_frame
	var part_name: String = player_ship.get_part_name("nacelles")
	if part_name == "unknown_part":
		printerr("ERROR: Cannot switch nacelle because current nacelle is invalid.")
		return
	
	var index: int = AssetManager.get_part_index(part_name, AssetManager.nacelles_list)
	if index == -1:
		printerr("ERROR: Could not find current nacelle in nacelles_list!")
		return
	index = (index + 1 + AssetManager.nacelles_list.size()) % AssetManager.nacelles_list.size()  # Loop backwards safely
	nacelle_select_label.text = AssetManager.nacelles_list[index]
	player_ship.set_nacelle(index)


func _on_nacelle_prev_bn_pressed() -> void:
	await get_tree().process_frame
	var part_name: String = player_ship.get_part_name("nacelles")
	
	if part_name == "unknown_part":
		printerr("ERROR: Cannot switch nacelles because current nacelle is invalid.")
		return
	
	var index: int = AssetManager.get_part_index(part_name, AssetManager.nacelles_list)
	
	if index == -1:
		printerr("ERROR: Could not find current nacelle in nacelles_list!")
		return

	index = (index - 1 + AssetManager.nacelles_list.size()) % AssetManager.nacelles_list.size()  # Loop backwards safely
	player_ship.set_nacelle(index)


func _on_wing_next_bn_pressed() -> void:
	await get_tree().process_frame
	var part_name: String = player_ship.get_part_name("wings")
	
	if part_name == "unknown_part":
		printerr("ERROR: Cannot switch wings because current wing is invalid.")
		return
		
	var index: int = AssetManager.get_part_index(part_name, AssetManager.wings_list)
		
	if index == -1:
		printerr("ERROR: Could not find current wing in wings_list!")
		return
	index = (index + 1 + AssetManager.wings_list.size()) % AssetManager.wings_list.size()  # Loop backwards safely
	wing_select_label.text = AssetManager.wings_list[index]
	player_ship.set_wing(index)


func _on_wing_prev_bn_pressed() -> void:
	await get_tree().process_frame
	var part_name: String = player_ship.get_part_name("wings")
	if part_name == "unknown_part":
		printerr("ERROR: Cannot switch wings because current wing is invalid.")
		return
	
	var index: int = AssetManager.get_part_index(part_name, AssetManager.wings_list)
	if index == -1:
		printerr("ERROR: Could not find current wing in wings_list!")
		return

	index = (index - 1 + AssetManager.wings_list.size()) % AssetManager.wings_list.size()  # Loop backwards safely
	player_ship.set_wing(index)
