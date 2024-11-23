extends Resource

class_name Biome

@export_group("Generation")
@export var amplitudes: Array[float]
@export var noiseLayers: Array[FastNoiseLite]

@export_group("Tileset")
@export_range(0,1) var tile_amplitudes_percentage: Array[float]
@export var tiles: Array[Tile]

@export_group("Objects")
@export var world_objects: Array[WorldObject]

func sample_height(pos: Vector2) -> float:
	var height: float = 0
	for i in range(noiseLayers.size()):
		height += (noiseLayers[i].get_noise_2dv(pos) + 1) / 2 * amplitudes[i]
	
	return height

func sample_height_normalized(pos: Vector2) -> float:
	var height: float = 0
	var max: float = 0
	
	for i in range(noiseLayers.size()):
		height += (noiseLayers[i].get_noise_2dv(pos) + 1) / 2 * amplitudes[i]
		max += amplitudes[i]
	
	
	return height / max

func seeded_random(pos: Vector2) -> float:
	return (cos(sin(pos.x*439498.39457390)*2885.3984589)*cos(sin(pos.y*34535.348957)*34987.348975)+1.0)/2.0

func sample_object(pos: Vector2) -> WorldObject:
	var alt = sample_height_normalized(pos)
	
	var i: int = 0
	
	var random = RandomNumberGenerator.new()
	random.seed = hash(pos * 100)
	
	for object in world_objects:
		if alt > object.spawn_altitude_min and alt < object.spawn_altitude_max:
			if random.randf() < object.spawn_frequency:
				return object
		i += 1
	return null

func sample_tile(pos: Vector2) -> Tile:
	var height: float = sample_height_normalized(pos)
	
	var current_tile: Tile = null
	
	for tile in range(tile_amplitudes_percentage.size()):
		if(height > tile_amplitudes_percentage[tile]):
			current_tile = tiles[tile]
		else:
			break
	
	return current_tile
