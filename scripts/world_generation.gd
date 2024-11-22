extends Node2D

@export var noise: FastNoiseLite

var chunk: StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	chunk = get_parent()
	noise.seed = 5
	generate()

func generate():
	for y in range(chunk.size + 1):
		for x in range(chunk.size + 1):
			var n: int = floor(noise.get_noise_2d(x + global_position.x / chunk.scale.x,y + global_position.y / chunk.scale.y) * (chunk.tile_colors.size()))
			chunk.set_tile(x,y,n)
	chunk.generate()
