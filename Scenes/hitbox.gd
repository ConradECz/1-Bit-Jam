extends Area2D

var is_dead = false

func _on_body_entered(_body: Node2D) -> void:
	
	if is_dead:
		return
		
	var y_delta = position.y - _body.position.y
	print(y_delta)
	if (y_delta > -60):
		print("Destroyed Enemy!")
		get_parent().queue_free()
		_body.jump()
	else:
		print("Player take damage")
		_body.queue_free()
