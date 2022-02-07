extends Node2D



func _on_Area2D_body_entered(body):
	print("entered_cp")
	$checkpoint_sfx.play()


func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	print("entered_cp")


func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	print("entered_asdcp")
