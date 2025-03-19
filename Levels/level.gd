extends Node3D
class_name Level

@onready var player: Player = null
@onready var player_spawn: Node3D = $PlayerSpawn

func _ready():
	print("DEBUG: Loading player from GameManager...")
	var player = GameManager.get_player()
	
	if player:
		print("DEBUG: Player found in GameManager:", player)
		if not player.get_parent():  # If Player is not already in the scene, add it
			add_child(player)
		player.global_transform.origin = player_spawn.global_transform.origin
		print("DEBUG: Player reparented into debug_level at", player.global_transform.origin)
	else:
		print("ERROR: No Player found in GameManager! Creating new player...")
		var new_player = load("res://Player/player.tscn").instantiate()
		add_child(new_player)
		GameManager.set_player(new_player)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):  # ESC key
		GameManager.set_player(player)#set the ship in game manager before leaving scene
		get_tree().change_scene_to_file("res://Menus/ShipBuilder_Menu.tscn")
