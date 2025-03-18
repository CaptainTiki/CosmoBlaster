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
	"nacelles": [],
	"wings": []
}

func _ready() -> void:
	set_hull(0)
	set_keel(0)
	set_nacelle(0)
	set_wing(0)
	pass

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
	
	align_ship_parts()
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
	
	# set the keel name
	new_keel.name = AssetManager.keels_list[index]
	keel_node.add_child(new_keel)
	
	# Now safely update current_parts
	current_parts["keel"] = new_keel
	
	align_ship_parts()
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
	
	# Remove old nacelles safely and clear references
	if "nacelles" in current_parts and current_parts["nacelles"].size() > 0:
		for old_nacelle in current_parts["nacelles"]:
			if is_instance_valid(old_nacelle) and old_nacelle.is_inside_tree():
				old_nacelle.queue_free()
		current_parts["nacelles"].clear()  # Ensure we don't hold references to deleted objects
		
	# Instantiate and add first nacelle
	var new_nacelle = nacelle_scene.instantiate()
	new_nacelle.name = AssetManager.nacelles_list[index]  # Ensure the name is properly set
	nacelle_node.add_child(new_nacelle)
		
	#instatiate mirrored nacelle
	var mirrored_nacelle = nacelle_scene.instantiate()
	mirrored_nacelle.name = AssetManager.nacelles_list[index] + "_mirrored"
	nacelle_node.add_child(mirrored_nacelle)
	
	# update current_parts
	current_parts["nacelles"] = [new_nacelle, mirrored_nacelle]

	align_ship_parts()
	calculate_ship_stats()

func set_wing(index: int):
	# Safety check: Ensure index is valid
	if index < 0 or index >= AssetManager.wings_list.size():
		printerr("ERROR: Index out of bounds!", index)
		return

	var new_wing_filename: String = wing_folder + AssetManager.wings_list[index] + ".tscn"
	var wing_scene = load(new_wing_filename)
	if wing_scene == null or not wing_scene is PackedScene:
		printerr("ERROR: Failed to load wing scene at:", new_wing_filename)
		return  # Stop here if loading fails
	
	# Remove old wings safely
	if "wings" in current_parts and current_parts["wings"].size() > 0:
		for old_wing in current_parts["wings"]:
			if is_instance_valid(old_wing) and old_wing.is_inside_tree():
				old_wing.queue_free()
		current_parts["wings"].clear()

	# Instantiate and add new wing
	var new_wing = wing_scene.instantiate()
	new_wing.name = AssetManager.wings_list[index]  # Ensure the name is properly set
	wing_node.add_child(new_wing)
	
	#instatiate mirrored wing
	var mirrored_wing = wing_scene.instantiate()
	mirrored_wing.name = AssetManager.wings_list[index] + "_mirrored"
	nacelle_node.add_child(mirrored_wing)
	
	# Now safely update current_parts
	current_parts["wings"] = [new_wing, mirrored_wing]
	
	align_ship_parts()
	calculate_ship_stats()

func align_ship_parts() -> void:
	if not current_parts["hull"] or not current_parts["keel"] or not current_parts["nacelles"] or not current_parts["wings"]:
		return # don't align if we don't have all the parts assigned yet. 
	
	#reset all positions to ZERO before alignment
	current_parts["hull"].transform.origin = Vector3.ZERO
	current_parts["keel"].transform.origin = Vector3.ZERO
	current_parts["nacelles"][0].transform.origin = Vector3.ZERO
	current_parts["nacelles"][1].transform.origin = Vector3.ZERO
	current_parts["wings"][0].transform.origin = Vector3.ZERO
	current_parts["wings"][1].transform.origin = Vector3.ZERO
	
# Align Hull - KeelAttachmentNode to Vector3.ZERO
	var keel_attachment = current_parts["hull"].get_node_or_null("KeelAttachmentNode")
	if keel_attachment:
		var offset = keel_attachment.transform.origin  # Get its local position
		current_parts["hull"].transform.origin -= offset  # Move hull in the opposite direction
	
