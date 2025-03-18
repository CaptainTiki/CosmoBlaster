extends Resource
class_name ShipStats

var total_mass : float = 0.0
var total_energy_capacity : float = 0.0
var total_thrust : float = 0.0
var total_integrity : float = 0.0
var total_armor : float = 0.0

##Reset stats to ZERO - so they can be re-calculated
func reset():
	total_mass = 0.0
	total_energy_capacity = 0.0
	total_thrust = 0.0
	total_integrity = 0.0
	total_armor = 0.0

##Add new part to total stats
func add_part(ship_part: ShipPart) -> void:
	total_mass += ship_part.mass
	total_energy_capacity += ship_part.energy_capacity
	total_thrust += ship_part.thrust
	total_integrity += ship_part.integrity
	total_armor += ship_part.armor

## Remove a ship part's stats from the total ship stats
func remove_part(ship_part: ShipPart) -> void:
	total_mass = max(0.0, total_mass - ship_part.mass)
	total_energy_capacity = max(0.0, total_energy_capacity - ship_part.energy_capacity)
	total_thrust = max(0.0, total_thrust - ship_part.thrust)
	total_integrity = max(0.0, total_integrity - ship_part.integrity)
	total_armor = max(0.0, total_armor - ship_part.armor)

func get_stats() -> Dictionary:
	return {
		"mass": total_mass,
		"energy": total_energy_capacity,
		"thrust": total_thrust,
		"integrity": total_integrity,
		"armor": total_armor
		}

func print_stats() -> void:
	print("-- Ship Stats --")
	print("Mass: ", total_mass)
	print("Energy Capacity: ", total_energy_capacity)
	print("Thrust: ", total_thrust)
	print("Integrity: ", total_integrity)
	print("Armor: ", total_armor)
