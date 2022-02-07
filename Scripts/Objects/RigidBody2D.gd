extends RigidBody2D

var velocity = Vector2.ZERO

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	velocity.y +=  Global.GRAVITY
	position += velocity * delta


func _on_RigidBody2D_body_entered(body):
	if body.name == "player" && !is_physics_processing():
		print("player entered")
		set_physics_process(true)
		get_parent().get_node("StaticBody2D/CollisionShape2D").set_disabled(true)
