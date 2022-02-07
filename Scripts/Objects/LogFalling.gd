extends Node2D

func _on_RigidBody2D_body_entered(body):
	print(body.name)
	if body.name == "player":
		print("here")
		$RigidBody2D/AnimationPlayer.play("falldelay")

func _on_AnimationPlayer_animation_finished(anim_name):
	print("here")
	$RigidBody2D.set_physics_process(true)
	$StaticBody2D/CollisionShape2D.set_disabled(true)
