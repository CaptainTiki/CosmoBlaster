extends CharacterBody3D
class_name Player

@onready var player_ship: PlayerShip = $PlayerShip

var bullet : PackedScene = preload("uid://bpqfqkdfgxyli")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Fire_Primary_Weapon"):
		fire_primary_weapon()


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		print("WARNING: Player is being queue_free()! This may cause loss of data.")

func _physics_process(delta: float) -> void:
	pass

func fire_primary_weapon() -> void:
	var b : Bullet = bullet.instantiate()
	b.global_transform = $BulletSpawn.global_transform
	b.direction = -global_transform.basis.z
	b.top_level = true
	get_parent().add_child(b)
	pass
