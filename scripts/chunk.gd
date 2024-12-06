extends Node2D
class_name Chunk

@export var size: int = 16
@export var tile_size: float = 64
@export var ground: StaticBody2D
@export var walls: StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ground.size = size
	ground.tile_size = tile_size
	walls.size = size
	walls.tile_size = tile_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var rect = Rect2(global_position,Vector2(size,size) * tile_size)
