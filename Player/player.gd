extends CharacterBody3D
class_name Player

@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2


@export var base_rotation_speed: float = 5.0  # Base rotation speed
@export var damping: float = .95  # Friction to prevent infinite drift

@onready var player_ship: PlayerShip = %PlayerShip
@onready var rotation_pivot: Node3D = $RotationPivot #we use this to rotate the ship around

var is_movement_active: bool = false  # Controls whether movement is enabled

var ship_stats: ShipStats

var bullet : PackedScene = preload("uid://bpqfqkdfgxyli")

func _ready() -> void:
	ship_stats = player_ship.ship_stats

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Fire_Primary_Weapon"):
		fire_primary_weapon()

func _physics_process(delta: float) -> void:
	if not is_movement_active:
		return
	handle_movement(delta)
	handle_rotation(delta)

func handle_movement(delta: float) -> void:
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("Forward"):
		input_dir -= rotation_pivot.transform.basis.z  # Forward
	if Input.is_action_pressed("Backward"):
		input_dir += rotation_pivot.transform.basis.z  # Backward
	if Input.is_action_pressed("Straffe_Left"):
		input_dir -= rotation_pivot.transform.basis.x  # Left
	if Input.is_action_pressed("Straffe_Right"):
		input_dir += rotation_pivot.transform.basis.x  # Right

	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
		#var acceleration = (ship_stats.total_thrust / max(ship_stats.total_mass, 1)) * input_dir
		var acceleration = input_dir * 15.0
		label_1.text = "Acceleration: " + str(acceleration.length())
		velocity += acceleration * delta
		label_2.text = "Velocity: " + str(velocity.length())
	else:
		velocity *= damping  # Apply friction
		label_1.text = "Acceleration: " + str(0)
		label_2.text = "Velocity: " + str(velocity)
	move_and_slide()

func handle_rotation(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var world_mouse_pos = camera.project_position(mouse_pos, 10) # Project mouse into world space

	var direction = (world_mouse_pos - global_transform.origin)
	direction.y = 0  # Ignore vertical movement
	direction = direction.normalized()

	var target_rotation = atan2(-direction.x, -direction.z)  # Calculate Yaw rotation

	# Adjust rotation speed based on mass + wings torque
	var ship_stats = player_ship.ship_stats
	var total_torque = ship_stats.total_torque
	var adjusted_rotation_speed = (base_rotation_speed + total_torque) / max(ship_stats.total_mass, 1)

	rotation_pivot.rotation.y = lerp_angle(rotation_pivot.rotation.y, target_rotation, adjusted_rotation_speed * delta)

func fire_primary_weapon() -> void:
	var b : Bullet = bullet.instantiate()
	b.global_transform = $BulletSpawn.global_transform
	b.direction = -rotation_pivot.global_transform.basis.z
	b.top_level = true
	get_parent().add_child(b)
	pass
