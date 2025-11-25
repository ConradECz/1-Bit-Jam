extends Area2D

@onready var timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	if _body.has_method("take_enemy_damage"):
		_body.take_enemy_damage()
	print("Took damage")
	
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
