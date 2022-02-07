extends Area2D

func _on_checkpoint_body_entered(body):
	if body.name == "player" && Global.checkpoint_coord != position:
		Global.checkpoint_coord = position
		Global.previous_world_score = Global.score
		$checkpoint_sfx.play()
