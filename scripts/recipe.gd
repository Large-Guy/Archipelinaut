extends Resource
class_name Recipe

@export_group("Input")
@export var required: Array[ItemStack]
@export_group("Output")
@export var outputs: Array[ItemStack]

func can_craft() -> bool:
	
