extends HFlowContainer

@export var player: bool
@export var heart_size: int = 32

var target_entity: CharacterBody2D

var hearts: Array[Texture2D] = [
	preload("res://graphics/images/ui/heart1-4.png"),
	preload("res://graphics/images/ui/heart2-4.png"),
	preload("res://graphics/images/ui/heart3-4.png"),
	preload("res://graphics/images/ui/heart4-4.png")
]

var heart_nodes: Array[TextureRect]

func _ready():
	while target_entity == null: 
		if player:
			target_entity = Globals.player
		else:
			if get_parent() is CharacterBody2D:
				target_entity = get_parent()
		await get_tree().process_frame
	
	var heart_count = ceil(float(target_entity.health) / 4)
	
	for i in heart_count:
		var heart = TextureRect.new()
		heart.custom_minimum_size = Vector2(heart_size,heart_size)
		heart.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		add_child(heart)
		heart_nodes.append(heart)
	
	size.y = heart_size

func _process(delta):
	if target_entity == null: return
	
	var cur_health = target_entity.current_health
	
	if !player:
		top_level = true
		global_position = get_parent().global_position - size / 2 + Vector2(0,-heart_size * 1.5)
		if cur_health == target_entity.health:
			cur_health = 0
	
	var heart_count = ceil(float(target_entity.health) / 4)
	if heart_count != heart_nodes.size():
		for heart in heart_nodes:
			heart.queue_free()
		heart_nodes.clear()
		for i in heart_count:
			var heart = TextureRect.new()
			heart.custom_minimum_size = Vector2(heart_size,heart_size)
			heart.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
			add_child(heart)
			heart_nodes.append(heart)
		size.y = heart_size
	
	for h in heart_nodes.size():
		# implement
		var heart_index = int(clamp(cur_health - h * 4, 0, 4)) - 1
		if heart_index >= 0:
			heart_nodes[h].texture = hearts[heart_index]
			heart_nodes[h].visible = true
		else:
			heart_nodes[h].visible = false
