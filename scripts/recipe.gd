extends Resource
class_name Recipe

@export_group("Input")
@export var required: Array[ItemStack]
@export_group("Output")
@export var outputs: Array[ItemStack]

func can_craft() -> bool:
	for item in required:
		if Globals.player.get_node("Inventory").count_item(item.item) < item.count:
			return false
	
	return true

func craft():
	if !can_craft(): return
	
	for item in required:
		for i in item.count:
			Globals.player.get_node("Inventory").remove_item(item.item)
	
	for output in outputs:
		for i in output.count:
			Globals.player.get_node("Inventory").add_item(output.item)
