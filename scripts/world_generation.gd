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
			var tileID = Globals.tilesIDs[biome.sample_tile(Vector2(x,y) + chunk.global_position / chunk.global_scale)]
			chunk.set_tile(x,y,tileID)
	chunk.generate()
