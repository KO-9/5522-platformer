extends Node2D

var first_play = true
export(int) var bounce_force
export(int) var max_bounce
var player_jump_velocity = 201.871933


func _ready():
	if max_bounce == 0:
		max_bounce = bounce_force - 400

func be_bounced_upon(bouncer):
	if bouncer.has_method("bounce"):
		var new_bounce_force = bounce_force
		print(bounce_force)
		var motion = bouncer.getMotion()
		if motion.y > 0:#Add their downward velocity to our bounce
			new_bounce_force += (motion.y * -1)
			if new_bounce_force < max_bounce:
				new_bounce_force = max_bounce
		$AnimatedSprite.play("bounce")
		bouncer.bounce(new_bounce_force)
		$boing.play()


func _on_AnimatedSprite_animation_finished():
	if first_play:
		first_play = false
		$AnimatedSprite.play("bounce", true)
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(1)
