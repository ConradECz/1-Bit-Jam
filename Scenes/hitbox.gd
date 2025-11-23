extends Area2D


@onready var player = $"."
@onready var collision_shape1 = $CollisionShape2D
@onready var collision_shape2 = $"../Killzone/CollisionShape2D"
@onready var animated_sprite = $".."
@export var penguin_death: AudioStream

func _on_body_entered(_body: Node2D) -> void:
	
	var y_delta = position.y - _body.position.y
	
	print(y_delta)
	
	if (y_delta > -60):
		
		print("Destroyed Enemy!")
		AudioPlayer.play_stream(penguin_death)
		
		if collision_shape1 and collision_shape2:
			collision_shape1.set_deferred("disabled", true)
			collision_shape2.set_deferred("disabled", true)
			
		animated_sprite.play("Peng_death")
		
		_body.jump()
		await animated_sprite.animation_finished
		get_parent().queue_free()
		
