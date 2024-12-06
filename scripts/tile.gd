extends Resource

class_name Tile

static var tilesIDs = {}
static var tiles = []

@export var name: String
@export var color: Color
@export var tile_behavior: GDScript

@export_group("Sounds")
@export var place_sound: AudioStream
@export var break_sound: AudioStream

func _init() -> void:
	Tile.tilesIDs[self] = Tile.tiles.size()
	Tile.tiles.append(self)
