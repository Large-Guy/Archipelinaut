extends HFlowContainer

@export var player: bool
@export var heart_size: int = 32
@export var health_per_heart: int = 4
@export var heart_color: Color = Color(0.957, 0.335, 0.367)

var target_entity: CharacterBody2D

var heart_nodes: Array[TextureRect]

func _ready():
	while target_entity == null: 
		if player:
			target_entity = Globals.player
		else:
			if get_parent() is CharacterBody2D:
				target_entity = get_parent()
		await get_tree().process_frame
	
	var heart_count = ceil(float(target_entity.health) / health_per_heart)
	
	for i in heart_count:
		var heart = TextureRect.new()
		heart.custom_minimum_size = Vector2(heart_size,heart_size)
		heart.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		heart.material = preload("res://graphics/materials/heart.tres").duplicate()
		heart.texture = preload("res://graphics/images/ui/heart4-4.png")
		heart.modulate = heart_color
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
	
	var heart_count = ceil(float(target_entity.health) / health_per_heart)
	if heart_count != heart_nodes.size():
		for heart in heart_nodes:
			heart.queue_free()
		heart_nodes.clear()
		for i in heart_count:
			var heart = TextureRect.new()
			heart.custom_minimum_size = Vector2(heart_size,heart_size)
			heart.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
			heart.material = preload("res://graphics/materials/heart.tres").duplicate()
			heart.texture = preload("res://graphics/images/ui/heart4-4.png")
			heart.modulate = heart_color
			add_child(heart)
			heart_nodes.append(heart)
		size.y = heart_size
	
	for h in heart_nodes.size():
		# implement
		var heart_index = int(clamp(cur_health - h * health_per_heart, 0, health_per_heart)) - 1
		if heart_index >= 0:
			var target_percentage: float = float((health_per_heart - (heart_index + 1)))/float(health_per_heart)
			var current_percentage: float = heart_nodes[h].material.get_shader_parameter("percentage")
			heart_nodes[h].material.set_shader_parameter("percentage",lerp(current_percentage,target_percentage,20*delta))
			
			var progress = (target_percentage - current_percentage)/(1.0/health_per_heart)
			
			heart_nodes[h].modulate = lerp(heart_color,Color.WHITE,progress)
			
			heart_nodes[h].visible = true
		else:
			heart_nodes[h].visible = false
