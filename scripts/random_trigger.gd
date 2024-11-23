extends Node2D

@export var frequency: float

signal trigger

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if randf() < frequency * delta:
		trigger.emit()
