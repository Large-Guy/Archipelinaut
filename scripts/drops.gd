extends Node2D

@export_range(0,1) var chance: float = 1.0
@export var table: LootTable

func drop():
	if randf_range(0.0,1.0) < chance:
		for it in table.items:
			var count = randi_range(it.min_count,it.max_count)
			for c in range(count):
				Item.spawn(it.item, global_position)
