extends Camera2D

@export_range(0,1) var mouse_influence: float = 0.1
@export var lerp_speed: float = 10

var target_override = null

func override_target(target):
	target_override = target

func _process(delta):
	var target_position = Globals.player.global_position
	if target_override != null:
		target_position = target_override.position
		target_override = null

	var mouse_local = get_local_mouse_position()
	global_position = global_position.lerp(target_position + mouse_local * mouse_influence,lerp_speed * delta)
