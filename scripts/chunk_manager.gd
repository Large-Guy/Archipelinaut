extends Node2D

@export var chunk_size: int = 32
@export var chunk_scale: float = 64
@export var chunk: PackedScene

var loaded_chunks = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var chunks_around_player: Array[Vector2i]
	
	for y in range(-3,3):
		for x in range(-3,3):
			var pos = Vector2i(x,y) + Vector2i(Globals.player.global_position / (chunk_scale * chunk_size))
			chunks_around_player.append(pos)
	
	for chunk_ap in chunks_around_player:
		if(!loaded_chunks.has(chunk_ap)):
			var c = chunk.instantiate()
			add_child(c)
			c.global_position = Vector2(chunk_ap) * (chunk_scale * chunk_size)
			loaded_chunks[chunk_ap] = c
	
	for chunk_l in loaded_chunks:
		if(!chunks_around_player.has(chunk_l)):
			loaded_chunks[chunk_l].queue_free()
			loaded_chunks.erase(chunk_l)
