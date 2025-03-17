extends Node3D
class_name PlayerShip

@onready var hull_node: Node3D = $Hull_Node
@onready var hull_folder: String = "res://Player/PlayerShip/ShipParts/Hulls/"
@onready var keel_node: Node3D = $Keel_Node
@onready var keel_folder: String = "res://Player/PlayerShip/ShipParts/Keels/"
@onready var nacelle_node: Node3D = $Nacelle_Node
@onready var nacelle_folder: String = "res://Player/PlayerShip/ShipParts/Nacelles/"
@onready var wing_node: Node3D = $Wing_Node
@onready var wing_folder: String = "res://Player/PlayerShip/ShipParts/Wings/"

var ship_stats: ShipStats = ShipStats.new()

# Store references to current parts for easy access
var current_parts = {
	"hull": null,
	"keel": null,
	"nacelles": null,
	"wings": null
}

func _ready() -> void:
	set_hull(0)
	set_keel(0)
	set_nacelle(0)
	set_wing(0)

func set_hull(index: int):
	# Safety check: Ensure index is valid
	if index < 0 or index >= AssetManager.hulls_list.size():
		printerr("ERROR: Index out of bounds!", index)
		return

	var new_hull_filename: String = hull_folder + AssetManager.hulls_list[index] + ".tscn"

	var hull_scene = load(new_hull_filename)
	if hull_scene == null or not hull_scene is PackedScene:
		printerr("ERROR: Failed to load hull scene at:", new_hull_filename)
		return  # Stop here if loading fails
	
	# Remove old hull
	for old_hull in hull_node.get_children():
		old_hull.queue_free()

	# Instantiate and add new hull
	var new_hull = hull_scene.instantiate()
	if new_hull == null:
		printerr("ERROR: Instantiation failed for", new_hull_filename)
		return  # Stop here if instantiation fails

	new_hull.name = AssetManager.hulls_list[index]  # Ensure the name is properly set
	hull_node.add_child(new_hull)

	# Now safely update current_parts
	current_parts["hull"] = new_hull
	
	# Align KeelAttachmentNode to Vector3.ZERO
	var keel_attachment = new_hull.get_node_or_null("KeelAttachmentNode")
	if keel_attachment:
		var offset = keel_attachment.transform.origin  # Get its local position
		new_hull.transform.origin -= offset  # Move hull in the opposite direction
		print("DEBUG: Adjusted hull position by:", offset)

	calculate_ship_stats()

func set_keel(index: int):
	# Safety check: Ensure index is valid
	if index < 0 or index >= AssetManager.keels_list.size():
		printerr("ERROR: Index out of bounds!", index)
		return
		
	var new_keel_filename: String = keel_folder + AssetManager.keels_list[index] + ".tscn"
	var keel_scene = load(new_keel_filename)
	if keel_scene == null or not keel_scene is PackedScene:
		printerr("ERROR: Failed to load keel scene at:", new_keel_filename)
		return  # Stop here if loading fails
		
	# Remove old keel
	for old_keel in keel_node.get_children():
		old_keel.queue_free()
		
	# Instantiate and add new keel
	var new_keel = keel_scene.instantiate()
	if new_keel == null:
		printerr("ERROR: Instantiation failed for", new_keel_filename)
		return  # Stop here if instantiation fails
	new_keel.name = AssetManager.keels_list[index]  # Ensure the name is properly set
	keel_node.add_child(new_keel)
	
	# Now safely update current_parts
	current_parts["keel"] = new_keel
	
	# Align KeelAttachmentNode to Vector3.ZERO
	var hull_attachment = new_keel.get_node_or_null("HullAttachmentNode")
	if hull_attachment:
		var offset = hull_attachment.transform.origin  # Get its local position
		new_keel.transform.origin -= offset  # Move keel in the opposite direction
		print("DEBUG: Adjusted keel position by:", offset)
	calculate_ship_stats()

