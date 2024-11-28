extends Node2D

@export var table: LootTable

func drop():
	for it in table.items:
		var count = randi_range(it.min_count,it.max_count)
		for c in range(count):
			Item.spawn(it.item, global_position)
