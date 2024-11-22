extends Node2D
var character_controller: CharacterBody2D

func _ready() -> void:
	character_controller = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move = Input.get_vector("move_left","move_right","move_up","move_down")
	character_controller.move(move)
