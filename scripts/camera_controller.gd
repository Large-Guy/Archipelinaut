extends Camera2D

@export var lerp_speed: float = 10

var target_override = null

func override_target(target):
	target_override = target

func _process(delta):
	var target_position = Globals.player.global_position
	if target_override != null:
		target_position = target_override.position
		target_override = null
	global_position = global_position.lerp(target_position,lerp_speed * delta)
