extends Node

var stacks: Array[ItemStack]

func _ready():
	stacks.resize(20) # 5x4 first 5 are hotbar

func add_item(item: Item):
	for s in stacks.size():
		if stacks[s] != null and stacks[s].item == item and stacks[s].count < stacks[s].item.stack_size:
			stacks[s].count += 1
			return
	
	for s in stacks.size():
		if stacks[s] == null:
			stacks[s] = ItemStack.new()
			stacks[s].item = item
			stacks[s].count += 1
			return
