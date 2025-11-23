extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	if _body.has_method("take_world_damage"):
		_body.take_world_damage()
	print("Took damage")
	print("You fell!")
