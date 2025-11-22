extends Area2D

@onready var timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	if _body.has_method("take_damage"):
		var damage_amount = _body.DAMAGE_AMOUNT
		_body.take_damage(damage_amount)
	print("Took damage")
	
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
