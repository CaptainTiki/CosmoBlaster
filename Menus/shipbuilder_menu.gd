extends Control

@onready var mass_label: Label = %Mass_Label
@onready var thrust_label: Label = %Thrust_Label
@onready var energy_capacity_label: Label = %EnergyCapacity_Label
@onready var armor_label: Label = %Armor_Label
@onready var integrity_label: Label = %Integrity_Label


@onready var ship_viewport: SubViewport = %ShipViewport
@onready var player : Player = null
@onready var player_ship: PlayerShip = null

@onready var hull_select_label: Label = %Hull_Select_Label
@onready var keel_select_label: Label = %Keel_Select_Label
@onready var nacelle_select_label: Label = %Nacelle_Select_Label
@onready var wing_select_label: Label = %Wing_Select_Label

func _ready() -> void:
	#get ship from gamemanager - on first load
	player = GameManager.get_player_from_GameManager()
	player_ship = player.player_ship
	
	ship_viewport.add_child(player)
	
	hull_select_label.text = AssetManager.hulls_list[0]
	keel_select_label.text = AssetManager.keels_list[0]
	nacelle_select_label.text = AssetManager.nacelles_list[0]
	wing_select_label.text = AssetManager.wings_list[0]
	update_ship_stats()

func update_ship_stats():
	#check for player for debug:
	if not player:
		print("player is missing")
	if not player_ship:
		return #dont want to update if we don't have a ship yet

	var stats = player_ship.ship_stats.get_stats()
	
	mass_label.text = "Mass: " + str(stats.mass)
	energy_capacity_label.text = "Energy Capacity: " + str(stats.energy)
	thrust_label.text = "Thrust: " + str(stats.thrust)
	integrity_label.text = "Integrity: " + str(stats.integrity)
	armor_label.text = "Armor: " + str(stats.armor)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):  # ESC key
		get_tree().quit()

func _on_player_ship_ship_part_updated() -> void:
	update_ship_stats()

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

func _on_deploy_bn_pressed():
	if player and player_ship:
		ship_viewport.remove_child(player) #unparent from this scene
		GameManager.store_player_in_GameManager(player) #store ref and parent to gamemanager
		get_tree().change_scene_to_file("res://Levels/debug_level.tscn")

func _on_exit_bn_pressed() -> void:
	get_tree().quit()
