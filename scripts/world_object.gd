extends Resource

class_name WorldObject

@export var object_name: String
@export_range(0,1) var spawn_frequency: float
@export_range(0,1) var spawn_altitude_min: float
@export_range(0,1) var spawn_altitude_max: float
@export var object: PackedScene
@export var randomize_rotation: bool = false
