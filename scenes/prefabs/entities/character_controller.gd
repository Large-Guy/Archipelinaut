extends CharacterBody2D

@export var speed: float
@export var acceleration: float
@export var animator: AnimationPlayer
@export var animation_walk_speed_scale: float
@export var animation_idle_speed_scale: float

var _move_input: Vector2 = Vector2.ZERO

func move(m: Vector2):
	_move_input = m


func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(_move_input.normalized() * speed, acceleration * delta)
	
	if(animator != null):
		if(velocity.length() > speed / 2):
			animator.play("walk")
			animator.speed_scale = (velocity.length() / speed) * animation_walk_speed_scale
		else:
			animator.play("idle")
			animator.speed_scale = lerp(animator.speed_scale,animation_idle_speed_scale,10*delta)
	
	_move_input = Vector2.ZERO
	
	move_and_slide()
