extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


const TOTAL_DAMAGE_FRAMES = 5 
var current_damage_frame: int = 0
var is_damaged: bool = false
var max_health: int = 5 
var current_health: int = max_health
@export var next_level_scene: PackedScene
const JINGLE_MUSIC = "res://audio/music/Jared-Level-Clear.ogg"

func _ready():
	
	animated_sprite.play("Damaged")
	animated_sprite.frame = current_damage_frame
	
	
	if not is_in_group("enemy"):
		print("WARNING: Enemy Area2D is not in the 'enemy' group!")


func die_from_player(_player_node):
	if is_damaged:
		return 

	current_health -= 1

	if current_health <= 0:
		AudioPlayer.stop_all_music(1.0) 
		_handle_level_clear()
	else:
		_advance_damage_frame()

func _advance_damage_frame():

	if current_damage_frame < TOTAL_DAMAGE_FRAMES - 1:
		current_damage_frame += 1
		animated_sprite.frame = current_damage_frame
		print(name, " advanced to frame: ", current_damage_frame)
	
	
	is_damaged = true
	var invulnerability_timer = get_tree().create_timer(0.2) 
	invulnerability_timer.timeout.connect(_on_invulnerability_timeout)

func _on_invulnerability_timeout():
	is_damaged = false

func _destroy_enemy():

	print(name, " has been destroyed!")
	AudioPlayer.play_sound(JINGLE_MUSIC)
	queue_free() 
	
func _handle_level_clear():
	print(name, " has been destroyed! Starting next level.")
	
	AudioPlayer.stop_all_music(0.2) 


	set_process(false)
	set_physics_process(false)
	monitoring = false
	visible = false
	

	if JINGLE_MUSIC:

		var jingle_player = AudioPlayer.play_sound(JINGLE_MUSIC) 
		

		var jingle_stream = jingle_player.stream 
		var jingle_duration = 0.0
		
		if jingle_stream:
			jingle_duration = jingle_stream.get_length()
		
		if jingle_duration > 0:
			print("Waiting for jingle to finish (", jingle_duration, " seconds)...")
			

			await get_tree().create_timer(jingle_duration + 0.1).timeout 
			
		else:
			print("Jingle duration unknown or zero. Waiting for 2.0 seconds as a safeguard.")
			await get_tree().create_timer(2.0).timeout
	else:
		print("ERROR: JINGLE_MUSIC path is missing. Changing scene immediately after 1 second.")
		await get_tree().create_timer(1.0).timeout
	

	_change_scene()



func _change_scene():
	if next_level_scene:
		get_tree().change_scene_to_packed(next_level_scene)
	else:
		print("ERROR: Cannot change scene. No 'next_level_scene' is set on the enemy!")


	queue_free()

	
func next_level():
	AudioPlayer.stop_all_music(0.5)
	if next_level_scene:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_packed(next_level_scene)
		queue_free()
	else:
		queue_free()
	
