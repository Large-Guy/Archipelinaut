extends Line2D

@export var growth_direction: Vector2
@export var growth_direction_variation: float
@export var growth_rotation: float = 0
@export var length: float = 400
@export var length_variation: float = 100
@export var segments: int = 32
@export var gravity: Vector2

@export_group("Leaves")
@export var leaf_count: int = 0
@export var leaf_count_variation: int = 0
@export var leaf: PackedScene

@export_group("Physics")
@export var stiffness: float = 1.2

var velocity: Vector2
var restore_velocity: Vector2

var leaves: Array[Line2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	growth_direction = growth_direction.rotated(deg_to_rad(growth_rotation) + deg_to_rad(randf_range(-growth_direction_variation,growth_direction_variation)))
	length += randf_range(-length_variation,length_variation)
	leaf_count += randf_range(-leaf_count_variation,leaf_count_variation)
	
	_generate()
	
	if leaf != null and leaf_count > 0:
		var spawn_point = points[-1]
		
		for c in range(leaf_count):
			var l = leaf.instantiate()
			var perc = float(c)/float(leaf_count)
			l.growth_rotation = perc * 360
			add_child(l)
			l.global_position = spawn_point + global_position
			leaves.append(l)
			
func _generate():
	clear_points()
	
	for i in range(segments):
		var perc = float(i)/float(segments)
		
		var l = length * perc
		
		var point: Vector2 = growth_direction * l + gravity * (perc * perc)
		
		var heightFactor = -point.y / (length/2)
		
		var bendFactor = pow(heightFactor, 1.5)
		
		if is_nan(bendFactor):
			bendFactor = 0
		
		add_point(point + (velocity * bendFactor))
		
	for leaf in leaves:
		leaf.position = points[-1]
	
func _apply_random_force(amplitude: float):
	var force: Vector2 = Vector2(randf_range(-amplitude,amplitude),randf_range(-amplitude,amplitude))
	_apply_force(force)
	for c in get_children():
		if c is Line2D and "_apply_force" in c:
			c._apply_force(force)
			#c._apply_random_force(amplitude)
	
func _apply_force(force: Vector2):
	restore_velocity += force
	for c in get_children():
		if "_apply_force" in c:
			c._apply_force(force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity += restore_velocity * 0.6
	velocity *= 0.9
	restore_velocity += velocity.direction_to(Vector2.ZERO) * (pow(velocity.distance_to(Vector2.ZERO),stiffness) * delta)
	_generate()
