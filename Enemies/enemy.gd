extends CharacterBody3D
class_name Enemy

@export var health: int = 50  # Adjustable health value
@export var float_speed: float = 0.5  # For a slight hovering effect
@export var float_amplitude: float = 0.2

var start_position: Vector3
var float_timer: float = 0.0

func _ready() -> void:
	start_position = global_transform.origin  # Store original position

func _process(delta: float) -> void:
	float_timer += delta
	global_transform.origin.y = start_position.y + sin(float_timer * float_speed) * float_amplitude

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		destroy()

func destroy() -> void:
	queue_free()
