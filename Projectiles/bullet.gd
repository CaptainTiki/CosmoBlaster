class_name Bullet extends RigidBody3D

@onready var timer: Timer = $Timer

@export var damage_amount : int = 5

var speed = 10 
var time_to_despawn = 5
var direction = Vector3.FORWARD

func _ready() -> void:
	timer.start(time_to_despawn)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	if timer.time_left <= 0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):  # Check if the object can take damage
		body.take_damage(damage_amount)
		print("Bullet hit:", body.name, "Collision layer:", body.collision_layer)
	queue_free()  # Destroy the bullet on impact