# Align Keel - HullAttachmentNode to Vector3.ZERO
	var hull_attachment = current_parts["keel"].get_node_or_null("HullAttachmentNode")
	if hull_attachment:
		var offset = hull_attachment.transform.origin  # Get its local position
		current_parts["keel"].transform.origin -= offset  # Move keel in the opposite direction
		
# Align Nacelles
	var keel_nacelle_attachment = current_parts["keel"].get_node_or_null("NacelleAttachmentNode")

	if keel_nacelle_attachment and current_parts["nacelles"].size() == 2:
		var nacelle_primary = current_parts["nacelles"][0]
		var nacelle_mirrored = current_parts["nacelles"][1]
		
		var nacelle_keel_attachment = nacelle_primary.get_node_or_null("KeelAttachmentNode")
		
		if nacelle_keel_attachment:
			var keel_target_pos = keel_nacelle_attachment.global_transform.origin
			var nacelle_attach_pos = nacelle_keel_attachment.global_transform.origin
			var offset = keel_target_pos - nacelle_attach_pos  # Calculate needed movement
			
			# Move primary nacelle
			nacelle_primary.global_transform.origin += offset
			
			 # Set mirrored nacelle's position and flip X
			nacelle_mirrored.global_transform.origin = nacelle_primary.global_transform.origin
			nacelle_mirrored.global_transform.origin.x *= -1  # Flip on X-axis
			
# Align wing's nacelle_attachment to nacelle's wing_attachment
	var wing_primary = current_parts["wings"][0]
	var wing_mirrored = current_parts["wings"][1]
	
	# Align wings
	var nacelle_wing_attachment = current_parts["nacelles"][0].get_node_or_null("WingAttachmentNode")
	var wing_nacelle_attachment = wing_primary.get_node_or_null("NacelleAttachmentNode")
	
	if nacelle_wing_attachment and wing_nacelle_attachment:
		var nacelle_target_pos = nacelle_wing_attachment.global_transform.origin
		var wing_attach_pos = wing_nacelle_attachment.global_transform.origin
		var offset = nacelle_target_pos - wing_attach_pos
		
		# Move primary wing
		wing_primary.global_transform.origin += offset
		
		# Position and mirror the second wing
		wing_mirrored.global_transform.origin = wing_primary.global_transform.origin
		wing_mirrored.global_transform.origin.x *= -1  # Flip the position across X-axis
		
	else:
		printerr("ERROR: Missing attachment nodes on nacelle or wing!")

func calculate_ship_stats():
	# Reset stats before recalculating
	ship_stats.reset()

	# Hull
	if is_instance_valid(current_parts["hull"]):
		ship_stats.add_part(current_parts["hull"])
	
	# Keel
	if is_instance_valid(current_parts["keel"]):
		ship_stats.add_part(current_parts["keel"])
	
	# Nacelles
	if "nacelles" in current_parts and current_parts["nacelles"].size() > 0:
		for nacelle in current_parts["nacelles"]:
			if is_instance_valid(nacelle):
				ship_stats.add_part(nacelle)
	
	# Wings
	if "wings" in current_parts and current_parts["wings"].size() > 0:
		for wing in current_parts["wings"]:
			if is_instance_valid(wing):
				ship_stats.add_part(wing)
	
	ship_stats.print_stats()

func get_part_name(part_name: String) -> String:
	if !current_parts.has(part_name) or current_parts[part_name] == null:
		printerr("ERROR: Part ", part_name, " does not exist in current_parts!")
		return "unknown_part"  # Return a placeholder instead of an empty string
		
	# Check if it's an array (for nacelles and wings)
	if current_parts[part_name] is Array and current_parts[part_name].size() > 0:
		return current_parts[part_name][0].name  # ✅ Only return the first item's name
		
	# Return name normally for single parts (hull, keel)
	return current_parts[part_name].name
