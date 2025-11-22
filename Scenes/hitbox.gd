extends Area2D


@onready var collision_shape1 = $CollisionShape2D
@onready var collision_shape2 = $"../Killzone/CollisionShape2D"
@onready var animated_sprite = $".."
@onready var player_collision = $PlayerCollision
@onready var player_sprite = $AnimatedSprite2D

var is_dead = false

func _on_body_entered(_body: Node2D) -> void:
	
	if is_dead:
		return
	
	var y_delta = position.y - _body.position.y
	
	print(y_delta)
	
	if (y_delta > -60):
		
		print("Destroyed Enemy!")
		
		is_dead = true
		
		if collision_shape1 and collision_shape2:
			collision_shape1.set_deferred("disabled", true)
			collision_shape2.set_deferred("disabled", true)
			
		animated_sprite.play("Peng_death")
		
		_body.jump()
		await animated_sprite.animation_finished
		get_parent().queue_free()
		
	else:
		print("Player take damage")
		_body.queue_free()