func set_nacelle(index: int):
	# Safety check: Ensure index is valid
	if index < 0 or index >= AssetManager.nacelles_list.size():
		printerr("ERROR: Index out of bounds!", index)
		return
		
	var new_nacelle_filename: String = nacelle_folder + AssetManager.nacelles_list[index] + ".tscn"
	var nacelle_scene = load(new_nacelle_filename)
	if nacelle_scene == null or not nacelle_scene is PackedScene:
		printerr("ERROR: Failed to load nacelle scene at:", new_nacelle_filename)
		return  # Stop here if loading fails
		
	# Remove old nacelle
	for old_keel in keel_node.get_children():
		old_keel.queue_free()
		
	# Instantiate and add new nacelle
	var new_nacelle = nacelle_scene.instantiate()
	if new_nacelle == null:
		printerr("ERROR: Instantiation failed for", new_nacelle_filename)
		return  # Stop here if instantiation fails
		
	new_nacelle.name = AssetManager.nacelles_list[index]  # Ensure the name is properly set
	keel_node.add_child(new_nacelle)
	
	# Now safely update current_parts
	current_parts["nacelle"] = new_nacelle
	
	# Align nacelle's keel_attachment to keel's nacelle_attachment
	var keel = current_parts["keel"]
	if keel == null:
		print("ERROR: Keel not set, cannot align nacelle!")
		return
		
	var keel_nacelle_attachment = keel.get_node_or_null("NacelleAttachmentNode")
	var nacelle_keel_attachment = new_nacelle.get_node_or_null("KeelAttachmentNode")
		
	if keel_nacelle_attachment and nacelle_keel_attachment:
		var keel_target_pos = keel_nacelle_attachment.global_transform.origin
		var nacelle_attach_pos = nacelle_keel_attachment.global_transform.origin
		
		var offset = keel_target_pos - nacelle_attach_pos  # Calculate needed movement
		new_nacelle.global_transform.origin += offset  # Move nacelle into position
		
		print("DEBUG: Adjusted nacelle position by:", offset)
	else:
		print("ERROR: Missing attachment nodes on keel or nacelle!")
		
	calculate_ship_stats()

func set_wing(index: int):
	# Safety check: Ensure index is valid
	if index < 0 or index >= AssetManager.keels_list.size():
		printerr("ERROR: Index out of bounds!", index)
		return

	var new_keel_filename: String = keel_folder + AssetManager.keels_list[index] + ".tscn"

	var keel_scene = load(new_keel_filename)
	if keel_scene == null or not keel_scene is PackedScene:
		printerr("ERROR: Failed to load keel scene at:", new_keel_filename)
		return  # Stop here if loading fails
	
	# Remove old keel
	for old_keel in keel_node.get_children():
		old_keel.queue_free()

	# Instantiate and add new keel
	var new_keel = keel_scene.instantiate()
	if new_keel == null:
		printerr("ERROR: Instantiation failed for", new_keel_filename)
		return  # Stop here if instantiation fails

	new_keel.name = AssetManager.keels_list[index]  # Ensure the name is properly set
	keel_node.add_child(new_keel)

	# Now safely update current_parts
	current_parts["keel"] = new_keel
	
	# Align KeelAttachmentNode to Vector3.ZERO
	var hull_attachment = new_keel.get_node_or_null("HullAttachmentNode")
	if hull_attachment:
		var offset = hull_attachment.transform.origin  # Get its local position
		new_keel.transform.origin -= offset  # Move keel in the opposite direction
		print("DEBUG: Adjusted keel position by:", offset)

	calculate_ship_stats()

func calculate_ship_stats():
	#print("Calculate Ship Stats")
	pass

func get_part_name(part_name: String) -> String:
	if !current_parts.has(part_name) or current_parts[part_name] == null:
		printerr("ERROR: Part ", part_name, " does not exist in current_parts!")
		return "unknown_part"  # Return a placeholder instead of an empty string
	return current_parts[part_name].name
