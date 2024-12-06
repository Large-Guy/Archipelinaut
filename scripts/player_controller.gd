extends Node2D

@export var weapon_animator: AnimationPlayer
@export var item: Sprite2D
@export var interact_rate: float = 5

var character_controller: CharacterBody2D

var attack_time: float = 0

func _ready() -> void:
	character_controller = get_parent()
	Globals.player = get_parent()

func play_swing():
	weapon_animator.stop()
	weapon_animator.play("Hit")

	await weapon_animator.animation_finished

	weapon_animator.play("Idle")

func movement(_delta):
	var move = Input.get_vector("move_left","move_right","move_up","move_down")
	character_controller.move(move)

	var mouse: Vector2 = get_global_mouse_position()

	if mouse.x < global_position.x:
		character_controller.look(Vector2(-1,0))

	if mouse.x > global_position.x:
		character_controller.look(Vector2(1,0))

func can_attack() -> bool:
	var mouse: Vector2 = get_global_mouse_position()

	for entity in Globals.entities:
		if entity != null and entity != character_controller and mouse.distance_to(entity.global_position) < 64:
			return true
	return false

func attack() -> void:
	if attack_time < 1.0/interact_rate: return

	attack_time = 0
	play_swing()

	var item_stack: ItemStack = Globals.player.inventory.stacks[Globals.player.inventory.current_selected]
	var mouse: Vector2 = get_global_mouse_position()

	for entity in Globals.entities:
		if entity != null and entity != character_controller and mouse.distance_to(entity.global_position) < 64:
			if item_stack != null:
				entity.damage(character_controller,0,item_stack.item)
			else:
				entity.damage(character_controller,1)

func build():
	var item_stack: ItemStack = Globals.player.inventory.stacks[Globals.player.inventory.current_selected]
	var hover_chunk = ChunkManager.instance.get_chunk(ChunkManager.instance.global_to_chunk_position(get_global_mouse_position()))
	var current_hovering_tile = null
	if hover_chunk != null:
		current_hovering_tile = hover_chunk.walls.get_tile(hover_chunk.walls.world_to_tile(get_global_mouse_position()))

	if current_hovering_tile == -1:
		play_swing()
		hover_chunk.walls.set_tile(hover_chunk.walls.world_to_tile(get_global_mouse_position()), Tile.tilesIDs[item_stack.item.tile])
		hover_chunk.walls.generate()

func interaction(delta):
	attack_time += delta

	if !Input.is_action_pressed("hit"): return

	var item_stack: ItemStack = Globals.player.inventory.stacks[Globals.player.inventory.current_selected]

	var can_hit = (item_stack == null or item_stack.item.tile == null)

	if can_hit:
		attack()
	else:
		build()

func hand(_delta):
	var item_stack: ItemStack = Globals.player.inventory.stacks[Globals.player.inventory.current_selected]
	item.texture = item_stack.item.sprite if item_stack != null else null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	movement(delta)
	interaction(delta)
	hand(delta)
