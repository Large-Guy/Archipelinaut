extends Resource
class_name Item

@export var item_name: String
@export var sprite: Texture2D
@export_multiline var description: String
@export var stack_size: int = 99

static func spawn(item: Item, world_position: Vector2):
	var item_object: PackedScene = preload("res://scenes/prefabs/game/item.tscn")
	var n = item_object.instantiate()
	n.item = item
	n.global_position = world_position
	
	Globals.get_current_scene_node().add_child(n)
