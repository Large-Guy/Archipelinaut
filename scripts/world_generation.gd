extends Node2D

@export var chunk: StaticBody2D
@export var biome: Biome
@export var water: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	for noise in biome.noiseLayers:
		noise.seed = Globals.world_seed
	if(chunk == null):
		chunk = get_parent()
	generate()

func generate():
	for y in range(chunk.size + 1):
		for x in range(chunk.size + 1):
			var tileID = Globals.tilesIDs[biome.sample_tile(Vector2(x,y) + chunk.global_position / chunk.tile_size)]
			chunk.set_tile(x,y,tileID)
			
			var object = biome.sample_object(Vector2(x,y) + chunk.global_position / chunk.tile_size)
			
			if object != null:
				var n = object.object.instantiate()
				get_parent().add_child(n)
				n.global_position = Vector2(x,y) * chunk.tile_size + chunk.global_position
				n.global_position += Vector2(randf_range(-32,32),randf_range(-32,32))
				if object.randomize_rotation:
					n.rotation_degrees = randf_range(-360,360)
	chunk.generate()
