extends TextureRect

@export var renders_slot: int

func _process(delta):
	var item_stack: ItemStack = Inventory.stacks[renders_slot]
	
	var count = str(item_stack.count) if item_stack != null else ""
	var text = item_stack.item.sprite if item_stack != null else null
	
	$Texture.texture = text
	$Count.text = count
