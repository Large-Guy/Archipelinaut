extends Node2D

@export var item: Item

var velocity: Vector2 = Vector2.ZERO

func _ready():
	await get_tree().process_frame
	$Sprite.texture = item.sprite
	velocity = Vector2(randf_range(-100,100),-150)
	physics()

func physics():
	var ground_y = $Sprite.position.y + randf_range(-20,20)
	
	while $Sprite.position.y <= ground_y or velocity.y < 0:
		$Sprite.position.y += velocity.y * get_physics_process_delta_time()
		global_position.x += velocity.x * get_physics_process_delta_time()
		velocity.x *= 0.98
		velocity.y += 350*get_physics_process_delta_time()
		await get_tree().physics_frame
