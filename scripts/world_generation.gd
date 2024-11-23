extends Node2D

@export var noise: FastNoiseLite
@export var water: ColorRect

var chunk: StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	chunk = get_parent()
	noise = noise.duplicate()
	noise.seed = 5
	noise.offset += Vector3(global_position.x / chunk.scale.x,global_position.y / chunk.scale.y,0)
	var noiseTexture: Texture = NoiseTexture2D.new()
	noiseTexture.noise = noise.duplicate()
	noiseTexture.noise.frequency /= 32
	
	water.material = water.material.duplicate()
	water.material.set_shader_parameter("noise", noiseTexture)
	
	generate()

func generate():
	for y in range(chunk.size + 1):
		for x in range(chunk.size + 1):
			var n: int = floor(noise.get_noise_2d(x,y) * (chunk.tile_colors.size()))
			chunk.set_tile(x,y,n)
	chunk.generate()
