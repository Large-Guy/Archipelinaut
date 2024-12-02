extends HFlowContainer

@export var slot_grid_size: Vector2i
@export var attached_inventory: Node2D
@export var use_player_inventory: bool = false
@export var display_slot_start_index: int

var last_size: Vector2i

func _ready():
	if use_player_inventory:
		attached_inventory = Globals.player.get_node("Inventory")

func _process(delta):
	if attached_inventory == null:
		attached_inventory = Globals.player.get_node("Inventory")
		return
	
	size = Vector2(slot_grid_size) * 100
	if last_size != slot_grid_size:
		last_size = slot_grid_size
		for s in get_children():
			s.queue_free()
		
		var slot = load("res://scenes/item_slot.tscn")
		
		for i in slot_grid_size.x * slot_grid_size.y:
			var s = slot.instantiate()
			s.inventory = attached_inventory
			s.renders_slot = i + display_slot_start_index
			add_child(s)
		
		print("Added slots")
