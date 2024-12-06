extends Node2D

@export var chunk: StaticBody2D
@export var biome: Biome
@export var water: ColorRect

var depth_texture: ImageTexture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	for noise in biome.noiseLayers:
		noise.seed = Globals.world_seed
	if(chunk == null):
		chunk = get_parent()
	generate()

	water.material = water.material.duplicate()

func _process(_delta: float) -> void:
	water.material.set_shader_parameter("depth",depth_texture)
	water.material.set_shader_parameter("position",global_position)
	water.material.set_shader_parameter("size",chunk.size * chunk.tile_size)

func generate():
	# The water depth relies on bilinear filtering so we need to extend the image by 1 pixel in each direction

	var image: Image = Image.create(chunk.size + 3,chunk.size + 3,false,Image.FORMAT_RGBAF)

	for y in range(chunk.size + 3):
		for x in range(chunk.size + 3):
			var sample_position = Vector2(x - 1, y - 1) + chunk.global_position / chunk.tile_size

			var normal: Vector3 = Vector3.ZERO

			var depth = biome.sample_height_normalized(sample_position)

			image.set_pixel(x,y,Color(normal.x,normal.y,normal.z,depth))

	for y in range(chunk.size + 1):
		for x in range(chunk.size + 1):
			var sample_position = Vector2(x,y) + chunk.global_position / chunk.tile_size

			var tileID = Tile.tilesIDs[biome.sample_tile(sample_position)]
			chunk.set_tile(Vector2i(x,y),tileID)


			var object = biome.sample_object(sample_position)

			if x == chunk.size or y == chunk.size: continue

			if object == null: continue

			var n = object.object.instantiate()
			add_child(n)
			n.global_position = Vector2(x,y) * chunk.tile_size + chunk.global_position
			n.global_position += Vector2(randf_range(-32,32),randf_range(-32,32))
			if object.randomize_rotation:
				n.rotation_degrees = randf_range(-360,360)

	chunk.generate()

	depth_texture = ImageTexture.create_from_image(image)
