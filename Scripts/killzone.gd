extends Area2D

@onready var timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	if _body.has_method("decrease_health"):
		_body.decrease_health()
	print("Took damage")
	
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
