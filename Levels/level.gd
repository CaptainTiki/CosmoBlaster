extends Node3D
class_name Level

@onready var player: Player = null
@onready var player_spawn: Node3D = $PlayerSpawn

func _ready():
	player = GameManager.get_player_from_GameManager()
	player.is_movement_active = true #its deactivated when its stored. 
	if player:
		# Prevent duplicate addition
		add_child(player)
		player.global_transform.origin = player_spawn.global_transform.origin

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):  # ESC key
		remove_child(player) #unparent before we store the player to gamemanager
		GameManager.store_player_in_GameManager(player)
		
		get_tree().change_scene_to_file("res://Menus/ShipBuilder_Menu.tscn")
