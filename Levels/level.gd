extends Node3D
class_name Level

@onready var player: Player = null
@onready var player_spawn: Node3D = $PlayerSpawn

func _ready():
	print("DEBUG: Loading player from GameManager...")
	
	player = GameManager.get_player_from_GameManager()
	
	if player:
		print("DEBUG: Debug_level: Player found in GameManager:", player)
		# Prevent duplicate addition
		add_child(player)
		player.global_transform.origin = player_spawn.global_transform.origin
		print("DEBUG: Debug_level: Player reparented into debug_level at", player.global_transform.origin)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_next"):  # up arrrow key
		if player:
			print(player)
	
	if event.is_action_pressed("Escape"):  # ESC key
		if not player:
			print("player is null")
		remove_child(player) #unparent before we store the player to gamemanager
		GameManager.store_player_in_GameManager(player)
		
		print("gamemanager should have stored player")
		for child in GameManager.get_children():
			print(child)
		
		get_tree().change_scene_to_file("res://Menus/ShipBuilder_Menu.tscn")
