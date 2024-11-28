extends Node2D

@export var item: Item

var velocity: Vector2 = Vector2.ZERO

func _ready():
	await get_tree().process_frame
	$Sprite.texture = item.sprite
	velocity = Vector2(randf_range(-200,200),-250)
	physics()

func physics():
	var ground_y = $Sprite.position.y + randf_range(-20,20)
	
	while $Sprite.position.y <= ground_y or velocity.y < 0:
		$Sprite.position.y += velocity.y * get_physics_process_delta_time()
		global_position.x += velocity.x * get_physics_process_delta_time()
		velocity.x *= 0.98
		velocity.y += 600*get_physics_process_delta_time()
		await get_tree().physics_frame

func _physics_process(delta):
	if global_position.distance_to(Globals.player.global_position) < 128:
		global_position = global_position.lerp(Globals.player.global_position,10*delta)
	
	if global_position.distance_to(Globals.player.global_position) < 48:
		Inventory.add_item(item)
		Sounds.play_pitch_chain(preload("res://audio/sfx/miscellaneous/item.wav"),0.2)
		queue_free()
