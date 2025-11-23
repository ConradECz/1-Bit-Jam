extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400
const jump_gravity_multipler = 3.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var player_collision = $PlayerCollision
@export var attack_sound: AudioStream

var lives = 5
var is_dead = false
var start_position: Vector2

func _ready():
	start_position = Vector2(-206, 65)

func take_world_damage():
	lives -= 1
	print(lives)
	
	if(lives <= 0 and not is_dead):
		is_dead = true
		print ("Game Over!")
		AudioPlayer.play_sound("res://audio/sfx/jared_death1.wav")
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

func take_enemy_damage():
	lives -= 1
	print(lives)
	
	if(lives <= 0 and not is_dead):
		is_dead = true
		print ("Game Over!")
		AudioPlayer.play_sound("res://audio/sfx/jared_death1.wav")
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
	
	if(lives <= 0 and not is_dead):
		is_dead = true
		print ("Game Over!")
		AudioPlayer.play_sound("res://audio/sfx/jared_death1.wav")
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
	get_tree().reload_current_scene()
		
func play_attack_sound():
	AudioPlayer.play_stream(attack_sound)

func jump():
	velocity.y = JUMP_VELOCITY
	
func _physics_process(delta):
	
	# FOR THE MEANTIME UNTIL ATTACK IS FIXED
	if Input.is_action_just_pressed("attack"):
		if animated_sprite.get_animation() != "Attack" or not animated_sprite.is_playing():
			animated_sprite.play("Attack")
			#animated_sprite.animation_finished.connect(play_attack_sound, CONNECT_ONE_SHOT)
			play_attack_sound()
	
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
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
