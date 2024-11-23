extends Resource

class_name Tile

@export var name: String
@export var color: Color
@export var tile_behavior: GDScript

func _init() -> void:
	Globals.tilesIDs[self] = Globals.tiles.size()
	Globals.tiles.append(self)
