extends CharacterBody2D

@export_group("Configuration")

@export var team: Globals.Team
@export var soft_collision: bool = false

@export_group("Movement")

@export var is_static: bool = false
@export var speed: float
@export var acceleration: float

@export_group("Animation")

@export var animator: AnimationPlayer
@export var animation_walk_speed_scale: float
@export var animation_idle_speed_scale: float

@export_group("Stats")

@export var health: int
@export var defence: int

@export var on_damage_on_death: bool = true

signal on_damage
signal on_damage_no_args

signal on_death
signal on_death_no_args

var _move_input: Vector2 = Vector2.ZERO

var force: Vector2

var target: CharacterBody2D = null

var last_move_dir: Vector2

var footstep_pos: Vector2

signal footstep

func move(m: Vector2):
	_move_input = m.normalized()
	last_move_dir = m.normalized()

func add_force(f: Vector2):
	force += f

func damage(from: CharacterBody2D, amount: int):
	if(health <= 0):
		return
	
	if amount > 1:
		amount -= defence
		if amount <= 0:
			amount = 1
	
	health -= amount
	
	if(health > 0 or on_damage_on_death):
		on_damage.emit(from,amount)
		on_damage_no_args.emit()
	elif (health <= 0):
		on_death.emit(from, amount)
		on_death_no_args.emit()

func _ready() -> void:
	Globals.entities.append(self)
	footstep_pos = global_position

func _physics_process(delta: float) -> void:
	if footstep_pos.distance_to(global_position) > 196:
		footstep_pos = global_position
		footstep.emit()
	
	velocity = velocity.lerp(_move_input.normalized() * speed, acceleration * delta)
	
	if(animator != null):
		if(velocity.length() > speed / 2):
			animator.play("walk")
			animator.speed_scale = (velocity.length() / speed) * animation_walk_speed_scale
		else:
			animator.play("idle")
			animator.speed_scale = lerp(animator.speed_scale,animation_idle_speed_scale,10*delta)
	
	_move_input = Vector2.ZERO
	
	for entity in Globals.entities:
		if entity != self and entity != null:
			
			var has_collider: bool = false
			for child in entity.get_children():
				if child is CollisionShape2D:
					has_collider = true
			
			if entity.soft_collision:
				has_collider = true
			
			if has_collider and entity.global_position.distance_to(global_position) < 64:
				add_force(global_position.direction_to(entity.global_position) * -90)
	
	velocity += force
	
	force = Vector2.ZERO
	
	if is_static:
		velocity = Vector2.ZERO
	else:
		move_and_slide()

func destroy_self(time: float):
	await get_tree().create_timer(time).timeout
	queue_free()

func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	
	if mouse.distance_to(global_position) < 64 and Input.is_action_just_pressed("hit"):
		damage(null,1)
	
	if has_node("Sprite"):
		var sprite = get_node("Sprite")
		if last_move_dir.x < 0:
			sprite.scale.x = lerp(sprite.scale.x,-1.0,10 * delta)
		elif last_move_dir.x > 0:
			sprite.scale.x = lerp(sprite.scale.x,1.0,10 * delta)
