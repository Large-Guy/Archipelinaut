extends Node

var tilesIDs = {}
var tiles = []

var world_seed: int = 0

func _ready():
	world_seed = randi()
	
	tilesIDs[null] = -1
	for file_name in DirAccess.get_files_at("res://world/tiles/"):
		if (file_name.get_extension() == "tres"):
			load("res://world/tiles/" + file_name)
	print("Tiles loaded!")
