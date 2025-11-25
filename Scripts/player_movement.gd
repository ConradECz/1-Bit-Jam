extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -400
const jump_gravity_multipler = 3.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player_damage = $PlayerDamageZone
@onready var animated_sprite = $AnimatedSprite2D
@onready var player_collision = $PlayerCollision
@export var attack_sound: AudioStream
@export var penguin_death: AudioStream
@export var hearts: Array[Node]
@export var ATTACK_OFFSET_PIXELS: float = 16.0


const TARGET_SCENE_PATH = "res://Scenes/Level4.tscn"
const LEVEL4_MUSIC_PATH = "res://audio/music/jablue.ogg"
const DEFAULT_MUSIC_PATH = "res://audio/music/Jared-Level-Theme.ogg"

var lives = 3
var is_dead = false
var start_position: Vector2
var levelmusic
var isplaying
func hearts_ui():
	for h in range(len(hearts)):
		if (h < lives):
			hearts[h].show()
		else:
			hearts[h].hide()

func _ready():
	levelmusic = AudioPlayer.play_music(DEFAULT_MUSIC_PATH)
	start_position = Vector2(-364, 275)
	await get_tree().process_frame
	
	var current_scene_path = get_tree().current_scene.scene_file_path
	var music_to_play
	
	if current_scene_path == TARGET_SCENE_PATH:
		print("Playing special Level 4 music.")
		music_to_play = LEVEL4_MUSIC_PATH
	else:
		print("Playing default level music.")
		music_to_play = DEFAULT_MUSIC_PATH
		
	# Start the determined music stream
	levelmusic = AudioPlayer.play_music(music_to_play)
	isplaying = 1

func take_world_damage():
	lives -= 3
	print(lives)
	
	hearts_ui()
	
	if(lives <= 0 and not is_dead):
		is_dead = true
		print ("Game Over!")
		animated_sprite.play("Death")
		AudioPlayer.play_sound("res://audio/sfx/jared_death1.wav")
		AudioPlayer.stop_audio(levelmusic, 0.1)
		#AudioServer.set_bus_mute(1, true)
		if player_collision:
			player_collision.set_deferred("disabled", true)
		animated_sprite.animation_finished.connect(_on_death_animation_finished, CONNECT_ONE_SHOT)
		set_physics_process(false)
	else:
		reset_to_start()
		# Animation for taking damage
		# Timer for reset
		AudioPlayer.play_sound("res://audio/sfx/jared_playerdamage1.wav")

func take_enemy_damage():
	lives -= 1
	print(lives)
	
	hearts_ui()
	
	if(lives <= 0 and not is_dead):
		is_dead = true
		print ("Game Over!")
		AudioPlayer.play_sound("res://audio/sfx/jared_death1.wav")
<<<<<<< HEAD
		#AudioPlayer.stop_audio(levelmusic, 0.1)
		AudioServer.set_bus_mute(1, true)
=======
		AudioPlayer.stop_audio(levelmusic, 0.1)
		#AudioServer.set_bus_mute(1, 1)
>>>>>>> c3ff5aa5fa8d374425cda43272f1f456b7780f0b
		print ("muted")
		animated_sprite.play("Death")
		if player_collision:
			player_collision.set_deferred("disabled", true)
		animated_sprite.animation_finished.connect(_on_death_animation_finished, CONNECT_ONE_SHOT)
		set_physics_process(false)
	else:
		# Animation for taking damage
		# Timer for reset
		AudioPlayer.play_sound("res://audio/sfx/jared_playerdamage1.wav")



func decrease_health():
	lives -= 1
	print(lives)
	
	hearts_ui()

	
	if(lives <= 0 and not is_dead):
		is_dead = true
		print ("Game Over!")
		AudioPlayer.play_sound("res://audio/sfx/jared_death1.wav")
		AudioServer.set_bus_mute(1, true)
		animated_sprite.play("Death")
		if player_collision:
			player_collision.set_deferred("disabled", true)
		animated_sprite.animation_finished.connect(_on_death_animation_finished, CONNECT_ONE_SHOT)
		set_physics_process(false)
	else:
		reset_to_start()
		# Animation for taking damage
		# Timer for reset
		AudioPlayer.play_sound("res://audio/sfx/jared_playerdamage1.wav")
		
func reset_to_start():
	global_position = start_position
	velocity = Vector2.ZERO
	
		
		
func _on_death_animation_finished():
	await get_tree().process_frame
	var isplaying
	get_tree().reload_current_scene()
<<<<<<< HEAD
	AudioServer.set_bus_mute(0, false)
	
	levelmusic = AudioPlayer.play_music(DEFAULT_MUSIC_PATH)
	isplaying = 1
	
=======
	#AudioServer.set_bus_mute(1, 0)
>>>>>>> c3ff5aa5fa8d374425cda43272f1f456b7780f0b
		
func play_attack_sound():
	AudioPlayer.play_stream(attack_sound)

func jump():
	velocity.y = JUMP_VELOCITY
	
func _physics_process(delta):
	
	# FOR THE MEANTIME UNTIL ATTACK IS FIXED
	if Input.is_action_just_pressed("attack"):
		if animated_sprite.get_animation() != "Attack" or not animated_sprite.is_playing():
			animated_sprite.play("Attack")
			AudioPlayer.play_stream(attack_sound)
			check_for_hits()
	
	if not is_on_floor():
		if !Input.is_action_pressed("jump") and velocity.y < 0:
			velocity.y += gravity * delta * jump_gravity_multipler
		else:
			velocity.y += gravity * delta
		
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		AudioPlayer.play_sound("res://audio/sfx/jared_jump1.wav")

	# Direction: -1, 0, 1	
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Player
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Animations for Player
	if not animated_sprite.get_animation() == "Attack" or animated_sprite.is_playing() == false: #FOR THE MEANTIME UNTIL ATTACK IS FIXED
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("Run")
		else:
			animated_sprite.play("Jump")
			
	var target_offset_x = 0.0
	if animated_sprite.get_animation() == "Attack":
		if animated_sprite.flip_h:
			target_offset_x = -ATTACK_OFFSET_PIXELS
		else:
			target_offset_x = ATTACK_OFFSET_PIXELS
	
	animated_sprite.offset.x = target_offset_x		
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func check_for_hits():
	var overlapping_areas = player_damage.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("enemy"):
			print("HIT!")			
			if is_instance_valid(area) and area.has_method("die_from_player"):
				area.die_from_player(self)
