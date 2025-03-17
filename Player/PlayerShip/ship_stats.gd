extends Resource
class_name ShipStats

var total_mass : float
var total_energy_capacity : float
var total_thrust : float
var total_integrity : float
var total_armor : float

##Add new part to total stats
func add_part(part_mass : float,part_energy_capacity : float,part_thrust : float,part_integrity : float,part_armor : float) -> void:
	total_mass += part_mass
	total_energy_capacity += part_energy_capacity
	total_thrust += part_thrust
	total_integrity += part_integrity
	total_armor += part_armor

##Remove old part from total stats
func remove_part(part_mass : float,part_energy_capacity : float,part_thrust : float,part_integrity : float,part_armor : float) -> void:
	total_mass -= part_mass
	total_energy_capacity -= part_energy_capacity
	total_thrust -= part_thrust
	total_integrity -= part_integrity
	total_armor -= part_armor

func get_stats() -> Dictionary:
	return {
		"mass": total_mass,
		"thrust": total_thrust,
		"energy": total_energy_capacity
		}
