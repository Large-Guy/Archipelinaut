extends Node2D

var character_controller: CharacterBody2D
@export var follow_distance: float

var target_player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_controller = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(target_player == null):
		target_player = Globals.get_entities_on_team(character_controller,[Globals.Team.PLAYER]).pick_random()
		return
	
	if(global_position.distance_to(target_player.global_position) > follow_distance):
		character_controller.move(global_position.direction_to(target_player.global_position))
