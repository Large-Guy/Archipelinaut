extends TextureRect

@export var inventory: Node2D
@export var renders_slot: int

var item_texture: TextureRect = null
var item_location: Vector2

func _process(delta):
	var item_stack: ItemStack = inventory.stacks[renders_slot]
	
	var count = str(item_stack.count) if item_stack != null else ""
	var text = item_stack.item.sprite if item_stack != null else null
	
	$Texture.texture = text
	$Count.text = count
	
	if Input.is_action_just_pressed("hit") and get_global_rect().has_point(get_global_mouse_position()):
		inventory.current_selected = renders_slot
		Globals.current_selected_slot = self
	if inventory.grabbed_slot == self:
		item_texture.global_position = item_texture.global_position.lerp(get_global_mouse_position() - Vector2(32,32),10*delta)
		$Texture.texture = null
		$Count.text = ""
	else:
		if item_texture != null:
			item_texture.queue_free()
	queue_redraw()

func get_item() -> Item:
	return inventory.stacks[renders_slot].item if inventory.stacks[renders_slot] != null else null
