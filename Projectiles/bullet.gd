class_name Bullet extends RigidBody3D

@onready var timer: Timer = $Timer

var speed = 10 
var time_to_despawn = 5
var direction = Vector3.FORWARD

func _ready() -> void:
	timer.start(time_to_despawn)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	if timer.time_left <= 0:
		queue_free()
