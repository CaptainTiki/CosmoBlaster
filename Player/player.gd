extends CharacterBody3D

var speed = 400 #pixels per second
var bullet : PackedScene = preload("uid://bpqfqkdfgxyli")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Fire_Primary_Weapon"):
		fire_primary_weapon()
	

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	#Get input
	if Input.is_action_pressed("Right"):
		direction.x += 1
	if Input.is_action_pressed("Left"):
		direction.x -= 1
	if Input.is_action_pressed("Up"):
		direction.z -= 1
	if Input.is_action_pressed("Down"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	velocity = direction * speed * delta
	
	move_and_slide()

func fire_primary_weapon() -> void:
	var b : Bullet = bullet.instantiate()
	b.global_transform = $BulletSpawn.global_transform
	b.direction = -global_transform.basis.z
	b.top_level = true
	get_parent().add_child(b)
	pass
