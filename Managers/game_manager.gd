extends Node3D

var player: Player = null  # Store the entire Player instance
@onready var instance: Node3D = $"."

func set_player(new_player: Player):
	if new_player == null:
		print("ERROR: Attempted to store a null player!")
		return
	
	player = new_player
	print("DEBUG: Player stored in GameManager:", player)

func get_player() -> Player:
	if player == null:
		print("ERROR: get_player() called but no Player is stored in GameManager!")
	return player
