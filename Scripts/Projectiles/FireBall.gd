extends KinematicBody2D

var THROW_VELOCITY = Vector2(350, -200)

var velocity = Vector2.ZERO
const MAX_BOUNCE = 3
var bounce_count = 0
const DAMAGE = 1

func _ready():
	add_collision_exception_with(Global.player)
	set_physics_process(false)

func _physics_process(delta):
	velocity.y += Global.GRAVITY
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		_on_impact(collision.normal)
		print(collision.collider.name)
		if collision.collider.is_in_group("Enemy"):
			collision.collider.takeDamage(DAMAGE)
			queue_free()
	if velocity.y == Vector2.ZERO.y && velocity.x == Vector2.ZERO.x:
		get_parent().remove_child(self)

func launch(direction):
	if !direction:
		direction = 1
	else:
		direction = -1
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	THROW_VELOCITY.x *= direction
	velocity = THROW_VELOCITY
	set_physics_process(true)

func _on_impact(normal : Vector2):
	bounce_count += 1
	if bounce_count >= MAX_BOUNCE:
		velocity = Vector2.ZERO
	velocity = velocity.bounce(normal)
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y = lerp(velocity.y, 0, 0.2)
	#if velocity.x < 0.001:
	#	velocity.x = 0
	#if velocity.y < 0.001:
	#	velocity.y =0
