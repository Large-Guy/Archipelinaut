extends Resource
class_name Item

enum ItemType {None,Food,Weapon,Tool}

@export var item_name: String
@export var sprite: Texture2D
@export var item_type: ItemType
@export_multiline var description: String
@export var stack_size: int = 99

@export_group("Weapon")

@export var attack_damage: int

@export_group("Tool")

@export var tool_damage: int
@export var tool_level: int

@export_group("Tile")

@export var tile: Tile

static func spawn(item: Item, world_position: Vector2):
	var item_object: PackedScene = preload("res://scenes/prefabs/game/item.tscn")
	var n = item_object.instantiate()
	n.item = item
	n.global_position = world_position

	Globals.get_current_scene_node().add_child(n)
