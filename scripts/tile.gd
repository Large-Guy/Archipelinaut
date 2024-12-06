extends Resource

class_name Tile

static var tilesIDs = {}
static var tiles = []

@export var name: String
@export var color: Color
@export var tile_behavior: GDScript

func _init() -> void:
	Tile.tilesIDs[self] = Tile.tiles.size()
	Tile.tiles.append(self)
