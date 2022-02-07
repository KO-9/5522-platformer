extends Area2D



func _on_DinoPickup_body_entered(body):
	if body.name == "player" && !$pickup.is_playing():
		Global.TopRightHUD.incScore(1)
		$pickup.play()
		#queue_free()
	


func _on_pickup_finished():
	queue_free()
