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

@export_group("Fruit")
@export var fruit_count: int = 0
@export var fruit_count_variation: int = 0
@export var fruit: PackedScene
@export var fruit_item: Item

@export_group("Physics")
@export var stiffness: float = 1.2

var velocity: Vector2
var restore_velocity: Vector2

var leaves: Array[Line2D]

var fruits: Array
var fruit_positons: Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	growth_direction = growth_direction.rotated(deg_to_rad(growth_rotation) + deg_to_rad(randf_range(-growth_direction_variation,growth_direction_variation)))
	length += randf_range(-length_variation,length_variation)
	leaf_count += randf_range(-leaf_count_variation,leaf_count_variation)
	fruit_count += randf_range(-fruit_count_variation,fruit_count_variation)
	
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
	
	if fruit != null and fruit_count > 0:
		var spawn_point = points[-1]
		
		for c in range(fruit_count):
			var f = fruit.instantiate()
			var perc = float(c)/float(fruit_count)
			var offset: Vector2 = Vector2.UP.rotated(perc * TAU) * randf_range(16,48)
			f.global_position = spawn_point + offset
			add_child(f)
			fruits.append(f)
			fruit_positons.append(offset)

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
	
	for f in fruits.size():
		if fruits[f] != null:
			fruits[f].position = fruit_positons[f] + points[-1]
	
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

func _drop_fruit():
	if fruits.size() <= 0: return
	
	var f: int = randi_range(0, fruits.size() - 1)
	
	var fo = fruits[f]
	
	var gp = fo.global_position
	
	remove_child(fo)
	
	fo.global_position = gp
	
	get_tree().current_scene.add_child(fo)
	
	fruits.remove_at(f)
	fruit_positons.remove_at(f)
	
	var v: Vector2 = Vector2(randf_range(-300,300),-500)
	
	while to_local(fo.global_position).y < 0:
		fo.global_position += v * get_physics_process_delta_time()
		
		v.y += 980 * get_physics_process_delta_time()
		
		await get_tree().physics_frame
	
	Item.spawn(fruit_item, fo.global_position)
	fo.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity += restore_velocity * 0.6
	velocity *= 0.9
	restore_velocity += velocity.direction_to(Vector2.ZERO) * (pow(velocity.distance_to(Vector2.ZERO),stiffness) * delta)
	_generate()
