extends Node2D

@export var weapon_animator: AnimationPlayer
@export var item: Sprite2D

var character_controller: CharacterBody2D

func _ready() -> void:
	character_controller = get_parent()
	Globals.player = get_parent()

func attack():
	weapon_animator.stop()
	weapon_animator.play("Hit")
	
	await weapon_animator.animation_finished
	
	weapon_animator.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move = Input.get_vector("move_left","move_right","move_up","move_down")
	character_controller.move(move)
	
	if Input.is_action_just_pressed("hit"):
		attack()
	
	var mouse: Vector2 = get_global_mouse_position()
	
	if mouse.x < global_position.x:
		character_controller.look(Vector2(-1,0))
	
	if mouse.x > global_position.x:
		character_controller.look(Vector2(1,0))
	
	var item_stack: ItemStack = Globals.player.get_node("Inventory").stacks[Globals.player.get_node("Inventory").current_selected]
	
	item.texture = item_stack.item.sprite if item_stack != null else null
	
	for entity in Globals.entities:
		if entity != null and entity != character_controller and mouse.distance_to(entity.global_position) < 64 and Input.is_action_just_pressed("hit"):
			if item_stack != null:
				entity.damage(character_controller,0,item_stack.item)
			else:
				entity.damage(character_controller,1)
