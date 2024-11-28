extends Control

@export var selector: TextureRect
@export var slots: HFlowContainer
@export var target_selector_size: float = 106

var item_slots: Array[TextureRect]

var s: float = 0

func _ready():
	item_slots.append_array(slots.get_children())
	s = target_selector_size

func _process(delta):
	var offset = (selector.size.x - 96)/2
	var target: Vector2 = item_slots[Inventory.current_selected].global_position - Vector2(offset,offset)
	selector.global_position = selector.global_position.lerp(target,7*delta)
	
	s = lerp(s,target_selector_size + clamp(selector.global_position.distance_to(target) / 2,0,20),20 * delta)
	selector.size = Vector2(s,s)
	
	selector.pivot_offset = selector.size / 2
	
	selector.rotation_degrees = lerp(selector.rotation_degrees,(selector.global_position.x - target.x) * 0.1,10*delta)
	
	if Input.is_key_label_pressed(KEY_1):
		Inventory.current_selected = 0
	if Input.is_key_label_pressed(KEY_2):
		Inventory.current_selected = 1
	if Input.is_key_label_pressed(KEY_3):
		Inventory.current_selected = 2
	if Input.is_key_label_pressed(KEY_4):
		Inventory.current_selected = 3
	if Input.is_key_label_pressed(KEY_5):
		Inventory.current_selected = 4
