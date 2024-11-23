extends Line2D

@export var spawn_point: Vector2
@export var growth_direction: Vector2
@export var growth_direction_variation: float
@export var length: float = 400
@export var length_variation: float = 100
@export var segments: int = 32
@export var gravity: Vector2

@export_group("Leaves")
@export var leaf_count: int = 0
@export var leaf_count_variation: int = 0
@export var leaves: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	clear_points()
	
	growth_direction = growth_direction.rotated(deg_to_rad(randf_range(-growth_direction_variation,growth_direction_variation)))
	length += randf_range(-length_variation,length_variation)
	leaf_count += randf_range(-leaf_count_variation,leaf_count_variation)
	
	for i in range(segments):
		var perc = float(i)/float(segments)
		
		var l = length * perc
		
		add_point(spawn_point + growth_direction * l + gravity * (perc * perc))
	
	if leaves != null and leaf_count > 0:
		var spawn_point = points[-1]
		
		for c in range(leaf_count):
			var leaf = leaves.instantiate()
			add_child(leaf)
			leaf.global_position = global_position
			leaf.spawn_point = spawn_point


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
