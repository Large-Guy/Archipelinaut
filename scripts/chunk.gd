extends Node2D

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
func _process(delta: float) -> void:
	var rect = Rect2(global_position,Vector2(size,size) * tile_size)
	
	if rect.has_point(Globals.player.global_position):
		Globals.current_chunk = self
	
	if rect.has_point(get_global_mouse_position()):
		Globals.mouse_hover_chunk = self
