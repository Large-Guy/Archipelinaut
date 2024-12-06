extends Node

enum Team {
	NEUTRAL = 0,
	PLAYER = 1,
	PLAYER_RED = 2,
	PLAYER_GREEN = 3,
	PLAYER_YELLOW = 4,
	PLAYER_BLUE = 5,
	ENEMY = 6,
	ENEMY_STANDARD = 7,
	ENEMY_BOSS = 8,
	ANY,
}

var world_seed: int = 0

var entities: Array[CharacterBody2D]

var player: CharacterBody2D

var current_selected_slot: TextureRect

func _ready():
	world_seed = randi()

	Tile.tilesIDs[null] = -1
	for file_name in DirAccess.get_files_at("res://world/tiles/"):
		if (file_name.get_extension() == "tres"):
			load("res://world/tiles/" + file_name)
	print("Tiles loaded!")

func get_entities_on_team(from: CharacterBody2D, teams: Array[Team], distance: float = -1, filter: Callable = Callable()) -> Array[CharacterBody2D]:
	# expand the teams, yeah this should probably be a bitmask
	for team in teams:
		if(team == Team.PLAYER):
			teams.append_array([Team.PLAYER_RED,Team.PLAYER_GREEN,Team.PLAYER_YELLOW,Team.PLAYER_BLUE])
		elif(team == Team.ENEMY):
			teams.append_array([Team.ENEMY_STANDARD,Team.ENEMY_BOSS])
		elif(team == Team.ANY):
			teams.append_array([Team.NEUTRAL,Team.PLAYER,Team.ENEMY]) # These should be expanded after this

	var viable: Array[CharacterBody2D]

	for entity in entities:
		if(teams.has(entity.team)):
			if(distance == -1 or from.global_position.distance_to(entity.global_position) < distance):
				if filter.is_null() or filter.call(entity):
					viable.append(entity)

	return viable

func get_current_scene_node():
	return get_tree().current_scene
