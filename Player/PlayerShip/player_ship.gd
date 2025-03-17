extends Node3D
class_name PlayerShip

@onready var hull: Node3D = $Hull
@onready var keel: Node3D = $Keel
@onready var nacelle: Node3D = $Nacelle
@onready var wing: Node3D = $Wing





var ship_stats: ShipStats = ShipStats.new()

# Store references to current parts for easy access
var current_parts = {
	"hull": null,
	"keel": null,
	"wings": null,
	"nacelles": null
}

var hulls = {
	"Standard": preload("res://Player/PlayerShip/ShipParts/Hulls/ship_hull_standard.tscn"),
	"Reinforced": preload("res://Player/PlayerShip/ShipParts/Hulls/ship_hull_reinforced.tscn")
}

var hull_names = [] #to store the keys for cycling through available parts
var current_hull_name = "Standard" #default hull

func _ready() -> void:
	hull_names = hulls.keys() # Get list of names
	update_hull()

func update_hull():
	#remove the current hull
	if hull.get_child_count() > 0:
		for oldhull in hull.get_children(): #get all the nodes in case theres extras some how
			oldhull.queue_free() #delete the old ones
		
		#load the new hull
		var new_hull = hulls[current_hull_name].instantiate()
		hull.add_child(new_hull)
		




##Swaps out the part from the ship
func swap_part(part_type: String, new_part: PackedScene):
	if current_parts.has(part_type):
		var old_part = current_parts[part_type]
		
		#if an old part exists, remove its stats
		if old_part:
			ship_stats.remove_part(old_part.mass, old_part.energy_capacity, old_part.thrust, old_part.integrity, old_part.armor)
		
	# Set the new part
	current_parts[part_type] = new_part
	
	# Add the new part's stats
	if new_part:
		var new_part_instance = new_part.instantiate()
		ship_stats.add_part(new_part.mass, new_part.energy_capacity, new_part.thrust, new_part.integrity, new_part.armor)
