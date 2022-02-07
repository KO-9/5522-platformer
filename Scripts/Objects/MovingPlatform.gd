extends Node2D

export var IDLE_DURATION = 1.0

export var move_to = Vector2.RIGHT * 192
export var speed = 3.0
export var disabled = false

var follow = Vector2.ZERO

onready var platform = $platform
onready var tween = $MoveTween

func _ready():
	set_physics_process(!disabled)
	if !disabled:
		_init_tween()
	
func _init_tween():
	var duration = move_to.length() / float(speed * 16)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + IDLE_DURATION * 2)
	tween.start()

func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
