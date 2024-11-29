extends Node

var current_selected: int = 0
var stacks: Array[ItemStack]

var slots: Array[TextureRect]
var grabbed_slot: TextureRect

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

func count_item(item: Item):
	var count: int = 0
	for s in stacks.size():
		if stacks[s].item == item:
			count += stacks[s].count
	return count

func remove_item(item: Item):
	for s in stacks.size():
		if stacks[s] != null and stacks[s].item == item and stacks[s].count < stacks[s].item.stack_size:
			stacks[s].count -= 1
			if stacks[s].count <= 0:
				stacks[s] = null
			return
