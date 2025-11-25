extends Area2D

@onready var enemy_hitbox = $"../Killzone"
@onready var player = $"."
@onready var collision_shape1 = $CollisionShape2D
@onready var collision_shape2 = $"../Killzone/CollisionShape2D"
@onready var animated_sprite = $".."
@export var penguin_death: AudioStream
@export var attack_sound: AudioStream
@export var enemy_hit: AudioStream
@onready var game_timer = $"../../Timer"

var health: int = 10
var is_dead = false
const TARGET_SCENE_PATH = "res://Scenes/Level4.tscn"

@export var teleport_positions: Array[Vector2] = [
	Vector2(-148, 214),
	Vector2(-18, 262),
	Vector2(-262, 142),
	Vector2(-487, 142),
	Vector2(-599, 214),
	Vector2(-707, 262) 
]

func _process(_delta):
	if is_instance_valid(game_timer) and game_timer.is_stopped() == false:
		var time_remaining = game_timer.time_left
		print("Time Remaining: ", "%1.0f" % time_remaining)

func _ready():
	await get_tree().process_frame
	
	var current_scene_path = get_tree().current_scene.scene_file_path
	
	if current_scene_path == TARGET_SCENE_PATH:
		print("Boss BATTLE! ACTIVATING TIMER!!")
		
		if game_timer:
			game_timer.timeout.connect(_on_game_timer_timeout)
	else:
		if game_timer and game_timer.is_autostart():
			game_timer.stop() 
		print("TIMER ERROR.")	
		
func _on_game_timer_timeout():
	print("TIME'S UP, LEVEL RESET")
	
	get_tree().reload_current_scene()

func _on_body_entered(_body: Node2D) -> void:
	
	var y_delta = position.y - _body.position.y
	
	print(y_delta)
	
	if (y_delta < -100):
		print("STOMPED ON BOSS!")
		die_from_player(_body)
		
		if not is_dead:
			if is_instance_valid(_body) and _body.has_method("jump"):
				_body.jump()

func die_from_player(_body: Node2D) -> void:
	if health > 0:
		health -= 1
		print("Enemy Hit! Health remaining: ", + health)
		AudioPlayer.play_stream(enemy_hit)
		
		if health > 0:
			teleport_to_random_location()
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

func teleport_to_random_location() -> void:
	if teleport_positions.size() > 0:
		var random_index = randi_range(0, teleport_positions.size() - 1)
		
		var new_position = teleport_positions[random_index]
		
		get_parent().global_position = new_position
		print("enemy teleoprted to: ", + new_position)
