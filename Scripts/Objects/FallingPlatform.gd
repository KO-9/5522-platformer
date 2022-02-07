extends Node2D

export var IDLE_DURATION = 1.0

export var move_to = Vector2.RIGHT * 192
export var speed = 3.0

var velocity = Vector2()
var is_triggered = false

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	velocity.y +=  Global.GRAVITY
	position += velocity * delta

onready var animation_player = $AnimationPlayer

func collide_with(collision : KinematicCollision2D, collider : KinematicBody2D):
	if !is_triggered:
		is_triggered = true
		animation_player.play("shake")
		velocity = Vector2.ZERO

func _on_AnimationPlayer_animation_finished(anim_name):
	set_physics_process(true)
