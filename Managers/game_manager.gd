extends Node3D
#GameManager Script

@onready var instance: Node3D = $"."
@onready var player: Player = $Player


func store_player_in_GameManager(new_player: Player):
	if new_player == null:
		print("ERROR: Gamemanager: Attempted to store a null player! Ignoring.")
		return
	
	player = new_player
	add_child(player)  # Reparent player to GameManager
	print("DEBUG: Gamemanager: Player stored in GameManager:", player)

func get_player_from_GameManager() -> Player:
	if player == null:
		print("ERROR: Gamemanager: get_player() called but no Player is stored in GameManager!")
	remove_child(player)	
	return player

func get_player_reference() -> Player:
	if player == null:
		print("ERROR: Gamemanager: get_player() called but no Player is stored in GameManager!")
	return player
