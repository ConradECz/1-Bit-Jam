extends Area2D

@onready var enemy_hitbox = $"../Killzone"
@onready var player = $"."
@onready var collision_shape1 = $CollisionShape2D
@onready var collision_shape2 = $"../Killzone/CollisionShape2D"
@onready var animated_sprite = $".."
@export var penguin_death: AudioStream
@export var attack_sound: AudioStream
@export var enemy_hit: AudioStream

var health: int = 10

func _on_body_entered(_body: Node2D) -> void:
	
	var y_delta = position.y - _body.position.y
	
	print(y_delta)
	
	if (y_delta < -200):
		
		print("Destroyed Enemy!")
		AudioPlayer.play_stream(penguin_death)
		
		if collision_shape1 and collision_shape2:
			collision_shape1.set_deferred("disabled", true)
			collision_shape2.set_deferred("disabled", true)
			
		animated_sprite.play("Death")
		
		_body.jump()
		await animated_sprite.animation_finished
		get_parent().queue_free()

func die_from_player(_body: Node2D) -> void:
	if health > 0:
		health -= 1
		print("Enemy Hit! Health remaining: ", + health)
		AudioPlayer.play_stream(enemy_hit)
	if health <= 0:	
		print("Enemy killed by sword!")
		AudioPlayer.play_stream(enemy_hit)
		AudioPlayer.play_stream(penguin_death)


		if collision_shape1 and collision_shape2:
				collision_shape1.set_deferred("disabled", true)
				collision_shape2.set_deferred("disabled", true)
	
		animated_sprite.play("Death")
		await animated_sprite.animation_finished

		get_parent().queue_free()
